import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../services/haptic_service.dart';

/// Slider permettant de choisir le score maximum d'une partie.
class MaxScoreSlider extends StatefulWidget {
  /// Valeur actuelle du score maximum.
  final int currentValue;

  /// Callback appelé lorsqu'une nouvelle valeur est sélectionnée.
  final ValueChanged<int> onChanged;

  const MaxScoreSlider({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<MaxScoreSlider> createState() => _MaxScoreSliderState();
}

class _MaxScoreSliderState extends State<MaxScoreSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Maximum : ${_value.round()}',
          style: theme.textTheme.titleLarge,
        ),
        Slider(
          value: _value.clamp(
            AppConstants.minScore.toDouble(),
            AppConstants.maxScoreLimit.toDouble(),
          ),
          min: AppConstants.minScore.toDouble(),
          max: AppConstants.maxScoreLimit.toDouble(),
          divisions: AppConstants.maxScoreLimit - AppConstants.minScore,
          label: _value.round().toString(),
          onChanged: (newValue) async {
            setState(() {
              _value = newValue;
            });
            // Feedback haptique léger pour signaler le changement.
            await HapticService().selectionClick();
            widget.onChanged(_value.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppConstants.minScore.toString(),
              style: theme.textTheme.bodySmall,
            ),
            Text(
              AppConstants.maxScoreLimit.toString(),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
