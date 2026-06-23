<div align="center">
    <h1>Setans</h1>
    <p>
        <img src=".github/setans.svg" align="center" alt="Logo" width="256" />
    </p>
    <p>A desktop app for tracking student attendance.</p>
    <p>
        <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" />
        <img alt="Platform" src="https://img.shields.io/badge/platform-linux%20|%20macos%20|%20windows-1565C0" />
        <img alt="License" src="https://img.shields.io/badge/license-AGPL--3.0-1565C0" />
    </p>
</div>

---

![App Screenshot](.github/screenshot.png)

## 📋 What it does

- **Calendar** — browse months and pick a day to manage
- **Attendance** — mark students present or absent per day
- **Students** — register, search, edit, and delete
- **Overview** — full table of all students × all dates, export to CSV
- **Profile** — per-student history with quick mark buttons
- **Tutorial** — interactive walkthrough on first run

## 🛠 Build

```bash
flutter pub get
dart run build_runner build
flutter build linux
```
