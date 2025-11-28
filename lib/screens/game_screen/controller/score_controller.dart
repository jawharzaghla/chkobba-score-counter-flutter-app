import '../../../models/player.dart';

/// Contrôleur chargé de la logique de gestion des scores.
///
/// Cette classe est "pure" (pas de ChangeNotifier) et peut donc être
/// utilisée facilement depuis n'importe quel contrôleur ou service.
/// Elle encapsule :
/// - l'historique des scores pour l'undo
/// - les règles d'incrémentation / décrémentation
/// - la validation d'un score saisi manuellement
class ScoreController {
  /// Historique des scores précédents pour permettre l'undo.
  ///
  /// Chaque entrée peut représenter un état précédent, par exemple :
  /// `{ 'score': ancienScore }`.
  final List<Map<String, int>> _history = [];

  /// Score maximal à atteindre pour considérer un joueur comme gagnant.
  final int _maxScore;

  /// Crée un contrôleur de score pour une partie donnée.
  ///
  /// [maxScore] représente la limite de score utilisée pour la
  /// détection de victoire.
  ScoreController({required int maxScore}) : _maxScore = maxScore;

  /// Retourne le score maximal configuré.
  int get maxScore => _maxScore;

  /// Retourne une copie immuable de l'historique actuel.
  List<Map<String, int>> get history => List.unmodifiable(_history);

  /// Sauvegarde l'état actuel du score du joueur dans l'historique.
  void _saveState(Player player) {
    _history.add({'score': player.score});
  }

  /// Incrémente le score du joueur de +1.
  ///
  /// Étapes :
  /// 1. Sauvegarder le score actuel dans l'historique.
  /// 2. Créer un nouveau [Player] avec le score augmenté.
  /// 3. (Optionnel) Vérifier si le joueur a atteint le score maximal
  ///    via [checkWinner].
  ///
  /// Exemple d'utilisation :
  /// ```dart
  /// final controller = ScoreController(maxScore: 21);
  /// player = controller.incrementScore(player);
  /// if (controller.checkWinner(player.score)) {
  ///   // Gérer la victoire
  /// }
  /// ```
  Player incrementScore(Player player) {
    _saveState(player);
    final newScore = player.score + 1;
    final updated = player.copyWith(score: newScore);
    return updated;
  }

  /// Décrémente le score du joueur de -1 sans passer en dessous de 0.
  ///
  /// Comme pour [incrementScore], l'état précédent est sauvegardé dans
  /// l'historique avant modification.
  Player decrementScore(Player player) {
    _saveState(player);
    final newScore = player.score > 0 ? player.score - 1 : 0;
    final updated = player.copyWith(score: newScore);
    return updated;
  }

  /// Définit directement le score du joueur (édition manuelle).
  ///
  /// La valeur [newScore] est acceptée uniquement si elle se situe dans
  /// l'intervalle `0 <= newScore <= maxScore + 10` afin de tolérer
  /// certains ajustements manuels au-delà de la limite de victoire.
  /// L'état précédent est sauvegardé dans l'historique.
  Player setScore(Player player, int newScore) {
    if (newScore < 0 || newScore > _maxScore + 10) {
      // On refuse silencieusement la mise à jour et retourne le joueur tel quel.
      return player;
    }

    _saveState(player);
    final updated = player.copyWith(score: newScore);
    return updated;
  }

  /// Annule la dernière modification de score.
  ///
  /// Retourne la dernière entrée de l'historique (par exemple
  /// `{ 'score': ancienScore }`) et la retire de la liste.
  ///
  /// Si l'historique est vide, retourne `null`.
  Map<String, int>? undo() {
    if (_history.isEmpty) {
      return null;
    }
    return _history.removeLast();
  }

  /// Efface complètement l'historique des scores.
  void clearHistory() {
    _history.clear();
  }

  /// Vérifie si un score donné correspond à une victoire.
  ///
  /// Retourne `true` si [score] est supérieur ou égal à [_maxScore].
  bool checkWinner(int score) => score >= _maxScore;
}
