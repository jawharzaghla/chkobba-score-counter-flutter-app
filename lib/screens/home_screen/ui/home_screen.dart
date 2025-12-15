import 'package:flutter/material.dart';

import '../../../models/game_state.dart';
import '../../../services/storage_service.dart';
import '../../../utils/constants.dart';
import '../controller/home_controller.dart';

/// Écran d'accueil principal de l'application.
///
/// Nouveau design sans AppBar, avec :
/// - un en-tête orange contenant le logo et le titre
/// - une icône d'accès aux paramètres en haut à droite
/// - un grand bouton circulaire "play" animé au centre.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    // Animation souple de mise à l'échelle pour le bouton "play".
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.98,
      upperBound: 1.02,
    )..repeat(reverse: true);

    _loadInitialNames();
  }

  Future<void> _loadInitialNames() async {
    // Charge les noms sauvegardés depuis le GameState, ou utilise les valeurs par défaut.
    final savedState = await _storage.loadGameState();
    final state = savedState ?? const GameState();
    setState(() {
      _player1Controller.text = state.player1.name;
      _player2Controller.text = state.player2.name;
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // En-tête orange avec logo + titre.
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orangeGradientStart,
                      AppColors.orangeGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetPaths.logo,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Chkobba Score Counter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Zone d'édition des noms des joueurs.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _player1Controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nom du Joueur 1',
                        hintText: 'Joueur 1',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _player2Controller,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nom du Joueur 2',
                        hintText: 'Joueur 2',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ],
                ),
              ),

              // Contenu principal avec bouton "play" circulaire.
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleController,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () async {
                        // Sauvegarde les noms saisis dans le GameState avant de lancer la partie.
                        final currentState = await _storage.loadGameState() ?? const GameState();
                        final updatedState = currentState.copyWith(
                          player1: currentState.player1.copyWith(name: _player1Controller.text.trim().isEmpty
                              ? currentState.player1.name
                              : _player1Controller.text.trim()),
                          player2: currentState.player2.copyWith(name: _player2Controller.text.trim().isEmpty
                              ? currentState.player2.name
                              : _player2Controller.text.trim()),
                        );
                        await _storage.saveGameState(updatedState);
                        if (!mounted) return;
                        await HomeController.navigateToGame(context);
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Icône de paramètres positionnée en haut à droite.
          Positioned(
            top: topPadding + 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: () => HomeController.navigateToSettings(context),
            ),
          ),
        ],
      ),
    );
  }
}
