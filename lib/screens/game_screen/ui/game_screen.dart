import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';
import '../controller/game_controller.dart';
import 'player_card.dart';
import 'winner_overlay.dart';

/// Main game screen.
///
/// This screen wires the [GameController] with the UI:
/// - displays two [PlayerCard] widgets (one for each player)
/// - exposes global actions like undo and reset
/// - shows a winner overlay when the game is won.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameController>(
      create: (_) => GameController()..loadGame(),
      child: Consumer<GameController>(
        builder: (context, controller, _) {
          final state = controller.gameState;
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.gameTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: AppStrings.reset,
                  onPressed: controller.reset,
                ),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Display the target score at the top.
                      Text(
                        'First to ${state.maxScore} points wins',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Player 1 card.
                      Expanded(
                        child: PlayerCard(
                          player: state.player1,
                          onIncrement: controller.incrementPlayer1Score,
                          onDecrement: controller.decrementPlayer1Score,
                          onEditScore: controller.editPlayer1Score,
                          onEditName: (name) =>
                              controller.editPlayerName(true, name),
                          cardColor:
                              theme.colorScheme.surface.withOpacity(0.95),
                        ),
                      ),

                      // Player 2 card.
                      Expanded(
                        child: PlayerCard(
                          player: state.player2,
                          onIncrement: controller.incrementPlayer2Score,
                          onDecrement: controller.decrementPlayer2Score,
                          onEditScore: controller.editPlayer2Score,
                          onEditName: (name) =>
                              controller.editPlayerName(false, name),
                          cardColor:
                              theme.colorScheme.surface.withOpacity(0.95),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Global actions row: undo + reset.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.undo,
                            icon: const Icon(Icons.undo),
                            label: Text(AppStrings.undo),
                          ),
                          ElevatedButton.icon(
                            onPressed: controller.reset,
                            icon: const Icon(Icons.refresh),
                            label: Text(AppStrings.reset),
                          ),
                        ],
                      ),
                    ],
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
