import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';
import 'services/platform_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ini?ializeaza serviciile pentru platforma curenta
  await PlatformService().initializeServices();

  runApp(const LotoROApp());
}

class LotoROApp extends StatelessWidget {
  const LotoROApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Culori principale
        primarySwatch: Colors.green,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: Colors.transparent,

        // Card theme
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppFonts.titleStyle,
        ),

        // Text theme
        textTheme: const TextTheme(
          headlineLarge: AppFonts.titleStyle,
          headlineMedium: AppFonts.subtitleStyle,
          bodyLarge: AppFonts.bodyStyle,
          bodyMedium: AppFonts.bodyStyle,
          bodySmall: AppFonts.captionStyle,
        ),

        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glassBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            borderSide: const BorderSide(
              color: AppColors.primaryGreen,
              width: 2,
            ),
          ),
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconMedium,
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ).copyWith(brightness: Brightness.light),

        // Font family
        fontFamily: AppFonts.primaryFont,
      ),
      home: const HomeScreen(),
    );
  }
}
