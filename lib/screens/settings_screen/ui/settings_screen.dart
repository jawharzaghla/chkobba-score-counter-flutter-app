import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_switch.dart';
import '../controller/settings_controller.dart';
import 'max_score_slider.dart';
import 'rules_list.dart';
import 'setting_tile.dart';

/// Application settings screen.
///
/// This screen reads the [SettingsController] provided at the root
/// of the app (in `main.dart`) via Provider, and reacts to
/// changes using [Consumer] / [context.watch].
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, _) {
        final settings = controller.settings;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const SizedBox(height: 20),

              // Tuile pour le score maximum avec un slider dédié.
              SettingTile(
                title: 'Score Maximum',
                subtitle:
                    'Définissez le score à atteindre pour gagner la partie.',
                trailing: MaxScoreSlider(
                  currentValue: settings.maxScore,
                  onChanged: controller.updateMaxScore,
                ),
              ),

              // Sons activés/désactivés.
              SettingTile(
                title: 'Sons',
                subtitle: 'Activer les effets sonores',
                icon: Icons.volume_up,
                trailing: CustomSwitch(
                  value: settings.soundEnabled,
                  onChanged: controller.toggleSound,
                ),
              ),

              // Thème sombre.
              SettingTile(
                title: 'Thème sombre',
                subtitle: 'Utiliser un thème adapté à la nuit',
                icon: Icons.dark_mode,
                trailing: CustomSwitch(
                  value: settings.darkMode,
                  onChanged: controller.toggleDarkMode,
                ),
              ),

              const SizedBox(height: 24),

              // En-tête pour la section des règles.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Règles du Jeu',
                  style: theme.textTheme.titleLarge,
                ),
              ),

              const RulesList(),

              const SizedBox(height: 24),

              // Bouton centré pour réinitialiser les statistiques.
              Center(
                child: CustomButton(
                  text: 'Réinitialiser Statistiques',
                  onPressed: () {
                    controller.resetStats();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Statistiques réinitialisées.'),
                      ),
                    );
                  },
                  backgroundColor: theme.colorScheme.secondary,
                  textColor: theme.colorScheme.onSecondary,
                  icon: Icons.refresh,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
