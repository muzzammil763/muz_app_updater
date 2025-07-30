# Muz App Updater Example

This example demonstrates how to use the `muz_app_updater` package in a Flutter application.

## Features Demonstrated

- App update checking
- Kill switch functionality
- Maintenance mode
- Platform-specific configurations
- Firebase Firestore integration

## Setup Instructions

1. **Firebase Configuration**
   - Create a Firebase project
   - Add your Android and iOS apps to the project
   - Download and add the configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)

2. **Firestore Database Structure**
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

3. **Run the Example**
   ```bash
   cd example
   flutter pub get
   flutter run
   ```

## How It Works

The example app initializes the `MuzAppUpdater` with platform-specific configurations for:

- **App Updates**: Checks for new versions and prompts users to update
- **Kill Switch**: Disables the app if needed
- **Maintenance Mode**: Shows maintenance messages when the app is under maintenance

The app will automatically check these configurations when it starts and display appropriate dialogs based on the Firestore data.

## Testing Different Scenarios

1. **Force Update**: Set `forceUpdate: true` in the Firestore document
2. **Kill Switch**: Set `enabled: true` in the kill_switch document
3. **Maintenance**: Set `enabled: true` in the maintenance document

The app will respond accordingly to these configurations. 