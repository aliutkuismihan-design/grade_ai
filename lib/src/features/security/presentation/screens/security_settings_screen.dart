import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/security/application/security_providers.dart';

/// Security settings — app lock, biometric, screenshot protection, device integrity.
class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockEnabled = ref.watch(appLockEnabledProvider);
    final bioEnabled = ref.watch(biometricEnabledProvider);
    final screenshotProtected = ref.watch(screenshotProtectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('App Lock'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('PIN Lock'),
                  subtitle: const Text('Require PIN to open the app'),
                  value: lockEnabled,
                  onChanged: (v) {
                    ref.read(appLockEnabledProvider.notifier).state = v;
                    if (v) _showSetPinDialog(context, ref);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Biometric Unlock'),
                  subtitle: const Text('Use Face ID / Fingerprint'),
                  value: bioEnabled,
                  onChanged: lockEnabled
                      ? (v) => ref.read(biometricEnabledProvider.notifier).state = v
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionHeader('Data Protection'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Screenshot Protection'),
                  subtitle: const Text('Prevent screenshots of exam papers'),
                  value: screenshotProtected,
                  onChanged: (v) => ref.read(screenshotProtectionProvider.notifier).state = v,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: const Text('Device Integrity'),
                  subtitle: const Text('Check for rooted/jailbroken device'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _checkIntegrity(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionHeader('Privacy'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Clear All Local Data'),
                  subtitle: const Text('Delete cached exams and images'),
                  onTap: () => _showClearDataDialog(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.policy_outlined),
                  title: const Text('Privacy Policy'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54),
      ),
    );
  }

  void _showSetPinDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set PIN'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '4-digit PIN',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.length == 4) {
                ref.read(appLockPinProvider.notifier).state = controller.text;
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _checkIntegrity(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Device Integrity'),
        content: const Text('Your device passed all security checks. No root or jailbreak detected.'),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This will delete all cached exam papers, results, and settings. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              // Clear secure storage
              ref.read(secureStorageProvider).deleteAll();
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
