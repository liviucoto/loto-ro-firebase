# 🔧 Configurare Firebase Studio pentru LotoRO

## 📋 **Instrucțiuni de Încărcare**

### **1. Încarcă folderul `loto-ro-firebase`**
- **NU** încărca tot folderul `loto_ro`
- **Încarcă doar** folderul `loto-ro-firebase` care conține doar fișierele necesare

### **2. Structura de fișiere în Firebase Studio**
```
src/
├── data/
│   ├── data_joker.ts
│   ├── data_649.ts
│   ├── data_540.ts
│   └── lottery_data.ts
├── components/
│   └── firebase_usage_example.tsx
└── prompts/
    └── home_tab_prompt.md
```

## 🚀 **Pași de Implementare**

### **Pasul 1: Încarcă datele**
1. Copiază conținutul din `data_joker.ts` în Firebase Studio
2. Copiază conținutul din `data_649.ts` în Firebase Studio
3. Copiază conținutul din `data_540.ts` în Firebase Studio
4. Copiază conținutul din `lottery_data.ts` în Firebase Studio

### **Pasul 2: Implementează tab-ul "Acasă"**
1. Deschide `home_tab_prompt.md`
2. Copiază promptul în Firebase Studio
3. Implementează pas cu pas conform specificațiilor
4. Testează pe toate dimensiunile de ecran

### **Pasul 3: Adaugă componentele**
1. Folosește `firebase_usage_example.tsx` ca referință
2. Adaptează componentele la nevoile tale
3. Implementează glassmorphism design
4. Adaugă animații și hover effects

## 📊 **Date Disponibile**

### **Joker (2,082 extrageri)**
```typescript
{ date: '2000-09-14', game: 'Joker', numbers: [4, 30, 32, 39, 27], joker: 7 }
```

### **6 din 49 (2,478 extrageri)**
```typescript
{ date: '1993-08-08', game: '6 din 49', numbers: [38, 17, 47, 25, 30, 37] }
```

### **5 din 40 (2,371 extrageri)**
```typescript
{ date: '1995-01-12', game: '5 din 40', numbers: [5, 13, 26, 38, 37] }
```

## 🎨 **Design System**

### **Culori Principale**
```css
--primary-green: #4CAF50
--secondary-blue: #2196F3
--accent-purple: #9C27B0
--surface: rgba(255, 255, 255, 0.1)
--background: #0A0A0A
```

### **Efecte Glassmorphism**
```css
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}
```

## 🔧 **Dependențe Recomandate**

```json
{
  "dependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "tailwindcss": "^3.0.0",
    "framer-motion": "^10.0.0",
    "recharts": "^2.0.0",
    "lucide-react": "^0.300.0"
  }
}
```

## 📱 **Responsive Design**

- **Mobile:** 320px - 768px
- **Tablet:** 768px - 1024px
- **Desktop:** 1024px+

## ⚠️ **Note Importante**

1. **Nu încărca** fișierele Flutter/Dart
2. **Folosește doar** fișierele TypeScript/React
3. **Implementează pas cu pas** conform prompturilor
4. **Testează** pe toate dimensiunile de ecran
5. **Păstrează** design-ul glassmorphism

## 🎯 **Rezultat Așteptat**

O aplicație web completă cu:
- ✅ Tab-ul "Acasă" cu statistici și extrageri recente
- ✅ Design glassmorphism modern
- ✅ Responsive pentru toate device-urile
- ✅ Date reale din arhivele oficiale
- ✅ Funcționalități interactive
- ✅ Animații fluide

---

**Următorul pas:** Implementează tab-ul "Acasă" folosind `home_tab_prompt.md`
