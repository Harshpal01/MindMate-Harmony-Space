import React, { useState } from 'react';
import MoodLogger from './components/MoodLogger';
import DailySummary from './components/DailySummary';
import WeeklyTrends from './components/WeeklyTrends';
import './App.css';

function App() {
  const [userId] = useState('user_001');
  const [activeTab, setActiveTab] = useState('mood');

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-content">
          <h1>🌟 MindMate Harmony Space</h1>
          <p>Your AI Emotional Wellness Companion</p>
        </div>
      </header>

      <nav className="app-nav">
        <button
          className={`nav-btn ${activeTab === 'mood' ? 'active' : ''}`}
          onClick={() => setActiveTab('mood')}
        >
          📝 Log Mood
        </button>
        <button
          className={`nav-btn ${activeTab === 'daily' ? 'active' : ''}`}
          onClick={() => setActiveTab('daily')}
        >
          🌞 Daily Check-in
        </button>
        <button
          className={`nav-btn ${activeTab === 'weekly' ? 'active' : ''}`}
          onClick={() => setActiveTab('weekly')}
        >
          📊 Weekly Trends
        </button>
      </nav>

      <main className="app-main">
        {activeTab === 'mood' && <MoodLogger userId={userId} />}
        {activeTab === 'daily' && <DailySummary userId={userId} />}
        {activeTab === 'weekly' && <WeeklyTrends userId={userId} />}
      </main>

      <footer className="app-footer">
        <p>
          🧠 Powered by Jaseci OSP & AI | Your wellness journey matters
        </p>
      </footer>
    </div>
  );
}

export default App;
