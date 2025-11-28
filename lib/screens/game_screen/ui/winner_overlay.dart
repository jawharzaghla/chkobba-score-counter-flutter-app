import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../widgets/confetti_animation.dart';

/// Overlay affiché lorsqu'un joueur remporte la partie.
///
/// Ce widget est pensé pour être placé dans un [Stack] au-dessus du
/// contenu principal du GameScreen. Il affiche :
/// - un fond semi-transparent
/// - une carte centrale avec le nom du gagnant
/// - un bouton pour fermer l'overlay
/// - une animation de confettis en arrière-plan.
class WinnerOverlay extends StatelessWidget {
  /// Nom du joueur gagnant.
  final String winnerName;

  /// Callback appelé lorsque l'utilisateur ferme l'overlay.
  final VoidCallback onDismiss;

  const WinnerOverlay({
    super.key,
    required this.winnerName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned.fill(
      child: IgnorePointer(
        // On laisse les interactions uniquement sur le contenu de la carte.
        ignoring: false,
        child: Container(
          color: Colors.black54, // Fond semi-transparent.
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animation de confettis pour célébrer la victoire.
              const ConfettiAnimation(isPlaying: true),

              // Carte centrale mettant en avant le gagnant.
              Center(
                child: Card(
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.winner,
                          style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          winnerName,
                          style: theme.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: onDismiss,
                            child: const Text('Continuer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
