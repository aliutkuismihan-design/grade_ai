import 'package:flutter/material.dart';

/// Animated AI grading progress indicator.
class GradingProgress extends StatelessWidget {
  const GradingProgress({super.key, this.message = 'AI is grading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                RotationTransition(
                  turns: const AlwaysStoppedAnimation(0),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.indigo.withOpacity(0.3),
                    ),
                  ),
                ),
                // Inner pulsing ring
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.6, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Container(
                      width: 80 * value,
                      height: 80 * value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF14B8A6).withOpacity(0.5 + (value - 0.6)),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
                // Center icon
                const Icon(
                  Icons.auto_fix_high,
                  size: 36,
                  color: Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analyzing handwriting, applying rubric, generating feedback',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }
}
