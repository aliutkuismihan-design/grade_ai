import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              l10n.homeTagline,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {}, // TODO: navigate to /scan
              icon: const Icon(Icons.document_scanner_outlined),
              label: Text(l10n.scanPaper),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {}, // TODO: navigate to /answer-keys
              icon: const Icon(Icons.key_outlined),
              label: Text(l10n.manageAnswerKeys),
            ),
          ],
        ),
      ),
    );
  }
}
