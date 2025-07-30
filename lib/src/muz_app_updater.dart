
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
  }) async {
    await AppConfigService().initialize(
      context: context,
      updaterAndroid: updaterAndroid,
      updaterIOS: updaterIOS,
      killSwitchAndroid: killSwitchAndroid,
      killSwitchIOS: killSwitchIOS,
      maintenanceAndroid: maintenanceAndroid,
      maintenanceIOS: maintenanceIOS,
    );
  }
}
