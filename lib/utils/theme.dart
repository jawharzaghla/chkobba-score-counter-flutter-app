import 'package:flutter/material.dart';

import 'constants.dart';

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
    const primary = AppColors.orange;
    const secondary = AppColors.darkBlue;
    const background = AppColors.white;
    const surface = AppColors.white;

    final colorScheme = const ColorScheme.light().copyWith(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: secondary,
      onSurface: secondary,
    );

    final baseTextTheme = ThemeData.light().textTheme;

    final textTheme = baseTextTheme.copyWith(
      // Score principal, très grand et bien visible.
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: AppColors.orange,
      ),
      // Noms des joueurs.
      displayMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue,
      ),
      // Titres de sections/écrans.
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkBlue,
      ),
      // Texte normal.
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.darkBlue,
      ),
      // Labels de boutons principaux.
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,

      // AppBar avec fond orange et texte blanc.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Style des boutons principaux (ElevatedButton).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
      ),

      // Style des champs de texte (TextField).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondary.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: TextStyle(color: secondary.withOpacity(0.8)),
      ),

      // Style des cartes représentant les joueurs ou sections.
      //
      // Utilise [CardThemeData] pour être compatible avec les
      // versions récentes de Flutter / Material.
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  /// Construit le [ThemeData] pour le mode sombre.
  static ThemeData _buildDarkTheme() {
    // Version assombrie du thème clair : orange plus doux et bleu nuit.
    const primary = Color(0xFFFFA94D); // Orange plus clair pour le sombre.
    const secondary = Color(0xFF0A1A2A); // Bleu nuit très sombre.
    const background = Color(0xFF050B10); // Fond quasi noir bleuté.
    const surface = Color(0xFF111827); // Surfaces légèrement plus claires.

    final colorScheme = const ColorScheme.dark().copyWith(
      primary: primary,
      secondary: primary,
      background: background,
      surface: surface,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: AppColors.white,
      onSurface: AppColors.white,
    );

    final baseTextTheme = ThemeData.dark().textTheme;

    final textTheme = baseTextTheme.copyWith(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      displayMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.white70),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
