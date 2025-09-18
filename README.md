# 🍀 LotoRO - Firebase Studio Project (Flutter)

## 📋 **Ce conține acest proiect**

Acest folder conține toate fișierele necesare pentru a recrea aplicația LotoRO în Firebase Studio folosind Flutter/Dart.

## 📁 **Structura Fișierelor**

### **`/data/` - Date Istorice (TypeScript)**
- `data_joker.ts` - 2,082 extrageri Joker (2000-2025)
- `data_649.ts` - 2,478 extrageri 6 din 49 (1993-2025)
- `data_540.ts` - 2,371 extrageri 5 din 40 (1995-2025)
- `lottery_data.ts` - Fișier index cu funcții helper

### **`/data/` - Date Istorice (Dart)**
- `data_joker.dart` - 2,082 extrageri Joker (2000-2025)
- `data_649.dart` - 2,478 extrageri 6 din 49 (1993-2025)
- `data_540.dart` - 2,371 extrageri 5 din 40 (1995-2025)

### **`/lib/` - Cod Flutter**
- `main.dart` - Entry point aplicație
- `utils/constants.dart` - Constante, culori, fonturi

### **`/components/` - Componente React (referință)**
- `firebase_usage_example.tsx` - Exemplu complet de implementare

### **`/prompts/` - Prompturi pentru Firebase Studio**
- `home_tab_prompt.md` - Prompt pentru tab-ul "Acasă"
- `archive_tab_prompt.md` - Prompt pentru tab-ul "Arhivă" (în dezvoltare)
- `statistics_tab_prompt.md` - Prompt pentru tab-ul "Statistici" (în dezvoltare)
- `generator_tab_prompt.md` - Prompt pentru tab-ul "Generator" (în dezvoltare)
- `settings_tab_prompt.md` - Prompt pentru tab-ul "Setări" (în dezvoltare)

## 🚀 **Cum să folosești în Firebase Studio (Flutter)**

### **1. Încarcă fișierele Flutter**
- Copiază conținutul din `lib/main.dart` și `lib/utils/constants.dart`
- Copiază `pubspec.yaml` pentru dependențe
- Acestea vor fi baza aplicației Flutter

### **2. Încarcă datele istorice**
- Copiază conținutul din `data_joker.dart`, `data_649.dart`, `data_540.dart`
- Acestea vor popula aplicația cu date reale din arhivele oficiale

### **3. Folosește promptul Flutter**
- Începe cu `flutter_firebase_prompt.md` pentru tab-ul "Acasă"
- Implementează pas cu pas conform specificațiilor Flutter
- Promptul conține cod Dart complet cu glassmorphism

### **4. Referință pentru implementare**
- `firebase_usage_example.tsx` arată logica de integrare (React)
- Adaptează logica pentru Flutter folosind Riverpod
- Demonstrează calcularea statisticilor din date

## 🎯 **Ordinea de Implementare**

1. **Tab-ul "Acasă"** - Folosește `flutter_firebase_prompt.md`
2. **Tab-ul "Arhivă"** - Folosește `archive_tab_prompt.md` (în dezvoltare)
3. **Tab-ul "Statistici"** - Folosește `statistics_tab_prompt.md` (în dezvoltare)
4. **Tab-ul "Generator"** - Folosește `generator_tab_prompt.md` (în dezvoltare)
5. **Tab-ul "Setări"** - Folosește `settings_tab_prompt.md` (în dezvoltare)

## 📊 **Statistici Date**

- **Total extrageri:** 6,931
- **Perioada acoperită:** 1993-2025 (32 ani)
- **Jocuri suportate:** Joker, 6 din 49, 5 din 40
- **Format:** TypeScript cu tipuri complete

## 🔧 **Tehnologii Flutter**

- **Flutter/Dart** cu Riverpod pentru state management
- **Glassmorphism** pentru efecte vizuale
- **FL Chart** pentru grafice interactive
- **Hive** pentru cache local
- **Material Design 3** pentru UI components

## 📱 **Design System**

- **Glassmorphism** cu efecte de sticlă
- **Paletă verde pastel** pentru culori
- **Responsive design** pentru toate device-urile
- **Animații fluide** cu 60fps

---

**Generat pe:** ${new Date().toLocaleString('ro-RO')}  
**Versiunea:** 1.0.0  
**Sursa:** Aplicația originală LotoRO (Flutter)
