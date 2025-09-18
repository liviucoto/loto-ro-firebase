import 'package:flutter/material.dart';
import 'package:loto_ro/services/platform_service.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';

class PlatformInfo extends StatelessWidget {
  const PlatformInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final platformService = PlatformService();

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getPlatformIcon(platformService.platformName),
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Platforma: ${platformService.platformName}',
                  style: AppFonts.subtitleStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              platformService.statusMessage,
              style: AppFonts.bodyStyle.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recomandări:',
              style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...platformService.recommendations.map(
              (recommendation) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      recommendation.startsWith('✅')
                          ? Icons.check_circle
                          : Icons.warning,
                      color: recommendation.startsWith('✅')
                          ? Colors.green
                          : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation.substring(2), // Elimină emoji-ul
                        style: AppFonts.captionStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platformName) {
    switch (platformName.toLowerCase()) {
      case 'web':
        return Icons.web;
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      case 'windows':
        return Icons.desktop_windows;
      case 'macos':
        return Icons.desktop_mac;
      case 'linux':
        return Icons.desktop_windows;
      default:
        return Icons.device_unknown;
    }
  }
}
