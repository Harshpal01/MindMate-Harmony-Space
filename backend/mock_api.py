"""
Mock Jaseci API Server for MindMate Harmony Space
This server simulates the Jaseci backend for development/testing purposes.
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import datetime
from pathlib import Path

app = Flask(__name__)
CORS(app)

# Simulated data storage
MOOD_LOG = []
EMOTIONS = {
    "happy": {"emoji": "😊", "intensity": 8},
    "sad": {"emoji": "😢", "intensity": 4},
    "anxious": {"emoji": "😰", "intensity": 7},
    "calm": {"emoji": "😌", "intensity": 2},
    "excited": {"emoji": "🤩", "intensity": 9},
    "frustrated": {"emoji": "😤", "intensity": 6},
    "grateful": {"emoji": "🙏", "intensity": 8},
    "lonely": {"emoji": "😞", "intensity": 5},
    "confident": {"emoji": "💪", "intensity": 8},
    "overwhelmed": {"emoji": "😫", "intensity": 9},
}

ACTIVITIES = {
    "exercise": {"duration": 30, "type": "physical", "emoji": "🏃"},
    "meditation": {"duration": 10, "type": "mindful", "emoji": "🧘"},
    "journaling": {"duration": 15, "type": "creative", "emoji": "📝"},
    "reading": {"duration": 30, "type": "relaxing", "emoji": "📖"},
    "music": {"duration": 20, "type": "relaxing", "emoji": "🎵"},
    "walk": {"duration": 20, "type": "physical", "emoji": "🚶"},
    "socializing": {"duration": 60, "type": "social", "emoji": "👥"},
    "cooking": {"duration": 45, "type": "creative", "emoji": "👨‍🍳"},
    "breathing_exercise": {"duration": 5, "type": "mindful", "emoji": "🌬️"},
    "yoga": {"duration": 25, "type": "physical", "emoji": "🧘‍♀️"},
}

SUGGESTIONS = {
    "breathing_exercise": "Take 5 deep breaths. Inhale for 4 counts, hold for 4, exhale for 6.",
    "affirmation": "You are strong and capable of handling whatever comes your way.",
    "grounding": "Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste.",
    "warm_bath": "A warm bath can help relax your muscles and calm your mind.",
    "music": "Listen to your favorite uplifting music to boost your mood.",
    "nature": "Spend 10 minutes in nature to refresh your perspective.",
    "gratitude": "Write down 3 things you're grateful for today.",
    "movement": "Do some light stretching or movement to get your body energized.",
}


@app.route('/api/walker', methods=['POST'])
def walker_endpoint():
    """Main endpoint for executing walkers"""
    try:
        data = request.json
        walker_name = data.get('walker')
        ctx = data.get('ctx', {})
        
        # Route to appropriate walker handler
        if walker_name == 'log_mood':
            return handle_log_mood(ctx)
        elif walker_name == 'emotion_from_text':
            return handle_emotion_from_text(ctx)
        elif walker_name == 'generate_support_message':
            return handle_generate_support_message(ctx)
        elif walker_name == 'get_daily_summary':
            return handle_get_daily_summary(ctx)
        elif walker_name == 'get_weekly_summary':
            return handle_get_weekly_summary(ctx)
        elif walker_name == 'recommend_activities':
            return handle_recommend_activities(ctx)
        elif walker_name == 'generate_breathing_exercise':
            return handle_generate_breathing_exercise(ctx)
        elif walker_name == 'find_common_emotions':
            return handle_find_common_emotions(ctx)
        elif walker_name == 'calculateEmotionalTrends' or walker_name == 'calculate_emotional_trends':
            return handle_calculate_trends(ctx)
        else:
            return jsonify({"error": f"Unknown walker: {walker_name}"}), 400
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def handle_log_mood(ctx):
    """Handle mood logging"""
    mood_entry = {
        "timestamp": datetime.datetime.now().isoformat(),
        "mood": ctx.get('mood_name', 'unknown'),
        "intensity": ctx.get('intensity', 5),
        "journal": ctx.get('journal_text', ''),
        "user_id": ctx.get('user_id', 'user1'),
    }
    MOOD_LOG.append(mood_entry)
    
    return jsonify({
        "status": "success",
        "message": f"Mood '{mood_entry['mood']}' logged successfully",
        "data": mood_entry
    })


def handle_emotion_from_text(ctx):
    """Analyze journal text for emotions (mock LLM)"""
    journal_text = ctx.get('journal_text', '')
    
    # Simple emotion detection based on keywords
    detected_emotions = []
    keywords = {
        "happy": ["happy", "great", "wonderful", "excited", "love", "joy"],
        "sad": ["sad", "depressed", "down", "unhappy", "terrible", "awful"],
        "anxious": ["anxious", "worried", "nervous", "stressed", "panic", "fear"],
        "calm": ["calm", "peaceful", "relaxed", "serene", "zen", "chill"],
        "frustrated": ["frustrated", "angry", "mad", "irritated", "annoyed"],
    }
    
    text_lower = journal_text.lower()
    for emotion, keywords_list in keywords.items():
        if any(kw in text_lower for kw in keywords_list):
            detected_emotions.append(emotion)
    
    if not detected_emotions:
        detected_emotions = ["calm"]
    
    return jsonify({
        "status": "success",
        "emotions": detected_emotions[:2],
        "intensity": len(detected_emotions) * 3,
        "confidence": 0.85,
        "keywords": detected_emotions
    })


def handle_generate_support_message(ctx):
    """Generate supportive message"""
    mood = ctx.get('mood', 'unknown')
    journal = ctx.get('journal_text', '')
    
    messages = {
        "happy": "That's wonderful! Keep celebrating these positive moments. They fuel your wellbeing! 🌟",
        "sad": "It's okay to feel sad sometimes. Remember, this feeling is temporary. Reach out if you need support. 💙",
        "anxious": "Your feelings are valid. Try taking some deep breaths or talking to someone you trust. You've got this! 🤗",
        "calm": "What a peaceful moment! Cherish this tranquility. 🧘",
        "excited": "Your energy is contagious! Channel this excitement into positive actions. 🚀",
        "frustrated": "It's normal to feel frustrated. Take a step back, breathe, and remember this too shall pass. 💪",
    }
    
    message = messages.get(mood, "Remember, you're doing your best and that's enough. 💖")
    
    return jsonify({
        "status": "success",
        "message": message,
        "type": "support"
    })


def handle_get_daily_summary(ctx):
    """Get daily mood summary"""
    today = datetime.date.today()
    today_entries = [e for e in MOOD_LOG if e["timestamp"].startswith(today.isoformat())]
    
    current_mood = "calm"
    if today_entries:
        current_mood = today_entries[-1]["mood"]
    
    return jsonify({
        "status": "success",
        "current_mood": current_mood,
        "intensity": 5,
        "entries_count": len(today_entries),
        "recommendations": [
            {"activity": "meditation", "duration": 10, "reason": "To find inner peace"},
            {"activity": "walk", "duration": 20, "reason": "Fresh air helps clear your mind"},
            {"activity": "music", "duration": 20, "reason": "Uplifting melodies boost mood"},
        ],
        "suggestions": [
            "Take 5 deep breaths",
            "You are stronger than your struggles",
            "One step at a time"
        ]
    })


def handle_get_weekly_summary(ctx):
    """Get weekly summary with trends"""
    moods = [e["mood"] for e in MOOD_LOG[-7:]]
    mood_counts = {}
    for mood in moods:
        mood_counts[mood] = mood_counts.get(mood, 0) + 1
    
    return jsonify({
        "status": "success",
        "weekly_moods": moods or ["calm", "calm", "calm", "calm", "calm", "calm", "calm"],
        "emotion_distribution": mood_counts or {"calm": 7},
        "trend": "stable",
        "habit_recommendations": [
            "Practice daily meditation",
            "Take regular breaks",
            "Stay active",
            "Get enough sleep"
        ]
    })


def handle_recommend_activities(ctx):
    """Recommend activities based on mood"""
    mood = ctx.get('mood', 'calm')
    
    recommendations = []
    for activity, details in ACTIVITIES.items():
        recommendations.append({
            "activity": activity,
            "duration": details["duration"],
            "type": details["type"],
            "emoji": details["emoji"],
            "effectiveness": 0.85
        })
    
    return jsonify({
        "status": "success",
        "recommendations": recommendations[:5]
    })


def handle_generate_breathing_exercise(ctx):
    """Generate breathing exercise"""
    intensity = ctx.get('intensity', 5)
    
    if intensity > 7:
        exercise = "Box Breathing: Inhale 4 counts, hold 4, exhale 4, hold 4. Repeat 5 times."
    else:
        exercise = "Simple Breathing: Inhale slowly through nose, exhale through mouth. Repeat 3 times."
    
    return jsonify({
        "status": "success",
        "exercise": exercise,
        "duration": 5,
        "type": "breathing"
    })


def handle_find_common_emotions(ctx):
    """Find common emotions in history"""
    moods = [e["mood"] for e in MOOD_LOG]
    mood_counts = {}
    for mood in moods:
        mood_counts[mood] = mood_counts.get(mood, 0) + 1
    
    return jsonify({
        "status": "success",
        "common_emotions": sorted(mood_counts.items(), key=lambda x: x[1], reverse=True)
    })


def handle_calculate_trends(ctx):
    """Calculate emotional trends"""
    moods = [e["mood"] for e in MOOD_LOG[-7:]]
    
    return jsonify({
        "status": "success",
        "trend": "improving" if len(moods) >= 2 else "stable",
        "volatility": "low",
        "stability_score": 0.8
    })


@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "server": "MindMate Mock API"})


if __name__ == '__main__':
    print("🚀 MindMate Mock API Server Starting...")
    print("📍 Server running on http://localhost:5000")
    print("📊 Frontend will connect automatically")
    app.run(host='localhost', port=5000, debug=False)
