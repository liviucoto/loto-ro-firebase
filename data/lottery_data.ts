// LotoRO - Date istorice pentru toate jocurile de loterie românești
// Generat automat din arhivele CSV oficiale

// Joker - 5 numere din 45 + Joker (1-20)
// Perioada: 2000-09-14 până în prezent
// Total extrageri: 2,082
export { dataJoker } from './data_joker';

// 6 din 49 - 6 numere din 49
// Perioada: 1993-08-08 până în prezent  
// Total extrageri: 2,478
export { data649 } from './data_649';

// 5 din 40 - 5 numere din 40
// Perioada: 1995-01-12 până în prezent
// Total extrageri: 2,371
export { data540 } from './data_540';

// Tipuri de date pentru TypeScript
export interface LotteryDraw {
  date: string;
  game: string;
  numbers: number[];
  joker?: number; // Doar pentru Joker
}

// Funcții helper pentru lucrul cu datele
export const getGameData = (gameType: 'joker' | '649' | '540') => {
  switch (gameType) {
    case 'joker':
      return dataJoker;
    case '649':
      return data649;
    case '540':
      return data540;
    default:
      return [];
  }
};

export const getTotalDraws = () => {
  return {
    joker: dataJoker.length,
    '649': data649.length,
    '540': data540.length,
    total: dataJoker.length + data649.length + data540.length
  };
};

export const getDateRange = (gameType: 'joker' | '649' | '540') => {
  const data = getGameData(gameType);
  if (data.length === 0) return { start: null, end: null };
  
  const dates = data.map(draw => new Date(draw.date));
  return {
    start: new Date(Math.min(...dates.map(d => d.getTime()))),
    end: new Date(Math.max(...dates.map(d => d.getTime())))
  };
};
