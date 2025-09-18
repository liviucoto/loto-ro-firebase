import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget chart;
  final Widget? legend;
  final Widget? pageIndicator;
  final Widget? periodSelector;
  final EdgeInsetsGeometry? padding;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.description,
    required this.chart,
    this.legend,
    this.pageIndicator,
    this.periodSelector,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return GlassCard(
      borderRadius: BorderRadius.circular(28),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: isDesktop ? 36 : 8,
            vertical: isDesktop ? 28 : 10,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppFonts.subtitleStyle.copyWith(
                  fontSize: isDesktop ? 20 : 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryBlueMedium,
                ),
              ),
              if (periodSelector != null) periodSelector!,
            ],
          ),
          SizedBox(height: isDesktop ? 10 : 6),
          Text(
            description,
            style: AppFonts.captionStyle.copyWith(
              fontSize: isDesktop ? 13 : 10,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: isDesktop ? 16 : 8),
          chart,
          if (legend != null) ...[
            SizedBox(height: isDesktop ? 14 : 8),
            legend!,
          ],
          if (pageIndicator != null) ...[
            SizedBox(height: isDesktop ? 10 : 6),
            Center(child: pageIndicator!),
          ],
        ],
      ),
    );
  }
}
