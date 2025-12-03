# Launcher Icons

The default Flutter launcher icons are missing. You have two options:

## Option 1: Use flutter_launcher_icons package
Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  image_path: "assets/icon/app_icon.png"
```

Then run: `flutter pub run flutter_launcher_icons`

## Option 2: Manual placement
Place PNG icons in these directories:
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

For now, the app will use Android's default launcher icon.
