import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../controller/splash_controller.dart';

/// Écran de splash principal de l'application.
///
/// Affiche un fond d'écran, un overlay semi-transparent, puis
/// le logo et le titre de l'application avec une animation
/// de fondu. Pendant ce temps, [SplashController] initialise
/// les services et navigue automatiquement vers l'écran d'accueil.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Contrôleur pour l'animation de fondu du contenu central.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Démarre l'animation dès que possible.
    _fadeController.forward();

    // On attend la fin de la première frame avant de lancer
    // l'initialisation pour garantir que le contexte est prêt
    // pour la navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SplashController.init(context);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond plein écran.
          Image.asset(
            AssetPaths.splashBg,
            fit: BoxFit.cover,
          ),

          // Overlay semi-transparent pour améliorer la lisibilité.
          Container(
            color: AppColors.darkBlue.withOpacity(0.7),
          ),

          // Contenu central avec animation de fondu.
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AssetPaths.logo,
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Chkobba Score Counter',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
