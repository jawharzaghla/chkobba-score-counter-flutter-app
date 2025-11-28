import 'package:flutter/material.dart';

/// Ensemble de boutons d'action pour contrôler le score d'un joueur.
///
/// Comprend trois actions principales :
/// - décrémenter le score (-1)
/// - éditer le score manuellement
/// - incrémenter le score (+1)
class ActionButtons extends StatelessWidget {
  /// Callback appelé lorsque l'utilisateur appuie sur le bouton +1.
  final VoidCallback onIncrement;

  /// Callback appelé lorsque l'utilisateur appuie sur le bouton -1.
  final VoidCallback onDecrement;

  /// Callback appelé lorsque l'utilisateur souhaite éditer le score.
  final VoidCallback onEdit;

  const ActionButtons({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(
          context: context,
          icon: Icons.remove,
          color: Colors.redAccent,
          onPressed: onDecrement,
        ),
        const SizedBox(width: 16),
        _buildCircleButton(
          context: context,
          icon: Icons.edit,
          color: Colors.orangeAccent,
          onPressed: onEdit,
        ),
        const SizedBox(width: 16),
        _buildCircleButton(
          context: context,
          icon: Icons.add,
          color: Colors.green,
          onPressed: onIncrement,
        ),
      ],
    );
  }

  /// Construit un bouton circulaire avec une icône centrée.
  ///
  /// La taille est volontairement généreuse (minimum 56x56) pour offrir
  /// une bonne ergonomie sur mobile.
  Widget _buildCircleButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
