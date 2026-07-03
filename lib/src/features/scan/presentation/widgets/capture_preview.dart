import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/scan/application/scan_providers.dart';

/// Review a captured image before proceeding to upload.
class CapturePreview extends ConsumerWidget {
  const CapturePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(capturedImageProvider);
    if (image == null) {
      return const Center(child: Text('No image captured'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(capturedImageProvider.notifier).state = null;
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          _actionsBar(context, ref, image),
        ],
      ),
    );
  }

  Widget _actionsBar(BuildContext context, WidgetRef ref, File image) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(capturedImageProvider.notifier).state = null;
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => context.push('/upload'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Use this photo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
