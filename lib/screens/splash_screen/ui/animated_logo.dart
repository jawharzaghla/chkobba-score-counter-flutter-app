import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

/// Logo animé affiché sur l'écran de splash.
///
/// L'animation combine :
/// - un fondu d'opacité (de 0 à 1)
/// - un effet de zoom léger (scale de 0.5 à 1.0)
/// sur une durée d'environ 1 seconde pour donner
/// une impression d'apparition douce et dynamique.
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    // On déclenche l'animation après la première frame
    // pour éviter les effets de clignotement.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: _opacity,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        // On applique un scale via une transformation.
        transform: Matrix4.identity()..scale(_scale, _scale),
        child: _buildLogo(theme),
      ),
    );
  }

  /// Construit le contenu du logo.
  ///
  /// Si une image est disponible, on peut utiliser [AssetPaths.logo].
  /// Ici, on affiche un texte stylisé "Chkobba" en attendant le logo.
  Widget _buildLogo(ThemeData theme) {
    return Text(
      AppStrings.appName,
      style: theme.textTheme.displayMedium?.copyWith(
            color: Colors.white,
          ) ??
          const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );
  }
}
