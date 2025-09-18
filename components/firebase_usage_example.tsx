// Exemplu de utilizare a datelor LotoRO în Firebase Studio
// Acest fișier demonstrează cum să integrezi datele istorice în aplicația ta

import React, { useState, useEffect } from 'react';
import { dataJoker, data649, data540, getGameData, getTotalDraws } from './lottery_data';

// Componenta pentru afișarea unei extrageri
const DrawCard: React.FC<{ draw: any; gameType: string }> = ({ draw, gameType }) => {
  const getGameColor = (game: string) => {
    switch (game) {
      case 'Joker': return 'bg-green-500';
      case '6 din 49': return 'bg-blue-500';
      case '5 din 40': return 'bg-purple-500';
      default: return 'bg-gray-500';
    }
  };

  return (
    <div className="glass-card p-4 mb-3">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-white font-semibold">{draw.date}</h3>
          <p className="text-gray-300 text-sm">{draw.game}</p>
        </div>
        <div className="flex space-x-2">
          {draw.numbers.map((number: number, index: number) => (
            <div
              key={index}
              className={`w-8 h-8 rounded-full ${getGameColor(draw.game)} flex items-center justify-center text-white font-bold text-sm`}
            >
              {number}
            </div>
          ))}
          {draw.joker && (
            <div className="w-8 h-8 rounded-full bg-yellow-500 flex items-center justify-center text-white font-bold text-sm">
              {draw.joker}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

// Componenta principală pentru tab-ul Acasă
const HomeTab: React.FC = () => {
  const [selectedGame, setSelectedGame] = useState<'joker' | '649' | '540'>('joker');
  const [recentDraws, setRecentDraws] = useState<any[]>([]);
  const [stats, setStats] = useState<any>(null);

  useEffect(() => {
    // Obține datele pentru jocul selectat
    const gameData = getGameData(selectedGame);
    
    // Obține ultimele 5 extrageri
    const recent = gameData.slice(-5).reverse();
    setRecentDraws(recent);
    
    // Calculează statistici rapide
    const totalDraws = gameData.length;
    const mostFrequent = calculateMostFrequent(gameData);
    const averageSum = calculateAverageSum(gameData);
    const evenPercentage = calculateEvenPercentage(gameData);
    
    setStats({
      totalDraws,
      mostFrequent,
      averageSum,
      evenPercentage
    });
  }, [selectedGame]);

  const calculateMostFrequent = (data: any[]) => {
    const frequency: { [key: number]: number } = {};
    data.forEach(draw => {
      draw.numbers.forEach((num: number) => {
        frequency[num] = (frequency[num] || 0) + 1;
      });
    });
    
    return Object.keys(frequency).reduce((a, b) => 
      frequency[parseInt(a)] > frequency[parseInt(b)] ? a : b
    );
  };

  const calculateAverageSum = (data: any[]) => {
    const sums = data.map(draw => 
      draw.numbers.reduce((sum: number, num: number) => sum + num, 0)
    );
    return (sums.reduce((sum, num) => sum + num, 0) / sums.length).toFixed(1);
  };

  const calculateEvenPercentage = (data: any[]) => {
    let totalNumbers = 0;
    let evenNumbers = 0;
    
    data.forEach(draw => {
      draw.numbers.forEach((num: number) => {
        totalNumbers++;
        if (num % 2 === 0) evenNumbers++;
      });
    });
    
    return Math.round((evenNumbers / totalNumbers) * 100);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 p-6">
      {/* Header */}
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

      {/* Game Selector */}
      <div className="glass-card p-6 mb-6">
        <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
          <span className="mr-2">🎯</span>
          Selectează Jocul de Loterie
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button
            onClick={() => setSelectedGame('joker')}
            className={`game-card p-4 rounded-lg border-2 transition-all ${
              selectedGame === 'joker' 
                ? 'border-green-400 bg-green-500/20' 
                : 'border-green-400/30 bg-green-500/10 hover:bg-green-500/20'
            }`}
          >
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
          </button>

          <button
            onClick={() => setSelectedGame('649')}
            className={`game-card p-4 rounded-lg border-2 transition-all ${
              selectedGame === '649' 
                ? 'border-blue-400 bg-blue-500/20' 
                : 'border-blue-400/30 bg-blue-500/10 hover:bg-blue-500/20'
            }`}
          >
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
          </button>

          <button
            onClick={() => setSelectedGame('540')}
            className={`game-card p-4 rounded-lg border-2 transition-all ${
              selectedGame === '540' 
                ? 'border-purple-400 bg-purple-500/20' 
                : 'border-purple-400/30 bg-purple-500/10 hover:bg-purple-500/20'
            }`}
          >
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
          </button>
        </div>
      </div>

      {/* Quick Stats */}
      {stats && (
        <div className="glass-card p-6 mb-6">
          <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
            <span className="mr-2">📊</span>
            Statistici Rapide
          </h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="stat-card text-center p-4 bg-white/5 rounded-lg border border-white/10">
              <div className="text-2xl font-bold text-green-400">{stats.totalDraws.toLocaleString()}</div>
              <div className="text-sm text-gray-300">Extrageri totale</div>
            </div>
            <div className="stat-card text-center p-4 bg-white/5 rounded-lg border border-white/10">
              <div className="text-2xl font-bold text-blue-400">{stats.mostFrequent}</div>
              <div className="text-sm text-gray-300">Numărul cel mai frecvent</div>
            </div>
            <div className="stat-card text-center p-4 bg-white/5 rounded-lg border border-white/10">
              <div className="text-2xl font-bold text-purple-400">{stats.averageSum}</div>
              <div className="text-sm text-gray-300">Suma medie</div>
            </div>
            <div className="stat-card text-center p-4 bg-white/5 rounded-lg border border-white/10">
              <div className="text-2xl font-bold text-yellow-400">{stats.evenPercentage}%</div>
              <div className="text-sm text-gray-300">Numere pare</div>
            </div>
          </div>
        </div>
      )}

      {/* Recent Draws */}
      <div className="glass-card p-6 mb-6">
        <h2 className="text-xl font-semibold text-white mb-4 flex items-center">
          <span className="mr-2">🕒</span>
          Ultimele Extrageri
        </h2>
        <div className="space-y-3">
          {recentDraws.map((draw, index) => (
            <DrawCard key={index} draw={draw} gameType={selectedGame} />
          ))}
        </div>
      </div>
    </div>
  );
};

export default HomeTab;
