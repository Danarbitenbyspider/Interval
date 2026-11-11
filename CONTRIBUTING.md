# Contributing to Intervals Training

Terima kasih atas minat Anda untuk berkontribusi! 🎉

## Cara Berkontribusi

### 1. Fork & Clone

```bash
git clone https://github.com/your-username/intervals-training.git
cd intervals-training
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Buat Branch Baru

```bash
git checkout -b feature/nama-fitur
# atau
git checkout -b fix/nama-bug
```

### 4. Lakukan Perubahan

- Tulis kode yang bersih dan mudah dibaca
- Ikuti konvensi Dart/Flutter yang ada
- Tambahkan komentar untuk logika yang kompleks
- Pastikan null-safety

### 5. Testing

```bash
# Run tests
flutter test

# Check formatting
flutter format .

# Analyze code
flutter analyze
```

### 6. Commit Changes

```bash
git add .
git commit -m "feat: deskripsi fitur baru"
# atau
git commit -m "fix: deskripsi bug fix"
```

**Commit Message Convention**:
- `feat:` untuk fitur baru
- `fix:` untuk bug fix
- `docs:` untuk dokumentasi
- `style:` untuk formatting
- `refactor:` untuk refactoring
- `test:` untuk testing
- `chore:` untuk maintenance

### 7. Push & Pull Request

```bash
git push origin feature/nama-fitur
```

Kemudian buat Pull Request di GitHub dengan deskripsi yang jelas.

## Panduan Kode

### Struktur File

- Tempatkan models di `lib/core/models/`
- Tempatkan providers di `lib/core/providers/`
- Tempatkan UI di `lib/features/[feature_name]/`
- Widgets reusable di `lib/core/widgets/` atau `lib/features/[feature]/widgets/`

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `kConstantName` atau `SCREAMING_SNAKE_CASE`

### State Management

- Gunakan Riverpod untuk state management
- Provider untuk read-only data
- StateNotifier untuk mutable state
- ChangeNotifier untuk complex state dengan listeners

### Localization

Tambahkan string baru di kedua file:
- `assets/i18n/id.json`
- `assets/i18n/en.json`

### Testing

- Tulis unit tests untuk logic/engine
- Tulis widget tests untuk UI components
- Pastikan coverage minimal 70% untuk core logic

## Jenis Kontribusi yang Dibutuhkan

### High Priority
- [ ] Bug fixes
- [ ] Performance improvements
- [ ] Accessibility improvements
- [ ] Documentation improvements

### Medium Priority
- [ ] New workout modes
- [ ] UI/UX enhancements
- [ ] More localization (languages)

### Nice-to-Have
- [ ] Custom workout builder UI
- [ ] Advanced statistics/charts
- [ ] Cloud backup (optional)
- [ ] Wearable integration

## Pelaporan Bug

Gunakan [GitHub Issues](https://github.com/your-repo/issues) dengan template:

**Bug Description**:
Deskripsi singkat bug

**Steps to Reproduce**:
1. Buka app
2. Klik X
3. Error muncul

**Expected Behavior**:
Yang seharusnya terjadi

**Actual Behavior**:
Yang terjadi

**Screenshots**:
(jika ada)

**Environment**:
- Device: (contoh: Pixel 6, iPhone 13)
- OS: (contoh: Android 12, iOS 15)
- App Version: (contoh: 1.0.0)

## Feature Requests

Gunakan [GitHub Discussions](https://github.com/your-repo/discussions) untuk diskusi fitur baru.

## Code of Conduct

- Bersikap ramah dan profesional
- Hormati kontributor lain
- Fokus pada solusi, bukan masalah personal
- Bantu sesama kontributor

## Questions?

Jika ada pertanyaan, silakan buat diskusi di GitHub Discussions atau hubungi maintainer.

---

Terima kasih atas kontribusi Anda! 🙏
