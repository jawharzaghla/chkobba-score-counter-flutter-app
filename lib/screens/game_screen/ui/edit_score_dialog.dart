import 'package:flutter/material.dart';

/// Dialog permettant d'éditer manuellement le score d'un joueur.
///
/// La validation vérifie :
/// - que la valeur saisie est un entier
/// - que 0 <= score <= maxScore + 10
/// En cas d'erreur, un message est affiché sous le champ de texte.
class EditScoreDialog extends StatefulWidget {
  /// Score actuel du joueur.
  final int currentScore;

  /// Score maximal de la partie (utilisé pour valider la plage autorisée).
  final int maxScore;

  const EditScoreDialog({
    super.key,
    required this.currentScore,
    required this.maxScore,
  });

  @override
  State<EditScoreDialog> createState() => _EditScoreDialogState();
}

class _EditScoreDialogState extends State<EditScoreDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentScore.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Tente de valider la valeur saisie et ferme le dialog.
  ///
  /// Si la valeur est invalide, met à jour [_errorText] pour avertir
  /// l'utilisateur sans fermer le dialog.
  void _onValidate() {
    final text = _controller.text.trim();

    // Vérification que le texte est bien un entier.
    final value = int.tryParse(text);
    if (value == null) {
      setState(() {
        _errorText = 'Veuillez entrer un nombre valide.';
      });
      return;
    }

    // Vérification de la plage autorisée.
    final min = 0;
    final max = widget.maxScore + 10;
    if (value < min || value > max) {
      setState(() {
        _errorText = 'Le score doit être compris entre $min et $max.';
      });
      return;
    }

    // Validation réussie : on ferme le dialog en renvoyant la valeur.
    Navigator.of(context).pop<int>(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier le score'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nouveau score',
              hintText: 'Entrez nouveau score',
              errorText: _errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _onValidate,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
