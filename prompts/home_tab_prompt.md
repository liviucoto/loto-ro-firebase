# 🏠 Prompt pentru Tab-ul "Acasă" - LotoRO

## 📋 **Specificații Generale**

**Nume tab:** Acasă (Home)  
**Poziție:** Primul tab în navigația principală  
**Scop:** Informații generale despre aplicație și jocuri de loterie, quick actions, statistici de bază  
**Design:** Glassmorphism cu paletă verde pastel  

## 🎨 **Layout și Structură**

### **Header Section:**
```jsx
// Header cu logo și informații generale
<div className="glass-card p-6 mb-6">
  <div className="flex items-center justify-between">
    <div className="flex items-center space-x-4">
      <div className="w-12 h-12 bg-gradient-to-br from-green-400 to-green-600 rounded-xl flex items-center justify-center">
        <span className="text-2xl">🍀</span>
      </div>
      <div>
        <h1 className="text-3xl font-bold text-white">LotoRO</h1>
        <p className="text-green-200">Statistici și Generator Inteligent</p>
      </div>
    </div>
    <div className="text-right">
      <p className="text-sm text-gray-300">Versiunea 1.0.0</p>
      <p className="text-xs text-gray-400">Ultima actualizare: {new Date().toLocaleDateString('ro-RO')}</p>
    </div>
  </div>
</div>
```

### **Game Selector Section:**
```jsx
// Selector pentru jocuri de loterie
<div className="glass-card p-6 mb-6">
  <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
    <span className="mr-2">🎯</span>
    Selectează Jocul de Loterie
  </h2>
  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
    {/* Joker Card */}
    <div className="game-card bg-gradient-to-br from-green-500/20 to-green-600/20 border border-green-400/30">
      <div className="text-center">
        <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-3">
          <span className="text-2xl">🎲</span>
        </div>
        <h3 className="text-lg font-semibold text-white">Joker</h3>
        <p className="text-sm text-green-200 mb-2">5 numere din 45 + Joker</p>
        <div className="text-xs text-gray-300">
          <p>Numere: 1-45</p>
          <p>Joker: 1-20</p>
        </div>
      </div>
    </div>
    
    {/* 6 din 49 Card */}
    <div className="game-card bg-gradient-to-br from-blue-500/20 to-blue-600/20 border border-blue-400/30">
      <div className="text-center">
        <div className="w-16 h-16 bg-blue-500 rounded-full flex items-center justify-center mx-auto mb-3">
          <span className="text-2xl">🔢</span>
        </div>
        <h3 className="text-lg font-semibold text-white">6 din 49</h3>
        <p className="text-sm text-blue-200 mb-2">6 numere din 49</p>
        <div className="text-xs text-gray-300">
          <p>Numere: 1-49</p>
          <p>Fără numere suplimentare</p>
        </div>
      </div>
    </div>
    
    {/* 5 din 40 Card */}
    <div className="game-card bg-gradient-to-br from-purple-500/20 to-purple-600/20 border border-purple-400/30">
      <div className="text-center">
        <div className="w-16 h-16 bg-purple-500 rounded-full flex items-center justify-center mx-auto mb-3">
          <span className="text-2xl">⭐</span>
        </div>
        <h3 className="text-lg font-semibold text-white">5 din 40</h3>
        <p className="text-sm text-purple-200 mb-2">5 numere din 40</p>
        <div className="text-xs text-gray-300">
          <p>Numere: 1-40</p>
          <p>Fără numere suplimentare</p>
        </div>
      </div>
    </div>
  </div>
</div>
```

### **Quick Stats Section:**
```jsx
// Statistici rapide pentru jocul selectat
<div className="glass-card p-6 mb-6">
  <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
    <span className="mr-2">📊</span>
    Statistici Rapide
  </h2>
  <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
    <div className="stat-card">
      <div className="text-2xl font-bold text-green-400">2,082</div>
      <div className="text-sm text-gray-300">Extrageri totale</div>
    </div>
    <div className="stat-card">
      <div className="text-2xl font-bold text-blue-400">23</div>
      <div className="text-sm text-gray-300">Numărul cel mai frecvent</div>
    </div>
    <div className="stat-card">
      <div className="text-2xl font-bold text-purple-400">127.5</div>
      <div className="text-sm text-gray-300">Suma medie</div>
    </div>
    <div className="stat-card">
      <div className="text-2xl font-bold text-yellow-400">45%</div>
      <div className="text-sm text-gray-300">Numere pare</div>
    </div>
  </div>
</div>
```

### **Quick Actions Section:**
```jsx
// Acțiuni rapide pentru utilizator
<div className="glass-card p-6 mb-6">
  <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
    <span className="mr-2">⚡</span>
    Acțiuni Rapide
  </h2>
  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
    <button className="quick-action-btn bg-gradient-to-r from-green-500 to-green-600">
      <span className="text-2xl mb-2">🎲</span>
      <span className="font-semibold">Generează Numere</span>
      <span className="text-sm opacity-90">AI Generator</span>
    </button>
    
    <button className="quick-action-btn bg-gradient-to-r from-blue-500 to-blue-600">
      <span className="text-2xl mb-2">📈</span>
      <span className="font-semibold">Vezi Statistici</span>
      <span className="text-sm opacity-90">Grafice avansate</span>
    </button>
    
    <button className="quick-action-btn bg-gradient-to-r from-purple-500 to-purple-600">
      <span className="text-2xl mb-2">📚</span>
      <span className="font-semibold">Arhiva Extrageri</span>
      <span className="text-sm opacity-90">Toate extragerile</span>
    </button>
    
    <button className="quick-action-btn bg-gradient-to-r from-yellow-500 to-yellow-600">
      <span className="text-2xl mb-2">⚙️</span>
      <span className="font-semibold">Setări</span>
      <span className="text-sm opacity-90">Configurări</span>
    </button>
  </div>
</div>
```

### **Recent Draws Section:**
```jsx
// Ultimele extrageri pentru jocul selectat
<div className="glass-card p-6 mb-6">
  <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
    <span className="mr-2">🕒</span>
    Ultimele Extrageri
  </h2>
  <div className="space-y-3">
    {recentDraws.map((draw, index) => (
      <div key={index} className="draw-item">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center">
              <span className="text-sm font-bold">{index + 1}</span>
            </div>
            <div>
              <div className="text-white font-medium">
                {draw.date.toLocaleDateString('ro-RO')}
              </div>
              <div className="text-sm text-gray-300">
                {draw.gameType.toUpperCase()}
              </div>
            </div>
          </div>
          <div className="flex space-x-1">
            {draw.mainNumbers.map((number, numIndex) => (
              <div key={numIndex} className="number-ball">
                {number}
              </div>
            ))}
            {draw.jokerNumber && (
              <div className="joker-ball">
                {draw.jokerNumber}
              </div>
            )}
          </div>
        </div>
      </div>
    ))}
  </div>
</div>
```

### **App Information Section:**
```jsx
// Informații despre aplicație
<div className="glass-card p-6 mb-6">
  <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
    <span className="mr-2">ℹ️</span>
    Despre LotoRO
  </h2>
  <div className="prose prose-invert max-w-none">
    <p className="text-gray-300 mb-4">
      LotoRO este o aplicație avansată pentru analiza și generarea numerelor de loterie românești. 
      Folosind algoritmi AI și machine learning, aplicația oferă statistici detaliate și predicții 
      inteligente pentru jocurile Joker, 6 din 49 și 5 din 40.
    </p>
    
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <h3 className="text-lg font-semibold text-white mb-2">🎯 Funcționalități Principale</h3>
        <ul className="space-y-1 text-gray-300">
          <li>• Statistici avansate cu 11 tipuri de grafice</li>
          <li>• Generator AI cu algoritmi locali</li>
          <li>• Arhivă completă cu căutare și filtrare</li>
          <li>• Analiză narativă automată</li>
          <li>• Export și partajare date</li>
        </ul>
      </div>
      
      <div>
        <h3 className="text-lg font-semibold text-white mb-2">🔬 Tehnologii</h3>
        <ul className="space-y-1 text-gray-300">
          <li>• Machine Learning local</li>
          <li>• Algoritmi de predicție</li>
          <li>• Cache inteligent</li>
          <li>• Performance monitoring</li>
          <li>• Design glassmorphism</li>
        </ul>
      </div>
    </div>
  </div>
</div>
```

## 🎨 **CSS Styles pentru Componente**

```css
/* Glass Card Base */
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

/* Game Cards */
.game-card {
  padding: 1.5rem;
  border-radius: 12px;
  transition: all 0.3s ease;
  cursor: pointer;
}

.game-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
}

/* Stat Cards */
.stat-card {
  text-align: center;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

/* Quick Action Buttons */
.quick-action-btn {
  padding: 1.5rem;
  border-radius: 12px;
  text-align: center;
  color: white;
  transition: all 0.3s ease;
  border: none;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.quick-action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

/* Draw Items */
.draw-item {
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.draw-item:hover {
  background: rgba(255, 255, 255, 0.1);
}

/* Number Balls */
.number-ball {
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #4CAF50, #45a049);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  font-size: 14px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.joker-ball {
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #9C27B0, #7B1FA2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  font-size: 14px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

/* Responsive Design */
@media (max-width: 768px) {
  .glass-card {
    margin: 0.5rem;
    padding: 1rem;
  }
  
  .game-card {
    padding: 1rem;
  }
  
  .quick-action-btn {
    padding: 1rem;
  }
  
  .number-ball, .joker-ball {
    width: 28px;
    height: 28px;
    font-size: 12px;
  }
}
```

## 📱 **Responsive Design**

### **Mobile (320px - 768px):**
- Layout pe o coloană
- Card-uri mai mici cu padding redus
- Butoane mai mari pentru touch
- Text mai mic pentru a încăpea

### **Tablet (768px - 1024px):**
- Layout pe două coloane
- Card-uri de dimensiune medie
- Spacing optimizat

### **Desktop (1024px+):**
- Layout pe trei coloane
- Card-uri mari cu spacing generos
- Hover effects complete

## 🔧 **Funcționalități JavaScript**

```javascript
// Game Selection
function selectGame(gameType) {
  // Update selected game
  setSelectedGame(gameType);
  
  // Update stats based on selected game
  updateGameStats(gameType);
  
  // Update recent draws
  updateRecentDraws(gameType);
  
  // Animate transition
  animateGameChange();
}

// Quick Actions
function handleQuickAction(action) {
  switch(action) {
    case 'generate':
      // Navigate to generator tab
      navigateToTab('generator');
      break;
    case 'statistics':
      // Navigate to statistics tab
      navigateToTab('statistics');
      break;
    case 'archive':
      // Navigate to archive tab
      navigateToTab('archive');
      break;
    case 'settings':
      // Navigate to settings tab
      navigateToTab('settings');
      break;
  }
}

// Update Stats
function updateGameStats(gameType) {
  // Fetch stats for selected game
  const stats = getGameStats(gameType);
  
  // Update UI elements
  updateStatCard('total-draws', stats.totalDraws);
  updateStatCard('most-frequent', stats.mostFrequent);
  updateStatCard('average-sum', stats.averageSum);
  updateStatCard('even-percentage', stats.evenPercentage);
}

// Animate Game Change
function animateGameChange() {
  // Fade out current content
  document.querySelector('.stats-section').style.opacity = '0';
  
  // After animation, update content
  setTimeout(() => {
    updateGameStats(selectedGame);
    document.querySelector('.stats-section').style.opacity = '1';
  }, 300);
}
```

## 📊 **Date Mock pentru Testare**

```javascript
// Mock data for testing
const mockData = {
  games: {
    joker: {
      name: 'Joker',
      totalDraws: 2082,
      mostFrequent: 23,
      averageSum: 127.5,
      evenPercentage: 45,
      recentDraws: [
        {
          date: new Date('2024-01-15'),
          mainNumbers: [12, 23, 34, 41, 45],
          jokerNumber: 7
        },
        {
          date: new Date('2024-01-12'),
          mainNumbers: [5, 18, 29, 37, 42],
          jokerNumber: 13
        }
      ]
    },
    loto649: {
      name: '6 din 49',
      totalDraws: 1856,
      mostFrequent: 31,
      averageSum: 150.2,
      evenPercentage: 48,
      recentDraws: [
        {
          date: new Date('2024-01-14'),
          mainNumbers: [3, 15, 28, 35, 42, 49]
        }
      ]
    },
    loto540: {
      name: '5 din 40',
      totalDraws: 1923,
      mostFrequent: 19,
      averageSum: 102.8,
      evenPercentage: 52,
      recentDraws: [
        {
          date: new Date('2024-01-13'),
          mainNumbers: [7, 14, 21, 28, 35]
        }
      ]
    }
  }
};
```

## 🎯 **Rezultat Așteptat**

Un tab "Acasă" complet funcțional cu:

✅ **Header elegant** cu logo și informații aplicație  
✅ **Selector de jocuri** cu card-uri interactive  
✅ **Statistici rapide** pentru jocul selectat  
✅ **Acțiuni rapide** pentru navigare între tab-uri  
✅ **Ultimele extrageri** cu bile numerotate  
✅ **Informații despre aplicație** cu funcționalități  
✅ **Design glassmorphism** complet  
✅ **Responsive design** pentru toate device-urile  
✅ **Animații fluide** și hover effects  
✅ **Funcționalități JavaScript** complete  

---

**Notă:** Acest prompt conține toate specificațiile necesare pentru a crea tab-ul "Acasă" în Firebase Studio. Implementează pas cu pas, testând pe toate dimensiunile de ecran.
