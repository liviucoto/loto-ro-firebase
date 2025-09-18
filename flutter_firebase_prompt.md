# 🍀 LotoRO - Prompt Flutter pentru Firebase Studio

## 📋 **Specificații Generale**

**Platforma:** Flutter/Dart  
**Design:** Glassmorphism cu paletă verde pastel  
**Arhitectură:** Provider/Riverpod pentru state management  
**Date:** 6,931 extrageri istorice (Joker, 6 din 49, 5 din 40)  

## 🎯 **Structura Aplicației**

### **Tab-uri Principale:**
1. **Acasă** - Informații generale și quick actions
2. **Arhivă** - Toate extragerile istorice cu căutare/filtrare
3. **Statistici** - 11 tipuri de grafice cu analize avansate
4. **Generator** - AI generator cu algoritmi locali
5. **Setări** - Configurări și debug panel

## 🎨 **Design System Flutter**

### **Culori (AppColors):**
```dart
static const Color primaryGreen = Color(0xFF4CAF50);
static const Color secondaryBlue = Color(0xFF2196F3);
static const Color accentPurple = Color(0xFF9C27B0);
static const Color glassBackground = Color(0x1AFFFFFF);
static const Color background = Color(0xFF0A0A0A);
```

### **Fonturi (AppFonts):**
```dart
static const TextStyle headingStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
);
```

### **Glassmorphism Widget:**
```dart
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassMedium,
          width: 1,
        ),
        boxShadow: AppShadows.glass,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

## 📊 **Date Istorice**

### **Joker (2,082 extrageri):**
```dart
class JokerDraw {
  final String date;
  final String game;
  final List<int> numbers;
  final int joker;
}

final List<JokerDraw> dataJoker = [
  JokerDraw(date: '2000-09-14', game: 'Joker', numbers: [4, 30, 32, 39, 27], joker: 7),
  // ... 2,081 extrageri în plus
];
```

### **6 din 49 (2,478 extrageri):**
```dart
class Loto649Draw {
  final String date;
  final String game;
  final List<int> numbers;
}

final List<Loto649Draw> data649 = [
  Loto649Draw(date: '1993-08-08', game: '6 din 49', numbers: [38, 17, 47, 25, 30, 37]),
  // ... 2,477 extrageri în plus
];
```

### **5 din 40 (2,371 extrageri):**
```dart
class Loto540Draw {
  final String date;
  final String game;
  final List<int> numbers;
}

final List<Loto540Draw> data540 = [
  Loto540Draw(date: '1995-01-12', game: '5 din 40', numbers: [5, 13, 26, 38, 37]),
  // ... 2,370 extrageri în plus
];
```

## 🏠 **Tab-ul "Acasă" - Implementare Flutter**

### **HomeScreen Widget:**
```dart
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GameType selectedGame = GameType.joker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),
              _buildGameSelector(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickStats(),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActions(),
              const SizedBox(height: AppSpacing.lg),
              _buildRecentDraws(),
              const SizedBox(height: AppSpacing.lg),
              _buildAppInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **Header Section:**
```dart
Widget _buildHeader() {
  return GlassCard(
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.casino,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appName,
                style: AppFonts.headingStyle,
              ),
              Text(
                AppStrings.appTagline,
                style: AppFonts.captionStyle.copyWith(
                  color: AppColors.primaryGreenLight,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Versiunea 1.0.0',
              style: AppFonts.smallStyle,
            ),
            Text(
              'Ultima actualizare: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
              style: AppFonts.smallStyle.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
```

### **Game Selector:**
```dart
Widget _buildGameSelector() {
  return GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.games, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Selectează Jocul de Loterie',
              style: AppFonts.titleStyle,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildGameCard(
                'Joker',
                '5 numere din 45 + Joker',
                Icons.casino,
                AppColors.primaryGreen,
                GameType.joker,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildGameCard(
                '6 din 49',
                '6 numere din 49',
                Icons.numbers,
                AppColors.secondaryBlue,
                GameType.loto649,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildGameCard(
                '5 din 40',
                '5 numere din 40',
                Icons.star,
                AppColors.accentPurple,
                GameType.loto540,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildGameCard(String title, String subtitle, IconData icon, Color color, GameType gameType) {
  final isSelected = selectedGame == gameType;
  
  return GestureDetector(
    onTap: () => setState(() => selectedGame = gameType),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.2) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppFonts.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppFonts.smallStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
```

### **Quick Stats:**
```dart
Widget _buildQuickStats() {
  final stats = _calculateStats();
  
  return GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Statistici Rapide',
              style: AppFonts.titleStyle,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '${stats['totalDraws']}',
                'Extrageri totale',
                AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                '${stats['mostFrequent']}',
                'Numărul cel mai frecvent',
                AppColors.secondaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '${stats['averageSum']}',
                'Suma medie',
                AppColors.accentPurple,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                '${stats['evenPercentage']}%',
                'Numere pare',
                AppColors.accentYellow,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatCard(String value, String label, Color color) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: AppFonts.headingStyle.copyWith(
            color: color,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppFonts.smallStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
```

### **Recent Draws:**
```dart
Widget _buildRecentDraws() {
  final recentDraws = _getRecentDraws();
  
  return GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Ultimele Extrageri',
              style: AppFonts.titleStyle,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...recentDraws.map((draw) => _buildDrawItem(draw)),
      ],
    ),
  );
}

Widget _buildDrawItem(dynamic draw) {
  return Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      border: Border.all(color: AppColors.glassMedium),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd.MM.yyyy').format(DateTime.parse(draw.date)),
                style: AppFonts.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                draw.game,
                style: AppFonts.smallStyle,
              ),
            ],
          ),
        ),
        Row(
          children: [
            ...draw.numbers.map((number) => _buildNumberBall(number)),
            if (draw.joker != null) ...[
              const SizedBox(width: AppSpacing.xs),
              _buildJokerBall(draw.joker),
            ],
          ],
        ),
      ],
    ),
  );
}

Widget _buildNumberBall(int number) {
  return Container(
    margin: const EdgeInsets.only(left: 2),
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      gradient: AppGradients.primaryGradient,
      borderRadius: BorderRadius.circular(14),
      boxShadow: AppShadows.glass,
    ),
    child: Center(
      child: Text(
        '$number',
        style: AppFonts.smallStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildJokerBall(int joker) {
  return Container(
    margin: const EdgeInsets.only(left: 2),
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: AppColors.accentYellow,
      borderRadius: BorderRadius.circular(14),
      boxShadow: AppShadows.glass,
    ),
    child: Center(
      child: Text(
        '$joker',
        style: AppFonts.smallStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
```

## 🔧 **Dependențe Necesare**

### **pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  glassmorphism: ^3.0.0
  intl: ^0.18.1
  fl_chart: ^0.65.0
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
```

## 📱 **Responsive Design**

### **LayoutBuilder pentru adaptare:**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 1024) {
      // Desktop layout
      return _buildDesktopLayout();
    } else if (constraints.maxWidth > 768) {
      // Tablet layout
      return _buildTabletLayout();
    } else {
      // Mobile layout
      return _buildMobileLayout();
    }
  },
)
```

## 🎯 **Rezultat Așteptat**

Un tab "Acasă" complet funcțional cu:

✅ **Header elegant** cu logo și informații aplicație  
✅ **Selector de jocuri** cu card-uri interactive  
✅ **Statistici rapide** calculate dinamic  
✅ **Acțiuni rapide** pentru navigare  
✅ **Ultimele extrageri** cu bile numerotate  
✅ **Design glassmorphism** complet  
✅ **Responsive design** pentru toate device-urile  
✅ **Animații fluide** și hover effects  
✅ **State management** cu Riverpod  

---

**Notă:** Acest prompt conține toate specificațiile necesare pentru a crea tab-ul "Acasă" în Flutter pentru Firebase Studio. Implementează pas cu pas, testând pe toate dimensiunile de ecran.
