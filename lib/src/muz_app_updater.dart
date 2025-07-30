
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_config_service.dart';

// Data Models

class UpdaterAndroid {
  final String collectionName;
  final String documentName;

  UpdaterAndroid({required this.collectionName, required this.documentName});
}

class UpdaterIOS {
  final String collectionName;
  final String documentName;

  UpdaterIOS({required this.collectionName, required this.documentName});
}

class KillSwitchAndroid {
  final String collectionName;
  final String documentName;

  KillSwitchAndroid({required this.collectionName, required this.documentName});
}

class KillSwitchIOS {
  final String collectionName;
  final String documentName;

  KillSwitchIOS({required this.collectionName, required this.documentName});
}

class MaintenanceAndroid {
  final String collectionName;
  final String documentName;

  MaintenanceAndroid(
      {required this.collectionName, required this.documentName});
}

class MaintenanceIOS {
  final String collectionName;
  final String documentName;

  MaintenanceIOS({required this.collectionName, required this.documentName});
}

// Main Class

class MuzAppUpdater {
  static Future<void> initialize({
    required BuildContext context,
    UpdaterAndroid? updaterAndroid,
    UpdaterIOS? updaterIOS,
    KillSwitchAndroid? killSwitchAndroid,
    KillSwitchIOS? killSwitchIOS,
    MaintenanceAndroid? maintenanceAndroid,
    MaintenanceIOS? maintenanceIOS,
    bool setupFirestoreCollections = false,
  }) async {
    print('🚀 [MuzAppUpdater] Initializing...');
    print('📱 [MuzAppUpdater] Platform: ${Platform.isAndroid ? 'Android' : 'iOS'}');
    
    if (setupFirestoreCollections) {
      print('⚙️ [MuzAppUpdater] Setting up Firestore collections...');
      await _setupFirestoreCollections(
        updaterAndroid: updaterAndroid,
        updaterIOS: updaterIOS,
        killSwitchAndroid: killSwitchAndroid,
        killSwitchIOS: killSwitchIOS,
        maintenanceAndroid: maintenanceAndroid,
        maintenanceIOS: maintenanceIOS,
      );
      print('✅ [MuzAppUpdater] Firestore collections setup completed');
    }
    
    print('🔧 [MuzAppUpdater] Starting AppConfigService...');
    await AppConfigService().initialize(
      context: context,
      updaterAndroid: updaterAndroid,
      updaterIOS: updaterIOS,
      killSwitchAndroid: killSwitchAndroid,
      killSwitchIOS: killSwitchIOS,
      maintenanceAndroid: maintenanceAndroid,
      maintenanceIOS: maintenanceIOS,
    );
    print('✅ [MuzAppUpdater] Initialization completed successfully');
  }

  static Future<void> _setupFirestoreCollections({
    UpdaterAndroid? updaterAndroid,
    UpdaterIOS? updaterIOS,
    KillSwitchAndroid? killSwitchAndroid,
    KillSwitchIOS? killSwitchIOS,
    MaintenanceAndroid? maintenanceAndroid,
    MaintenanceIOS? maintenanceIOS,
  }) async {
    final firestore = FirebaseFirestore.instance;
    
    try {
      // Setup App Updates Collection
      if (updaterAndroid != null) {
        print('📝 [MuzAppUpdater] Setting up Android updater collection...');
        await firestore
            .collection(updaterAndroid.collectionName)
            .doc(updaterAndroid.documentName)
            .set({
          'android_version': '1.0.0',
          'android_force_update': false,
          'android_update_url': 'https://play.google.com/store/apps/details?id=your.app.id',
          'ios_version': '1.0.0',
          'ios_force_update': false,
          'ios_update_url': 'https://apps.apple.com/app/your-app-id',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] Android updater collection setup completed');
      }

      if (updaterIOS != null) {
        print('📝 [MuzAppUpdater] Setting up iOS updater collection...');
        await firestore
            .collection(updaterIOS.collectionName)
            .doc(updaterIOS.documentName)
            .set({
          'android_version': '1.0.0',
          'android_force_update': false,
          'android_update_url': 'https://play.google.com/store/apps/details?id=your.app.id',
          'ios_version': '1.0.0',
          'ios_force_update': false,
          'ios_update_url': 'https://apps.apple.com/app/your-app-id',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] iOS updater collection setup completed');
      }

      // Setup Kill Switch Collection
      if (killSwitchAndroid != null) {
        print('📝 [MuzAppUpdater] Setting up Android kill switch collection...');
        await firestore
            .collection(killSwitchAndroid.collectionName)
            .doc(killSwitchAndroid.documentName)
            .set({
          'android_enabled': false,
          'android_title': 'App Disabled',
          'android_message': 'This app has been temporarily disabled.',
          'ios_enabled': false,
          'ios_title': 'App Disabled',
          'ios_message': 'This app has been temporarily disabled.',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] Android kill switch collection setup completed');
      }

      if (killSwitchIOS != null) {
        print('📝 [MuzAppUpdater] Setting up iOS kill switch collection...');
        await firestore
            .collection(killSwitchIOS.collectionName)
            .doc(killSwitchIOS.documentName)
            .set({
          'android_enabled': false,
          'android_title': 'App Disabled',
          'android_message': 'This app has been temporarily disabled.',
          'ios_enabled': false,
          'ios_title': 'App Disabled',
          'ios_message': 'This app has been temporarily disabled.',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] iOS kill switch collection setup completed');
      }

      // Setup Maintenance Collection
      if (maintenanceAndroid != null) {
        print('📝 [MuzAppUpdater] Setting up Android maintenance collection...');
        await firestore
            .collection(maintenanceAndroid.collectionName)
            .doc(maintenanceAndroid.documentName)
            .set({
          'android_enabled': false,
          'android_title': 'Under Maintenance',
          'android_message': 'The app is currently under maintenance. Please try again later.',
          'ios_enabled': false,
          'ios_title': 'Under Maintenance',
          'ios_message': 'The app is currently under maintenance. Please try again later.',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] Android maintenance collection setup completed');
      }

      if (maintenanceIOS != null) {
        print('📝 [MuzAppUpdater] Setting up iOS maintenance collection...');
        await firestore
            .collection(maintenanceIOS.collectionName)
            .doc(maintenanceIOS.documentName)
            .set({
          'android_enabled': false,
          'android_title': 'Under Maintenance',
          'android_message': 'The app is currently under maintenance. Please try again later.',
          'ios_enabled': false,
          'ios_title': 'Under Maintenance',
          'ios_message': 'The app is currently under maintenance. Please try again later.',
        }, SetOptions(merge: true));
        print('✅ [MuzAppUpdater] iOS maintenance collection setup completed');
      }
    } catch (e) {
      print('❌ [MuzAppUpdater] Error setting up Firestore collections: $e');
      rethrow;
    }
  }
}
