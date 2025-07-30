# Muz App Updater

A Flutter package for app update management with Firebase Firestore integration. This package provides a simple way to implement app update checking, kill switch functionality, and maintenance mode in your Flutter applications.

## Features

- **App Update Checking**: Automatically check for new app versions and prompt users to update
- **Kill Switch**: Disable your app remotely when needed
- **Maintenance Mode**: Show maintenance messages to users
- **Platform-Specific Configuration**: Different settings for Android and iOS
- **Firebase Firestore Integration**: Store configuration in Firestore
- **Easy Integration**: Simple initialization with minimal setup

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

### 2. Firestore Database Structure

Create the following collections and documents in your Firestore database:

```
app_updates/
├── android/
│   ├── version: "1.0.1"
│   ├── forceUpdate: true/false
│   └── downloadUrl: "https://play.google.com/store/apps/details?id=..."
└── ios/
    ├── version: "1.0.1"
    ├── forceUpdate: true/false
    └── downloadUrl: "https://apps.apple.com/app/id..."

kill_switch/
├── android/
│   └── enabled: true/false
└── ios/
    └── enabled: true/false

maintenance/
├── android/
│   ├── enabled: true/false
│   └── message: "App is under maintenance"
└── ios/
    ├── enabled: true/false
    └── message: "App is under maintenance"
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
- `killSwitchAndroid`: Configuration for Android kill switch
- `killSwitchIOS`: Configuration for iOS kill switch
- `maintenanceAndroid`: Configuration for Android maintenance mode
- `maintenanceIOS`: Configuration for iOS maintenance mode

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

1. **Force Update**: Set `forceUpdate: true` in the Firestore document
2. **Kill Switch**: Set `enabled: true` in the kill_switch document
3. **Maintenance**: Set `enabled: true` in the maintenance document

The app will respond accordingly to these configurations.

## Dependencies

This package depends on:
- `firebase_core`: ^4.0.0
- `cloud_firestore`: ^6.0.0
- `package_info_plus`: ^8.3.0
- `url_launcher`: ^6.3.2

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
