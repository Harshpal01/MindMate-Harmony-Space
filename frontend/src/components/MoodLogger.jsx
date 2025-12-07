import React, { useState } from 'react';
import { logMood, generateSupportMessage } from '../services/api';
import '../styles/MoodLogger.css';

const MOOD_OPTIONS = [
  { name: 'happy', emoji: '😊', label: 'Happy' },
  { name: 'sad', emoji: '😢', label: 'Sad' },
  { name: 'anxious', emoji: '😰', label: 'Anxious' },
  { name: 'calm', emoji: '😌', label: 'Calm' },
  { name: 'stressed', emoji: '😫', label: 'Stressed' },
  { name: 'content', emoji: '😊', label: 'Content' },
  { name: 'overwhelmed', emoji: '😵', label: 'Overwhelmed' },
  { name: 'peaceful', emoji: '🧘', label: 'Peaceful' },
  { name: 'excited', emoji: '🤩', label: 'Excited' },
  { name: 'lonely', emoji: '😔', label: 'Lonely' },
];

export default function MoodLogger({ userId, onMoodLogged }) {
  const [selectedMood, setSelectedMood] = useState(null);
  const [intensity, setIntensity] = useState(5);
  const [journalText, setJournalText] = useState('');
  const [loading, setLoading] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [supportData, setSupportData] = useState(null);
  const [error, setError] = useState(null);

  const handleLogMood = async (e) => {
    e.preventDefault();
    if (!selectedMood) {
      setError('Please select a mood before continuing.');
      return;
    }

    setLoading(true);
    setError(null);
    try {
      // Log the mood
      const moodResult = await logMood(userId, selectedMood.name, intensity, journalText);
      console.log('Mood logged:', moodResult);

      // Generate comprehensive support
      const support = await generateSupportMessage(selectedMood.name, intensity, [], journalText);
      
      setSupportData({
        mood: selectedMood,
        intensity: intensity,
        message: support.message || support.data?.message || 'Your feelings have been noted. Take a moment to breathe and be kind to yourself.',
        suggestions: [
          '💬 Talk to someone you trust about how you\'re feeling',
          '🌬️ Try a quick breathing exercise to calm your mind',
          '📝 Journal your thoughts to process your emotions',
          '🚶 Take a walk or engage in light physical activity',
          '🎵 Listen to music that matches or shifts your mood'
        ],
        resources: [
          {
            title: 'Niskize Crisis & Suicide Prevention Helpline (Kenya)',
            phone: '0900 620 800',
          },
          {
            title: 'Niskize Mobile Line (Kenya)',
            phone: '+254 718 227 440',
          },
          {
            title: 'International Association for Suicide Prevention',
            url: 'https://www.iasp.info/resources/Crisis_Centres/',
          },
        ]
      });

      setSubmitted(true);
      if (onMoodLogged) {
        onMoodLogged(moodResult);
      }
    } catch (error) {
      console.error('Error logging mood:', error);
      setError('There was a problem logging your mood. Please try again in a moment.');
    } finally {
      setLoading(false);
    }
  };

  const handleNewMood = () => {
    setSelectedMood(null);
    setIntensity(5);
    setJournalText('');
    setSubmitted(false);
    setSupportData(null);
    setError(null);
  };

  if (submitted && supportData) {
    return (
      <div className="mood-logger-container submitted-state">
        <div className="success-message-full">
          <div className="support-header">
            <h3>✨ We Care About You ✨</h3>
            <p>Your mood has been logged and saved. Here's personalized support:</p>
          </div>

          <div className="support-main-message">
            <div className="mood-display">
              <span className="mood-emoji-large">{supportData.mood.emoji}</span>
              <div className="mood-info">
                <h4>{supportData.mood.label}</h4>
                <p>Intensity: {supportData.intensity}/10</p>
              </div>
            </div>
            
            <div className="support-text">
              <p className="main-message">{supportData.message}</p>
            </div>
          </div>

          <div className="suggestions-section">
            <h4>💡 Things You Can Try Right Now:</h4>
            <ul className="suggestions-list">
              {supportData.suggestions.map((suggestion, idx) => (
                <li key={idx}>{suggestion}</li>
              ))}
            </ul>
          </div>

          <div className="resources-section">
            <h4>🤝 Support Resources (Always Available):</h4>
            <div className="resources-list">
              {supportData.resources.map((resource, idx) => (
                <div key={idx} className="resource-item">
                  <strong>{resource.title}</strong>
                  {resource.phone && <p>📞 {resource.phone}</p>}
                  {resource.text && <p>💬 {resource.text}</p>}
                  {resource.url && <a href={resource.url} target="_blank" rel="noopener noreferrer">Learn more →</a>}
                </div>
              ))}
            </div>
          </div>

          <div className="support-footer">
            <p className="encouragement">
              Remember: Seeking support is a sign of strength. You deserve to feel better. 💙
            </p>
            <button onClick={handleNewMood} className="log-another-btn">
              Log Another Mood
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="mood-logger-container">
      <div className="mood-logger-card">
        <h2>📝 How are you feeling today?</h2>
        {error && <p className="error-message">{error}</p>}
        
        <form onSubmit={handleLogMood}>
          {/* Mood Selection */}
          <div className="mood-selection">
            <p className="section-label">Choose your mood:</p>
            <div className="mood-grid">
              {MOOD_OPTIONS.map((mood) => (
                <button
                  key={mood.name}
                  type="button"
                  className={`mood-btn ${selectedMood?.name === mood.name ? 'selected' : ''}`}
                  onClick={() => setSelectedMood(mood)}
                  title={mood.label}
                >
                  <span className="mood-emoji">{mood.emoji}</span>
                  <span className="mood-label">{mood.label}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Intensity Slider */}
          {selectedMood && (
            <div className="intensity-section">
              <p className="section-label">
                How intense is this feeling? ({intensity}/10)
              </p>
              <input
                type="range"
                min="1"
                max="10"
                value={intensity}
                onChange={(e) => setIntensity(parseInt(e.target.value))}
                className="intensity-slider"
              />
              <div className="intensity-labels">
                <span>Mild</span>
                <span>Moderate</span>
                <span>Intense</span>
              </div>
            </div>
          )}

          {/* Journal Entry */}
          <div className="journal-section">
            <label className="section-label">
              💭 Optional: Tell me more about what you're feeling:
            </label>
            <textarea
              value={journalText}
              onChange={(e) => setJournalText(e.target.value)}
              placeholder="Share your thoughts, what triggered this feeling, or anything on your mind..."
              className="journal-textarea"
              rows={5}
            />
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={!selectedMood || loading}
            className="submit-btn"
          >
            {loading ? 'Logging mood and preparing support...' : 'Log Mood & Get Support'}
          </button>
        </form>
      </div>
    </div>
  );
}
