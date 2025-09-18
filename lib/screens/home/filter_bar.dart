import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedFilter;
  final List<String> filterOptions;
  final String selectedSort;
  final List<String> sortOptions;
  final ValueChanged<String?> onFilterChanged;
  final ValueChanged<String?> onSortChanged;
  final VoidCallback onResetFilters;

  const FilterBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedFilter,
    required this.filterOptions,
    required this.selectedSort,
    required this.sortOptions,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(hintText: 'Caută extrageri...'),
            ),
          ),
          const SizedBox(width: 8),
          // Filter dropdown
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              value: selectedFilter,
              items: filterOptions
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: onFilterChanged,
              hint: const Text('Filtru'),
              isExpanded: true,
            ),
          ),
          const SizedBox(width: 8),
          // Sort dropdown
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              value: selectedSort,
              items: sortOptions
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: onSortChanged,
              hint: const Text('Sortare'),
              isExpanded: true,
            ),
          ),
          const SizedBox(width: 8),
          // Reset button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onResetFilters,
            tooltip: 'Resetează filtrele',
          ),
        ],
      ),
    );
  }
}
