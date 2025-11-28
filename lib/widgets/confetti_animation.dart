import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Widget d'animation de confettis pour célébrer une victoire.
///
/// Ce widget est conçu pour être superposé (overlay) au-dessus d'un autre
/// contenu via un [Stack]. Il gère en interne un [ConfettiController]
/// avec une durée fixe de 3 secondes.
class ConfettiAnimation extends StatefulWidget {
  /// Indique si l'animation de confettis doit être en cours.
  ///
  /// Lorsque cette valeur passe à `true`, le contrôleur démarre
  /// une explosion de confettis pendant une durée prédéfinie.
  final bool isPlaying;

  /// Callback optionnel appelé lorsque l'animation se termine.
  final VoidCallback? onComplete;

  const ConfettiAnimation({
    super.key,
    required this.isPlaying,
    this.onComplete,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    // Contrôleur configuré pour jouer pendant 3 secondes.
    _controller = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // On écoute la fin de l'animation pour déclencher éventuellement
    // le callback [onComplete].
    _controller.addListener(_handleControllerUpdate);

    // Si le widget est initialisé avec isPlaying = true, on démarre aussitôt.
    if (widget.isPlaying) {
      _controller.play();
    }
  }

  /// Réagit aux changements du contrôleur pour savoir quand l'animation
  /// est terminée.
  void _handleControllerUpdate() {
    if (_controller.state == ConfettiControllerState.stopped &&
        widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la valeur de isPlaying change, on démarre ou arrête l'animation.
    if (!oldWidget.isPlaying && widget.isPlaying) {
      _controller.play();
    } else if (oldWidget.isPlaying && !widget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Le widget occupe tout l'espace disponible pour permettre
    // un effet visuel couvrant l'écran ou la zone du jeu.
    return IgnorePointer(
      // Empêche l'overlay de bloquer les interactions avec le contenu dessous.
      ignoring: true,
      child: Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          // Explosion dans toutes les directions.
          shouldLoop: false,
          // Couleurs chaleureuses adaptées au thème de cartes.
          colors: const [
            Color(0xFFFFD700), // Or
            Color(0xFF8B0000), // Rouge bordeaux
            Colors.white, // Blanc pour le contraste
          ],
          numberOfParticles: 30,
          gravity: 0.4,
          emissionFrequency: 0.8,
        ),
      ),
    );
  }
}
