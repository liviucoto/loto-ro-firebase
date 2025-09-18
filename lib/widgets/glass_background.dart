import 'package:flutter/material.dart';

class GlassBackground extends StatelessWidget {
  final Widget? child;
  const GlassBackground({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2F0E6), // albastru pastel
              Color(0xFFD1C4E9), // mov pastel
              Color(0xFFFDE68A), // galben pastel
              Color(0xFFB9F6CA), // verde pastel
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          color: Colors.white.withValues(alpha: 0.10),
          child: child != null ? Positioned.fill(child: child!) : null,
        ),
      ),
    );
  }
}
