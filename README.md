# AI Study Assistant

An AI-powered study assistant app built with Flutter. This app allows you to import PDF documents, extract text, and automatically generate flashcards and mock tests using the Gemini API.

## Features
- **PDF Import**: Extract text from any PDF study material.
- **AI Generation**: Automatically creates flashcards and multiple-choice questions.
- **Flashcards**: Interactive study mode with flip animation.
- **Mock Tests**: Take quizzes and track your score.
- **Progress Tracking**: Visualize your study streaks and activity.
- **Local Storage**: All data is saved locally using Hive.

## Setup

1. **Prerequisites**:
    - Flutter SDK installed (v3.0+)
    - Android Studio or VS Code

2. **Installation**:
    ```bash
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3. **API Key**:
    - Get a Gemini API Key from [Google AI Studio](https://aistudio.google.com/).
    - Enter the key in the app when prompted on the Import Screen.

4. **Run**:
    ```bash
    flutter run
    ```

## Building APK (Android)

You can build the APK locally or use the included GitHub Actions workflow.

**Locally:**
```bash
flutter build apk --release
```

**GitHub Actions:**
1. Push this code to a GitHub repository.
2. Go to the "Actions" tab.
3. Select "Build Android APK".
4. Download the artifact once the build completes.

## Architecture
- **State Management**: Riverpod
- **Database**: Hive
- **AI**: Google Generative AI (Gemini)
- **PDF**: Syncfusion Flutter PDF
