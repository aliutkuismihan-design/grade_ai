import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/scan/application/scan_providers.dart';
import 'package:grade_ai/src/features/scan/presentation/widgets/edge_overlay.dart';

/// Scan screen — capture or pick an exam paper image.
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    ref.read(scanLoadingProvider.notifier).state = true;
    try {
      final file = await ref.read(captureImageUseCaseProvider(source).future);
      if (file != null) {
        ref.read(capturedImageProvider.notifier).state = file;
        if (context.mounted) {
          context.push('/preview');
        }
      }
    } finally {
      ref.read(scanLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(scanLoadingProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'Scan Exam Paper',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // Paper placeholder with edge overlay
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const EdgeOverlay(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Position the paper within the frame',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const Spacer(),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _pickImage(context, ref, ImageSource.camera),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.camera_alt),
                          label: Text(isLoading ? 'Opening camera...' : 'Take Photo'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _pickImage(context, ref, ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Choose from Gallery'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
