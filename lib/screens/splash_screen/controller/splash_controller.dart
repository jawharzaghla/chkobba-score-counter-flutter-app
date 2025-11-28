import 'package:flutter/material.dart';

import '../../../models/settings.dart';
import '../../../services/audio_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/constants.dart';

/// Contrôleur responsable de la logique de l'écran de splash.
///
/// Cette classe n'est pas un widget. Elle regroupe la logique
/// d'initialisation de l'application (services, paramètres) et la
/// navigation vers l'écran d'accueil après l'animation de splash.
class SplashController {
  SplashController._();

  /// Méthode d'initialisation appelée depuis le SplashScreen.
  ///
  /// Étapes :
  /// 1. Initialiser les services de stockage et audio.
  /// 2. Charger les paramètres persistés ([Settings]).
  /// 3. Attendre la fin de l'animation de splash.
  /// 4. Naviguer vers l'écran d'accueil.
  static Future<void> init(BuildContext context) async {
    try {
      print('[SplashController] Initialisation du splash...');

      // 1. Initialisation des services de base.
      await StorageService().init();
      await AudioService().init();
      print('[SplashController] Services initiaux prêts');

      // 2. Chargement des paramètres utilisateur.
      final Settings settings = await StorageService().loadSettings();
      print('[SplashController] Settings chargés: ');
      print(
          '  maxScore=${settings.maxScore}, soundEnabled=${settings.soundEnabled}, darkMode=${settings.darkMode}, volume=${settings.volume}',
      );

      // TODO: connecter ces paramètres à un provider ou un state global
      // (par exemple pour appliquer le thème sombre et le volume global).

      // 3. Attendre la fin de l'animation de splash.
      print('[SplashController] Attente de la durée du splash...');
      await Future.delayed(AppConstants.splashDuration);

      // 4. Navigation vers l'écran d'accueil.
      print('[SplashController] Navigation vers HomeScreen');
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e, stack) {
      // Gestion centralisée des erreurs d'initialisation.
      print('[SplashController] Erreur lors de init: $e');
      print(stack);

      // En cas d'erreur, on tente quand même d'aller sur la Home
      // pour ne pas bloquer l'utilisateur sur le splash.
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    }
  }
}
