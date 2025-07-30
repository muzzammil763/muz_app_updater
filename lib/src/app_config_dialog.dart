import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConfigDialog extends StatelessWidget {
  final bool isKillSwitch;
  final bool isMaintenance;
  final bool isVersionDiscontinued;
  final bool isForceUpdate;
  final String currentVersion;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final VoidCallback? onDismiss;

  const AppConfigDialog({
    super.key,
    required this.isKillSwitch,
    required this.isMaintenance,
    required this.isVersionDiscontinued,
    this.isForceUpdate = true,
    required this.currentVersion,
    this.playStoreUrl,
    this.appStoreUrl,
    this.onDismiss,
  });

  Future<void> _launchStoreUrl() async {
    final url = Platform.isIOS ? appStoreUrl : playStoreUrl;
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DialogMode mode = _getDialogMode();

    return PopScope(
      canPop: isVersionDiscontinued && !isForceUpdate,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop &&
            onDismiss != null &&
            isVersionDiscontinued &&
            !isForceUpdate) {
          onDismiss!();
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(mode.icon, color: Colors.red, size: 45),
                ),
                const SizedBox(height: 16),
                Text(
                  mode.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mode.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                if (isVersionDiscontinued &&
                    (playStoreUrl != null || appStoreUrl != null))
                  Column(
                    children: [
                      ElevatedButton(
                        child: Text("Update Now"),
                        onPressed: _launchStoreUrl,
                      ),
                      const SizedBox(height: 12),
                      if (isForceUpdate)
                        OutlinedButton(
                          child: Text("Close App"),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        )
                      else
                        OutlinedButton(
                          child: Text("Not Now"),
                          onPressed: () {
                            if (onDismiss != null) {
                              onDismiss!();
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                    ],
                  )
                else
                  OutlinedButton(
                    child: Text("Close App"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DialogMode _getDialogMode() {
    if (isVersionDiscontinued) {
      return DialogMode(
        title: 'Version Discontinued',
        message:
            'Version $currentVersion Is No Longer Supported. Please Update To The Latest Version To Continue Using The App.',
        icon: Icons.update_rounded,
      );
    } else if (isKillSwitch) {
      return DialogMode(
        title: 'App Disabled',
        message:
            'This App Has Been Disabled By The Administrator. Please Contact Support For More Information.',
        icon: Icons.warning_rounded,
      );
    } else {
      return DialogMode(
        title: 'App Maintenance',
        message:
            'The App Is Currently Under Maintenance. Please Try Again Later.',
        icon: Icons.engineering_rounded,
      );
    }
  }
}

class DialogMode {
  final String title;
  final String message;
  final IconData icon;

  const DialogMode({
    required this.title,
    required this.message,
    required this.icon,
  });
}
