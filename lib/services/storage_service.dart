import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';
import '../models/settings.dart';

/// Service responsable de la persistance des données de l'application.
///
/// Cette classe utilise le pattern *singleton* pour fournir une
/// unique instance de service dans toute l'application. Elle gère :
/// - la sauvegarde et le chargement de l'état de jeu [GameState]
/// - la sauvegarde et le chargement des paramètres [Settings]
class StorageService {
  /// Instance unique du service (singleton).
  static final StorageService _instance = StorageService._internal();

  /// Factory qui retourne toujours la même instance.
  factory StorageService() => _instance;

  /// Constructeur interne privé utilisé uniquement par le singleton.
  StorageService._internal();

  /// Référence vers [SharedPreferences] une fois initialisée.
  SharedPreferences? _prefs;

  // Clés de stockage utilisées dans SharedPreferences
  static const String _keyGameState = 'game_state';
  static const String _keySettings = 'settings';

  /// Initialise le service et charge l'instance de [SharedPreferences].
  ///
  /// Cette méthode doit être appelée une seule fois au démarrage de
  /// l'application (par exemple dans `main` avant de lancer l'UI).
  Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      // Log pour confirmer l'initialisation.
      // Utilisation de print pour un debug simple.
      print('[StorageService] SharedPreferences initialisé');
    } catch (e, stack) {
      // Gestion d'erreur simple avec log en console.
      print('[StorageService] Erreur lors de l\'initialisation: $e');
      print(stack);
    }
  }

  /// Sauvegarde l'état courant de la partie dans les préférences.
  ///
  /// L'objet [GameState] est d'abord converti en JSON, puis stocké
  /// sous forme de chaîne de caractères.
  Future<void> saveGameState(GameState state) async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) return;

      final jsonString = jsonEncode(state.toJson());
      final success = await prefs.setString(_keyGameState, jsonString);
      print('[StorageService] saveGameState -> success=$success');
    } catch (e, stack) {
      print('[StorageService] Erreur lors de saveGameState: $e');
      print(stack);
    }
  }

  /// Charge le dernier état de jeu sauvegardé.
  ///
  /// Retourne :
  /// - un objet [GameState] si des données valides sont trouvées,
  /// - `null` si aucune donnée n'est disponible ou en cas d'erreur.
  Future<GameState?> loadGameState() async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) return null;

      final jsonString = prefs.getString(_keyGameState);
      if (jsonString == null) {
        print('[StorageService] loadGameState -> aucune donnée trouvée');
        return null;
      }

      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final state = GameState.fromJson(jsonMap);
      print('[StorageService] loadGameState -> état chargé avec succès');
      return state;
    } catch (e, stack) {
      print('[StorageService] Erreur lors de loadGameState: $e');
      print(stack);
      return null;
    }
  }

  /// Sauvegarde les paramètres utilisateur.
  ///
  /// L'objet [Settings] est sérialisé en JSON puis stocké en chaîne.
  Future<void> saveSettings(Settings settings) async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) return;

      final jsonString = jsonEncode(settings.toJson());
      final success = await prefs.setString(_keySettings, jsonString);
      print('[StorageService] saveSettings -> success=$success');
    } catch (e, stack) {
      print('[StorageService] Erreur lors de saveSettings: $e');
      print(stack);
    }
  }

  /// Charge les paramètres utilisateur.
  ///
  /// Si aucune donnée n'est disponible ou si une erreur survient,
  /// cette méthode retourne un objet [Settings] avec les valeurs
  /// par défaut définies dans son constructeur.
  Future<Settings> loadSettings() async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) {
        return const Settings();
      }

      final jsonString = prefs.getString(_keySettings);
      if (jsonString == null) {
        print('[StorageService] loadSettings -> aucune donnée, valeurs par défaut');
        return const Settings();
      }

      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = Settings.fromJson(jsonMap);
      print('[StorageService] loadSettings -> paramètres chargés avec succès');
      return settings;
    } catch (e, stack) {
      print('[StorageService] Erreur lors de loadSettings: $e');
      print(stack);
      return const Settings();
    }
  }

  /// Efface uniquement l'état de jeu sauvegardé.
  ///
  /// Utile par exemple lors d'un reset complet de la partie
  /// sans perdre les préférences de l'utilisateur.
  Future<void> clearGameState() async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) return;

      final success = await prefs.remove(_keyGameState);
      print('[StorageService] clearGameState -> success=$success');
    } catch (e, stack) {
      print('[StorageService] Erreur lors de clearGameState: $e');
      print(stack);
    }
  }

  /// Efface toutes les données sauvegardées par l'application.
  ///
  /// Attention : cette méthode supprime à la fois l'état de jeu et
  /// les paramètres utilisateur.
  Future<void> clearAll() async {
    try {
      if (_prefs == null) {
        await init();
      }
      final prefs = _prefs;
      if (prefs == null) return;

      final success = await prefs.clear();
      print('[StorageService] clearAll -> success=$success');
    } catch (e, stack) {
      print('[StorageService] Erreur lors de clearAll: $e');
      print(stack);
    }
  }
}
