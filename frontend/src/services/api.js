import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_JASECI_API_URL || 'http://localhost:8000';

// API client for walker endpoints
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Helper to call jac serve walker endpoints
const callWalker = async (walkerName, fields = {}) => {
  try {
    const response = await apiClient.post(`/walker/${walkerName}`, fields);
    // jac serve returns {result: {...}, reports: [...]}
    // Return the first report if available, otherwise the full response
    if (response.data && response.data.reports && response.data.reports.length > 0) {
      return response.data.reports[0];
    }
    return response.data;
  } catch (error) {
    console.error(`Error calling walker ${walkerName}:`, error);
    throw error;
  }
};

// ============================================================================
// MOOD & JOURNALING ENDPOINTS
// ============================================================================

export const logMood = async (userId, moodName, intensity, journalText = '') => {
  return callWalker('log_mood', {
    user_id: userId,
    mood_name: moodName,
    intensity: intensity,
    journal_text: journalText,
  });
};

export const analyzeJournal = async (userId, journalText) => {
  return callWalker('emotion_from_text', {
    journal_text: journalText,
    user_id: userId,
  });
};

// ============================================================================
// SUMMARY & RECOMMENDATIONS ENDPOINTS
// ============================================================================

export const getDailySummary = async (userId) => {
  return callWalker('get_daily_summary', {
    user_id: userId,
  });
};

export const getWeeklySummary = async (userId) => {
  return callWalker('get_weekly_summary', {
    user_id: userId,
  });
};

export const getRecommendations = async (emotion, intensity) => {
  return callWalker('recommend_activities', {
    emotion_name: emotion,
    intensity: intensity,
  });
};

// ============================================================================
// SUPPORT MESSAGE & BREATHING EXERCISE ENDPOINTS
// ============================================================================

export const generateSupportMessage = async (emotion, intensity, triggers = [], context = '') => {
  return callWalker('generate_support_message', {
    emotion_name: emotion,
    intensity_score: intensity,
    detected_triggers: triggers,
    user_context: context,
  });
};

export const generateBreathingExercise = async (emotion, intensity, duration = 300) => {
  return callWalker('generate_breathing_exercise', {
    emotion_name: emotion,
    intensity_score: intensity,
    duration_preference: duration,
  });
};

export const generateAffirmation = async (emotion, intensity, userName = 'Friend', triggers = []) => {
  return callWalker('generate_affirmation', {
    emotion_name: emotion,
    intensity_score: intensity,
    user_name: userName,
    detected_triggers: triggers,
  });
};

// ============================================================================
// TREND ANALYSIS ENDPOINTS
// ============================================================================

export const findRepeatingTriggers = async (userId, lookbackDays = 30) => {
  return callWalker('find_repeating_triggers', {
    user_id: userId,
    lookback_days: lookbackDays,
  });
};

export const findCommonEmotions = async (userId, periodDays = 30) => {
  return callWalker('find_common_emotions', {
    user_id: userId,
    period_days: periodDays,
  });
};

export const calculateEmotionalTrends = async (userId, lookbackDays = 14) => {
  return callWalker('calculate_emotional_trends', {
    user_id: userId,
    lookback_days: lookbackDays,
  });
};

// ============================================================================
// HEALTH CHECK
// ============================================================================

export const healthCheck = async () => {
  try {
    const response = await apiClient.get('/health');
    return response.data;
  } catch (error) {
    console.error('Health check failed:', error);
    return { status: 'offline' };
  }
};

export default apiClient;

