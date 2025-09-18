import 'package:flutter/material.dart';

/// Constante pentru design si stilizare LotoRO
/// Paleta de culori, fonturi, stiluri glassmorphism, dimensiuni

class AppColors {
  // Verde pastel (principal, noroc, optimism, fresh)
  static const Color primaryGreen = Color(0xFF6EE7B7);
  static const Color primaryGreenMedium = Color(0xFF34D399);
  static const Color primaryGreenDark = Color(0xFF059669);

  // Albastru pastel (secundar, calm, incredere)
  static const Color secondaryBlue = Color(0xFFA7C7E7);
  static const Color secondaryBlueMedium = Color(0xFF60A5FA);

  // Galben pastel (energie, optimism)
  static const Color accentYellow = Color(0xFFFDE68A);
  static const Color accentYellowMedium = Color(0xFFFBBF24);

  // Gri deschis/white glass (transparenta, modern)
  static const Color glassLight = Color(0xFFF3F4F6);
  static const Color glassMedium = Color(0xFFE5E7EB);

  // Mov pastel (pentru contrast subtil)
  static const Color accentPurple = Color(0xFFC4B5FD);
  static const Color accentPurpleMedium = Color(0xFFA78BFA);

  // Rosu pastel (pentru erori, avertismente)
  static const Color errorRed = Color(0xFFFCA5A5);
  static const Color errorRedMedium = Color(0xFFF87171);

  // Culori pentru fundal ?i text
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Culori pentru glassmorphism
  static const Color glassBackground = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x20FFFFFF);
  static const Color glassShadow = Color(0x10000000);
}

class AppFonts {
  // Fonturi principale
  static const String primaryFont = 'Poppins';
  static const String secondaryFont = 'Montserrat';
  static const String accentFont = 'Inter';

  // Dimensiuni fonturi
  static const double titleLarge = 24.0;
  static const double titleMedium = 20.0;
  static const double titleSmall = 18.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double caption = 10.0;

  // Stiluri text
  static const TextStyle titleStyle = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    fontSize: titleLarge,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    fontSize: titleMedium,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.normal,
    fontSize: bodyMedium,
    color: AppColors.textPrimary,
  );

  static const TextStyle captionStyle = TextStyle(
    fontFamily: secondaryFont,
    fontWeight: FontWeight.normal,
    fontSize: bodySmall,
    color: AppColors.textSecondary,
  );
}

class AppSizes {
  // Dimensiuni generale
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Inaltimi componente
  static const double buttonHeight = 48.0;
  static const double cardHeight = 80.0;
  static const double bottomBarHeight = 80.0;
  static const double headerHeight = 120.0;
  static const double gameSelectorHeight = 60.0;

  // Latimi
  static const double buttonMinWidth = 120.0;
  static const double cardMinWidth = 300.0;

  // Iconuri
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}

class AppShadows {
  // Umbre pentru glassmorphism
  static const List<BoxShadow> glassShadow = [
    BoxShadow(
      color: AppColors.glassShadow,
      blurRadius: 10.0,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.glassShadow,
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: AppColors.glassShadow,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ];
}

class AppDecorations {
  // Decoruri pentru glassmorphism
  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColors.glassBackground,
    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
    border: Border.all(color: AppColors.glassBorder, width: 1.0),
    boxShadow: AppShadows.glassShadow,
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
    boxShadow: AppShadows.cardShadow,
  );

  static BoxDecoration buttonDecoration = BoxDecoration(
    color: AppColors.primaryGreen,
    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
    boxShadow: AppShadows.buttonShadow,
  );

  static BoxDecoration numberBallDecoration = BoxDecoration(
    color: AppColors.primaryGreen,
    shape: BoxShape.circle,
    boxShadow: AppShadows.buttonShadow,
  );
}

class AppAnimations {
  // Durate anima?ii
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  // Curbe anima?ii
  static const Curve easeInOut = Curves.easeInOutCubic;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
}

class AppGradients {
  // Gradiente pentru efecte vizuale
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryGreen, AppColors.primaryGreenMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [AppColors.glassBackground, AppColors.glassMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accentYellow, AppColors.accentYellowMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGameTypes {
  // Tipuri de jocuri
  static const String joker = 'joker';
  static const String sixFromFortyNine = '6din49';
  static const String fiveFromForty = '5din40';

  // Configuratii per joc
  static const Map<String, Map<String, dynamic>> gameConfigs = {
    joker: {
      'name': 'Joker',
      'mainNumbers': 5,
      'mainRange': 45,
      'additionalNumbers': 1,
      'additionalRange': 20,
      'color': AppColors.primaryGreen,
    },
    sixFromFortyNine: {
      'name': '6 din 49',
      'mainNumbers': 6,
      'mainRange': 49,
      'additionalNumbers': 0,
      'additionalRange': 0,
      'color': AppColors.secondaryBlue,
    },
    fiveFromForty: {
      'name': '5 din 40',
      'mainNumbers': 5,
      'mainRange': 40,
      'additionalNumbers': 0,
      'additionalRange': 0,
      'color': AppColors.accentPurple,
    },
  };
}

class AppStrings {
  // Texte pentru aplicatie
  static const String appName = 'LotoRO';
  static const String appTagline = 'Statistici si Generator Inteligent';

  // Taburi
  static const String archiveTab = 'Arhiva';
  static const String statisticsTab = 'Statistici';
  static const String generatorTab = 'Generator';
  static const String settingsTab = 'Setari';

  // Mesaje
  static const String loadingMessage = 'Se incarca...';
  static const String errorMessage = 'A aparut o eroare';
  static const String noDataMessage = 'Nu exista date disponibile';

  // Butoane
  static const String generateButton = 'Genereaza';
  static const String saveButton = 'Salveaza';
  static const String cancelButton = 'Anuleaza';
  static const String confirmButton = 'Confirma';
}

enum GameType { joker, loto649, loto540 }

extension GameTypeExtension on GameType {
  Map<String, dynamic> toJson() => {'gameType': key};
  String get key {
    switch (this) {
      case GameType.joker:
        return AppGameTypes.joker;
      case GameType.loto649:
        return AppGameTypes.sixFromFortyNine;
      case GameType.loto540:
        return AppGameTypes.fiveFromForty;
    }
  }

  String get csvName => key;

  String get displayName {
    switch (this) {
      case GameType.joker:
        return 'Joker';
      case GameType.loto649:
        return '6 din 49';
      case GameType.loto540:
        return '5 din 40';
    }
  }

  static GameType fromKey(String key) {
    switch (key) {
      case AppGameTypes.joker:
        return GameType.joker;
      case AppGameTypes.sixFromFortyNine:
        return GameType.loto649;
      case AppGameTypes.fiveFromForty:
        return GameType.loto540;
      default:
        throw ArgumentError('Invalid game key: $key');
    }
  }
}
