import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformService {
  // Singleton pattern
  static final PlatformService _instance = PlatformService._internal();
  factory PlatformService() => _instance;
  PlatformService._internal();

  /// Detectează platforma curentă
  bool get isWeb => kIsWeb;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isLinux => !kIsWeb && Platform.isLinux;
  bool get isMobile => isAndroid || isIOS;
  bool get isDesktop => isWindows || isMacOS || isLinux;

  /// Returnează numele platformei
  String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWindows) return 'Windows';
    if (isMacOS) return 'macOS';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Verifică dacă platforma suportă funcționalități avansate
  bool get supportsAdvancedFeatures {
    // Web nu poate executa procese de sistem
    if (isWeb) return false;
    // Mobile poate avea limitări
    if (isMobile) return true;
    // Desktop suportă toate funcționalitățile
    return true;
  }

  /// Verifică dacă platforma poate porni servicii externe
  bool get canStartExternalServices {
    // Doar desktop poate porni servicii externe
    return isDesktop;
  }

  /// Returnează configurația optimă pentru platforma curentă
  Map<String, dynamic> get optimalConfiguration {
    return {
      'useLocalAI': true, // Întotdeauna folosim AI local
      'useBackend': false, // Nu mai folosim backend extern
      'autoStart': true, // Pornire automată
      'cacheEnabled': true, // Cache activat
      'offlineMode': true, // Mod offline disponibil
    };
  }

  /// Inițializează serviciile pentru platforma curentă
  Future<void> initializeServices() async {
    print('🚀 Inițializez serviciile pentru platforma: $platformName');

    if (isWeb) {
      print('🌐 Platforma Web - folosesc servicii locale');
    } else if (isMobile) {
      print('📱 Platforma Mobile - optimizat pentru performanță');
    } else if (isDesktop) {
      print('💻 Platforma Desktop - toate funcționalitățile disponibile');
    }

    // Aici se pot adăuga inițializări specifice platformei
    await _initializePlatformSpecific();
  }

  /// Inițializare specifică platformei
  Future<void> _initializePlatformSpecific() async {
    try {
      if (isAndroid || isIOS) {
        // Configurații pentru mobile
        await _configureMobile();
      } else if (isDesktop) {
        // Configurații pentru desktop
        await _configureDesktop();
      } else if (isWeb) {
        // Configurații pentru web
        await _configureWeb();
      }
    } catch (e) {
      print('⚠️ Eroare la inițializarea specifică platformei: $e');
    }
  }

  /// Configurează platforma mobile
  Future<void> _configureMobile() async {
    print('📱 Configurare mobile...');
    // Optimizări pentru mobile
    // - Cache mai agresiv
    // - Generare mai rapidă
    // - UI optimizat pentru touch
  }

  /// Configurează platforma desktop
  Future<void> _configureDesktop() async {
    print('💻 Configurare desktop...');
    // Funcționalități avansate pentru desktop
    // - Generare mai complexă
    // - Interfață extinsă
    // - Integrare cu sistemul de fișiere
  }

  /// Configurează platforma web
  Future<void> _configureWeb() async {
    print('🌐 Configurare web...');
    // Limitări pentru web
    // - Generare locală
    // - Cache în localStorage
    // - UI adaptat pentru browser
  }

  /// Verifică dacă aplicația poate rula în modul automatizat
  bool get canRunAutomated {
    return true; // Toate platformele suportă automatizarea locală
  }

  /// Returnează mesajul de status pentru platforma curentă
  String get statusMessage {
    if (isWeb) {
      return '🌐 Aplicația rulează în browser cu AI local';
    } else if (isMobile) {
      return '📱 Aplicația rulează pe dispozitiv cu AI local';
    } else if (isDesktop) {
      return '💻 Aplicația rulează pe desktop cu AI local';
    }
    return '❓ Platforma necunoscută';
  }

  /// Returnează recomandările pentru platforma curentă
  List<String> get recommendations {
    final recommendations = <String>[];

    if (isWeb) {
      recommendations.addAll([
        '✅ AI local - nu necesită backend extern',
        '✅ Funcționează în orice browser',
        '✅ Nu necesită instalare',
        '⚠️ Limitări de performanță în browser',
      ]);
    } else if (isMobile) {
      recommendations.addAll([
        '✅ AI local optimizat pentru mobile',
        '✅ Performanță optimă',
        '✅ Funcționează offline',
        '✅ Interfață adaptată pentru touch',
      ]);
    } else if (isDesktop) {
      recommendations.addAll([
        '✅ AI local cu performanță maximă',
        '✅ Toate funcționalitățile disponibile',
        '✅ Funcționează offline',
        '✅ Interfață desktop completă',
      ]);
    }

    return recommendations;
  }
}
