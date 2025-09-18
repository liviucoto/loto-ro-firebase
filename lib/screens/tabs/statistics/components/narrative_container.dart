import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';

/// Componentă reutilizabilă pentru toate narativele din tab-ul de statistici
class NarrativeContainer extends StatelessWidget {
  final Widget child;
  final bool isDesktop;

  const NarrativeContainer({
    super.key,
    required this.child,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.glassLight.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 14 : 8,
          vertical: isDesktop ? 10 : 14,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: isDesktop ? 12.0 : 9.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
