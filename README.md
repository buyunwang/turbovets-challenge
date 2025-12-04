# Setup

## 1. Start Angular dashboard

```bash
cd webpage
npm install
npm start
```

Should be running at http://localhost:4200

## 2. Start Flutter app

Open a new terminal

```bash
cd flutter_app
flutter pub get
flutter run
```

Pick iOS or Android when prompted

## Notes

- Angular must be running first before launching the Flutter app
- Flutter webview points to localhost:4200 (iOS) or 10.0.2.2:4200 (Android emulator)
- If Angular port changes update it in flutter_app/lib/screens/dashboard_screen.dart
