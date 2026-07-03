import 'package:flutter/material.dart';
import 'package:grade_ai/src/features/grading/domain/entities/rubric.dart';

/// Inline rubric editor — add/remove criteria and set weights.
class RubricEditor extends StatefulWidget {
  const RubricEditor({
    super.key,
    required this.rubric,
    required this.onChanged,
  });

  final Rubric rubric;
  final ValueChanged<Rubric> onChanged;

  @override
  State<RubricEditor> createState() => _RubricEditorState();
}

class _RubricEditorState extends State<RubricEditor> {
  late List<RubricCriterion> _criteria;

  @override
  void initState() {
    super.initState();
    _criteria = List.from(widget.rubric.criteria);
  }

  void _notify() {
    widget.onChanged(
      Rubric(
        id: widget.rubric.id,
        title: widget.rubric.title,
        curriculum: widget.rubric.curriculum,
        criteria: _criteria,
      ),
    );
  }

  void _addCriterion() {
    setState(() {
      _criteria.add(
        RubricCriterion(
          id: 'c${_criteria.length + 1}',
          description: 'New criterion',
          weight: 0.5,
        ),
      );
    });
    _notify();
  }

  void _removeCriterion(int index) {
    setState(() => _criteria.removeAt(index));
    _notify();
  }

  void _updateDescription(int index, String value) {
    setState(() {
      _criteria[index] = RubricCriterion(
        id: _criteria[index].id,
        description: value,
        weight: _criteria[index].weight,
      );
    });
    _notify();
  }

  void _updateWeight(int index, double value) {
    setState(() {
      _criteria[index] = RubricCriterion(
        id: _criteria[index].id,
        description: _criteria[index].description,
        weight: value.clamp(0.0, 1.0),
      );
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Grading Rubric',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addCriterion,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._criteria.asMap().entries.map((e) => _criterionRow(e.key, e.value)),
          ],
        ),
      ),
    );
  }

  Widget _criterionRow(int index, RubricCriterion c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: c.description,
              onChanged: (v) => _updateDescription(index, v),
              decoration: const InputDecoration(
                hintText: 'Criterion description',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: c.weight.toStringAsFixed(1),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateWeight(index, double.tryParse(v) ?? c.weight),
              decoration: const InputDecoration(
                suffixText: '%',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _removeCriterion(index),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
