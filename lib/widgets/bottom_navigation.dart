import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';

/// Widget custom pentru bottom navigation cu efect glassmorphism
/// Folosit pentru taburile per joc (Arhiva, Statistici, Generator)
class GlassBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;

  const GlassBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<GlassBottomNavigation> createState() => _GlassBottomNavigationState();
}

class _GlassBottomNavigationState extends State<GlassBottomNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xB0FFFFFF), // alb semi-transparent pentru efect de sticla
              Color(0x80B2F0E6),
              Color(0x80D1C4E9),
              Color(0x80FDE68A),
              Color(0x80B9F6CA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _slideAnimation.value)),
              child: Opacity(
                opacity: _slideAnimation.value,
                child: Container(
                  height: 68,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: 0,
                  ),
                  child: Row(
                    children: widget.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = widget.currentIndex == index;
                      return Expanded(
                        child: Container(
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                )
                              : null,
                          child: _BottomNavigationItem(
                            item: item,
                            isSelected: isSelected,
                            onTap: () => widget.onTap(index),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Element individual pentru bottom navigation
class _BottomNavigationItem extends StatefulWidget {
  final BottomNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_BottomNavigationItem> createState() => _BottomNavigationItemState();
}

class _BottomNavigationItemState extends State<_BottomNavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );

    if (widget.isSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_BottomNavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: widget.isSelected
                            ? Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 1.2,
                              )
                            : null,
                        boxShadow: widget.isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: widget.isSelected
                            ? AppColors.primaryGreenDark
                            : AppColors.textSecondary,
                        size: AppSizes.iconSmall,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        widget.item.label,
                        style: AppFonts.captionStyle.copyWith(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          shadows: widget.isSelected
                              ? [
                                  Shadow(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    blurRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Model pentru elementele bottom navigation
class BottomNavigationItem {
  final String label;
  final IconData icon;

  const BottomNavigationItem({required this.label, required this.icon});
}

/// Bottom navigation pentru jocuri specifice
class GameBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String gameType;

  const GameBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.gameType,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationItem(
        label: AppStrings.archiveTab,
        icon: Icons.archive,
      ),
      const BottomNavigationItem(
        label: AppStrings.statisticsTab,
        icon: Icons.analytics,
      ),
      const BottomNavigationItem(
        label: AppStrings.generatorTab,
        icon: Icons.casino,
      ),
    ];

    return GlassBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}

/// Buton global pentru setari (fix, col? dreapta jos)
class GlobalSettingsButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isVisible;

  const GlobalSettingsButton({
    super.key,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  State<GlobalSettingsButton> createState() => _GlobalSettingsButtonState();
}

class _GlobalSettingsButtonState extends State<GlobalSettingsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.bounce,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glassShadow,
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppColors.surface,
                  size: AppSizes.iconLarge,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
