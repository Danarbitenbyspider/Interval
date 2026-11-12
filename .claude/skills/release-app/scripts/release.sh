#!/usr/bin/env bash
# Mechanical steps of the release-app skill. Run from anywhere inside the repo.
#   bash release.sh status                 preflight checks + release facts
#   bash release.sh bump major|minor|patch rewrite pubspec.yaml version (build number +1)
#   bash release.sh build                  build + verify the Android App Bundle
#   bash release.sh finish <notes-file>    commit + tag the release, push (non-fatal)
#   bash release.sh abort                  undo an unfinished version bump
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
PUBSPEC="pubspec.yaml"
AAB="build/app/outputs/bundle/release/app-release.aab"
RELEASE_BRANCH="main"

fail() { echo "ERROR: $*" >&2; exit 1; }

current_version() {
  local v
  v="$(grep -E '^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+[[:space:]]*$' "$PUBSPEC" | head -1 | sed -E 's/^version:[[:space:]]*//; s/[[:space:]]*$//')"
  [ -n "$v" ] || fail "pubspec.yaml has no 'version: X.Y.Z+N' line"
  echo "$v"
}

last_tag() { git describe --tags --abbrev=0 --match 'v*' 2>/dev/null || true; }

preflight() {
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD)"
  [ "$branch" = "$RELEASE_BRANCH" ] || fail "on branch '$branch'; releases are made from '$RELEASE_BRANCH' only"
  command -v flutter >/dev/null || fail "flutter is not installed or not on PATH"
  [ -f android/key.properties ] || fail "android/key.properties missing: the upload signing key is not set up on this computer (ask the project owner for key.properties and the .keystore file)"
  local store
  store="$(grep -E '^storeFile=' android/key.properties | cut -d= -f2- || true)"
  [ -n "$store" ] || fail "android/key.properties has no storeFile entry"
  [ -f "android/$store" ] || [ -f "$store" ] || fail "keystore '$store' named in android/key.properties not found"
  if git ls-files --cached | grep -qiE '(^|/)key\.properties$|\.(keystore|jks)$'; then
    fail "signing secrets are tracked or staged in git; remove them from the index (git rm --cached) and rotate the key with the project owner"
  fi
}

cmd_status() {
  preflight
  local tag
  tag="$(last_tag)"
  echo "current_version: $(current_version)"
  echo "last_release_tag: ${tag:-none}"
  echo "uncommitted_changes:"
  git status --short | sed 's/^/  /'
  if [ -n "$tag" ]; then
    echo "commits_since_last_release:"
    git log --oneline "$tag..HEAD" | sed 's/^/  /'
    echo "files_changed_since_last_release:"
    git diff --stat "$tag..HEAD" | sed 's/^/  /'
  else
    echo "commits_since_last_release: (no release tag yet; full history)"
    git log --oneline | sed 's/^/  /'
  fi
}

cmd_bump() {
  local level="${1:-}"
  case "$level" in major|minor|patch) ;; *) fail "usage: bump major|minor|patch" ;; esac
  preflight
  [ -z "$(git status --porcelain)" ] || fail "working tree not clean; commit pending work before bumping"
  local cur name code ma mi pa new
  cur="$(current_version)"
  name="${cur%+*}"; code="${cur#*+}"
  IFS=. read -r ma mi pa <<<"$name"
  case "$level" in
    major) ma=$((ma + 1)); mi=0; pa=0 ;;
    minor) mi=$((mi + 1)); pa=0 ;;
    patch) pa=$((pa + 1)) ;;
  esac
  new="$ma.$mi.$pa+$((code + 1))"
  git rev-parse -q --verify "refs/tags/v$new" >/dev/null && fail "tag v$new already exists"
  NEW="$new" perl -pi -e 's/^version:\s*\S+\s*$/version: $ENV{NEW}\n/' "$PUBSPEC"
  [ "$(current_version)" = "$new" ] || fail "failed to write new version to pubspec.yaml"
  echo "bumped: $cur -> $new"
}

cmd_build() {
  preflight
  local ver marker out
  ver="$(current_version)"
  marker="$(mktemp)"
  flutter build appbundle --release || { rm -f "$marker"; fail "flutter build failed (see output above); version bump is kept, fix the error and run build again, or run abort"; }
  [ -f "$AAB" ] && [ -n "$(find "$AAB" -newer "$marker")" ] || { rm -f "$marker"; fail "no fresh bundle at $AAB"; }
  rm -f "$marker"
  # Flutter writes the version it built into android/local.properties.
  grep -q "^flutter.versionName=${ver%+*}$" android/local.properties && grep -q "^flutter.versionCode=${ver#*+}$" android/local.properties \
    || fail "built version does not match pubspec.yaml version $ver"
  out="$(keytool -printcert -jarfile "$AAB" 2>&1 || true)"
  echo "$out" | grep -q '^Owner:' || fail "bundle is not signed"
  echo "$out" | grep -qi 'Android Debug' && fail "bundle is signed with the DEBUG key; Play Console will reject it"
  mkdir -p releases
  cp "$AAB" "releases/intervals-v$ver.aab"
  echo "bundle: $ROOT/releases/intervals-v$ver.aab"
  echo "size: $(du -h "releases/intervals-v$ver.aab" | cut -f1)"
}

cmd_finish() {
  local notes="${1:-}"
  [ -f "$notes" ] || fail "usage: finish <notes-file> (file with the release commit message body)"
  preflight
  local ver changed
  ver="$(current_version)"
  [ -f "releases/intervals-v$ver.aab" ] || fail "no verified bundle for $ver; run build first"
  [ "releases/intervals-v$ver.aab" -nt "$PUBSPEC" ] && cmp -s "$AAB" "releases/intervals-v$ver.aab" \
    || fail "bundle for $ver is stale (older than pubspec.yaml or not the latest build); run build again"
  changed="$(git status --porcelain | awk '{print $2}' | grep -vE '^(pubspec\.yaml|pubspec\.lock)$' || true)"
  [ -z "$changed" ] || fail "unexpected uncommitted files besides pubspec: $changed"
  git add "$PUBSPEC"
  git add pubspec.lock 2>/dev/null || true
  { echo "Release v$ver"; echo; cat "$notes"; } | git commit -q -F -
  git tag -a "v$ver" -m "Release v$ver"
  echo "committed and tagged: v$ver"
  if git push -q origin "$RELEASE_BRANCH" --follow-tags 2>&1; then
    echo "pushed: origin/$RELEASE_BRANCH with tag v$ver"
  else
    echo "WARNING: push to GitHub failed; release is saved locally (commit + tag). Push later with: git push origin $RELEASE_BRANCH --follow-tags"
  fi
}

cmd_abort() {
  rm -f "releases/intervals-v$(current_version).aab"
  git checkout -- "$PUBSPEC"
  echo "restored pubspec.yaml version: $(current_version)"
}

case "${1:-}" in
  status) cmd_status ;;
  bump) cmd_bump "${2:-}" ;;
  build) cmd_build ;;
  finish) cmd_finish "${2:-}" ;;
  abort) cmd_abort ;;
  *) fail "usage: release.sh status|bump <level>|build|finish <notes-file>|abort" ;;
esac
