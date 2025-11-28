import 'player.dart';

/// Représente l'état complet d'une partie de Chkobba.
///
/// Cette classe centralise toutes les informations nécessaires pour
/// reprendre une partie : joueurs, score maximum, historique, etc.
class GameState {
  /// Joueur 1 de la partie.
  final Player player1;

  /// Joueur 2 de la partie.
  final Player player2;

  /// Score maximal à atteindre pour gagner la partie (21 par défaut).
  final int maxScore;

  /// Historique des scores précédents pour permettre l'annulation (undo).
  ///
  /// Chaque entrée de la liste peut par exemple contenir :
  /// `{ 'player1': scoreJoueur1, 'player2': scoreJoueur2 }`.
  final List<Map<String, int>> scoreHistory;

  /// Heure de début de la partie (peut être null si non encore démarrée).
  final DateTime? startTime;

  /// Nom du gagnant de la partie, ou null si personne n'a encore gagné.
  final String? winner;

  /// Constructeur avec valeurs par défaut raisonnables pour une nouvelle partie.
  const GameState({
    this.player1 = const Player(name: 'Joueur 1'),
    this.player2 = const Player(name: 'Joueur 2'),
    this.maxScore = 21,
    this.scoreHistory = const [],
    this.startTime,
    this.winner,
  });

  /// Crée une nouvelle instance de [GameState] en copiant l'état actuel
  /// et en appliquant uniquement les modifications fournies.
  ///
  /// Très utile pour gérer un état immuable dans des architectures
  /// comme Provider, Riverpod, etc.
  GameState copyWith({
    Player? player1,
    Player? player2,
    int? maxScore,
    List<Map<String, int>>? scoreHistory,
    DateTime? startTime,
    String? winner,
  }) {
    return GameState(
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      maxScore: maxScore ?? this.maxScore,
      scoreHistory: scoreHistory ?? this.scoreHistory,
      startTime: startTime ?? this.startTime,
      winner: winner ?? this.winner,
    );
  }

  /// Convertit l'état de la partie en une carte JSON sérialisable.
  ///
  /// Permet par exemple de sauvegarder l'état en local pour pouvoir
  /// reprendre la partie plus tard.
  Map<String, dynamic> toJson() {
    return {
      'player1': player1.toJson(),
      'player2': player2.toJson(),
      'maxScore': maxScore,
      'scoreHistory': scoreHistory
          .map((entry) => <String, int>{
                'player1': entry['player1'] ?? 0,
                'player2': entry['player2'] ?? 0,
              })
          .toList(),
      'startTime': startTime?.toIso8601String(),
      'winner': winner,
    };
  }

  /// Construit un [GameState] à partir d'une carte JSON.
  ///
  /// Cette méthode est l'inverse de [toJson] et permet de restaurer
  /// une partie sauvegardée.
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      player1: Player.fromJson(json['player1'] as Map<String, dynamic>),
      player2: Player.fromJson(json['player2'] as Map<String, dynamic>),
      maxScore: json['maxScore'] as int? ?? 21,
      scoreHistory: (json['scoreHistory'] as List<dynamic>? ?? [])
          .map((e) => Map<String, int>.from(e as Map))
          .toList(),
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'] as String)
          : null,
      winner: json['winner'] as String?,
    );
  }

  /// Réinitialise complètement l'état de la partie.
  ///
  /// - Les deux joueurs retrouvent un score à zéro.
  /// - L'historique des scores est vidé.
  /// - L'heure de départ et le gagnant sont supprimés.
  GameState reset() {
    return GameState(
      player1: Player(name: player1.name),
      player2: Player(name: player2.name),
      maxScore: maxScore,
      scoreHistory: const [],
      startTime: null,
      winner: null,
    );
  }
}
