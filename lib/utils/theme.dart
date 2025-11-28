import 'package:flutter/material.dart';

/// Classe centralisant les thèmes clair et sombre de l'application.
///
/// Les couleurs sont inspirées d'un univers de jeu de cartes traditionnel
/// (rouge bordeaux, or, beige, noir) pour donner une ambiance chaleureuse
/// et élégante.
class AppTheme {
  AppTheme._();

  /// Thème clair principal de l'application.
  ///
  /// Utilise :
  /// - un rouge bordeaux pour la couleur primaire
  /// - un or pour les accents et éléments interactifs
  /// - un beige clair en arrière-plan pour rappeler la table de jeu
  /// - des surfaces blanches pour garder une bonne lisibilité
  static final ThemeData lightTheme = _buildLightTheme();

  /// Thème sombre pour une utilisation confortable en faible luminosité.
  ///
  /// Les mêmes tonalités sont reprises mais assombries :
  /// - rouge plus doux
  /// - or lumineux en accent
  /// - fond très sombre pour faire ressortir les cartes et textes.
  static final ThemeData darkTheme = _buildDarkTheme();

  /// Construit le [ThemeData] pour le mode clair.
  static ThemeData _buildLightTheme() {
    const primary = Color(0xFF8B0000); // Rouge bordeaux profond.
    const secondary = Color(0xFFDAA520); // Or chaud pour les accents.
    const background = Color(0xFFF5E6D3); // Beige clair rappelant une table de jeu.
    const surface = Colors.white; // Surfaces de cartes et panneaux.

    final colorScheme = const ColorScheme.light().copyWith(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black,
    );

    final baseTextTheme = ThemeData.light().textTheme;

    final textTheme = baseTextTheme.copyWith(
      // Score principal, très grand et bien visible.
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      // Noms des joueurs.
      displayMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      // Titres de sections/écrans.
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      // Texte normal.
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      // Labels de boutons principaux.
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,

      // Style des boutons principaux (ElevatedButton).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 4,
        ),
      ),

      // Style des champs de texte (TextField).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: TextStyle(color: primary.withOpacity(0.8)),
      ),

      // Style des cartes représentant les joueurs ou sections.
      //
      // Utilise [CardThemeData] pour être compatible avec les
      // versions récentes de Flutter / Material.
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  /// Construit le [ThemeData] pour le mode sombre.
  static ThemeData _buildDarkTheme() {
    const primary = Color(0xFFCD5C5C); // Rouge adouci pour le mode sombre.
    const secondary = Color(0xFFFFD700); // Or vif pour faire ressortir les actions.
    const background = Color(0xFF1A1A1A); // Fond très sombre, neutre.
    const surface = Color(0xFF2D2D2D); // Surfaces légèrement plus claires.

    final colorScheme = const ColorScheme.dark().copyWith(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    );

    final baseTextTheme = ThemeData.dark().textTheme;

    final textTheme = baseTextTheme.copyWith(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.black,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withOpacity(0.5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.white70),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
