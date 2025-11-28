import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/haptic_service.dart';

/// Interrupteur personnalisé réutilisable.
///
/// Ce widget encapsule un [Switch] standard tout en ajoutant :
/// - un label optionnel
/// - une icône optionnelle
/// - un feedback haptique lors du changement
/// - un son subtil via [AudioService]
class CustomSwitch extends StatelessWidget {
  /// Valeur actuelle de l'interrupteur.
  final bool value;

  /// Callback appelé lorsqu'une nouvelle valeur est sélectionnée.
  final ValueChanged<bool> onChanged;

  /// Label optionnel affiché à gauche (ou à côté) du switch.
  final String? label;

  /// Icône optionnelle affichée avant le label.
  final IconData? icon;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.icon,
  });

  /// Gère le changement d'état avec son + haptique avant de
  /// propager la nouvelle valeur via [onChanged].
  Future<void> _handleChanged(bool newValue) async {
    // Feedback haptique léger pour indiquer le changement.
    await HapticService().selectionClick();
    // Son très discret (on réutilise ici le son de tap).
    await AudioService().playTap();
    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.secondary;

    final switchWidget = Switch(
      value: value,
      onChanged: (newValue) {
        _handleChanged(newValue);
      },
      activeColor: activeColor,
      activeTrackColor: activeColor.withOpacity(0.4),
    );

    // Si aucun label ni icône, on retourne simplement le switch.
    if (label == null && icon == null) {
      return switchWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: theme.colorScheme.onBackground),
          const SizedBox(width: 8),
        ],
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(width: 8),
        ],
        switchWidget,
      ],
    );
  }
}
