import React, { useState, useEffect } from 'react';
import { getWeeklySummary, findCommonEmotions, calculateEmotionalTrends } from '../services/api';
import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts';
import '../styles/WeeklyTrends.css';

export default function WeeklyTrends({ userId }) {
  const [weeklyData, setWeeklyData] = useState(null);
  const [emotionData, setEmotionData] = useState([]);
  const [trendData, setTrendData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchTrends = async () => {
      try {
        setError(null);
        const [weekly, emotions, trends] = await Promise.all([
          getWeeklySummary(userId),
          findCommonEmotions(userId),
          calculateEmotionalTrends(userId)
        ]);

        setWeeklyData(weekly);
        
        // Format emotion data for chart
        // Backend returns common_emotions as array of [emotion, count] tuples
        if (emotions && emotions.common_emotions && Array.isArray(emotions.common_emotions)) {
          const chartData = emotions.common_emotions.map(([emotion, count]) => ({
            emotion: emotion,
            count: count
          }));
          setEmotionData(chartData);
        } else if (weekly && weekly.emotion_distribution) {
          // Fallback to emotion_distribution from weekly summary
          const chartData = Object.entries(weekly.emotion_distribution).map(([emotion, count]) => ({
            emotion,
            count
          }));
          setEmotionData(chartData);
        }

        setTrendData(trends);
      } catch (error) {
        console.error('Error fetching trends:', error);
        setError('Unable to load your weekly insights right now. Please try again later.');
      } finally {
        setLoading(false);
      }
    };

    fetchTrends();
  }, [userId]);

  if (loading) {
    return <div className="weekly-trends loading">Loading your weekly insights...</div>;
  }

  if (error) {
    return (
      <div className="weekly-trends error-state">
        <h2>📊 Weekly Emotional Trends</h2>
        <p className="error-message">{error}</p>
      </div>
    );
  }

  return (
    <div className="weekly-trends">
      <h2>📊 Weekly Emotional Trends</h2>

      <div className="trends-grid">
        {/* Emotion Distribution Chart */}
        {emotionData.length > 0 && (
          <div className="chart-container">
            <h3>Emotion Distribution</h3>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={emotionData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="emotion" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="count" fill="#8884d8" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}

        {emotionData.length === 0 && (
          <div className="chart-container">
            <h3>Emotion Distribution</h3>
            <p>Once you log more moods over several days, I’ll show you which emotions appear most often.</p>
          </div>
        )}

        {/* Trend Analysis Card */}
        {trendData && trendData.trend && (
          <div className="trend-card">
            <h3>Emotional Trend</h3>
            <div className="trend-metrics">
              <div className="metric">
                <p className="metric-label">Trend Direction</p>
                <p className={`metric-value trend-${trendData.trend}`}>
                  {trendData.trend === 'improving' && '📈 Improving'}
                  {trendData.trend === 'declining' && '📉 Declining'}
                  {trendData.trend === 'stable' && '→ Stable'}
                  {!['improving', 'declining', 'stable'].includes(trendData.trend) && 'Not enough data yet'}
                </p>
              </div>
              <div className="metric">
                <p className="metric-label">Stability Score</p>
                <p className="metric-value">
                  {trendData.stability_score != null 
                    ? (typeof trendData.stability_score === 'number' 
                      ? `${(trendData.stability_score * 100).toFixed(1)}%` 
                      : `${trendData.stability_score}%`)
                    : 'N/A'}
                </p>
              </div>
              <div className="metric">
                <p className="metric-label">Volatility</p>
                <p className="metric-value">
                  {trendData.volatility != null 
                    ? (typeof trendData.volatility === 'number'
                      ? trendData.volatility.toFixed(1)
                      : trendData.volatility)
                    : 'N/A'}
                </p>
              </div>
            </div>
          </div>
        )}

        {!trendData && (
          <div className="trend-card">
            <h3>Emotional Trend</h3>
            <p>Log moods regularly over at least a few days and I’ll help you see how your emotional intensity is changing over time.</p>
          </div>
        )}

        {/* Weekly Summary Card */}
        {weeklyData && (
          <div className="summary-card">
            <h3>Weekly Summary</h3>
            <div className="summary-stats">
              <p><strong>Total Entries:</strong> {weeklyData.total_entries ?? (weeklyData.weekly_moods ? weeklyData.weekly_moods.length : 0)}</p>
              <p><strong>Period:</strong> Last 7 days</p>
              
              {weeklyData.dominant_emotions && (
                <div className="dominant-emotions">
                  <strong>Most Common Emotions:</strong>
                  <ul>
                    {Object.entries(weeklyData.dominant_emotions)
                      .sort(([, a], [, b]) => b - a)
                      .slice(0, 3)
                      .map(([emotion, count]) => (
                        <li key={emotion}>{emotion}: {count} times</li>
                      ))}
                  </ul>
                </div>
              )}

              {weeklyData.trend_analysis && (
                <div className="trend-analysis">
                  <strong>Analysis:</strong>
                  <p>{weeklyData.trend_analysis}</p>
                </div>
              )}
            </div>
          </div>
        )}
      </div>

      {/* Recommendations Card */}
      {weeklyData && weeklyData.habit_recommendations && (
        <div className="recommendations-card">
          <h3>💡 Recommended Actions for Next Week</h3>
          <div className="recommendations-list">
            {Array.isArray(weeklyData.habit_recommendations) 
              ? weeklyData.habit_recommendations.map((rec, idx) => (
                  <div key={idx} className="recommendation">
                    <p>{rec}</p>
                  </div>
                ))
              : <p>{weeklyData.habit_recommendations}</p>
            }
          </div>
        </div>
      )}
    </div>
  );
}
