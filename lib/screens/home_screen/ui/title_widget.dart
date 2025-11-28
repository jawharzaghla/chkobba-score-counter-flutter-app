import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

/// Widget d'en-tête pour l'écran d'accueil.
///
/// Affiche le titre principal "Chkobba" et le sous-titre
/// "Score Counter" avec un style élégant inspiré d'un jeu de cartes.
class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Titre principal de l'application.
        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayMedium?.copyWith(
                color: colorScheme.secondary,
                shadows: const [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ) ??
              const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDAA520),
              ),
        ),
        const SizedBox(height: 8),
        // Sous-titre décrivant la fonction de l'application.
        Text(
          'Score Counter',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.8),
              ) ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}
