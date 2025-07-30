# Muz App Updater

A Flutter package for app update management with Firebase Firestore integration. This package provides a simple way to implement app update checking in your Flutter applications.

## Features

- **App Update Checking**: Automatically check for new app versions and prompt users to update
- **Force Update Support**: Require users to update before using the app
- **Platform-Specific Configuration**: Different settings for Android and iOS
- **Firebase Firestore Integration**: Store configuration in Firestore
- **Easy Integration**: Simple initialization with minimal setup
- **Custom Update URLs**: Support for custom app store URLs

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  muz_app_updater: ^0.0.2
```

## Setup

### 1. Firebase Configuration

1. Create a Firebase project
2. Add your Android and iOS apps to the project
3. Download and add the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

### 2. Automatic Firestore Setup (Recommended)

For first-time setup, use the `setupFirestoreCollections` parameter to automatically create the required collections:

```dart
await MuzAppUpdater.initialize(
  context: context,
  updaterAndroid: UpdaterAndroid(
    collectionName: 'app_updates',
    documentName: 'android',
  ),
  updaterIOS: UpdaterIOS(
    collectionName: 'app_updates',
    documentName: 'ios',
  ),
  killSwitchAndroid: KillSwitchAndroid(
    collectionName: 'kill_switch',
    documentName: 'android',
  ),
  killSwitchIOS: KillSwitchIOS(
    collectionName: 'kill_switch',
    documentName: 'ios',
  ),
  maintenanceAndroid: MaintenanceAndroid(
    collectionName: 'maintenance',
    documentName: 'android',
  ),
  maintenanceIOS: MaintenanceIOS(
    collectionName: 'maintenance',
    documentName: 'ios',
  ),
  setupFirestoreCollections: true, // Set to true for first-time setup
);
```

After the collections are created successfully, you can set this parameter to `false` or remove it entirely.

### 3. Manual Firestore Database Structure (Alternative)

If you prefer to create the collections manually, use this structure:

```
app_updates/
├── android/
│   ├── android_version: "1.0.1"
│   ├── android_force_update: true/false
│   ├── android_update_url: "https://play.google.com/store/apps/details?id=..."
│   ├── ios_version: "1.0.1"
│   ├── ios_force_update: true/false
│   └── ios_update_url: "https://apps.apple.com/app/id..."
└── ios/
    ├── android_version: "1.0.1"
    ├── android_force_update: true/false
    ├── android_update_url: "https://play.google.com/store/apps/details?id=..."
    ├── ios_version: "1.0.1"
    ├── ios_force_update: true/false
    └── ios_update_url: "https://apps.apple.com/app/id..."
```

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muz_app_updater/muz_app_updater.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initializeAppUpdater();
  }

  Future<void> _initializeAppUpdater() async {
    await MuzAppUpdater.initialize(
      context: context,
      updaterAndroid: UpdaterAndroid(
        collectionName: 'app_updates',
        documentName: 'android',
      ),
      updaterIOS: UpdaterIOS(
        collectionName: 'app_updates',
        documentName: 'ios',
      ),
      killSwitchAndroid: KillSwitchAndroid(
        collectionName: 'kill_switch',
        documentName: 'android',
      ),
      killSwitchIOS: KillSwitchIOS(
        collectionName: 'kill_switch',
        documentName: 'ios',
      ),
      maintenanceAndroid: MaintenanceAndroid(
        collectionName: 'maintenance',
        documentName: 'android',
      ),
      maintenanceIOS: MaintenanceIOS(
        collectionName: 'maintenance',
        documentName: 'ios',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: const Center(child: Text('Welcome to My App!')),
    );
  }
}
```

### Configuration Options

The `MuzAppUpdater.initialize()` method accepts the following parameters:

- `context`: The BuildContext for showing dialogs
- `updaterAndroid`: Configuration for Android app updates
- `updaterIOS`: Configuration for iOS app updates
- `setupFirestoreCollections`: Set to `true` for first-time setup to automatically create collections

Each configuration object requires:
- `collectionName`: The Firestore collection name
- `documentName`: The Firestore document name

## Example

See the `example/` directory for a complete working example that demonstrates all features of the package.

To run the example:

```bash
cd example
flutter pub get
flutter run
```

## Testing Different Scenarios

1. **Force Update**: Set `android_force_update: true` or `ios_force_update: true` in the Firestore document
2. **Version Check**: Update `android_version` or `ios_version` to a newer version than your app
3. **Custom URLs**: Modify `android_update_url` or `ios_update_url` to point to your app's store page

The app will respond accordingly to these configurations.

## Dependencies

This package depends on:
- `firebase_core`: any
- `cloud_firestore`: any
- `package_info_plus`: any
- `url_launcher`: any

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
