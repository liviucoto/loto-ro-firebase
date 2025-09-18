import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import 'package:loto_ro/widgets/period_selector_glass.dart';
import 'dart:ui';

/// Componentă reutilizabilă pentru toate graficele din tab-ul de statistici
class ChartContainer extends StatelessWidget {
  final String title;
  final String description;
  final Widget chart;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String> onCustomPeriod;
  final bool isDesktop;
  final Widget? titleWidget;
  final Widget? actionWidget;
  final Widget? leftButton;
  final Widget? rightButton;

  const ChartContainer({
    super.key,
    required this.title,
    required this.description,
    required this.chart,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    this.titleWidget,
    this.actionWidget,
    this.leftButton,
    this.rightButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget fullScreenButton = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.18),
            builder: (ctx) => Center(
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: isDesktop
                          ? 900
                          : MediaQuery.of(context).size.width * 0.98,
                      height: isDesktop
                          ? 580
                          : MediaQuery.of(context).size.height * 0.85,
                      padding: EdgeInsets.all(isDesktop ? 18 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 28 : 20,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 32,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Scroll pentru conținutul graficului
                          Positioned.fill(
                            child: SingleChildScrollView(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isDesktop ? 820 : 900,
                                    maxHeight: isDesktop ? 520 : 500,
                                  ),
                                  child: SizedBox(
                                    height: isDesktop ? 320 : 220,
                                    child: chart,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Buton de închidere
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                size: isDesktop ? 26 : 24,
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              tooltip: 'Închide',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.fullscreen, size: 20, color: Colors.black54),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = !isDesktop;
        final footerHeight = isDesktop ? 80.0 : 64.0;
        final headerHeight = isDesktop ? 64.0 : 48.0;
        return GlassCard(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 10,
            vertical: isDesktop ? 28 : 10,
          ),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              SizedBox(
                height: headerHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: titleWidget != null
                          ? titleWidget!
                          : Text(
                              title,
                              style: AppFonts.subtitleStyle.copyWith(
                                fontSize: isDesktop ? 20 : 15,
                              ),
                            ),
                    ),
                    PeriodSelectorGlass(
                      value: selectedPeriod,
                      options: periodOptions,
                      onChanged: onPeriodChanged,
                      onCustom: onCustomPeriod,
                      fontSize: isDesktop ? 13 : 11,
                      iconSize: isDesktop ? 18 : 15,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 10 : 6,
                        vertical: isDesktop ? 4 : 2,
                      ),
                    ),
                  ],
                ),
              ),
              if (description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    description,
                    style: AppFonts.captionStyle.copyWith(
                      fontSize: isDesktop ? 13 : 10,
                      color: Colors.black54,
                    ),
                  ),
                ),
              // CHART
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 8),
                  child: chart,
                ),
              ),
              // FOOTER (butoane + legendă)
              SizedBox(
                height: footerHeight,
                child: actionWidget != null
                    ? Center(child: actionWidget)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
