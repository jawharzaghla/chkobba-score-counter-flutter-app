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
                          onTap: controller.incrementPlayer1Score,
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

                                  // Nom du joueur.
                                  Text(
                                    state.player1.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                        onTap: controller.incrementPlayer2Score,
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
                                // Nom du joueur 2.
                                Text(
                                  state.player2.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
