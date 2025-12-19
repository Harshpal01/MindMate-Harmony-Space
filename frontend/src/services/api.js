import { jacSpawn } from 'jac-client';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_JASECI_API_URL || 'http://localhost:5000';

// Fallback axios client for non-walker endpoints
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
    const response = await jacSpawn('log_mood', {
      user_id: userId,
      mood_name: moodName,
      intensity: intensity,
      journal_text: journalText,
    });
    return response;
  } catch (error) {
    console.error('Error logging mood:', error);
    throw error;
  }
};

export const analyzeJournal = async (userId, journalText) => {
  try {
    const response = await jacSpawn('emotion_from_text', {
      journal_text: journalText,
      user_id: userId,
    });
    return response;
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
    const response = await jacSpawn('get_daily_summary', {
      user_id: userId,
    });
    return response;
  } catch (error) {
    console.error('Error getting daily summary:', error);
    throw error;
  }
};

export const getWeeklySummary = async (userId) => {
  try {
    const response = await jacSpawn('get_weekly_summary', {
      user_id: userId,
    });
    return response;
  } catch (error) {
    console.error('Error getting weekly summary:', error);
    throw error;
  }
};

export const getRecommendations = async (emotion, intensity) => {
  try {
    const response = await jacSpawn('recommend_activities', {
      emotion_name: emotion,
      intensity: intensity,
    });
    return response;
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
    const response = await jacSpawn('generate_support_message', {
      emotion_name: emotion,
      intensity_score: intensity,
      detected_triggers: triggers,
      user_context: context,
    });
    return response;
  } catch (error) {
    console.error('Error generating support message:', error);
    throw error;
  }
};

export const generateBreathingExercise = async (emotion, intensity, duration = 300) => {
  try {
    const response = await jacSpawn('generate_breathing_exercise', {
      emotion_name: emotion,
      intensity_score: intensity,
      duration_preference: duration,
    });
    return response;
  } catch (error) {
    console.error('Error generating breathing exercise:', error);
    throw error;
  }
};

export const generateAffirmation = async (emotion, intensity, userName = 'Friend', triggers = []) => {
  try {
    const response = await jacSpawn('generate_affirmation', {
      emotion_name: emotion,
      intensity_score: intensity,
      user_name: userName,
      detected_triggers: triggers,
    });
    return response;
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
    const response = await jacSpawn('find_repeating_triggers', {
      user_id: userId,
      lookback_days: lookbackDays,
    });
    return response;
  } catch (error) {
    console.error('Error finding repeating triggers:', error);
    throw error;
  }
};

export const findCommonEmotions = async (userId, periodDays = 30) => {
  try {
    const response = await jacSpawn('find_common_emotions', {
      user_id: userId,
      period_days: periodDays,
    });
    return response;
  } catch (error) {
    console.error('Error finding common emotions:', error);
    throw error;
  }
};

export const calculateEmotionalTrends = async (userId, lookbackDays = 14) => {
  try {
    const response = await jacSpawn('calculate_emotional_trends', {
      user_id: userId,
      lookback_days: lookbackDays,
    });
    return response;
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

