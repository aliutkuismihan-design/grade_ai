import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

final localAuthProvider = Provider<LocalAuthentication>((ref) => LocalAuthentication());

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
    ),
    iOptions: IOSOptions(
      accountName: 'grade_ai_secure',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);

final appLockEnabledProvider = StateProvider<bool>((ref) => false);
final appLockPinProvider = StateProvider<String?>((ref) => null);
final biometricEnabledProvider = StateProvider<bool>((ref) => false);

final screenshotProtectionProvider = StateProvider<bool>((ref) => true);

final deviceIntegrityProvider = FutureProvider<bool>((ref) async {
  try {
    // Root/jailbreak detection placeholder
    // Will be implemented with jailbreak_root_detection
    return true;
  } catch (_) {
    return false;
  }
});
