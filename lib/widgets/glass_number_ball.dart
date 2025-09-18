import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/utils/constants.dart';

class GlassNumberBall extends StatelessWidget {
  final int number;
  final double size;
  final bool isJoker;

  const GlassNumberBall({
    super.key,
    required this.number,
    this.size = 36,
    this.isJoker = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final double effectiveSize = size;
    final double fontSize = isDesktop ? 20 : 16;
    // Paleta pastel uniforma
    final List<Color> pastelGradient = [
      const Color(0xFFE0F7FA), // pastel cyan
      const Color(0xFFB2F0E6), // pastel bleu
      const Color(0xFFC8E6C9), // pastel verde
      const Color(0xFFD1C4E9), // pastel mov
      const Color(0xFFFFF9C4), // pastel galben
    ];
    final Color jokerGold = const Color(0xFFFFD700); // auriu
    final Color jokerGlow = const Color(0x33FFD700); // glow subtil
    return Container(
      width: effectiveSize,
      height: effectiveSize,
      margin: const EdgeInsets.only(right: AppSizes.paddingSmall),
      child: Stack(
        children: [
          // Shadow 3D sub bila
          Positioned(
            left: 4,
            right: 4,
            bottom: 2,
            child: Container(
              height: effectiveSize * 0.28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(effectiveSize),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          // Bila cu efect glass, gradient pastel
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isJoker
                      ? LinearGradient(
                          colors: [
                            jokerGold.withValues(alpha: 0.7),
                            const Color(0xFFFFF9C4),
                            const Color(0xFFFDE68A),
                            const Color(0xFFF3E5F5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: pastelGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isJoker
                        ? jokerGold
                        : Colors.white.withValues(alpha: 0.7),
                    width: isJoker ? 2.5 : 1.7,
                  ),
                  boxShadow: [
                    if (isJoker)
                      BoxShadow(
                        color: jokerGlow,
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.85),
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.7),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isJoker)
            Positioned(
              top: 1,
              right: 2,
              child: Icon(
                Icons.stars,
                size: effectiveSize * 0.32,
                color: jokerGold.withValues(alpha: 0.85),
              ),
            ),
        ],
      ),
    );
  }
}
