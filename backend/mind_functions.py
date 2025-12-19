"""
MindMate AI Functions Module
Contains all helper functions and LLM integration
"""

import requests
import json
import os
import datetime
import statistics
from datetime import datetime

# Configuration
LLM_API_KEY = os.getenv("LLM_API_KEY", "sk-your-key")
LLM_ENDPOINT = os.getenv("LLM_ENDPOINT", "https://api.openai.com/v1/chat/completions")
LLM_MODEL = os.getenv("LLM_MODEL", "gpt-3.5-turbo")

class EmotionalAnalyzer:
    """Analytical LLM for emotional extraction"""
    
    @staticmethod
    def analyze_emotion_from_text(text):
        """Analytical Prompt: Extract emotion information from journal text"""
        prompt = f"""You are an expert emotional intelligence analyst. Analyze the following journal entry and extract:
1. Primary emotion(s) being expressed
2. Emotional intensity on a scale of 1-10
3. Identified triggers or causes
4. Sentiment (positive/neutral/negative)
5. Key emotional themes
6. Suggested coping strategies

Journal Entry:
"{text}"

Please provide a structured JSON response with keys: emotions, intensity, triggers, sentiment, themes, suggested_strategies"""

        try:
            response = requests.post(
                LLM_ENDPOINT,
                headers={
                    "Authorization": f"Bearer {LLM_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": LLM_MODEL,
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": 0.7,
                    "max_tokens": 500
                }
            )
            
            if response.status_code == 200:
                content = response.json()['choices'][0]['message']['content']
                result = json.loads(content)
                return result
            else:
                return {"error": f"API Error: {response.status_code}"}
        except Exception as e:
            return {"error": str(e)}

class SupportiveCompanion:
    """Generative LLM for empathetic responses and coping strategies"""
    
    @staticmethod
    def generate_support_response(emotion, intensity, triggers, context=""):
        """Generative Prompt: Create empathetic response and coping strategies"""
        prompt = f"""You are a compassionate mental wellness companion. Based on the following emotional state, provide supportive guidance:

Emotion: {emotion}
Intensity (1-10): {intensity}
Identified Triggers: {', '.join(triggers)}
Additional Context: {context if context else 'None provided'}

Please provide a response that includes:
1. Empathetic acknowledgment of their feelings
2. 3-5 specific, actionable coping strategies
3. A personalized affirmation
4. Recommended activities to help
5. When to seek additional support

Format as a warm, supportive message suitable for emotional support."""

        try:
            response = requests.post(
                LLM_ENDPOINT,
                headers={
                    "Authorization": f"Bearer {LLM_API_KEY}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": LLM_MODEL,
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": 0.8,
                    "max_tokens": 800
                }
            )
            
            if response.status_code == 200:
                message = response.json()['choices'][0]['message']['content']
                return {"message": message}
            else:
                return {"error": f"API Error: {response.status_code}"}
        except Exception as e:
            return {"error": str(e)}

# Initialize instances
analyzer = EmotionalAnalyzer()
companion = SupportiveCompanion()

# Walker callable functions
def analyze_emotion_by_llm(text):
    return analyzer.analyze_emotion_from_text(text)

def generate_message_by_llm(emotion, intensity, triggers, context):
    return companion.generate_support_response(emotion, intensity, triggers, context)

def generate_breathing_by_llm(emotion, intensity, duration):
    prompt = f"""You are an expert in breathing techniques and mindfulness. Create a personalized breathing exercise for someone experiencing:

Emotion: {emotion}
Intensity Level: {intensity}/10
Preferred Duration: {duration} seconds

Design a breathing exercise that:
1. Matches the emotion and intensity level
2. Fits within the time constraint
3. Is easy to follow and remember
4. Includes specific counts and repetitions
5. Provides calming or energizing as appropriate

Format as clear, step-by-step instructions with a catchy name."""
    
    try:
        response = requests.post(
            LLM_ENDPOINT,
            headers={
                "Authorization": f"Bearer {LLM_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": LLM_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.7,
                "max_tokens": 600
            }
        )
        
        if response.status_code == 200:
            return response.json()['choices'][0]['message']['content']
        else:
            return {"error": f"API Error: {response.status_code}"}
    except Exception as e:
        return {"error": str(e)}

def generate_affirmation_by_llm(emotion, intensity, user_name, triggers):
    prompt = f"""Create a personalized, powerful affirmation for someone named {user_name} who is experiencing {emotion} (intensity: {intensity}/10).
Triggers: {', '.join(triggers) if triggers else 'Not specified'}

The affirmation should be:
1. Personally empowering
2. Realistic and believable
3. Focused on strength and resilience
4. 1-2 sentences maximum

Also suggest how to use it (when to repeat it, how many times, etc.)"""
    
    try:
        response = requests.post(
            LLM_ENDPOINT,
            headers={
                "Authorization": f"Bearer {LLM_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": LLM_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.7,
                "max_tokens": 300
            }
        )
        
        if response.status_code == 200:
            return response.json()['choices'][0]['message']['content']
        else:
            return {"error": f"API Error: {response.status_code}"}
    except Exception as e:
        return {"error": str(e)}

# Helper functions
def extract_keywords(text):
    """Extract keywords from journal text"""
    words = text.lower().split()
    return words[:10]

def get_latest_emotion(user_id):
    """Get most recent emotion entry for user"""
    return {"name": "calm", "intensity": 6.5}

def traverse_emotion_triggers(emotion):
    """Get triggers connected to emotion"""
    return []

def traverse_emotion_activities(emotion):
    """Get activities connected to emotion"""
    return []

def get_relevant_suggestions(emotion):
    """Get suggestions relevant to emotion"""
    return []

def get_emotions_by_date_range(user_id, num_days):
    """Get all emotions from past N days"""
    return []

def count_emotion_frequencies(emotions_list):
    """Count frequency of each emotion"""
    freq = {}
    for e in emotions_list:
        freq[e] = freq.get(e, 0) + 1
    return freq

def analyze_trends(emotion_counts):
    """Analyze trend from emotion counts"""
    return "stable"

def generate_habit_recommendations(trends):
    """Generate habit recommendations from trends"""
    return []

def find_emotion_by_name(emotion_name):
    """Find emotion node by name"""
    return None

def traverse_outgoing_edges(node, edge_type):
    """Traverse outgoing edges of a node"""
    return []

def rank_activities_by_effectiveness(activities, intensity):
    """Rank activities by effectiveness"""
    return activities

def get_user_entries_by_date(user_id, lookback_days):
    """Get user entries within date range"""
    return []

def traverse_entry_emotions(entry):
    """Get emotions connected to entry"""
    return []

def sort_by_frequency(freq_dict):
    """Sort dictionary by frequency"""
    return sorted(freq_dict.items(), key=lambda x: x[1], reverse=True)

def get_emotion_counts_by_period(user_id, period_days):
    """Get emotion frequency counts"""
    return {}

def get_emotions_timeline(user_id, lookback_days):
    """Get emotions in chronological order"""
    return []

def calculate_intensity_trend(emotions_timeline):
    """Calculate trend direction"""
    if len(emotions_timeline) < 2:
        return "insufficient_data"
    
    mid = len(emotions_timeline) // 2
    first_half = emotions_timeline[:mid]
    second_half = emotions_timeline[mid:]
    
    first_avg = statistics.mean([e['intensity'] for e in first_half])
    second_avg = statistics.mean([e['intensity'] for e in second_half])
    
    if second_avg > first_avg + 1:
        return "improving"
    elif second_avg < first_avg - 1:
        return "declining"
    else:
        return "stable"

def calculate_volatility(emotions_timeline):
    """Calculate mood volatility (swing magnitude)"""
    if len(emotions_timeline) < 2:
        return 0
    
    intensities = [e['intensity'] for e in emotions_timeline]
    volatility = statistics.stdev(intensities) if len(intensities) > 1 else 0
    
    return min(volatility * 10, 100)
