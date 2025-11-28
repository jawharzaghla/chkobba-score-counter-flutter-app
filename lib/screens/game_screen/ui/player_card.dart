import 'package:flutter/material.dart';

import '../../../models/player.dart';
import 'action_buttons.dart';
import 'score_display.dart';

/// Carte représentant un joueur dans l'écran de jeu.
///
/// Permet :
/// - d'afficher et d'éditer le nom du joueur
/// - de voir son score actuel
/// - d'ajuster le score via des boutons (+1, -1, édition manuelle)
class PlayerCard extends StatefulWidget {
  /// Données du joueur à afficher.
  final Player player;

  /// Callback appelé lorsqu'on veut incrémenter le score.
  final VoidCallback onIncrement;

  /// Callback appelé lorsqu'on veut décrémenter le score.
  final VoidCallback onDecrement;

  /// Callback appelé lorsqu'un nouveau score est validé depuis le dialog.
  final ValueChanged<int> onEditScore;

  /// Callback appelé lorsqu'un nouveau nom est validé depuis le dialog.
  final ValueChanged<String> onEditName;

  /// Couleur optionnelle de fond de la carte.
  final Color? cardColor;

  const PlayerCard({
    super.key,
    required this.player,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEditScore,
    required this.onEditName,
    this.cardColor,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  /// Ouvre un dialog pour éditer le nom du joueur.
  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: widget.player.name);
    final theme = Theme.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le nom du joueur'),
          content: TextField(
            controller: controller,
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
                final newName = controller.text.trim();
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
      widget.onEditName(result);
    }
  }

  /// Ouvre un dialog pour éditer manuellement le score du joueur.
  Future<void> _showEditScoreDialog() async {
    final controller = TextEditingController(text: widget.player.score.toString());

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le score'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nouveau score',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                final value = int.tryParse(text);
                if (value != null) {
                  Navigator.of(context).pop(value);
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

    if (result != null) {
      widget.onEditScore(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: widget.cardColor ?? theme.cardTheme.color,
      elevation: theme.cardTheme.elevation ?? 4,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nom du joueur, cliquable pour ouvrir le dialog d'édition.
            GestureDetector(
              onTap: _showEditNameDialog,
              child: Text(
                widget.player.name,
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Affichage du score actuel avec animation.
            ScoreDisplay(score: widget.player.score),

            const SizedBox(height: 16),

            // Boutons d'action pour ajuster le score ou ouvrir
            // le dialog d'édition manuelle.
            ActionButtons(
              onIncrement: widget.onIncrement,
              onDecrement: widget.onDecrement,
              onEdit: _showEditScoreDialog,
            ),
          ],
        ),
      ),
    );
  }
}
