import 'package:flutter/foundation.dart';

import '../../../models/settings.dart';
import '../../../services/audio_service.dart';
import '../../../services/storage_service.dart';

/// Contrôleur des paramètres de l'application.
///
/// Cette classe suit le pattern Provider en étendant [ChangeNotifier].
/// Elle expose un objet [Settings] immuable vers l'UI et fournit
/// des méthodes pour mettre à jour chaque préférence tout en
/// assurant la persistance via [StorageService].
class SettingsController extends ChangeNotifier {
  /// Service de stockage utilisé pour persister les paramètres.
  final StorageService _storage = StorageService();

  /// État courant des paramètres (privé).
  Settings _settings = const Settings();

  /// Getter public pour exposer les paramètres à l'UI.
  Settings get settings => _settings;

  /// Constructeur : charge les paramètres depuis le stockage.
  ///
  /// Le chargement est déclenché de manière asynchrone afin de ne
  /// pas bloquer la création du contrôleur.
  SettingsController() {
    _init();
  }

  /// Initialisation interne : s'assure que le [StorageService] est
  /// prêt puis charge les paramètres existants.
  Future<void> _init() async {
    try {
      print('[SettingsController] Initialisation...');
      await _storage.init();
      await loadSettings();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de _init: $e');
      print(stack);
    }
  }

  /// Applique les paramètres courants aux services globaux.
  ///
  /// Actuellement, cela synchronise :
  /// - l'activation du son
  /// - le volume global de l'application
  Future<void> _applyToServices() async {
    try {
      await AudioService().setVolume(_settings.volume);
      AudioService().setSoundEnabled(_settings.soundEnabled);
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de _applyToServices: $e');
      print(stack);
    }
  }

  /// Charge les paramètres sauvegardés depuis le [StorageService].
  ///
  /// En cas d'erreur, conserve les valeurs par défaut et logue
  /// simplement l'exception.
  Future<void> loadSettings() async {
    try {
      print('[SettingsController] Chargement des paramètres...');
      final loaded = await _storage.loadSettings();
      _settings = loaded;
      // Applique les paramètres chargés aux services globaux
      // (par exemple le son).
      await _applyToServices();
      notifyListeners();
      print('[SettingsController] Paramètres chargés: '
          'maxScore=${_settings.maxScore}, '
          'soundEnabled=${_settings.soundEnabled}, '
          'darkMode=${_settings.darkMode}, '
          'volume=${_settings.volume}');
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de loadSettings: $e');
      print(stack);
    }
  }

  /// Met à jour le score maximal autorisé pour une partie.
  ///
  /// La nouvelle valeur est appliquée à [_settings], sauvegardée
  /// dans le stockage, puis les listeners sont notifiés.
  Future<void> updateMaxScore(int value) async {
    try {
      print('[SettingsController] updateMaxScore -> $value');
      _settings = _settings.copyWith(maxScore: value);
      await _storage.saveSettings(_settings);
      notifyListeners();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de updateMaxScore: $e');
      print(stack);
    }
  }

  /// Active ou désactive les effets sonores.
  Future<void> toggleSound(bool value) async {
    try {
      print('[SettingsController] toggleSound -> $value');
      _settings = _settings.copyWith(soundEnabled: value);
      await _storage.saveSettings(_settings);
      await _applyToServices();
      notifyListeners();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de toggleSound: $e');
      print(stack);
    }
  }

  /// Active ou désactive le mode sombre.
  Future<void> toggleDarkMode(bool value) async {
    try {
      print('[SettingsController] toggleDarkMode -> $value');
      _settings = _settings.copyWith(darkMode: value);
      await _storage.saveSettings(_settings);
      notifyListeners();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de toggleDarkMode: $e');
      print(stack);
    }
  }

  /// Met à jour le volume global de l'application.
  ///
  /// [value] doit être compris entre 0.0 et 1.0.
  Future<void> updateVolume(double value) async {
    try {
      final clamped = value.clamp(0.0, 1.0);
      print('[SettingsController] updateVolume -> $clamped');
      _settings = _settings.copyWith(volume: clamped);
      await _storage.saveSettings(_settings);
      await _applyToServices();
      notifyListeners();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de updateVolume: $e');
      print(stack);
    }
  }

  /// Réinitialise les statistiques et/ou paramètres liés au jeu.
  ///
  /// Ici, on peut décider de :
  /// - remettre les paramètres à leur valeur par défaut
  /// - effacer certaines données persistées spécifiques
  ///
  /// Pour l'instant, cette méthode remet simplement [Settings]
  /// à son état par défaut et sauvegarde le résultat.
  Future<void> resetStats() async {
    try {
      print('[SettingsController] resetStats');
      _settings = const Settings();
      await _storage.saveSettings(_settings);
      await _applyToServices();
      notifyListeners();
    } catch (e, stack) {
      print('[SettingsController] Erreur lors de resetStats: $e');
      print(stack);
    }
  }
}
