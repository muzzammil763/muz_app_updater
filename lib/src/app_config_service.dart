import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_config_dialog.dart';
import 'muz_app_updater.dart';

class AppConfigService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize({
    required BuildContext context,
    UpdaterAndroid? updaterAndroid,
    UpdaterIOS? updaterIOS,
    KillSwitchAndroid? killSwitchAndroid,
    KillSwitchIOS? killSwitchIOS,
    MaintenanceAndroid? maintenanceAndroid,
    MaintenanceIOS? maintenanceIOS,
  }) async {
    print('🔧 [AppConfigService] Starting initialization...');
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    print('📦 [AppConfigService] Current app version: $currentVersion');

    if (Platform.isAndroid) {
      print('🤖 [AppConfigService] Processing Android configurations...');
      // Handle Android
      if (updaterAndroid != null) {
        print('📱 [AppConfigService] Setting up Android updater listener...');
        _handleUpdater(context, updaterAndroid.collectionName,
            updaterAndroid.documentName, currentVersion);
      }
      if (killSwitchAndroid != null) {
        print('🚫 [AppConfigService] Setting up Android kill switch listener...');
        _handleKillSwitch(context, killSwitchAndroid.collectionName,
            killSwitchAndroid.documentName);
      }
      if (maintenanceAndroid != null) {
        print('🔧 [AppConfigService] Setting up Android maintenance listener...');
        _handleMaintenance(context, maintenanceAndroid.collectionName,
            maintenanceAndroid.documentName);
      }
    } else if (Platform.isIOS) {
      print('🍎 [AppConfigService] Processing iOS configurations...');
      // Handle iOS
      if (updaterIOS != null) {
        print('📱 [AppConfigService] Setting up iOS updater listener...');
        _handleUpdater(context, updaterIOS.collectionName,
            updaterIOS.documentName, currentVersion);
      }
      if (killSwitchIOS != null) {
        print('🚫 [AppConfigService] Setting up iOS kill switch listener...');
        _handleKillSwitch(
            context, killSwitchIOS.collectionName, killSwitchIOS.documentName);
      }
      if (maintenanceIOS != null) {
        print('🔧 [AppConfigService] Setting up iOS maintenance listener...');
        _handleMaintenance(context, maintenanceIOS.collectionName,
            maintenanceIOS.documentName);
      }
    }
    print('✅ [AppConfigService] Initialization completed');
  }

  void _handleUpdater(BuildContext context, String collectionName,
      String documentName, String currentVersion) {
    print('📡 [AppConfigService] Listening to updater collection: $collectionName/$documentName');
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        print('📊 [AppConfigService] Updater data received from Firestore');
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final discontinuedVersions =
            data['${platformKey}_discontinued_versions'] as List<dynamic>? ??
                [];
        final forceUpdate =
            data['${platformKey}_force_update'] as bool? ?? false;
        final updateUrl = data['${platformKey}_update_url'] as String?;

        print('🔍 [AppConfigService] Checking version: $currentVersion, Force update: $forceUpdate');
        if (discontinuedVersions.contains(currentVersion)) {
          print('⚠️ [AppConfigService] Version discontinued, showing update dialog');
          _showUpdateDialog(context, forceUpdate, updateUrl, currentVersion);
        }
      } else {
        print('📭 [AppConfigService] No updater data found in Firestore');
      }
    });
  }

  void _handleKillSwitch(
      BuildContext context, String collectionName, String documentName) {
    print('📡 [AppConfigService] Listening to kill switch collection: $collectionName/$documentName');
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        print('📊 [AppConfigService] Kill switch data received from Firestore');
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final enabled = data['${platformKey}_enabled'] as bool? ?? false;
        final title = data['${platformKey}_title'] as String?;
        final message = data['${platformKey}_message'] as String?;

        print('🚫 [AppConfigService] Kill switch enabled: $enabled');
        if (enabled) {
          print('🚨 [AppConfigService] Showing kill switch dialog');
          _showKillSwitchDialog(context, title, message);
        } else {
          print('✅ [AppConfigService] Kill switch disabled, hiding dialog');
          _hideDialog(context);
        }
      } else {
        print('📭 [AppConfigService] No kill switch data found in Firestore');
      }
    });
  }

  void _handleMaintenance(
      BuildContext context, String collectionName, String documentName) {
    print('📡 [AppConfigService] Listening to maintenance collection: $collectionName/$documentName');
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        print('📊 [AppConfigService] Maintenance data received from Firestore');
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final enabled = data['${platformKey}_enabled'] as bool? ?? false;
        final title = data['${platformKey}_title'] as String?;
        final message = data['${platformKey}_message'] as String?;

        print('🔧 [AppConfigService] Maintenance enabled: $enabled');
        if (enabled) {
          print('🚧 [AppConfigService] Showing maintenance dialog');
          _showMaintenanceDialog(context, title, message);
        } else {
          print('✅ [AppConfigService] Maintenance disabled, hiding dialog');
          _hideDialog(context);
        }
      } else {
        print('📭 [AppConfigService] No maintenance data found in Firestore');
      }
    });
  }

  void _showUpdateDialog(BuildContext context, bool forceUpdate,
      String? updateUrl, String currentVersion) {
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (context) => AppConfigDialog(
        isKillSwitch: false,
        isMaintenance: false,
        isVersionDiscontinued: true,
        isForceUpdate: forceUpdate,
        currentVersion: currentVersion,
        playStoreUrl: updateUrl,
        appStoreUrl: updateUrl,
      ),
    );
  }

  void _showKillSwitchDialog(
      BuildContext context, String? title, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppConfigDialog(
        isKillSwitch: true,
        isMaintenance: false,
        isVersionDiscontinued: false,
        currentVersion: '',
      ),
    );
  }

  void _showMaintenanceDialog(
      BuildContext context, String? title, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppConfigDialog(
        isKillSwitch: false,
        isMaintenance: true,
        isVersionDiscontinued: false,
        currentVersion: '',
      ),
    );
  }

  void _hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
