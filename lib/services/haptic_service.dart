import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service responsable de la gestion des vibrations (retours haptiques).
///
/// Ce service fournit une API simple pour déclencher différents types
/// de feedback haptique (léger, moyen, fort, sélection) tout en
/// permettant de les activer/désactiver globalement.
class HapticService {
  /// Instance unique du service (singleton).
  static final HapticService _instance = HapticService._internal();

  /// Factory qui retourne toujours la même instance.
  factory HapticService() => _instance;

  /// Constructeur interne privé.
  HapticService._internal();

  /// Indique si les vibrations sont globalement activées.
  bool _hapticEnabled = true;

  /// Active ou désactive globalement les retours haptiques.
  ///
  /// Lorsque désactivé, aucune vibration ne sera déclenchée.
  void setEnabled(bool enabled) {
    _hapticEnabled = enabled;
    print('[HapticService] Haptique activé: $_hapticEnabled');
  }

  /// Retourne `true` si les vibrations sont actuellement activées.
  bool get isEnabled => _hapticEnabled;

  /// Vérifie si la plateforme supporte les retours haptiques.
  ///
  /// Sur le web ou certaines plateformes desktop, ces appels peuvent
  /// être ignorés. Cette méthode permet de centraliser la logique.
  bool get _isHapticSupported {
    if (kIsWeb) {
      return false;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  /// Déclenche un retour haptique léger (tap léger).
  Future<void> lightImpact() async {
    await _runHaptic(() => HapticFeedback.lightImpact(), 'lightImpact');
  }

  /// Déclenche un retour haptique moyen (action normale).
  Future<void> mediumImpact() async {
    await _runHaptic(() => HapticFeedback.mediumImpact(), 'mediumImpact');
  }

  /// Déclenche un retour haptique fort (victoire, reset, actions importantes).
  Future<void> heavyImpact() async {
    await _runHaptic(() => HapticFeedback.heavyImpact(), 'heavyImpact');
  }

  /// Déclenche un retour haptique de sélection (changement d'option).
  Future<void> selectionClick() async {
    await _runHaptic(() => HapticFeedback.selectionClick(), 'selectionClick');
  }

  /// Méthode générique pour exécuter un feedback haptique.
  ///
  /// - Vérifie d'abord si l'haptique est activé.
  /// - Vérifie ensuite si la plateforme est supportée.
  /// - Exécute enfin l'action fournie, en capturant les erreurs
  ///   éventuelles pour éviter de faire crasher l'application.
  Future<void> _runHaptic(Future<void> Function() action, String label) async {
    if (!_hapticEnabled) {
      print('[HapticService] Haptique désactivé, appel ignoré: $label');
      return;
    }

    if (!_isHapticSupported) {
      print('[HapticService] Haptique non supporté sur cette plateforme pour: $label');
      return;
    }

    try {
      await action();
      print('[HapticService] Feedback haptique exécuté: $label');
    } catch (e, stack) {
      print('[HapticService] Erreur lors du feedback haptique "$label": $e');
      print(stack);
    }
  }
}
