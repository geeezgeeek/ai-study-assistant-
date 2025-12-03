# AI Study Assistant - Android App

## Setup Instructions

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- Java JDK 17 or higher

### Building the APK

#### Local Build
1. Navigate to project directory
2. Run `flutter pub get` to install dependencies
3. Run `flutter build apk --release` to build release APK
4. APK will be in `build/app/outputs/flutter-apk/app-release.apk`

#### GitHub Actions
The repository includes a GitHub Actions workflow that automatically builds the APK when you push to main/master branch.

1. Push your code to GitHub
2. Go to Actions tab in your repository
3. The workflow will run automatically
4. Download the built APK from the artifacts section

### Important Files Added

**Gradle Configuration:**
- `android/build.gradle` - Root build configuration
- `android/settings.gradle` - Project settings
- `android/gradle.properties` - Build properties
- `android/app/build.gradle` - App-level build config
- `android/gradle/wrapper/gradle-wrapper.properties` - Gradle wrapper

**Android Platform:**
- `android/app/src/main/AndroidManifest.xml` - App manifest with permissions
- `android/app/src/main/kotlin/com/study/ai_assistant/MainActivity.kt` - Main activity
- `android/app/src/main/res/values/styles.xml` - App themes
- `android/app/src/main/res/drawable/launch_background.xml` - Launch screen

**CI/CD:**
- `.github/workflows/build-apk.yml` - GitHub Actions workflow for APK building

### Package Name
`com.study.ai_assistant`

### SDK Versions
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Compile SDK: 34

### Permissions
- INTERNET - For AI API calls
- READ_EXTERNAL_STORAGE - For importing PDFs
- WRITE_EXTERNAL_STORAGE - For saving study data

### Notes
- Launcher icons need to be added (see `android/app/src/main/res/LAUNCHER_ICONS_README.md`)
- The app uses debug signing for now (update for production release)
- GitHub Actions will build on every push to main/master branch
