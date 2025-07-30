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
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (Platform.isAndroid) {
      // Handle Android
      if (updaterAndroid != null) {
        _handleUpdater(context, updaterAndroid.collectionName,
            updaterAndroid.documentName, currentVersion);
      }
      if (killSwitchAndroid != null) {
        _handleKillSwitch(context, killSwitchAndroid.collectionName,
            killSwitchAndroid.documentName);
      }
      if (maintenanceAndroid != null) {
        _handleMaintenance(context, maintenanceAndroid.collectionName,
            maintenanceAndroid.documentName);
      }
    } else if (Platform.isIOS) {
      // Handle iOS
      if (updaterIOS != null) {
        _handleUpdater(context, updaterIOS.collectionName,
            updaterIOS.documentName, currentVersion);
      }
      if (killSwitchIOS != null) {
        _handleKillSwitch(
            context, killSwitchIOS.collectionName, killSwitchIOS.documentName);
      }
      if (maintenanceIOS != null) {
        _handleMaintenance(context, maintenanceIOS.collectionName,
            maintenanceIOS.documentName);
      }
    }
  }

  void _handleUpdater(BuildContext context, String collectionName,
      String documentName, String currentVersion) {
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final discontinuedVersions =
            data['${platformKey}_discontinued_versions'] as List<dynamic>? ??
                [];
        final forceUpdate =
            data['${platformKey}_force_update'] as bool? ?? false;
        final updateUrl = data['${platformKey}_update_url'] as String?;

        if (discontinuedVersions.contains(currentVersion)) {
          _showUpdateDialog(context, forceUpdate, updateUrl, currentVersion);
        }
      }
    });
  }

  void _handleKillSwitch(
      BuildContext context, String collectionName, String documentName) {
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final enabled = data['${platformKey}_enabled'] as bool? ?? false;
        final title = data['${platformKey}_title'] as String?;
        final message = data['${platformKey}_message'] as String?;

        if (enabled) {
          _showKillSwitchDialog(context, title, message);
        } else {
          _hideDialog(context);
        }
      }
    });
  }

  void _handleMaintenance(
      BuildContext context, String collectionName, String documentName) {
    _firestore
        .collection(collectionName)
        .doc(documentName)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        final platformKey = Platform.isIOS ? 'ios' : 'android';
        final enabled = data['${platformKey}_enabled'] as bool? ?? false;
        final title = data['${platformKey}_title'] as String?;
        final message = data['${platformKey}_message'] as String?;

        if (enabled) {
          _showMaintenanceDialog(context, title, message);
        } else {
          _hideDialog(context);
        }
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
