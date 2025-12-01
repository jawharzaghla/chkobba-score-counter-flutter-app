import 'package:flutter/material.dart';

/// Tuile générique pour un élément de paramètre.
///
/// Permet d'afficher un titre, un sous-titre optionnel, une icône
/// et un widget de fin (switch, slider, bouton, etc.).
///
/// Implémentée sans utiliser [ListTile] afin d'éviter certains
/// problèmes de layout dans des conteneurs scrollables imbriqués.
class SettingTile extends StatelessWidget {
  /// Titre principal du paramètre.
  final String title;

  /// Description optionnelle pour expliquer le paramètre.
  final String? subtitle;

  /// Icône optionnelle affichée à gauche.
  final IconData? icon;

  /// Widget affiché à droite (par exemple un switch ou un slider).
  final Widget trailing;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: theme.colorScheme.secondary),
                const SizedBox(width: 16),
              ],

              // Texte (titre + sous-titre) prend tout l'espace restant.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Widget de fin (switch / slider / bouton...).
              trailing,
            ],
          ),
        ),

        // Séparateur discret sous chaque tuile.
        const Divider(
          height: 1,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }
}
