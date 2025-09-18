/// Model pentru o extragere de loterie
class LotoDraw {
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'mainNumbers': mainNumbers,
    'additionalNumbers': additionalNumbers,
    'gameType': gameType,
    'jokerNumber': jokerNumber,
  };
  final DateTime date;
  final List<int> mainNumbers;
  final List<int>? additionalNumbers; // Pentru Joker
  final String gameType; // 'joker', '6din49', '5din40'
  final int? jokerNumber; // Pentru Joker (1-20)

  const LotoDraw({
    required this.date,
    required this.mainNumbers,
    this.additionalNumbers,
    required this.gameType,
    this.jokerNumber,
  });

  /// Factory constructor pentru crearea unui LotoDraw dintr-un rand CSV
  factory LotoDraw.fromCsvRow(Map<String, dynamic> row, String gameType) {
    // Functie helper pentru a normaliza data la format YYYY-MM-DD
    String normalizeDate(String dateStr) {
      // Daca data este deja in format YYYY-MM-DD, o returnam
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
        return dateStr;
      }

      // Daca data este in format YYYY-M-D, o normalizam
      if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(dateStr)) {
        final parts = dateStr.split('-');
        final year = parts[0];
        final month = parts[1].padLeft(2, '0');
        final day = parts[2].padLeft(2, '0');
        return '$year-$month-$day';
      }

      // Daca nu se potriveste cu niciun format cunoscut, aruncam o eroare
      throw FormatException('Invalid date format: $dateStr');
    }

    final dateStr = row['data'] as String;
    final normalizedDateStr = normalizeDate(dateStr);
    final date = DateTime.parse(normalizedDateStr);

    List<int> mainNumbers = [];
    List<int>? additionalNumbers;
    int? jokerNumber;

    // Functie helper pentru a converti valoarea in int
    int parseToInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw ArgumentError('Cannot convert $value to int');
    }

    switch (gameType) {
      case 'joker':
        // Joker: 5 numere principale + 1 joker
        mainNumbers = [
          parseToInt(row['numar_1']),
          parseToInt(row['numar_2']),
          parseToInt(row['numar_3']),
          parseToInt(row['numar_4']),
          parseToInt(row['numar_5']),
        ];
        jokerNumber = parseToInt(row['joker']);
        break;

      case '6din49':
        // 6 din 49: 6 numere principale
        mainNumbers = [
          parseToInt(row['numar_1']),
          parseToInt(row['numar_2']),
          parseToInt(row['numar_3']),
          parseToInt(row['numar_4']),
          parseToInt(row['numar_5']),
          parseToInt(row['numar_6']),
        ];
        break;

      case '5din40':
        // 5 din 40: 5 numere principale
        mainNumbers = [
          parseToInt(row['numar_1']),
          parseToInt(row['numar_2']),
          parseToInt(row['numar_3']),
          parseToInt(row['numar_4']),
          parseToInt(row['numar_5']),
        ];
        break;
    }

    return LotoDraw(
      date: date,
      mainNumbers: mainNumbers,
      additionalNumbers: additionalNumbers,
      gameType: gameType,
      jokerNumber: jokerNumber,
    );
  }

  /// Returneaza toate numerele din extragere (inclusiv joker pentru Joker)
  List<int> getAllNumbers() {
    List<int> allNumbers = List.from(mainNumbers);
    if (additionalNumbers != null) {
      allNumbers.addAll(additionalNumbers!);
    }
    if (jokerNumber != null) {
      allNumbers.add(jokerNumber!);
    }
    return allNumbers;
  }

  /// Verifica daca o combinatie de numere castiga
  Map<String, int> checkWinningNumbers(List<int> userNumbers) {
    int mainMatches = 0;
    int additionalMatches = 0;
    bool jokerMatch = false;

    // Verifica numerele principale
    for (int number in userNumbers) {
      if (mainNumbers.contains(number)) {
        mainMatches++;
      }
    }

    // Verifica numerele suplimentare (daca exista)
    if (additionalNumbers != null) {
      for (int number in userNumbers) {
        if (additionalNumbers!.contains(number)) {
          additionalMatches++;
        }
      }
    }

    // Verifica joker (daca exista)
    if (jokerNumber != null && userNumbers.contains(jokerNumber)) {
      jokerMatch = true;
    }

    return {
      'mainMatches': mainMatches,
      'additionalMatches': additionalMatches,
      'jokerMatch': jokerMatch ? 1 : 0,
    };
  }

  /// Returneaza descrierea extragerii
  String getDescription() {
    String desc =
        '${gameType.toUpperCase()} - ${date.day}/${date.month}/${date.year}\n';
    desc += 'Numere: ${mainNumbers.join(', ')}';

    if (jokerNumber != null) {
      desc += '\nJoker: $jokerNumber';
    }

    return desc;
  }

  /// Returneaza numarul maxim de numere pentru acest joc
  int getMaxNumbers() {
    switch (gameType) {
      case 'joker':
        return 5;
      case '6din49':
        return 6;
      case '5din40':
        return 5;
      default:
        return 0;
    }
  }

  /// Returneaza intervalul de numere pentru acest joc
  Map<String, int> getNumberRange() {
    switch (gameType) {
      case 'joker':
        return {'min': 1, 'max': 45, 'jokerMax': 20};
      case '6din49':
        return {'min': 1, 'max': 49, 'jokerMax': 0};
      case '5din40':
        return {'min': 1, 'max': 40, 'jokerMax': 0};
      default:
        return {'min': 1, 'max': 1, 'jokerMax': 0};
    }
  }

  /// Statistici rapide pentru extragere (fara Joker la Joker)
  int get sum => mainNumbers.fold(0, (a, b) => a + b);
  int get evenCount => mainNumbers.where((n) => n % 2 == 0).length;
  int get oddCount => mainNumbers.where((n) => n % 2 != 0).length;
  double get average => mainNumbers.isEmpty ? 0 : sum / mainNumbers.length;
  int get minNumber =>
      mainNumbers.isEmpty ? 0 : mainNumbers.reduce((a, b) => a < b ? a : b);
  int get maxNumber =>
      mainNumbers.isEmpty ? 0 : mainNumbers.reduce((a, b) => a > b ? a : b);

  @override
  String toString() {
    return 'LotoDraw{date: $date, mainNumbers: $mainNumbers, gameType: $gameType, jokerNumber: $jokerNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LotoDraw &&
        other.date == date &&
        other.gameType == gameType;
  }

  @override
  int get hashCode => date.hashCode ^ gameType.hashCode;
}
