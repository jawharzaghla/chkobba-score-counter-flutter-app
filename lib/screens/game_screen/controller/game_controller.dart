import 'package:flutter/foundation.dart';

import '../../../models/game_state.dart';
import '../../../models/player.dart';
import '../../../services/audio_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/storage_service.dart';
import 'score_controller.dart';

/// Contrôleur principal de la logique de jeu.
///
/// Ce contrôleur étend [ChangeNotifier] afin de pouvoir être utilisé
/// facilement avec le pattern Provider. Il orchestre :
/// - l'état de la partie ([GameState])
/// - la logique de score via [ScoreController]
/// - la persistance via [StorageService]
/// - les effets sonores et haptiques.
class GameController extends ChangeNotifier {
  GameState _gameState = const GameState();
  late ScoreController _scoreController;

  final StorageService _storage = StorageService();
  final AudioService _audio = AudioService();
  final HapticService _haptic = HapticService();

  /// Indique si l'overlay de victoire doit être affiché.
  bool _showWinner = false;

  /// Expose l'état courant de la partie.
  GameState get gameState => _gameState;

  /// Indique si le joueur gagnant doit être affiché.
  bool get showWinner => _showWinner;

  GameController() {
    _scoreController = ScoreController(maxScore: _gameState.maxScore);
  }

  /// Charge une partie existante ou initialise une nouvelle partie.
  ///
  /// - Initialise les services de stockage et audio.
  /// - Tente de charger un [GameState] sauvegardé.
  /// - Si aucun état n'est trouvé, crée un état par défaut.
  /// - Met à jour le [ScoreController] avec le score max courant.
  Future<void> loadGame() async {
    try {
      print('[GameController] Chargement de la partie...');
      await _storage.init();
      await _audio.init();
      // On lit également les paramètres pour récupérer le score max choisi
      // par l'utilisateur dans l'écran des paramètres.
      final settings = await _storage.loadSettings();

      final loaded = await _storage.loadGameState();
      final baseState = loaded ?? const GameState();

      // On force le maxScore de la partie à refléter la valeur des Settings
      // afin que le slider de "Score Maximum" ait un impact réel sur le jeu.
      _gameState = baseState.copyWith(maxScore: settings.maxScore);
      _scoreController = ScoreController(maxScore: settings.maxScore);

      _showWinner = _gameState.winner != null;

      notifyListeners();
      print('[GameController] Partie chargée');
    } catch (e, stack) {
      print('[GameController] Erreur lors de loadGame: $e');
      print(stack);
    }
  }

  /// Sauvegarde automatiquement l'état courant de la partie.
  Future<void> _autoSave() async {
    try {
      await _storage.saveGameState(_gameState);
    } catch (e, stack) {
      print('[GameController] Erreur lors de _autoSave: $e');
      print(stack);
    }
  }

  /// Enregistre les scores actuels des deux joueurs dans l'historique
  /// de [GameState] pour permettre l'undo.
  void _pushHistory() {
    final current = <String, int>{
      'player1': _gameState.player1.score,
      'player2': _gameState.player2.score,
    };
    final newHistory = List<Map<String, int>>.from(_gameState.scoreHistory)
      ..add(current);
    _gameState = _gameState.copyWith(scoreHistory: newHistory);
  }

  /// Vérifie si un joueur a atteint le score de victoire et met à jour
  /// l'état en conséquence (gagnant, overlay, sons, haptique).
  Future<void> _checkVictory() async {
    try {
      final p1Score = _gameState.player1.score;
      final p2Score = _gameState.player2.score;

      String? winnerName;
      if (_scoreController.checkWinner(p1Score)) {
        winnerName = _gameState.player1.name;
      } else if (_scoreController.checkWinner(p2Score)) {
        winnerName = _gameState.player2.name;
      }

      if (winnerName != null) {
        _gameState = _gameState.copyWith(winner: winnerName);
        _showWinner = true;
        await _audio.playWin();
        await _haptic.heavyImpact();
        await _autoSave();
        notifyListeners();
      }
    } catch (e, stack) {
      print('[GameController] Erreur lors de _checkVictory: $e');
      print(stack);
    }
  }

  /// Incrémente le score du joueur 1.
  Future<void> incrementPlayer1Score() async {
    try {
      _pushHistory();
      _audio.playTap();
      _haptic.lightImpact();

      final updatedPlayer = _scoreController.incrementScore(_gameState.player1);
      _gameState = _gameState.copyWith(player1: updatedPlayer);

      await _autoSave();
      await _checkVictory();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de incrementPlayer1Score: $e');
      print(stack);
    }
  }

  /// Incrémente le score du joueur 2.
  Future<void> incrementPlayer2Score() async {
    try {
      _pushHistory();
      _audio.playTap();
      _haptic.lightImpact();

      final updatedPlayer = _scoreController.incrementScore(_gameState.player2);
      _gameState = _gameState.copyWith(player2: updatedPlayer);

      await _autoSave();
      await _checkVictory();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de incrementPlayer2Score: $e');
      print(stack);
    }
  }

  /// Décrémente le score du joueur 1.
  Future<void> decrementPlayer1Score() async {
    try {
      _pushHistory();
      _audio.playTap();
      _haptic.selectionClick();

      final updatedPlayer = _scoreController.decrementScore(_gameState.player1);
      _gameState = _gameState.copyWith(player1: updatedPlayer);

      await _autoSave();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de decrementPlayer1Score: $e');
      print(stack);
    }
  }

  /// Décrémente le score du joueur 2.
  Future<void> decrementPlayer2Score() async {
    try {
      _pushHistory();
      _audio.playTap();
      _haptic.selectionClick();

      final updatedPlayer = _scoreController.decrementScore(_gameState.player2);
      _gameState = _gameState.copyWith(player2: updatedPlayer);

      await _autoSave();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de decrementPlayer2Score: $e');
      print(stack);
    }
  }

  /// Met à jour manuellement le score du joueur 1.
  Future<void> editPlayer1Score(int newScore) async {
    try {
      _pushHistory();
      final updatedPlayer = _scoreController.setScore(_gameState.player1, newScore);
      _gameState = _gameState.copyWith(player1: updatedPlayer);

      _audio.playTap();
      _haptic.selectionClick();

      await _autoSave();
      await _checkVictory();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de editPlayer1Score: $e');
      print(stack);
    }
  }

  /// Met à jour manuellement le score du joueur 2.
  Future<void> editPlayer2Score(int newScore) async {
    try {
      _pushHistory();
      final updatedPlayer = _scoreController.setScore(_gameState.player2, newScore);
      _gameState = _gameState.copyWith(player2: updatedPlayer);

      _audio.playTap();
      _haptic.selectionClick();

      await _autoSave();
      await _checkVictory();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de editPlayer2Score: $e');
      print(stack);
    }
  }

  /// Annule la dernière modification de score.
  ///
  /// Utilise l'historique stocké dans [GameState.scoreHistory] pour
  /// restaurer les scores précédents des deux joueurs.
  Future<void> undo() async {
    try {
      if (_gameState.scoreHistory.isEmpty) {
        print('[GameController] undo -> aucun historique');
        return;
      }

      // On consomme la dernière entrée de l'historique.
      final newHistory = List<Map<String, int>>.from(_gameState.scoreHistory);
      final last = newHistory.removeLast();

      final p1Score = last['player1'] ?? _gameState.player1.score;
      final p2Score = last['player2'] ?? _gameState.player2.score;

      final updatedPlayer1 = _gameState.player1.copyWith(score: p1Score);
      final updatedPlayer2 = _gameState.player2.copyWith(score: p2Score);

      _gameState = _gameState.copyWith(
        player1: updatedPlayer1,
        player2: updatedPlayer2,
        scoreHistory: newHistory,
        winner: null,
      );
      _showWinner = false;

      // Appel optionnel au ScoreController pour garder ses structures internes
      // cohérentes si nécessaire.
      _scoreController.undo();

      _audio.playTap();
      _haptic.selectionClick();

      await _autoSave();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de undo: $e');
      print(stack);
    }
  }

  /// Réinitialise complètement la partie.
  ///
  /// - Remet les scores à zéro.
  /// - Vide l'historique.
  /// - Efface le gagnant éventuel.
  Future<void> reset() async {
    try {
      print('[GameController] reset');
      _gameState = _gameState.reset();
      _scoreController.clearHistory();
      _showWinner = false;

      await _audio.playReset();
      await _haptic.heavyImpact();

      await _autoSave();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de reset: $e');
      print(stack);
    }
  }

  /// Met à jour le nom d'un joueur.
  ///
  /// [isPlayer1] permet de savoir quel joueur mettre à jour.
  Future<void> editPlayerName(bool isPlayer1, String newName) async {
    try {
      print('[GameController] editPlayerName -> isPlayer1=$isPlayer1, newName=$newName');
      Player updatedPlayer;
      if (isPlayer1) {
        updatedPlayer = _gameState.player1.copyWith(name: newName);
        _gameState = _gameState.copyWith(player1: updatedPlayer);
      } else {
        updatedPlayer = _gameState.player2.copyWith(name: newName);
        _gameState = _gameState.copyWith(player2: updatedPlayer);
      }

      _audio.playTap();
      _haptic.selectionClick();

      await _autoSave();
      notifyListeners();
    } catch (e, stack) {
      print('[GameController] Erreur lors de editPlayerName: $e');
      print(stack);
    }
  }

  /// Masque l'overlay de victoire et efface le nom du gagnant.
  Future<void> dismissWinner() async {
    try {
      // Après un écran de victoire, on enchaîne automatiquement sur
      // une nouvelle manche en réinitialisant complètement la partie.
      await reset();
    } catch (e, stack) {
      print('[GameController] Erreur lors de dismissWinner: $e');
      print(stack);
    }
  }
}
