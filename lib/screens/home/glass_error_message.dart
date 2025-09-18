import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import '../../widgets/glass_button.dart';

/// Widget pentru afișarea elegantă a erorilor cu buton de retry
class GlassErrorMessage extends StatelessWidget {
  final String title;
  final String? details;
  final VoidCallback onRetry;

  const GlassErrorMessage({
    super.key,
    required this.title,
    this.details,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconLarge,
            color: AppColors.errorRed,
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Text(title, style: AppFonts.subtitleStyle),
          if (details != null) ...[
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              details!,
              style: AppFonts.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSizes.paddingLarge),
          GlassButton(
            onTap: onRetry,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
            borderRadius: AppSizes.radiusMedium,
            child: Text(
              'Reîncearcă',
              style: AppFonts.bodyStyle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
