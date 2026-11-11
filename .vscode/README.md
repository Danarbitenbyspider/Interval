# VS Code Configuration

Folder ini berisi konfigurasi VS Code untuk project Intervals Training.

## 📁 Files

- **`settings.json`** - Editor settings (format on save, dart settings)
- **`launch.json`** - Debug configurations (Run, Profile, Release)
- **`tasks.json`** - Custom tasks (pub get, clean, test, doctor)
- **`extensions.json`** - Recommended extensions

## 🚀 Quick Start

1. Install recommended extensions (VS Code akan popup notifikasi)
2. Tekan **F5** untuk run app
3. Pilih **Chrome** dari device selector
4. Done! App running di browser

## 🎯 Debug Configurations

Pilih dari Debug dropdown:

- **Flutter: Run** - Normal debug mode
- **Flutter: Run (Profile)** - Performance profiling
- **Flutter: Run (Release)** - Release mode (no debugging)
- **Flutter: Attach** - Attach ke running app

## ⚡ Tasks

Akses via `Ctrl+Shift+P` → `Tasks: Run Task`:

- **Flutter: Get Packages** - Install dependencies
- **Flutter: Run on Chrome** - Run di Chrome
- **Flutter: Clean** - Clean build cache
- **Flutter: Test** - Run all tests
- **Flutter: Doctor** - Check Flutter setup

## 🔧 Settings Explained

### Auto Format on Save
Code otomatis diformat saat save (`Ctrl+S`).

### Dart Line Length
Max 100 characters (vs default 80).

### Editor Rulers
Visual guide di column 80.

### Files Exclude
Hide `.dart_tool`, `.packages`, `build` dari explorer.

## 💡 Tips

### Hot Reload
- Save file (`Ctrl+S`) = Auto hot reload
- Atau tekan `r` di debug console

### Go to Definition
- `F12` - Go to definition
- `Ctrl+Click` - Quick peek

### Find Symbol
- `Ctrl+Shift+O` - Symbols in file
- `Ctrl+T` - Symbols in workspace

### Terminal
- `Ctrl+` ` - Toggle terminal
- Multiple terminals supported

---

**Happy coding! 🎉**
