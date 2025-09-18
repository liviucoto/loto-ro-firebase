import 'package:flutter/material.dart';
import 'package:loto_ro/widgets/glass_card.dart';

class PeriodSelectorGlass extends StatefulWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCustom;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  const PeriodSelectorGlass({
    required this.value,
    required this.options,
    required this.onChanged,
    this.onCustom,
    this.fontSize,
    this.iconSize,
    this.padding,
    super.key,
  });

  @override
  State<PeriodSelectorGlass> createState() => _PeriodSelectorGlassState();
}

class _PeriodSelectorGlassState extends State<PeriodSelectorGlass> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeMenu,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width + 40,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(-20, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: GlassCard(
                  borderRadius: BorderRadius.circular(18),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.options.map((option) {
                      final isSelected = option == widget.value;
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          _removeMenu();
                          if (option == 'Custom' && widget.onCustom != null) {
                            final customPeriod = await _showCustomDialog(
                              context,
                            );
                            if (customPeriod != null &&
                                customPeriod.isNotEmpty) {
                              widget.onCustom!(customPeriod);
                            }
                          } else {
                            widget.onChanged(option);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: widget.fontSize ?? 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showMenu,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.value,
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                    size: widget.iconSize ?? 18,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 1.5,
                width: double.infinity,
                color: Colors.black.withValues(alpha: 0.18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showCustomDialog(BuildContext context) async {
    String? result;
    await showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Perioada custom'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Numar extrageri',
              hintText: 'Ex: 10',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Anuleaza'),
            ),
            TextButton(
              onPressed: () {
                final number = int.tryParse(controller.text);
                if (number != null && number > 0) {
                  result = 'Ultimele $number';
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Aplica'),
            ),
          ],
        );
      },
    );
    return result;
  }
}
