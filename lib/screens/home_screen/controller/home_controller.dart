import 'package:flutter/material.dart';

import '../../../models/game_state.dart';
import '../../../screens/game_screen/ui/game_screen.dart';
import '../../../screens/settings_screen/ui/settings_screen.dart';
import '../../../services/audio_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/constants.dart';

/// Contrôleur de l'écran d'accueil.
///
/// Cette classe regroupe la logique de navigation depuis le HomeScreen
/// vers les autres écrans principaux (jeu, paramètres), tout en
/// déclenchant les effets sonores et haptiques appropriés.
class HomeController {
  HomeController._();

  /// Navigue vers l'écran de jeu.
  ///
  /// Étapes :
  /// 1. Jouer un léger son de tap et un feedback haptique.
  /// 2. Tenter de charger un [GameState] sauvegardé.
  /// 3. Si aucun état n'est trouvé, créer un nouvel état par défaut.
  /// 4. Naviguer vers l'écran de jeu via [Navigator.pushNamed].
  static Future<void> navigateToGame(BuildContext context) async {
    try {
      // 1. Effets de feedback immédiats.
      await AudioService().playTap();
      await HapticService().selectionClick();

      // 2. Chargement éventuel de l'état de jeu.
      print('[HomeController] Chargement du GameState sauvegardé...');
      GameState? state = await StorageService().loadGameState();

      // 3. Si aucun état n'est disponible, on en crée un nouveau par défaut.
      state ??= const GameState();
      print('[HomeController] GameState prêt pour la navigation');

      if (!context.mounted) return;

      // 4. Navigation vers l'écran de jeu avec une transition de slide.
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e, stack) {
      print('[HomeController] Erreur lors de navigateToGame: $e');
      print(stack);

      // En cas d'erreur, on peut afficher un SnackBar informatif.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir la partie. Veuillez réessayer.'),
          ),
        );
      }
    }
  }

  /// Navigue vers l'écran des paramètres.
  ///
  /// Étapes :
  /// 1. Jouer un léger son de tap et un feedback haptique.
  /// 2. Naviguer vers l'écran des paramètres.
  static Future<void> navigateToSettings(BuildContext context) async {
    try {
      await AudioService().playTap();
      await HapticService().selectionClick();

      if (!context.mounted) return;

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SettingsScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e, stack) {
      print('[HomeController] Erreur lors de navigateToSettings: $e');
      print(stack);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Impossible d\'ouvrir les paramètres. Veuillez réessayer.'),
          ),
        );
      }
    }
  }
}
