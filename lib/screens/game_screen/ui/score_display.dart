import 'package:flutter/material.dart';

/// Widget d'affichage du score d'un joueur.
///
/// Utilise un [AnimatedSwitcher] pour animer en douceur la transition
/// lorsque le score change (fade + légère transition de taille).
class ScoreDisplay extends StatelessWidget {
  /// Valeur numérique du score à afficher.
  final int score;

  /// Couleur optionnelle du texte du score.
  final Color? color;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? theme.colorScheme.primary,
        ) ??
        TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: color ?? theme.colorScheme.primary,
        );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: (color ?? theme.colorScheme.primary).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              // Combinaison d'un fondu et d'une légère mise à l'échelle
              // pour rendre la mise à jour du score plus vivante.
              return ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            // La clé dépend de la valeur du score afin que l'AnimatedSwitcher
            // détecte les changements et déclenche l'animation.
            child: Text(
              '$score',
              key: ValueKey<int>(score),
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
