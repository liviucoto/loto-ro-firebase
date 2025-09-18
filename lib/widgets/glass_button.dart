import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';

/// Widget custom pentru butoane cu efect glassmorphism
/// Folosit pentru toate butoanele din aplica?ie
class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isSelected;
  final Color? backgroundColor;

  const GlassButton({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius = 18,
    this.isSelected = false,
    this.backgroundColor,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _pressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0x80B2F0E6),
      const Color(0x80D1C4E9),
      const Color(0x80FDE68A),
      const Color(0x80B9F6CA),
    ];
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pressed ? _scaleAnim.value : 1.0,
            child: Opacity(
              opacity: _pressed ? _opacityAnim.value : 1.0,
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.isSelected
                    ? Color(0xE6FFFFFF) // alb opac pentru buton selectat
                    : Color(0x80B2F0E6),
                Color(0x80D1C4E9),
                Color(0x80FDE68A),
                Color(0x80B9F6CA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
              width: widget.isSelected ? 2.2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.isSelected
                    ? Colors.black
                    : Colors.black.withValues(alpha: 0.85),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Varianta pentru butoane cu gradient
class GradientGlassButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool isDisabled;

  const GradientGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.gradient,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<GradientGlassButton> createState() => _GradientGlassButtonState();
}

class _GradientGlassButtonState extends State<GradientGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    if (widget.isDisabled || widget.isLoading) return;
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPressed != null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width ?? double.infinity,
              height: widget.height ?? AppSizes.buttonHeight,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                    vertical: AppSizes.paddingMedium,
                  ),
              decoration: BoxDecoration(
                gradient: widget.isDisabled
                    ? null
                    : widget.gradient ?? AppGradients.primaryGradient,
                color: widget.isDisabled ? AppColors.glassMedium : null,
                borderRadius:
                    widget.borderRadius ??
                    BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: AppColors.glassBorder, width: 1.0),
                boxShadow: AppShadows.buttonShadow,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: AppSizes.iconMedium,
                        height: AppSizes.iconMedium,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.textColor ?? AppColors.surface,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.textColor ?? AppColors.surface,
                              size: AppSizes.iconMedium,
                            ),
                            const SizedBox(width: AppSizes.paddingSmall),
                          ],
                          Text(
                            widget.text,
                            style: AppFonts.bodyStyle.copyWith(
                              color: widget.textColor ?? AppColors.surface,
                              fontWeight: FontWeight.w600,
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

/// Buton pentru ac?iuni secundare
class SecondaryGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isDisabled;

  const SecondaryGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onTap: onPressed,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLarge,
        vertical: AppSizes.paddingMedium,
      ),
      borderRadius: AppSizes.radiusMedium,
      isSelected: false,
      child: Text(
        text,
        style: AppFonts.bodyStyle.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
