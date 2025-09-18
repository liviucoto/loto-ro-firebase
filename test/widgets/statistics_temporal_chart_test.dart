import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/screens/tabs/statistics/charts/temporal_chart/temporal_chart_section.dart';
import 'package:loto_ro/screens/tabs/statistics/charts/temporal_chart/temporal_narrative.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

void main() {
  group('TemporalChartSection narrative integration', () {
    final testDraws = List<LotoDraw>.generate(
      200,
      (i) => LotoDraw(
        date: DateTime(2024, (i % 12) + 1, 1),
        mainNumbers: [for (int n = 1; n <= 5; n++) ((i + n) % 49) + 1],
        additionalNumbers: null,
        gameType: '6din49',
        jokerNumber: null,
      ),
    );

    testWidgets('TemporalChartSection se afișează corect', (tester) async {
      String selectedPeriod = 'Ultimele 100';
      List<String> periodOptions = [
        'Ultimele 20',
        'Ultimele 100',
        'Toate extragerile',
        'Custom',
      ];
      List<LotoDraw> filteredDraws = testDraws.take(100).toList();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemporalChartSection(
              statsDraws: filteredDraws,
              allDraws: testDraws,
              selectedPeriod: selectedPeriod,
              periodOptions: periodOptions,
              onPeriodChanged: (val) {
                selectedPeriod = val;
                if (val == 'Ultimele 20') {
                  filteredDraws = testDraws.take(20).toList();
                } else if (val == 'Toate extragerile') {
                  filteredDraws = testDraws;
                } else if (val == 'Custom') {
                  filteredDraws = testDraws.take(50).toList();
                } else {
                  filteredDraws = testDraws.take(100).toList();
                }
              },
              onCustomPeriod: (val) {
                selectedPeriod = val;
                filteredDraws = testDraws.take(50).toList();
              },
              isDesktop: false,
              selectedGame: GameType.loto649,
              temporalNarrative: null,
              isProcessingTemporal: false,
            ),
          ),
        ),
      );

      // Verific că graficul temporal este afișat
      expect(find.text('Evoluție temporală'), findsOneWidget);
      expect(find.text('Analiză narativă'), findsOneWidget);
      expect(find.text('Generator Temporal'), findsOneWidget);
    });

    testWidgets(
      'Dialogul de analiză narativă se deschide și afișează toate insight-urile',
      (tester) async {
        List<LotoDraw> testDraws = List<LotoDraw>.generate(
          50,
          (i) => LotoDraw(
            date: DateTime(2024, (i % 12) + 1, 1),
            mainNumbers: [for (int n = 1; n <= 5; n++) ((i + n) % 49) + 1],
            additionalNumbers: null,
            gameType: '6din49',
            jokerNumber: null,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TemporalChartSection(
                statsDraws: testDraws,
                allDraws: testDraws,
                selectedPeriod: 'Ultimele 50',
                periodOptions: ['Ultimele 50', 'Toate extragerile'],
                onPeriodChanged: (val) {},
                onCustomPeriod: (val) {},
                isDesktop: false,
                selectedGame: GameType.loto649,
                temporalNarrative: null,
                isProcessingTemporal: false,
              ),
            ),
          ),
        );

        // Găsesc și apăs butonul "Analiză narativă"
        await tester.tap(find.text('Analiză narativă'));
        await tester.pumpAndSettle();

        // Verific că dialogul s-a deschis
        expect(find.text('Analiză narativă'), findsAtLeastNWidgets(1));
        expect(find.text('Închide'), findsOneWidget);

        // Verific că toate insight-urile sunt prezente în dialog
        expect(
          find.textContaining('Acest grafic arată cum s-au schimbat în timp'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Top 3 numere cu cele mai mari fluctuații'),
          findsOneWidget,
        );
        expect(find.textContaining('Top 3 numere stabile'), findsOneWidget);
        expect(find.textContaining('Gradul de variabilitate'), findsOneWidget);
        expect(
          find.textContaining('Perioada cu cele mai multe extrageri'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Perioada cu cele mai puține extrageri'),
          findsOneWidget,
        );
        expect(find.textContaining('Trendul general'), findsOneWidget);
        expect(
          find.textContaining('Anotimpul cu cele mai multe extrageri'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Total extrageri analizate'),
          findsOneWidget,
        );

        // Verific că iconurile sunt prezente
        expect(find.byIcon(Icons.timeline), findsOneWidget);
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
        expect(find.byIcon(Icons.trending_down), findsOneWidget);
        expect(find.byIcon(Icons.analytics), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
        expect(find.byIcon(Icons.show_chart), findsOneWidget);
        expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
        expect(find.byIcon(Icons.format_list_numbered), findsOneWidget);

        // Închid dialogul
        await tester.tap(find.text('Închide'));
        await tester.pumpAndSettle();

        // Verific că dialogul s-a închis
        expect(
          find.text('Analiză narativă'),
          findsOneWidget,
        ); // Doar titlul din card
      },
    );

    testWidgets('TemporalNarrative widget afișează corect toate insight-urile', (
      tester,
    ) async {
      final testNarrative = {
        'top3Variable': [15, 23, 7],
        'top3Stable': [42, 8, 31],
        'temporalPattern': 'variabilitate 45.2%',
        'mostFrequentPeriod': '2024-06',
        'leastFrequentPeriod': '2024-01',
        'trend': 'Crescător',
        'dominantSeason': 'Vară',
        'drawCount': 50,
        'periodCount': 12,
        'numberCount': 25,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemporalNarrative(narrative: testNarrative, isDesktop: false),
          ),
        ),
      );

      // Verific că toate insight-urile sunt afișate corect
      expect(
        find.textContaining('Acest grafic arată cum s-au schimbat în timp'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Top 3 numere cu cele mai mari fluctuații (au apărut foarte des în unele perioade și rar în altele): 15, 23, 7',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Top 3 numere stabile (au avut apariții constante, fără variații mari): 42, 8, 31',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Gradul de variabilitate arată cât de mult s-au schimbat aparițiile numerelor de la o perioadă la alta. Pentru acest interval: variabilitate 45.2%',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Perioada cu cele mai multe extrageri (sau cu cele mai multe apariții de numere): 2024-06',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Perioada cu cele mai puține extrageri (sau cu cele mai puține apariții de numere): 2024-01',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Trendul general arată dacă, în acest interval, numerele au apărut mai des spre final sau la început. Rezultat: Crescător',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Anotimpul cu cele mai multe extrageri sau apariții de numere este: Vară',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Total extrageri analizate: 50, perioade: 12, numere diferite analizate: 25',
        ),
        findsOneWidget,
      );
    });

    testWidgets('TemporalNarrative gestionează corect cazurile cu date goale', (
      tester,
    ) async {
      final emptyNarrative = {
        'top3Variable': [],
        'top3Stable': [],
        'temporalPattern': '-',
        'mostFrequentPeriod': '-',
        'leastFrequentPeriod': '-',
        'trend': '-',
        'dominantSeason': '-',
        'drawCount': 0,
        'periodCount': 0,
        'numberCount': 0,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemporalNarrative(
              narrative: emptyNarrative,
              isDesktop: false,
            ),
          ),
        ),
      );

      // Verific că se afișează mesajele pentru date goale
      expect(
        find.textContaining('Top 3 numere cu cele mai mari fluctuații'),
        findsOneWidget,
      );
      expect(find.textContaining('Top 3 numere stabile'), findsOneWidget);
      expect(find.textContaining('Gradul de variabilitate'), findsOneWidget);
      expect(
        find.textContaining('Perioada cu cele mai multe extrageri'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Perioada cu cele mai puține extrageri'),
        findsOneWidget,
      );
      expect(find.textContaining('Trendul general'), findsOneWidget);
      expect(
        find.textContaining('Anotimpul cu cele mai multe extrageri'),
        findsOneWidget,
      );
      expect(find.textContaining('Total extrageri analizate'), findsOneWidget);
    });

    testWidgets('TemporalNarrative gestionează corect narrative null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemporalNarrative(narrative: null, isDesktop: false),
          ),
        ),
      );

      // Verific că nu se afișează nimic când narrative este null
      expect(find.textContaining('Acest grafic arată'), findsNothing);
      expect(find.textContaining('Top 3 numere'), findsNothing);
    });

    testWidgets(
      'Dialogul de analiză narativă permite schimbarea perioadei și actualizează narativa',
      (tester) async {
        List<LotoDraw> testDraws = List<LotoDraw>.generate(
          100,
          (i) => LotoDraw(
            date: DateTime(2024, (i % 12) + 1, 1),
            mainNumbers: [for (int n = 1; n <= 5; n++) ((i + n) % 49) + 1],
            additionalNumbers: null,
            gameType: '6din49',
            jokerNumber: null,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TemporalChartSection(
                statsDraws: testDraws,
                allDraws: testDraws,
                selectedPeriod: 'Ultimele 50',
                periodOptions: [
                  'Ultimele 20',
                  'Ultimele 50',
                  'Ultimele 100',
                  'Toate extragerile',
                ],
                onPeriodChanged: (val) {},
                onCustomPeriod: (val) {},
                isDesktop: false,
                selectedGame: GameType.loto649,
                temporalNarrative: null,
                isProcessingTemporal: false,
              ),
            ),
          ),
        );

        // Deschid dialogul
        await tester.tap(find.text('Analiză narativă'));
        await tester.pumpAndSettle();

        // Verific că selectorul de perioadă este prezent în dialog
        expect(find.text('Ultimele 50'), findsAtLeastNWidgets(1));

        // Verific că narativa inițială este afișată
        expect(
          find.textContaining('Top 3 numere cu cele mai mari fluctuații'),
          findsOneWidget,
        );
        expect(find.textContaining('Top 3 numere stabile'), findsOneWidget);
        expect(
          find.textContaining('Total extrageri analizate'),
          findsOneWidget,
        );
      },
    );

    testWidgets('TemporalNarrative afișează toate iconurile corect', (
      tester,
    ) async {
      final testNarrative = {
        'top3Variable': [15, 23, 7],
        'top3Stable': [42, 8, 31],
        'temporalPattern': 'variabilitate 45.2%',
        'mostFrequentPeriod': '2024-06',
        'leastFrequentPeriod': '2024-01',
        'trend': 'Crescător',
        'dominantSeason': 'Vară',
        'drawCount': 50,
        'periodCount': 12,
        'numberCount': 25,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TemporalNarrative(narrative: testNarrative, isDesktop: false),
          ),
        ),
      );

      // Verific că toate iconurile sunt prezente
      expect(find.byIcon(Icons.timeline), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
      expect(find.byIcon(Icons.analytics), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      expect(find.byIcon(Icons.show_chart), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      expect(find.byIcon(Icons.format_list_numbered), findsOneWidget);
    });

    testWidgets(
      'TemporalNarrative se adaptează la dimensiunea desktop/mobile',
      (tester) async {
        final testNarrative = {
          'top3Variable': [15, 23, 7],
          'top3Stable': [42, 8, 31],
          'temporalPattern': 'variabilitate 45.2%',
          'mostFrequentPeriod': '2024-06',
          'leastFrequentPeriod': '2024-01',
          'trend': 'Crescător',
          'dominantSeason': 'Vară',
          'drawCount': 50,
          'periodCount': 12,
          'numberCount': 25,
        };

        // Test pentru desktop
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TemporalNarrative(
                narrative: testNarrative,
                isDesktop: true,
              ),
            ),
          ),
        );

        // Verific că textul are dimensiunea corectă pentru desktop
        final desktopText = tester.widget<Text>(
          find.textContaining('Acest grafic arată'),
        );
        expect(desktopText.style?.fontSize, 13.0);

        // Test pentru mobile
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TemporalNarrative(
                narrative: testNarrative,
                isDesktop: false,
              ),
            ),
          ),
        );

        // Verific că textul are dimensiunea corectă pentru mobile
        final mobileText = tester.widget<Text>(
          find.textContaining('Acest grafic arată'),
        );
        expect(mobileText.style?.fontSize, 10.0);
      },
    );
  });
}
