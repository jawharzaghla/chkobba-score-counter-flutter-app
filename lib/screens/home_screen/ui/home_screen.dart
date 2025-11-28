import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../controller/home_controller.dart';
import 'menu_button.dart';
import 'title_widget.dart';

/// Écran d'accueil principal de l'application.
///
/// Affiche le titre du jeu et deux boutons de menu permettant
/// d'accéder rapidement à la partie ou aux paramètres.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chkobba'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Container(
        // Optionnel : léger dégradé de fond pour donner plus de profondeur.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.background,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(),
                // Titre de l'application (logo + sous-titre).
                const TitleWidget(),
                const SizedBox(height: 60),
                // Bouton pour démarrer ou reprendre une partie.
                MenuButton(
                  text: AppStrings.newGame,
                  icon: Icons.play_arrow,
                  onPressed: () => HomeController.navigateToGame(context),
                ),
                const SizedBox(height: 20),
                // Bouton pour accéder aux paramètres.
                MenuButton(
                  text: AppStrings.settings,
                  icon: Icons.settings,
                  onPressed: () => HomeController.navigateToSettings(context),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
