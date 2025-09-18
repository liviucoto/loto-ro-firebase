import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';

class HomeGameSelectorHeader extends StatelessWidget {
  final GameType selectedGame;
  final ValueChanged<GameType> onChanged;

  const HomeGameSelectorHeader({
    super.key,
    required this.selectedGame,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGameButton(context, GameType.joker, 'Joker'),
          const SizedBox(width: 12),
          _buildGameButton(context, GameType.loto649, '6 din 49'),
          const SizedBox(width: 12),
          _buildGameButton(context, GameType.loto540, '5 din 40'),
        ],
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, GameType game, String label) {
    final bool isSelected = selectedGame == game;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(game),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.black.withValues(alpha: 0.10).withAlpha(60).withValues(alpha: 0.32)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
