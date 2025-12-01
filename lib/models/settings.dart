/// Représente les paramètres généraux de l'application.
///
/// Cette classe permet de sauvegarder les préférences de l'utilisateur
/// comme le score maximum, l'activation du son, le thème sombre, etc.
class Settings {
  /// Score maximal par défaut pour gagner une partie (21).
  final int maxScore;

  /// Indique si les effets sonores sont activés (true par défaut).
  final bool soundEnabled;

  /// Indique si le thème sombre est activé (false par défaut).
  final bool darkMode;

  /// Volume global de l'application (entre 0.0 et 1.0, 0.5 par défaut).
  final double volume;

  /// Indique si les retours haptiques (vibrations) sont activés (true par défaut).
  final bool hapticsEnabled;

  /// Constructeur avec valeurs par défaut adaptées à une première utilisation.
  const Settings({
    this.maxScore = 21,
    this.soundEnabled = true,
    this.darkMode = false,
    this.volume = 0.5,
    this.hapticsEnabled = true,
  });

  /// Crée une nouvelle instance de [Settings] en copiant l'objet courant
  /// et en remplaçant uniquement les champs fournis.
  ///
  /// Permet de mettre à jour les préférences de manière immuable.
  Settings copyWith({
    int? maxScore,
    bool? soundEnabled,
    bool? darkMode,
    double? volume,
    bool? hapticsEnabled,
  }) {
    return Settings(
      maxScore: maxScore ?? this.maxScore,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      darkMode: darkMode ?? this.darkMode,
      volume: volume ?? this.volume,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  /// Convertit les paramètres en une carte JSON sérialisable.
  ///
  /// Cette méthode est utilisée pour stocker les préférences
  /// dans un système de persistance (SharedPreferences, fichiers, etc.).
  Map<String, dynamic> toJson() {
    return {
      'maxScore': maxScore,
      'soundEnabled': soundEnabled,
      'darkMode': darkMode,
      'volume': volume,
      'hapticsEnabled': hapticsEnabled,
    };
  }

  /// Crée une instance de [Settings] à partir d'une carte JSON.
  ///
  /// Cette méthode permet de restaurer les préférences sauvegardées
  /// précédemment par [toJson].
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      maxScore: json['maxScore'] as int? ?? 21,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.5,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
    );
  }
}
