import 'package:flutter/foundation.dart';

/// Représente un joueur avec son nom, son score actuel et le nombre de parties gagnées.
class Player {
  /// Nom du joueur (par défaut "Joueur 1" ou "Joueur 2" selon le contexte d'utilisation).
  final String name;

  /// Score actuel du joueur pour la partie en cours.
  final int score;

  /// Nombre total de parties gagnées par ce joueur.
  final int gamesWon;

  /// Constructeur avec paramètres nommés et valeurs par défaut.
  ///
  /// [name] permet d'identifier le joueur dans l'interface.
  /// [score] représente le score courant (0 par défaut).
  /// [gamesWon] stocke le nombre de victoires (0 par défaut).
  const Player({
    this.name = 'Joueur 1',
    this.score = 0,
    this.gamesWon = 0,
  });

  /// Crée une nouvelle instance de [Player] en copiant cet objet
  /// et en modifiant uniquement les champs fournis.
  ///
  /// Cela permet de garder l'objet immuable tout en appliquant
  /// des changements ciblés (pratique avec des architectures réactives).
  Player copyWith({
    String? name,
    int? score,
    int? gamesWon,
  }) {
    return Player(
      name: name ?? this.name,
      score: score ?? this.score,
      gamesWon: gamesWon ?? this.gamesWon,
    );
  }

  /// Convertit l'objet [Player] en une carte JSON sérialisable.
  ///
  /// Utile pour sauvegarder les données en local (SharedPreferences, fichiers, etc.).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'gamesWon': gamesWon,
    };
  }

  /// Construit un objet [Player] à partir d'une carte JSON.
  ///
  /// Cette méthode est l'inverse de [toJson] et permet de recréer
  /// l'état d'un joueur à partir de données persistées.
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String? ?? 'Joueur 1',
      score: json['score'] as int? ?? 0,
      gamesWon: json['gamesWon'] as int? ?? 0,
    );
  }

  @override
  String toString() => 'Player(name: $name, score: $score, gamesWon: $gamesWon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.name == name &&
        other.score == score &&
        other.gamesWon == gamesWon;
  }

  @override
  int get hashCode => Object.hash(name, score, gamesWon);
}
