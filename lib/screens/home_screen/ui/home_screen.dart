import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../controller/home_controller.dart';

/// Écran d'accueil principal de l'application.
///
/// Nouveau design sans AppBar, avec :
/// - un en-tête orange contenant le logo et le titre
/// - une icône d'accès aux paramètres en haut à droite
/// - un grand bouton circulaire "play" animé au centre.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    // Animation souple de mise à l'échelle pour le bouton "play".
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.98,
      upperBound: 1.02,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // En-tête orange avec logo + titre.
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orangeGradientStart,
                      AppColors.orangeGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetPaths.logo,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Chkobba Score Counter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Contenu principal avec bouton "play" circulaire.
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleController,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => HomeController.navigateToGame(context),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Icône de paramètres positionnée en haut à droite.
          Positioned(
            top: topPadding + 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: () => HomeController.navigateToSettings(context),
            ),
          ),
        ],
      ),
    );
  }
}
