import 'package:flutter/material.dart';

class AppColors {
  // Culori principale
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryGreenMedium = Color(0xFF66BB6A);
  static const Color primaryGreenLight = Color(0xFF81C784);

  static const Color secondaryBlue = Color(0xFF2196F3);
  static const Color secondaryBlueMedium = Color(0xFF42A5F5);
  static const Color secondaryBlueLight = Color(0xFF64B5F6);

  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentPurpleMedium = Color(0xFFAB47BC);
  static const Color accentPurpleLight = Color(0xFFBA68C8);

  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentYellowMedium = Color(0xFFFFCA28);
  static const Color accentYellowLight = Color(0xFFFFD54F);

  // Culori pentru glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassMedium = Color(0x33FFFFFF);
  static const Color glassStrong = Color(0x4DFFFFFF);

  // Culori de fundal
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);

  // Culori pentru text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);

  // Culori pentru bile numerotate
  static const Color pastelGreen = Color(0xFF81C784);
  static const Color pastelBlue = Color(0xFF64B5F6);
  static const Color pastelPurple = Color(0xFFBA68C8);
  static const Color pastelYellow = Color(0xFFFFF176);
  static const Color pastelOrange = Color(0xFFFFB74D);
  static const Color pastelGray = Color(0xFFE0E0E0);
}

class AppFonts {
  // Stiluri de text
  static const TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle smallStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.3,
  );
}

class AppSpacing {
  // Spacing-uri consistente
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  // Border radius-uri consistente
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}

class AppShadows {
  // Umbre pentru glassmorphism
  static const List<BoxShadow> glass = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> glassStrong = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
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
  static const String appTagline = 'Statistici și Generator Inteligent';

  // Taburi
  static const String homeTab = 'Acasă';
  static const String archiveTab = 'Arhivă';
  static const String statisticsTab = 'Statistici';
  static const String generatorTab = 'Generator';
  static const String settingsTab = 'Setări';

  // Mesaje
  static const String loadingMessage = 'Se încarcă...';
  static const String errorMessage = 'A apărut o eroare';
  static const String noDataMessage = 'Nu există date disponibile';

  // Butoane
  static const String generateButton = 'Generează';
  static const String saveButton = 'Salvează';
  static const String cancelButton = 'Anulează';
  static const String confirmButton = 'Confirmă';
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
