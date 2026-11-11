# 🚀 Quick Setup dengan VS Code

Panduan super cepat untuk run aplikasi dengan VS Code.

## 📋 Step-by-Step (5 Menit)

### Step 1: Install Extensions

Di VS Code, tekan `Ctrl+Shift+X` untuk buka Extensions, lalu install:

1. **Flutter** (by Dart Code)
2. **Dart** (by Dart Code)

Atau search "Flutter" dan install yang official dari Dart Code.

### Step 2: Reload VS Code

Setelah install extensions, reload VS Code:
- Tekan `Ctrl+Shift+P`
- Ketik "Reload Window"
- Enter

### Step 3: Setup Flutter SDK

VS Code akan otomatis detect bahwa Flutter belum terinstall.

**Opsi A - VS Code Auto Download (Recommended):**
1. Buka Command Palette (`Ctrl+Shift+P`)
2. Ketik: `Flutter: New Project`
3. VS Code akan tanya lokasi Flutter SDK
4. Pilih **Download SDK**
5. Pilih folder (contoh: `C:\flutter`)
6. Tunggu download selesai (~5-10 menit)

**Opsi B - Manual (Jika sudah download):**
1. Download Flutter dari: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip
2. Extract ke `C:\flutter`
3. Di VS Code:
   - `Ctrl+Shift+P` → `Flutter: Change SDK`
   - Browse ke `C:\flutter`

### Step 4: Run Aplikasi

1. Buka folder project ini di VS Code (jika belum):
   - `File` → `Open Folder`
   - Pilih: `d:\Project Ongoing\Claude Project\Interval apps`

2. **Pilih Device:**
   - Klik status bar kanan bawah (tulisan "No Device")
   - Pilih **Chrome** (paling mudah untuk testing)
   - Atau pilih **Edge** jika Chrome tidak ada

3. **Run:**
   - Tekan **F5**
   - Atau klik **Run** → **Start Debugging**
   - Atau klik tombol ▶️ di kanan atas

4. **Done!** 🎉
   - Browser akan terbuka otomatis
   - App akan running di Chrome/Edge
   - Hot reload aktif (edit code langsung update)

## 🎯 Shortcut Penting

Saat app running:

- **`r`** - Hot reload (update perubahan tanpa restart)
- **`R`** - Hot restart (restart app)
- **`q`** - Quit app
- **`F5`** - Start debugging
- **`Shift+F5`** - Stop debugging

## 🔧 Troubleshooting

### "Unable to locate Android SDK"

**Solusi:** Abaikan saja! Tidak perlu Android SDK untuk run di Chrome.

### "No devices found"

**Solusi:**
1. Install Chrome/Edge browser
2. Restart VS Code
3. Device akan muncul otomatis

### "Waiting for connection from debug service"

**Solusi:**
1. Stop (Shift+F5)
2. Run `flutter clean` di terminal
3. Run ulang (F5)

### Error saat `flutter pub get`

**Solusi:**
```bash
flutter clean
flutter pub get
```

## 📱 Available Devices

VS Code akan show devices di status bar:

- **Chrome (web-javascript)** ✅ Recommended
- **Edge (web-javascript)** ✅ Alternative
- **Windows (desktop)** - Perlu Visual Studio
- **Android** - Perlu Android Studio
- **iOS** - Mac only

Untuk quick testing, gunakan **Chrome**!

## 🎨 VS Code Tips

### 1. Lihat Output/Debug Console

Tekan `Ctrl+` ` (backtick) untuk buka integrated terminal.

Tab yang berguna:
- **Debug Console** - Lihat print() output
- **Terminal** - Run flutter commands
- **Problems** - Lihat errors

### 2. Flutter Commands

`Ctrl+Shift+P` lalu ketik:
- `Flutter: Run Flutter Doctor` - Check setup
- `Flutter: Clean Project` - Clean build
- `Flutter: Get Packages` - Install dependencies
- `Flutter: Hot Reload` - Reload app

### 3. Navigate Code

- `Ctrl+P` - Quick open file
- `Ctrl+Shift+O` - Go to symbol
- `F12` - Go to definition
- `Alt+Left/Right` - Navigate back/forward

### 4. Format Code

- `Shift+Alt+F` - Format file
- Auto format on save (sudah diconfig di `.vscode/settings.json`)

## 🚀 First Run Checklist

Saat pertama kali run:

1. ✅ VS Code terbuka folder `Interval apps`
2. ✅ Extensions Flutter & Dart installed
3. ✅ Flutter SDK detected (lihat status bar)
4. ✅ Device selected (Chrome/Edge)
5. ✅ Tekan F5
6. ✅ Browser terbuka dengan app
7. ✅ Lihat 5 workout cards di home page

## 🎯 Expected Result

Setelah F5, Anda akan lihat:

**Browser terbuka dengan:**
- 📱 App "Intervals Training"
- 🏠 Home page dengan 5 workout cards:
  - Japanese Walking Interval
  - Tabata Basic
  - Mobility Interval
  - Core Interval Training
  - Breathing Intervals
- ⚙️ Settings icon (kanan atas)
- 📊 History icon (kanan atas)

**VS Code debug console:**
```
Launching lib/main.dart on Chrome in debug mode...
✓ Built build/web
```

## 🔥 Hot Reload Demo

1. App running di browser
2. Edit file (contoh: ubah warna di `lib/app.dart`)
3. Save (`Ctrl+S`)
4. Atau tekan `r` di terminal
5. Browser langsung update tanpa refresh!

## 📚 Next Steps

Setelah app running:

1. ✅ **Explore app** - Coba semua 5 workout modes
2. ✅ **Read docs** - [QUICKSTART.md](QUICKSTART.md) untuk panduan pakai app
3. ✅ **Edit code** - Coba edit & lihat hot reload
4. ✅ **Customize** - Edit [assets/workouts.json](assets/workouts.json)
5. ✅ **Run tests** - Terminal: `flutter test`

---

**Selamat coding! 🎉**

*Jika ada issue, check [INSTALL.md](INSTALL.md) untuk troubleshooting lengkap.*
