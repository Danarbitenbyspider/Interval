---
name: release-app
description: Use when the user wants to release the app, ship a new version, or build an Android bundle (AAB) for the Play Store.
---

# Release the app

Produces a signed Android App Bundle for a new version, recorded in git as a commit plus tag `vX.Y.Z+N` on `main`. iOS is out of scope.

The user is non-technical. Talk in plain words ("saving your changes", "new version 1.2.0"), never git or Gradle jargon. The only question you ask is the version confirmation in step 3; everything else you decide.

All mechanical work goes through `bash .claude/skills/release-app/scripts/release.sh <command>`. Each command exits non-zero with an `ERROR:` line when something is wrong.

## Steps

1. **Check readiness.** Run `status`. On `ERROR`, explain the problem in one plain sentence plus what the user must do, then stop. Signing-key errors always mean "ask the project owner for the signing key files"; never create or replace a key.

2. **Save pending work.** If `uncommitted_changes` lists files, read the diff and commit it on `main` with a plain message describing the change. Leave out build output and anything resembling a secret. Done when the working tree is clean.

3. **Propose the version.** The version in `pubspec.yaml` has always already been uploaded, so every release bumps. Read every commit and changed file since `last_release_tag` (when it is `none`, read only the most recent commits since the version last changed in `pubspec.yaml`), then pick the level:
   - **minor**: something the user can newly see or do (screen, setting, feature).
   - **patch**: everything else (fixes, tweaks, wording, internals).
   - **major**: only when the user asks for it.

   Ask once: "New version **X.Y.Z** — <one-sentence reason>. Go ahead?", with your choice as the recommended option and the other two levels as alternatives. The build number always increases by 1; never ask about it.

4. **Bump.** Run `bump <level>`.

5. **Build.** Run `build` (takes a few minutes). On failure, read the error:
   - Code or dependency error: fix it, commit the fix, run `build` again.
   - Signing error: explain as in step 1, run `abort`, stop.
   - Stuck after 3 attempts: run `abort`, tell the user the release did not happen and the project owner should look.

   Done when the output prints `bundle:` with a path. Warnings in a successful build are left alone.

6. **Record the release.** Write release notes to a file from `mktemp` (outside the repo): plain-language bullets of what is new for app users, in English and then Indonesian (the app's languages), each under 500 characters (the Play Console "What's new" limit). Run `finish <file>`.

7. **Report.** Tell the user, in this order:
   - Version number and the full bundle path from step 5.
   - The release notes text, ready to paste.
   - Upload steps: Play Console → the app → Testing → Internal testing → Create new release → upload the bundle → paste the notes → Next → Save and publish.
   - If `finish` printed `WARNING` about the push: the release is saved on this computer but not on GitHub; tell the project owner.

## Rules

- Releases come only from `main`, version only from `pubspec.yaml` (Flutter derives the Android version from it).
- A version number that reached Play Console is used up forever. After any uploaded release, the next one gets a new version; reuse is how "Version code already used" rejections happen.
- The signing key (`android/key.properties` and the `.keystore`) stays out of git and out of chat output.
