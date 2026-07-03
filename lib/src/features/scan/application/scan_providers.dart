import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final capturedImageProvider = StateProvider<File?>((ref) => null);

final scanLoadingProvider = StateProvider<bool>((ref) => false);

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

final captureImageUseCaseProvider = FutureProvider.family<File?, ImageSource>(
  (ref, source) async {
    final picker = ref.read(imagePickerProvider);
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );
    if (picked == null) return null;
    return File(picked.path);
  },
);
