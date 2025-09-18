import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:loto_ro/screens/home/filter_bar.dart';

void main() {
  testWidgets('FilterBar displays search, filter, sort, and reset', (
    WidgetTester tester,
  ) async {
    final searchController = TextEditingController();
    String? selectedFilter = 'Toate extragerile';
    String? selectedSort = 'Dată descendent';
    bool resetPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterBar(
            searchController: searchController,
            searchQuery: '',
            selectedFilter: selectedFilter,
            filterOptions: ['Toate extragerile', 'Doar cu numere pare'],
            selectedSort: selectedSort,
            sortOptions: ['Dată descendent', 'Dată ascendent'],
            onFilterChanged: (v) => selectedFilter = v,
            onSortChanged: (v) => selectedSort = v,
            onResetFilters: () => resetPressed = true,
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsNWidgets(2));
    expect(find.byIcon(Icons.refresh), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test');
    expect(searchController.text, 'test');

    await tester.tap(find.byIcon(Icons.refresh));
    expect(resetPressed, isTrue);
  });
}
