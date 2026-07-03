import 'package:flutter/material.dart';

/// A minimal dependency-free vertical bar chart (used for per-question averages,
/// score histograms, and student progress). Values are normalised against
/// [maxValue].
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.maxValue = 100,
    this.barColor,
    this.height = 160,
    this.highlightIndex,
  });

  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color? barColor;
  final double height;

  /// Optional index to paint in the accent (amber) colour, e.g. hardest question.
  final int? highlightIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = barColor ?? scheme.primary;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      values[i].toStringAsFixed(0),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: (height - 40) * (values[i] / maxValue).clamp(0, 1),
                      decoration: BoxDecoration(
                        color: i == highlightIndex ? scheme.tertiary : base,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
