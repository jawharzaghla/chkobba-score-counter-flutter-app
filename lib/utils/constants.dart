/// Fichier contenant toutes les constantes globales de l'application.
///
/// Les constantes sont organisées par thématique dans des classes
/// statiques pour garder le code lisible et facilement maintenable.

/// Textes et libellés utilisés dans l'application.
class AppStrings {
  AppStrings._(); // Constructeur privé pour empêcher l'instanciation.

  /// Nom affiché de l'application.
  static const String appName = 'Chkobba';

  /// Libellé pour démarrer une nouvelle partie.
  static const String newGame = 'Nouvelle Partie';

  /// Titre/entrée de menu pour accéder aux paramètres.
  static const String settings = 'Paramètres';

  /// Nom par défaut du joueur 1.
  static const String player1Default = 'Joueur 1';

  /// Nom par défaut du joueur 2.
  static const String player2Default = 'Joueur 2';

  /// Libellé pour réinitialiser une partie ou des scores.
  static const String reset = 'Réinitialiser';

  /// Libellé pour annuler la dernière action (undo).
  static const String undo = 'Annuler';

  /// Libellé pour éditer des informations (nom, score, paramètres...).
  static const String edit = 'Éditer';

  /// Message affiché lorsqu'un joueur gagne la partie.
  static const String winner = 'Gagnant !';

  /// Label générique pour valider une action.
  static const String confirm = 'Valider';

  /// Label générique pour annuler une action.
  static const String cancel = 'Annuler';

  /// Titre pour l'écran de jeu.
  static const String gameTitle = 'Compteur de score';

  /// Titre pour l'écran des règles / informations.
  static const String rulesTitle = 'Règles';
}

/// Constantes numériques et durées utilisées dans l'application.
class AppConstants {
  AppConstants._();

  /// Score minimum configurable pour une partie.
  static const int minScore = 5;

  /// Limite maximale autorisée pour le score de victoire.
  static const int maxScoreLimit = 50;

  /// Score maximal par défaut pour gagner une partie.
  static const int defaultMaxScore = 21;

  /// Durée d'affichage de l'écran de splash.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Durée standard pour les animations de l'interface.
  static const Duration animationDuration = Duration(milliseconds: 300);
}

/// Noms de routes utilisés pour la navigation dans l'application.
class AppRoutes {
  AppRoutes._();

  /// Route de l'écran de splash (écran de démarrage).
  static const String splash = '/';

  /// Route de l'écran d'accueil / menu principal.
  static const String home = '/home';

  /// Route de l'écran de jeu principal.
  static const String game = '/game';

  /// Route de l'écran des paramètres.
  static const String settings = '/settings';
}

/// Couleurs principales réutilisables dans l'application.
class AppColors {
  AppColors._();

  static const orange = Color(0xFFFF8C00);
  static const darkBlue = Color(0xFF0A3D5C);
  static const white = Color(0xFFFFFFFF);
  static const orangeGradientStart = Color(0xFFFF8C00);
  static const orangeGradientEnd = Color(0xFFFF9F29);
  static const blueGradientStart = Color(0xFF0A3D5C);
  static const blueGradientEnd = Color(0xFF164863);
}

/// Chemins vers les différents assets (animations, images, sons).
class AssetPaths {
  AssetPaths._();

  /// Animation Lottie affichée sur l'écran de splash.
  static const String splashAnimation = 'assets/animations/splash_animation.json';

  /// Logo principal de l'application.
  static const String logo = 'assets/images/logo.png';

  /// Image de fond optionnelle pour l'écran de splash.
  static const String splashBg = 'assets/images/splash_bg.png';

  /// Icône d'engrenage pour représenter les paramètres (optionnelle).
  static const String gearIcon = 'assets/images/gear.png';

  /// Son de tap pour les interactions simples.
  static const String tapSound = 'assets/sounds/tap.mp3';

  /// Son joué lorsqu'un joueur gagne la partie.
  static const String winSound = 'assets/sounds/win.mp3';

  /// Son utilisé lors de la réinitialisation des scores ou de la partie.
  static const String resetSound = 'assets/sounds/reset.mp3';
}
