import React, { useState, useEffect } from 'react';
import { getDailySummary, getRecommendations, generateBreathingExercise } from '../services/api';
import '../styles/DailySummary.css';

export default function DailySummary({ userId }) {
  const [summary, setSummary] = useState(null);
  const [recommendations, setRecommendations] = useState([]);
  const [breathingExercise, setBreathingExercise] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeTab, setActiveTab] = useState('summary');

  useEffect(() => {
    const fetchSummary = async () => {
      try {
        setError(null);
        const result = await getDailySummary(userId);
        setSummary(result);

        if (result && result.current_mood) {
          const recs = await getRecommendations(result.current_mood, result.intensity);
          setRecommendations(recs.recommendations || []);

          const exercise = await generateBreathingExercise(result.current_mood, result.intensity);
          setBreathingExercise(exercise.exercise || '');
        }
      } catch (error) {
        console.error('Error fetching daily summary:', error);
        setError('Unable to load your daily summary right now. Please try again in a moment.');
      } finally {
        setLoading(false);
      }
    };

    fetchSummary();
  }, [userId]);

  if (loading) {
    return <div className="daily-summary loading">Loading your daily summary...</div>;
  }

  if (error) {
    return (
      <div className="daily-summary error-state">
        <h2>🌟 Your Daily Emotional Check-in</h2>
        <p className="error-message">{error}</p>
      </div>
    );
  }

  return (
    <div className="daily-summary">
      <h2>🌟 Your Daily Emotional Check-in</h2>

      {summary && (
        <div className="summary-content">
          {/* Current Mood */}
          <div className="current-mood-card">
            <h3>Current Mood</h3>
            <div className="mood-display">
              <p className="mood-name">{summary.current_mood || 'Not yet logged'}</p>
              <div className="intensity-bar">
                <div
                  className="intensity-fill"
                  style={{ width: `${summary.intensity ? (summary.intensity / 10) * 100 : 0}%` }}
                />
              </div>
              <p className="intensity-text">
                Intensity: {summary.intensity != null ? summary.intensity.toFixed(1) : 'N/A'}/10
              </p>
            </div>
          </div>

          {/* Tabs */}
          <div className="tabs">
            <button
              className={`tab-btn ${activeTab === 'summary' ? 'active' : ''}`}
              onClick={() => setActiveTab('summary')}
            >
              Summary
            </button>
            <button
              className={`tab-btn ${activeTab === 'recommendations' ? 'active' : ''}`}
              onClick={() => setActiveTab('recommendations')}
            >
              Recommendations
            </button>
            <button
              className={`tab-btn ${activeTab === 'breathing' ? 'active' : ''}`}
              onClick={() => setActiveTab('breathing')}
            >
              Breathing
            </button>
          </div>

          {/* Tab Content */}
          <div className="tab-content">
            {activeTab === 'summary' && Array.isArray(summary.triggers) && summary.triggers.length > 0 && (
              <div className="summary-tab">
                <h4>Identified Triggers</h4>
                <ul>
                  {summary.triggers.map((trigger, idx) => (
                    <li key={idx}>{trigger}</li>
                  ))}
                </ul>
              </div>
            )}

            {activeTab === 'summary' && (!summary.triggers || summary.triggers.length === 0) && (
              <div className="summary-tab">
                <h4>Identified Triggers</h4>
                <p>No specific triggers identified yet. Logging more moods and journals will help me learn your patterns.</p>
              </div>
            )}

            {activeTab === 'recommendations' && recommendations.length > 0 && (
              <div className="recommendations-tab">
                <h4>Recommended Activities</h4>
                {recommendations.map((activity, idx) => (
                  <div key={idx} className="recommendation-item">
                    <h5>{activity.name || activity.activity || activity}</h5>
                    <p>
                      {activity.description ||
                        (activity.duration_minutes
                          ? `${activity.duration_minutes} minutes`
                          : activity.duration
                          ? `${activity.duration} minutes`
                          : '')}
                    </p>
                  </div>
                ))}
              </div>
            )}

            {activeTab === 'recommendations' && recommendations.length === 0 && (
              <div className="recommendations-tab">
                <h4>Recommended Activities</h4>
                <p>Log a mood to see personalized activity recommendations tailored to how you feel.</p>
              </div>
            )}

            {activeTab === 'breathing' && breathingExercise && (
              <div className="breathing-tab">
                <h4>Guided Breathing Exercise</h4>
                <div className="exercise-content">
                  <p>{breathingExercise}</p>
                </div>
              </div>
            )}
          </div>

          {/* Timestamp */}
          <p className="timestamp">
            Last updated: {summary.timestamp ? new Date(summary.timestamp).toLocaleTimeString() : 'Just now'}
          </p>
        </div>
      )}
    </div>
  );
}
