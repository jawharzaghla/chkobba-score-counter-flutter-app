import 'package:flutter/material.dart';

/// Tuile générique pour un élément de paramètre.
///
/// Permet d'afficher un titre, un sous-titre optionnel, une icône
/// et un widget de fin (switch, slider, bouton, etc.).
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
        ListTile(
          leading: icon != null
              ? Icon(icon, color: theme.colorScheme.secondary)
              : null,
          title: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium,
                )
              : null,
          trailing: trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        // Séparateur discret sous chaque tuile.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            height: 1,
            color: theme.dividerColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
