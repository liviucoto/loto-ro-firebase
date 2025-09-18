// Arhiva Joker - Date istorice pentru jocul Joker
// Generat automat din Arhiva_Joker.csv

class JokerDraw {
  final String date;
  final String game;
  final List<int> numbers;
  final int joker;

  const JokerDraw({
    required this.date,
    required this.game,
    required this.numbers,
    required this.joker,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'game': game,
        'numbers': numbers,
        'joker': joker,
      };

  factory JokerDraw.fromJson(Map<String, dynamic> json) => JokerDraw(
        date: json['date'] as String,
        game: json['game'] as String,
        numbers: List<int>.from(json['numbers'] as List),
        joker: json['joker'] as int,
      );
}

// TODO: Adaugă aici datele din arhiva CSV pentru Joker, respectând formatul de mai jos.
final List<JokerDraw> dataJoker = [
  JokerDraw(
      date: '2000-09-14',
      game: 'Joker',
      numbers: [4, 30, 32, 39, 27],
      joker: 7),
  JokerDraw(
      date: '2000-09-21',
      game: 'Joker',
      numbers: [9, 31, 24, 41, 39],
      joker: 7),
  JokerDraw(
      date: '2000-09-28',
      game: 'Joker',
      numbers: [19, 1, 28, 43, 38],
      joker: 11),
  JokerDraw(
      date: '2000-10-05',
      game: 'Joker',
      numbers: [33, 35, 18, 19, 30],
      joker: 18),
  JokerDraw(
      date: '2000-10-12',
      game: 'Joker',
      numbers: [26, 28, 32, 35, 12],
      joker: 11),
  JokerDraw(
      date: '2000-10-19',
      game: 'Joker',
      numbers: [27, 7, 32, 6, 38],
      joker: 12),
  JokerDraw(
      date: '2000-10-26',
      game: 'Joker',
      numbers: [35, 19, 29, 7, 23],
      joker: 14),
  JokerDraw(
      date: '2000-11-02',
      game: 'Joker',
      numbers: [12, 10, 7, 24, 44],
      joker: 17),
  JokerDraw(
      date: '2000-11-09', game: 'Joker', numbers: [10, 1, 26, 7, 18], joker: 7),
  JokerDraw(
      date: '2000-11-16',
      game: 'Joker',
      numbers: [33, 39, 45, 26, 24],
      joker: 5),
  JokerDraw(
      date: '2000-11-23',
      game: 'Joker',
      numbers: [35, 13, 22, 37, 24],
      joker: 8),
  JokerDraw(
      date: '2000-11-30',
      game: 'Joker',
      numbers: [15, 44, 39, 17, 33],
      joker: 17),
  JokerDraw(
      date: '2000-12-07',
      game: 'Joker',
      numbers: [3, 44, 13, 36, 32],
      joker: 7),
  JokerDraw(
      date: '2000-12-14',
      game: 'Joker',
      numbers: [2, 13, 39, 15, 43],
      joker: 12),
  JokerDraw(
      date: '2000-12-21',
      game: 'Joker',
      numbers: [36, 35, 15, 11, 33],
      joker: 2),
  JokerDraw(
      date: '2001-01-02', game: 'Joker', numbers: [9, 28, 36, 3, 20], joker: 6),
  JokerDraw(
      date: '2001-01-11', game: 'Joker', numbers: [9, 5, 30, 40, 21], joker: 5),
  JokerDraw(
      date: '2001-01-18',
      game: 'Joker',
      numbers: [45, 31, 10, 39, 25],
      joker: 18),
  JokerDraw(
      date: '2001-01-25',
      game: 'Joker',
      numbers: [1, 19, 10, 11, 28],
      joker: 11),
  JokerDraw(
      date: '2001-02-01',
      game: 'Joker',
      numbers: [25, 21, 34, 20, 9],
      joker: 5),
  JokerDraw(
      date: '2001-02-08',
      game: 'Joker',
      numbers: [15, 37, 25, 10, 33],
      joker: 17),
  JokerDraw(
      date: '2001-02-15',
      game: 'Joker',
      numbers: [2, 21, 16, 18, 28],
      joker: 11),
  JokerDraw(
      date: '2001-02-22',
      game: 'Joker',
      numbers: [19, 2, 20, 28, 40],
      joker: 4),
  JokerDraw(
      date: '2001-03-01',
      game: 'Joker',
      numbers: [36, 11, 40, 18, 24],
      joker: 17),
  JokerDraw(
      date: '2001-03-08',
      game: 'Joker',
      numbers: [14, 6, 32, 33, 31],
      joker: 7),
  JokerDraw(
      date: '2001-03-15',
      game: 'Joker',
      numbers: [11, 42, 35, 5, 28],
      joker: 15),
  JokerDraw(
      date: '2001-03-22',
      game: 'Joker',
      numbers: [4, 21, 23, 17, 41],
      joker: 8),
  JokerDraw(
      date: '2001-03-29',
      game: 'Joker',
      numbers: [39, 38, 35, 24, 30],
      joker: 18),
  JokerDraw(
      date: '2001-04-05',
      game: 'Joker',
      numbers: [45, 15, 42, 14, 44],
      joker: 18),
  JokerDraw(
      date: '2001-04-12',
      game: 'Joker',
      numbers: [39, 5, 22, 32, 29],
      joker: 18),
  JokerDraw(
      date: '2001-04-19',
      game: 'Joker',
      numbers: [8, 28, 17, 4, 19],
      joker: 16),
  JokerDraw(
      date: '2001-04-26',
      game: 'Joker',
      numbers: [17, 19, 1, 14, 18],
      joker: 10),
  JokerDraw(
      date: '2001-05-03',
      game: 'Joker',
      numbers: [28, 40, 44, 45, 6],
      joker: 13),
  JokerDraw(
      date: '2001-05-10',
      game: 'Joker',
      numbers: [39, 21, 41, 20, 33],
      joker: 1),
  JokerDraw(
      date: '2001-05-17', game: 'Joker', numbers: [2, 34, 7, 42, 8], joker: 17),
  JokerDraw(
      date: '2001-05-24',
      game: 'Joker',
      numbers: [10, 15, 22, 41, 32],
      joker: 18),
  JokerDraw(
      date: '2001-05-31',
      game: 'Joker',
      numbers: [37, 20, 14, 13, 2],
      joker: 18),
  JokerDraw(
      date: '2001-06-07',
      game: 'Joker',
      numbers: [37, 24, 45, 30, 43],
      joker: 11),
  JokerDraw(
      date: '2001-06-14', game: 'Joker', numbers: [16, 1, 24, 5, 45], joker: 3),
  JokerDraw(
      date: '2001-06-21',
      game: 'Joker',
      numbers: [1, 39, 17, 25, 26],
      joker: 15),
  JokerDraw(
      date: '2001-06-28',
      game: 'Joker',
      numbers: [44, 26, 30, 11, 1],
      joker: 14),
  JokerDraw(
      date: '2001-07-05', game: 'Joker', numbers: [41, 24, 1, 21, 2], joker: 5),
  JokerDraw(
      date: '2001-07-12',
      game: 'Joker',
      numbers: [42, 22, 5, 34, 17],
      joker: 17),
  JokerDraw(
      date: '2001-07-19', game: 'Joker', numbers: [9, 24, 8, 22, 37], joker: 6),
  JokerDraw(
      date: '2001-07-26',
      game: 'Joker',
      numbers: [13, 26, 17, 7, 41],
      joker: 7),
  JokerDraw(
      date: '2001-08-02',
      game: 'Joker',
      numbers: [41, 13, 42, 17, 36],
      joker: 7),
  JokerDraw(
      date: '2001-08-09', game: 'Joker', numbers: [26, 6, 27, 5, 42], joker: 6),
  JokerDraw(
      date: '2001-08-16',
      game: 'Joker',
      numbers: [21, 4, 31, 2, 37],
      joker: 11),
  JokerDraw(
      date: '2001-08-23',
      game: 'Joker',
      numbers: [26, 11, 31, 19, 17],
      joker: 14),
  JokerDraw(
      date: '2001-08-30', game: 'Joker', numbers: [33, 3, 5, 25, 24], joker: 5),
  JokerDraw(
      date: '2001-09-06',
      game: 'Joker',
      numbers: [22, 7, 45, 18, 32],
      joker: 14),
  JokerDraw(
      date: '2001-09-13',
      game: 'Joker',
      numbers: [27, 37, 9, 28, 10],
      joker: 11),
  JokerDraw(
      date: '2001-09-20',
      game: 'Joker',
      numbers: [14, 44, 36, 20, 10],
      joker: 5),
  JokerDraw(
      date: '2001-09-27',
      game: 'Joker',
      numbers: [23, 1, 18, 22, 32],
      joker: 15),
  JokerDraw(
      date: '2001-10-04', game: 'Joker', numbers: [18, 8, 35, 14, 9], joker: 3),
  JokerDraw(
      date: '2001-10-11',
      game: 'Joker',
      numbers: [34, 23, 12, 20, 28],
      joker: 19),
  JokerDraw(
      date: '2001-10-18',
      game: 'Joker',
      numbers: [22, 23, 7, 34, 27],
      joker: 20),
  JokerDraw(
      date: '2001-10-25',
      game: 'Joker',
      numbers: [34, 42, 35, 20, 29],
      joker: 13),
  JokerDraw(
      date: '2001-11-01',
      game: 'Joker',
      numbers: [14, 35, 40, 28, 15],
      joker: 10),
  JokerDraw(
      date: '2001-11-08', game: 'Joker', numbers: [39, 37, 2, 8, 38], joker: 9),
  JokerDraw(
      date: '2001-11-15',
      game: 'Joker',
      numbers: [14, 35, 24, 32, 45],
      joker: 16),
  JokerDraw(
      date: '2001-11-22',
      game: 'Joker',
      numbers: [35, 14, 7, 23, 19],
      joker: 17),
  JokerDraw(
      date: '2001-11-29',
      game: 'Joker',
      numbers: [4, 19, 44, 17, 36],
      joker: 1),
  JokerDraw(
      date: '2001-12-06',
      game: 'Joker',
      numbers: [5, 30, 42, 18, 22],
      joker: 7),
  JokerDraw(
      date: '2001-12-13',
      game: 'Joker',
      numbers: [35, 12, 25, 33, 40],
      joker: 18),
  JokerDraw(
      date: '2001-12-20',
      game: 'Joker',
      numbers: [22, 44, 30, 1, 32],
      joker: 17),
  JokerDraw(
      date: '2002-01-10',
      game: 'Joker',
      numbers: [2, 18, 10, 43, 29],
      joker: 5),
  JokerDraw(
      date: '2002-01-17',
      game: 'Joker',
      numbers: [19, 4, 38, 29, 32],
      joker: 5),
  JokerDraw(
      date: '2002-01-24',
      game: 'Joker',
      numbers: [37, 8, 1, 11, 10],
      joker: 12),
  JokerDraw(
      date: '2002-01-31',
      game: 'Joker',
      numbers: [41, 28, 30, 40, 37],
      joker: 4),
  JokerDraw(
      date: '2002-02-07', game: 'Joker', numbers: [4, 38, 2, 8, 39], joker: 11),
  JokerDraw(
      date: '2002-02-14',
      game: 'Joker',
      numbers: [26, 6, 27, 45, 30],
      joker: 11),
  JokerDraw(
      date: '2002-02-21', game: 'Joker', numbers: [4, 11, 32, 8, 36], joker: 2),
  JokerDraw(
      date: '2002-02-28',
      game: 'Joker',
      numbers: [3, 34, 14, 20, 41],
      joker: 16),
  JokerDraw(
      date: '2002-03-07',
      game: 'Joker',
      numbers: [40, 24, 12, 38, 27],
      joker: 20),
  JokerDraw(
      date: '2002-03-14',
      game: 'Joker',
      numbers: [20, 14, 15, 34, 40],
      joker: 13),
  JokerDraw(
      date: '2002-03-21',
      game: 'Joker',
      numbers: [29, 32, 22, 33, 42],
      joker: 19),
  JokerDraw(
      date: '2002-03-28',
      game: 'Joker',
      numbers: [41, 26, 17, 24, 6],
      joker: 20),
  JokerDraw(
      date: '2002-04-04',
      game: 'Joker',
      numbers: [40, 12, 26, 28, 11],
      joker: 11),
  JokerDraw(
      date: '2002-04-11',
      game: 'Joker',
      numbers: [22, 28, 1, 10, 17],
      joker: 9),
  JokerDraw(
      date: '2002-04-18', game: 'Joker', numbers: [6, 3, 7, 4, 18], joker: 15),
  JokerDraw(
      date: '2002-04-25',
      game: 'Joker',
      numbers: [40, 16, 36, 22, 44],
      joker: 10),
  JokerDraw(
      date: '2002-05-02',
      game: 'Joker',
      numbers: [36, 37, 32, 25, 24],
      joker: 18),
  JokerDraw(
      date: '2002-05-09',
      game: 'Joker',
      numbers: [9, 4, 42, 22, 44],
      joker: 11),
  JokerDraw(
      date: '2002-05-16',
      game: 'Joker',
      numbers: [23, 10, 12, 36, 25],
      joker: 11),
  JokerDraw(
      date: '2002-05-23',
      game: 'Joker',
      numbers: [4, 32, 33, 13, 23],
      joker: 3),
  JokerDraw(
      date: '2002-05-30',
      game: 'Joker',
      numbers: [40, 8, 25, 10, 18],
      joker: 5),
  JokerDraw(
      date: '2002-06-06',
      game: 'Joker',
      numbers: [29, 18, 31, 43, 36],
      joker: 12),
  JokerDraw(
      date: '2002-06-13',
      game: 'Joker',
      numbers: [4, 44, 35, 18, 24],
      joker: 7),
  JokerDraw(
      date: '2002-06-20',
      game: 'Joker',
      numbers: [23, 5, 19, 34, 36],
      joker: 12),
  JokerDraw(
      date: '2002-06-27',
      game: 'Joker',
      numbers: [8, 35, 16, 21, 18],
      joker: 14),
  JokerDraw(
      date: '2002-07-04', game: 'Joker', numbers: [7, 25, 19, 42, 4], joker: 5),
  JokerDraw(
      date: '2002-07-11',
      game: 'Joker',
      numbers: [36, 10, 20, 30, 24],
      joker: 5),
  JokerDraw(
      date: '2002-07-18',
      game: 'Joker',
      numbers: [9, 31, 34, 33, 26],
      joker: 17),
  JokerDraw(
      date: '2002-07-25',
      game: 'Joker',
      numbers: [36, 22, 37, 17, 39],
      joker: 11),
  JokerDraw(
      date: '2002-08-01',
      game: 'Joker',
      numbers: [39, 32, 3, 18, 23],
      joker: 8),
  JokerDraw(
      date: '2002-08-08', game: 'Joker', numbers: [44, 4, 24, 8, 37], joker: 1),
  JokerDraw(
      date: '2002-08-15',
      game: 'Joker',
      numbers: [37, 31, 26, 42, 27],
      joker: 18),
  JokerDraw(
      date: '2002-08-22',
      game: 'Joker',
      numbers: [30, 21, 26, 42, 40],
      joker: 20),
  JokerDraw(
      date: '2002-08-29',
      game: 'Joker',
      numbers: [10, 15, 42, 41, 24],
      joker: 10),
  JokerDraw(
      date: '2002-09-05', game: 'Joker', numbers: [19, 29, 7, 9, 20], joker: 9),
  JokerDraw(
      date: '2002-09-12',
      game: 'Joker',
      numbers: [10, 44, 37, 19, 22],
      joker: 17),
  JokerDraw(
      date: '2002-09-19',
      game: 'Joker',
      numbers: [45, 29, 28, 38, 22],
      joker: 6),
  JokerDraw(
      date: '2002-09-26', game: 'Joker', numbers: [8, 13, 7, 42, 45], joker: 2),
  JokerDraw(
      date: '2002-10-03',
      game: 'Joker',
      numbers: [35, 41, 43, 7, 28],
      joker: 6),
  JokerDraw(
      date: '2002-10-10',
      game: 'Joker',
      numbers: [45, 24, 37, 5, 34],
      joker: 18),
  JokerDraw(
      date: '2002-10-17',
      game: 'Joker',
      numbers: [37, 14, 6, 26, 22],
      joker: 8),
  JokerDraw(
      date: '2002-10-24',
      game: 'Joker',
      numbers: [34, 17, 12, 33, 25],
      joker: 11),
  JokerDraw(
      date: '2002-10-31',
      game: 'Joker',
      numbers: [27, 37, 14, 45, 23],
      joker: 8),
  JokerDraw(
      date: '2002-11-07',
      game: 'Joker',
      numbers: [17, 42, 33, 18, 39],
      joker: 13),
  JokerDraw(
      date: '2002-11-14',
      game: 'Joker',
      numbers: [16, 29, 26, 31, 30],
      joker: 8),
  JokerDraw(
      date: '2002-11-21',
      game: 'Joker',
      numbers: [30, 44, 8, 26, 24],
      joker: 15),
  JokerDraw(
      date: '2002-11-28',
      game: 'Joker',
      numbers: [27, 30, 21, 3, 19],
      joker: 2),
  JokerDraw(
      date: '2002-12-05',
      game: 'Joker',
      numbers: [32, 37, 16, 9, 18],
      joker: 19),
  JokerDraw(
      date: '2002-12-12',
      game: 'Joker',
      numbers: [29, 25, 17, 9, 43],
      joker: 15),
  JokerDraw(
      date: '2002-12-19', game: 'Joker', numbers: [29, 1, 23, 2, 19], joker: 4),
  JokerDraw(
      date: '2002-12-27',
      game: 'Joker',
      numbers: [34, 11, 10, 25, 26],
      joker: 13),
  JokerDraw(
      date: '2003-01-09',
      game: 'Joker',
      numbers: [28, 10, 31, 22, 38],
      joker: 16),
  JokerDraw(
      date: '2003-01-16',
      game: 'Joker',
      numbers: [37, 32, 43, 38, 40],
      joker: 3),
  JokerDraw(
      date: '2003-01-23', game: 'Joker', numbers: [20, 8, 2, 36, 33], joker: 4),
  JokerDraw(
      date: '2003-01-30',
      game: 'Joker',
      numbers: [16, 21, 42, 7, 4],
      joker: 15),
  JokerDraw(
      date: '2003-02-06',
      game: 'Joker',
      numbers: [13, 37, 14, 26, 43],
      joker: 18),
  JokerDraw(
      date: '2003-02-13',
      game: 'Joker',
      numbers: [42, 36, 15, 12, 38],
      joker: 14),
  JokerDraw(
      date: '2003-02-20',
      game: 'Joker',
      numbers: [30, 10, 32, 42, 25],
      joker: 2),
  JokerDraw(
      date: '2003-02-27',
      game: 'Joker',
      numbers: [43, 28, 15, 2, 41],
      joker: 11),
  JokerDraw(
      date: '2003-03-06',
      game: 'Joker',
      numbers: [16, 4, 17, 42, 9],
      joker: 17),
  JokerDraw(
      date: '2003-03-13',
      game: 'Joker',
      numbers: [20, 30, 33, 24, 43],
      joker: 1),
  JokerDraw(
      date: '2003-03-20',
      game: 'Joker',
      numbers: [37, 18, 6, 31, 34],
      joker: 10),
  JokerDraw(
      date: '2003-03-27',
      game: 'Joker',
      numbers: [45, 2, 23, 39, 14],
      joker: 10),
  JokerDraw(
      date: '2003-04-03', game: 'Joker', numbers: [8, 37, 7, 40, 20], joker: 4),
  JokerDraw(
      date: '2003-04-10',
      game: 'Joker',
      numbers: [34, 20, 11, 3, 45],
      joker: 14),
  JokerDraw(
      date: '2003-04-17',
      game: 'Joker',
      numbers: [13, 27, 7, 17, 33],
      joker: 18),
  JokerDraw(
      date: '2003-04-24', game: 'Joker', numbers: [2, 4, 10, 29, 15], joker: 6),
  JokerDraw(
      date: '2003-05-01',
      game: 'Joker',
      numbers: [18, 22, 37, 2, 35],
      joker: 19),
  JokerDraw(
      date: '2003-05-08',
      game: 'Joker',
      numbers: [13, 7, 23, 9, 37],
      joker: 17),
  JokerDraw(
      date: '2003-05-15',
      game: 'Joker',
      numbers: [19, 25, 26, 43, 6],
      joker: 16),
  JokerDraw(
      date: '2003-05-22',
      game: 'Joker',
      numbers: [45, 41, 8, 10, 9],
      joker: 16),
  JokerDraw(
      date: '2003-05-29',
      game: 'Joker',
      numbers: [43, 26, 22, 42, 6],
      joker: 3),
  JokerDraw(
      date: '2003-06-05',
      game: 'Joker',
      numbers: [21, 11, 8, 41, 7],
      joker: 10),
  JokerDraw(
      date: '2003-06-12', game: 'Joker', numbers: [17, 29, 2, 37, 3], joker: 2),
  JokerDraw(
      date: '2003-06-19',
      game: 'Joker',
      numbers: [16, 27, 42, 19, 6],
      joker: 5),
  JokerDraw(
      date: '2003-06-26',
      game: 'Joker',
      numbers: [40, 27, 41, 18, 2],
      joker: 14),
  JokerDraw(
      date: '2003-07-03',
      game: 'Joker',
      numbers: [24, 14, 20, 10, 16],
      joker: 15),
  JokerDraw(
      date: '2003-07-10', game: 'Joker', numbers: [6, 11, 1, 35, 2], joker: 6),
  JokerDraw(
      date: '2003-07-17',
      game: 'Joker',
      numbers: [33, 15, 13, 24, 19],
      joker: 9),
  JokerDraw(
      date: '2003-07-24',
      game: 'Joker',
      numbers: [32, 40, 24, 23, 29],
      joker: 20),
  JokerDraw(
      date: '2003-07-31',
      game: 'Joker',
      numbers: [33, 9, 40, 14, 37],
      joker: 6),
  JokerDraw(
      date: '2003-08-07',
      game: 'Joker',
      numbers: [11, 29, 40, 37, 27],
      joker: 18),
  JokerDraw(
      date: '2003-08-14',
      game: 'Joker',
      numbers: [13, 19, 44, 30, 43],
      joker: 10),
  JokerDraw(
      date: '2003-08-21',
      game: 'Joker',
      numbers: [23, 21, 34, 2, 13],
      joker: 6),
  JokerDraw(
      date: '2003-08-28', game: 'Joker', numbers: [37, 3, 6, 43, 4], joker: 2),
  JokerDraw(
      date: '2003-09-04',
      game: 'Joker',
      numbers: [44, 41, 33, 30, 3],
      joker: 17),
  JokerDraw(
      date: '2003-09-11', game: 'Joker', numbers: [9, 45, 41, 2, 7], joker: 20),
  JokerDraw(
      date: '2003-09-18',
      game: 'Joker',
      numbers: [11, 1, 39, 35, 34],
      joker: 7),
  JokerDraw(
      date: '2003-09-25',
      game: 'Joker',
      numbers: [45, 9, 24, 38, 15],
      joker: 18),
  JokerDraw(
      date: '2003-10-02',
      game: 'Joker',
      numbers: [25, 43, 30, 20, 33],
      joker: 19),
  JokerDraw(
      date: '2003-10-09',
      game: 'Joker',
      numbers: [35, 26, 28, 27, 5],
      joker: 18),
  JokerDraw(
      date: '2003-10-16',
      game: 'Joker',
      numbers: [32, 41, 20, 13, 18],
      joker: 13),
  JokerDraw(
      date: '2003-10-23',
      game: 'Joker',
      numbers: [21, 43, 8, 45, 32],
      joker: 9),
  JokerDraw(
      date: '2003-10-30',
      game: 'Joker',
      numbers: [5, 45, 26, 19, 24],
      joker: 2),
  JokerDraw(
      date: '2003-11-06',
      game: 'Joker',
      numbers: [23, 27, 21, 18, 14],
      joker: 16),
  JokerDraw(
      date: '2003-11-13',
      game: 'Joker',
      numbers: [15, 34, 17, 23, 16],
      joker: 9),
  JokerDraw(
      date: '2003-11-20',
      game: 'Joker',
      numbers: [17, 32, 31, 16, 44],
      joker: 16),
  JokerDraw(
      date: '2003-11-27',
      game: 'Joker',
      numbers: [14, 19, 34, 33, 18],
      joker: 16),
  JokerDraw(
      date: '2003-12-04',
      game: 'Joker',
      numbers: [43, 32, 8, 1, 40],
      joker: 20),
  JokerDraw(
      date: '2003-12-11',
      game: 'Joker',
      numbers: [9, 16, 21, 20, 37],
      joker: 15),
  JokerDraw(
      date: '2003-12-18', game: 'Joker', numbers: [4, 1, 16, 8, 3], joker: 20),
  JokerDraw(
      date: '2003-12-24',
      game: 'Joker',
      numbers: [1, 19, 42, 18, 38],
      joker: 18),
  JokerDraw(
      date: '2004-01-08',
      game: 'Joker',
      numbers: [15, 29, 31, 30, 18],
      joker: 3),
  JokerDraw(
      date: '2004-01-15',
      game: 'Joker',
      numbers: [6, 23, 27, 16, 8],
      joker: 18),
  JokerDraw(
      date: '2004-01-22',
      game: 'Joker',
      numbers: [16, 39, 17, 10, 41],
      joker: 8),
  JokerDraw(
      date: '2004-01-29',
      game: 'Joker',
      numbers: [42, 31, 18, 28, 14],
      joker: 14),
  JokerDraw(
      date: '2004-02-05',
      game: 'Joker',
      numbers: [1, 32, 37, 6, 41],
      joker: 13),
  JokerDraw(
      date: '2004-02-12',
      game: 'Joker',
      numbers: [1, 18, 26, 24, 15],
      joker: 3),
  JokerDraw(
      date: '2004-02-19',
      game: 'Joker',
      numbers: [44, 24, 39, 8, 35],
      joker: 18),
  JokerDraw(
      date: '2004-02-26',
      game: 'Joker',
      numbers: [4, 28, 10, 22, 31],
      joker: 12),
  JokerDraw(
      date: '2004-03-04',
      game: 'Joker',
      numbers: [9, 32, 4, 44, 21],
      joker: 11),
  JokerDraw(
      date: '2004-03-11', game: 'Joker', numbers: [27, 4, 9, 22, 3], joker: 17),
  JokerDraw(
      date: '2004-03-18',
      game: 'Joker',
      numbers: [8, 21, 23, 36, 40],
      joker: 13),
  JokerDraw(
      date: '2004-03-25',
      game: 'Joker',
      numbers: [16, 29, 37, 26, 43],
      joker: 16),
  JokerDraw(
      date: '2004-04-01',
      game: 'Joker',
      numbers: [44, 36, 20, 11, 22],
      joker: 19),
  JokerDraw(
      date: '2004-04-08',
      game: 'Joker',
      numbers: [34, 3, 12, 21, 7],
      joker: 16),
  JokerDraw(
      date: '2004-04-15', game: 'Joker', numbers: [9, 15, 30, 24, 3], joker: 4),
  JokerDraw(
      date: '2004-04-22',
      game: 'Joker',
      numbers: [8, 40, 32, 24, 44],
      joker: 20),
  JokerDraw(
      date: '2004-04-29',
      game: 'Joker',
      numbers: [26, 20, 9, 31, 11],
      joker: 20),
  JokerDraw(
      date: '2004-05-06',
      game: 'Joker',
      numbers: [42, 43, 25, 20, 24],
      joker: 15),
  JokerDraw(
      date: '2004-05-13',
      game: 'Joker',
      numbers: [11, 17, 16, 36, 29],
      joker: 20),
  JokerDraw(
      date: '2004-05-20',
      game: 'Joker',
      numbers: [26, 28, 20, 37, 1],
      joker: 5),
  JokerDraw(
      date: '2004-05-27',
      game: 'Joker',
      numbers: [42, 24, 23, 28, 37],
      joker: 7),
  JokerDraw(
      date: '2004-06-03',
      game: 'Joker',
      numbers: [38, 11, 15, 20, 16],
      joker: 9),
  JokerDraw(
      date: '2004-06-10', game: 'Joker', numbers: [38, 15, 1, 4, 32], joker: 7),
  JokerDraw(
      date: '2004-06-17',
      game: 'Joker',
      numbers: [31, 20, 23, 2, 45],
      joker: 12),
  JokerDraw(
      date: '2004-06-24',
      game: 'Joker',
      numbers: [16, 36, 25, 30, 42],
      joker: 16),
  JokerDraw(
      date: '2004-07-01',
      game: 'Joker',
      numbers: [27, 18, 26, 29, 36],
      joker: 6),
  JokerDraw(
      date: '2004-07-08', game: 'Joker', numbers: [30, 29, 31, 5, 3], joker: 3),
  JokerDraw(
      date: '2004-07-15',
      game: 'Joker',
      numbers: [12, 5, 25, 13, 40],
      joker: 16),
  JokerDraw(
      date: '2004-07-22',
      game: 'Joker',
      numbers: [33, 44, 12, 1, 17],
      joker: 16),
  JokerDraw(
      date: '2004-07-29',
      game: 'Joker',
      numbers: [11, 42, 25, 31, 41],
      joker: 9),
  JokerDraw(
      date: '2004-08-05',
      game: 'Joker',
      numbers: [30, 26, 41, 21, 34],
      joker: 3),
  JokerDraw(
      date: '2004-08-12',
      game: 'Joker',
      numbers: [16, 19, 15, 24, 2],
      joker: 1),
  JokerDraw(
      date: '2004-08-19',
      game: 'Joker',
      numbers: [7, 17, 36, 35, 42],
      joker: 7),
  JokerDraw(
      date: '2004-08-26',
      game: 'Joker',
      numbers: [37, 40, 41, 25, 34],
      joker: 14),
  JokerDraw(
      date: '2004-09-02', game: 'Joker', numbers: [6, 2, 21, 11, 44], joker: 6),
  JokerDraw(
      date: '2004-09-09',
      game: 'Joker',
      numbers: [34, 20, 38, 13, 26],
      joker: 8),
  JokerDraw(
      date: '2004-09-16',
      game: 'Joker',
      numbers: [17, 34, 35, 19, 41],
      joker: 4),
  JokerDraw(
      date: '2004-09-23',
      game: 'Joker',
      numbers: [21, 5, 14, 30, 29],
      joker: 17),
  JokerDraw(
      date: '2004-09-30',
      game: 'Joker',
      numbers: [42, 18, 16, 6, 24],
      joker: 1),
  JokerDraw(
      date: '2004-10-07',
      game: 'Joker',
      numbers: [35, 43, 37, 28, 10],
      joker: 7),
  JokerDraw(
      date: '2004-10-14', game: 'Joker', numbers: [9, 28, 10, 18, 8], joker: 2),
  JokerDraw(
      date: '2004-10-21',
      game: 'Joker',
      numbers: [45, 41, 43, 32, 20],
      joker: 6),
  JokerDraw(
      date: '2004-10-28',
      game: 'Joker',
      numbers: [10, 35, 43, 45, 5],
      joker: 14),
  JokerDraw(
      date: '2004-11-04', game: 'Joker', numbers: [18, 9, 31, 27, 5], joker: 3),
  JokerDraw(
      date: '2004-11-11',
      game: 'Joker',
      numbers: [14, 5, 18, 10, 43],
      joker: 8),
  JokerDraw(
      date: '2004-11-18',
      game: 'Joker',
      numbers: [9, 5, 25, 19, 11],
      joker: 13),
  JokerDraw(
      date: '2004-11-25',
      game: 'Joker',
      numbers: [40, 28, 45, 2, 9],
      joker: 18),
  JokerDraw(
      date: '2004-12-02',
      game: 'Joker',
      numbers: [23, 11, 33, 44, 27],
      joker: 11),
  JokerDraw(
      date: '2004-12-09',
      game: 'Joker',
      numbers: [16, 26, 5, 4, 39],
      joker: 15),
  JokerDraw(
      date: '2004-12-16', game: 'Joker', numbers: [41, 1, 33, 8, 9], joker: 18),
  JokerDraw(
      date: '2004-12-23', game: 'Joker', numbers: [4, 18, 24, 1, 30], joker: 6),
  JokerDraw(
      date: '2005-01-06',
      game: 'Joker',
      numbers: [41, 22, 12, 9, 21],
      joker: 5),
  JokerDraw(
      date: '2005-01-13',
      game: 'Joker',
      numbers: [15, 13, 34, 11, 44],
      joker: 7),
  JokerDraw(
      date: '2005-01-20',
      game: 'Joker',
      numbers: [5, 7, 32, 10, 25],
      joker: 12),
  JokerDraw(
      date: '2005-01-27',
      game: 'Joker',
      numbers: [43, 8, 23, 26, 30],
      joker: 15),
  JokerDraw(
      date: '2005-02-03', game: 'Joker', numbers: [20, 8, 45, 14, 7], joker: 6),
  JokerDraw(
      date: '2005-02-10',
      game: 'Joker',
      numbers: [32, 13, 33, 28, 2],
      joker: 16),
  JokerDraw(
      date: '2005-02-17',
      game: 'Joker',
      numbers: [42, 18, 4, 43, 32],
      joker: 19),
  JokerDraw(
      date: '2005-02-24',
      game: 'Joker',
      numbers: [3, 36, 35, 16, 27],
      joker: 9),
  JokerDraw(
      date: '2005-03-03',
      game: 'Joker',
      numbers: [4, 30, 13, 39, 36],
      joker: 8),
  JokerDraw(
      date: '2005-03-10',
      game: 'Joker',
      numbers: [32, 22, 43, 5, 20],
      joker: 6),
  JokerDraw(
      date: '2005-03-17', game: 'Joker', numbers: [7, 25, 2, 22, 42], joker: 2),
  JokerDraw(
      date: '2005-03-24',
      game: 'Joker',
      numbers: [36, 21, 5, 20, 13],
      joker: 18),
  JokerDraw(
      date: '2005-03-31',
      game: 'Joker',
      numbers: [12, 2, 13, 29, 19],
      joker: 3),
  JokerDraw(
      date: '2005-04-07',
      game: 'Joker',
      numbers: [32, 35, 2, 19, 33],
      joker: 2),
  JokerDraw(
      date: '2005-04-14',
      game: 'Joker',
      numbers: [19, 14, 36, 13, 9],
      joker: 8),
  JokerDraw(
      date: '2005-04-21',
      game: 'Joker',
      numbers: [35, 19, 28, 24, 26],
      joker: 11),
  JokerDraw(
      date: '2005-04-28',
      game: 'Joker',
      numbers: [26, 6, 32, 41, 45],
      joker: 7),
  JokerDraw(
      date: '2005-05-05', game: 'Joker', numbers: [44, 19, 5, 8, 6], joker: 19),
  JokerDraw(
      date: '2005-05-12',
      game: 'Joker',
      numbers: [40, 38, 43, 32, 36],
      joker: 7),
  JokerDraw(
      date: '2005-05-19',
      game: 'Joker',
      numbers: [23, 10, 29, 22, 17],
      joker: 19),
  JokerDraw(
      date: '2005-05-26',
      game: 'Joker',
      numbers: [40, 45, 31, 43, 27],
      joker: 17),
  JokerDraw(
      date: '2005-06-02',
      game: 'Joker',
      numbers: [12, 2, 40, 18, 27],
      joker: 18),
  JokerDraw(
      date: '2005-06-09',
      game: 'Joker',
      numbers: [16, 19, 37, 36, 10],
      joker: 4),
  JokerDraw(
      date: '2005-06-16', game: 'Joker', numbers: [1, 37, 4, 36, 18], joker: 9),
  JokerDraw(
      date: '2005-06-23', game: 'Joker', numbers: [9, 41, 8, 37, 21], joker: 3),
  JokerDraw(
      date: '2005-06-30',
      game: 'Joker',
      numbers: [13, 24, 10, 37, 42],
      joker: 15),
  JokerDraw(
      date: '2005-07-07',
      game: 'Joker',
      numbers: [29, 14, 21, 36, 16],
      joker: 14),
  JokerDraw(
      date: '2005-07-14', game: 'Joker', numbers: [12, 3, 27, 9, 14], joker: 3),
  JokerDraw(
      date: '2005-07-21', game: 'Joker', numbers: [45, 1, 2, 32, 12], joker: 2),
  JokerDraw(
      date: '2005-07-28',
      game: 'Joker',
      numbers: [38, 20, 22, 12, 37],
      joker: 1),
  JokerDraw(
      date: '2005-08-04',
      game: 'Joker',
      numbers: [18, 10, 44, 15, 14],
      joker: 1),
  JokerDraw(
      date: '2005-08-11',
      game: 'Joker',
      numbers: [3, 19, 15, 24, 45],
      joker: 7),
  JokerDraw(
      date: '2005-08-18',
      game: 'Joker',
      numbers: [32, 13, 28, 6, 27],
      joker: 17),
  JokerDraw(
      date: '2005-08-25',
      game: 'Joker',
      numbers: [12, 43, 27, 1, 31],
      joker: 2),
  JokerDraw(
      date: '2005-09-01',
      game: 'Joker',
      numbers: [18, 44, 42, 4, 26],
      joker: 10),
  JokerDraw(
      date: '2005-09-08',
      game: 'Joker',
      numbers: [19, 35, 34, 11, 17],
      joker: 5),
  JokerDraw(
      date: '2005-09-15',
      game: 'Joker',
      numbers: [15, 32, 30, 2, 33],
      joker: 16),
  JokerDraw(
      date: '2005-09-22', game: 'Joker', numbers: [1, 27, 30, 9, 26], joker: 5),
  JokerDraw(
      date: '2005-09-29',
      game: 'Joker',
      numbers: [12, 20, 29, 17, 43],
      joker: 11),
  JokerDraw(
      date: '2005-10-06',
      game: 'Joker',
      numbers: [23, 25, 20, 24, 32],
      joker: 2),
  JokerDraw(
      date: '2005-10-13',
      game: 'Joker',
      numbers: [20, 14, 31, 37, 45],
      joker: 8),
  JokerDraw(
      date: '2005-10-20',
      game: 'Joker',
      numbers: [27, 36, 30, 26, 39],
      joker: 17),
  JokerDraw(
      date: '2005-10-27',
      game: 'Joker',
      numbers: [30, 16, 45, 43, 32],
      joker: 3),
  JokerDraw(
      date: '2005-11-03', game: 'Joker', numbers: [18, 24, 5, 4, 31], joker: 6),
  JokerDraw(
      date: '2005-11-10',
      game: 'Joker',
      numbers: [43, 33, 28, 10, 35],
      joker: 7),
  JokerDraw(
      date: '2005-11-17',
      game: 'Joker',
      numbers: [8, 11, 22, 1, 44],
      joker: 11),
  JokerDraw(
      date: '2005-11-24',
      game: 'Joker',
      numbers: [44, 39, 34, 40, 37],
      joker: 12),
  JokerDraw(
      date: '2005-12-01', game: 'Joker', numbers: [36, 4, 3, 26, 1], joker: 18),
  JokerDraw(
      date: '2005-12-08',
      game: 'Joker',
      numbers: [41, 44, 22, 6, 31],
      joker: 13),
  JokerDraw(
      date: '2005-12-15',
      game: 'Joker',
      numbers: [23, 14, 38, 17, 15],
      joker: 12),
  JokerDraw(
      date: '2005-12-22',
      game: 'Joker',
      numbers: [37, 39, 3, 30, 38],
      joker: 9),
  JokerDraw(
      date: '2005-12-29',
      game: 'Joker',
      numbers: [33, 41, 35, 22, 19],
      joker: 13),
  JokerDraw(
      date: '2006-01-05', game: 'Joker', numbers: [3, 19, 5, 41, 32], joker: 3),
  JokerDraw(
      date: '2006-01-12',
      game: 'Joker',
      numbers: [40, 39, 18, 29, 14],
      joker: 19),
  JokerDraw(
      date: '2006-01-19',
      game: 'Joker',
      numbers: [45, 30, 26, 41, 11],
      joker: 6),
  JokerDraw(
      date: '2006-01-26',
      game: 'Joker',
      numbers: [36, 40, 3, 27, 15],
      joker: 20),
  JokerDraw(
      date: '2006-02-02',
      game: 'Joker',
      numbers: [27, 26, 8, 43, 37],
      joker: 4),
  JokerDraw(
      date: '2006-02-09',
      game: 'Joker',
      numbers: [17, 43, 32, 10, 31],
      joker: 16),
  JokerDraw(
      date: '2006-02-16',
      game: 'Joker',
      numbers: [13, 23, 44, 21, 14],
      joker: 2),
  JokerDraw(
      date: '2006-02-23',
      game: 'Joker',
      numbers: [2, 44, 5, 27, 29],
      joker: 20),
  JokerDraw(
      date: '2006-03-02',
      game: 'Joker',
      numbers: [19, 37, 9, 29, 13],
      joker: 1),
  JokerDraw(
      date: '2006-03-09',
      game: 'Joker',
      numbers: [26, 35, 21, 10, 3],
      joker: 17),
  JokerDraw(
      date: '2006-03-16',
      game: 'Joker',
      numbers: [17, 30, 33, 25, 9],
      joker: 1),
  JokerDraw(
      date: '2006-03-23',
      game: 'Joker',
      numbers: [44, 31, 32, 13, 19],
      joker: 6),
  JokerDraw(
      date: '2006-03-30',
      game: 'Joker',
      numbers: [33, 41, 4, 1, 15],
      joker: 10),
  JokerDraw(
      date: '2006-04-06',
      game: 'Joker',
      numbers: [21, 19, 22, 32, 3],
      joker: 1),
  JokerDraw(
      date: '2006-04-13', game: 'Joker', numbers: [6, 9, 25, 37, 22], joker: 2),
  JokerDraw(
      date: '2006-04-20',
      game: 'Joker',
      numbers: [37, 31, 28, 3, 15],
      joker: 3),
  JokerDraw(
      date: '2006-04-27',
      game: 'Joker',
      numbers: [34, 30, 1, 19, 35],
      joker: 2),
  JokerDraw(
      date: '2006-05-04', game: 'Joker', numbers: [9, 38, 23, 1, 2], joker: 2),
  JokerDraw(
      date: '2006-05-11', game: 'Joker', numbers: [2, 9, 7, 30, 15], joker: 10),
  JokerDraw(
      date: '2006-05-18',
      game: 'Joker',
      numbers: [21, 29, 39, 45, 7],
      joker: 20),
  JokerDraw(
      date: '2006-05-25',
      game: 'Joker',
      numbers: [28, 41, 15, 27, 44],
      joker: 8),
  JokerDraw(
      date: '2006-06-01',
      game: 'Joker',
      numbers: [28, 35, 23, 37, 27],
      joker: 3),
  JokerDraw(
      date: '2006-06-08',
      game: 'Joker',
      numbers: [12, 20, 13, 33, 38],
      joker: 11),
  JokerDraw(
      date: '2006-06-15',
      game: 'Joker',
      numbers: [24, 29, 38, 12, 3],
      joker: 9),
  JokerDraw(
      date: '2006-06-22', game: 'Joker', numbers: [2, 27, 5, 1, 19], joker: 11),
  JokerDraw(
      date: '2006-06-29', game: 'Joker', numbers: [42, 6, 28, 3, 45], joker: 9),
  JokerDraw(
      date: '2006-07-06',
      game: 'Joker',
      numbers: [13, 27, 14, 31, 35],
      joker: 12),
  JokerDraw(
      date: '2006-07-13',
      game: 'Joker',
      numbers: [23, 11, 37, 17, 2],
      joker: 12),
  JokerDraw(
      date: '2006-07-20',
      game: 'Joker',
      numbers: [37, 40, 26, 44, 13],
      joker: 11),
  JokerDraw(
      date: '2006-07-27',
      game: 'Joker',
      numbers: [19, 34, 29, 32, 30],
      joker: 12),
  JokerDraw(
      date: '2006-08-03',
      game: 'Joker',
      numbers: [23, 30, 40, 16, 5],
      joker: 13),
  JokerDraw(
      date: '2006-08-10',
      game: 'Joker',
      numbers: [32, 27, 4, 5, 39],
      joker: 10),
  JokerDraw(
      date: '2006-08-17',
      game: 'Joker',
      numbers: [14, 35, 10, 22, 17],
      joker: 6),
  JokerDraw(
      date: '2006-08-24', game: 'Joker', numbers: [40, 7, 36, 2, 27], joker: 3),
  JokerDraw(
      date: '2006-08-31',
      game: 'Joker',
      numbers: [41, 31, 18, 19, 8],
      joker: 16),
  JokerDraw(
      date: '2006-09-07',
      game: 'Joker',
      numbers: [9, 44, 26, 2, 12],
      joker: 10),
  JokerDraw(
      date: '2006-09-14', game: 'Joker', numbers: [40, 27, 7, 2, 6], joker: 8),
  JokerDraw(
      date: '2006-09-21',
      game: 'Joker',
      numbers: [44, 41, 25, 13, 35],
      joker: 1),
  JokerDraw(
      date: '2006-09-28',
      game: 'Joker',
      numbers: [29, 34, 22, 28, 41],
      joker: 9),
  JokerDraw(
      date: '2006-10-05', game: 'Joker', numbers: [41, 7, 8, 3, 43], joker: 20),
  JokerDraw(
      date: '2006-10-12', game: 'Joker', numbers: [43, 16, 7, 39, 4], joker: 5),
  JokerDraw(
      date: '2006-10-19',
      game: 'Joker',
      numbers: [19, 17, 33, 15, 16],
      joker: 5),
  JokerDraw(
      date: '2006-10-26',
      game: 'Joker',
      numbers: [35, 18, 12, 10, 21],
      joker: 1),
  JokerDraw(
      date: '2006-11-02',
      game: 'Joker',
      numbers: [10, 1, 29, 27, 45],
      joker: 3),
  JokerDraw(
      date: '2006-11-09',
      game: 'Joker',
      numbers: [33, 30, 7, 31, 28],
      joker: 10),
  JokerDraw(
      date: '2006-11-16',
      game: 'Joker',
      numbers: [8, 1, 31, 17, 27],
      joker: 16),
  JokerDraw(
      date: '2006-11-23',
      game: 'Joker',
      numbers: [39, 36, 37, 8, 42],
      joker: 20),
  JokerDraw(
      date: '2006-11-30',
      game: 'Joker',
      numbers: [42, 39, 25, 10, 28],
      joker: 10),
  JokerDraw(
      date: '2006-12-07',
      game: 'Joker',
      numbers: [23, 34, 20, 21, 29],
      joker: 10),
  JokerDraw(
      date: '2006-12-14',
      game: 'Joker',
      numbers: [2, 3, 38, 29, 44],
      joker: 18),
  JokerDraw(
      date: '2006-12-21',
      game: 'Joker',
      numbers: [8, 11, 37, 40, 42],
      joker: 13),
  JokerDraw(
      date: '2006-12-28',
      game: 'Joker',
      numbers: [40, 36, 16, 5, 29],
      joker: 19),
  JokerDraw(
      date: '2007-01-04',
      game: 'Joker',
      numbers: [3, 43, 41, 2, 39],
      joker: 13),
  JokerDraw(
      date: '2007-01-11',
      game: 'Joker',
      numbers: [45, 31, 19, 4, 25],
      joker: 7),
  JokerDraw(
      date: '2007-01-18',
      game: 'Joker',
      numbers: [31, 42, 7, 39, 23],
      joker: 4),
  JokerDraw(
      date: '2007-01-25',
      game: 'Joker',
      numbers: [18, 21, 36, 44, 40],
      joker: 1),
  JokerDraw(
      date: '2007-02-01',
      game: 'Joker',
      numbers: [13, 11, 36, 31, 6],
      joker: 9),
  JokerDraw(
      date: '2007-02-08',
      game: 'Joker',
      numbers: [37, 33, 42, 21, 31],
      joker: 14),
  JokerDraw(
      date: '2007-02-15',
      game: 'Joker',
      numbers: [3, 32, 19, 12, 24],
      joker: 19),
  JokerDraw(
      date: '2007-02-22',
      game: 'Joker',
      numbers: [40, 6, 41, 43, 2],
      joker: 19),
  JokerDraw(
      date: '2007-03-01',
      game: 'Joker',
      numbers: [28, 16, 7, 33, 2],
      joker: 20),
  JokerDraw(
      date: '2007-03-08',
      game: 'Joker',
      numbers: [29, 8, 18, 44, 11],
      joker: 8),
  JokerDraw(
      date: '2007-03-15',
      game: 'Joker',
      numbers: [24, 9, 12, 22, 34],
      joker: 6),
  JokerDraw(
      date: '2007-03-22',
      game: 'Joker',
      numbers: [31, 10, 4, 41, 34],
      joker: 17),
  JokerDraw(
      date: '2007-03-29',
      game: 'Joker',
      numbers: [31, 4, 28, 14, 34],
      joker: 20),
  JokerDraw(
      date: '2007-04-05', game: 'Joker', numbers: [7, 5, 20, 6, 24], joker: 7),
  JokerDraw(
      date: '2007-04-12',
      game: 'Joker',
      numbers: [37, 13, 31, 38, 32],
      joker: 9),
  JokerDraw(
      date: '2007-04-19',
      game: 'Joker',
      numbers: [24, 45, 22, 8, 41],
      joker: 6),
  JokerDraw(
      date: '2007-04-26',
      game: 'Joker',
      numbers: [4, 14, 35, 17, 12],
      joker: 11),
  JokerDraw(
      date: '2007-05-03',
      game: 'Joker',
      numbers: [27, 19, 7, 17, 22],
      joker: 15),
  JokerDraw(
      date: '2007-05-10',
      game: 'Joker',
      numbers: [8, 44, 18, 10, 22],
      joker: 1),
  JokerDraw(
      date: '2007-05-17',
      game: 'Joker',
      numbers: [41, 9, 20, 29, 5],
      joker: 14),
  JokerDraw(
      date: '2007-05-24',
      game: 'Joker',
      numbers: [35, 11, 27, 40, 45],
      joker: 18),
  JokerDraw(
      date: '2007-05-31',
      game: 'Joker',
      numbers: [24, 2, 43, 10, 19],
      joker: 14),
  JokerDraw(
      date: '2007-06-07',
      game: 'Joker',
      numbers: [18, 42, 2, 5, 10],
      joker: 17),
  JokerDraw(
      date: '2007-06-14',
      game: 'Joker',
      numbers: [25, 7, 28, 41, 19],
      joker: 14),
  JokerDraw(
      date: '2007-06-21', game: 'Joker', numbers: [29, 2, 19, 6, 42], joker: 8),
  JokerDraw(
      date: '2007-06-28',
      game: 'Joker',
      numbers: [21, 40, 18, 12, 5],
      joker: 8),
  JokerDraw(
      date: '2007-07-05',
      game: 'Joker',
      numbers: [10, 17, 14, 20, 28],
      joker: 18),
  JokerDraw(
      date: '2007-07-12',
      game: 'Joker',
      numbers: [35, 13, 5, 39, 36],
      joker: 10),
  JokerDraw(
      date: '2007-07-19',
      game: 'Joker',
      numbers: [8, 23, 42, 22, 37],
      joker: 3),
  JokerDraw(
      date: '2007-07-26',
      game: 'Joker',
      numbers: [17, 5, 25, 1, 22],
      joker: 17),
  JokerDraw(
      date: '2007-08-02', game: 'Joker', numbers: [36, 12, 3, 28, 5], joker: 8),
  JokerDraw(
      date: '2007-08-09',
      game: 'Joker',
      numbers: [35, 1, 32, 19, 23],
      joker: 12),
  JokerDraw(
      date: '2007-08-16',
      game: 'Joker',
      numbers: [44, 31, 34, 45, 37],
      joker: 7),
  JokerDraw(
      date: '2007-08-23',
      game: 'Joker',
      numbers: [20, 42, 41, 44, 3],
      joker: 10),
  JokerDraw(
      date: '2007-08-30',
      game: 'Joker',
      numbers: [13, 44, 34, 22, 20],
      joker: 20),
  JokerDraw(
      date: '2007-09-06',
      game: 'Joker',
      numbers: [29, 33, 6, 38, 43],
      joker: 15),
  JokerDraw(
      date: '2007-09-13',
      game: 'Joker',
      numbers: [29, 25, 40, 5, 26],
      joker: 3),
  JokerDraw(
      date: '2007-09-20',
      game: 'Joker',
      numbers: [11, 45, 31, 3, 32],
      joker: 3),
  JokerDraw(
      date: '2007-09-27',
      game: 'Joker',
      numbers: [3, 20, 19, 13, 39],
      joker: 17),
  JokerDraw(
      date: '2007-10-04',
      game: 'Joker',
      numbers: [1, 12, 2, 45, 11],
      joker: 17),
  JokerDraw(
      date: '2007-10-11',
      game: 'Joker',
      numbers: [17, 11, 44, 25, 13],
      joker: 3),
  JokerDraw(
      date: '2007-10-18', game: 'Joker', numbers: [18, 41, 8, 29, 6], joker: 7),
  JokerDraw(
      date: '2007-10-25',
      game: 'Joker',
      numbers: [23, 12, 40, 35, 38],
      joker: 11),
  JokerDraw(
      date: '2007-11-01',
      game: 'Joker',
      numbers: [1, 19, 41, 20, 17],
      joker: 10),
  JokerDraw(
      date: '2007-11-08',
      game: 'Joker',
      numbers: [30, 41, 6, 10, 8],
      joker: 12),
  JokerDraw(
      date: '2007-11-15',
      game: 'Joker',
      numbers: [34, 40, 5, 39, 33],
      joker: 3),
  JokerDraw(
      date: '2007-11-22',
      game: 'Joker',
      numbers: [25, 26, 40, 21, 11],
      joker: 14),
  JokerDraw(
      date: '2007-11-29',
      game: 'Joker',
      numbers: [25, 23, 36, 39, 16],
      joker: 18),
  JokerDraw(
      date: '2007-12-06',
      game: 'Joker',
      numbers: [33, 6, 38, 34, 19],
      joker: 3),
  JokerDraw(
      date: '2007-12-13',
      game: 'Joker',
      numbers: [30, 21, 27, 20, 39],
      joker: 6),
  JokerDraw(
      date: '2007-12-20',
      game: 'Joker',
      numbers: [35, 15, 16, 29, 43],
      joker: 15),
  JokerDraw(
      date: '2008-01-03',
      game: 'Joker',
      numbers: [23, 17, 3, 7, 19],
      joker: 14),
  JokerDraw(
      date: '2008-01-10',
      game: 'Joker',
      numbers: [33, 1, 32, 30, 16],
      joker: 19),
  JokerDraw(
      date: '2008-01-17',
      game: 'Joker',
      numbers: [35, 24, 40, 13, 14],
      joker: 5),
  JokerDraw(
      date: '2008-01-24',
      game: 'Joker',
      numbers: [21, 15, 40, 5, 44],
      joker: 12),
  JokerDraw(
      date: '2008-01-31',
      game: 'Joker',
      numbers: [2, 12, 40, 41, 28],
      joker: 6),
  JokerDraw(
      date: '2008-02-07',
      game: 'Joker',
      numbers: [7, 30, 23, 22, 42],
      joker: 14),
  JokerDraw(
      date: '2008-02-14',
      game: 'Joker',
      numbers: [44, 39, 6, 1, 22],
      joker: 19),
  JokerDraw(
      date: '2008-02-21',
      game: 'Joker',
      numbers: [27, 22, 41, 32, 2],
      joker: 10),
  JokerDraw(
      date: '2008-02-28',
      game: 'Joker',
      numbers: [13, 31, 43, 27, 2],
      joker: 19),
  JokerDraw(
      date: '2008-03-06',
      game: 'Joker',
      numbers: [16, 7, 29, 12, 22],
      joker: 11),
  JokerDraw(
      date: '2008-03-13',
      game: 'Joker',
      numbers: [18, 10, 6, 1, 34],
      joker: 20),
  JokerDraw(
      date: '2008-03-20',
      game: 'Joker',
      numbers: [43, 14, 22, 17, 15],
      joker: 12),
  JokerDraw(
      date: '2008-03-27',
      game: 'Joker',
      numbers: [38, 19, 30, 6, 1],
      joker: 14),
  JokerDraw(
      date: '2008-04-03',
      game: 'Joker',
      numbers: [13, 28, 2, 20, 24],
      joker: 7),
  JokerDraw(
      date: '2008-04-10',
      game: 'Joker',
      numbers: [42, 3, 4, 36, 31],
      joker: 10),
  JokerDraw(
      date: '2008-04-17',
      game: 'Joker',
      numbers: [23, 26, 32, 10, 9],
      joker: 5),
  JokerDraw(
      date: '2008-04-24',
      game: 'Joker',
      numbers: [17, 19, 18, 13, 4],
      joker: 7),
  JokerDraw(
      date: '2008-05-01',
      game: 'Joker',
      numbers: [3, 39, 18, 8, 26],
      joker: 11),
  JokerDraw(
      date: '2008-05-08',
      game: 'Joker',
      numbers: [30, 15, 9, 21, 37],
      joker: 10),
  JokerDraw(
      date: '2008-05-15',
      game: 'Joker',
      numbers: [22, 25, 11, 23, 16],
      joker: 15),
  JokerDraw(
      date: '2008-05-22',
      game: 'Joker',
      numbers: [42, 12, 29, 34, 11],
      joker: 13),
  JokerDraw(
      date: '2008-05-29',
      game: 'Joker',
      numbers: [3, 38, 35, 23, 10],
      joker: 19),
  JokerDraw(
      date: '2008-06-05',
      game: 'Joker',
      numbers: [41, 37, 26, 29, 2],
      joker: 20),
  JokerDraw(
      date: '2008-06-12',
      game: 'Joker',
      numbers: [14, 39, 27, 44, 2],
      joker: 15),
  JokerDraw(
      date: '2008-06-19',
      game: 'Joker',
      numbers: [15, 25, 2, 18, 43],
      joker: 6),
  JokerDraw(
      date: '2008-06-26',
      game: 'Joker',
      numbers: [5, 12, 27, 11, 19],
      joker: 9),
  JokerDraw(
      date: '2008-07-03',
      game: 'Joker',
      numbers: [38, 10, 18, 17, 40],
      joker: 6),
  JokerDraw(
      date: '2008-07-10',
      game: 'Joker',
      numbers: [6, 38, 17, 13, 37],
      joker: 5),
  JokerDraw(
      date: '2008-07-17',
      game: 'Joker',
      numbers: [5, 17, 26, 22, 33],
      joker: 1),
  JokerDraw(
      date: '2008-07-24', game: 'Joker', numbers: [37, 28, 11, 1, 6], joker: 9),
  JokerDraw(
      date: '2008-07-31',
      game: 'Joker',
      numbers: [20, 40, 14, 8, 35],
      joker: 5),
  JokerDraw(
      date: '2008-08-07',
      game: 'Joker',
      numbers: [13, 34, 43, 11, 24],
      joker: 5),
  JokerDraw(
      date: '2008-08-14',
      game: 'Joker',
      numbers: [24, 15, 35, 45, 21],
      joker: 17),
  JokerDraw(
      date: '2008-08-21',
      game: 'Joker',
      numbers: [31, 27, 37, 9, 7],
      joker: 16),
  JokerDraw(
      date: '2008-08-28',
      game: 'Joker',
      numbers: [41, 14, 43, 34, 17],
      joker: 15),
  JokerDraw(
      date: '2008-09-04',
      game: 'Joker',
      numbers: [7, 15, 40, 19, 29],
      joker: 1),
  JokerDraw(
      date: '2008-09-11',
      game: 'Joker',
      numbers: [45, 1, 41, 6, 15],
      joker: 16),
  JokerDraw(
      date: '2008-09-18', game: 'Joker', numbers: [7, 34, 15, 17, 5], joker: 3),
  JokerDraw(
      date: '2008-09-25',
      game: 'Joker',
      numbers: [23, 19, 16, 32, 3],
      joker: 9),
  JokerDraw(
      date: '2008-10-02',
      game: 'Joker',
      numbers: [17, 5, 8, 25, 26],
      joker: 13),
  JokerDraw(
      date: '2008-10-09',
      game: 'Joker',
      numbers: [22, 40, 29, 16, 9],
      joker: 6),
  JokerDraw(
      date: '2008-10-16',
      game: 'Joker',
      numbers: [17, 28, 44, 25, 40],
      joker: 8),
  JokerDraw(
      date: '2008-10-23',
      game: 'Joker',
      numbers: [8, 36, 7, 31, 38],
      joker: 19),
  JokerDraw(
      date: '2008-10-30',
      game: 'Joker',
      numbers: [35, 28, 39, 45, 2],
      joker: 1),
  JokerDraw(
      date: '2008-11-06',
      game: 'Joker',
      numbers: [30, 33, 18, 35, 20],
      joker: 7),
  JokerDraw(
      date: '2008-11-13',
      game: 'Joker',
      numbers: [41, 15, 25, 36, 10],
      joker: 3),
  JokerDraw(
      date: '2008-11-20',
      game: 'Joker',
      numbers: [18, 45, 23, 27, 39],
      joker: 20),
  JokerDraw(
      date: '2008-11-27',
      game: 'Joker',
      numbers: [20, 27, 18, 19, 39],
      joker: 17),
  JokerDraw(
      date: '2008-12-04',
      game: 'Joker',
      numbers: [41, 16, 12, 18, 3],
      joker: 3),
  JokerDraw(
      date: '2008-12-11',
      game: 'Joker',
      numbers: [29, 35, 40, 21, 42],
      joker: 3),
  JokerDraw(
      date: '2008-12-18',
      game: 'Joker',
      numbers: [19, 17, 30, 22, 28],
      joker: 12),
  JokerDraw(
      date: '2008-12-24',
      game: 'Joker',
      numbers: [35, 33, 45, 41, 38],
      joker: 4),
  JokerDraw(
      date: '2009-01-08',
      game: 'Joker',
      numbers: [44, 30, 14, 13, 25],
      joker: 10),
  JokerDraw(
      date: '2009-01-15',
      game: 'Joker',
      numbers: [3, 7, 27, 28, 23],
      joker: 17),
  JokerDraw(
      date: '2009-01-22', game: 'Joker', numbers: [10, 33, 1, 7, 17], joker: 2),
  JokerDraw(
      date: '2009-01-29',
      game: 'Joker',
      numbers: [12, 15, 44, 13, 29],
      joker: 5),
  JokerDraw(
      date: '2009-02-05',
      game: 'Joker',
      numbers: [11, 10, 39, 8, 38],
      joker: 4),
  JokerDraw(
      date: '2009-02-12',
      game: 'Joker',
      numbers: [20, 33, 41, 31, 40],
      joker: 13),
  JokerDraw(
      date: '2009-02-19',
      game: 'Joker',
      numbers: [16, 11, 7, 32, 18],
      joker: 5),
  JokerDraw(
      date: '2009-02-26', game: 'Joker', numbers: [3, 2, 5, 38, 29], joker: 3),
  JokerDraw(
      date: '2009-03-05',
      game: 'Joker',
      numbers: [45, 24, 43, 40, 33],
      joker: 12),
  JokerDraw(
      date: '2009-03-12',
      game: 'Joker',
      numbers: [39, 34, 16, 22, 15],
      joker: 10),
  JokerDraw(
      date: '2009-03-19',
      game: 'Joker',
      numbers: [9, 5, 15, 43, 25],
      joker: 10),
  JokerDraw(
      date: '2009-03-26',
      game: 'Joker',
      numbers: [35, 3, 40, 43, 2],
      joker: 17),
  JokerDraw(
      date: '2009-04-02',
      game: 'Joker',
      numbers: [23, 38, 15, 2, 4],
      joker: 16),
  JokerDraw(
      date: '2009-04-09',
      game: 'Joker',
      numbers: [42, 45, 27, 4, 36],
      joker: 11),
  JokerDraw(
      date: '2009-04-16',
      game: 'Joker',
      numbers: [7, 19, 30, 37, 6],
      joker: 20),
  JokerDraw(
      date: '2009-04-23',
      game: 'Joker',
      numbers: [22, 37, 25, 14, 30],
      joker: 17),
  JokerDraw(
      date: '2009-04-30',
      game: 'Joker',
      numbers: [27, 22, 45, 24, 9],
      joker: 20),
  JokerDraw(
      date: '2009-05-07',
      game: 'Joker',
      numbers: [11, 43, 40, 33, 6],
      joker: 9),
  JokerDraw(
      date: '2009-05-14',
      game: 'Joker',
      numbers: [36, 22, 39, 7, 3],
      joker: 10),
  JokerDraw(
      date: '2009-05-21',
      game: 'Joker',
      numbers: [42, 14, 3, 20, 27],
      joker: 1),
  JokerDraw(
      date: '2009-05-28',
      game: 'Joker',
      numbers: [26, 12, 17, 1, 24],
      joker: 5),
  JokerDraw(
      date: '2009-06-04',
      game: 'Joker',
      numbers: [5, 2, 35, 27, 22],
      joker: 14),
  JokerDraw(
      date: '2009-06-11',
      game: 'Joker',
      numbers: [37, 30, 4, 6, 27],
      joker: 15),
  JokerDraw(
      date: '2009-06-18', game: 'Joker', numbers: [45, 8, 12, 25, 5], joker: 5),
  JokerDraw(
      date: '2009-06-25',
      game: 'Joker',
      numbers: [9, 32, 33, 37, 21],
      joker: 19),
  JokerDraw(
      date: '2009-07-02', game: 'Joker', numbers: [5, 3, 6, 30, 44], joker: 19),
  JokerDraw(
      date: '2009-07-09',
      game: 'Joker',
      numbers: [21, 39, 13, 24, 5],
      joker: 18),
  JokerDraw(
      date: '2009-07-16',
      game: 'Joker',
      numbers: [16, 7, 30, 17, 42],
      joker: 19),
  JokerDraw(
      date: '2009-07-23',
      game: 'Joker',
      numbers: [16, 45, 4, 38, 44],
      joker: 13),
  JokerDraw(
      date: '2009-07-30', game: 'Joker', numbers: [1, 5, 13, 4, 11], joker: 16),
  JokerDraw(
      date: '2009-08-06', game: 'Joker', numbers: [7, 11, 6, 2, 25], joker: 5),
  JokerDraw(
      date: '2009-08-13',
      game: 'Joker',
      numbers: [6, 9, 34, 36, 22],
      joker: 14),
  JokerDraw(
      date: '2009-08-20',
      game: 'Joker',
      numbers: [29, 27, 36, 42, 8],
      joker: 7),
  JokerDraw(
      date: '2009-08-27',
      game: 'Joker',
      numbers: [13, 1, 6, 40, 25],
      joker: 17),
  JokerDraw(
      date: '2009-09-03', game: 'Joker', numbers: [35, 38, 4, 9, 8], joker: 10),
  JokerDraw(
      date: '2009-09-10',
      game: 'Joker',
      numbers: [4, 21, 6, 29, 33],
      joker: 10),
  JokerDraw(
      date: '2009-09-17',
      game: 'Joker',
      numbers: [42, 17, 44, 10, 24],
      joker: 15),
  JokerDraw(
      date: '2009-09-24',
      game: 'Joker',
      numbers: [34, 33, 29, 11, 44],
      joker: 13),
  JokerDraw(
      date: '2009-10-01',
      game: 'Joker',
      numbers: [40, 30, 14, 26, 15],
      joker: 17),
  JokerDraw(
      date: '2009-10-08',
      game: 'Joker',
      numbers: [19, 20, 45, 39, 32],
      joker: 20),
  JokerDraw(
      date: '2009-10-15',
      game: 'Joker',
      numbers: [26, 18, 19, 29, 1],
      joker: 16),
  JokerDraw(
      date: '2009-10-22', game: 'Joker', numbers: [3, 9, 45, 41, 35], joker: 7),
  JokerDraw(
      date: '2009-10-29', game: 'Joker', numbers: [3, 6, 8, 15, 32], joker: 15),
  JokerDraw(
      date: '2009-11-05',
      game: 'Joker',
      numbers: [26, 14, 25, 3, 43],
      joker: 10),
  JokerDraw(
      date: '2009-11-12',
      game: 'Joker',
      numbers: [14, 15, 10, 28, 23],
      joker: 12),
  JokerDraw(
      date: '2009-11-19',
      game: 'Joker',
      numbers: [33, 13, 10, 16, 45],
      joker: 4),
  JokerDraw(
      date: '2009-11-26',
      game: 'Joker',
      numbers: [11, 23, 36, 15, 14],
      joker: 18),
  JokerDraw(
      date: '2009-12-03',
      game: 'Joker',
      numbers: [40, 20, 29, 24, 14],
      joker: 13),
  JokerDraw(
      date: '2009-12-10',
      game: 'Joker',
      numbers: [15, 30, 16, 43, 18],
      joker: 5),
  JokerDraw(
      date: '2009-12-17',
      game: 'Joker',
      numbers: [6, 32, 15, 37, 13],
      joker: 9),
  JokerDraw(
      date: '2009-12-24',
      game: 'Joker',
      numbers: [10, 44, 8, 29, 22],
      joker: 4),
  JokerDraw(
      date: '2009-12-31',
      game: 'Joker',
      numbers: [5, 33, 10, 45, 26],
      joker: 14),
  JokerDraw(
      date: '2010-01-07',
      game: 'Joker',
      numbers: [24, 20, 45, 6, 16],
      joker: 7),
  JokerDraw(
      date: '2010-01-14',
      game: 'Joker',
      numbers: [10, 8, 25, 23, 20],
      joker: 17),
  JokerDraw(
      date: '2010-01-21', game: 'Joker', numbers: [8, 12, 18, 2, 34], joker: 2),
  JokerDraw(
      date: '2010-01-28',
      game: 'Joker',
      numbers: [8, 40, 30, 44, 21],
      joker: 10),
  JokerDraw(
      date: '2010-02-04', game: 'Joker', numbers: [31, 1, 35, 3, 14], joker: 1),
  JokerDraw(
      date: '2010-02-11',
      game: 'Joker',
      numbers: [22, 13, 43, 28, 6],
      joker: 14),
  JokerDraw(
      date: '2010-02-18',
      game: 'Joker',
      numbers: [18, 44, 28, 31, 13],
      joker: 2),
  JokerDraw(
      date: '2010-02-25', game: 'Joker', numbers: [16, 5, 33, 9, 24], joker: 4),
  JokerDraw(
      date: '2010-03-04',
      game: 'Joker',
      numbers: [34, 3, 14, 39, 43],
      joker: 18),
  JokerDraw(
      date: '2010-03-11',
      game: 'Joker',
      numbers: [14, 39, 29, 26, 22],
      joker: 4),
  JokerDraw(
      date: '2010-03-18',
      game: 'Joker',
      numbers: [15, 36, 24, 8, 16],
      joker: 10),
  JokerDraw(
      date: '2010-03-25', game: 'Joker', numbers: [17, 1, 24, 4, 2], joker: 10),
  JokerDraw(
      date: '2010-04-01',
      game: 'Joker',
      numbers: [23, 36, 20, 32, 1],
      joker: 7),
  JokerDraw(
      date: '2010-04-04',
      game: 'Joker',
      numbers: [29, 32, 43, 33, 40],
      joker: 17),
  JokerDraw(
      date: '2010-04-08',
      game: 'Joker',
      numbers: [37, 1, 4, 18, 14],
      joker: 12),
  JokerDraw(
      date: '2010-04-11',
      game: 'Joker',
      numbers: [39, 8, 16, 35, 18],
      joker: 18),
  JokerDraw(
      date: '2010-04-15', game: 'Joker', numbers: [4, 1, 12, 31, 32], joker: 9),
  JokerDraw(
      date: '2010-04-18', game: 'Joker', numbers: [7, 4, 41, 19, 38], joker: 1),
  JokerDraw(
      date: '2010-04-22',
      game: 'Joker',
      numbers: [41, 30, 18, 44, 34],
      joker: 19),
  JokerDraw(
      date: '2010-04-25',
      game: 'Joker',
      numbers: [37, 14, 39, 5, 28],
      joker: 17),
  JokerDraw(
      date: '2010-04-29',
      game: 'Joker',
      numbers: [26, 5, 38, 21, 43],
      joker: 11),
  JokerDraw(
      date: '2010-05-02',
      game: 'Joker',
      numbers: [18, 24, 7, 29, 11],
      joker: 3),
  JokerDraw(
      date: '2010-05-06',
      game: 'Joker',
      numbers: [35, 39, 37, 24, 1],
      joker: 1),
  JokerDraw(
      date: '2010-05-09',
      game: 'Joker',
      numbers: [43, 15, 14, 12, 13],
      joker: 17),
  JokerDraw(
      date: '2010-05-13',
      game: 'Joker',
      numbers: [31, 12, 11, 37, 3],
      joker: 6),
  JokerDraw(
      date: '2010-05-16',
      game: 'Joker',
      numbers: [5, 7, 43, 26, 14],
      joker: 11),
  JokerDraw(
      date: '2010-05-20',
      game: 'Joker',
      numbers: [14, 2, 20, 45, 21],
      joker: 9),
  JokerDraw(
      date: '2010-05-23',
      game: 'Joker',
      numbers: [21, 26, 18, 12, 9],
      joker: 20),
  JokerDraw(
      date: '2010-05-27',
      game: 'Joker',
      numbers: [37, 44, 32, 20, 8],
      joker: 19),
  JokerDraw(
      date: '2010-05-30',
      game: 'Joker',
      numbers: [2, 5, 35, 14, 41],
      joker: 17),
  JokerDraw(
      date: '2010-06-03',
      game: 'Joker',
      numbers: [45, 9, 13, 43, 37],
      joker: 12),
  JokerDraw(
      date: '2010-06-06',
      game: 'Joker',
      numbers: [43, 26, 22, 10, 23],
      joker: 14),
  JokerDraw(
      date: '2010-06-10',
      game: 'Joker',
      numbers: [32, 13, 9, 6, 38],
      joker: 14),
  JokerDraw(
      date: '2010-06-13',
      game: 'Joker',
      numbers: [8, 31, 5, 38, 20],
      joker: 13),
  JokerDraw(
      date: '2010-06-17',
      game: 'Joker',
      numbers: [19, 12, 21, 14, 1],
      joker: 14),
  JokerDraw(
      date: '2010-06-20', game: 'Joker', numbers: [7, 37, 16, 2, 21], joker: 5),
  JokerDraw(
      date: '2010-06-24',
      game: 'Joker',
      numbers: [32, 33, 12, 9, 11],
      joker: 6),
  JokerDraw(
      date: '2010-06-27',
      game: 'Joker',
      numbers: [37, 21, 14, 3, 18],
      joker: 20),
  JokerDraw(
      date: '2010-07-01',
      game: 'Joker',
      numbers: [11, 18, 16, 12, 24],
      joker: 6),
  JokerDraw(
      date: '2010-07-04', game: 'Joker', numbers: [7, 25, 33, 1, 11], joker: 9),
  JokerDraw(
      date: '2010-07-08',
      game: 'Joker',
      numbers: [43, 23, 27, 39, 24],
      joker: 8),
  JokerDraw(
      date: '2010-07-11', game: 'Joker', numbers: [9, 5, 11, 37, 44], joker: 7),
  JokerDraw(
      date: '2010-07-15', game: 'Joker', numbers: [43, 11, 9, 3, 25], joker: 3),
  JokerDraw(
      date: '2010-07-18',
      game: 'Joker',
      numbers: [45, 19, 3, 11, 37],
      joker: 5),
  JokerDraw(
      date: '2010-07-22',
      game: 'Joker',
      numbers: [41, 25, 1, 42, 7],
      joker: 20),
  JokerDraw(
      date: '2010-07-25',
      game: 'Joker',
      numbers: [27, 13, 45, 33, 41],
      joker: 13),
  JokerDraw(
      date: '2010-07-29',
      game: 'Joker',
      numbers: [22, 12, 19, 43, 8],
      joker: 18),
  JokerDraw(
      date: '2010-08-01',
      game: 'Joker',
      numbers: [44, 21, 8, 42, 16],
      joker: 3),
  JokerDraw(
      date: '2010-08-05',
      game: 'Joker',
      numbers: [2, 7, 36, 45, 18],
      joker: 10),
  JokerDraw(
      date: '2010-08-08',
      game: 'Joker',
      numbers: [10, 15, 39, 6, 26],
      joker: 6),
  JokerDraw(
      date: '2010-08-12',
      game: 'Joker',
      numbers: [17, 19, 40, 5, 3],
      joker: 20),
  JokerDraw(
      date: '2010-08-15',
      game: 'Joker',
      numbers: [16, 44, 4, 18, 1],
      joker: 11),
  JokerDraw(
      date: '2010-08-19',
      game: 'Joker',
      numbers: [28, 24, 1, 16, 6],
      joker: 18),
  JokerDraw(
      date: '2010-08-22',
      game: 'Joker',
      numbers: [44, 23, 29, 16, 4],
      joker: 5),
  JokerDraw(
      date: '2010-08-26',
      game: 'Joker',
      numbers: [15, 44, 36, 25, 12],
      joker: 19),
  JokerDraw(
      date: '2010-08-29',
      game: 'Joker',
      numbers: [22, 15, 8, 19, 43],
      joker: 4),
  JokerDraw(
      date: '2010-09-02', game: 'Joker', numbers: [6, 3, 41, 23, 7], joker: 8),
  JokerDraw(
      date: '2010-09-05', game: 'Joker', numbers: [16, 7, 40, 9, 27], joker: 5),
  JokerDraw(
      date: '2010-09-09',
      game: 'Joker',
      numbers: [5, 32, 28, 41, 29],
      joker: 12),
  JokerDraw(
      date: '2010-09-12',
      game: 'Joker',
      numbers: [5, 18, 35, 13, 30],
      joker: 5),
  JokerDraw(
      date: '2010-09-16',
      game: 'Joker',
      numbers: [25, 31, 34, 9, 11],
      joker: 20),
  JokerDraw(
      date: '2010-09-19',
      game: 'Joker',
      numbers: [40, 18, 45, 44, 2],
      joker: 9),
  JokerDraw(
      date: '2010-09-23',
      game: 'Joker',
      numbers: [33, 4, 18, 11, 31],
      joker: 8),
  JokerDraw(
      date: '2010-09-26',
      game: 'Joker',
      numbers: [25, 36, 41, 11, 34],
      joker: 16),
  JokerDraw(
      date: '2010-09-30',
      game: 'Joker',
      numbers: [37, 6, 20, 39, 30],
      joker: 9),
  JokerDraw(
      date: '2010-10-03',
      game: 'Joker',
      numbers: [30, 29, 14, 24, 10],
      joker: 20),
  JokerDraw(
      date: '2010-10-07',
      game: 'Joker',
      numbers: [5, 2, 10, 35, 25],
      joker: 19),
  JokerDraw(
      date: '2010-10-10',
      game: 'Joker',
      numbers: [5, 23, 9, 20, 44],
      joker: 11),
  JokerDraw(
      date: '2010-10-14',
      game: 'Joker',
      numbers: [5, 3, 11, 36, 23],
      joker: 16),
  JokerDraw(
      date: '2010-10-17',
      game: 'Joker',
      numbers: [22, 7, 21, 17, 20],
      joker: 16),
  JokerDraw(
      date: '2010-10-21', game: 'Joker', numbers: [35, 6, 13, 5, 41], joker: 1),
  JokerDraw(
      date: '2010-10-24', game: 'Joker', numbers: [11, 9, 41, 3, 7], joker: 19),
  JokerDraw(
      date: '2010-10-28', game: 'Joker', numbers: [1, 45, 5, 4, 29], joker: 3),
  JokerDraw(
      date: '2010-10-31',
      game: 'Joker',
      numbers: [27, 12, 21, 35, 20],
      joker: 14),
  JokerDraw(
      date: '2010-11-04',
      game: 'Joker',
      numbers: [16, 8, 39, 9, 41],
      joker: 19),
  JokerDraw(
      date: '2010-11-07',
      game: 'Joker',
      numbers: [12, 2, 39, 1, 34],
      joker: 19),
  JokerDraw(
      date: '2010-11-11', game: 'Joker', numbers: [32, 5, 40, 34, 4], joker: 1),
  JokerDraw(
      date: '2010-11-14',
      game: 'Joker',
      numbers: [20, 28, 31, 22, 4],
      joker: 5),
  JokerDraw(
      date: '2010-11-18',
      game: 'Joker',
      numbers: [18, 8, 19, 30, 28],
      joker: 17),
  JokerDraw(
      date: '2010-11-21',
      game: 'Joker',
      numbers: [45, 31, 34, 16, 27],
      joker: 10),
  JokerDraw(
      date: '2010-11-25',
      game: 'Joker',
      numbers: [33, 35, 2, 23, 21],
      joker: 3),
  JokerDraw(
      date: '2010-11-28',
      game: 'Joker',
      numbers: [23, 5, 19, 3, 25],
      joker: 14),
  JokerDraw(
      date: '2010-12-02',
      game: 'Joker',
      numbers: [24, 43, 33, 44, 45],
      joker: 2),
  JokerDraw(
      date: '2010-12-05', game: 'Joker', numbers: [5, 11, 2, 25, 14], joker: 4),
  JokerDraw(
      date: '2010-12-09',
      game: 'Joker',
      numbers: [6, 20, 4, 13, 30],
      joker: 12),
  JokerDraw(
      date: '2010-12-12',
      game: 'Joker',
      numbers: [20, 7, 14, 38, 41],
      joker: 1),
  JokerDraw(
      date: '2010-12-16',
      game: 'Joker',
      numbers: [20, 19, 44, 41, 23],
      joker: 11),
  JokerDraw(
      date: '2010-12-19',
      game: 'Joker',
      numbers: [43, 13, 4, 23, 18],
      joker: 13),
  JokerDraw(
      date: '2010-12-23', game: 'Joker', numbers: [11, 9, 2, 40, 18], joker: 8),
  JokerDraw(
      date: '2010-12-30',
      game: 'Joker',
      numbers: [34, 45, 28, 43, 7],
      joker: 20),
  JokerDraw(
      date: '2011-01-06',
      game: 'Joker',
      numbers: [33, 44, 17, 9, 23],
      joker: 17),
  JokerDraw(
      date: '2011-01-09',
      game: 'Joker',
      numbers: [24, 19, 18, 17, 38],
      joker: 10),
  JokerDraw(
      date: '2011-01-13', game: 'Joker', numbers: [40, 17, 28, 8, 6], joker: 4),
  JokerDraw(
      date: '2011-01-16',
      game: 'Joker',
      numbers: [35, 30, 23, 33, 6],
      joker: 19),
  JokerDraw(
      date: '2011-01-20',
      game: 'Joker',
      numbers: [13, 25, 18, 3, 34],
      joker: 14),
  JokerDraw(
      date: '2011-01-23',
      game: 'Joker',
      numbers: [21, 24, 18, 34, 42],
      joker: 20),
  JokerDraw(
      date: '2011-01-27',
      game: 'Joker',
      numbers: [21, 31, 2, 19, 30],
      joker: 18),
  JokerDraw(
      date: '2011-01-30',
      game: 'Joker',
      numbers: [23, 14, 31, 13, 3],
      joker: 14),
  JokerDraw(
      date: '2011-02-03',
      game: 'Joker',
      numbers: [29, 22, 17, 37, 14],
      joker: 7),
  JokerDraw(
      date: '2011-02-06',
      game: 'Joker',
      numbers: [34, 42, 37, 18, 43],
      joker: 15),
  JokerDraw(
      date: '2011-02-10',
      game: 'Joker',
      numbers: [16, 2, 11, 19, 20],
      joker: 9),
  JokerDraw(
      date: '2011-02-13',
      game: 'Joker',
      numbers: [11, 33, 24, 36, 8],
      joker: 6),
  JokerDraw(
      date: '2011-02-17',
      game: 'Joker',
      numbers: [16, 28, 37, 3, 35],
      joker: 19),
  JokerDraw(
      date: '2011-02-20',
      game: 'Joker',
      numbers: [6, 35, 15, 34, 10],
      joker: 6),
  JokerDraw(
      date: '2011-02-24',
      game: 'Joker',
      numbers: [17, 21, 23, 20, 13],
      joker: 5),
  JokerDraw(
      date: '2011-02-27', game: 'Joker', numbers: [9, 18, 12, 22, 6], joker: 1),
  JokerDraw(
      date: '2011-03-03',
      game: 'Joker',
      numbers: [43, 37, 29, 6, 23],
      joker: 10),
  JokerDraw(
      date: '2011-03-06',
      game: 'Joker',
      numbers: [14, 34, 6, 35, 19],
      joker: 12),
  JokerDraw(
      date: '2011-03-10',
      game: 'Joker',
      numbers: [29, 31, 33, 2, 44],
      joker: 1),
  JokerDraw(
      date: '2011-03-13',
      game: 'Joker',
      numbers: [34, 17, 39, 21, 14],
      joker: 1),
  JokerDraw(
      date: '2011-03-17',
      game: 'Joker',
      numbers: [2, 40, 30, 39, 3],
      joker: 20),
  JokerDraw(
      date: '2011-03-20',
      game: 'Joker',
      numbers: [37, 27, 8, 35, 28],
      joker: 20),
  JokerDraw(
      date: '2011-03-24', game: 'Joker', numbers: [11, 29, 44, 1, 9], joker: 4),
  JokerDraw(
      date: '2011-03-27',
      game: 'Joker',
      numbers: [44, 20, 30, 25, 35],
      joker: 17),
  JokerDraw(
      date: '2011-03-31',
      game: 'Joker',
      numbers: [40, 45, 11, 44, 31],
      joker: 7),
  JokerDraw(
      date: '2011-04-03',
      game: 'Joker',
      numbers: [17, 30, 19, 9, 11],
      joker: 17),
  JokerDraw(
      date: '2011-04-07',
      game: 'Joker',
      numbers: [34, 8, 28, 24, 26],
      joker: 10),
  JokerDraw(
      date: '2011-04-10',
      game: 'Joker',
      numbers: [13, 44, 37, 20, 23],
      joker: 2),
  JokerDraw(
      date: '2011-04-14',
      game: 'Joker',
      numbers: [2, 34, 43, 8, 36],
      joker: 11),
  JokerDraw(
      date: '2011-04-17',
      game: 'Joker',
      numbers: [4, 30, 28, 26, 1],
      joker: 17),
  JokerDraw(
      date: '2011-04-21',
      game: 'Joker',
      numbers: [10, 45, 11, 3, 18],
      joker: 19),
  JokerDraw(
      date: '2011-04-24',
      game: 'Joker',
      numbers: [10, 22, 4, 40, 19],
      joker: 8),
  JokerDraw(
      date: '2011-04-28',
      game: 'Joker',
      numbers: [10, 44, 19, 21, 32],
      joker: 8),
  JokerDraw(
      date: '2011-05-01',
      game: 'Joker',
      numbers: [43, 16, 32, 41, 34],
      joker: 5),
  JokerDraw(
      date: '2011-05-05',
      game: 'Joker',
      numbers: [12, 39, 4, 33, 15],
      joker: 14),
  JokerDraw(
      date: '2011-05-08',
      game: 'Joker',
      numbers: [13, 20, 16, 27, 10],
      joker: 15),
  JokerDraw(
      date: '2011-05-12',
      game: 'Joker',
      numbers: [6, 40, 8, 28, 30],
      joker: 12),
  JokerDraw(
      date: '2011-05-15',
      game: 'Joker',
      numbers: [26, 10, 17, 41, 4],
      joker: 4),
  JokerDraw(
      date: '2011-05-19',
      game: 'Joker',
      numbers: [11, 36, 20, 43, 1],
      joker: 2),
  JokerDraw(
      date: '2011-05-22',
      game: 'Joker',
      numbers: [4, 28, 41, 15, 39],
      joker: 18),
  JokerDraw(
      date: '2011-05-26',
      game: 'Joker',
      numbers: [9, 22, 2, 44, 45],
      joker: 16),
  JokerDraw(
      date: '2011-05-29',
      game: 'Joker',
      numbers: [31, 24, 36, 6, 14],
      joker: 3),
  JokerDraw(
      date: '2011-06-02',
      game: 'Joker',
      numbers: [5, 17, 20, 15, 21],
      joker: 5),
  JokerDraw(
      date: '2011-06-05',
      game: 'Joker',
      numbers: [10, 44, 4, 33, 24],
      joker: 19),
  JokerDraw(
      date: '2011-06-09',
      game: 'Joker',
      numbers: [45, 28, 16, 15, 2],
      joker: 9),
  JokerDraw(
      date: '2011-06-12', game: 'Joker', numbers: [7, 6, 3, 4, 36], joker: 5),
  JokerDraw(
      date: '2011-06-16', game: 'Joker', numbers: [23, 3, 41, 44, 7], joker: 7),
  JokerDraw(
      date: '2011-06-19', game: 'Joker', numbers: [31, 40, 9, 16, 8], joker: 5),
  JokerDraw(
      date: '2011-06-23', game: 'Joker', numbers: [30, 20, 41, 9, 2], joker: 4),
  JokerDraw(
      date: '2011-06-26', game: 'Joker', numbers: [17, 10, 9, 22, 4], joker: 3),
  JokerDraw(
      date: '2011-06-30',
      game: 'Joker',
      numbers: [27, 5, 44, 12, 6],
      joker: 16),
  JokerDraw(
      date: '2011-07-03', game: 'Joker', numbers: [43, 11, 8, 2, 32], joker: 6),
  JokerDraw(
      date: '2011-07-07',
      game: 'Joker',
      numbers: [29, 4, 45, 25, 36],
      joker: 17),
  JokerDraw(
      date: '2011-07-10',
      game: 'Joker',
      numbers: [8, 23, 33, 27, 39],
      joker: 4),
  JokerDraw(
      date: '2011-07-14',
      game: 'Joker',
      numbers: [9, 14, 35, 34, 32],
      joker: 16),
  JokerDraw(
      date: '2011-07-17',
      game: 'Joker',
      numbers: [13, 16, 37, 28, 25],
      joker: 6),
  JokerDraw(
      date: '2011-07-21',
      game: 'Joker',
      numbers: [31, 18, 45, 3, 23],
      joker: 3),
  JokerDraw(
      date: '2011-07-24',
      game: 'Joker',
      numbers: [13, 28, 37, 42, 33],
      joker: 9),
  JokerDraw(
      date: '2011-07-28',
      game: 'Joker',
      numbers: [44, 31, 28, 34, 16],
      joker: 12),
  JokerDraw(
      date: '2011-07-31',
      game: 'Joker',
      numbers: [41, 33, 13, 9, 34],
      joker: 11),
  JokerDraw(
      date: '2011-08-04', game: 'Joker', numbers: [12, 4, 25, 30, 8], joker: 7),
  JokerDraw(
      date: '2011-08-07',
      game: 'Joker',
      numbers: [42, 2, 19, 18, 15],
      joker: 3),
  JokerDraw(
      date: '2011-08-11',
      game: 'Joker',
      numbers: [3, 12, 21, 32, 16],
      joker: 10),
  JokerDraw(
      date: '2011-08-14',
      game: 'Joker',
      numbers: [25, 31, 6, 33, 39],
      joker: 20),
  JokerDraw(
      date: '2011-08-18',
      game: 'Joker',
      numbers: [6, 7, 29, 30, 27],
      joker: 11),
  JokerDraw(
      date: '2011-08-21',
      game: 'Joker',
      numbers: [34, 39, 27, 44, 17],
      joker: 2),
  JokerDraw(
      date: '2011-08-25',
      game: 'Joker',
      numbers: [11, 21, 23, 16, 42],
      joker: 13),
  JokerDraw(
      date: '2011-08-28',
      game: 'Joker',
      numbers: [28, 19, 16, 4, 41],
      joker: 19),
  JokerDraw(
      date: '2011-09-01',
      game: 'Joker',
      numbers: [7, 3, 12, 25, 13],
      joker: 12),
  JokerDraw(
      date: '2011-09-04',
      game: 'Joker',
      numbers: [29, 36, 44, 32, 33],
      joker: 8),
  JokerDraw(
      date: '2011-09-08',
      game: 'Joker',
      numbers: [27, 13, 39, 17, 33],
      joker: 14),
  JokerDraw(
      date: '2011-09-11',
      game: 'Joker',
      numbers: [8, 26, 27, 32, 7],
      joker: 14),
  JokerDraw(
      date: '2011-09-15',
      game: 'Joker',
      numbers: [7, 39, 16, 40, 23],
      joker: 6),
  JokerDraw(
      date: '2011-09-18',
      game: 'Joker',
      numbers: [25, 30, 18, 19, 8],
      joker: 16),
  JokerDraw(
      date: '2011-09-22', game: 'Joker', numbers: [13, 4, 31, 43, 2], joker: 2),
  JokerDraw(
      date: '2011-09-25',
      game: 'Joker',
      numbers: [36, 31, 1, 13, 32],
      joker: 12),
  JokerDraw(
      date: '2011-09-29',
      game: 'Joker',
      numbers: [23, 38, 24, 1, 32],
      joker: 20),
  JokerDraw(
      date: '2011-10-02',
      game: 'Joker',
      numbers: [12, 43, 11, 18, 27],
      joker: 10),
  JokerDraw(
      date: '2011-10-06', game: 'Joker', numbers: [5, 12, 14, 4, 1], joker: 20),
  JokerDraw(
      date: '2011-10-09',
      game: 'Joker',
      numbers: [36, 6, 23, 41, 18],
      joker: 12),
  JokerDraw(
      date: '2011-10-13',
      game: 'Joker',
      numbers: [16, 29, 24, 26, 8],
      joker: 3),
  JokerDraw(
      date: '2011-10-16',
      game: 'Joker',
      numbers: [39, 37, 1, 36, 15],
      joker: 9),
  JokerDraw(
      date: '2011-10-20',
      game: 'Joker',
      numbers: [4, 3, 31, 23, 20],
      joker: 10),
  JokerDraw(
      date: '2011-10-23',
      game: 'Joker',
      numbers: [41, 33, 25, 42, 21],
      joker: 16),
  JokerDraw(
      date: '2011-10-27',
      game: 'Joker',
      numbers: [41, 8, 23, 25, 33],
      joker: 3),
  JokerDraw(
      date: '2011-10-30', game: 'Joker', numbers: [16, 37, 3, 29, 9], joker: 9),
  JokerDraw(
      date: '2011-11-03',
      game: 'Joker',
      numbers: [5, 27, 36, 41, 40],
      joker: 8),
  JokerDraw(
      date: '2011-11-06',
      game: 'Joker',
      numbers: [3, 40, 18, 21, 30],
      joker: 20),
  JokerDraw(
      date: '2011-11-10', game: 'Joker', numbers: [31, 5, 34, 8, 23], joker: 9),
  JokerDraw(
      date: '2011-11-13', game: 'Joker', numbers: [7, 1, 35, 25, 18], joker: 5),
  JokerDraw(
      date: '2011-11-17',
      game: 'Joker',
      numbers: [35, 42, 24, 17, 28],
      joker: 7),
  JokerDraw(
      date: '2011-11-20', game: 'Joker', numbers: [15, 8, 33, 7, 4], joker: 15),
  JokerDraw(
      date: '2011-11-24',
      game: 'Joker',
      numbers: [11, 6, 37, 16, 30],
      joker: 20),
  JokerDraw(
      date: '2011-11-27', game: 'Joker', numbers: [8, 3, 4, 7, 14], joker: 12),
  JokerDraw(
      date: '2011-12-01',
      game: 'Joker',
      numbers: [13, 24, 20, 32, 31],
      joker: 5),
  JokerDraw(
      date: '2011-12-04',
      game: 'Joker',
      numbers: [40, 4, 13, 1, 29],
      joker: 20),
  JokerDraw(
      date: '2011-12-08',
      game: 'Joker',
      numbers: [1, 36, 18, 33, 32],
      joker: 1),
  JokerDraw(
      date: '2011-12-11', game: 'Joker', numbers: [37, 3, 6, 21, 2], joker: 14),
  JokerDraw(
      date: '2011-12-15',
      game: 'Joker',
      numbers: [3, 44, 20, 27, 14],
      joker: 10),
  JokerDraw(
      date: '2011-12-18',
      game: 'Joker',
      numbers: [17, 31, 29, 18, 6],
      joker: 7),
  JokerDraw(
      date: '2011-12-22',
      game: 'Joker',
      numbers: [44, 22, 31, 19, 13],
      joker: 10),
  JokerDraw(
      date: '2011-12-30',
      game: 'Joker',
      numbers: [11, 41, 38, 22, 19],
      joker: 11),
  JokerDraw(
      date: '2011-12-30',
      game: 'Joker',
      numbers: [22, 38, 29, 40, 9],
      joker: 13),
  JokerDraw(
      date: '2012-01-05',
      game: 'Joker',
      numbers: [12, 8, 40, 28, 26],
      joker: 17),
  JokerDraw(
      date: '2012-01-08',
      game: 'Joker',
      numbers: [23, 26, 34, 31, 4],
      joker: 6),
  JokerDraw(
      date: '2012-01-12',
      game: 'Joker',
      numbers: [34, 33, 26, 27, 16],
      joker: 4),
  JokerDraw(
      date: '2012-01-15',
      game: 'Joker',
      numbers: [42, 43, 11, 45, 17],
      joker: 13),
  JokerDraw(
      date: '2012-01-19',
      game: 'Joker',
      numbers: [16, 22, 7, 21, 40],
      joker: 13),
  JokerDraw(
      date: '2012-01-22',
      game: 'Joker',
      numbers: [24, 10, 18, 12, 16],
      joker: 13),
  JokerDraw(
      date: '2012-01-26',
      game: 'Joker',
      numbers: [22, 28, 32, 2, 40],
      joker: 6),
  JokerDraw(
      date: '2012-01-29', game: 'Joker', numbers: [37, 20, 4, 26, 7], joker: 7),
  JokerDraw(
      date: '2012-02-02',
      game: 'Joker',
      numbers: [23, 6, 29, 4, 22],
      joker: 11),
  JokerDraw(
      date: '2012-02-05',
      game: 'Joker',
      numbers: [8, 30, 9, 26, 17],
      joker: 13),
  JokerDraw(
      date: '2012-02-09',
      game: 'Joker',
      numbers: [23, 39, 11, 1, 22],
      joker: 19),
  JokerDraw(
      date: '2012-02-12',
      game: 'Joker',
      numbers: [35, 37, 7, 39, 12],
      joker: 8),
  JokerDraw(
      date: '2012-02-16',
      game: 'Joker',
      numbers: [26, 45, 11, 36, 25],
      joker: 9),
  JokerDraw(
      date: '2012-02-19',
      game: 'Joker',
      numbers: [28, 37, 34, 33, 6],
      joker: 14),
  JokerDraw(
      date: '2012-02-23',
      game: 'Joker',
      numbers: [11, 3, 30, 36, 19],
      joker: 2),
  JokerDraw(
      date: '2012-02-26',
      game: 'Joker',
      numbers: [31, 40, 30, 13, 5],
      joker: 7),
  JokerDraw(
      date: '2012-03-01', game: 'Joker', numbers: [8, 39, 3, 43, 42], joker: 2),
  JokerDraw(
      date: '2012-03-04',
      game: 'Joker',
      numbers: [35, 5, 29, 28, 19],
      joker: 2),
  JokerDraw(
      date: '2012-03-08',
      game: 'Joker',
      numbers: [14, 40, 25, 20, 9],
      joker: 20),
  JokerDraw(
      date: '2012-03-11',
      game: 'Joker',
      numbers: [16, 44, 32, 23, 34],
      joker: 18),
  JokerDraw(
      date: '2012-03-15',
      game: 'Joker',
      numbers: [36, 5, 31, 38, 17],
      joker: 7),
  JokerDraw(
      date: '2012-03-18',
      game: 'Joker',
      numbers: [36, 26, 27, 30, 5],
      joker: 17),
  JokerDraw(
      date: '2012-03-22',
      game: 'Joker',
      numbers: [34, 45, 25, 26, 15],
      joker: 1),
  JokerDraw(
      date: '2012-03-25',
      game: 'Joker',
      numbers: [33, 14, 17, 26, 11],
      joker: 1),
  JokerDraw(
      date: '2012-03-29',
      game: 'Joker',
      numbers: [27, 8, 34, 31, 4],
      joker: 19),
  JokerDraw(
      date: '2012-04-01',
      game: 'Joker',
      numbers: [1, 45, 36, 6, 13],
      joker: 13),
  JokerDraw(
      date: '2012-04-05',
      game: 'Joker',
      numbers: [16, 19, 17, 5, 44],
      joker: 4),
  JokerDraw(
      date: '2012-04-08',
      game: 'Joker',
      numbers: [28, 24, 5, 4, 30],
      joker: 15),
  JokerDraw(
      date: '2012-04-15',
      game: 'Joker',
      numbers: [22, 25, 24, 13, 16],
      joker: 3),
  JokerDraw(
      date: '2012-04-15',
      game: 'Joker',
      numbers: [29, 38, 31, 20, 24],
      joker: 10),
  JokerDraw(
      date: '2012-04-19',
      game: 'Joker',
      numbers: [21, 23, 17, 7, 39],
      joker: 5),
  JokerDraw(
      date: '2012-04-22',
      game: 'Joker',
      numbers: [26, 13, 21, 43, 9],
      joker: 13),
  JokerDraw(
      date: '2012-04-26',
      game: 'Joker',
      numbers: [44, 17, 42, 8, 40],
      joker: 3),
  JokerDraw(
      date: '2012-04-29', game: 'Joker', numbers: [30, 31, 6, 1, 2], joker: 15),
  JokerDraw(
      date: '2012-05-03',
      game: 'Joker',
      numbers: [18, 24, 12, 30, 31],
      joker: 20),
  JokerDraw(
      date: '2012-05-06',
      game: 'Joker',
      numbers: [6, 45, 30, 37, 44],
      joker: 17),
  JokerDraw(
      date: '2012-05-10', game: 'Joker', numbers: [8, 18, 17, 6, 30], joker: 5),
  JokerDraw(
      date: '2012-05-13',
      game: 'Joker',
      numbers: [42, 11, 45, 34, 28],
      joker: 10),
  JokerDraw(
      date: '2012-05-17',
      game: 'Joker',
      numbers: [44, 22, 18, 12, 13],
      joker: 15),
  JokerDraw(
      date: '2012-05-20',
      game: 'Joker',
      numbers: [8, 43, 25, 35, 45],
      joker: 4),
  JokerDraw(
      date: '2012-05-24',
      game: 'Joker',
      numbers: [29, 6, 38, 43, 34],
      joker: 6),
  JokerDraw(
      date: '2012-05-27',
      game: 'Joker',
      numbers: [18, 25, 14, 36, 33],
      joker: 4),
  JokerDraw(
      date: '2012-05-31',
      game: 'Joker',
      numbers: [9, 11, 40, 10, 36],
      joker: 6),
  JokerDraw(
      date: '2012-06-03', game: 'Joker', numbers: [6, 13, 18, 8, 25], joker: 2),
  JokerDraw(
      date: '2012-06-07', game: 'Joker', numbers: [1, 37, 8, 32, 2], joker: 10),
  JokerDraw(
      date: '2012-06-10',
      game: 'Joker',
      numbers: [45, 17, 35, 37, 3],
      joker: 15),
  JokerDraw(
      date: '2012-06-14',
      game: 'Joker',
      numbers: [7, 35, 11, 21, 16],
      joker: 4),
  JokerDraw(
      date: '2012-06-17',
      game: 'Joker',
      numbers: [40, 14, 44, 37, 45],
      joker: 11),
  JokerDraw(
      date: '2012-06-21',
      game: 'Joker',
      numbers: [7, 33, 23, 31, 45],
      joker: 7),
  JokerDraw(
      date: '2012-06-24',
      game: 'Joker',
      numbers: [45, 40, 20, 18, 16],
      joker: 15),
  JokerDraw(
      date: '2012-06-28', game: 'Joker', numbers: [9, 1, 45, 42, 40], joker: 6),
  JokerDraw(
      date: '2012-07-01',
      game: 'Joker',
      numbers: [1, 17, 38, 29, 19],
      joker: 12),
  JokerDraw(
      date: '2012-07-05',
      game: 'Joker',
      numbers: [37, 39, 28, 26, 12],
      joker: 4),
  JokerDraw(
      date: '2012-07-08',
      game: 'Joker',
      numbers: [13, 8, 23, 5, 15],
      joker: 12),
  JokerDraw(
      date: '2012-07-12',
      game: 'Joker',
      numbers: [2, 43, 45, 39, 27],
      joker: 2),
  JokerDraw(
      date: '2012-07-15',
      game: 'Joker',
      numbers: [44, 22, 32, 41, 43],
      joker: 8),
  JokerDraw(
      date: '2012-07-19',
      game: 'Joker',
      numbers: [40, 8, 15, 35, 34],
      joker: 11),
  JokerDraw(
      date: '2012-07-22', game: 'Joker', numbers: [37, 6, 4, 23, 26], joker: 3),
  JokerDraw(
      date: '2012-07-26',
      game: 'Joker',
      numbers: [15, 39, 6, 21, 33],
      joker: 20),
  JokerDraw(
      date: '2012-07-29', game: 'Joker', numbers: [4, 17, 45, 1, 5], joker: 18),
  JokerDraw(
      date: '2012-08-02',
      game: 'Joker',
      numbers: [43, 40, 34, 30, 17],
      joker: 19),
  JokerDraw(
      date: '2012-08-05',
      game: 'Joker',
      numbers: [34, 2, 1, 30, 11],
      joker: 12),
  JokerDraw(
      date: '2012-08-09',
      game: 'Joker',
      numbers: [8, 29, 26, 20, 45],
      joker: 6),
  JokerDraw(
      date: '2012-08-12',
      game: 'Joker',
      numbers: [19, 17, 45, 5, 21],
      joker: 1),
  JokerDraw(
      date: '2012-08-16',
      game: 'Joker',
      numbers: [10, 28, 18, 24, 12],
      joker: 14),
  JokerDraw(
      date: '2012-08-19', game: 'Joker', numbers: [15, 3, 7, 35, 23], joker: 4),
  JokerDraw(
      date: '2012-08-23',
      game: 'Joker',
      numbers: [30, 38, 32, 9, 34],
      joker: 10),
  JokerDraw(
      date: '2012-08-26',
      game: 'Joker',
      numbers: [8, 37, 16, 27, 42],
      joker: 11),
  JokerDraw(
      date: '2012-08-30',
      game: 'Joker',
      numbers: [11, 29, 14, 26, 39],
      joker: 5),
  JokerDraw(
      date: '2012-09-02',
      game: 'Joker',
      numbers: [34, 35, 23, 42, 18],
      joker: 15),
  JokerDraw(
      date: '2012-09-06',
      game: 'Joker',
      numbers: [27, 31, 28, 7, 23],
      joker: 18),
  JokerDraw(
      date: '2012-09-09',
      game: 'Joker',
      numbers: [22, 3, 33, 12, 13],
      joker: 7),
  JokerDraw(
      date: '2012-09-16',
      game: 'Joker',
      numbers: [31, 30, 1, 19, 35],
      joker: 16),
  JokerDraw(
      date: '2012-09-16', game: 'Joker', numbers: [3, 29, 1, 10, 35], joker: 1),
  JokerDraw(
      date: '2012-09-20',
      game: 'Joker',
      numbers: [12, 35, 17, 23, 18],
      joker: 6),
  JokerDraw(
      date: '2012-09-23', game: 'Joker', numbers: [4, 9, 10, 18, 38], joker: 1),
  JokerDraw(
      date: '2012-09-27',
      game: 'Joker',
      numbers: [30, 17, 34, 45, 27],
      joker: 14),
  JokerDraw(
      date: '2012-09-30', game: 'Joker', numbers: [14, 28, 5, 8, 22], joker: 1),
  JokerDraw(
      date: '2012-10-04', game: 'Joker', numbers: [7, 22, 3, 8, 9], joker: 3),
  JokerDraw(
      date: '2012-10-07', game: 'Joker', numbers: [7, 25, 3, 8, 39], joker: 15),
  JokerDraw(
      date: '2012-10-11',
      game: 'Joker',
      numbers: [37, 44, 20, 29, 34],
      joker: 12),
  JokerDraw(
      date: '2012-10-14',
      game: 'Joker',
      numbers: [35, 33, 37, 3, 20],
      joker: 7),
  JokerDraw(
      date: '2012-10-18',
      game: 'Joker',
      numbers: [40, 5, 33, 23, 12],
      joker: 5),
  JokerDraw(
      date: '2012-10-21',
      game: 'Joker',
      numbers: [32, 26, 18, 25, 22],
      joker: 12),
  JokerDraw(
      date: '2012-10-25',
      game: 'Joker',
      numbers: [33, 16, 41, 26, 42],
      joker: 3),
  JokerDraw(
      date: '2012-10-28',
      game: 'Joker',
      numbers: [41, 16, 36, 21, 5],
      joker: 10),
  JokerDraw(
      date: '2012-11-01', game: 'Joker', numbers: [33, 4, 13, 40, 6], joker: 7),
  JokerDraw(
      date: '2012-11-04',
      game: 'Joker',
      numbers: [35, 33, 40, 34, 26],
      joker: 16),
  JokerDraw(
      date: '2012-11-08',
      game: 'Joker',
      numbers: [14, 18, 24, 40, 11],
      joker: 5),
  JokerDraw(
      date: '2012-11-11', game: 'Joker', numbers: [8, 5, 20, 33, 17], joker: 4),
  JokerDraw(
      date: '2012-11-15', game: 'Joker', numbers: [2, 6, 43, 39, 30], joker: 1),
  JokerDraw(
      date: '2012-11-18',
      game: 'Joker',
      numbers: [23, 36, 39, 1, 17],
      joker: 14),
  JokerDraw(
      date: '2012-11-22',
      game: 'Joker',
      numbers: [27, 36, 22, 28, 16],
      joker: 4),
  JokerDraw(
      date: '2012-11-25',
      game: 'Joker',
      numbers: [30, 43, 15, 29, 24],
      joker: 10),
  JokerDraw(
      date: '2012-11-29',
      game: 'Joker',
      numbers: [41, 18, 43, 34, 1],
      joker: 5),
  JokerDraw(
      date: '2012-12-02',
      game: 'Joker',
      numbers: [22, 8, 37, 33, 29],
      joker: 20),
  JokerDraw(
      date: '2012-12-06',
      game: 'Joker',
      numbers: [42, 3, 5, 18, 28],
      joker: 13),
  JokerDraw(
      date: '2012-12-09',
      game: 'Joker',
      numbers: [18, 37, 16, 39, 43],
      joker: 19),
  JokerDraw(
      date: '2012-12-13',
      game: 'Joker',
      numbers: [12, 16, 2, 19, 22],
      joker: 5),
  JokerDraw(
      date: '2012-12-16',
      game: 'Joker',
      numbers: [37, 17, 26, 36, 44],
      joker: 2),
  JokerDraw(
      date: '2012-12-20', game: 'Joker', numbers: [5, 11, 15, 2, 1], joker: 20),
  JokerDraw(
      date: '2012-12-23',
      game: 'Joker',
      numbers: [44, 38, 6, 29, 43],
      joker: 15),
  JokerDraw(
      date: '2012-12-30', game: 'Joker', numbers: [18, 9, 15, 24, 1], joker: 6),
  JokerDraw(
      date: '2012-12-30',
      game: 'Joker',
      numbers: [16, 39, 33, 2, 22],
      joker: 18),
  JokerDraw(
      date: '2013-01-06',
      game: 'Joker',
      numbers: [35, 34, 32, 21, 27],
      joker: 9),
  JokerDraw(
      date: '2013-01-10', game: 'Joker', numbers: [7, 19, 20, 37, 3], joker: 2),
  JokerDraw(
      date: '2013-01-13',
      game: 'Joker',
      numbers: [39, 33, 29, 4, 38],
      joker: 3),
  JokerDraw(
      date: '2013-01-17',
      game: 'Joker',
      numbers: [37, 31, 3, 13, 15],
      joker: 4),
  JokerDraw(
      date: '2013-01-20',
      game: 'Joker',
      numbers: [32, 18, 17, 14, 38],
      joker: 16),
  JokerDraw(
      date: '2013-01-24',
      game: 'Joker',
      numbers: [18, 32, 1, 35, 23],
      joker: 6),
  JokerDraw(
      date: '2013-01-27',
      game: 'Joker',
      numbers: [40, 35, 17, 9, 42],
      joker: 13),
  JokerDraw(
      date: '2013-01-31',
      game: 'Joker',
      numbers: [15, 19, 13, 10, 29],
      joker: 20),
  JokerDraw(
      date: '2013-02-03', game: 'Joker', numbers: [8, 35, 4, 13, 9], joker: 5),
  JokerDraw(
      date: '2013-02-07',
      game: 'Joker',
      numbers: [35, 12, 9, 10, 41],
      joker: 20),
  JokerDraw(
      date: '2013-02-10',
      game: 'Joker',
      numbers: [28, 18, 5, 29, 42],
      joker: 11),
  JokerDraw(
      date: '2013-02-14',
      game: 'Joker',
      numbers: [27, 32, 44, 45, 23],
      joker: 5),
  JokerDraw(
      date: '2013-02-17',
      game: 'Joker',
      numbers: [45, 38, 2, 42, 11],
      joker: 1),
  JokerDraw(
      date: '2013-02-21',
      game: 'Joker',
      numbers: [3, 35, 39, 38, 9],
      joker: 18),
  JokerDraw(
      date: '2013-02-24',
      game: 'Joker',
      numbers: [32, 40, 15, 38, 4],
      joker: 4),
  JokerDraw(
      date: '2013-02-28',
      game: 'Joker',
      numbers: [40, 23, 39, 13, 18],
      joker: 14),
  JokerDraw(
      date: '2013-03-03',
      game: 'Joker',
      numbers: [12, 45, 19, 36, 28],
      joker: 17),
  JokerDraw(
      date: '2013-03-07',
      game: 'Joker',
      numbers: [12, 17, 32, 44, 37],
      joker: 6),
  JokerDraw(
      date: '2013-03-10',
      game: 'Joker',
      numbers: [5, 33, 41, 40, 23],
      joker: 6),
  JokerDraw(
      date: '2013-03-14', game: 'Joker', numbers: [28, 6, 9, 10, 40], joker: 2),
  JokerDraw(
      date: '2013-03-17',
      game: 'Joker',
      numbers: [27, 8, 43, 23, 19],
      joker: 20),
  JokerDraw(
      date: '2013-03-21',
      game: 'Joker',
      numbers: [15, 26, 30, 32, 1],
      joker: 2),
  JokerDraw(
      date: '2013-03-24', game: 'Joker', numbers: [9, 30, 44, 6, 10], joker: 3),
  JokerDraw(
      date: '2013-03-28',
      game: 'Joker',
      numbers: [5, 8, 34, 18, 25],
      joker: 12),
  JokerDraw(
      date: '2013-03-31',
      game: 'Joker',
      numbers: [45, 39, 19, 41, 15],
      joker: 18),
  JokerDraw(
      date: '2013-04-04',
      game: 'Joker',
      numbers: [20, 45, 36, 3, 19],
      joker: 4),
  JokerDraw(
      date: '2013-04-07', game: 'Joker', numbers: [13, 18, 9, 4, 27], joker: 1),
  JokerDraw(
      date: '2013-04-11',
      game: 'Joker',
      numbers: [45, 10, 9, 42, 22],
      joker: 19),
  JokerDraw(
      date: '2013-04-14',
      game: 'Joker',
      numbers: [9, 17, 14, 30, 16],
      joker: 14),
  JokerDraw(
      date: '2013-04-18',
      game: 'Joker',
      numbers: [4, 39, 13, 37, 36],
      joker: 10),
  JokerDraw(
      date: '2013-04-21',
      game: 'Joker',
      numbers: [28, 41, 4, 36, 1],
      joker: 15),
  JokerDraw(
      date: '2013-04-25',
      game: 'Joker',
      numbers: [2, 30, 13, 38, 34],
      joker: 12),
  JokerDraw(
      date: '2013-04-28',
      game: 'Joker',
      numbers: [43, 10, 2, 12, 11],
      joker: 15),
  JokerDraw(
      date: '2013-05-05',
      game: 'Joker',
      numbers: [44, 3, 38, 33, 27],
      joker: 17),
  JokerDraw(
      date: '2013-05-05', game: 'Joker', numbers: [8, 6, 15, 7, 3], joker: 4),
  JokerDraw(
      date: '2013-05-09',
      game: 'Joker',
      numbers: [15, 16, 11, 23, 22],
      joker: 9),
  JokerDraw(
      date: '2013-05-12', game: 'Joker', numbers: [23, 5, 39, 33, 3], joker: 7),
  JokerDraw(
      date: '2013-05-16',
      game: 'Joker',
      numbers: [30, 39, 41, 19, 38],
      joker: 6),
  JokerDraw(
      date: '2013-05-19',
      game: 'Joker',
      numbers: [32, 30, 10, 42, 6],
      joker: 11),
  JokerDraw(
      date: '2013-05-23',
      game: 'Joker',
      numbers: [39, 32, 14, 1, 13],
      joker: 14),
  JokerDraw(
      date: '2013-05-26',
      game: 'Joker',
      numbers: [17, 41, 21, 7, 36],
      joker: 7),
  JokerDraw(
      date: '2013-05-30',
      game: 'Joker',
      numbers: [26, 21, 17, 23, 30],
      joker: 10),
  JokerDraw(
      date: '2013-06-02',
      game: 'Joker',
      numbers: [31, 18, 11, 7, 39],
      joker: 15),
  JokerDraw(
      date: '2013-06-06',
      game: 'Joker',
      numbers: [23, 45, 20, 9, 11],
      joker: 5),
  JokerDraw(
      date: '2013-06-09',
      game: 'Joker',
      numbers: [11, 30, 35, 28, 37],
      joker: 10),
  JokerDraw(
      date: '2013-06-13', game: 'Joker', numbers: [18, 2, 1, 30, 32], joker: 4),
  JokerDraw(
      date: '2013-06-16',
      game: 'Joker',
      numbers: [41, 17, 31, 25, 33],
      joker: 15),
  JokerDraw(
      date: '2013-06-20',
      game: 'Joker',
      numbers: [13, 25, 20, 28, 36],
      joker: 6),
  JokerDraw(
      date: '2013-06-23',
      game: 'Joker',
      numbers: [13, 1, 19, 14, 29],
      joker: 13),
  JokerDraw(
      date: '2013-06-27',
      game: 'Joker',
      numbers: [25, 7, 33, 9, 30],
      joker: 11),
  JokerDraw(
      date: '2013-06-30',
      game: 'Joker',
      numbers: [21, 6, 45, 44, 26],
      joker: 1),
  JokerDraw(
      date: '2013-07-04',
      game: 'Joker',
      numbers: [16, 2, 17, 14, 15],
      joker: 7),
  JokerDraw(
      date: '2013-07-07', game: 'Joker', numbers: [4, 20, 16, 3, 8], joker: 5),
  JokerDraw(
      date: '2013-07-11',
      game: 'Joker',
      numbers: [36, 20, 5, 37, 15],
      joker: 1),
  JokerDraw(
      date: '2013-07-14',
      game: 'Joker',
      numbers: [38, 17, 37, 28, 8],
      joker: 2),
  JokerDraw(
      date: '2013-07-18',
      game: 'Joker',
      numbers: [32, 39, 40, 13, 22],
      joker: 13),
  JokerDraw(
      date: '2013-07-21',
      game: 'Joker',
      numbers: [45, 13, 31, 25, 43],
      joker: 3),
  JokerDraw(
      date: '2013-07-25',
      game: 'Joker',
      numbers: [11, 41, 20, 38, 27],
      joker: 7),
  JokerDraw(
      date: '2013-07-28',
      game: 'Joker',
      numbers: [11, 8, 27, 31, 32],
      joker: 13),
  JokerDraw(
      date: '2013-08-01',
      game: 'Joker',
      numbers: [5, 33, 32, 30, 20],
      joker: 4),
  JokerDraw(
      date: '2013-08-04',
      game: 'Joker',
      numbers: [39, 13, 9, 29, 19],
      joker: 20),
  JokerDraw(
      date: '2013-08-08',
      game: 'Joker',
      numbers: [7, 33, 28, 20, 12],
      joker: 2),
  JokerDraw(
      date: '2013-08-11',
      game: 'Joker',
      numbers: [11, 23, 20, 43, 45],
      joker: 7),
  JokerDraw(
      date: '2013-08-15',
      game: 'Joker',
      numbers: [9, 40, 30, 8, 24],
      joker: 18),
  JokerDraw(
      date: '2013-08-18',
      game: 'Joker',
      numbers: [32, 15, 29, 42, 3],
      joker: 5),
  JokerDraw(
      date: '2013-08-22',
      game: 'Joker',
      numbers: [17, 29, 28, 4, 40],
      joker: 14),
  JokerDraw(
      date: '2013-08-25',
      game: 'Joker',
      numbers: [31, 37, 6, 17, 42],
      joker: 12),
  JokerDraw(
      date: '2013-08-29',
      game: 'Joker',
      numbers: [5, 11, 42, 20, 28],
      joker: 10),
  JokerDraw(
      date: '2013-09-01', game: 'Joker', numbers: [6, 1, 37, 5, 13], joker: 18),
  JokerDraw(
      date: '2013-09-05',
      game: 'Joker',
      numbers: [14, 22, 16, 32, 25],
      joker: 16),
  JokerDraw(
      date: '2013-09-08',
      game: 'Joker',
      numbers: [37, 32, 36, 42, 33],
      joker: 3),
  JokerDraw(
      date: '2013-09-15',
      game: 'Joker',
      numbers: [36, 14, 32, 43, 9],
      joker: 9),
  JokerDraw(
      date: '2013-09-15',
      game: 'Joker',
      numbers: [13, 36, 15, 30, 37],
      joker: 19),
  JokerDraw(
      date: '2013-09-19',
      game: 'Joker',
      numbers: [6, 25, 32, 13, 29],
      joker: 20),
  JokerDraw(
      date: '2013-09-22',
      game: 'Joker',
      numbers: [12, 24, 4, 9, 32],
      joker: 16),
  JokerDraw(
      date: '2013-09-26',
      game: 'Joker',
      numbers: [4, 39, 30, 6, 10],
      joker: 17),
  JokerDraw(
      date: '2013-09-29',
      game: 'Joker',
      numbers: [38, 44, 27, 13, 40],
      joker: 17),
  JokerDraw(
      date: '2013-10-03',
      game: 'Joker',
      numbers: [24, 15, 45, 29, 28],
      joker: 16),
  JokerDraw(
      date: '2013-10-06',
      game: 'Joker',
      numbers: [39, 33, 29, 35, 14],
      joker: 4),
  JokerDraw(
      date: '2013-10-10',
      game: 'Joker',
      numbers: [24, 45, 17, 29, 10],
      joker: 4),
  JokerDraw(
      date: '2013-10-13',
      game: 'Joker',
      numbers: [36, 10, 19, 30, 8],
      joker: 9),
  JokerDraw(
      date: '2013-10-17',
      game: 'Joker',
      numbers: [32, 31, 28, 4, 22],
      joker: 10),
  JokerDraw(
      date: '2013-10-20',
      game: 'Joker',
      numbers: [45, 14, 44, 25, 39],
      joker: 20),
  JokerDraw(
      date: '2013-10-24',
      game: 'Joker',
      numbers: [7, 19, 15, 2, 11],
      joker: 13),
  JokerDraw(
      date: '2013-10-27', game: 'Joker', numbers: [2, 34, 3, 32, 10], joker: 7),
  JokerDraw(
      date: '2013-10-31', game: 'Joker', numbers: [9, 7, 18, 19, 39], joker: 3),
  JokerDraw(
      date: '2013-11-03', game: 'Joker', numbers: [8, 34, 26, 27, 1], joker: 3),
  JokerDraw(
      date: '2013-11-07',
      game: 'Joker',
      numbers: [20, 29, 33, 7, 44],
      joker: 7),
  JokerDraw(
      date: '2013-11-10',
      game: 'Joker',
      numbers: [29, 24, 28, 21, 19],
      joker: 8),
  JokerDraw(
      date: '2013-11-14',
      game: 'Joker',
      numbers: [22, 2, 28, 11, 21],
      joker: 15),
  JokerDraw(
      date: '2013-11-17',
      game: 'Joker',
      numbers: [25, 44, 36, 40, 19],
      joker: 20),
  JokerDraw(
      date: '2013-11-21',
      game: 'Joker',
      numbers: [42, 19, 6, 38, 18],
      joker: 2),
  JokerDraw(
      date: '2013-11-24',
      game: 'Joker',
      numbers: [7, 44, 40, 12, 39],
      joker: 17),
  JokerDraw(
      date: '2013-11-28',
      game: 'Joker',
      numbers: [31, 30, 18, 25, 28],
      joker: 13),
  JokerDraw(
      date: '2013-12-01',
      game: 'Joker',
      numbers: [29, 38, 36, 37, 23],
      joker: 6),
  JokerDraw(
      date: '2013-12-05',
      game: 'Joker',
      numbers: [6, 23, 35, 17, 30],
      joker: 19),
  JokerDraw(
      date: '2013-12-08', game: 'Joker', numbers: [9, 1, 18, 2, 45], joker: 4),
  JokerDraw(
      date: '2013-12-12',
      game: 'Joker',
      numbers: [26, 16, 21, 41, 8],
      joker: 19),
  JokerDraw(
      date: '2013-12-15',
      game: 'Joker',
      numbers: [4, 39, 29, 10, 24],
      joker: 19),
  JokerDraw(
      date: '2013-12-19',
      game: 'Joker',
      numbers: [43, 12, 42, 30, 15],
      joker: 14),
  JokerDraw(
      date: '2013-12-22',
      game: 'Joker',
      numbers: [43, 5, 18, 14, 8],
      joker: 20),
  JokerDraw(
      date: '2013-12-30',
      game: 'Joker',
      numbers: [8, 23, 42, 43, 40],
      joker: 19),
  JokerDraw(
      date: '2013-12-30',
      game: 'Joker',
      numbers: [10, 44, 24, 3, 41],
      joker: 2),
  JokerDraw(
      date: '2014-01-05',
      game: 'Joker',
      numbers: [28, 30, 2, 37, 45],
      joker: 16),
  JokerDraw(
      date: '2014-01-09',
      game: 'Joker',
      numbers: [9, 21, 23, 19, 6],
      joker: 18),
  JokerDraw(
      date: '2014-01-12',
      game: 'Joker',
      numbers: [42, 10, 25, 21, 36],
      joker: 2),
  JokerDraw(
      date: '2014-01-16',
      game: 'Joker',
      numbers: [14, 19, 24, 45, 9],
      joker: 20),
  JokerDraw(
      date: '2014-01-19',
      game: 'Joker',
      numbers: [16, 11, 2, 40, 9],
      joker: 10),
  JokerDraw(
      date: '2014-01-23',
      game: 'Joker',
      numbers: [44, 14, 19, 45, 27],
      joker: 13),
  JokerDraw(
      date: '2014-01-26', game: 'Joker', numbers: [1, 10, 20, 4, 23], joker: 9),
  JokerDraw(
      date: '2014-01-30',
      game: 'Joker',
      numbers: [44, 43, 41, 22, 16],
      joker: 20),
  JokerDraw(
      date: '2014-02-02',
      game: 'Joker',
      numbers: [10, 17, 29, 7, 45],
      joker: 5),
  JokerDraw(
      date: '2014-02-06',
      game: 'Joker',
      numbers: [34, 2, 36, 45, 27],
      joker: 16),
  JokerDraw(
      date: '2014-02-09',
      game: 'Joker',
      numbers: [10, 29, 24, 5, 25],
      joker: 13),
  JokerDraw(
      date: '2014-02-13',
      game: 'Joker',
      numbers: [21, 5, 22, 43, 30],
      joker: 9),
  JokerDraw(
      date: '2014-02-16',
      game: 'Joker',
      numbers: [31, 34, 21, 30, 19],
      joker: 7),
  JokerDraw(
      date: '2014-02-20',
      game: 'Joker',
      numbers: [34, 5, 30, 45, 33],
      joker: 16),
  JokerDraw(
      date: '2014-02-23',
      game: 'Joker',
      numbers: [11, 1, 39, 24, 13],
      joker: 5),
  JokerDraw(
      date: '2014-02-27',
      game: 'Joker',
      numbers: [26, 25, 20, 3, 28],
      joker: 4),
  JokerDraw(
      date: '2014-03-02',
      game: 'Joker',
      numbers: [24, 45, 32, 27, 19],
      joker: 11),
  JokerDraw(
      date: '2014-03-06',
      game: 'Joker',
      numbers: [32, 39, 6, 13, 33],
      joker: 4),
  JokerDraw(
      date: '2014-03-09',
      game: 'Joker',
      numbers: [38, 45, 20, 41, 39],
      joker: 2),
  JokerDraw(
      date: '2014-03-13',
      game: 'Joker',
      numbers: [2, 39, 45, 1, 37],
      joker: 14),
  JokerDraw(
      date: '2014-03-16',
      game: 'Joker',
      numbers: [22, 45, 32, 35, 38],
      joker: 17),
  JokerDraw(
      date: '2014-03-20',
      game: 'Joker',
      numbers: [39, 34, 9, 29, 11],
      joker: 19),
  JokerDraw(
      date: '2014-03-23',
      game: 'Joker',
      numbers: [23, 31, 19, 34, 43],
      joker: 6),
  JokerDraw(
      date: '2014-03-27',
      game: 'Joker',
      numbers: [15, 6, 11, 24, 27],
      joker: 5),
  JokerDraw(
      date: '2014-03-30',
      game: 'Joker',
      numbers: [38, 44, 20, 26, 16],
      joker: 15),
  JokerDraw(
      date: '2014-04-03',
      game: 'Joker',
      numbers: [40, 45, 38, 22, 39],
      joker: 16),
  JokerDraw(
      date: '2014-04-06',
      game: 'Joker',
      numbers: [18, 15, 43, 45, 4],
      joker: 2),
  JokerDraw(
      date: '2014-04-10',
      game: 'Joker',
      numbers: [15, 29, 13, 38, 43],
      joker: 15),
  JokerDraw(
      date: '2014-04-13',
      game: 'Joker',
      numbers: [39, 32, 16, 29, 27],
      joker: 20),
  JokerDraw(
      date: '2014-04-20',
      game: 'Joker',
      numbers: [10, 9, 23, 16, 22],
      joker: 1),
  JokerDraw(
      date: '2014-04-20',
      game: 'Joker',
      numbers: [44, 18, 35, 5, 19],
      joker: 11),
  JokerDraw(
      date: '2014-04-24',
      game: 'Joker',
      numbers: [21, 5, 42, 38, 43],
      joker: 11),
  JokerDraw(
      date: '2014-04-27',
      game: 'Joker',
      numbers: [17, 42, 4, 44, 37],
      joker: 2),
  JokerDraw(
      date: '2014-05-01',
      game: 'Joker',
      numbers: [4, 17, 24, 32, 37],
      joker: 5),
  JokerDraw(
      date: '2014-05-04',
      game: 'Joker',
      numbers: [15, 28, 42, 37, 25],
      joker: 12),
  JokerDraw(
      date: '2014-05-08',
      game: 'Joker',
      numbers: [34, 30, 28, 12, 38],
      joker: 11),
  JokerDraw(
      date: '2014-05-11',
      game: 'Joker',
      numbers: [1, 16, 40, 30, 26],
      joker: 3),
  JokerDraw(
      date: '2014-05-15',
      game: 'Joker',
      numbers: [43, 27, 19, 35, 10],
      joker: 9),
  JokerDraw(
      date: '2014-05-18',
      game: 'Joker',
      numbers: [26, 20, 41, 14, 27],
      joker: 16),
  JokerDraw(
      date: '2014-05-22',
      game: 'Joker',
      numbers: [19, 25, 16, 8, 21],
      joker: 3),
  JokerDraw(
      date: '2014-05-25',
      game: 'Joker',
      numbers: [38, 45, 24, 42, 1],
      joker: 10),
  JokerDraw(
      date: '2014-05-29',
      game: 'Joker',
      numbers: [22, 14, 8, 39, 3],
      joker: 14),
  JokerDraw(
      date: '2014-06-01', game: 'Joker', numbers: [4, 2, 3, 7, 30], joker: 4),
  JokerDraw(
      date: '2014-06-01',
      game: 'Joker',
      numbers: [14, 26, 32, 24, 18],
      joker: 19),
  JokerDraw(
      date: '2014-06-08',
      game: 'Joker',
      numbers: [35, 33, 36, 45, 40],
      joker: 5),
  JokerDraw(
      date: '2014-06-12',
      game: 'Joker',
      numbers: [12, 18, 5, 22, 39],
      joker: 19),
  JokerDraw(
      date: '2014-06-15',
      game: 'Joker',
      numbers: [35, 19, 20, 22, 25],
      joker: 12),
  JokerDraw(
      date: '2014-06-19',
      game: 'Joker',
      numbers: [22, 18, 29, 28, 42],
      joker: 7),
  JokerDraw(
      date: '2014-06-22',
      game: 'Joker',
      numbers: [33, 31, 7, 45, 34],
      joker: 13),
  JokerDraw(
      date: '2014-06-26',
      game: 'Joker',
      numbers: [36, 35, 11, 1, 44],
      joker: 20),
  JokerDraw(
      date: '2014-06-29',
      game: 'Joker',
      numbers: [13, 15, 30, 3, 45],
      joker: 18),
  JokerDraw(
      date: '2014-07-03',
      game: 'Joker',
      numbers: [38, 31, 42, 25, 19],
      joker: 4),
  JokerDraw(
      date: '2014-07-06',
      game: 'Joker',
      numbers: [22, 1, 4, 28, 33],
      joker: 10),
  JokerDraw(
      date: '2014-07-10',
      game: 'Joker',
      numbers: [24, 15, 2, 38, 27],
      joker: 4),
  JokerDraw(
      date: '2014-07-13', game: 'Joker', numbers: [42, 6, 7, 8, 20], joker: 10),
  JokerDraw(
      date: '2014-07-17',
      game: 'Joker',
      numbers: [16, 21, 44, 17, 24],
      joker: 19),
  JokerDraw(
      date: '2014-07-20', game: 'Joker', numbers: [8, 1, 21, 43, 37], joker: 9),
  JokerDraw(
      date: '2014-07-24',
      game: 'Joker',
      numbers: [28, 15, 23, 45, 40],
      joker: 9),
  JokerDraw(
      date: '2014-07-27',
      game: 'Joker',
      numbers: [23, 15, 24, 5, 44],
      joker: 3),
  JokerDraw(
      date: '2014-07-31',
      game: 'Joker',
      numbers: [19, 3, 45, 42, 8],
      joker: 18),
  JokerDraw(
      date: '2014-08-03',
      game: 'Joker',
      numbers: [40, 23, 34, 36, 21],
      joker: 20),
  JokerDraw(
      date: '2014-08-07',
      game: 'Joker',
      numbers: [23, 26, 4, 37, 11],
      joker: 8),
  JokerDraw(
      date: '2014-08-10',
      game: 'Joker',
      numbers: [14, 21, 10, 42, 35],
      joker: 12),
  JokerDraw(
      date: '2014-08-14',
      game: 'Joker',
      numbers: [40, 16, 36, 7, 4],
      joker: 16),
  JokerDraw(
      date: '2014-08-17',
      game: 'Joker',
      numbers: [42, 35, 44, 4, 31],
      joker: 3),
  JokerDraw(
      date: '2014-08-21',
      game: 'Joker',
      numbers: [33, 8, 14, 5, 17],
      joker: 18),
  JokerDraw(
      date: '2014-08-24',
      game: 'Joker',
      numbers: [45, 11, 44, 17, 4],
      joker: 8),
  JokerDraw(
      date: '2014-08-28',
      game: 'Joker',
      numbers: [28, 30, 7, 3, 29],
      joker: 11),
  JokerDraw(
      date: '2014-08-31',
      game: 'Joker',
      numbers: [4, 29, 22, 41, 27],
      joker: 9),
  JokerDraw(
      date: '2014-09-04',
      game: 'Joker',
      numbers: [1, 22, 11, 37, 7],
      joker: 14),
  JokerDraw(
      date: '2014-09-07',
      game: 'Joker',
      numbers: [31, 14, 8, 12, 40],
      joker: 17),
  JokerDraw(
      date: '2014-09-14', game: 'Joker', numbers: [7, 3, 13, 36, 14], joker: 3),
  JokerDraw(
      date: '2014-09-14',
      game: 'Joker',
      numbers: [38, 27, 15, 25, 43],
      joker: 6),
  JokerDraw(
      date: '2014-09-18',
      game: 'Joker',
      numbers: [34, 4, 18, 19, 44],
      joker: 15),
  JokerDraw(
      date: '2014-09-21',
      game: 'Joker',
      numbers: [34, 33, 17, 10, 4],
      joker: 2),
  JokerDraw(
      date: '2014-09-25',
      game: 'Joker',
      numbers: [12, 19, 39, 36, 38],
      joker: 13),
  JokerDraw(
      date: '2014-09-28',
      game: 'Joker',
      numbers: [15, 32, 40, 37, 23],
      joker: 14),
  JokerDraw(
      date: '2014-10-02',
      game: 'Joker',
      numbers: [8, 26, 44, 24, 7],
      joker: 18),
  JokerDraw(
      date: '2014-10-05',
      game: 'Joker',
      numbers: [5, 37, 19, 42, 7],
      joker: 18),
  JokerDraw(
      date: '2014-10-09',
      game: 'Joker',
      numbers: [1, 30, 34, 24, 26],
      joker: 13),
  JokerDraw(
      date: '2014-10-12',
      game: 'Joker',
      numbers: [37, 7, 27, 26, 1],
      joker: 14),
  JokerDraw(
      date: '2014-10-16', game: 'Joker', numbers: [1, 12, 31, 6, 24], joker: 5),
  JokerDraw(
      date: '2014-10-19',
      game: 'Joker',
      numbers: [12, 25, 44, 29, 41],
      joker: 2),
  JokerDraw(
      date: '2014-10-23',
      game: 'Joker',
      numbers: [7, 34, 29, 31, 45],
      joker: 19),
  JokerDraw(
      date: '2014-10-26',
      game: 'Joker',
      numbers: [1, 30, 43, 9, 40],
      joker: 18),
  JokerDraw(
      date: '2014-10-30',
      game: 'Joker',
      numbers: [24, 28, 2, 19, 16],
      joker: 12),
  JokerDraw(
      date: '2014-11-02',
      game: 'Joker',
      numbers: [28, 10, 40, 23, 5],
      joker: 5),
  JokerDraw(
      date: '2014-11-06',
      game: 'Joker',
      numbers: [30, 43, 7, 24, 1],
      joker: 19),
  JokerDraw(
      date: '2014-11-09',
      game: 'Joker',
      numbers: [15, 40, 25, 45, 43],
      joker: 11),
  JokerDraw(
      date: '2014-11-13',
      game: 'Joker',
      numbers: [5, 6, 28, 25, 24],
      joker: 19),
  JokerDraw(
      date: '2014-11-16',
      game: 'Joker',
      numbers: [29, 41, 21, 9, 35],
      joker: 13),
  JokerDraw(
      date: '2014-11-20',
      game: 'Joker',
      numbers: [1, 26, 20, 10, 29],
      joker: 13),
  JokerDraw(
      date: '2014-11-23',
      game: 'Joker',
      numbers: [25, 18, 14, 29, 36],
      joker: 4),
  JokerDraw(
      date: '2014-11-27', game: 'Joker', numbers: [26, 6, 7, 28, 40], joker: 9),
  JokerDraw(
      date: '2014-11-30', game: 'Joker', numbers: [2, 5, 26, 8, 24], joker: 7),
  JokerDraw(
      date: '2014-12-04', game: 'Joker', numbers: [25, 7, 21, 6, 38], joker: 4),
  JokerDraw(
      date: '2014-12-07',
      game: 'Joker',
      numbers: [9, 13, 32, 22, 28],
      joker: 7),
  JokerDraw(
      date: '2014-12-11',
      game: 'Joker',
      numbers: [41, 27, 8, 38, 12],
      joker: 17),
  JokerDraw(
      date: '2014-12-14',
      game: 'Joker',
      numbers: [11, 29, 9, 13, 6],
      joker: 14),
  JokerDraw(
      date: '2014-12-18',
      game: 'Joker',
      numbers: [18, 43, 12, 26, 39],
      joker: 20),
  JokerDraw(
      date: '2014-12-21',
      game: 'Joker',
      numbers: [23, 13, 43, 21, 45],
      joker: 1),
  JokerDraw(
      date: '2014-12-30',
      game: 'Joker',
      numbers: [32, 34, 11, 27, 8],
      joker: 14),
  JokerDraw(
      date: '2014-12-30',
      game: 'Joker',
      numbers: [43, 27, 38, 8, 15],
      joker: 10),
  JokerDraw(
      date: '2015-01-11',
      game: 'Joker',
      numbers: [44, 40, 29, 30, 2],
      joker: 12),
  JokerDraw(
      date: '2015-01-15', game: 'Joker', numbers: [5, 41, 2, 22, 39], joker: 3),
  JokerDraw(
      date: '2015-01-18', game: 'Joker', numbers: [9, 6, 17, 8, 12], joker: 2),
  JokerDraw(
      date: '2015-01-22',
      game: 'Joker',
      numbers: [1, 30, 40, 17, 29],
      joker: 3),
  JokerDraw(
      date: '2015-01-25', game: 'Joker', numbers: [1, 23, 38, 3, 30], joker: 5),
  JokerDraw(
      date: '2015-01-29', game: 'Joker', numbers: [7, 36, 31, 44, 4], joker: 4),
  JokerDraw(
      date: '2015-02-01',
      game: 'Joker',
      numbers: [27, 17, 14, 39, 42],
      joker: 5),
  JokerDraw(
      date: '2015-02-05',
      game: 'Joker',
      numbers: [6, 26, 40, 3, 10],
      joker: 19),
  JokerDraw(
      date: '2015-02-08',
      game: 'Joker',
      numbers: [1, 3, 45, 16, 21],
      joker: 12),
  JokerDraw(
      date: '2015-02-12',
      game: 'Joker',
      numbers: [11, 26, 24, 6, 17],
      joker: 7),
  JokerDraw(
      date: '2015-02-15',
      game: 'Joker',
      numbers: [43, 42, 15, 16, 4],
      joker: 20),
  JokerDraw(
      date: '2015-02-19',
      game: 'Joker',
      numbers: [24, 39, 42, 22, 5],
      joker: 12),
  JokerDraw(
      date: '2015-02-22',
      game: 'Joker',
      numbers: [40, 1, 44, 9, 29],
      joker: 16),
  JokerDraw(
      date: '2015-02-26',
      game: 'Joker',
      numbers: [30, 23, 28, 36, 17],
      joker: 13),
  JokerDraw(
      date: '2015-03-01',
      game: 'Joker',
      numbers: [8, 24, 16, 22, 38],
      joker: 5),
  JokerDraw(
      date: '2015-03-01',
      game: 'Joker',
      numbers: [20, 38, 41, 22, 32],
      joker: 11),
  JokerDraw(
      date: '2015-03-05', game: 'Joker', numbers: [1, 34, 2, 22, 39], joker: 2),
  JokerDraw(
      date: '2015-03-08',
      game: 'Joker',
      numbers: [45, 41, 21, 17, 33],
      joker: 14),
  JokerDraw(
      date: '2015-03-12',
      game: 'Joker',
      numbers: [32, 13, 30, 40, 28],
      joker: 4),
  JokerDraw(
      date: '2015-03-15',
      game: 'Joker',
      numbers: [10, 7, 20, 12, 23],
      joker: 6),
  JokerDraw(
      date: '2015-03-19',
      game: 'Joker',
      numbers: [38, 2, 15, 20, 19],
      joker: 18),
  JokerDraw(
      date: '2015-03-22',
      game: 'Joker',
      numbers: [10, 18, 34, 42, 32],
      joker: 17),
  JokerDraw(
      date: '2015-03-26',
      game: 'Joker',
      numbers: [14, 40, 19, 12, 22],
      joker: 20),
  JokerDraw(
      date: '2015-03-29',
      game: 'Joker',
      numbers: [6, 12, 14, 19, 24],
      joker: 15),
  JokerDraw(
      date: '2015-04-02',
      game: 'Joker',
      numbers: [20, 42, 6, 17, 4],
      joker: 18),
  JokerDraw(
      date: '2015-04-05',
      game: 'Joker',
      numbers: [2, 23, 25, 29, 27],
      joker: 10),
  JokerDraw(
      date: '2015-04-09',
      game: 'Joker',
      numbers: [29, 2, 17, 19, 22],
      joker: 13),
  JokerDraw(
      date: '2015-04-12',
      game: 'Joker',
      numbers: [26, 8, 44, 20, 37],
      joker: 5),
  JokerDraw(
      date: '2015-04-12',
      game: 'Joker',
      numbers: [40, 1, 38, 35, 22],
      joker: 19),
  JokerDraw(
      date: '2015-04-16',
      game: 'Joker',
      numbers: [21, 34, 6, 26, 38],
      joker: 16),
  JokerDraw(
      date: '2015-04-19',
      game: 'Joker',
      numbers: [14, 36, 38, 24, 4],
      joker: 8),
  JokerDraw(
      date: '2015-04-23',
      game: 'Joker',
      numbers: [45, 35, 39, 34, 15],
      joker: 4),
  JokerDraw(
      date: '2015-04-26',
      game: 'Joker',
      numbers: [4, 26, 24, 16, 41],
      joker: 19),
  JokerDraw(
      date: '2015-04-30',
      game: 'Joker',
      numbers: [35, 9, 25, 27, 16],
      joker: 19),
  JokerDraw(
      date: '2015-05-03',
      game: 'Joker',
      numbers: [27, 9, 32, 21, 14],
      joker: 20),
  JokerDraw(
      date: '2015-05-07',
      game: 'Joker',
      numbers: [30, 26, 20, 34, 24],
      joker: 5),
  JokerDraw(
      date: '2015-05-10', game: 'Joker', numbers: [30, 4, 29, 33, 2], joker: 2),
  JokerDraw(
      date: '2015-05-14',
      game: 'Joker',
      numbers: [6, 15, 14, 26, 23],
      joker: 19),
  JokerDraw(
      date: '2015-05-17',
      game: 'Joker',
      numbers: [16, 21, 33, 42, 19],
      joker: 2),
  JokerDraw(
      date: '2015-05-21', game: 'Joker', numbers: [31, 16, 5, 9, 3], joker: 17),
  JokerDraw(
      date: '2015-05-24',
      game: 'Joker',
      numbers: [5, 16, 45, 44, 41],
      joker: 9),
  JokerDraw(
      date: '2015-05-28',
      game: 'Joker',
      numbers: [16, 36, 11, 29, 28],
      joker: 13),
  JokerDraw(
      date: '2015-05-31',
      game: 'Joker',
      numbers: [10, 29, 36, 14, 31],
      joker: 18),
  JokerDraw(
      date: '2015-06-04', game: 'Joker', numbers: [1, 23, 3, 9, 25], joker: 11),
  JokerDraw(
      date: '2015-06-07', game: 'Joker', numbers: [28, 31, 26, 3, 6], joker: 1),
  JokerDraw(
      date: '2015-06-11',
      game: 'Joker',
      numbers: [10, 9, 39, 19, 4],
      joker: 19),
  JokerDraw(
      date: '2015-06-14', game: 'Joker', numbers: [20, 1, 5, 11, 18], joker: 4),
  JokerDraw(
      date: '2015-06-18',
      game: 'Joker',
      numbers: [31, 16, 28, 44, 39],
      joker: 15),
  JokerDraw(
      date: '2015-06-21', game: 'Joker', numbers: [37, 17, 8, 39, 4], joker: 1),
  JokerDraw(
      date: '2015-06-25',
      game: 'Joker',
      numbers: [43, 38, 3, 26, 2],
      joker: 17),
  JokerDraw(
      date: '2015-06-28',
      game: 'Joker',
      numbers: [28, 22, 12, 17, 33],
      joker: 10),
  JokerDraw(
      date: '2015-07-02', game: 'Joker', numbers: [8, 18, 40, 14, 4], joker: 8),
  JokerDraw(
      date: '2015-07-05',
      game: 'Joker',
      numbers: [17, 29, 32, 18, 4],
      joker: 1),
  JokerDraw(
      date: '2015-07-09', game: 'Joker', numbers: [28, 8, 6, 2, 12], joker: 16),
  JokerDraw(
      date: '2015-07-12',
      game: 'Joker',
      numbers: [5, 28, 39, 41, 22],
      joker: 2),
  JokerDraw(
      date: '2015-07-16',
      game: 'Joker',
      numbers: [27, 29, 10, 32, 3],
      joker: 7),
  JokerDraw(
      date: '2015-07-19',
      game: 'Joker',
      numbers: [16, 38, 12, 22, 3],
      joker: 3),
  JokerDraw(
      date: '2015-07-23',
      game: 'Joker',
      numbers: [3, 40, 37, 20, 16],
      joker: 1),
  JokerDraw(
      date: '2015-07-26',
      game: 'Joker',
      numbers: [22, 17, 5, 2, 36],
      joker: 14),
  JokerDraw(
      date: '2015-07-30',
      game: 'Joker',
      numbers: [21, 23, 26, 16, 41],
      joker: 9),
  JokerDraw(
      date: '2015-08-02',
      game: 'Joker',
      numbers: [41, 10, 29, 31, 6],
      joker: 20),
  JokerDraw(
      date: '2015-08-06',
      game: 'Joker',
      numbers: [21, 34, 30, 5, 45],
      joker: 17),
  JokerDraw(
      date: '2015-08-09',
      game: 'Joker',
      numbers: [14, 24, 45, 43, 11],
      joker: 9),
  JokerDraw(
      date: '2015-08-13',
      game: 'Joker',
      numbers: [6, 24, 42, 7, 38],
      joker: 20),
  JokerDraw(
      date: '2015-08-16', game: 'Joker', numbers: [44, 8, 24, 16, 7], joker: 7),
  JokerDraw(
      date: '2015-08-20', game: 'Joker', numbers: [18, 14, 43, 2, 5], joker: 7),
  JokerDraw(
      date: '2015-08-23',
      game: 'Joker',
      numbers: [21, 4, 10, 3, 25],
      joker: 14),
  JokerDraw(
      date: '2015-08-27',
      game: 'Joker',
      numbers: [20, 41, 37, 27, 30],
      joker: 18),
  JokerDraw(
      date: '2015-08-30',
      game: 'Joker',
      numbers: [42, 25, 1, 24, 39],
      joker: 19),
  JokerDraw(
      date: '2015-09-03',
      game: 'Joker',
      numbers: [18, 7, 43, 45, 22],
      joker: 7),
  JokerDraw(
      date: '2015-09-06', game: 'Joker', numbers: [15, 1, 38, 17, 8], joker: 3),
  JokerDraw(
      date: '2015-09-13',
      game: 'Joker',
      numbers: [43, 18, 16, 23, 6],
      joker: 16),
  JokerDraw(
      date: '2015-09-13',
      game: 'Joker',
      numbers: [33, 3, 6, 24, 45],
      joker: 14),
  JokerDraw(
      date: '2015-09-17',
      game: 'Joker',
      numbers: [30, 27, 3, 36, 33],
      joker: 6),
  JokerDraw(
      date: '2015-09-20',
      game: 'Joker',
      numbers: [10, 28, 30, 11, 7],
      joker: 16),
  JokerDraw(
      date: '2015-09-24',
      game: 'Joker',
      numbers: [29, 28, 45, 41, 20],
      joker: 15),
  JokerDraw(
      date: '2015-09-27',
      game: 'Joker',
      numbers: [27, 26, 20, 35, 34],
      joker: 7),
  JokerDraw(
      date: '2015-10-01',
      game: 'Joker',
      numbers: [30, 2, 43, 12, 17],
      joker: 13),
  JokerDraw(
      date: '2015-10-04',
      game: 'Joker',
      numbers: [9, 25, 29, 38, 16],
      joker: 9),
  JokerDraw(
      date: '2015-10-08',
      game: 'Joker',
      numbers: [12, 44, 39, 22, 35],
      joker: 8),
  JokerDraw(
      date: '2015-10-11',
      game: 'Joker',
      numbers: [26, 44, 39, 12, 8],
      joker: 12),
  JokerDraw(
      date: '2015-10-15',
      game: 'Joker',
      numbers: [45, 6, 13, 30, 12],
      joker: 6),
  JokerDraw(
      date: '2015-10-18',
      game: 'Joker',
      numbers: [13, 10, 15, 6, 31],
      joker: 5),
  JokerDraw(
      date: '2015-10-22',
      game: 'Joker',
      numbers: [39, 41, 25, 27, 37],
      joker: 16),
  JokerDraw(
      date: '2015-10-25',
      game: 'Joker',
      numbers: [20, 21, 44, 17, 45],
      joker: 15),
  JokerDraw(
      date: '2015-10-29',
      game: 'Joker',
      numbers: [34, 40, 38, 8, 20],
      joker: 14),
  JokerDraw(
      date: '2015-11-01',
      game: 'Joker',
      numbers: [17, 14, 45, 16, 20],
      joker: 9),
  JokerDraw(
      date: '2015-11-05',
      game: 'Joker',
      numbers: [28, 18, 37, 44, 3],
      joker: 4),
  JokerDraw(
      date: '2015-11-08',
      game: 'Joker',
      numbers: [38, 24, 17, 15, 36],
      joker: 1),
  JokerDraw(
      date: '2015-11-12',
      game: 'Joker',
      numbers: [17, 1, 21, 15, 42],
      joker: 16),
  JokerDraw(
      date: '2015-11-15',
      game: 'Joker',
      numbers: [5, 14, 32, 34, 21],
      joker: 7),
  JokerDraw(
      date: '2015-11-19',
      game: 'Joker',
      numbers: [22, 7, 38, 13, 1],
      joker: 20),
  JokerDraw(
      date: '2015-11-22',
      game: 'Joker',
      numbers: [15, 12, 11, 10, 1],
      joker: 14),
  JokerDraw(
      date: '2015-11-26', game: 'Joker', numbers: [23, 1, 30, 34, 6], joker: 6),
  JokerDraw(
      date: '2015-11-29',
      game: 'Joker',
      numbers: [10, 7, 33, 16, 9],
      joker: 18),
  JokerDraw(
      date: '2015-12-03',
      game: 'Joker',
      numbers: [36, 10, 37, 24, 15],
      joker: 6),
  JokerDraw(
      date: '2015-12-06',
      game: 'Joker',
      numbers: [4, 18, 16, 29, 31],
      joker: 14),
  JokerDraw(
      date: '2015-12-10', game: 'Joker', numbers: [23, 41, 9, 1, 22], joker: 8),
  JokerDraw(
      date: '2015-12-13',
      game: 'Joker',
      numbers: [34, 35, 6, 44, 22],
      joker: 7),
  JokerDraw(
      date: '2015-12-17', game: 'Joker', numbers: [3, 17, 15, 10, 9], joker: 7),
  JokerDraw(
      date: '2015-12-20',
      game: 'Joker',
      numbers: [17, 45, 36, 16, 33],
      joker: 11),
  JokerDraw(
      date: '2015-12-30', game: 'Joker', numbers: [4, 3, 40, 1, 2], joker: 13),
  JokerDraw(
      date: '2015-12-30',
      game: 'Joker',
      numbers: [5, 18, 16, 2, 24],
      joker: 13),
  JokerDraw(
      date: '2016-01-07',
      game: 'Joker',
      numbers: [33, 17, 20, 22, 4],
      joker: 16),
  JokerDraw(
      date: '2016-01-10',
      game: 'Joker',
      numbers: [35, 41, 28, 37, 25],
      joker: 2),
  JokerDraw(
      date: '2016-01-14',
      game: 'Joker',
      numbers: [33, 3, 28, 41, 32],
      joker: 3),
  JokerDraw(
      date: '2016-01-17',
      game: 'Joker',
      numbers: [20, 26, 5, 38, 18],
      joker: 16),
  JokerDraw(
      date: '2016-01-21', game: 'Joker', numbers: [27, 2, 4, 10, 11], joker: 9),
  JokerDraw(
      date: '2016-01-24',
      game: 'Joker',
      numbers: [24, 44, 32, 8, 27],
      joker: 20),
  JokerDraw(
      date: '2016-01-28',
      game: 'Joker',
      numbers: [5, 42, 36, 8, 11],
      joker: 11),
  JokerDraw(
      date: '2016-01-31',
      game: 'Joker',
      numbers: [23, 18, 24, 20, 13],
      joker: 7),
  JokerDraw(
      date: '2016-02-04',
      game: 'Joker',
      numbers: [26, 23, 44, 9, 40],
      joker: 1),
  JokerDraw(
      date: '2016-02-07', game: 'Joker', numbers: [18, 11, 12, 4, 8], joker: 5),
  JokerDraw(
      date: '2016-02-11',
      game: 'Joker',
      numbers: [2, 33, 40, 17, 38],
      joker: 9),
  JokerDraw(
      date: '2016-02-14',
      game: 'Joker',
      numbers: [35, 34, 43, 20, 24],
      joker: 20),
  JokerDraw(
      date: '2016-02-18',
      game: 'Joker',
      numbers: [19, 41, 25, 34, 24],
      joker: 20),
  JokerDraw(
      date: '2016-02-21',
      game: 'Joker',
      numbers: [11, 39, 1, 42, 24],
      joker: 17),
  JokerDraw(
      date: '2016-02-25',
      game: 'Joker',
      numbers: [45, 5, 8, 41, 14],
      joker: 15),
  JokerDraw(
      date: '2016-02-28',
      game: 'Joker',
      numbers: [20, 30, 27, 17, 16],
      joker: 11),
  JokerDraw(
      date: '2016-03-03', game: 'Joker', numbers: [33, 8, 14, 10, 3], joker: 2),
  JokerDraw(
      date: '2016-03-06',
      game: 'Joker',
      numbers: [26, 27, 17, 37, 33],
      joker: 5),
  JokerDraw(
      date: '2016-03-06',
      game: 'Joker',
      numbers: [22, 26, 35, 8, 19],
      joker: 18),
  JokerDraw(
      date: '2016-03-10',
      game: 'Joker',
      numbers: [39, 44, 19, 6, 36],
      joker: 17),
  JokerDraw(
      date: '2016-03-13',
      game: 'Joker',
      numbers: [7, 29, 42, 20, 17],
      joker: 7),
  JokerDraw(
      date: '2016-03-17',
      game: 'Joker',
      numbers: [40, 7, 1, 38, 39],
      joker: 20),
  JokerDraw(
      date: '2016-03-20',
      game: 'Joker',
      numbers: [31, 23, 33, 42, 44],
      joker: 16),
  JokerDraw(
      date: '2016-03-24', game: 'Joker', numbers: [2, 9, 32, 40, 27], joker: 2),
  JokerDraw(
      date: '2016-03-27',
      game: 'Joker',
      numbers: [28, 30, 9, 32, 42],
      joker: 18),
  JokerDraw(
      date: '2016-03-31',
      game: 'Joker',
      numbers: [32, 45, 33, 27, 8],
      joker: 1),
  JokerDraw(
      date: '2016-04-03',
      game: 'Joker',
      numbers: [19, 29, 3, 17, 37],
      joker: 4),
  JokerDraw(
      date: '2016-04-07',
      game: 'Joker',
      numbers: [21, 27, 18, 33, 45],
      joker: 1),
  JokerDraw(
      date: '2016-04-10',
      game: 'Joker',
      numbers: [24, 25, 3, 40, 39],
      joker: 16),
  JokerDraw(
      date: '2016-04-14',
      game: 'Joker',
      numbers: [28, 35, 36, 6, 24],
      joker: 20),
  JokerDraw(
      date: '2016-04-17',
      game: 'Joker',
      numbers: [14, 43, 20, 30, 24],
      joker: 3),
  JokerDraw(
      date: '2016-04-21',
      game: 'Joker',
      numbers: [10, 19, 26, 23, 39],
      joker: 15),
  JokerDraw(
      date: '2016-04-24',
      game: 'Joker',
      numbers: [28, 20, 23, 3, 24],
      joker: 11),
  JokerDraw(
      date: '2016-05-01',
      game: 'Joker',
      numbers: [42, 17, 11, 20, 16],
      joker: 2),
  JokerDraw(
      date: '2016-05-01',
      game: 'Joker',
      numbers: [44, 24, 15, 41, 5],
      joker: 2),
  JokerDraw(
      date: '2016-05-05',
      game: 'Joker',
      numbers: [18, 12, 11, 16, 39],
      joker: 11),
  JokerDraw(
      date: '2016-05-08',
      game: 'Joker',
      numbers: [11, 41, 37, 34, 7],
      joker: 6),
  JokerDraw(
      date: '2016-05-12', game: 'Joker', numbers: [40, 7, 8, 43, 34], joker: 3),
  JokerDraw(
      date: '2016-05-15',
      game: 'Joker',
      numbers: [35, 37, 13, 41, 31],
      joker: 1),
  JokerDraw(
      date: '2016-05-19',
      game: 'Joker',
      numbers: [34, 29, 21, 42, 19],
      joker: 9),
  JokerDraw(
      date: '2016-05-22',
      game: 'Joker',
      numbers: [38, 34, 37, 35, 17],
      joker: 11),
  JokerDraw(
      date: '2016-05-26',
      game: 'Joker',
      numbers: [19, 23, 37, 43, 38],
      joker: 2),
  JokerDraw(
      date: '2016-05-29',
      game: 'Joker',
      numbers: [36, 11, 6, 18, 10],
      joker: 7),
  JokerDraw(
      date: '2016-06-02',
      game: 'Joker',
      numbers: [40, 38, 30, 31, 23],
      joker: 18),
  JokerDraw(
      date: '2016-06-05',
      game: 'Joker',
      numbers: [3, 28, 36, 23, 45],
      joker: 5),
  JokerDraw(
      date: '2016-06-09',
      game: 'Joker',
      numbers: [3, 11, 10, 31, 35],
      joker: 4),
  JokerDraw(
      date: '2016-06-12', game: 'Joker', numbers: [6, 45, 3, 21, 40], joker: 2),
  JokerDraw(
      date: '2016-06-16',
      game: 'Joker',
      numbers: [21, 3, 37, 39, 7],
      joker: 11),
  JokerDraw(
      date: '2016-06-19',
      game: 'Joker',
      numbers: [10, 2, 41, 16, 19],
      joker: 9),
  JokerDraw(
      date: '2016-06-23',
      game: 'Joker',
      numbers: [12, 45, 30, 6, 2],
      joker: 11),
  JokerDraw(
      date: '2016-06-26',
      game: 'Joker',
      numbers: [11, 40, 7, 20, 17],
      joker: 10),
  JokerDraw(
      date: '2016-06-30',
      game: 'Joker',
      numbers: [25, 40, 31, 39, 32],
      joker: 14),
  JokerDraw(
      date: '2016-07-03',
      game: 'Joker',
      numbers: [4, 41, 43, 17, 29],
      joker: 14),
  JokerDraw(
      date: '2016-07-07',
      game: 'Joker',
      numbers: [23, 1, 31, 36, 12],
      joker: 18),
  JokerDraw(
      date: '2016-07-10',
      game: 'Joker',
      numbers: [7, 38, 36, 31, 6],
      joker: 12),
  JokerDraw(
      date: '2016-07-14',
      game: 'Joker',
      numbers: [19, 11, 20, 34, 27],
      joker: 9),
  JokerDraw(
      date: '2016-07-17',
      game: 'Joker',
      numbers: [42, 14, 28, 22, 36],
      joker: 9),
  JokerDraw(
      date: '2016-07-21',
      game: 'Joker',
      numbers: [24, 16, 10, 39, 1],
      joker: 12),
  JokerDraw(
      date: '2016-07-24',
      game: 'Joker',
      numbers: [12, 33, 32, 45, 4],
      joker: 19),
  JokerDraw(
      date: '2016-07-28',
      game: 'Joker',
      numbers: [8, 35, 11, 17, 42],
      joker: 16),
  JokerDraw(
      date: '2016-07-31', game: 'Joker', numbers: [8, 45, 2, 42, 5], joker: 16),
  JokerDraw(
      date: '2016-08-04',
      game: 'Joker',
      numbers: [20, 19, 29, 17, 32],
      joker: 14),
  JokerDraw(
      date: '2016-08-07',
      game: 'Joker',
      numbers: [24, 41, 33, 15, 16],
      joker: 5),
  JokerDraw(
      date: '2016-08-11',
      game: 'Joker',
      numbers: [21, 32, 36, 13, 15],
      joker: 2),
  JokerDraw(
      date: '2016-08-14',
      game: 'Joker',
      numbers: [35, 21, 19, 11, 34],
      joker: 9),
  JokerDraw(
      date: '2016-08-18',
      game: 'Joker',
      numbers: [42, 32, 27, 31, 2],
      joker: 18),
  JokerDraw(
      date: '2016-08-21', game: 'Joker', numbers: [3, 20, 32, 8, 4], joker: 6),
  JokerDraw(
      date: '2016-08-25',
      game: 'Joker',
      numbers: [16, 32, 25, 28, 38],
      joker: 20),
  JokerDraw(
      date: '2016-08-28',
      game: 'Joker',
      numbers: [23, 27, 20, 6, 16],
      joker: 3),
  JokerDraw(
      date: '2016-09-01',
      game: 'Joker',
      numbers: [37, 3, 41, 24, 35],
      joker: 11),
  JokerDraw(
      date: '2016-09-04',
      game: 'Joker',
      numbers: [23, 4, 32, 18, 24],
      joker: 16),
  JokerDraw(
      date: '2016-09-08',
      game: 'Joker',
      numbers: [12, 34, 16, 1, 41],
      joker: 10),
  JokerDraw(
      date: '2016-09-11',
      game: 'Joker',
      numbers: [43, 34, 31, 24, 2],
      joker: 2),
  JokerDraw(
      date: '2016-09-15',
      game: 'Joker',
      numbers: [5, 33, 42, 45, 17],
      joker: 7),
  JokerDraw(
      date: '2016-09-18',
      game: 'Joker',
      numbers: [40, 24, 22, 23, 20],
      joker: 11),
  JokerDraw(
      date: '2016-09-18',
      game: 'Joker',
      numbers: [26, 42, 10, 32, 6],
      joker: 5),
  JokerDraw(
      date: '2016-09-22',
      game: 'Joker',
      numbers: [25, 12, 39, 16, 13],
      joker: 6),
  JokerDraw(
      date: '2016-09-25',
      game: 'Joker',
      numbers: [18, 34, 5, 33, 28],
      joker: 9),
  JokerDraw(
      date: '2016-09-29',
      game: 'Joker',
      numbers: [24, 31, 3, 13, 10],
      joker: 5),
  JokerDraw(
      date: '2016-10-02', game: 'Joker', numbers: [26, 32, 6, 8, 24], joker: 6),
  JokerDraw(
      date: '2016-10-06',
      game: 'Joker',
      numbers: [16, 45, 39, 1, 22],
      joker: 5),
  JokerDraw(
      date: '2016-10-09',
      game: 'Joker',
      numbers: [19, 32, 18, 13, 15],
      joker: 8),
  JokerDraw(
      date: '2016-10-13', game: 'Joker', numbers: [38, 16, 2, 1, 43], joker: 1),
  JokerDraw(
      date: '2016-10-16',
      game: 'Joker',
      numbers: [23, 29, 16, 4, 20],
      joker: 3),
  JokerDraw(
      date: '2016-10-20',
      game: 'Joker',
      numbers: [22, 23, 39, 18, 34],
      joker: 4),
  JokerDraw(
      date: '2016-10-23',
      game: 'Joker',
      numbers: [22, 40, 32, 42, 15],
      joker: 17),
  JokerDraw(
      date: '2016-10-27',
      game: 'Joker',
      numbers: [30, 39, 24, 20, 9],
      joker: 14),
  JokerDraw(
      date: '2016-10-30',
      game: 'Joker',
      numbers: [14, 23, 2, 6, 35],
      joker: 17),
  JokerDraw(
      date: '2016-11-03',
      game: 'Joker',
      numbers: [5, 2, 32, 31, 43],
      joker: 10),
  JokerDraw(
      date: '2016-11-06',
      game: 'Joker',
      numbers: [32, 25, 8, 45, 24],
      joker: 10),
  JokerDraw(
      date: '2016-11-10', game: 'Joker', numbers: [7, 11, 43, 9, 35], joker: 2),
  JokerDraw(
      date: '2016-11-13',
      game: 'Joker',
      numbers: [31, 39, 27, 37, 32],
      joker: 11),
  JokerDraw(
      date: '2016-11-17',
      game: 'Joker',
      numbers: [10, 29, 7, 11, 8],
      joker: 12),
  JokerDraw(
      date: '2016-11-20',
      game: 'Joker',
      numbers: [41, 22, 21, 18, 37],
      joker: 10),
  JokerDraw(
      date: '2016-11-24', game: 'Joker', numbers: [39, 5, 17, 2, 25], joker: 1),
  JokerDraw(
      date: '2016-11-27',
      game: 'Joker',
      numbers: [14, 10, 45, 18, 3],
      joker: 1),
  JokerDraw(
      date: '2016-12-04',
      game: 'Joker',
      numbers: [41, 29, 21, 22, 45],
      joker: 3),
  JokerDraw(
      date: '2016-12-08',
      game: 'Joker',
      numbers: [41, 32, 26, 4, 23],
      joker: 17),
  JokerDraw(
      date: '2016-12-11', game: 'Joker', numbers: [15, 6, 9, 5, 3], joker: 1),
  JokerDraw(
      date: '2016-12-15',
      game: 'Joker',
      numbers: [15, 37, 24, 17, 9],
      joker: 15),
  JokerDraw(
      date: '2016-12-18',
      game: 'Joker',
      numbers: [1, 2, 12, 41, 31],
      joker: 17),
  JokerDraw(
      date: '2016-12-22',
      game: 'Joker',
      numbers: [27, 1, 3, 38, 31],
      joker: 18),
  JokerDraw(
      date: '2016-12-31',
      game: 'Joker',
      numbers: [17, 34, 31, 36, 24],
      joker: 7),
  JokerDraw(
      date: '2016-12-31',
      game: 'Joker',
      numbers: [45, 23, 32, 11, 25],
      joker: 1),
  JokerDraw(
      date: '2017-01-05',
      game: 'Joker',
      numbers: [7, 38, 12, 31, 42],
      joker: 10),
  JokerDraw(
      date: '2017-01-08',
      game: 'Joker',
      numbers: [23, 21, 10, 34, 27],
      joker: 4),
  JokerDraw(
      date: '2017-01-12', game: 'Joker', numbers: [7, 22, 5, 6, 44], joker: 13),
  JokerDraw(
      date: '2017-01-15',
      game: 'Joker',
      numbers: [11, 40, 36, 41, 5],
      joker: 19),
  JokerDraw(
      date: '2017-01-19',
      game: 'Joker',
      numbers: [41, 43, 44, 2, 15],
      joker: 20),
  JokerDraw(
      date: '2017-01-22',
      game: 'Joker',
      numbers: [22, 29, 37, 31, 5],
      joker: 8),
  JokerDraw(
      date: '2017-01-26',
      game: 'Joker',
      numbers: [21, 7, 28, 34, 23],
      joker: 15),
  JokerDraw(
      date: '2017-01-29',
      game: 'Joker',
      numbers: [44, 10, 11, 8, 17],
      joker: 17),
  JokerDraw(
      date: '2017-02-02',
      game: 'Joker',
      numbers: [20, 31, 16, 38, 15],
      joker: 14),
  JokerDraw(
      date: '2017-02-05',
      game: 'Joker',
      numbers: [37, 14, 7, 32, 41],
      joker: 17),
  JokerDraw(
      date: '2017-02-09',
      game: 'Joker',
      numbers: [12, 21, 9, 10, 33],
      joker: 5),
  JokerDraw(
      date: '2017-02-12',
      game: 'Joker',
      numbers: [17, 10, 32, 18, 20],
      joker: 14),
  JokerDraw(
      date: '2017-02-16',
      game: 'Joker',
      numbers: [41, 10, 27, 37, 20],
      joker: 18),
  JokerDraw(
      date: '2017-02-19', game: 'Joker', numbers: [9, 12, 6, 16, 3], joker: 6),
  JokerDraw(
      date: '2017-02-23',
      game: 'Joker',
      numbers: [23, 10, 4, 39, 13],
      joker: 8),
  JokerDraw(
      date: '2017-02-26',
      game: 'Joker',
      numbers: [23, 45, 20, 21, 26],
      joker: 12),
  JokerDraw(
      date: '2017-03-02',
      game: 'Joker',
      numbers: [27, 30, 9, 31, 16],
      joker: 6),
  JokerDraw(
      date: '2017-03-05',
      game: 'Joker',
      numbers: [30, 26, 17, 15, 34],
      joker: 6),
  JokerDraw(
      date: '2017-03-05',
      game: 'Joker',
      numbers: [33, 4, 36, 22, 17],
      joker: 2),
  JokerDraw(
      date: '2017-03-09',
      game: 'Joker',
      numbers: [45, 30, 33, 3, 5],
      joker: 20),
  JokerDraw(
      date: '2017-03-12',
      game: 'Joker',
      numbers: [28, 4, 10, 16, 23],
      joker: 17),
  JokerDraw(
      date: '2017-03-16',
      game: 'Joker',
      numbers: [42, 34, 37, 16, 39],
      joker: 4),
  JokerDraw(
      date: '2017-03-19',
      game: 'Joker',
      numbers: [3, 21, 37, 13, 19],
      joker: 16),
  JokerDraw(
      date: '2017-03-23',
      game: 'Joker',
      numbers: [21, 6, 4, 35, 30],
      joker: 11),
  JokerDraw(
      date: '2017-03-26',
      game: 'Joker',
      numbers: [3, 38, 27, 9, 24],
      joker: 14),
  JokerDraw(
      date: '2017-03-30',
      game: 'Joker',
      numbers: [40, 28, 24, 42, 39],
      joker: 8),
  JokerDraw(
      date: '2017-04-02',
      game: 'Joker',
      numbers: [41, 31, 15, 28, 18],
      joker: 19),
  JokerDraw(
      date: '2017-04-06',
      game: 'Joker',
      numbers: [20, 28, 25, 21, 43],
      joker: 5),
  JokerDraw(
      date: '2017-04-09',
      game: 'Joker',
      numbers: [23, 17, 16, 37, 28],
      joker: 10),
  JokerDraw(
      date: '2017-04-16',
      game: 'Joker',
      numbers: [12, 31, 15, 22, 41],
      joker: 7),
  JokerDraw(
      date: '2017-04-16', game: 'Joker', numbers: [10, 9, 2, 33, 31], joker: 1),
  JokerDraw(
      date: '2017-04-20',
      game: 'Joker',
      numbers: [10, 40, 19, 20, 34],
      joker: 11),
  JokerDraw(
      date: '2017-04-23',
      game: 'Joker',
      numbers: [8, 15, 12, 25, 30],
      joker: 8),
  JokerDraw(
      date: '2017-04-27', game: 'Joker', numbers: [3, 5, 38, 1, 10], joker: 13),
  JokerDraw(
      date: '2017-04-30',
      game: 'Joker',
      numbers: [28, 31, 26, 40, 4],
      joker: 5),
  JokerDraw(
      date: '2017-05-04',
      game: 'Joker',
      numbers: [7, 20, 39, 33, 18],
      joker: 19),
  JokerDraw(
      date: '2017-05-07',
      game: 'Joker',
      numbers: [38, 33, 15, 41, 23],
      joker: 6),
  JokerDraw(
      date: '2017-05-11',
      game: 'Joker',
      numbers: [22, 21, 14, 12, 3],
      joker: 13),
  JokerDraw(
      date: '2017-05-14',
      game: 'Joker',
      numbers: [5, 37, 15, 10, 16],
      joker: 4),
  JokerDraw(
      date: '2017-05-18',
      game: 'Joker',
      numbers: [13, 19, 21, 3, 17],
      joker: 5),
  JokerDraw(
      date: '2017-05-21',
      game: 'Joker',
      numbers: [12, 18, 39, 42, 19],
      joker: 6),
  JokerDraw(
      date: '2017-05-25',
      game: 'Joker',
      numbers: [38, 20, 2, 26, 16],
      joker: 2),
  JokerDraw(
      date: '2017-05-28',
      game: 'Joker',
      numbers: [40, 14, 27, 28, 34],
      joker: 17),
  JokerDraw(
      date: '2017-06-01',
      game: 'Joker',
      numbers: [45, 31, 16, 26, 20],
      joker: 14),
  JokerDraw(
      date: '2017-06-04', game: 'Joker', numbers: [45, 31, 6, 5, 15], joker: 8),
  JokerDraw(
      date: '2017-06-08',
      game: 'Joker',
      numbers: [44, 34, 3, 18, 26],
      joker: 8),
  JokerDraw(
      date: '2017-06-11',
      game: 'Joker',
      numbers: [36, 33, 30, 44, 26],
      joker: 1),
  JokerDraw(
      date: '2017-06-15', game: 'Joker', numbers: [38, 5, 2, 45, 35], joker: 3),
  JokerDraw(
      date: '2017-06-18',
      game: 'Joker',
      numbers: [38, 25, 40, 1, 37],
      joker: 11),
  JokerDraw(
      date: '2017-06-22',
      game: 'Joker',
      numbers: [26, 40, 12, 3, 19],
      joker: 14),
  JokerDraw(
      date: '2017-06-25',
      game: 'Joker',
      numbers: [20, 2, 31, 22, 40],
      joker: 19),
  JokerDraw(
      date: '2017-06-29',
      game: 'Joker',
      numbers: [27, 35, 21, 7, 14],
      joker: 15),
  JokerDraw(
      date: '2017-07-02', game: 'Joker', numbers: [2, 45, 9, 13, 15], joker: 7),
  JokerDraw(
      date: '2017-07-06',
      game: 'Joker',
      numbers: [8, 30, 15, 11, 14],
      joker: 8),
  JokerDraw(
      date: '2017-07-09',
      game: 'Joker',
      numbers: [37, 20, 42, 7, 26],
      joker: 10),
  JokerDraw(
      date: '2017-07-13',
      game: 'Joker',
      numbers: [15, 42, 16, 4, 7],
      joker: 13),
  JokerDraw(
      date: '2017-07-16',
      game: 'Joker',
      numbers: [45, 34, 21, 35, 10],
      joker: 2),
  JokerDraw(
      date: '2017-07-20',
      game: 'Joker',
      numbers: [15, 27, 21, 6, 14],
      joker: 8),
  JokerDraw(
      date: '2017-07-23',
      game: 'Joker',
      numbers: [6, 39, 37, 16, 20],
      joker: 16),
  JokerDraw(
      date: '2017-07-27',
      game: 'Joker',
      numbers: [13, 39, 34, 30, 5],
      joker: 18),
  JokerDraw(
      date: '2017-07-30',
      game: 'Joker',
      numbers: [4, 15, 19, 33, 38],
      joker: 16),
  JokerDraw(
      date: '2017-08-03',
      game: 'Joker',
      numbers: [41, 32, 22, 26, 39],
      joker: 18),
  JokerDraw(
      date: '2017-08-06',
      game: 'Joker',
      numbers: [21, 32, 4, 40, 23],
      joker: 9),
  JokerDraw(
      date: '2017-08-06',
      game: 'Joker',
      numbers: [38, 42, 43, 8, 19],
      joker: 13),
  JokerDraw(
      date: '2017-08-10',
      game: 'Joker',
      numbers: [33, 19, 13, 39, 34],
      joker: 11),
  JokerDraw(
      date: '2017-08-13',
      game: 'Joker',
      numbers: [14, 19, 40, 31, 6],
      joker: 10),
  JokerDraw(
      date: '2017-08-17',
      game: 'Joker',
      numbers: [15, 45, 8, 17, 14],
      joker: 18),
  JokerDraw(
      date: '2017-08-20',
      game: 'Joker',
      numbers: [23, 14, 38, 40, 44],
      joker: 18),
  JokerDraw(
      date: '2017-08-24',
      game: 'Joker',
      numbers: [11, 14, 43, 4, 7],
      joker: 19),
  JokerDraw(
      date: '2017-08-27',
      game: 'Joker',
      numbers: [15, 39, 24, 29, 18],
      joker: 5),
  JokerDraw(
      date: '2017-08-31',
      game: 'Joker',
      numbers: [35, 8, 36, 6, 16],
      joker: 12),
  JokerDraw(
      date: '2017-09-03',
      game: 'Joker',
      numbers: [36, 20, 12, 31, 45],
      joker: 5),
  JokerDraw(
      date: '2017-09-07',
      game: 'Joker',
      numbers: [20, 12, 40, 31, 10],
      joker: 18),
  JokerDraw(
      date: '2017-09-10',
      game: 'Joker',
      numbers: [16, 31, 10, 22, 40],
      joker: 9),
  JokerDraw(
      date: '2017-09-17',
      game: 'Joker',
      numbers: [20, 39, 40, 29, 36],
      joker: 16),
  JokerDraw(
      date: '2017-09-17',
      game: 'Joker',
      numbers: [27, 20, 35, 5, 13],
      joker: 17),
  JokerDraw(
      date: '2017-09-21',
      game: 'Joker',
      numbers: [19, 21, 27, 14, 18],
      joker: 4),
  JokerDraw(
      date: '2017-09-24',
      game: 'Joker',
      numbers: [4, 35, 24, 41, 25],
      joker: 5),
  JokerDraw(
      date: '2017-09-28', game: 'Joker', numbers: [17, 1, 4, 8, 44], joker: 19),
  JokerDraw(
      date: '2017-10-01',
      game: 'Joker',
      numbers: [32, 30, 33, 28, 21],
      joker: 13),
  JokerDraw(
      date: '2017-10-05',
      game: 'Joker',
      numbers: [2, 12, 31, 10, 29],
      joker: 6),
  JokerDraw(
      date: '2017-10-08', game: 'Joker', numbers: [40, 3, 5, 4, 29], joker: 8),
  JokerDraw(
      date: '2017-10-12',
      game: 'Joker',
      numbers: [32, 43, 42, 3, 37],
      joker: 8),
  JokerDraw(
      date: '2017-10-15',
      game: 'Joker',
      numbers: [32, 21, 22, 24, 42],
      joker: 2),
  JokerDraw(
      date: '2017-10-19',
      game: 'Joker',
      numbers: [16, 19, 3, 25, 6],
      joker: 12),
  JokerDraw(
      date: '2017-10-22',
      game: 'Joker',
      numbers: [42, 19, 11, 32, 4],
      joker: 8),
  JokerDraw(
      date: '2017-10-26',
      game: 'Joker',
      numbers: [21, 43, 37, 1, 36],
      joker: 9),
  JokerDraw(
      date: '2017-10-29',
      game: 'Joker',
      numbers: [21, 41, 27, 42, 20],
      joker: 10),
  JokerDraw(
      date: '2017-11-02',
      game: 'Joker',
      numbers: [6, 38, 23, 20, 10],
      joker: 9),
  JokerDraw(
      date: '2017-11-05',
      game: 'Joker',
      numbers: [29, 19, 3, 5, 10],
      joker: 14),
  JokerDraw(
      date: '2017-11-09', game: 'Joker', numbers: [29, 8, 15, 20, 1], joker: 7),
  JokerDraw(
      date: '2017-11-12',
      game: 'Joker',
      numbers: [21, 29, 7, 40, 2],
      joker: 10),
  JokerDraw(
      date: '2017-11-16',
      game: 'Joker',
      numbers: [22, 9, 45, 10, 20],
      joker: 15),
  JokerDraw(
      date: '2017-11-19',
      game: 'Joker',
      numbers: [16, 17, 33, 11, 22],
      joker: 6),
  JokerDraw(
      date: '2017-11-23',
      game: 'Joker',
      numbers: [43, 41, 17, 18, 29],
      joker: 1),
  JokerDraw(
      date: '2017-11-26', game: 'Joker', numbers: [12, 6, 33, 7, 35], joker: 5),
  JokerDraw(
      date: '2017-11-30',
      game: 'Joker',
      numbers: [7, 45, 22, 9, 21],
      joker: 11),
  JokerDraw(
      date: '2017-12-03',
      game: 'Joker',
      numbers: [5, 44, 19, 21, 7],
      joker: 14),
  JokerDraw(
      date: '2017-12-07',
      game: 'Joker',
      numbers: [9, 29, 31, 12, 10],
      joker: 11),
  JokerDraw(
      date: '2017-12-10',
      game: 'Joker',
      numbers: [27, 30, 3, 22, 44],
      joker: 10),
  JokerDraw(
      date: '2017-12-14',
      game: 'Joker',
      numbers: [5, 21, 8, 42, 33],
      joker: 17),
  JokerDraw(
      date: '2017-12-17', game: 'Joker', numbers: [43, 21, 3, 8, 13], joker: 6),
  JokerDraw(
      date: '2017-12-21',
      game: 'Joker',
      numbers: [36, 29, 35, 9, 30],
      joker: 14),
  JokerDraw(
      date: '2017-12-24',
      game: 'Joker',
      numbers: [39, 31, 33, 42, 27],
      joker: 20),
  JokerDraw(
      date: '2017-12-31',
      game: 'Joker',
      numbers: [41, 14, 7, 31, 37],
      joker: 2),
  JokerDraw(
      date: '2017-12-31',
      game: 'Joker',
      numbers: [44, 29, 8, 14, 17],
      joker: 3),
  JokerDraw(
      date: '2018-01-04',
      game: 'Joker',
      numbers: [33, 12, 42, 7, 30],
      joker: 8),
  JokerDraw(
      date: '2018-01-07', game: 'Joker', numbers: [42, 8, 1, 41, 2], joker: 19),
  JokerDraw(
      date: '2018-01-11',
      game: 'Joker',
      numbers: [22, 20, 12, 42, 15],
      joker: 12),
  JokerDraw(
      date: '2018-01-14',
      game: 'Joker',
      numbers: [29, 40, 43, 13, 35],
      joker: 9),
  JokerDraw(
      date: '2018-01-18',
      game: 'Joker',
      numbers: [13, 24, 40, 35, 34],
      joker: 20),
  JokerDraw(
      date: '2018-01-21',
      game: 'Joker',
      numbers: [43, 9, 16, 36, 32],
      joker: 8),
  JokerDraw(
      date: '2018-01-25', game: 'Joker', numbers: [8, 12, 33, 1, 38], joker: 1),
  JokerDraw(
      date: '2018-01-28', game: 'Joker', numbers: [16, 28, 6, 5, 32], joker: 4),
  JokerDraw(
      date: '2018-02-01',
      game: 'Joker',
      numbers: [26, 34, 2, 28, 11],
      joker: 14),
  JokerDraw(
      date: '2018-02-04',
      game: 'Joker',
      numbers: [35, 16, 36, 26, 39],
      joker: 9),
  JokerDraw(
      date: '2018-02-08',
      game: 'Joker',
      numbers: [21, 41, 42, 37, 44],
      joker: 20),
  JokerDraw(
      date: '2018-02-11',
      game: 'Joker',
      numbers: [12, 33, 17, 30, 2],
      joker: 5),
  JokerDraw(
      date: '2018-02-15',
      game: 'Joker',
      numbers: [45, 44, 2, 32, 10],
      joker: 6),
  JokerDraw(
      date: '2018-02-18',
      game: 'Joker',
      numbers: [28, 12, 20, 2, 35],
      joker: 7),
  JokerDraw(
      date: '2018-02-22',
      game: 'Joker',
      numbers: [29, 19, 26, 4, 35],
      joker: 13),
  JokerDraw(
      date: '2018-02-25',
      game: 'Joker',
      numbers: [10, 37, 24, 15, 25],
      joker: 13),
  JokerDraw(
      date: '2018-03-01',
      game: 'Joker',
      numbers: [44, 40, 39, 3, 32],
      joker: 20),
  JokerDraw(
      date: '2018-03-04',
      game: 'Joker',
      numbers: [39, 34, 21, 10, 30],
      joker: 4),
  JokerDraw(
      date: '2018-03-04', game: 'Joker', numbers: [38, 1, 25, 30, 7], joker: 7),
  JokerDraw(
      date: '2018-03-08',
      game: 'Joker',
      numbers: [35, 45, 13, 4, 24],
      joker: 2),
  JokerDraw(
      date: '2018-03-11',
      game: 'Joker',
      numbers: [37, 8, 41, 22, 38],
      joker: 3),
  JokerDraw(
      date: '2018-03-15', game: 'Joker', numbers: [6, 5, 3, 25, 21], joker: 17),
  JokerDraw(
      date: '2018-03-18',
      game: 'Joker',
      numbers: [6, 24, 27, 23, 10],
      joker: 1),
  JokerDraw(
      date: '2018-03-22',
      game: 'Joker',
      numbers: [34, 5, 20, 23, 29],
      joker: 7),
  JokerDraw(
      date: '2018-03-25',
      game: 'Joker',
      numbers: [21, 45, 28, 16, 23],
      joker: 4),
  JokerDraw(
      date: '2018-03-29', game: 'Joker', numbers: [34, 3, 1, 29, 20], joker: 6),
  JokerDraw(
      date: '2018-04-01',
      game: 'Joker',
      numbers: [15, 21, 41, 5, 12],
      joker: 8),
  JokerDraw(
      date: '2018-04-08',
      game: 'Joker',
      numbers: [40, 21, 37, 26, 42],
      joker: 6),
  JokerDraw(
      date: '2018-04-08',
      game: 'Joker',
      numbers: [28, 10, 34, 41, 14],
      joker: 19),
  JokerDraw(
      date: '2018-04-12',
      game: 'Joker',
      numbers: [39, 37, 16, 44, 6],
      joker: 5),
  JokerDraw(
      date: '2018-04-15',
      game: 'Joker',
      numbers: [13, 44, 5, 42, 43],
      joker: 6),
  JokerDraw(
      date: '2018-04-19',
      game: 'Joker',
      numbers: [27, 10, 19, 14, 32],
      joker: 2),
  JokerDraw(
      date: '2018-04-22', game: 'Joker', numbers: [6, 31, 7, 3, 12], joker: 7),
  JokerDraw(
      date: '2018-04-26',
      game: 'Joker',
      numbers: [10, 44, 3, 20, 16],
      joker: 3),
  JokerDraw(
      date: '2018-04-29',
      game: 'Joker',
      numbers: [32, 30, 12, 11, 19],
      joker: 11),
  JokerDraw(
      date: '2018-05-03',
      game: 'Joker',
      numbers: [31, 15, 38, 32, 44],
      joker: 5),
  JokerDraw(
      date: '2018-05-06', game: 'Joker', numbers: [11, 27, 6, 4, 41], joker: 5),
  JokerDraw(
      date: '2018-05-10', game: 'Joker', numbers: [4, 18, 12, 14, 9], joker: 7),
  JokerDraw(
      date: '2018-05-13', game: 'Joker', numbers: [4, 35, 18, 8, 1], joker: 2),
  JokerDraw(
      date: '2018-05-17',
      game: 'Joker',
      numbers: [13, 35, 17, 24, 6],
      joker: 5),
  JokerDraw(
      date: '2018-05-20', game: 'Joker', numbers: [35, 28, 1, 24, 3], joker: 9),
  JokerDraw(
      date: '2018-05-24',
      game: 'Joker',
      numbers: [28, 41, 42, 17, 43],
      joker: 5),
  JokerDraw(
      date: '2018-05-27',
      game: 'Joker',
      numbers: [30, 42, 3, 25, 28],
      joker: 4),
  JokerDraw(
      date: '2018-05-31',
      game: 'Joker',
      numbers: [31, 41, 35, 21, 22],
      joker: 20),
  JokerDraw(
      date: '2018-06-03',
      game: 'Joker',
      numbers: [28, 34, 18, 29, 22],
      joker: 1),
  JokerDraw(
      date: '2018-06-07',
      game: 'Joker',
      numbers: [5, 4, 35, 36, 31],
      joker: 20),
  JokerDraw(
      date: '2018-06-10',
      game: 'Joker',
      numbers: [40, 39, 16, 2, 7],
      joker: 16),
  JokerDraw(
      date: '2018-06-14', game: 'Joker', numbers: [1, 34, 35, 27, 3], joker: 7),
  JokerDraw(
      date: '2018-06-17', game: 'Joker', numbers: [31, 8, 3, 33, 45], joker: 5),
  JokerDraw(
      date: '2018-06-21',
      game: 'Joker',
      numbers: [22, 20, 25, 12, 36],
      joker: 15),
  JokerDraw(
      date: '2018-06-24', game: 'Joker', numbers: [35, 9, 30, 17, 7], joker: 5),
  JokerDraw(
      date: '2018-06-28',
      game: 'Joker',
      numbers: [11, 35, 7, 25, 20],
      joker: 4),
  JokerDraw(
      date: '2018-07-01',
      game: 'Joker',
      numbers: [7, 31, 40, 45, 22],
      joker: 17),
  JokerDraw(
      date: '2018-07-05',
      game: 'Joker',
      numbers: [12, 4, 25, 30, 6],
      joker: 15),
  JokerDraw(
      date: '2018-07-08',
      game: 'Joker',
      numbers: [26, 31, 6, 23, 18],
      joker: 8),
  JokerDraw(
      date: '2018-07-12',
      game: 'Joker',
      numbers: [34, 31, 33, 9, 18],
      joker: 5),
  JokerDraw(
      date: '2018-07-15',
      game: 'Joker',
      numbers: [41, 23, 3, 18, 2],
      joker: 18),
  JokerDraw(
      date: '2018-07-19',
      game: 'Joker',
      numbers: [31, 8, 28, 22, 40],
      joker: 7),
  JokerDraw(
      date: '2018-07-22', game: 'Joker', numbers: [2, 8, 41, 28, 40], joker: 8),
  JokerDraw(
      date: '2018-07-26',
      game: 'Joker',
      numbers: [34, 10, 26, 25, 36],
      joker: 19),
  JokerDraw(
      date: '2018-07-29',
      game: 'Joker',
      numbers: [30, 13, 14, 36, 5],
      joker: 15),
  JokerDraw(
      date: '2018-08-02',
      game: 'Joker',
      numbers: [1, 12, 45, 38, 23],
      joker: 20),
  JokerDraw(
      date: '2018-08-05',
      game: 'Joker',
      numbers: [3, 20, 1, 25, 12],
      joker: 10),
  JokerDraw(
      date: '2018-08-09',
      game: 'Joker',
      numbers: [26, 28, 40, 21, 24],
      joker: 5),
  JokerDraw(
      date: '2018-08-12',
      game: 'Joker',
      numbers: [29, 38, 45, 4, 25],
      joker: 11),
  JokerDraw(
      date: '2018-08-16',
      game: 'Joker',
      numbers: [5, 31, 26, 42, 30],
      joker: 13),
  JokerDraw(
      date: '2018-08-19', game: 'Joker', numbers: [45, 30, 7, 31, 9], joker: 6),
  JokerDraw(
      date: '2018-08-23', game: 'Joker', numbers: [3, 37, 16, 8, 34], joker: 9),
  JokerDraw(
      date: '2018-08-26',
      game: 'Joker',
      numbers: [12, 28, 17, 45, 42],
      joker: 17),
  JokerDraw(
      date: '2018-08-30', game: 'Joker', numbers: [39, 5, 7, 15, 29], joker: 8),
  JokerDraw(
      date: '2018-09-02',
      game: 'Joker',
      numbers: [19, 31, 8, 33, 17],
      joker: 14),
  JokerDraw(
      date: '2018-09-06',
      game: 'Joker',
      numbers: [27, 10, 2, 43, 12],
      joker: 1),
  JokerDraw(
      date: '2018-09-09',
      game: 'Joker',
      numbers: [13, 14, 1, 35, 25],
      joker: 10),
  JokerDraw(
      date: '2018-09-13',
      game: 'Joker',
      numbers: [32, 2, 20, 40, 41],
      joker: 4),
  JokerDraw(
      date: '2018-09-16',
      game: 'Joker',
      numbers: [2, 37, 34, 15, 21],
      joker: 4),
  JokerDraw(
      date: '2018-09-16',
      game: 'Joker',
      numbers: [21, 12, 18, 28, 32],
      joker: 13),
  JokerDraw(
      date: '2018-09-20',
      game: 'Joker',
      numbers: [12, 24, 31, 6, 34],
      joker: 18),
  JokerDraw(
      date: '2018-09-23',
      game: 'Joker',
      numbers: [24, 22, 40, 39, 27],
      joker: 17),
  JokerDraw(
      date: '2018-09-27',
      game: 'Joker',
      numbers: [11, 26, 32, 23, 44],
      joker: 9),
  JokerDraw(
      date: '2018-09-30',
      game: 'Joker',
      numbers: [40, 32, 41, 2, 38],
      joker: 3),
  JokerDraw(
      date: '2018-10-04',
      game: 'Joker',
      numbers: [31, 44, 41, 20, 25],
      joker: 5),
  JokerDraw(
      date: '2018-10-07', game: 'Joker', numbers: [21, 3, 42, 34, 4], joker: 9),
  JokerDraw(
      date: '2018-10-11',
      game: 'Joker',
      numbers: [34, 1, 6, 26, 10],
      joker: 14),
  JokerDraw(
      date: '2018-10-14',
      game: 'Joker',
      numbers: [6, 18, 29, 32, 17],
      joker: 8),
  JokerDraw(
      date: '2018-10-18',
      game: 'Joker',
      numbers: [19, 20, 38, 40, 10],
      joker: 16),
  JokerDraw(
      date: '2018-10-21', game: 'Joker', numbers: [35, 5, 43, 21, 9], joker: 7),
  JokerDraw(
      date: '2018-10-21', game: 'Joker', numbers: [4, 7, 19, 26, 31], joker: 9),
  JokerDraw(
      date: '2018-10-25',
      game: 'Joker',
      numbers: [25, 13, 15, 11, 37],
      joker: 17),
  JokerDraw(
      date: '2018-10-28',
      game: 'Joker',
      numbers: [17, 24, 42, 44, 13],
      joker: 6),
  JokerDraw(
      date: '2018-11-01',
      game: 'Joker',
      numbers: [16, 44, 9, 27, 36],
      joker: 2),
  JokerDraw(
      date: '2018-11-04',
      game: 'Joker',
      numbers: [44, 40, 27, 10, 35],
      joker: 12),
  JokerDraw(
      date: '2018-11-08',
      game: 'Joker',
      numbers: [32, 22, 6, 42, 36],
      joker: 3),
  JokerDraw(
      date: '2018-11-11',
      game: 'Joker',
      numbers: [25, 18, 37, 39, 32],
      joker: 13),
  JokerDraw(
      date: '2018-11-15',
      game: 'Joker',
      numbers: [24, 20, 4, 25, 39],
      joker: 3),
  JokerDraw(
      date: '2018-11-18', game: 'Joker', numbers: [9, 38, 8, 6, 3], joker: 15),
  JokerDraw(
      date: '2018-11-18',
      game: 'Joker',
      numbers: [28, 40, 18, 43, 16],
      joker: 20),
  JokerDraw(
      date: '2018-11-22',
      game: 'Joker',
      numbers: [6, 15, 45, 32, 41],
      joker: 16),
  JokerDraw(
      date: '2018-11-25', game: 'Joker', numbers: [25, 27, 3, 1, 8], joker: 2),
  JokerDraw(
      date: '2018-11-29',
      game: 'Joker',
      numbers: [39, 37, 43, 44, 2],
      joker: 5),
  JokerDraw(
      date: '2018-12-2', game: 'Joker', numbers: [17, 4, 37, 16, 27], joker: 2),
  JokerDraw(
      date: '2018-12-2',
      game: 'Joker',
      numbers: [17, 27, 26, 23, 30],
      joker: 15),
  JokerDraw(
      date: '2018-12-6', game: 'Joker', numbers: [37, 36, 18, 39, 7], joker: 3),
  JokerDraw(
      date: '2018-12-9',
      game: 'Joker',
      numbers: [38, 14, 37, 12, 19],
      joker: 20),
  JokerDraw(
      date: '2018-12-13',
      game: 'Joker',
      numbers: [32, 6, 25, 24, 42],
      joker: 6),
  JokerDraw(
      date: '2018-12-16',
      game: 'Joker',
      numbers: [43, 31, 22, 9, 23],
      joker: 7),
  JokerDraw(
      date: '2018-12-20',
      game: 'Joker',
      numbers: [18, 45, 21, 20, 37],
      joker: 15),
  JokerDraw(
      date: '2018-12-23',
      game: 'Joker',
      numbers: [45, 2, 21, 3, 10],
      joker: 20),
  JokerDraw(
      date: '2018-12-31',
      game: 'Joker',
      numbers: [39, 4, 13, 32, 20],
      joker: 3),
  JokerDraw(
      date: '2019-01-06',
      game: 'Joker',
      numbers: [8, 20, 42, 38, 22],
      joker: 17),
  JokerDraw(
      date: '2019-01-10',
      game: 'Joker',
      numbers: [18, 38, 43, 45, 11],
      joker: 2),
  JokerDraw(
      date: '2019-01-13',
      game: 'Joker',
      numbers: [29, 44, 27, 6, 40],
      joker: 19),
  JokerDraw(
      date: '2019-01-17',
      game: 'Joker',
      numbers: [39, 3, 32, 27, 30],
      joker: 3),
  JokerDraw(
      date: '2019-01-20',
      game: 'Joker',
      numbers: [11, 33, 10, 6, 12],
      joker: 3),
  JokerDraw(
      date: '2019-01-24',
      game: 'Joker',
      numbers: [36, 13, 45, 31, 12],
      joker: 14),
  JokerDraw(
      date: '2019-01-27',
      game: 'Joker',
      numbers: [17, 3, 7, 28, 38],
      joker: 15),
  JokerDraw(
      date: '2019-01-31', game: 'Joker', numbers: [25, 6, 43, 5, 2], joker: 4),
  JokerDraw(
      date: '2019-02-03',
      game: 'Joker',
      numbers: [21, 22, 14, 7, 43],
      joker: 19),
  JokerDraw(
      date: '2019-02-07', game: 'Joker', numbers: [1, 41, 5, 2, 22], joker: 6),
  JokerDraw(
      date: '2019-02-10',
      game: 'Joker',
      numbers: [44, 30, 17, 3, 24],
      joker: 6),
  JokerDraw(
      date: '2019-02-14',
      game: 'Joker',
      numbers: [43, 3, 41, 27, 15],
      joker: 19),
  JokerDraw(
      date: '2019-02-17',
      game: 'Joker',
      numbers: [4, 3, 13, 43, 11],
      joker: 16),
  JokerDraw(
      date: '2019-02-21', game: 'Joker', numbers: [1, 37, 13, 23, 5], joker: 2),
  JokerDraw(
      date: '2019-02-24',
      game: 'Joker',
      numbers: [30, 6, 27, 13, 20],
      joker: 11),
  JokerDraw(
      date: '2019-02-28',
      game: 'Joker',
      numbers: [29, 3, 39, 14, 33],
      joker: 6),
  JokerDraw(
      date: '2019-03-03',
      game: 'Joker',
      numbers: [42, 18, 33, 12, 34],
      joker: 4),
  JokerDraw(
      date: '2019-03-07',
      game: 'Joker',
      numbers: [18, 15, 40, 13, 3],
      joker: 6),
  JokerDraw(
      date: '2019-03-10',
      game: 'Joker',
      numbers: [16, 27, 22, 6, 43],
      joker: 4),
  JokerDraw(
      date: '2019-03-14',
      game: 'Joker',
      numbers: [28, 39, 33, 1, 45],
      joker: 8),
  JokerDraw(
      date: '2019-03-17', game: 'Joker', numbers: [9, 14, 12, 10, 4], joker: 7),
  JokerDraw(
      date: '2019-03-21',
      game: 'Joker',
      numbers: [35, 29, 11, 14, 4],
      joker: 6),
  JokerDraw(
      date: '2019-03-24',
      game: 'Joker',
      numbers: [13, 4, 22, 35, 39],
      joker: 4),
  JokerDraw(
      date: '2019-03-28',
      game: 'Joker',
      numbers: [26, 10, 15, 16, 14],
      joker: 18),
  JokerDraw(
      date: '2019-03-31',
      game: 'Joker',
      numbers: [40, 21, 16, 18, 17],
      joker: 2),
  JokerDraw(
      date: '2019-04-04',
      game: 'Joker',
      numbers: [21, 5, 24, 16, 13],
      joker: 8),
  JokerDraw(
      date: '2019-04-07',
      game: 'Joker',
      numbers: [29, 21, 34, 1, 39],
      joker: 2),
  JokerDraw(
      date: '2019-04-11',
      game: 'Joker',
      numbers: [17, 37, 27, 4, 35],
      joker: 3),
  JokerDraw(
      date: '2019-04-14',
      game: 'Joker',
      numbers: [40, 13, 39, 34, 25],
      joker: 10),
  JokerDraw(
      date: '2019-04-18',
      game: 'Joker',
      numbers: [14, 33, 26, 9, 28],
      joker: 5),
  JokerDraw(
      date: '2019-04-21',
      game: 'Joker',
      numbers: [16, 13, 33, 44, 39],
      joker: 8),
  JokerDraw(
      date: '2019-04-27',
      game: 'Joker',
      numbers: [5, 6, 15, 25, 33],
      joker: 12),
  JokerDraw(
      date: '2019-04-27', game: 'Joker', numbers: [22, 6, 21, 5, 45], joker: 3),
  JokerDraw(
      date: '2019-05-02',
      game: 'Joker',
      numbers: [40, 3, 16, 1, 37],
      joker: 18),
  JokerDraw(
      date: '2019-05-05',
      game: 'Joker',
      numbers: [14, 5, 11, 25, 18],
      joker: 18),
  JokerDraw(
      date: '2019-05-09',
      game: 'Joker',
      numbers: [26, 17, 1, 8, 33],
      joker: 17),
  JokerDraw(
      date: '2019-05-12',
      game: 'Joker',
      numbers: [7, 4, 42, 27, 19],
      joker: 12),
  JokerDraw(
      date: '2019-05-16',
      game: 'Joker',
      numbers: [42, 23, 41, 38, 13],
      joker: 14),
  JokerDraw(
      date: '2019-05-19',
      game: 'Joker',
      numbers: [3, 28, 44, 19, 14],
      joker: 13),
  JokerDraw(
      date: '2019-05-23',
      game: 'Joker',
      numbers: [45, 4, 31, 18, 21],
      joker: 1),
  JokerDraw(
      date: '2019-05-26',
      game: 'Joker',
      numbers: [1, 8, 18, 12, 24],
      joker: 18),
  JokerDraw(
      date: '2019-05-30',
      game: 'Joker',
      numbers: [41, 10, 32, 31, 6],
      joker: 12),
  JokerDraw(
      date: '2019-06-02',
      game: 'Joker',
      numbers: [33, 20, 3, 21, 34],
      joker: 18),
  JokerDraw(
      date: '2019-06-06',
      game: 'Joker',
      numbers: [30, 18, 43, 3, 16],
      joker: 7),
  JokerDraw(
      date: '2019-06-09',
      game: 'Joker',
      numbers: [34, 11, 21, 40, 43],
      joker: 2),
  JokerDraw(
      date: '2019-06-13',
      game: 'Joker',
      numbers: [16, 5, 38, 35, 37],
      joker: 13),
  JokerDraw(
      date: '2019-06-16',
      game: 'Joker',
      numbers: [10, 27, 4, 37, 36],
      joker: 12),
  JokerDraw(
      date: '2019-06-20',
      game: 'Joker',
      numbers: [37, 40, 44, 42, 28],
      joker: 3),
  JokerDraw(
      date: '2019-06-23',
      game: 'Joker',
      numbers: [11, 21, 12, 2, 3],
      joker: 19),
  JokerDraw(
      date: '2019-06-27',
      game: 'Joker',
      numbers: [37, 32, 16, 23, 2],
      joker: 7),
  JokerDraw(
      date: '2019-06-30',
      game: 'Joker',
      numbers: [4, 7, 13, 40, 44],
      joker: 19),
  JokerDraw(
      date: '2019-07-04',
      game: 'Joker',
      numbers: [10, 13, 33, 18, 45],
      joker: 3),
  JokerDraw(
      date: '2019-07-07', game: 'Joker', numbers: [22, 5, 38, 4, 24], joker: 4),
  JokerDraw(
      date: '2019-07-11',
      game: 'Joker',
      numbers: [39, 43, 16, 34, 28],
      joker: 10),
  JokerDraw(
      date: '2019-07-14',
      game: 'Joker',
      numbers: [45, 16, 10, 35, 31],
      joker: 18),
  JokerDraw(
      date: '2019-07-18', game: 'Joker', numbers: [1, 31, 12, 44, 5], joker: 9),
  JokerDraw(
      date: '2019-07-21',
      game: 'Joker',
      numbers: [36, 9, 29, 26, 40],
      joker: 11),
  JokerDraw(
      date: '2019-07-25',
      game: 'Joker',
      numbers: [41, 45, 24, 16, 6],
      joker: 12),
  JokerDraw(
      date: '2019-07-28',
      game: 'Joker',
      numbers: [28, 45, 24, 40, 33],
      joker: 5),
  JokerDraw(
      date: '2019-08-01',
      game: 'Joker',
      numbers: [35, 44, 19, 25, 43],
      joker: 3),
  JokerDraw(
      date: '2019-08-04', game: 'Joker', numbers: [6, 20, 7, 9, 8], joker: 4),
  JokerDraw(
      date: '2019-08-08',
      game: 'Joker',
      numbers: [43, 11, 15, 42, 36],
      joker: 1),
  JokerDraw(
      date: '2019-08-11',
      game: 'Joker',
      numbers: [24, 23, 4, 18, 32],
      joker: 9),
  JokerDraw(
      date: '2019-08-15',
      game: 'Joker',
      numbers: [30, 38, 40, 32, 27],
      joker: 3),
  JokerDraw(
      date: '2019-08-18', game: 'Joker', numbers: [13, 6, 4, 1, 28], joker: 3),
  JokerDraw(
      date: '2019-08-22',
      game: 'Joker',
      numbers: [31, 34, 8, 17, 24],
      joker: 3),
  JokerDraw(
      date: '2019-08-25',
      game: 'Joker',
      numbers: [17, 14, 37, 41, 26],
      joker: 7),
  JokerDraw(
      date: '2019-08-29',
      game: 'Joker',
      numbers: [42, 18, 27, 10, 32],
      joker: 14),
  JokerDraw(
      date: '2019-09-01',
      game: 'Joker',
      numbers: [25, 22, 19, 4, 10],
      joker: 9),
  JokerDraw(
      date: '2019-09-05',
      game: 'Joker',
      numbers: [37, 35, 8, 39, 14],
      joker: 20),
  JokerDraw(
      date: '2019-09-08',
      game: 'Joker',
      numbers: [27, 3, 32, 2, 11],
      joker: 14),
  JokerDraw(
      date: '2019-09-12',
      game: 'Joker',
      numbers: [44, 1, 35, 17, 43],
      joker: 20),
  JokerDraw(
      date: '2019-09-15',
      game: 'Joker',
      numbers: [16, 43, 23, 24, 20],
      joker: 16),
  JokerDraw(
      date: '2019-09-15',
      game: 'Joker',
      numbers: [17, 5, 6, 37, 44],
      joker: 10),
  JokerDraw(
      date: '2019-09-19',
      game: 'Joker',
      numbers: [10, 6, 35, 21, 43],
      joker: 7),
  JokerDraw(
      date: '2019-09-22',
      game: 'Joker',
      numbers: [23, 29, 10, 17, 26],
      joker: 14),
  JokerDraw(
      date: '2019-09-26',
      game: 'Joker',
      numbers: [31, 10, 15, 7, 5],
      joker: 16),
  JokerDraw(
      date: '2019-09-29',
      game: 'Joker',
      numbers: [31, 32, 19, 22, 35],
      joker: 13),
  JokerDraw(
      date: '2019-10-3',
      game: 'Joker',
      numbers: [37, 24, 8, 40, 20],
      joker: 12),
  JokerDraw(
      date: '2019-10-6', game: 'Joker', numbers: [45, 28, 4, 5, 18], joker: 3),
  JokerDraw(
      date: '2019-10-10',
      game: 'Joker',
      numbers: [45, 31, 33, 30, 7],
      joker: 9),
  JokerDraw(
      date: '2019-10-13',
      game: 'Joker',
      numbers: [22, 8, 5, 36, 23],
      joker: 13),
  JokerDraw(
      date: '2019-10-17',
      game: 'Joker',
      numbers: [1, 40, 13, 19, 25],
      joker: 10),
  JokerDraw(
      date: '2019-10-20',
      game: 'Joker',
      numbers: [10, 14, 26, 24, 22],
      joker: 8),
  JokerDraw(
      date: '2019-10-24',
      game: 'Joker',
      numbers: [31, 14, 21, 5, 23],
      joker: 13),
  JokerDraw(
      date: '2019-10-27',
      game: 'Joker',
      numbers: [35, 17, 4, 42, 31],
      joker: 9),
  JokerDraw(
      date: '2019-10-31',
      game: 'Joker',
      numbers: [25, 35, 5, 45, 34],
      joker: 9),
  JokerDraw(
      date: '2019-11-3',
      game: 'Joker',
      numbers: [25, 12, 43, 13, 34],
      joker: 12),
  JokerDraw(
      date: '2019-11-7',
      game: 'Joker',
      numbers: [41, 6, 34, 19, 32],
      joker: 13),
  JokerDraw(
      date: '2019-11-10',
      game: 'Joker',
      numbers: [31, 41, 16, 43, 13],
      joker: 12),
  JokerDraw(
      date: '2019-11-14',
      game: 'Joker',
      numbers: [5, 11, 35, 4, 18],
      joker: 13),
  JokerDraw(
      date: '2019-11-17',
      game: 'Joker',
      numbers: [38, 12, 25, 28, 41],
      joker: 4),
  JokerDraw(
      date: '2019-11-21', game: 'Joker', numbers: [3, 26, 17, 4, 27], joker: 1),
  JokerDraw(
      date: '2019-11-24',
      game: 'Joker',
      numbers: [27, 31, 21, 44, 26],
      joker: 6),
  JokerDraw(
      date: '2019-11-28',
      game: 'Joker',
      numbers: [8, 14, 38, 36, 29],
      joker: 7),
  JokerDraw(
      date: '2019-12-1', game: 'Joker', numbers: [5, 23, 37, 45, 8], joker: 18),
  JokerDraw(
      date: '2019-12-1',
      game: 'Joker',
      numbers: [12, 38, 25, 42, 7],
      joker: 20),
  JokerDraw(
      date: '2019-12-5', game: 'Joker', numbers: [32, 5, 42, 39, 37], joker: 5),
  JokerDraw(
      date: '2019-12-8',
      game: 'Joker',
      numbers: [11, 17, 27, 14, 28],
      joker: 5),
  JokerDraw(
      date: '2019-12-12',
      game: 'Joker',
      numbers: [41, 9, 27, 43, 42],
      joker: 5),
  JokerDraw(
      date: '2019-12-15',
      game: 'Joker',
      numbers: [27, 11, 18, 45, 4],
      joker: 5),
  JokerDraw(
      date: '2019-12-19', game: 'Joker', numbers: [24, 25, 6, 22, 9], joker: 9),
  JokerDraw(
      date: '2019-12-22',
      game: 'Joker',
      numbers: [14, 28, 38, 39, 19],
      joker: 2),
  JokerDraw(
      date: '2019-12-31',
      game: 'Joker',
      numbers: [27, 16, 17, 7, 31],
      joker: 17),
  JokerDraw(
      date: '2019-12-31',
      game: 'Joker',
      numbers: [2, 44, 27, 12, 33],
      joker: 5),
  JokerDraw(
      date: '2020-01-05',
      game: 'Joker',
      numbers: [10, 40, 25, 8, 35],
      joker: 10),
  JokerDraw(
      date: '2020-01-09',
      game: 'Joker',
      numbers: [1, 27, 22, 21, 12],
      joker: 8),
  JokerDraw(
      date: '2020-01-12',
      game: 'Joker',
      numbers: [19, 16, 43, 5, 37],
      joker: 12),
  JokerDraw(
      date: '2020-01-16',
      game: 'Joker',
      numbers: [33, 37, 6, 18, 34],
      joker: 9),
  JokerDraw(
      date: '2020-01-19',
      game: 'Joker',
      numbers: [45, 43, 42, 41, 20],
      joker: 15),
  JokerDraw(
      date: '2020-01-23',
      game: 'Joker',
      numbers: [4, 10, 14, 1, 11],
      joker: 20),
  JokerDraw(
      date: '2020-01-26',
      game: 'Joker',
      numbers: [10, 20, 31, 28, 45],
      joker: 6),
  JokerDraw(
      date: '2020-01-30',
      game: 'Joker',
      numbers: [18, 10, 7, 30, 24],
      joker: 11),
  JokerDraw(
      date: '2020-02-02',
      game: 'Joker',
      numbers: [3, 40, 34, 21, 44],
      joker: 9),
  JokerDraw(
      date: '2020-02-06', game: 'Joker', numbers: [25, 2, 39, 8, 43], joker: 9),
  JokerDraw(
      date: '2020-02-09',
      game: 'Joker',
      numbers: [10, 3, 38, 24, 5],
      joker: 20),
  JokerDraw(
      date: '2020-02-13',
      game: 'Joker',
      numbers: [27, 43, 22, 12, 42],
      joker: 13),
  JokerDraw(
      date: '2020-02-16',
      game: 'Joker',
      numbers: [43, 31, 42, 33, 19],
      joker: 18),
  JokerDraw(
      date: '2020-02-20',
      game: 'Joker',
      numbers: [35, 19, 41, 16, 20],
      joker: 12),
  JokerDraw(
      date: '2020-02-23',
      game: 'Joker',
      numbers: [24, 23, 27, 13, 19],
      joker: 15),
  JokerDraw(
      date: '2020-02-27',
      game: 'Joker',
      numbers: [8, 10, 43, 7, 18],
      joker: 10),
  JokerDraw(
      date: '2020-03-01',
      game: 'Joker',
      numbers: [20, 9, 8, 42, 31],
      joker: 20),
  JokerDraw(
      date: '2020-03-05', game: 'Joker', numbers: [16, 4, 43, 36, 5], joker: 7),
  JokerDraw(
      date: '2020-03-08',
      game: 'Joker',
      numbers: [32, 10, 33, 3, 12],
      joker: 15),
  JokerDraw(
      date: '2020-03-08',
      game: 'Joker',
      numbers: [27, 36, 23, 42, 9],
      joker: 17),
  JokerDraw(
      date: '2020-03-12',
      game: 'Joker',
      numbers: [29, 19, 30, 38, 13],
      joker: 10),
  JokerDraw(
      date: '2020-03-15', game: 'Joker', numbers: [29, 3, 24, 20, 7], joker: 4),
  JokerDraw(
      date: '2020-03-19',
      game: 'Joker',
      numbers: [43, 33, 40, 19, 12],
      joker: 10),
  JokerDraw(
      date: '2020-06-21', game: 'Joker', numbers: [9, 36, 27, 21, 3], joker: 8),
  JokerDraw(
      date: '2020-06-25',
      game: 'Joker',
      numbers: [31, 39, 7, 10, 15],
      joker: 12),
  JokerDraw(
      date: '2020-06-28',
      game: 'Joker',
      numbers: [11, 38, 29, 10, 36],
      joker: 3),
  JokerDraw(
      date: '2020-07-02', game: 'Joker', numbers: [6, 9, 14, 3, 16], joker: 8),
  JokerDraw(
      date: '2020-07-05',
      game: 'Joker',
      numbers: [44, 36, 1, 6, 16],
      joker: 19),
  JokerDraw(
      date: '2020-07-09',
      game: 'Joker',
      numbers: [9, 27, 38, 34, 7],
      joker: 10),
  JokerDraw(
      date: '2020-07-12',
      game: 'Joker',
      numbers: [9, 25, 24, 30, 14],
      joker: 16),
  JokerDraw(
      date: '2020-07-16',
      game: 'Joker',
      numbers: [37, 24, 22, 10, 26],
      joker: 20),
  JokerDraw(
      date: '2020-07-19',
      game: 'Joker',
      numbers: [3, 28, 13, 29, 17],
      joker: 7),
  JokerDraw(
      date: '2020-07-23',
      game: 'Joker',
      numbers: [17, 26, 1, 32, 35],
      joker: 20),
  JokerDraw(
      date: '2020-07-26', game: 'Joker', numbers: [45, 3, 9, 1, 29], joker: 19),
  JokerDraw(
      date: '2020-07-30', game: 'Joker', numbers: [13, 6, 45, 9, 8], joker: 8),
  JokerDraw(
      date: '2020-08-02',
      game: 'Joker',
      numbers: [32, 42, 39, 20, 4],
      joker: 19),
  JokerDraw(
      date: '2020-08-06', game: 'Joker', numbers: [7, 32, 40, 6, 25], joker: 9),
  JokerDraw(
      date: '2020-08-09',
      game: 'Joker',
      numbers: [16, 25, 35, 5, 42],
      joker: 16),
  JokerDraw(
      date: '2020-08-13', game: 'Joker', numbers: [36, 1, 23, 8, 41], joker: 5),
  JokerDraw(
      date: '2020-08-16',
      game: 'Joker',
      numbers: [23, 28, 11, 35, 18],
      joker: 18),
  JokerDraw(
      date: '2020-08-20',
      game: 'Joker',
      numbers: [13, 32, 41, 5, 23],
      joker: 4),
  JokerDraw(
      date: '2020-08-23',
      game: 'Joker',
      numbers: [30, 3, 41, 7, 18],
      joker: 14),
  JokerDraw(
      date: '2020-08-27',
      game: 'Joker',
      numbers: [26, 20, 19, 16, 44],
      joker: 12),
  JokerDraw(
      date: '2020-08-30',
      game: 'Joker',
      numbers: [11, 25, 13, 9, 31],
      joker: 1),
  JokerDraw(
      date: '2020-09-03',
      game: 'Joker',
      numbers: [13, 17, 38, 25, 2],
      joker: 1),
  JokerDraw(
      date: '2020-09-06',
      game: 'Joker',
      numbers: [10, 34, 23, 32, 8],
      joker: 4),
  JokerDraw(
      date: '2020-09-10', game: 'Joker', numbers: [25, 4, 5, 3, 10], joker: 11),
  JokerDraw(
      date: '2020-09-13',
      game: 'Joker',
      numbers: [42, 32, 41, 18, 22],
      joker: 6),
  JokerDraw(
      date: '2020-09-13',
      game: 'Joker',
      numbers: [11, 7, 41, 3, 22],
      joker: 18),
  JokerDraw(
      date: '2020-09-17',
      game: 'Joker',
      numbers: [33, 2, 28, 30, 5],
      joker: 12),
  JokerDraw(
      date: '2020-09-20', game: 'Joker', numbers: [6, 39, 28, 9, 25], joker: 2),
  JokerDraw(
      date: '2020-09-24',
      game: 'Joker',
      numbers: [18, 1, 35, 44, 22],
      joker: 16),
  JokerDraw(
      date: '2020-09-27', game: 'Joker', numbers: [4, 22, 21, 6, 18], joker: 2),
  JokerDraw(
      date: '2020-10-1', game: 'Joker', numbers: [9, 41, 14, 3, 45], joker: 11),
  JokerDraw(
      date: '2020-10-4', game: 'Joker', numbers: [30, 23, 1, 41, 31], joker: 4),
  JokerDraw(
      date: '2020-10-8',
      game: 'Joker',
      numbers: [3, 35, 12, 44, 38],
      joker: 13),
  JokerDraw(
      date: '2020-10-11',
      game: 'Joker',
      numbers: [22, 45, 37, 23, 7],
      joker: 18),
  JokerDraw(
      date: '2020-10-15',
      game: 'Joker',
      numbers: [25, 15, 31, 3, 2],
      joker: 18),
  JokerDraw(
      date: '2020-10-18',
      game: 'Joker',
      numbers: [31, 16, 15, 32, 38],
      joker: 7),
  JokerDraw(
      date: '2020-10-22',
      game: 'Joker',
      numbers: [29, 43, 42, 34, 8],
      joker: 13),
  JokerDraw(
      date: '2020-10-25',
      game: 'Joker',
      numbers: [44, 9, 14, 13, 16],
      joker: 8),
  JokerDraw(
      date: '2020-10-29',
      game: 'Joker',
      numbers: [32, 7, 5, 29, 14],
      joker: 14),
  JokerDraw(
      date: '2020-11-1',
      game: 'Joker',
      numbers: [24, 10, 11, 4, 43],
      joker: 20),
  JokerDraw(
      date: '2020-11-5', game: 'Joker', numbers: [8, 22, 34, 2, 5], joker: 6),
  JokerDraw(
      date: '2020-11-8',
      game: 'Joker',
      numbers: [19, 15, 20, 21, 1],
      joker: 20),
  JokerDraw(
      date: '2020-11-12',
      game: 'Joker',
      numbers: [29, 28, 21, 9, 3],
      joker: 10),
  JokerDraw(
      date: '2020-11-15', game: 'Joker', numbers: [1, 2, 30, 33, 9], joker: 17),
  JokerDraw(
      date: '2020-11-19',
      game: 'Joker',
      numbers: [44, 9, 6, 32, 10],
      joker: 16),
  JokerDraw(
      date: '2020-11-22', game: 'Joker', numbers: [38, 28, 2, 6, 25], joker: 1),
  JokerDraw(
      date: '2020-11-26',
      game: 'Joker',
      numbers: [10, 24, 37, 30, 28],
      joker: 1),
  JokerDraw(
      date: '2020-11-29',
      game: 'Joker',
      numbers: [25, 14, 6, 32, 20],
      joker: 19),
  JokerDraw(
      date: '2020-12-3',
      game: 'Joker',
      numbers: [33, 25, 44, 17, 28],
      joker: 1),
  JokerDraw(
      date: '2020-12-6',
      game: 'Joker',
      numbers: [21, 17, 39, 26, 44],
      joker: 19),
  JokerDraw(
      date: '2020-12-6',
      game: 'Joker',
      numbers: [30, 15, 34, 42, 8],
      joker: 20),
  JokerDraw(
      date: '2020-12-10',
      game: 'Joker',
      numbers: [11, 43, 16, 32, 38],
      joker: 9),
  JokerDraw(
      date: '2020-12-13',
      game: 'Joker',
      numbers: [38, 8, 15, 27, 34],
      joker: 11),
  JokerDraw(
      date: '2020-12-17',
      game: 'Joker',
      numbers: [2, 19, 42, 11, 39],
      joker: 12),
  JokerDraw(
      date: '2020-12-20',
      game: 'Joker',
      numbers: [35, 42, 2, 28, 30],
      joker: 6),
  JokerDraw(
      date: '2020-12-24',
      game: 'Joker',
      numbers: [33, 44, 20, 12, 17],
      joker: 10),
  JokerDraw(
      date: '2020-12-31',
      game: 'Joker',
      numbers: [18, 21, 13, 23, 36],
      joker: 17),
  JokerDraw(
      date: '2020-12-31',
      game: 'Joker',
      numbers: [19, 45, 10, 11, 42],
      joker: 6),
  JokerDraw(
      date: '2021-01-03',
      game: 'Joker',
      numbers: [17, 21, 33, 27, 10],
      joker: 16),
  JokerDraw(
      date: '2021-01-07',
      game: 'Joker',
      numbers: [21, 6, 29, 14, 19],
      joker: 18),
  JokerDraw(
      date: '2021-01-10',
      game: 'Joker',
      numbers: [10, 36, 14, 38, 39],
      joker: 11),
  JokerDraw(
      date: '2021-01-14',
      game: 'Joker',
      numbers: [12, 10, 11, 27, 36],
      joker: 19),
  JokerDraw(
      date: '2021-01-17', game: 'Joker', numbers: [32, 6, 29, 45, 8], joker: 2),
  JokerDraw(
      date: '2021-01-21',
      game: 'Joker',
      numbers: [41, 25, 13, 8, 31],
      joker: 13),
  JokerDraw(
      date: '2021-01-24',
      game: 'Joker',
      numbers: [40, 35, 23, 19, 28],
      joker: 19),
  JokerDraw(
      date: '2021-01-28',
      game: 'Joker',
      numbers: [24, 12, 21, 4, 7],
      joker: 19),
  JokerDraw(
      date: '2021-01-31', game: 'Joker', numbers: [5, 45, 44, 1, 4], joker: 9),
  JokerDraw(
      date: '2021-02-04',
      game: 'Joker',
      numbers: [18, 10, 16, 26, 3],
      joker: 19),
  JokerDraw(
      date: '2021-02-07',
      game: 'Joker',
      numbers: [15, 40, 20, 41, 3],
      joker: 11),
  JokerDraw(
      date: '2021-02-11',
      game: 'Joker',
      numbers: [16, 25, 11, 38, 36],
      joker: 12),
  JokerDraw(
      date: '2021-02-14',
      game: 'Joker',
      numbers: [13, 25, 11, 44, 18],
      joker: 17),
  JokerDraw(
      date: '2021-02-18', game: 'Joker', numbers: [6, 5, 8, 12, 3], joker: 4),
  JokerDraw(
      date: '2021-02-21',
      game: 'Joker',
      numbers: [12, 22, 18, 26, 31],
      joker: 4),
  JokerDraw(
      date: '2021-02-25',
      game: 'Joker',
      numbers: [2, 44, 8, 40, 30],
      joker: 19),
  JokerDraw(
      date: '2021-03-07',
      game: 'Joker',
      numbers: [14, 18, 1, 31, 24],
      joker: 2),
  JokerDraw(
      date: '2021-03-07',
      game: 'Joker',
      numbers: [19, 22, 42, 36, 34],
      joker: 20),
  JokerDraw(
      date: '2021-03-11', game: 'Joker', numbers: [45, 16, 4, 18, 1], joker: 5),
  JokerDraw(
      date: '2021-03-14',
      game: 'Joker',
      numbers: [31, 13, 21, 33, 16],
      joker: 17),
  JokerDraw(
      date: '2021-03-18',
      game: 'Joker',
      numbers: [13, 33, 23, 6, 20],
      joker: 8),
  JokerDraw(
      date: '2021-03-21',
      game: 'Joker',
      numbers: [34, 9, 45, 5, 31],
      joker: 10),
  JokerDraw(
      date: '2021-03-25',
      game: 'Joker',
      numbers: [12, 27, 29, 16, 23],
      joker: 9),
  JokerDraw(
      date: '2021-03-28',
      game: 'Joker',
      numbers: [6, 21, 45, 36, 24],
      joker: 7),
  JokerDraw(
      date: '2021-04-01', game: 'Joker', numbers: [2, 3, 23, 25, 10], joker: 1),
  JokerDraw(
      date: '2021-04-04',
      game: 'Joker',
      numbers: [3, 24, 22, 21, 38],
      joker: 10),
  JokerDraw(
      date: '2021-04-08',
      game: 'Joker',
      numbers: [39, 33, 4, 40, 36],
      joker: 7),
  JokerDraw(
      date: '2021-04-11', game: 'Joker', numbers: [6, 4, 24, 45, 33], joker: 8),
  JokerDraw(
      date: '2021-04-15',
      game: 'Joker',
      numbers: [20, 28, 32, 33, 27],
      joker: 4),
  JokerDraw(
      date: '2021-04-18', game: 'Joker', numbers: [2, 1, 10, 25, 14], joker: 3),
  JokerDraw(
      date: '2021-04-22', game: 'Joker', numbers: [9, 44, 41, 1, 12], joker: 2),
  JokerDraw(
      date: '2021-04-25',
      game: 'Joker',
      numbers: [1, 23, 15, 18, 26],
      joker: 17),
  JokerDraw(
      date: '2021-05-01', game: 'Joker', numbers: [3, 5, 20, 9, 41], joker: 13),
  JokerDraw(
      date: '2021-05-01', game: 'Joker', numbers: [4, 9, 43, 1, 36], joker: 4),
  JokerDraw(
      date: '2021-05-06', game: 'Joker', numbers: [13, 40, 5, 16, 7], joker: 3),
  JokerDraw(
      date: '2021-05-09',
      game: 'Joker',
      numbers: [5, 29, 38, 14, 23],
      joker: 9),
  JokerDraw(
      date: '2021-05-13',
      game: 'Joker',
      numbers: [39, 36, 45, 21, 15],
      joker: 19),
  JokerDraw(
      date: '2021-05-16', game: 'Joker', numbers: [36, 7, 8, 25, 13], joker: 1),
  JokerDraw(
      date: '2021-05-20', game: 'Joker', numbers: [2, 33, 27, 9, 31], joker: 1),
  JokerDraw(
      date: '2021-05-23',
      game: 'Joker',
      numbers: [12, 42, 31, 33, 34],
      joker: 12),
  JokerDraw(
      date: '2021-05-27',
      game: 'Joker',
      numbers: [28, 24, 27, 7, 39],
      joker: 10),
  JokerDraw(
      date: '2021-05-30',
      game: 'Joker',
      numbers: [40, 37, 42, 31, 21],
      joker: 16),
  JokerDraw(
      date: '2021-06-03',
      game: 'Joker',
      numbers: [45, 10, 14, 11, 37],
      joker: 7),
  JokerDraw(
      date: '2021-06-06',
      game: 'Joker',
      numbers: [45, 38, 40, 8, 32],
      joker: 10),
  JokerDraw(
      date: '2021-06-10',
      game: 'Joker',
      numbers: [24, 26, 40, 29, 1],
      joker: 14),
  JokerDraw(
      date: '2021-06-13',
      game: 'Joker',
      numbers: [19, 34, 18, 31, 6],
      joker: 18),
  JokerDraw(
      date: '2021-06-17',
      game: 'Joker',
      numbers: [30, 24, 16, 17, 22],
      joker: 19),
  JokerDraw(
      date: '2021-06-20',
      game: 'Joker',
      numbers: [30, 36, 21, 25, 42],
      joker: 1),
  JokerDraw(
      date: '2021-06-24', game: 'Joker', numbers: [26, 6, 39, 9, 33], joker: 5),
  JokerDraw(
      date: '2021-06-27',
      game: 'Joker',
      numbers: [36, 14, 40, 28, 13],
      joker: 4),
  JokerDraw(
      date: '2021-07-01',
      game: 'Joker',
      numbers: [17, 8, 43, 20, 29],
      joker: 14),
  JokerDraw(
      date: '2021-07-04',
      game: 'Joker',
      numbers: [6, 31, 25, 18, 11],
      joker: 3),
  JokerDraw(
      date: '2021-07-08',
      game: 'Joker',
      numbers: [24, 3, 29, 43, 15],
      joker: 6),
  JokerDraw(
      date: '2021-07-11',
      game: 'Joker',
      numbers: [4, 9, 30, 35, 33],
      joker: 13),
  JokerDraw(
      date: '2021-07-15', game: 'Joker', numbers: [4, 7, 38, 3, 24], joker: 12),
  JokerDraw(
      date: '2021-07-18', game: 'Joker', numbers: [31, 43, 1, 4, 16], joker: 7),
  JokerDraw(
      date: '2021-07-22',
      game: 'Joker',
      numbers: [24, 42, 20, 30, 25],
      joker: 14),
  JokerDraw(
      date: '2021-07-25',
      game: 'Joker',
      numbers: [32, 33, 14, 8, 29],
      joker: 20),
  JokerDraw(
      date: '2021-07-29',
      game: 'Joker',
      numbers: [21, 1, 34, 3, 43],
      joker: 10),
  JokerDraw(
      date: '2021-08-01',
      game: 'Joker',
      numbers: [15, 42, 26, 45, 1],
      joker: 13),
  JokerDraw(
      date: '2021-08-05',
      game: 'Joker',
      numbers: [1, 24, 26, 28, 27],
      joker: 7),
  JokerDraw(
      date: '2021-08-08',
      game: 'Joker',
      numbers: [12, 23, 19, 15, 3],
      joker: 13),
  JokerDraw(
      date: '2021-08-12',
      game: 'Joker',
      numbers: [28, 6, 11, 21, 40],
      joker: 18),
  JokerDraw(
      date: '2021-08-15',
      game: 'Joker',
      numbers: [33, 10, 31, 18, 28],
      joker: 8),
  JokerDraw(
      date: '2021-08-19',
      game: 'Joker',
      numbers: [13, 17, 25, 23, 16],
      joker: 8),
  JokerDraw(
      date: '2021-08-22',
      game: 'Joker',
      numbers: [28, 31, 32, 9, 27],
      joker: 19),
  JokerDraw(
      date: '2021-08-26',
      game: 'Joker',
      numbers: [37, 21, 6, 5, 29],
      joker: 18),
  JokerDraw(
      date: '2021-08-29',
      game: 'Joker',
      numbers: [43, 21, 32, 6, 5],
      joker: 19),
  JokerDraw(
      date: '2021-09-02',
      game: 'Joker',
      numbers: [29, 43, 1, 28, 36],
      joker: 3),
  JokerDraw(
      date: '2021-09-05',
      game: 'Joker',
      numbers: [38, 4, 21, 26, 15],
      joker: 3),
  JokerDraw(
      date: '2021-09-09',
      game: 'Joker',
      numbers: [12, 45, 36, 11, 44],
      joker: 6),
  JokerDraw(
      date: '2021-09-12',
      game: 'Joker',
      numbers: [11, 3, 21, 30, 2],
      joker: 15),
  JokerDraw(
      date: '2021-09-12',
      game: 'Joker',
      numbers: [14, 38, 40, 3, 28],
      joker: 10),
  JokerDraw(
      date: '2021-09-16',
      game: 'Joker',
      numbers: [31, 7, 34, 25, 29],
      joker: 2),
  JokerDraw(
      date: '2021-09-19',
      game: 'Joker',
      numbers: [23, 3, 38, 7, 15],
      joker: 19),
  JokerDraw(
      date: '2021-09-23',
      game: 'Joker',
      numbers: [8, 15, 13, 28, 23],
      joker: 4),
  JokerDraw(
      date: '2021-09-26', game: 'Joker', numbers: [16, 3, 2, 43, 6], joker: 20),
  JokerDraw(
      date: '2021-09-30', game: 'Joker', numbers: [31, 35, 5, 6, 9], joker: 2),
  JokerDraw(
      date: '2021-10-03',
      game: 'Joker',
      numbers: [4, 44, 41, 37, 9],
      joker: 10),
  JokerDraw(
      date: '2021-10-07',
      game: 'Joker',
      numbers: [35, 8, 32, 25, 26],
      joker: 2),
  JokerDraw(
      date: '2021-10-10',
      game: 'Joker',
      numbers: [19, 40, 2, 23, 12],
      joker: 16),
  JokerDraw(
      date: '2021-10-14',
      game: 'Joker',
      numbers: [25, 35, 45, 40, 8],
      joker: 19),
  JokerDraw(
      date: '2021-10-17',
      game: 'Joker',
      numbers: [20, 32, 33, 5, 31],
      joker: 4),
  JokerDraw(
      date: '2021-10-21',
      game: 'Joker',
      numbers: [2, 19, 18, 27, 39],
      joker: 20),
  JokerDraw(
      date: '2021-10-24',
      game: 'Joker',
      numbers: [6, 45, 23, 22, 17],
      joker: 13),
  JokerDraw(
      date: '2021-10-28',
      game: 'Joker',
      numbers: [21, 35, 17, 20, 27],
      joker: 17),
  JokerDraw(
      date: '2021-10-31',
      game: 'Joker',
      numbers: [28, 27, 1, 24, 10],
      joker: 12),
  JokerDraw(
      date: '2021-11-04', game: 'Joker', numbers: [6, 40, 5, 39, 25], joker: 4),
  JokerDraw(
      date: '2021-11-07',
      game: 'Joker',
      numbers: [14, 42, 13, 40, 3],
      joker: 8),
  JokerDraw(
      date: '2021-11-11',
      game: 'Joker',
      numbers: [36, 19, 25, 11, 23],
      joker: 2),
  JokerDraw(
      date: '2021-11-14',
      game: 'Joker',
      numbers: [3, 20, 23, 5, 14],
      joker: 17),
  JokerDraw(
      date: '2021-11-18',
      game: 'Joker',
      numbers: [36, 28, 35, 17, 32],
      joker: 12),
  JokerDraw(
      date: '2021-11-21',
      game: 'Joker',
      numbers: [28, 43, 11, 32, 18],
      joker: 10),
  JokerDraw(
      date: '2021-11-25',
      game: 'Joker',
      numbers: [17, 10, 19, 15, 8],
      joker: 7),
  JokerDraw(
      date: '2021-11-28',
      game: 'Joker',
      numbers: [31, 11, 17, 16, 2],
      joker: 6),
  JokerDraw(
      date: '2021-12-05',
      game: 'Joker',
      numbers: [8, 5, 30, 36, 17],
      joker: 13),
  JokerDraw(
      date: '2021-12-05',
      game: 'Joker',
      numbers: [25, 43, 11, 33, 20],
      joker: 15),
  JokerDraw(
      date: '2021-12-09',
      game: 'Joker',
      numbers: [39, 12, 28, 35, 5],
      joker: 2),
  JokerDraw(
      date: '2021-12-12',
      game: 'Joker',
      numbers: [45, 31, 14, 6, 4],
      joker: 16),
  JokerDraw(
      date: '2021-12-16',
      game: 'Joker',
      numbers: [14, 22, 15, 38, 17],
      joker: 17),
  JokerDraw(
      date: '2021-12-19', game: 'Joker', numbers: [8, 21, 27, 44, 3], joker: 7),
  JokerDraw(
      date: '2021-12-24',
      game: 'Joker',
      numbers: [15, 16, 36, 5, 29],
      joker: 20),
  JokerDraw(
      date: '2021-12-31',
      game: 'Joker',
      numbers: [42, 37, 17, 28, 18],
      joker: 2),
  JokerDraw(
      date: '2021-12-31',
      game: 'Joker',
      numbers: [14, 18, 35, 19, 25],
      joker: 16),
  JokerDraw(
      date: '2022-01-06',
      game: 'Joker',
      numbers: [41, 28, 16, 39, 20],
      joker: 1),
  JokerDraw(
      date: '2022-01-09',
      game: 'Joker',
      numbers: [33, 16, 23, 32, 22],
      joker: 2),
  JokerDraw(
      date: '2022-01-13',
      game: 'Joker',
      numbers: [3, 36, 19, 18, 1],
      joker: 19),
  JokerDraw(
      date: '2022-01-16', game: 'Joker', numbers: [45, 6, 10, 8, 29], joker: 6),
  JokerDraw(
      date: '2022-01-20',
      game: 'Joker',
      numbers: [30, 15, 2, 35, 29],
      joker: 10),
  JokerDraw(
      date: '2022-01-23',
      game: 'Joker',
      numbers: [35, 1, 45, 24, 23],
      joker: 2),
  JokerDraw(
      date: '2022-01-27',
      game: 'Joker',
      numbers: [10, 21, 43, 15, 20],
      joker: 11),
  JokerDraw(
      date: '2022-01-30',
      game: 'Joker',
      numbers: [43, 3, 5, 18, 31],
      joker: 11),
  JokerDraw(
      date: '2022-02-03',
      game: 'Joker',
      numbers: [38, 19, 28, 1, 12],
      joker: 3),
  JokerDraw(
      date: '2022-02-06', game: 'Joker', numbers: [9, 24, 19, 5, 27], joker: 1),
  JokerDraw(
      date: '2022-02-10',
      game: 'Joker',
      numbers: [24, 28, 29, 37, 32],
      joker: 8),
  JokerDraw(
      date: '2022-02-13',
      game: 'Joker',
      numbers: [34, 36, 23, 14, 1],
      joker: 15),
  JokerDraw(
      date: '2022-02-17',
      game: 'Joker',
      numbers: [38, 1, 34, 25, 28],
      joker: 6),
  JokerDraw(
      date: '2022-02-20',
      game: 'Joker',
      numbers: [32, 29, 20, 21, 22],
      joker: 12),
  JokerDraw(
      date: '2022-02-27',
      game: 'Joker',
      numbers: [15, 7, 27, 31, 32],
      joker: 6),
  JokerDraw(
      date: '2022-03-03', game: 'Joker', numbers: [10, 25, 2, 3, 7], joker: 1),
  JokerDraw(
      date: '2022-03-06', game: 'Joker', numbers: [7, 45, 4, 3, 2], joker: 7),
  JokerDraw(
      date: '2022-03-06',
      game: 'Joker',
      numbers: [13, 1, 12, 14, 20],
      joker: 1),
  JokerDraw(
      date: '2022-03-10',
      game: 'Joker',
      numbers: [20, 7, 1, 45, 24],
      joker: 17),
  JokerDraw(
      date: '2022-03-13',
      game: 'Joker',
      numbers: [37, 28, 5, 32, 2],
      joker: 11),
  JokerDraw(
      date: '2022-03-17', game: 'Joker', numbers: [3, 6, 41, 29, 24], joker: 9),
  JokerDraw(
      date: '2022-03-20', game: 'Joker', numbers: [17, 8, 1, 21, 19], joker: 1),
  JokerDraw(
      date: '2022-03-24',
      game: 'Joker',
      numbers: [4, 41, 22, 11, 33],
      joker: 8),
  JokerDraw(
      date: '2022-03-27',
      game: 'Joker',
      numbers: [15, 38, 41, 17, 6],
      joker: 5),
  JokerDraw(
      date: '2022-03-31',
      game: 'Joker',
      numbers: [14, 22, 30, 20, 12],
      joker: 9),
  JokerDraw(
      date: '2022-04-03',
      game: 'Joker',
      numbers: [21, 36, 22, 23, 45],
      joker: 20),
  JokerDraw(
      date: '2022-04-07',
      game: 'Joker',
      numbers: [39, 19, 13, 3, 36],
      joker: 9),
  JokerDraw(
      date: '2022-04-10', game: 'Joker', numbers: [21, 7, 43, 5, 35], joker: 4),
  JokerDraw(
      date: '2022-04-14',
      game: 'Joker',
      numbers: [42, 40, 8, 4, 10],
      joker: 10),
  JokerDraw(
      date: '2022-04-17',
      game: 'Joker',
      numbers: [26, 2, 19, 20, 8],
      joker: 16),
  JokerDraw(
      date: '2022-04-23',
      game: 'Joker',
      numbers: [35, 37, 44, 13, 3],
      joker: 3),
  JokerDraw(
      date: '2022-04-28',
      game: 'Joker',
      numbers: [35, 6, 16, 26, 43],
      joker: 5),
  JokerDraw(
      date: '2022-05-01',
      game: 'Joker',
      numbers: [38, 10, 14, 45, 16],
      joker: 11),
  JokerDraw(
      date: '2022-05-05',
      game: 'Joker',
      numbers: [30, 2, 4, 38, 29],
      joker: 12),
  JokerDraw(
      date: '2022-05-08',
      game: 'Joker',
      numbers: [8, 41, 28, 36, 21],
      joker: 16),
  JokerDraw(
      date: '2022-05-12',
      game: 'Joker',
      numbers: [18, 14, 44, 9, 31],
      joker: 15),
  JokerDraw(
      date: '2022-05-15',
      game: 'Joker',
      numbers: [26, 42, 35, 20, 13],
      joker: 12),
  JokerDraw(
      date: '2022-05-19',
      game: 'Joker',
      numbers: [34, 42, 24, 17, 39],
      joker: 15),
  JokerDraw(
      date: '2022-05-22',
      game: 'Joker',
      numbers: [20, 23, 37, 24, 35],
      joker: 19),
  JokerDraw(
      date: '2022-05-26',
      game: 'Joker',
      numbers: [21, 16, 3, 2, 39],
      joker: 17),
  JokerDraw(
      date: '2022-05-29',
      game: 'Joker',
      numbers: [45, 44, 21, 10, 39],
      joker: 8),
  JokerDraw(
      date: '2022-06-02',
      game: 'Joker',
      numbers: [23, 14, 3, 20, 28],
      joker: 9),
  JokerDraw(
      date: '2022-06-05',
      game: 'Joker',
      numbers: [22, 10, 28, 17, 19],
      joker: 7),
  JokerDraw(
      date: '2022-06-09',
      game: 'Joker',
      numbers: [10, 11, 45, 21, 1],
      joker: 6),
  JokerDraw(
      date: '2022-06-12',
      game: 'Joker',
      numbers: [34, 43, 25, 23, 31],
      joker: 19),
  JokerDraw(
      date: '2022-06-16',
      game: 'Joker',
      numbers: [17, 19, 31, 43, 10],
      joker: 9),
  JokerDraw(
      date: '2022-06-19',
      game: 'Joker',
      numbers: [14, 23, 15, 10, 36],
      joker: 16),
  JokerDraw(
      date: '2022-06-23',
      game: 'Joker',
      numbers: [22, 3, 45, 21, 10],
      joker: 15),
  JokerDraw(
      date: '2022-06-26',
      game: 'Joker',
      numbers: [7, 25, 26, 12, 18],
      joker: 2),
  JokerDraw(
      date: '2022-06-30',
      game: 'Joker',
      numbers: [26, 14, 22, 7, 19],
      joker: 17),
  JokerDraw(
      date: '2022-07-03', game: 'Joker', numbers: [28, 2, 7, 20, 5], joker: 9),
  JokerDraw(
      date: '2022-07-07', game: 'Joker', numbers: [14, 7, 6, 8, 37], joker: 13),
  JokerDraw(
      date: '2022-07-10', game: 'Joker', numbers: [2, 4, 39, 26, 20], joker: 7),
  JokerDraw(
      date: '2022-07-14',
      game: 'Joker',
      numbers: [39, 29, 20, 18, 41],
      joker: 16),
  JokerDraw(
      date: '2022-07-17',
      game: 'Joker',
      numbers: [43, 40, 33, 7, 4],
      joker: 16),
  JokerDraw(
      date: '2022-07-21',
      game: 'Joker',
      numbers: [37, 11, 39, 38, 22],
      joker: 4),
  JokerDraw(
      date: '2022-07-24',
      game: 'Joker',
      numbers: [22, 5, 13, 23, 20],
      joker: 19),
  JokerDraw(
      date: '2022-07-28',
      game: 'Joker',
      numbers: [27, 42, 17, 21, 2],
      joker: 2),
  JokerDraw(
      date: '2022-07-31',
      game: 'Joker',
      numbers: [14, 44, 28, 31, 25],
      joker: 13),
  JokerDraw(
      date: '2022-08-04',
      game: 'Joker',
      numbers: [39, 23, 25, 8, 31],
      joker: 1),
  JokerDraw(
      date: '2022-08-07', game: 'Joker', numbers: [41, 8, 45, 3, 34], joker: 7),
  JokerDraw(
      date: '2022-08-11', game: 'Joker', numbers: [5, 9, 16, 22, 43], joker: 1),
  JokerDraw(
      date: '2022-08-14', game: 'Joker', numbers: [9, 1, 41, 13, 3], joker: 2),
  JokerDraw(
      date: '2022-08-18',
      game: 'Joker',
      numbers: [39, 26, 5, 43, 40],
      joker: 19),
  JokerDraw(
      date: '2022-08-21', game: 'Joker', numbers: [8, 32, 1, 43, 5], joker: 11),
  JokerDraw(
      date: '2022-08-25',
      game: 'Joker',
      numbers: [24, 15, 5, 8, 34],
      joker: 14),
  JokerDraw(
      date: '2022-08-28',
      game: 'Joker',
      numbers: [31, 18, 39, 20, 13],
      joker: 2),
  JokerDraw(
      date: '2022-09-01',
      game: 'Joker',
      numbers: [5, 28, 19, 22, 29],
      joker: 12),
  JokerDraw(
      date: '2022-09-04',
      game: 'Joker',
      numbers: [21, 40, 16, 38, 44],
      joker: 6),
  JokerDraw(
      date: '2022-09-08',
      game: 'Joker',
      numbers: [20, 3, 28, 16, 38],
      joker: 20),
  JokerDraw(
      date: '2022-09-11', game: 'Joker', numbers: [2, 42, 37, 3, 44], joker: 1),
  JokerDraw(
      date: '2022-09-11',
      game: 'Joker',
      numbers: [11, 24, 3, 22, 26],
      joker: 4),
  JokerDraw(
      date: '2022-09-15',
      game: 'Joker',
      numbers: [17, 34, 15, 3, 33],
      joker: 9),
  JokerDraw(
      date: '2022-09-18',
      game: 'Joker',
      numbers: [26, 16, 35, 6, 29],
      joker: 13),
  JokerDraw(
      date: '2022-09-22',
      game: 'Joker',
      numbers: [16, 1, 26, 25, 43],
      joker: 15),
  JokerDraw(
      date: '2022-09-25',
      game: 'Joker',
      numbers: [35, 3, 14, 7, 19],
      joker: 14),
  JokerDraw(
      date: '2022-09-29',
      game: 'Joker',
      numbers: [14, 33, 38, 28, 26],
      joker: 20),
  JokerDraw(
      date: '2022-10-02',
      game: 'Joker',
      numbers: [25, 31, 9, 37, 34],
      joker: 7),
  JokerDraw(
      date: '2022-10-06',
      game: 'Joker',
      numbers: [40, 5, 28, 7, 36],
      joker: 10),
  JokerDraw(
      date: '2022-10-09', game: 'Joker', numbers: [17, 10, 3, 29, 4], joker: 2),
  JokerDraw(
      date: '2022-10-13',
      game: 'Joker',
      numbers: [14, 31, 24, 39, 12],
      joker: 13),
  JokerDraw(
      date: '2022-10-16',
      game: 'Joker',
      numbers: [9, 20, 39, 4, 13],
      joker: 20),
  JokerDraw(
      date: '2022-10-20',
      game: 'Joker',
      numbers: [29, 34, 42, 16, 45],
      joker: 10),
  JokerDraw(
      date: '2022-10-23', game: 'Joker', numbers: [34, 3, 40, 6, 25], joker: 9),
  JokerDraw(
      date: '2022-10-27', game: 'Joker', numbers: [25, 6, 15, 8, 34], joker: 1),
  JokerDraw(
      date: '2022-10-30', game: 'Joker', numbers: [1, 43, 5, 28, 45], joker: 6),
  JokerDraw(
      date: '2022-11-03',
      game: 'Joker',
      numbers: [28, 26, 42, 15, 36],
      joker: 15),
  JokerDraw(
      date: '2022-11-06',
      game: 'Joker',
      numbers: [1, 32, 10, 12, 23],
      joker: 1),
  JokerDraw(
      date: '2022-11-10',
      game: 'Joker',
      numbers: [40, 38, 13, 44, 31],
      joker: 10),
  JokerDraw(
      date: '2022-11-13',
      game: 'Joker',
      numbers: [9, 27, 35, 40, 21],
      joker: 19),
  JokerDraw(
      date: '2022-11-17',
      game: 'Joker',
      numbers: [16, 27, 4, 26, 29],
      joker: 16),
  JokerDraw(
      date: '2022-11-20',
      game: 'Joker',
      numbers: [15, 8, 30, 42, 6],
      joker: 15),
  JokerDraw(
      date: '2022-11-24',
      game: 'Joker',
      numbers: [45, 1, 28, 8, 39],
      joker: 17),
  JokerDraw(
      date: '2022-11-27',
      game: 'Joker',
      numbers: [20, 24, 30, 19, 35],
      joker: 9),
  JokerDraw(
      date: '2022-12-04',
      game: 'Joker',
      numbers: [8, 19, 41, 17, 18],
      joker: 8),
  JokerDraw(
      date: '2022-12-08',
      game: 'Joker',
      numbers: [29, 31, 14, 40, 36],
      joker: 8),
  JokerDraw(
      date: '2022-12-11',
      game: 'Joker',
      numbers: [28, 27, 13, 19, 2],
      joker: 19),
  JokerDraw(
      date: '2022-12-15', game: 'Joker', numbers: [1, 20, 19, 5, 6], joker: 9),
  JokerDraw(
      date: '2022-12-18',
      game: 'Joker',
      numbers: [1, 28, 44, 8, 29],
      joker: 15),
  JokerDraw(
      date: '2022-12-24',
      game: 'Joker',
      numbers: [30, 32, 27, 18, 39],
      joker: 18),
  JokerDraw(
      date: '2022-12-31',
      game: 'Joker',
      numbers: [3, 35, 30, 16, 11],
      joker: 19),
  JokerDraw(
      date: '2022-12-31',
      game: 'Joker',
      numbers: [34, 7, 31, 13, 12],
      joker: 13),
  JokerDraw(
      date: '2023-01-05',
      game: 'Joker',
      numbers: [10, 26, 21, 36, 35],
      joker: 18),
  JokerDraw(
      date: '2023-01-08', game: 'Joker', numbers: [6, 7, 10, 3, 1], joker: 4),
  JokerDraw(
      date: '2023-01-12',
      game: 'Joker',
      numbers: [7, 44, 20, 37, 3],
      joker: 13),
  JokerDraw(
      date: '2023-01-15',
      game: 'Joker',
      numbers: [8, 21, 34, 11, 44],
      joker: 12),
  JokerDraw(
      date: '2023-01-19',
      game: 'Joker',
      numbers: [6, 9, 38, 14, 45],
      joker: 12),
  JokerDraw(
      date: '2023-01-22', game: 'Joker', numbers: [2, 31, 7, 39, 18], joker: 7),
  JokerDraw(
      date: '2023-01-26',
      game: 'Joker',
      numbers: [44, 19, 14, 2, 20],
      joker: 11),
  JokerDraw(
      date: '2023-01-29',
      game: 'Joker',
      numbers: [13, 10, 33, 31, 28],
      joker: 20),
  JokerDraw(
      date: '2023-02-02', game: 'Joker', numbers: [16, 13, 2, 3, 7], joker: 15),
  JokerDraw(
      date: '2023-02-05',
      game: 'Joker',
      numbers: [33, 39, 5, 20, 19],
      joker: 12),
  JokerDraw(
      date: '2023-02-09',
      game: 'Joker',
      numbers: [28, 19, 30, 9, 20],
      joker: 9),
  JokerDraw(
      date: '2023-02-12',
      game: 'Joker',
      numbers: [17, 45, 35, 13, 3],
      joker: 3),
  JokerDraw(
      date: '2023-02-16',
      game: 'Joker',
      numbers: [19, 44, 36, 20, 4],
      joker: 20),
  JokerDraw(
      date: '2023-02-19',
      game: 'Joker',
      numbers: [5, 18, 23, 31, 30],
      joker: 3),
  JokerDraw(
      date: '2023-02-23',
      game: 'Joker',
      numbers: [37, 15, 6, 8, 11],
      joker: 17),
  JokerDraw(
      date: '2023-02-26', game: 'Joker', numbers: [45, 27, 7, 5, 13], joker: 7),
  JokerDraw(
      date: '2023-03-02', game: 'Joker', numbers: [11, 8, 38, 7, 31], joker: 9),
  JokerDraw(
      date: '2023-03-05',
      game: 'Joker',
      numbers: [35, 33, 16, 36, 6],
      joker: 13),
  JokerDraw(
      date: '2023-03-09',
      game: 'Joker',
      numbers: [30, 18, 43, 22, 14],
      joker: 16),
  JokerDraw(
      date: '2023-03-12',
      game: 'Joker',
      numbers: [33, 35, 16, 27, 18],
      joker: 3),
  JokerDraw(
      date: '2023-03-12',
      game: 'Joker',
      numbers: [29, 6, 43, 28, 23],
      joker: 17),
  JokerDraw(
      date: '2023-03-16',
      game: 'Joker',
      numbers: [3, 26, 44, 30, 23],
      joker: 15),
  JokerDraw(
      date: '2023-03-19',
      game: 'Joker',
      numbers: [45, 6, 10, 15, 2],
      joker: 19),
  JokerDraw(
      date: '2023-03-23',
      game: 'Joker',
      numbers: [36, 19, 7, 33, 15],
      joker: 16),
  JokerDraw(
      date: '2023-03-26',
      game: 'Joker',
      numbers: [5, 25, 3, 28, 29],
      joker: 12),
  JokerDraw(
      date: '2023-03-30', game: 'Joker', numbers: [3, 8, 13, 2, 34], joker: 16),
  JokerDraw(
      date: '2023-04-02',
      game: 'Joker',
      numbers: [27, 22, 24, 35, 40],
      joker: 10),
  JokerDraw(
      date: '2023-04-06',
      game: 'Joker',
      numbers: [41, 1, 16, 2, 35],
      joker: 13),
  JokerDraw(
      date: '2023-04-09',
      game: 'Joker',
      numbers: [29, 23, 10, 20, 2],
      joker: 18),
  JokerDraw(
      date: '2023-04-15',
      game: 'Joker',
      numbers: [20, 32, 6, 25, 24],
      joker: 7),
  JokerDraw(
      date: '2023-04-15',
      game: 'Joker',
      numbers: [19, 44, 5, 40, 3],
      joker: 18),
  JokerDraw(
      date: '2023-04-20',
      game: 'Joker',
      numbers: [1, 12, 34, 42, 16],
      joker: 17),
  JokerDraw(
      date: '2023-04-23',
      game: 'Joker',
      numbers: [24, 33, 12, 26, 16],
      joker: 8),
  JokerDraw(
      date: '2023-04-27',
      game: 'Joker',
      numbers: [13, 17, 31, 4, 19],
      joker: 2),
  JokerDraw(
      date: '2023-04-30',
      game: 'Joker',
      numbers: [14, 36, 23, 7, 16],
      joker: 15),
  JokerDraw(
      date: '2023-05-04', game: 'Joker', numbers: [8, 32, 38, 2, 23], joker: 5),
  JokerDraw(
      date: '2023-05-07',
      game: 'Joker',
      numbers: [10, 42, 18, 23, 19],
      joker: 4),
  JokerDraw(
      date: '2023-05-11',
      game: 'Joker',
      numbers: [41, 13, 7, 5, 24],
      joker: 11),
  JokerDraw(
      date: '2023-05-14',
      game: 'Joker',
      numbers: [18, 12, 2, 28, 14],
      joker: 10),
  JokerDraw(
      date: '2023-05-18',
      game: 'Joker',
      numbers: [34, 14, 17, 43, 37],
      joker: 13),
  JokerDraw(
      date: '2023-05-21',
      game: 'Joker',
      numbers: [14, 32, 31, 38, 22],
      joker: 7),
  JokerDraw(
      date: '2023-05-25',
      game: 'Joker',
      numbers: [36, 22, 20, 6, 8],
      joker: 13),
  JokerDraw(
      date: '2023-05-28',
      game: 'Joker',
      numbers: [31, 12, 1, 13, 8],
      joker: 14),
  JokerDraw(
      date: '2023-06-01',
      game: 'Joker',
      numbers: [14, 42, 39, 34, 45],
      joker: 15),
  JokerDraw(
      date: '2023-06-04',
      game: 'Joker',
      numbers: [37, 32, 45, 17, 29],
      joker: 2),
  JokerDraw(
      date: '2023-06-08',
      game: 'Joker',
      numbers: [25, 39, 2, 44, 43],
      joker: 16),
  JokerDraw(
      date: '2023-06-11',
      game: 'Joker',
      numbers: [19, 14, 41, 34, 21],
      joker: 4),
  JokerDraw(
      date: '2023-06-15', game: 'Joker', numbers: [6, 19, 43, 1, 37], joker: 4),
  JokerDraw(
      date: '2023-06-18',
      game: 'Joker',
      numbers: [18, 3, 45, 10, 44],
      joker: 11),
  JokerDraw(
      date: '2023-06-22',
      game: 'Joker',
      numbers: [45, 44, 18, 5, 10],
      joker: 3),
  JokerDraw(
      date: '2023-06-25',
      game: 'Joker',
      numbers: [1, 4, 29, 11, 45],
      joker: 15),
  JokerDraw(
      date: '2023-06-29',
      game: 'Joker',
      numbers: [39, 11, 14, 21, 42],
      joker: 3),
  JokerDraw(
      date: '2023-07-02',
      game: 'Joker',
      numbers: [42, 1, 6, 34, 45],
      joker: 17),
  JokerDraw(
      date: '2023-07-06',
      game: 'Joker',
      numbers: [2, 13, 43, 12, 42],
      joker: 9),
  JokerDraw(
      date: '2023-07-09',
      game: 'Joker',
      numbers: [17, 18, 30, 26, 37],
      joker: 19),
  JokerDraw(
      date: '2023-07-13',
      game: 'Joker',
      numbers: [8, 25, 5, 37, 17],
      joker: 16),
  JokerDraw(
      date: '2023-07-16',
      game: 'Joker',
      numbers: [25, 16, 23, 28, 36],
      joker: 2),
  JokerDraw(
      date: '2023-07-20',
      game: 'Joker',
      numbers: [45, 27, 39, 17, 13],
      joker: 7),
  JokerDraw(
      date: '2023-07-23',
      game: 'Joker',
      numbers: [33, 1, 13, 8, 10],
      joker: 20),
  JokerDraw(
      date: '2023-07-27', game: 'Joker', numbers: [3, 32, 13, 22, 4], joker: 8),
  JokerDraw(
      date: '2023-07-30',
      game: 'Joker',
      numbers: [17, 26, 23, 4, 41],
      joker: 20),
  JokerDraw(
      date: '2023-08-03',
      game: 'Joker',
      numbers: [44, 34, 18, 36, 30],
      joker: 20),
  JokerDraw(
      date: '2023-08-06',
      game: 'Joker',
      numbers: [2, 34, 27, 44, 45],
      joker: 20),
  JokerDraw(
      date: '2023-08-10',
      game: 'Joker',
      numbers: [40, 3, 29, 39, 42],
      joker: 17),
  JokerDraw(
      date: '2023-08-13',
      game: 'Joker',
      numbers: [28, 36, 39, 11, 34],
      joker: 3),
  JokerDraw(
      date: '2023-08-17',
      game: 'Joker',
      numbers: [20, 28, 2, 14, 29],
      joker: 14),
  JokerDraw(
      date: '2023-08-20',
      game: 'Joker',
      numbers: [44, 7, 41, 40, 30],
      joker: 11),
  JokerDraw(
      date: '2023-08-24', game: 'Joker', numbers: [20, 7, 6, 35, 3], joker: 2),
  JokerDraw(
      date: '2023-08-27',
      game: 'Joker',
      numbers: [22, 7, 33, 4, 34],
      joker: 16),
  JokerDraw(
      date: '2023-08-31',
      game: 'Joker',
      numbers: [30, 42, 33, 40, 43],
      joker: 15),
  JokerDraw(
      date: '2023-09-03',
      game: 'Joker',
      numbers: [23, 27, 43, 14, 29],
      joker: 14),
  JokerDraw(
      date: '2023-09-07',
      game: 'Joker',
      numbers: [29, 41, 44, 4, 11],
      joker: 19),
  JokerDraw(
      date: '2023-09-10',
      game: 'Joker',
      numbers: [44, 25, 13, 23, 39],
      joker: 6),
  JokerDraw(
      date: '2023-09-14',
      game: 'Joker',
      numbers: [40, 36, 42, 33, 12],
      joker: 13),
  JokerDraw(
      date: '2023-09-17', game: 'Joker', numbers: [3, 11, 26, 12, 8], joker: 6),
  JokerDraw(
      date: '2023-09-17',
      game: 'Joker',
      numbers: [9, 40, 19, 35, 13],
      joker: 19),
  JokerDraw(
      date: '2023-09-21',
      game: 'Joker',
      numbers: [30, 34, 7, 28, 10],
      joker: 6),
  JokerDraw(
      date: '2023-09-24',
      game: 'Joker',
      numbers: [36, 4, 39, 40, 33],
      joker: 19),
  JokerDraw(
      date: '2023-09-28',
      game: 'Joker',
      numbers: [11, 33, 9, 20, 35],
      joker: 16),
  JokerDraw(
      date: '2023-10-01',
      game: 'Joker',
      numbers: [9, 15, 38, 20, 26],
      joker: 5),
  JokerDraw(
      date: '2023-10-05',
      game: 'Joker',
      numbers: [22, 8, 32, 34, 10],
      joker: 19),
  JokerDraw(
      date: '2023-10-08', game: 'Joker', numbers: [34, 7, 44, 35, 9], joker: 8),
  JokerDraw(
      date: '2023-10-12', game: 'Joker', numbers: [3, 17, 4, 5, 19], joker: 4),
  JokerDraw(
      date: '2023-10-15',
      game: 'Joker',
      numbers: [33, 30, 39, 1, 38],
      joker: 7),
  JokerDraw(
      date: '2023-10-19',
      game: 'Joker',
      numbers: [37, 42, 27, 7, 36],
      joker: 4),
  JokerDraw(
      date: '2023-10-22',
      game: 'Joker',
      numbers: [42, 15, 44, 28, 37],
      joker: 19),
  JokerDraw(
      date: '2023-10-26',
      game: 'Joker',
      numbers: [42, 34, 21, 23, 36],
      joker: 12),
  JokerDraw(
      date: '2023-10-29',
      game: 'Joker',
      numbers: [30, 27, 4, 25, 12],
      joker: 13),
  JokerDraw(
      date: '2023-11-02',
      game: 'Joker',
      numbers: [38, 12, 8, 44, 7],
      joker: 12),
  JokerDraw(
      date: '2023-11-05',
      game: 'Joker',
      numbers: [3, 23, 1, 24, 25],
      joker: 12),
  JokerDraw(
      date: '2023-11-09',
      game: 'Joker',
      numbers: [29, 27, 35, 15, 6],
      joker: 16),
  JokerDraw(
      date: '2023-11-12',
      game: 'Joker',
      numbers: [9, 12, 41, 35, 24],
      joker: 5),
  JokerDraw(
      date: '2023-11-16', game: 'Joker', numbers: [3, 2, 4, 39, 28], joker: 17),
  JokerDraw(
      date: '2023-11-19',
      game: 'Joker',
      numbers: [27, 13, 4, 15, 11],
      joker: 10),
  JokerDraw(
      date: '2023-11-23',
      game: 'Joker',
      numbers: [27, 41, 2, 26, 36],
      joker: 11),
  JokerDraw(
      date: '2023-11-26',
      game: 'Joker',
      numbers: [13, 4, 23, 26, 33],
      joker: 15),
  JokerDraw(
      date: '2023-12-03',
      game: 'Joker',
      numbers: [4, 12, 14, 19, 29],
      joker: 6),
  JokerDraw(
      date: '2023-12-03',
      game: 'Joker',
      numbers: [3, 12, 18, 27, 33],
      joker: 12),
  JokerDraw(
      date: '2023-12-07',
      game: 'Joker',
      numbers: [12, 29, 10, 16, 37],
      joker: 17),
  JokerDraw(
      date: '2023-12-10',
      game: 'Joker',
      numbers: [33, 6, 18, 43, 26],
      joker: 14),
  JokerDraw(
      date: '2023-12-14',
      game: 'Joker',
      numbers: [19, 5, 2, 44, 29],
      joker: 14),
  JokerDraw(
      date: '2023-12-17',
      game: 'Joker',
      numbers: [17, 16, 36, 41, 14],
      joker: 19),
  JokerDraw(
      date: '2023-12-21', game: 'Joker', numbers: [16, 29, 1, 9, 24], joker: 8),
  JokerDraw(
      date: '2023-12-24',
      game: 'Joker',
      numbers: [19, 44, 21, 4, 22],
      joker: 14),
  JokerDraw(
      date: '2023-12-31',
      game: 'Joker',
      numbers: [13, 43, 35, 37, 6],
      joker: 18),
  JokerDraw(
      date: '2023-12-31',
      game: 'Joker',
      numbers: [5, 24, 28, 15, 41],
      joker: 4),
  JokerDraw(
      date: '2024-01-04', game: 'Joker', numbers: [3, 14, 26, 41, 7], joker: 8),
  JokerDraw(
      date: '2024-01-07',
      game: 'Joker',
      numbers: [45, 23, 15, 9, 7],
      joker: 19),
  JokerDraw(
      date: '2024-01-11',
      game: 'Joker',
      numbers: [30, 27, 37, 24, 28],
      joker: 10),
  JokerDraw(
      date: '2024-01-14',
      game: 'Joker',
      numbers: [1, 6, 26, 34, 15],
      joker: 20),
  JokerDraw(
      date: '2024-01-18',
      game: 'Joker',
      numbers: [32, 18, 17, 3, 15],
      joker: 17),
  JokerDraw(
      date: '2024-01-21',
      game: 'Joker',
      numbers: [16, 2, 32, 37, 12],
      joker: 9),
  JokerDraw(
      date: '2024-01-25',
      game: 'Joker',
      numbers: [22, 33, 26, 12, 15],
      joker: 15),
  JokerDraw(
      date: '2024-01-28',
      game: 'Joker',
      numbers: [21, 25, 3, 15, 17],
      joker: 13),
  JokerDraw(
      date: '2024-02-01',
      game: 'Joker',
      numbers: [35, 7, 15, 23, 26],
      joker: 8),
  JokerDraw(
      date: '2024-02-04',
      game: 'Joker',
      numbers: [16, 2, 30, 15, 19],
      joker: 18),
  JokerDraw(
      date: '2024-02-08',
      game: 'Joker',
      numbers: [25, 19, 39, 32, 34],
      joker: 17),
  JokerDraw(
      date: '2024-02-11',
      game: 'Joker',
      numbers: [26, 11, 22, 40, 44],
      joker: 10),
  JokerDraw(
      date: '2024-02-15',
      game: 'Joker',
      numbers: [43, 19, 23, 17, 31],
      joker: 2),
  JokerDraw(
      date: '2024-02-18', game: 'Joker', numbers: [36, 32, 35, 8, 9], joker: 6),
  JokerDraw(
      date: '2024-02-22',
      game: 'Joker',
      numbers: [23, 27, 26, 7, 33],
      joker: 10),
  JokerDraw(
      date: '2024-02-25',
      game: 'Joker',
      numbers: [28, 11, 24, 26, 31],
      joker: 20),
  JokerDraw(
      date: '2024-02-29',
      game: 'Joker',
      numbers: [1, 18, 21, 29, 14],
      joker: 13),
  JokerDraw(
      date: '2024-03-03',
      game: 'Joker',
      numbers: [32, 41, 23, 18, 39],
      joker: 11),
  JokerDraw(
      date: '2024-03-07', game: 'Joker', numbers: [29, 27, 7, 6, 8], joker: 18),
  JokerDraw(
      date: '2024-03-10',
      game: 'Joker',
      numbers: [22, 19, 39, 20, 11],
      joker: 1),
  JokerDraw(
      date: '2024-03-10',
      game: 'Joker',
      numbers: [29, 20, 4, 2, 37],
      joker: 14),
  JokerDraw(
      date: '2024-03-14', game: 'Joker', numbers: [2, 25, 30, 13, 8], joker: 2),
  JokerDraw(
      date: '2024-03-17',
      game: 'Joker',
      numbers: [35, 11, 10, 33, 7],
      joker: 12),
  JokerDraw(
      date: '2024-03-21',
      game: 'Joker',
      numbers: [41, 35, 45, 5, 32],
      joker: 20),
  JokerDraw(
      date: '2024-03-24',
      game: 'Joker',
      numbers: [28, 3, 26, 45, 10],
      joker: 2),
  JokerDraw(
      date: '2024-03-28',
      game: 'Joker',
      numbers: [34, 16, 9, 10, 36],
      joker: 7),
  JokerDraw(
      date: '2024-03-31',
      game: 'Joker',
      numbers: [26, 28, 24, 20, 32],
      joker: 13),
  JokerDraw(
      date: '2024-04-04',
      game: 'Joker',
      numbers: [29, 8, 30, 38, 20],
      joker: 16),
  JokerDraw(
      date: '2024-04-07',
      game: 'Joker',
      numbers: [33, 18, 19, 25, 10],
      joker: 16),
  JokerDraw(
      date: '2024-04-11',
      game: 'Joker',
      numbers: [15, 31, 3, 21, 37],
      joker: 15),
  JokerDraw(
      date: '2024-04-14',
      game: 'Joker',
      numbers: [22, 39, 18, 19, 36],
      joker: 9),
  JokerDraw(
      date: '2024-04-18',
      game: 'Joker',
      numbers: [42, 6, 44, 17, 26],
      joker: 14),
  JokerDraw(
      date: '2024-04-21',
      game: 'Joker',
      numbers: [26, 14, 11, 1, 12],
      joker: 18),
  JokerDraw(
      date: '2024-04-25',
      game: 'Joker',
      numbers: [8, 44, 28, 12, 10],
      joker: 8),
  JokerDraw(
      date: '2024-04-28',
      game: 'Joker',
      numbers: [35, 37, 24, 34, 27],
      joker: 2),
  JokerDraw(
      date: '2024-05-04',
      game: 'Joker',
      numbers: [5, 28, 17, 15, 12],
      joker: 12),
  JokerDraw(
      date: '2024-05-04',
      game: 'Joker',
      numbers: [41, 40, 34, 15, 2],
      joker: 12),
  JokerDraw(
      date: '2024-05-09',
      game: 'Joker',
      numbers: [23, 45, 34, 4, 38],
      joker: 9),
  JokerDraw(
      date: '2024-05-12', game: 'Joker', numbers: [5, 14, 8, 37, 40], joker: 7),
  JokerDraw(
      date: '2024-05-16', game: 'Joker', numbers: [18, 41, 9, 4, 6], joker: 8),
  JokerDraw(
      date: '2024-05-19',
      game: 'Joker',
      numbers: [6, 19, 33, 28, 45],
      joker: 15),
  JokerDraw(
      date: '2024-05-23',
      game: 'Joker',
      numbers: [35, 38, 18, 7, 29],
      joker: 20),
  JokerDraw(
      date: '2024-05-26',
      game: 'Joker',
      numbers: [38, 32, 45, 28, 9],
      joker: 8),
  JokerDraw(
      date: '2024-05-30',
      game: 'Joker',
      numbers: [41, 14, 18, 30, 15],
      joker: 7),
  JokerDraw(
      date: '2024-06-02',
      game: 'Joker',
      numbers: [34, 24, 13, 1, 23],
      joker: 3),
  JokerDraw(
      date: '2024-06-06',
      game: 'Joker',
      numbers: [5, 41, 13, 17, 25],
      joker: 9),
  JokerDraw(
      date: '2024-06-09',
      game: 'Joker',
      numbers: [13, 31, 28, 32, 29],
      joker: 18),
  JokerDraw(
      date: '2024-06-13',
      game: 'Joker',
      numbers: [12, 32, 16, 15, 11],
      joker: 12),
  JokerDraw(
      date: '2024-06-16',
      game: 'Joker',
      numbers: [24, 19, 37, 22, 6],
      joker: 16),
  JokerDraw(
      date: '2024-06-20',
      game: 'Joker',
      numbers: [17, 36, 45, 33, 20],
      joker: 18),
  JokerDraw(
      date: '2024-06-23',
      game: 'Joker',
      numbers: [1, 36, 28, 16, 10],
      joker: 16),
  JokerDraw(
      date: '2024-06-27',
      game: 'Joker',
      numbers: [16, 1, 10, 20, 13],
      joker: 8),
  JokerDraw(
      date: '2024-06-30', game: 'Joker', numbers: [9, 26, 41, 1, 7], joker: 1),
  JokerDraw(
      date: '2024-07-04',
      game: 'Joker',
      numbers: [26, 13, 31, 2, 11],
      joker: 3),
  JokerDraw(
      date: '2024-07-07',
      game: 'Joker',
      numbers: [8, 39, 40, 12, 20],
      joker: 2),
  JokerDraw(
      date: '2024-07-11', game: 'Joker', numbers: [5, 6, 42, 13, 19], joker: 1),
  JokerDraw(
      date: '2024-07-14',
      game: 'Joker',
      numbers: [43, 7, 36, 23, 45],
      joker: 10),
  JokerDraw(
      date: '2024-07-18', game: 'Joker', numbers: [21, 8, 1, 7, 17], joker: 12),
  JokerDraw(
      date: '2024-07-21',
      game: 'Joker',
      numbers: [12, 41, 14, 36, 9],
      joker: 9),
  JokerDraw(
      date: '2024-07-25', game: 'Joker', numbers: [5, 17, 2, 9, 43], joker: 6),
  JokerDraw(
      date: '2024-07-28',
      game: 'Joker',
      numbers: [17, 25, 36, 13, 35],
      joker: 13),
  JokerDraw(
      date: '2024-08-01',
      game: 'Joker',
      numbers: [12, 29, 31, 27, 6],
      joker: 8),
  JokerDraw(
      date: '2024-08-04',
      game: 'Joker',
      numbers: [35, 42, 3, 12, 30],
      joker: 3),
  JokerDraw(
      date: '2024-08-08',
      game: 'Joker',
      numbers: [36, 11, 16, 2, 31],
      joker: 18),
  JokerDraw(
      date: '2024-08-11',
      game: 'Joker',
      numbers: [5, 37, 7, 10, 40],
      joker: 16),
  JokerDraw(
      date: '2024-08-15',
      game: 'Joker',
      numbers: [1, 45, 25, 23, 6],
      joker: 20),
  JokerDraw(
      date: '2024-08-18',
      game: 'Joker',
      numbers: [30, 26, 1, 36, 29],
      joker: 13),
  JokerDraw(
      date: '2024-08-22',
      game: 'Joker',
      numbers: [25, 11, 40, 10, 32],
      joker: 12),
  JokerDraw(
      date: '2024-08-25',
      game: 'Joker',
      numbers: [28, 45, 18, 27, 15],
      joker: 20),
  JokerDraw(
      date: '2024-08-29', game: 'Joker', numbers: [13, 7, 9, 28, 36], joker: 5),
  JokerDraw(
      date: '2024-09-01',
      game: 'Joker',
      numbers: [17, 35, 41, 44, 45],
      joker: 16),
  JokerDraw(
      date: '2024-09-05', game: 'Joker', numbers: [22, 1, 7, 8, 27], joker: 9),
  JokerDraw(
      date: '2024-09-08',
      game: 'Joker',
      numbers: [9, 35, 45, 33, 27],
      joker: 5),
  JokerDraw(
      date: '2024-09-12',
      game: 'Joker',
      numbers: [28, 31, 33, 12, 4],
      joker: 5),
  JokerDraw(
      date: '2024-09-15',
      game: 'Joker',
      numbers: [17, 41, 14, 23, 16],
      joker: 6),
  JokerDraw(
      date: '2024-09-15',
      game: 'Joker',
      numbers: [32, 4, 23, 39, 29],
      joker: 5),
  JokerDraw(
      date: '2024-09-19',
      game: 'Joker',
      numbers: [15, 40, 33, 19, 41],
      joker: 6),
  JokerDraw(
      date: '2024-09-22',
      game: 'Joker',
      numbers: [15, 6, 27, 29, 28],
      joker: 17),
  JokerDraw(
      date: '2024-09-26',
      game: 'Joker',
      numbers: [29, 20, 27, 31, 36],
      joker: 4),
  JokerDraw(
      date: '2024-09-29',
      game: 'Joker',
      numbers: [18, 17, 5, 37, 15],
      joker: 15),
  JokerDraw(
      date: '2024-10-03',
      game: 'Joker',
      numbers: [15, 25, 22, 31, 17],
      joker: 10),
  JokerDraw(
      date: '2024-10-06',
      game: 'Joker',
      numbers: [15, 42, 4, 18, 28],
      joker: 17),
  JokerDraw(
      date: '2024-10-10',
      game: 'Joker',
      numbers: [19, 4, 22, 12, 35],
      joker: 8),
  JokerDraw(
      date: '2024-10-13',
      game: 'Joker',
      numbers: [6, 27, 17, 12, 44],
      joker: 5),
  JokerDraw(
      date: '2024-10-17', game: 'Joker', numbers: [6, 30, 23, 26, 7], joker: 7),
  JokerDraw(
      date: '2024-10-20',
      game: 'Joker',
      numbers: [18, 26, 5, 38, 14],
      joker: 11),
  JokerDraw(
      date: '2024-10-24',
      game: 'Joker',
      numbers: [24, 1, 17, 39, 36],
      joker: 15),
  JokerDraw(
      date: '2024-10-27',
      game: 'Joker',
      numbers: [14, 42, 43, 22, 10],
      joker: 4),
  JokerDraw(
      date: '2024-10-31',
      game: 'Joker',
      numbers: [14, 30, 38, 44, 2],
      joker: 2),
  JokerDraw(
      date: '2024-11-03',
      game: 'Joker',
      numbers: [41, 15, 18, 16, 7],
      joker: 2),
  JokerDraw(
      date: '2024-11-07',
      game: 'Joker',
      numbers: [26, 13, 30, 16, 38],
      joker: 7),
  JokerDraw(
      date: '2024-11-10',
      game: 'Joker',
      numbers: [31, 40, 18, 11, 8],
      joker: 19),
  JokerDraw(
      date: '2024-11-14', game: 'Joker', numbers: [14, 5, 13, 45, 6], joker: 4),
  JokerDraw(
      date: '2024-11-17',
      game: 'Joker',
      numbers: [1, 38, 24, 15, 42],
      joker: 10),
  JokerDraw(
      date: '2024-11-21',
      game: 'Joker',
      numbers: [11, 43, 13, 39, 21],
      joker: 6),
  JokerDraw(
      date: '2024-11-24', game: 'Joker', numbers: [9, 22, 41, 7, 32], joker: 1),
  JokerDraw(
      date: '2024-11-28', game: 'Joker', numbers: [38, 7, 36, 6, 5], joker: 3),
  JokerDraw(
      date: '2024-12-01',
      game: 'Joker',
      numbers: [16, 36, 35, 4, 13],
      joker: 9),
  JokerDraw(
      date: '2024-12-01',
      game: 'Joker',
      numbers: [37, 44, 29, 11, 20],
      joker: 7),
  JokerDraw(
      date: '2024-12-05',
      game: 'Joker',
      numbers: [29, 36, 11, 34, 21],
      joker: 9),
  JokerDraw(
      date: '2024-12-08', game: 'Joker', numbers: [44, 24, 3, 1, 13], joker: 9),
  JokerDraw(
      date: '2024-12-12',
      game: 'Joker',
      numbers: [23, 10, 42, 45, 30],
      joker: 11),
  JokerDraw(
      date: '2024-12-15',
      game: 'Joker',
      numbers: [2, 37, 30, 19, 35],
      joker: 15),
  JokerDraw(
      date: '2024-12-19',
      game: 'Joker',
      numbers: [19, 24, 42, 8, 44],
      joker: 4),
  JokerDraw(
      date: '2024-12-22',
      game: 'Joker',
      numbers: [22, 24, 10, 15, 37],
      joker: 20),
  JokerDraw(
      date: '2024-12-31',
      game: 'Joker',
      numbers: [23, 42, 24, 37, 16],
      joker: 1),
  JokerDraw(
      date: '2024-12-31',
      game: 'Joker',
      numbers: [38, 25, 17, 7, 23],
      joker: 17),
  JokerDraw(
      date: '2025-01-05', game: 'Joker', numbers: [45, 16, 9, 5, 39], joker: 8),
  JokerDraw(
      date: '2025-01-09',
      game: 'Joker',
      numbers: [39, 29, 44, 5, 34],
      joker: 14),
  JokerDraw(
      date: '2025-01-12',
      game: 'Joker',
      numbers: [41, 44, 33, 23, 17],
      joker: 2),
  JokerDraw(
      date: '2025-01-16',
      game: 'Joker',
      numbers: [8, 42, 33, 34, 16],
      joker: 6),
  JokerDraw(
      date: '2025-01-19',
      game: 'Joker',
      numbers: [36, 10, 33, 43, 31],
      joker: 5),
  JokerDraw(
      date: '2025-01-23',
      game: 'Joker',
      numbers: [2, 31, 29, 33, 1],
      joker: 15),
  JokerDraw(
      date: '2025-01-26', game: 'Joker', numbers: [26, 4, 2, 32, 28], joker: 6),
  JokerDraw(
      date: '2025-01-30',
      game: 'Joker',
      numbers: [14, 24, 30, 18, 37],
      joker: 8),
  JokerDraw(
      date: '2025-02-02',
      game: 'Joker',
      numbers: [15, 22, 44, 27, 3],
      joker: 17),
  JokerDraw(
      date: '2025-02-06', game: 'Joker', numbers: [16, 45, 9, 6, 19], joker: 7),
  JokerDraw(
      date: '2025-02-09',
      game: 'Joker',
      numbers: [36, 10, 4, 30, 9],
      joker: 10),
  JokerDraw(
      date: '2025-02-13',
      game: 'Joker',
      numbers: [18, 6, 28, 23, 45],
      joker: 14),
  JokerDraw(
      date: '2025-02-16',
      game: 'Joker',
      numbers: [32, 10, 5, 28, 33],
      joker: 16),
  JokerDraw(
      date: '2025-02-20',
      game: 'Joker',
      numbers: [6, 29, 16, 7, 33],
      joker: 10),
  JokerDraw(
      date: '2025-02-23',
      game: 'Joker',
      numbers: [42, 14, 6, 44, 40],
      joker: 9),
  JokerDraw(
      date: '2025-02-27',
      game: 'Joker',
      numbers: [8, 23, 30, 38, 32],
      joker: 7),
  JokerDraw(
      date: '2025-03-02',
      game: 'Joker',
      numbers: [31, 41, 29, 5, 21],
      joker: 19),
  JokerDraw(
      date: '2025-03-06',
      game: 'Joker',
      numbers: [33, 3, 41, 38, 37],
      joker: 19),
  JokerDraw(
      date: '2025-03-09',
      game: 'Joker',
      numbers: [42, 40, 37, 10, 19],
      joker: 19),
  JokerDraw(
      date: '2025-03-09',
      game: 'Joker',
      numbers: [25, 6, 32, 16, 33],
      joker: 19),
  JokerDraw(
      date: '2025-03-13',
      game: 'Joker',
      numbers: [31, 13, 8, 17, 15],
      joker: 8),
  JokerDraw(
      date: '2025-03-16', game: 'Joker', numbers: [23, 6, 5, 3, 8], joker: 7),
  JokerDraw(
      date: '2025-03-20',
      game: 'Joker',
      numbers: [36, 28, 29, 10, 20],
      joker: 20),
  JokerDraw(
      date: '2025-03-23',
      game: 'Joker',
      numbers: [13, 5, 43, 41, 18],
      joker: 1),
  JokerDraw(
      date: '2025-03-27',
      game: 'Joker',
      numbers: [44, 26, 32, 36, 14],
      joker: 5),
  JokerDraw(
      date: '2025-03-30', game: 'Joker', numbers: [35, 5, 22, 4, 16], joker: 1),
  JokerDraw(
      date: '2025-04-03',
      game: 'Joker',
      numbers: [44, 15, 40, 37, 18],
      joker: 3),
  JokerDraw(
      date: '2025-04-06',
      game: 'Joker',
      numbers: [13, 43, 35, 21, 33],
      joker: 17),
  JokerDraw(
      date: '2025-04-10',
      game: 'Joker',
      numbers: [37, 29, 12, 11, 7],
      joker: 8),
  JokerDraw(
      date: '2025-04-13',
      game: 'Joker',
      numbers: [16, 40, 18, 32, 29],
      joker: 8),
  JokerDraw(
      date: '2025-04-19',
      game: 'Joker',
      numbers: [18, 28, 10, 37, 6],
      joker: 17),
  JokerDraw(
      date: '2025-04-19', game: 'Joker', numbers: [35, 9, 3, 8, 34], joker: 3),
  JokerDraw(
      date: '2025-04-24',
      game: 'Joker',
      numbers: [34, 18, 4, 27, 41],
      joker: 18),
  JokerDraw(
      date: '2025-04-27',
      game: 'Joker',
      numbers: [6, 28, 43, 37, 15],
      joker: 18),
  JokerDraw(
      date: '2025-05-01',
      game: 'Joker',
      numbers: [18, 40, 8, 14, 28],
      joker: 20),
  JokerDraw(
      date: '2025-05-04',
      game: 'Joker',
      numbers: [24, 35, 21, 5, 45],
      joker: 11),
  JokerDraw(
      date: '2025-05-08',
      game: 'Joker',
      numbers: [2, 19, 1, 37, 27],
      joker: 12),
  JokerDraw(
      date: '2025-05-11',
      game: 'Joker',
      numbers: [43, 39, 35, 38, 31],
      joker: 1),
  JokerDraw(
      date: '2025-05-15', game: 'Joker', numbers: [44, 9, 26, 3, 2], joker: 12),
  JokerDraw(
      date: '2025-05-18',
      game: 'Joker',
      numbers: [30, 26, 44, 3, 27],
      joker: 13),
  JokerDraw(
      date: '2025-05-22',
      game: 'Joker',
      numbers: [25, 32, 1, 28, 30],
      joker: 4),
  JokerDraw(
      date: '2025-05-25',
      game: 'Joker',
      numbers: [19, 34, 12, 15, 11],
      joker: 10),
  JokerDraw(
      date: '2025-05-29',
      game: 'Joker',
      numbers: [25, 31, 28, 29, 7],
      joker: 20),
  JokerDraw(
      date: '2025-06-01',
      game: 'Joker',
      numbers: [41, 24, 36, 28, 10],
      joker: 4),
  JokerDraw(
      date: '2025-06-05',
      game: 'Joker',
      numbers: [26, 7, 15, 35, 40],
      joker: 11),
  JokerDraw(
      date: '2025-06-08',
      game: 'Joker',
      numbers: [29, 44, 8, 7, 12],
      joker: 15),
  JokerDraw(
      date: '2025-06-12',
      game: 'Joker',
      numbers: [41, 24, 19, 27, 14],
      joker: 14),
  JokerDraw(
      date: '2025-06-15',
      game: 'Joker',
      numbers: [43, 27, 4, 30, 13],
      joker: 4),
  JokerDraw(
      date: '2025-06-19',
      game: 'Joker',
      numbers: [44, 38, 29, 24, 9],
      joker: 4),
  JokerDraw(
      date: '2025-06-22',
      game: 'Joker',
      numbers: [10, 16, 42, 22, 38],
      joker: 16),
  JokerDraw(
      date: '2025-06-26',
      game: 'Joker',
      numbers: [45, 40, 12, 7, 31],
      joker: 13),
  JokerDraw(
      date: '2025-06-29',
      game: 'Joker',
      numbers: [16, 26, 35, 18, 21],
      joker: 19),
  JokerDraw(
      date: '2025-07-03',
      game: 'Joker',
      numbers: [38, 35, 3, 28, 21],
      joker: 13),
  JokerDraw(
      date: '2025-07-06',
      game: 'Joker',
      numbers: [45, 42, 14, 26, 4],
      joker: 4),
  JokerDraw(
      date: '2025-07-10',
      game: 'Joker',
      numbers: [34, 24, 39, 11, 36],
      joker: 1),
  JokerDraw(
      date: '2025-07-13',
      game: 'Joker',
      numbers: [18, 17, 24, 42, 39],
      joker: 9),
  JokerDraw(
      date: '2025-07-17',
      game: 'Joker',
      numbers: [45, 13, 15, 6, 18],
      joker: 4),
  JokerDraw(
      date: '2025-07-20',
      game: 'Joker',
      numbers: [7, 24, 29, 1, 33],
      joker: 13),
  JokerDraw(
      date: '2025-07-24',
      game: 'Joker',
      numbers: [2, 21, 15, 23, 1],
      joker: 18),
  JokerDraw(
      date: '2025-07-27',
      game: 'Joker',
      numbers: [21, 31, 8, 38, 22],
      joker: 15),
  JokerDraw(
      date: '2025-07-31', game: 'Joker', numbers: [12, 1, 20, 33, 7], joker: 9),
  JokerDraw(
      date: '2025-08-03',
      game: 'Joker',
      numbers: [35, 14, 26, 41, 24],
      joker: 6),
  JokerDraw(
      date: '2025-08-07',
      game: 'Joker',
      numbers: [11, 22, 27, 21, 34],
      joker: 11),
  JokerDraw(
      date: '2025-08-10',
      game: 'Joker',
      numbers: [37, 44, 5, 36, 8],
      joker: 18),
  JokerDraw(
      date: '2025-08-14',
      game: 'Joker',
      numbers: [42, 43, 41, 24, 37],
      joker: 9),
  JokerDraw(
      date: '2025-08-17',
      game: 'Joker',
      numbers: [23, 12, 25, 35, 17],
      joker: 14),
  JokerDraw(
      date: '2025-08-21',
      game: 'Joker',
      numbers: [2, 35, 15, 3, 16],
      joker: 12),
  JokerDraw(
      date: '2025-08-24',
      game: 'Joker',
      numbers: [34, 20, 40, 32, 29],
      joker: 5),
  JokerDraw(
      date: '2025-08-28', game: 'Joker', numbers: [42, 8, 26, 7, 1], joker: 3),
  JokerDraw(
      date: '2025-08-31', game: 'Joker', numbers: [40, 6, 20, 19, 1], joker: 3),
  JokerDraw(
      date: '2025-09-04',
      game: 'Joker',
      numbers: [37, 13, 42, 18, 35],
      joker: 16),
  JokerDraw(
      date: '2025-09-07', game: 'Joker', numbers: [12, 6, 41, 43, 4], joker: 5),
  JokerDraw(
      date: '2025-09-11',
      game: 'Joker',
      numbers: [36, 8, 22, 5, 14],
      joker: 20),
  JokerDraw(
      date: '2025-09-14',
      game: 'Joker',
      numbers: [32, 38, 5, 29, 34],
      joker: 12),
  JokerDraw(
      date: '2025-09-14',
      game: 'Joker',
      numbers: [23, 13, 24, 42, 14],
      joker: 18)
];
