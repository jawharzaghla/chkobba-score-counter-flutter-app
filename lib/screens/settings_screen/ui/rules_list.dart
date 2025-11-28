import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

/// Liste des règles principales de l'application / jeu.
///
/// Ce widget affiche quelques règles de base de Chkobba sous forme
/// de cartes ou d'items expansibles pour aider l'utilisateur à
/// comprendre rapidement le fonctionnement du compteur.
class RulesList extends StatelessWidget {
  const RulesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final rules = <_RuleItem>[
      _RuleItem(
        icon: Icons.flag,
        title: 'Objectif',
        description:
            'Premier à \\${AppConstants.defaultMaxScore} points gagne la partie.',
      ),
      _RuleItem(
        icon: Icons.exposure_plus_1,
        title: 'Ajustement des scores',
        description: 'Utilisez les boutons +1 et -1 pour ajuster les scores.',
      ),
      _RuleItem(
        icon: Icons.edit,
        title: 'Édition manuelle',
        description:
            'Touchez un score pour l\'éditer manuellement en cas d\'erreur.',
      ),
      _RuleItem(
        icon: Icons.undo,
        title: 'Annulation',
        description: 'Utilisez le bouton Annuler pour revenir en arrière.',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
          child: ListTile(
            leading: Icon(rule.icon, color: theme.colorScheme.secondary),
            title: Text(rule.title, style: theme.textTheme.titleMedium),
            subtitle: Text(rule.description, style: theme.textTheme.bodyMedium),
          ),
        );
      },
    );
  }
}

/// Modèle interne pour décrire une règle.
class _RuleItem {
  final IconData icon;
  final String title;
  final String description;

  const _RuleItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
