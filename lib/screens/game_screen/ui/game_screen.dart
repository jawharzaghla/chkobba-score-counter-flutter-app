import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../controller/game_controller.dart';
import 'winner_overlay.dart';

/// Main game screen with split layout for both players.
///
/// - Top half: Player 1 (orange gradient), rotated 180° so both
///   players see their score upright from their side of the table.
/// - Bottom half: Player 2 (blue gradient).
/// - Center: floating reset button avec confirmation.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  Future<void> _showEditNameDialog(
    BuildContext context, {
    required bool isPlayer1,
    required String currentName,
  }) async {
    final controller = context.read<GameController>();
    final textController = TextEditingController(text: currentName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le nom du joueur'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Nom du joueur',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final newName = textController.text.trim();
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop(newName);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await controller.editPlayerName(isPlayer1, result);
    }
  }

  Future<void> _showResetDialog(BuildContext context) async {
    final controller = context.read<GameController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Game?'),
          content: const Text(
            'This will reset both scores to 0',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await controller.reset();
    }
  }

  void _showPlusOneAnimation(BuildContext context, {required bool isPlayer1}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return IgnorePointer(
          child: Stack(
            children: [
              Positioned(
                top: isPlayer1 ? size.height * 0.20 : null,
                bottom: isPlayer1 ? null : size.height * 0.20,
                left: 0,
                right: 0,
                child: const _PlusOneBubble(),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 600), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>(
      create: (_) => GameController()..loadGame(),
      child: Consumer<GameController>(
        builder: (context, controller, _) {
          final state = controller.gameState;

          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    // Top half - Player 1 (orange, rotated 180°).
                    Expanded(
                      child: Transform.rotate(
                        angle: math.pi,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _showPlusOneAnimation(context, isPlayer1: true);
                            controller.incrementPlayer1Score();
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.orangeGradientStart,
                                  AppColors.orangeGradientEnd,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: SafeArea(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'Tap To Increase Score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Bouton -1
                                  GestureDetector(
                                    onTap: () {
                                      // Empêche de propager le tap à la zone globale.
                                      controller.decrementPlayer1Score();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        '-1',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Score énorme.
                                  Text(
                                    '${state.player1.score}',
                                    style: const TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Nom du joueur (cliquable pour édition).
                                  GestureDetector(
                                    onTap: () => _showEditNameDialog(
                                      context,
                                      isPlayer1: true,
                                      currentName: state.player1.name,
                                    ),
                                    child: Text(
                                      state.player1.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom half - Player 2 (blue gradient).
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _showPlusOneAnimation(context, isPlayer1: false);
                          controller.incrementPlayer2Score();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.blueGradientStart,
                                AppColors.blueGradientEnd,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Nom du joueur 2 (cliquable pour édition).
                                GestureDetector(
                                  onTap: () => _showEditNameDialog(
                                    context,
                                    isPlayer1: false,
                                    currentName: state.player2.name,
                                  ),
                                  child: Text(
                                    state.player2.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Score énorme.
                                Text(
                                  '${state.player2.score}',
                                  style: const TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                // Bouton -1 pour le joueur 2.
                                GestureDetector(
                                  onTap: () {
                                    controller.decrementPlayer2Score();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '-1',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const Text(
                                  'Tap To Increase Score',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Bouton de reset central.
                Center(
                  child: GestureDetector(
                    onTap: () => _showResetDialog(context),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),

                // Winner overlay displayed on top of everything when
                // a player has reached the max score.
                if (controller.showWinner && state.winner != null)
                  WinnerOverlay(
                    winnerName: state.winner!,
                    onDismiss: controller.dismissWinner,
                  ),

                // Back button to return to the previous (home) screen.
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlusOneBubble extends StatefulWidget {
  const _PlusOneBubble();

  @override
  State<_PlusOneBubble> createState() => _PlusOneBubbleState();
}

class _PlusOneBubbleState extends State<_PlusOneBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: const Offset(0, -0.2),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: const Text(
          '+1',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
