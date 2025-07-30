
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

// Main Class

class MuzAppUpdater {
  static Future<void> initialize({
    required BuildContext context,
    UpdaterAndroid? updaterAndroid,
    UpdaterIOS? updaterIOS,
    bool setupFirestoreCollections = false,
  }) async {
    print('🚀 [MuzAppUpdater] Initializing...');
    print('📱 [MuzAppUpdater] Platform: ${Platform.isAndroid ? 'Android' : 'iOS'}');
    
    if (setupFirestoreCollections) {
      print('⚙️ [MuzAppUpdater] Setting up Firestore collections...');
      await _setupFirestoreCollections(
        updaterAndroid: updaterAndroid,
        updaterIOS: updaterIOS,
      );
      print('✅ [MuzAppUpdater] Firestore collections setup completed');
    }
    
    print('🔧 [MuzAppUpdater] Starting AppConfigService...');
    await AppConfigService().initialize(
      context: context,
      updaterAndroid: updaterAndroid,
      updaterIOS: updaterIOS,
    );
    print('✅ [MuzAppUpdater] Initialization completed successfully');
  }

  static Future<void> _setupFirestoreCollections({
    UpdaterAndroid? updaterAndroid,
    UpdaterIOS? updaterIOS,
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
    } catch (e) {
      print('❌ [MuzAppUpdater] Error setting up Firestore collections: $e');
      rethrow;
    }
  }
}
