import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';

/// Bouton de menu réutilisable pour l'écran d'accueil.
///
/// Ce widget encapsule un [CustomButton] avec une mise en forme
/// adaptée pour un menu (icône + texte alignés sur une ligne).
class MenuButton extends StatelessWidget {
  /// Texte du bouton (par exemple "Nouvelle Partie").
  final String text;

  /// Icône affichée à gauche du texte.
  final IconData icon;

  /// Callback déclenché lors de l'appui sur le bouton.
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        // On laisse CustomButton gérer la couleur primaire du thème.
        backgroundColor: theme.colorScheme.surface,
        textColor: theme.colorScheme.onSurface,
        // On simule un "card button" en utilisant le mode outlined
        // avec une légère surélévation visuelle.
        isOutlined: false,
        height: 56,
      ),
    );
  }
}
