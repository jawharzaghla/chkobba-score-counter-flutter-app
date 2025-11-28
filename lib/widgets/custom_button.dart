import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/haptic_service.dart';

/// Bouton réutilisable avec support des icônes, du mode outlined,
/// des effets sonores et haptiques.
class CustomButton extends StatelessWidget {
  /// Texte affiché dans le bouton.
  final String text;

  /// Callback exécuté lors du tap sur le bouton.
  final VoidCallback onPressed;

  /// Couleur de fond du bouton.
  /// Si null, utilise la couleur primaire du thème.
  final Color? backgroundColor;

  /// Couleur du texte (et de l'icône le cas échéant).
  /// Si null, une couleur adaptée est choisie en fonction du fond.
  final Color? textColor;

  /// Largeur optionnelle du bouton.
  final double? width;

  /// Hauteur optionnelle du bouton.
  final double? height;

  /// Icône optionnelle affichée à gauche du texte.
  final IconData? icon;

  /// Indique si le bouton doit être affiché en mode "outlined"
  /// (bordure uniquement, fond transparent ou léger).
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color resolvedBackgroundColor = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? colorScheme.primary);

    final Color resolvedTextColor = textColor ??
        (isOutlined
            ? (backgroundColor ?? colorScheme.primary)
            : colorScheme.onPrimary);

    final borderColor = backgroundColor ?? colorScheme.primary;

    final double effectiveHeight = height ?? 48.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 0),
      builder: (context, scale, child) {
        return _ButtonContent(
          text: text,
          icon: icon,
          onPressed: () async {
            // Effet sonore et haptique avant l'action.
            await AudioService().playTap();
            await HapticService().lightImpact();
            onPressed();
          },
          backgroundColor: resolvedBackgroundColor,
          textColor: resolvedTextColor,
          borderColor: borderColor,
          width: width,
          height: effectiveHeight,
          isOutlined: isOutlined,
        );
      },
    );
  }
}

/// Contenu interne du bouton avec gestion de l'effet d'échelle.
class _ButtonContent extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double? width;
  final double height;
  final bool isOutlined;

  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.width,
    required this.height,
    required this.isOutlined,
  });

  @override
  State<_ButtonContent> createState() => _ButtonContentState();
}

class _ButtonContentState extends State<_ButtonContent>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  /// Met à jour le facteur d'échelle du bouton pour donner un
  /// léger effet de pression lors du tap.
  void _setScale(double value) {
    setState(() {
      _scale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setScale(0.97),
      onTapUp: (_) => _setScale(1.0),
      onTapCancel: () => _setScale(1.0),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isOutlined ? Colors.transparent : widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.borderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: widget.textColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: widget.textColor,
                      ) ??
                      TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
