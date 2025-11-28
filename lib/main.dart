import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen/ui/home_screen.dart';
import 'screens/settings_screen/controller/settings_controller.dart';
import 'screens/settings_screen/ui/settings_screen.dart';
import 'screens/splash_screen/ui/splash_screen.dart';
import 'screens/game_screen/ui/game_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
///
/// Provides a [SettingsController] at the top level so that
/// theme mode (light/dark) and other global preferences can
/// be driven from user settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsController>(
      create: (_) => SettingsController(),
      child: Consumer<SettingsController>(
        builder: (context, settingsController, _) {
          final settings = settingsController.settings;

          final themeMode = settings.darkMode ? ThemeMode.dark : ThemeMode.light;

          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => const SplashScreen(),
              AppRoutes.home: (_) => const HomeScreen(),
              AppRoutes.game: (_) => const GameScreen(),
              AppRoutes.settings: (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}