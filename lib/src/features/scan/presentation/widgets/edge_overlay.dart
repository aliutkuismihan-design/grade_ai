import 'package:flutter/material.dart';

/// A4 paper corner guide overlay for the scan preview.
class EdgeOverlay extends StatelessWidget {
  const EdgeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
        ),
        child: Center(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Corner markers
                  _corner(top: 0, left: 0),
                  _corner(top: 0, right: 0),
                  _corner(bottom: 0, left: 0),
                  _corner(bottom: 0, right: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _corner({double? top, double? left, double? right, double? bottom}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: top != null ? const BorderSide(color: Colors.teal, width: 3) : BorderSide.none,
            left: left != null ? const BorderSide(color: Colors.teal, width: 3) : BorderSide.none,
            right: right != null ? const BorderSide(color: Colors.teal, width: 3) : BorderSide.none,
            bottom: bottom != null ? const BorderSide(color: Colors.teal, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
