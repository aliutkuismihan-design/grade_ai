import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/security/application/security_providers.dart';

/// App lock screen — PIN entry or biometric authentication.
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key, required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  String? _error;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tryBiometric();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _tryBiometric() async {
    final enabled = ref.read(biometricEnabledProvider);
    if (!enabled) return;

    final auth = ref.read(localAuthProvider);
    final canCheck = await auth.canCheckBiometrics;
    if (!canCheck) return;

    final didAuth = await auth.authenticate(
      localizedReason: 'Unlock GradeAI',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    if (didAuth && mounted) widget.onUnlock();
  }

  void _onDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += digit;
      _error = null;
    });
    if (_pin.length == 4) _verifyPin();
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _verifyPin() {
    final storedPin = ref.read(appLockPinProvider);
    if (storedPin == null || _pin == storedPin) {
      widget.onUnlock();
    } else {
      _shakeController.forward(from: 0);
      setState(() {
        _pin = '';
        _error = 'Incorrect PIN';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.lock_outline, size: 56, color: AppTheme.primary),
              const SizedBox(height: 16),
              const Text(
                'GradeAI is Locked',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your PIN to continue',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
              const SizedBox(height: 40),

              // PIN dots
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shake = _shakeController.value < 1
                      ? Curves.elasticOut.transform(_shakeController.value) * 20
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(shake * (_shakeController.isAnimating ? (_shakeController.value > 0.5 ? -1 : 1) : 0), 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) {
                        final filled = i < _pin.length;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? AppTheme.primary : Colors.white.withOpacity(0.15),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
              ],

              const Spacer(),

              // Biometric button
              if (ref.watch(biometricEnabledProvider))
                IconButton(
                  onPressed: _tryBiometric,
                  icon: const Icon(Icons.fingerprint, size: 40, color: Colors.white70),
                ),

              const SizedBox(height: 20),

              // Numpad
              _numpad(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numpad() {
    return Column(
      children: [
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', 'backspace'],
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                if (key == '') return const SizedBox(width: 80);
                if (key == 'backspace') {
                  return _keyButton(
                    icon: Icons.backspace_outlined,
                    onTap: _onBackspace,
                  );
                }
                return _keyButton(
                  label: key,
                  onTap: () => _onDigit(key),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _keyButton({String? label, IconData? icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(
              child: label != null
                  ? Text(
                      label,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
                    )
                  : Icon(icon, size: 28, color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}
