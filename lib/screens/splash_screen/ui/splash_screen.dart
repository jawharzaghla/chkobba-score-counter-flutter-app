import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../controller/splash_controller.dart';
import 'animated_logo.dart';

/// Écran de splash principal de l'application.
///
/// Cet écran affiche le logo animé, un sous-titre et un indicateur
/// de chargement pendant que l'application initialise les services
/// (stockage, audio, chargement des paramètres) via [SplashController].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // On attend la fin de la première frame avant de lancer
    // l'initialisation pour garantir que le contexte est prêt
    // pour la navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SplashController.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedLogo(),
            const SizedBox(height: 16),
            // Sous-titre simple indiquant la fonction de l'application.
            Text(
              'Score Counter',
              style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white70,
                  ) ??
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 24),
            // Petit indicateur de progression pour suggérer
            // que l'application termine sa préparation.
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
