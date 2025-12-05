import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_JASECI_API_URL || 'http://localhost:5000';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// ============================================================================
// MOOD & JOURNALING ENDPOINTS
// ============================================================================

export const logMood = async (userId, moodName, intensity, journalText = '') => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'log_mood',
      ctx: {
        user_id: userId,
        mood_name: moodName,
        intensity: intensity,
        journal_text: journalText,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error logging mood:', error);
    throw error;
  }
};

export const analyzeJournal = async (userId, journalText) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'emotion_from_text',
      ctx: {
        journal_text: journalText,
        user_id: userId,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error analyzing journal:', error);
    throw error;
  }
};

// ============================================================================
// SUMMARY & RECOMMENDATIONS ENDPOINTS
// ============================================================================

export const getDailySummary = async (userId) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'get_daily_summary',
      ctx: {
        user_id: userId,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error getting daily summary:', error);
    throw error;
  }
};

export const getWeeklySummary = async (userId) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'get_weekly_summary',
      ctx: {
        user_id: userId,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error getting weekly summary:', error);
    throw error;
  }
};

export const getRecommendations = async (emotion, intensity) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'recommend_activities',
      ctx: {
        emotion_name: emotion,
        intensity: intensity,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error getting recommendations:', error);
    throw error;
  }
};

// ============================================================================
// SUPPORT MESSAGE & BREATHING EXERCISE ENDPOINTS
// ============================================================================

export const generateSupportMessage = async (emotion, intensity, triggers = [], context = '') => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'generate_support_message',
      ctx: {
        emotion_name: emotion,
        intensity_score: intensity,
        detected_triggers: triggers,
        user_context: context,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error generating support message:', error);
    throw error;
  }
};

export const generateBreathingExercise = async (emotion, intensity, duration = 300) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'generate_breathing_exercise',
      ctx: {
        emotion_name: emotion,
        intensity_score: intensity,
        duration_preference: duration,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error generating breathing exercise:', error);
    throw error;
  }
};

export const generateAffirmation = async (emotion, intensity, userName = 'Friend', triggers = []) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'generate_affirmation',
      ctx: {
        emotion_name: emotion,
        intensity_score: intensity,
        user_name: userName,
        detected_triggers: triggers,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error generating affirmation:', error);
    throw error;
  }
};

// ============================================================================
// TREND ANALYSIS ENDPOINTS
// ============================================================================

export const findRepeatingTriggers = async (userId, lookbackDays = 30) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'find_repeating_triggers',
      ctx: {
        user_id: userId,
        lookback_days: lookbackDays,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error finding repeating triggers:', error);
    throw error;
  }
};

export const findCommonEmotions = async (userId, periodDays = 30) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'find_common_emotions',
      ctx: {
        user_id: userId,
        period_days: periodDays,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error finding common emotions:', error);
    throw error;
  }
};

export const calculateEmotionalTrends = async (userId, lookbackDays = 14) => {
  try {
    const response = await apiClient.post('/api/walker', {
      walker: 'calculate_emotional_trends',
      ctx: {
        user_id: userId,
        lookback_days: lookbackDays,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Error calculating trends:', error);
    throw error;
  }
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
