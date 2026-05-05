# FitQuest - Fitness Tracking App

[![Flutter](https://img.shields.io/badge/Flutter-3.9%2B-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com)

FitQuest is a comprehensive Flutter-based mobile fitness application designed to help users track workouts, record GPS-powered runs, view workout history, and manage their fitness goals. The app integrates Firebase Authentication, Cloud Firestore, local offline storage, and map-based run tracking with a modern MVVM architecture.

## 🎯 Features

- **User Authentication** - Secure Firebase-based login and signup
- **Workout Tracking** - Log custom workouts with duration, type, and calories
- **GPS Run Tracking** - Record runs with real-time map visualization and distance tracking
- **Fitness Goals** - Set and monitor personal fitness goals
- **Workout History** - View detailed history of all past workouts with statistics
- **User Profile** - Manage personal information and profile settings
- **Offline Support** - Full offline capability with local Hive/SQLite storage
- **Real-time Sync** - Automatic synchronization with Firebase when online
- **Cross-Platform** - Support for Android, iOS, Web, Windows, macOS, and Linux

## 📱 Supported Platforms

- **Mobile:** iOS, Android
- **Web:** Web browsers
- **Desktop:** Windows, macOS, Linux

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** architectural pattern with clean separation of concerns:

```
lib/
├── screens/          # UI Screens
├── viewmodel/        # ViewModels with business logic
├── models/           # Data models
├── domain/           # Domain layer (repository interfaces)
├── data/             # Data layer (implementations & sources)
├── services/         # External services (Firebase, etc.)
├── local/            # Local database
└── utils/            # Utility functions and helpers
```

## 🔧 Tech Stack

### Framework & UI
- **Flutter 3.9+** - Cross-platform mobile framework
- **Provider** - State management solution

### Backend & Storage
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - Cloud database
- **Firebase Realtime Database** - Real-time data sync
- **Firebase Storage** - File storage
- **SQLite & Hive** - Local offline storage

### Maps & Location
- **flutter_map** - Map visualization
- **geolocator** - GPS location tracking
- **latlong2** - Location data handling
- **flutter_map_location_marker** - Location markers

### Utilities
- **shared_preferences** - Local preferences
- **uuid** - Unique identifier generation
- **intl** - Internationalization support
- **path_provider** - File system paths
- **connectivity_plus** - Network connectivity detection
- **flutter_dotenv** - Environment configuration

## 🚀 Getting Started

### Prerequisites

- Flutter 3.9+ installed ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK (bundled with Flutter)
- Firebase project setup
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fitness-flutter
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Add your Firebase configuration to `ios/Runner/` if needed
   - Update `lib/firebase_options.dart` with your Firebase project details

4. **Generate code (if needed)**
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Project Structure

### Key Directories

- **`lib/screens/`** - All UI screens (authentication, dashboard, workout tracking, etc.)
- **`lib/viewmodel/`** - Business logic and state management using Provider
- **`lib/models/`** - Data models (User, Workout, RunPath, etc.)
- **`lib/services/`** - External service integrations (Firebase, APIs)
- **`lib/local/`** - Local database setup and management
- **`lib/data/`** - Repository pattern implementation
- **`lib/domain/`** - Repository interfaces
- **`android/`** - Android-specific configuration
- **`ios/`** - iOS-specific configuration
- **`web/`, `windows/`, `macos/`, `linux/`** - Platform-specific code

### Important Files

- `pubspec.yaml` - Project dependencies and configuration
- `firebase.json` - Firebase configuration
- `google-services.json` - Android Firebase credentials
- `lib/main.dart` - App entry point
- `lib/app.dart` - App root widget
- `lib/firebase_options.dart` - Firebase initialization

## 🔐 Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication (Email/Password)
3. Create Firestore database
4. Download service account and configure in the app
5. Update security rules in Firestore as needed

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 🐛 Development

### Running in Debug Mode
```bash
flutter run -d <device-id>
```

### Building for Release
- **Android:**
  ```bash
  flutter build apk
  ```
  or for App Bundle:
  ```bash
  flutter build appbundle
  ```

- **iOS:**
  ```bash
  flutter build ios
  ```

- **Web:**
  ```bash
  flutter build web
  ```

## 📦 Generating Build Files

After modifying models or using code generation tools:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🔄 State Management

The app uses **Provider** pattern for state management. ViewModels are located in `lib/viewmodel/` and handle all business logic, with screens consuming them using `Provider.of<ViewModel>(context)`.

## 💾 Local Storage

- **Hive** - Fast local key-value storage for user preferences
- **SQLite** - Relational database for workout and history data
- All local data syncs with Firestore when connection is available

## 📍 Location Services

The app uses device GPS for accurate run tracking:
- Real-time location updates during runs
- Map visualization of run path
- Distance and duration calculation
- Automatic location permission handling

## 🌐 Connectivity

The app detects network status and:
- Works offline with local storage
- Queues actions when offline
- Auto-syncs when connection is restored
- Shows connectivity status to users

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👤 Author

Created as a comprehensive fitness tracking solution.

## 🤝 Contributing

Contributions are welcome! Please follow standard Git workflows:
1. Create a feature branch
2. Make your changes
3. Submit a pull request

## 📧 Support

For issues and questions, please use the GitHub issues tracker.

---

**Note:** This project uses Firebase. Ensure proper security rules are configured in your Firestore database before deploying to production.
