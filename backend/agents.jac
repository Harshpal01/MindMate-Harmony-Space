"""
MindMate Harmony Space - AI Agents
Multi-agent system with byLLM integration for emotional analysis and support generation
"""

import:py from py_modules {
    requests,
    json,
    os,
}

# ============================================================================
# AGENT 1: EMOTIONAL ANALYZER (Analytical byLLM)
# ============================================================================

walker emotion_from_text {
    """
    Analytical LLM Agent: Analyzes journal text to extract emotions, triggers, and intensity
    
    Input: journal_text
    Output: 
        - emotion_classification (list of emotions with confidence scores)
        - detected_triggers (list of identified triggers)
        - intensity_score (1-10)
        - keywords (extracted key phrases)
        - sentiment (positive/neutral/negative)
    """
    has journal_text: str;
    has user_id: str = "";
    
    root {
        # Call analytical LLM
        analysis_result = analyze_emotion_by_llm(journal_text);
        
        report {
            "user_id": user_id,
            "raw_text": journal_text,
            "analysis": analysis_result,
            "status": "complete"
        };
    }
}

# ============================================================================
# AGENT 2: SUPPORTIVE COMPANION (Generative byLLM)
# ============================================================================

walker generate_support_message {
    """
    Generative LLM Agent: Creates empathetic responses and coping strategies
    
    Input: 
        - emotion_name
        - intensity_score
        - detected_triggers
        - user_context (optional)
    
    Output:
        - empathetic_message (personalized supportive response)
        - coping_strategies (list of actionable tips)
        - affirmation (personalized affirmation)
        - suggested_activities (ranked activity recommendations)
    """
    has emotion_name: str;
    has intensity_score: float;
    has detected_triggers: list[str];
    has user_context: str = "";
    
    root {
        # Call generative LLM for support message
        support_message = generate_message_by_llm(
            emotion_name,
            intensity_score,
            detected_triggers,
            user_context
        );
        
        report {
            "emotion": emotion_name,
            "intensity": intensity_score,
            "message": support_message,
            "generated_at": std.datetime.now().isoformat()
        };
    }
}

walker generate_breathing_exercise {
    """
    Generative LLM Agent: Creates personalized breathing exercises
    
    Input:
        - emotion_name
        - intensity_score
        - duration_preference (seconds)
    
    Output:
        - exercise_name (e.g., "4-7-8 Breathing", "Box Breathing")
        - steps (list of detailed breathing instructions)
        - duration_seconds
        - repetitions
        - best_for (which emotions/states it helps with)
    """
    has emotion_name: str;
    has intensity_score: float;
    has duration_preference: int = 300;  # 5 minutes default
    
    root {
        # Call generative LLM for breathing exercise
        exercise = generate_breathing_by_llm(
            emotion_name,
            intensity_score,
            duration_preference
        );
        
        report {
            "emotion": emotion_name,
            "intensity": intensity_score,
            "exercise": exercise,
            "duration_seconds": duration_preference
        };
    }
}

walker generate_affirmation {
    """
    Generative LLM Agent: Creates personalized affirmations
    
    Input:
        - emotion_name
        - intensity_score
        - user_name (optional)
        - detected_triggers (optional)
    
    Output:
        - affirmation_text (personalized, positive affirmation)
        - affirmation_type (self-love, strength, resilience, etc.)
        - how_to_use (suggestions for using the affirmation)
    """
    has emotion_name: str;
    has intensity_score: float;
    has user_name: str = "Friend";
    has detected_triggers: list[str] = [];
    
    root {
        affirmation = generate_affirmation_by_llm(
            emotion_name,
            intensity_score,
            user_name,
            detected_triggers
        );
        
        report {
            "emotion": emotion_name,
            "affirmation": affirmation,
            "generated_at": std.datetime.now().isoformat()
        };
    }
}

# ============================================================================
# AGENT 3: TREND DETECTION & PLANNER
# ============================================================================

walker generate_weekly_reflection {
    """
    Analytical/Generative LLM Agent: Creates comprehensive weekly emotional summary
    
    Input:
        - user_id
        - weekly_emotions (dict of emotion frequencies)
        - detected_patterns (list of identified patterns)
        - week_number
    
    Output:
        - weekly_summary (prose summary of emotional week)
        - key_insights (bullet points of important patterns)
        - progress_vs_last_week (comparison)
        - recommended_focus (what to focus on this week)
    """
    has user_id: str;
    has weekly_emotions: dict[str, int];
    has detected_patterns: list[str];
    has week_number: int = 1;
    
    root {
        reflection = generate_weekly_reflection_by_llm(
            weekly_emotions,
            detected_patterns,
            week_number
        );
        
        report {
            "user_id": user_id,
            "week_number": week_number,
            "reflection": reflection,
            "generated_at": std.datetime.now().isoformat()
        };
    }
}

walker suggest_habit_improvements {
    """
    Generative LLM Agent: Suggests specific habits to improve emotional wellbeing
    
    Input:
        - detected_triggers (list)
        - dominant_emotions (list)
        - current_habits (list of activities user has tried)
        - intensity_average (average emotional intensity)
    
    Output:
        - new_habits_to_try (list with descriptions)
        - implementation_tips (how to start each habit)
        - expected_benefits (what each habit helps with)
        - habit_priority (ranked by potential impact)
    """
    has detected_triggers: list[str];
    has dominant_emotions: list[str];
    has current_habits: list[str];
    has intensity_average: float;
    
    root {
        habits = suggest_habits_by_llm(
            detected_triggers,
            dominant_emotions,
            current_habits,
            intensity_average
        );
        
        report {
            "suggested_habits": habits,
            "based_on": {
                "triggers": detected_triggers,
                "emotions": dominant_emotions,
                "average_intensity": intensity_average
            },
            "generated_at": std.datetime.now().isoformat()
        };
    }
}

# ============================================================================
# LLM INTEGRATION FUNCTIONS
# ============================================================================

:py {
import requests
import json
import os
from datetime import datetime

# Configuration
LLM_API_KEY = os.getenv("LLM_API_KEY", "sk-your-key")
LLM_ENDPOINT = os.getenv("LLM_ENDPOINT", "https://api.openai.com/v1/chat/completions")
LLM_MODEL = os.getenv("LLM_MODEL", "gpt-3.5-turbo")

class EmotionalAnalyzer:
    """Analytical LLM for emotional extraction"""
    
    @staticmethod
    def analyze_emotion_from_text(text):
        """
        Analytical Prompt: Extract emotion information from journal text
        """
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
                # Parse JSON from response
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
        """
        Generative Prompt: Create empathetic response and coping strategies
        """
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
    
    @staticmethod
    def generate_breathing_exercise(emotion, intensity, duration=300):
        """
        Generative Prompt: Create personalized breathing exercise
        """
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
                exercise = response.json()['choices'][0]['message']['content']
                return {"exercise": exercise}
            else:
                return {"error": f"API Error: {response.status_code}"}
        except Exception as e:
            return {"error": str(e)}

# Initialize agent instances
analyzer = EmotionalAnalyzer()
companion = SupportiveCompanion()

# Walker callable functions
def analyze_emotion_by_llm(text):
    return analyzer.analyze_emotion_from_text(text)

def generate_message_by_llm(emotion, intensity, triggers, context):
    return companion.generate_support_response(emotion, intensity, triggers, context)

def generate_breathing_by_llm(emotion, intensity, duration):
    return companion.generate_breathing_exercise(emotion, intensity, duration)

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

def generate_weekly_reflection_by_llm(emotions_dict, patterns, week_num):
    emotions_str = ", ".join([f"{e}: {c} times" for e, c in emotions_dict.items()])
    patterns_str = "\n".join([f"- {p}" for p in patterns])
    
    prompt = f"""Create a compassionate weekly emotional reflection for someone whose emotional data shows:

Emotions This Week: {emotions_str}
Identified Patterns: 
{patterns_str}

Week Number: {week_num}

Provide:
1. A warm, encouraging summary of their emotional week
2. Key insights about patterns
3. Progress observations (if week_num > 1, assume previous data exists)
4. What to focus on this coming week
5. One specific actionable step

Format as a personal, supportive letter."""

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
                "max_tokens": 1000
            }
        )
        
        if response.status_code == 200:
            return response.json()['choices'][0]['message']['content']
        else:
            return {"error": f"API Error: {response.status_code}"}
    except Exception as e:
        return {"error": str(e)}

def suggest_habits_by_llm(triggers, emotions, current_habits, avg_intensity):
    prompt = f"""As a wellness coach, suggest new habits to help someone improve their emotional wellbeing given:

Current Emotional Profile:
- Common Triggers: {', '.join(triggers)}
- Dominant Emotions: {', '.join(emotions)}
- Average Emotional Intensity: {avg_intensity}/10
- Habits Already Trying: {', '.join(current_habits) if current_habits else 'None listed'}

Suggest 5 NEW habits they should try that:
1. Address their specific triggers
2. Help regulate the emotions they experience
3. Are sustainable and realistic
4. Range from easy to moderate difficulty
5. Include both quick daily practices and longer practices

For each habit, provide:
- Name and 1-line description
- How it helps with their specific triggers/emotions
- How to start it
- Expected time commitment
- Expected benefit level (high/medium/low)

Format as a numbered list with clear, actionable guidance."""

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
                "max_tokens": 1200
            }
        )
        
        if response.status_code == 200:
            return response.json()['choices'][0]['message']['content']
        else:
            return {"error": f"API Error: {response.status_code}"}
    except Exception as e:
        return {"error": str(e)}
}
