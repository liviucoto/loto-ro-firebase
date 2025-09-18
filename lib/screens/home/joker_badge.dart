import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/utils/constants.dart';

class JokerBadge extends StatelessWidget {
  final int joker;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconSize;

  const JokerBadge({
    super.key,
    required this.joker,
    this.padding,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(right: 0),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xB0FFFFFF), Color(0x806EE7B7), Color(0x80B2F0E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars,
                color: Colors.black.withValues(alpha: 0.75),
                size: iconSize ?? 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Joker:',
                style: AppFonts.captionStyle.copyWith(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 13,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                joker.toString(),
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
