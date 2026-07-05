import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Checks for app updates and shows a dialog if a newer version is available.
/// 
/// For Android: uses in-app update API or redirects to Play Store.
/// For iOS: redirects to App Store.
/// For Windows: checks GitHub releases and downloads the new installer.
class UpdateChecker {
  static Future<void> check(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    // TODO: Replace with your actual version check endpoint
    // Example: https://your-api.com/version?platform=android
    final latestVersion = await _fetchLatestVersion();

    if (latestVersion != null && _isNewer(latestVersion, currentVersion)) {
      if (context.mounted) {
        _showUpdateDialog(context, currentVersion, latestVersion);
      }
    }
  }

  static Future<String?> _fetchLatestVersion() async {
    // Mock: In production, fetch from your API or GitHub releases
    // For now, return null to skip update checks during development
    return null;
  }

  static bool _isNewer(String latest, String current) {
    final l = latest.split('.').map(int.parse).toList();
    final c = current.split('.').map(int.parse).toList();
    for (var i = 0; i < 3; i++) {
      if (l[i] > c[i]) return true;
      if (l[i] < c[i]) return false;
    }
    return false;
  }

  static void _showUpdateDialog(BuildContext context, String current, String latest) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Available'),
        content: Text('A new version ($latest) is available. You are on $current.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () => _openStore(ctx),
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  static Future<void> _openStore(BuildContext context) async {
    String url;
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.aliutku.grade_ai';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/idYOUR_APP_ID';
    } else {
      url = 'https://github.com/aliutkuismihan-design/grade_ai/releases';
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
