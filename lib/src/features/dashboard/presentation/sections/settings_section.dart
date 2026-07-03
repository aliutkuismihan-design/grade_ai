import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/core/config/locale_controller.dart';
import 'package:grade_ai/src/features/ads/application/ads_providers.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  static const _languages = <String, Locale?>{
    'System default': null,
    'English': Locale('en'),
    'Français': Locale('fr'),
    'Türkçe': Locale('tr'),
    'Español': Locale('es'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final credits = ref.watch(creditsProvider);
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _ProfileCard(),
        const SizedBox(height: 16),

        Text('Language', style: text.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final entry in _languages.entries)
                RadioListTile<Locale?>(
                  value: entry.value,
                  groupValue: locale,
                  title: Text(entry.key),
                  onChanged: (v) =>
                      ref.read(localeControllerProvider.notifier).setLocale(v),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Rewarded-ad credit booster (gamification).
        Card(
          child: ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Grading credits'),
            subtitle: Text('$credits available'),
            trailing: FilledButton.icon(
              onPressed: () async {
                final shown = await ref.read(adsServiceProvider).showRewarded(
                  (earned) => ref.read(creditsProvider.notifier).add(earned),
                );
                if (!shown && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No ad ready yet — try again shortly.')),
                  );
                }
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Watch ad'),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text('Subscription', style: text.titleMedium),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: Text('Free plan'),
            subtitle: Text('Upgrade to remove ads and unlock unlimited grading (coming soon).'),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('Teacher'),
        subtitle: Text('ali.utku.ismihan@gmail.com'),
      ),
    );
  }
}
