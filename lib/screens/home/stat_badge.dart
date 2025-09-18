import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import 'dart:ui';

class StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconSize;

  const StatBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.padding,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.black.withValues(alpha: 0.7),
                size: iconSize ?? 16,
              ),
              const SizedBox(width: 3),
              Text(
                '$label:',
                style: AppFonts.captionStyle.copyWith(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 13,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                value,
                style: AppFonts.bodyStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
