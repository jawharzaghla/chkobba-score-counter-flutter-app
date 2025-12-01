import 'package:audioplayers/audioplayers.dart';

/// Service responsable de la gestion des sons de l'application.
///
/// Ce service utilise le pattern singleton afin de réutiliser les mêmes
/// instances d'`AudioPlayer` et éviter des créations répétées inutiles.
/// Il centralise :
/// - le préchargement des sons
/// - la lecture des sons de tap, victoire et reset
/// - la gestion du volume et de l'activation/désactivation du son
class AudioService {
  /// Instance unique du service (singleton).
  static final AudioService _instance = AudioService._internal();

  /// Factory qui retourne toujours la même instance.
  factory AudioService() => _instance;

  /// Constructeur interne privé.
  AudioService._internal();

  /// Map des players audio réutilisables, indexés par un identifiant de son.
  ///
  /// Par exemple :
  /// - 'tap'
  /// - 'win'
  /// - 'reset'
  final Map<String, AudioPlayer> _players = {};

  /// Indique si le son est globalement activé dans l'application.
  bool _soundEnabled = true;

  /// Volume global (entre 0.0 et 1.0).
  double _volume = 0.5;

  /// Constantes représentant les identifiants logiques de chaque son.
  static const String _idTap = 'tap';
  static const String _idWin = 'win';
  static const String _idReset = 'reset';

  /// Chemins vers les fichiers audio des assets.
  static const String _pathTap = 'assets/sounds/tap.mp3';
  static const String _pathWin = 'assets/sounds/win.mp3';
  static const String _pathReset = 'assets/sounds/reset.mp3';

  /// Initialise le service audio et précharge les sons.
  ///
  /// Cette méthode doit idéalement être appelée au démarrage de
  /// l'application afin de réduire la latence au premier playback.
  Future<void> init() async {
    await _createAndPreparePlayer(_idTap, _pathTap);
    await _createAndPreparePlayer(_idWin, _pathWin);
    await _createAndPreparePlayer(_idReset, _pathReset);
  }

  /// Crée (si nécessaire) puis prépare un [AudioPlayer] pour un son donné.
  ///
  /// [id] est l'identifiant logique du son.
  /// [assetPath] est le chemin vers le fichier dans le dossier assets.
  Future<void> _createAndPreparePlayer(String id, String assetPath) async {
    try {
      final existing = _players[id];
      final player = existing ?? AudioPlayer();

      // On configure la source audio pour ce player.
      await player.setSourceAsset(assetPath.replaceFirst('assets/', '')); // asset sous forme relative

      // On applique le volume courant.
      await player.setVolume(_volume);

      if (existing == null) {
        _players[id] = player;
      }

      // Log simple pour debug.
      print('[AudioService] Player préparé pour "$id" avec asset "$assetPath"');
    } catch (e, stack) {
      // En cas de fichier manquant ou autre erreur, on loggue simplement.
      print('[AudioService] Erreur lors de la préparation du son "$id": $e');
      print(stack);
    }
  }

  /// Active ou désactive globalement le son.
  ///
  /// Lorsque le son est désactivé, aucun son ne sera joué.
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    print('[AudioService] Son activé: $_soundEnabled');
  }

  /// Retourne `true` si le son est actuellement activé.
  bool get isSoundEnabled => _soundEnabled;

  /// Modifie le volume global de tous les players.
  ///
  /// [volume] doit être compris entre 0.0 et 1.0.
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    for (final player in _players.values) {
      try {
        await player.setVolume(_volume);
      } catch (e, stack) {
        print('[AudioService] Erreur lors du changement de volume: $e');
        print(stack);
      }
    }
    print('[AudioService] Volume défini à $_volume');
  }

  /// Joue le son de tap si le son est activé.
  Future<void> playTap() async {
    await _playSound(_idTap, _pathTap);
  }

  /// Joue le son de victoire si le son est activé.
  Future<void> playWin() async {
    await _playSound(_idWin, _pathWin);
  }

  /// Joue le son de reset si le son est activé.
  Future<void> playReset() async {
    await _playSound(_idReset, _pathReset);
  }

  /// Méthode générique pour jouer un son à partir de son identifiant.
  ///
  /// Vérifie d'abord si le son est activé avant toute tentative de lecture.
  Future<void> _playSound(String id, String assetPath) async {
    if (!_soundEnabled) {
      print('[AudioService] Lecture ignorée pour "$id" (son désactivé)');
      return;
    }

    try {
      var player = _players[id];
      player ??= AudioPlayer();

      // On s'assure que la source est correctement définie.
      await player.setSourceAsset(assetPath.replaceFirst('assets/', ''));
      await player.setVolume(_volume);

      _players[id] = player;

      // Si le son est déjà en cours, on revient simplement au début pour
      // donner un effet de "clic" réactif lors de taps rapides.
      if (player.state == PlayerState.playing) {
        await player.seek(Duration.zero);
      }

      await player.resume();
      print('[AudioService] Lecture du son "$id"');
    } catch (e, stack) {
      print('[AudioService] Erreur lors de la lecture du son "$id": $e');
      print(stack);
    }
  }

  /// Libère toutes les ressources associées aux players.
  ///
  /// À appeler par exemple lors de la fermeture complète de l'application
  /// ou quand le service n'est plus nécessaire.
  Future<void> dispose() async {
    for (final entry in _players.entries) {
      try {
        await entry.value.dispose();
        print('[AudioService] Player "${entry.key}" disposé');
      } catch (e, stack) {
        print('[AudioService] Erreur lors du dispose du player "${entry.key}": $e');
        print(stack);
      }
    }
    _players.clear();
  }
}
