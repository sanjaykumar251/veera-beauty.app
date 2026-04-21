import 'package:flutter/material.dart';
import 'package:veeras_beauty/core/theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final Color? color;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              : (gradient ?? (color != null ? LinearGradient(colors: [color!, color!]) : AppTheme.primaryGradient)),
          color: onPressed == null ? AppTheme.textMuted.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onPressed == null ? null : [
            BoxShadow(
              color: (color ?? AppTheme.primary).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
