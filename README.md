# Chkobba Score Counter

Mobile score counter for the Tunisian card game **Chkobba**, built with Flutter.

This app lets you track scores for two players, apply the game rules, and
persist games between sessions. It uses an orange / dark blue flat theme and
simple animations.

## Setup

1. Install Flutter (3.x recommended) and Android Studio / Xcode.
2. Fetch dependencies:

   ```bash
   flutter pub get
   ```

3. Run on a device or emulator:

   ```bash
   flutter run
   ```

Assets (images, sounds, animations) are declared under `assets/` in
`pubspec.yaml`. Make sure they are present locally before building a release.

## Main Features

- Two-player score tracking with max score limit.
- Persistent game state (resume later).
- Orange / dark blue custom theme.
- Sound effects and haptic feedback.
- Simple rules help section.

## Architecture

The app follows a simple MVC / layered approach:

- **Models** (`lib/models`)
  - `player.dart` – player name and score.
  - `game_state.dart` – complete game state (players, history, max score).
  - `settings.dart` – user preferences (sound, dark mode, volume, max score).

- **Screens** (`lib/screens`)
  - `splash_screen` – initialization and navigation to home.
  - `home_screen` – entry point, play button, settings shortcut.
  - `game_screen` – main score counter UI.
  - `settings_screen` – app settings and rules.

- **Services** (`lib/services`)
  - `audio_service.dart` – sound effects via `audioplayers`.
  - `haptic_service.dart` – vibration / haptics.
  - `storage_service.dart` – persistence via `shared_preferences`.

- **Utils & Theme** (`lib/utils`)
  - `constants.dart` – routes, colors (`AppColors`), asset paths.
  - `theme.dart` – light / dark `ThemeData` for the orange / blue design.

- **Widgets** (`lib/widgets`)
  - `custom_button.dart` – reusable button with sound & haptic feedback.
  - `custom_switch.dart` – switch with label and feedback.
  - `confetti_animation.dart` – confetti effect for the winner overlay.

State management uses `provider` with controllers for each screen
(`GameController`, `SettingsController`, `HomeController`, `SplashController`).

## Main Screens

- **SplashScreen** – full-screen background image, logo, and auto-navigation.
- **HomeScreen** – dark blue background, orange header, animated play button,
  and gear icon to open settings.
- **GameScreen** – split-screen player layout (top and bottom), tap to
  increment, minus button to decrement, central reset button with confirmation,
  and winner overlay with confetti.
- **SettingsScreen** – orange AppBar, tiles for max score, sound, theme,
  volume slider, rules list, and a button to reset statistics.

## License

Personal / learning project. No explicit open-source license defined.
