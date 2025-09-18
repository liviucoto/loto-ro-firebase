import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';

class GameSelector extends StatefulWidget {
  final GameType selectedGame;
  final Function(GameType) onGameChanged;

  const GameSelector({
    super.key,
    required this.selectedGame,
    required this.onGameChanged,
  });

  @override
  State<GameSelector> createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int _pressedIndex = -1;

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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
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
  void didUpdateWidget(covariant GameSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedGame != oldWidget.selectedGame) {
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _pressedIndex = -1;
      });
    }
  }

  void _onTapDown(int index) {
    setState(() => _pressedIndex = index);
    _animationController.forward();
  }

  void _onTapUp(int index) {
    setState(() => _pressedIndex = -1);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _pressedIndex = -1);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Iconuri pentru fiecare joc
    IconData gameIcon(GameType game) {
      switch (game) {
        case GameType.joker:
          return Icons.stars;
        case GameType.loto649:
          return Icons.casino;
        case GameType.loto540:
          return Icons.sports_esports;
        default:
          return Icons.casino;
      }
    }

    // Paleta pastel pentru fiecare joc
    Color gameColor(GameType game) {
      switch (game) {
        case GameType.joker:
          return const Color(0xFFB39DDB); // pastel mov
        case GameType.loto649:
          return const Color(0xFFB2F0E6); // pastel bleu
        case GameType.loto540:
          return const Color(0xFFC8E6C9); // pastel verde
        default:
          return Colors.white;
      }
    }

    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xB0FFFFFF),
            Color(0x80B2F0E6),
            Color(0x80D1C4E9),
            Color(0x80FDE68A),
            Color(0x80B9F6CA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: GameType.values.map((game) {
          final isSelected = widget.selectedGame == game;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onGameChanged(game),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                decoration: isSelected
                    ? BoxDecoration(
                        color: gameColor(game).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: gameColor(game), width: 2.2),
                        boxShadow: [
                          BoxShadow(
                            color: gameColor(game).withValues(alpha: 0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      )
                    : null,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        gameIcon(game),
                        size: 18,
                        color: isSelected ? gameColor(game) : Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        game.displayName,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? gameColor(game).withValues(alpha: 0.95)
                              : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    blurRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
