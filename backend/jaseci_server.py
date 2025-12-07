"""
MindMate Harmony Space - Jaseci Server with Jac Support
Properly initialized Jaseci server that loads and executes Jac programs
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import os
import sys
from pathlib import Path
import sqlite3
import requests

# Try to import Jaseci components
try:
    from jaseci.jsorc.jsorc import JsorcRunner
    from jaseci.core.machine import JaseciBridge
    JASECI_AVAILABLE = True
except ImportError:
    print("⚠️  Jaseci not fully configured. Using enhanced mock mode with Jac simulation.")
    JASECI_AVAILABLE = False

import datetime

app = Flask(__name__)
# For this demo, allow any origin so both Render frontend and local dev can call the API
CORS(app, resources={r"/*": {"origins": "*"}})

# Initialize Jaseci if available
jac_engine = None
if JASECI_AVAILABLE:
    try:
        jac_engine = JaseciBridge()
        print("✅ Jaseci Engine initialized")
    except Exception as e:
        print(f"⚠️  Jaseci Engine initialization failed: {e}")

# Simulated data storage (for mock mode and persistence)
MOOD_LOG = []
GRAPH_DATA = {}

# ---------------------------------------------------------------------------
# Lightweight SQLite persistence for mood history
# ---------------------------------------------------------------------------

BASE_DIR = Path(__file__).resolve().parent
DB_FILE = os.environ.get("MOOD_DB_FILE", "mindmate.db")
DB_PATH = BASE_DIR / DB_FILE


def get_db_connection():
    """Get a SQLite connection to the mood history database."""
    return sqlite3.connect(DB_PATH)


def init_db():
    """Initialize the SQLite database with a simple mood_entries table."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS mood_entries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT,
                timestamp TEXT,
                mood TEXT,
                intensity INTEGER,
                journal TEXT
            )
            """
        )
        conn.commit()
    except Exception as e:
        print(f"⚠️ Failed to initialize SQLite mood history DB: {e}")
    finally:
        try:
            conn.close()
        except Exception:
            pass


def save_mood_entry(mood_entry: dict):
    """Persist a single mood entry to SQLite. Best-effort, non-fatal on error."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """
            INSERT INTO mood_entries (user_id, timestamp, mood, intensity, journal)
            VALUES (?, ?, ?, ?, ?)
            """,
            (
                mood_entry.get("user_id", "user1"),
                mood_entry.get("timestamp"),
                mood_entry.get("mood"),
                int(mood_entry.get("intensity", 5)),
                mood_entry.get("journal", ""),
            ),
        )
        conn.commit()
    except Exception as e:
        print(f"⚠️ Failed to save mood entry to DB: {e}")
    finally:
        try:
            conn.close()
        except Exception:
            pass


def get_today_entries_from_db(user_id: str | None = None):
    """Return all mood entries for today from SQLite (optionally filtered by user)."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        today = datetime.date.today().isoformat()
        if user_id:
            cur.execute(
                """
                SELECT timestamp, mood, intensity, journal, user_id
                FROM mood_entries
                WHERE date(timestamp) = date(?) AND user_id = ?
                ORDER BY timestamp
                """,
                (today, user_id),
            )
        else:
            cur.execute(
                """
                SELECT timestamp, mood, intensity, journal, user_id
                FROM mood_entries
                WHERE date(timestamp) = date(?)
                ORDER BY timestamp
                """,
                (today,),
            )
        rows = cur.fetchall()
        conn.close()
        return rows
    except Exception as e:
        print(f"⚠️ Failed to load today's entries from DB: {e}")
        return []


def get_recent_entries_from_db(days: int = 7, user_id: str | None = None):
    """Return mood entries from the last `days` days from SQLite."""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        today = datetime.date.today()
        start_date = (today - datetime.timedelta(days=days)).isoformat()
        if user_id:
            cur.execute(
                """
                SELECT timestamp, mood, intensity, journal, user_id
                FROM mood_entries
                WHERE date(timestamp) >= date(?) AND user_id = ?
                ORDER BY timestamp
                """,
                (start_date, user_id),
            )
        else:
            cur.execute(
                """
                SELECT timestamp, mood, intensity, journal, user_id
                FROM mood_entries
                WHERE date(timestamp) >= date(?)
                ORDER BY timestamp
                """,
                (start_date,),
            )
        rows = cur.fetchall()
        conn.close()
        return rows
    except Exception as e:
        print(f"⚠️ Failed to load recent entries from DB: {e}")
        return []

# Sample data
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


def execute_jac_walker(walker_name, ctx):
    """
    Execute a Jac walker through Jaseci engine if available
    Falls back to mock implementation if Jaseci not ready
    """
    if jac_engine:
        try:
            # Try to execute through Jaseci
            result = jac_engine.execute(walker_name, ctx)
            return result
        except Exception as e:
            print(f"⚠️  Jaseci execution failed for {walker_name}: {e}")
    
    # Fallback to mock implementation
    return execute_mock_walker(walker_name, ctx)


def execute_mock_walker(walker_name, ctx):
    """Mock implementation of Jac walkers for development"""
    
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
    # Support both camelCase and snake_case for trends walker
    elif walker_name == 'calculateEmotionalTrends' or walker_name == 'calculate_emotional_trends':
        return handle_calculate_trends(ctx)
    else:
        return {"error": f"Unknown walker: {walker_name}"}


@app.route('/api/walker', methods=['POST'])
def walker_endpoint():
    """
    Main endpoint for executing Jac walkers
    Accepts POST requests with walker name and context
    """
    try:
        data = request.json
        walker_name = data.get('walker')
        ctx = data.get('ctx', {})
        
        if not walker_name:
            return jsonify({"error": "No walker specified"}), 400
        
        # Execute walker (through Jaseci if available, else mock)
        result = execute_jac_walker(walker_name, ctx)
        
        return jsonify(result)
            
    except Exception as e:
        print(f"Error in walker endpoint: {e}")
        return jsonify({"error": str(e)}), 500


# ============================================================================
# MOCK WALKER IMPLEMENTATIONS (for development/testing)
# These simulate the behavior of actual Jac walkers
# ============================================================================

def handle_log_mood(ctx):
    """Jac Walker: log_mood - Records emotional state to graph"""
    mood_entry = {
        "timestamp": datetime.datetime.now().isoformat(),
        "mood": ctx.get('mood_name', 'unknown'),
        "intensity": ctx.get('intensity', 5),
        "journal": ctx.get('journal_text', ''),
        "user_id": ctx.get('user_id', 'user1'),
    }
    MOOD_LOG.append(mood_entry)
    # Best-effort persistence to SQLite for history/trends
    save_mood_entry(mood_entry)
    
    return {
        "status": "success",
        "walker": "log_mood",
        "message": f"Mood '{mood_entry['mood']}' logged successfully to graph",
        "data": mood_entry
    }


def handle_emotion_from_text(ctx):
    """Jac Walker: emotion_from_text - Analytical LLM analyzes journal text for emotions"""
    journal_text = ctx.get('journal_text', '')
    
    # Simulates LLM emotion detection
    detected_emotions = []
    keywords = {
        "happy": ["happy", "great", "wonderful", "excited", "love", "joy", "amazing"],
        "sad": ["sad", "depressed", "down", "unhappy", "terrible", "awful", "cry"],
        "anxious": ["anxious", "worried", "nervous", "stressed", "panic", "fear", "dread"],
        "calm": ["calm", "peaceful", "relaxed", "serene", "zen", "chill", "tranquil"],
        "frustrated": ["frustrated", "angry", "mad", "irritated", "annoyed", "upset"],
    }
    
    text_lower = journal_text.lower()
    for emotion, keywords_list in keywords.items():
        if any(kw in text_lower for kw in keywords_list):
            detected_emotions.append(emotion)
    
    if not detected_emotions:
        detected_emotions = ["calm"]
    
    return {
        "status": "success",
        "walker": "emotion_from_text",
        "emotions": detected_emotions[:2],
        "intensity": min(len(detected_emotions) * 3, 10),
        "confidence": 0.85,
        "keywords": detected_emotions
    }


def call_gemini_support_message(api_key: str, mood: str, journal: str, intensity: int) -> str:
    """Call Google Gemini to generate a supportive message.

    Uses the public Generative Language REST API with gemini-1.5-flash.
    """
    try:
        endpoint = (
            "https://generativelanguage.googleapis.com/v1beta/"
            "models/gemini-1.5-flash:generateContent"
        )

        prompt = (
            "You are an empathetic mental health companion named MindMate. "
            "Given the user's current emotion, intensity, and a short journal entry, "
            "write a concise, supportive message (2-4 sentences). "
            "Be warm, non-clinical, and avoid giving medical advice.\n\n"
            f"Current emotion: {mood or 'unknown'}\n"
            f"Intensity (1-10): {intensity}\n"
            f"Journal entry: {journal or 'N/A'}\n\n"
            "Support message:"
        )

        payload = {
            "contents": [
                {
                    "parts": [
                        {"text": prompt}
                    ]
                }
            ]
        }

        params = {"key": api_key}
        headers = {"Content-Type": "application/json"}

        resp = requests.post(endpoint, params=params, headers=headers, json=payload, timeout=15)
        resp.raise_for_status()
        data = resp.json()

        # Extract the first candidate text if present
        candidates = data.get("candidates") or []
        if candidates:
            parts = candidates[0].get("content", {}).get("parts") or []
            texts = [p.get("text", "") for p in parts if isinstance(p, dict)]
            joined = "\n".join(t for t in texts if t)
            if joined.strip():
                return joined.strip()

    except Exception as e:
        print(f"⚠️ Gemini support call failed: {e}")

    # If anything goes wrong, return empty string so caller can fall back
    return ""


def handle_generate_support_message(ctx):
    """Jac Walker: generate_support_message - Generative LLM creates supportive response"""
    # Frontend sends emotion_name/intensity_score/user_context;
    # fall back to older keys for compatibility.
    mood = ctx.get('emotion_name') or ctx.get('mood', 'unknown')
    journal = ctx.get('journal_text') or ctx.get('user_context', '')
    intensity = ctx.get('intensity_score') if 'intensity_score' in ctx else ctx.get('intensity', 5)

    # Try Gemini first if GOOGLE_API_KEY is available
    gemini_key = os.environ.get("GOOGLE_API_KEY")
    if gemini_key:
        gemini_msg = call_gemini_support_message(gemini_key, mood, journal, intensity)
        if gemini_msg:
            return {
                "status": "success",
                "walker": "generate_support_message",
                "message": gemini_msg,
                "type": "support",
                "provider": "gemini"
            }

    # Fallback: Comprehensive, empathetic messages based on mood and intensity
    messages = {
        "happy": {
            "low": "That's wonderful! These positive moments are precious. Enjoy this feeling and let it energize you.",
            "high": "You're radiating positivity! This is amazing energy. Channel it into something meaningful and share the joy.",
            "default": "That's wonderful! Keep celebrating these positive moments. They fuel your wellbeing! 🌟"
        },
        "sad": {
            "low": "It's okay to feel a little down sometimes. Remember, this is temporary and you have support.",
            "high": "It sounds like you're going through something difficult right now. Please know that what you're feeling is valid and you're not alone. Consider reaching out to someone you trust.",
            "default": "It's okay to feel sad sometimes. Remember, this feeling is temporary. Reach out if you need support. 💙"
        },
        "anxious": {
            "low": "You're experiencing some worry, which is normal. Try grounding techniques to settle your mind.",
            "high": "Anxiety can feel overwhelming, but you can manage it. Try deep breathing: 4 counts in, hold 4, out 4. You're stronger than you think.",
            "default": "Your feelings are valid. Try taking some deep breaths or talking to someone you trust. You've got this! 🤗"
        },
        "calm": {
            "low": "You're feeling peaceful. This is a great state. Enjoy and preserve this tranquility.",
            "high": "What a beautiful peaceful state you're in. Cherish this moment and use it to recharge.",
            "default": "What a peaceful moment! Cherish this tranquility and let it ground you. 🧘"
        },
        "stressed": {
            "low": "You're under some pressure. Remember to take breaks and be kind to yourself.",
            "high": "Stress is weighing on you right now. It's important to take time to decompress. Consider talking to someone about what's stressing you.",
            "default": "You're carrying stress right now. Remember, you're capable and this is manageable. Take a moment for yourself. 💪"
        },
        "excited": {
            "low": "There's a nice energy in you today. Let yourself enjoy this uplifted state.",
            "high": "Your energy is amazing! You're riding a wave of excitement. Use this momentum for something positive.",
            "default": "Your energy is contagious! Channel this excitement into positive actions. 🚀"
        },
        "overwhelmed": {
            "low": "You're feeling a bit stretched. It's okay to pause and prioritize what matters most.",
            "high": "It sounds like everything feels like too much right now. That's okay. Start with one small thing. You don't have to handle everything at once.",
            "default": "Take a breath. When everything feels like too much, remember you can take it one step at a time. 💙"
        },
        "lonely": {
            "low": "You're missing connection. Consider reaching out to someone you care about.",
            "high": "Loneliness can feel heavy. Please know that connection is within reach. Reach out to a friend, family, or counselor.",
            "default": "You're feeling isolated right now, and that's understandable. Remember, you deserve connection and support. 💙"
        },
        "content": {
            "low": "You're feeling satisfied with where you are. That's a solid foundation.",
            "high": "You're in a place of contentment. This is wonderful. Appreciate this stability.",
            "default": "You're feeling content and grounded. This is great. Hold onto this peace. 😊"
        },
        "frustrated": {
            "low": "You're mildly frustrated. Take a step back and give yourself a break.",
            "high": "Frustration is building up. Find a healthy way to release it—exercise, talk it out, or take a pause.",
            "default": "It's normal to feel frustrated. Take a step back, breathe, and remember this too shall pass. 💪"
        },
    }
    
    # Get the appropriate message based on mood and intensity
    mood_messages = messages.get(mood, messages["calm"])
    
    if intensity <= 3:
        message = mood_messages.get("low", mood_messages.get("default", "You're doing your best and that's enough. 💖"))
    elif intensity >= 8:
        message = mood_messages.get("high", mood_messages.get("default", "You're doing your best and that's enough. 💖"))
    else:
        message = mood_messages.get("default", "You're doing your best and that's enough. 💖")
    
    return {
        "status": "success",
        "walker": "generate_support_message",
        "message": message,
        "type": "support"
    }


def handle_get_daily_summary(ctx):
    """Jac Walker: get_daily_summary - Graph traversal for daily insights"""
    user_id = ctx.get('user_id', None)

    # Prefer DB entries; fall back to in-memory if needed
    today_rows = get_today_entries_from_db(user_id=user_id)
    if today_rows:
        # rows: (timestamp, mood, intensity, journal, user_id)
        last = today_rows[-1]
        current_mood = last[1] or "calm"
        entries_count = len(today_rows)
    else:
        today = datetime.date.today()
        today_entries = [e for e in MOOD_LOG if e["timestamp"].startswith(today.isoformat())]
        current_mood = today_entries[-1]["mood"] if today_entries else "calm"
        entries_count = len(today_entries)

    return {
        "status": "success",
        "walker": "get_daily_summary",
        "current_mood": current_mood,
        # For now, keep a simple fixed intensity; could be averaged from DB later
        "intensity": 5,
        "entries_count": entries_count,
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
    }


def handle_get_weekly_summary(ctx):
    """Jac Walker: get_weekly_summary - Graph analysis for weekly patterns"""
    user_id = ctx.get('user_id', None)

    # Prefer DB entries from the last 7 days for trend analysis
    rows = get_recent_entries_from_db(days=7, user_id=user_id)
    if rows:
        moods = [r[1] for r in rows]  # mood column
    else:
        moods = [e["mood"] for e in MOOD_LOG[-7:]]

    mood_counts = {}
    for mood in moods:
        mood_counts[mood] = mood_counts.get(mood, 0) + 1

    return {
        "status": "success",
        "walker": "get_weekly_summary",
        "weekly_moods": moods or ["calm", "calm", "calm", "calm", "calm", "calm", "calm"],
        "emotion_distribution": mood_counts or {"calm": 7},
        "trend": "stable",
        "habit_recommendations": [
            "Practice daily meditation",
            "Take regular breaks",
            "Stay active with exercise",
            "Get 7-8 hours of sleep"
        ]
    }


def handle_recommend_activities(ctx):
    """Jac Walker: recommend_activities - Graph traversal for mood-matched suggestions"""
    # Frontend uses emotion_name; support both.
    mood = ctx.get('emotion_name') or ctx.get('mood', 'calm')
    
    recommendations = []
    for activity, details in ACTIVITIES.items():
        recommendations.append({
            "activity": activity,
            "duration": details["duration"],
            "type": details["type"],
            "emoji": details["emoji"],
            "effectiveness": 0.85
        })
    
    return {
        "status": "success",
        "walker": "recommend_activities",
        "recommendations": recommendations[:5]
    }


def handle_generate_breathing_exercise(ctx):
    """Jac Walker: generate_breathing_exercise - Create personalized breathing technique"""
    # Frontend sends intensity_score and duration_preference; fall back to older keys.
    intensity = ctx.get('intensity_score') if 'intensity_score' in ctx else ctx.get('intensity', 5)
    
    if intensity > 7:
        exercise = "Box Breathing: Inhale 4 counts, hold 4, exhale 4, hold 4. Repeat 5 times."
    else:
        exercise = "Simple Breathing: Inhale slowly through nose, exhale through mouth. Repeat 3 times."
    
    return {
        "status": "success",
        "walker": "generate_breathing_exercise",
        "exercise": exercise,
        "duration": 5,
        "type": "breathing"
    }


def handle_find_common_emotions(ctx):
    """Jac Walker: find_common_emotions - Identify repeating patterns in graph"""
    user_id = ctx.get('user_id', None)
    rows = get_recent_entries_from_db(days=30, user_id=user_id)
    if rows:
        moods = [r[1] for r in rows]
    else:
        moods = [e["mood"] for e in MOOD_LOG]

    mood_counts = {}
    for mood in moods:
        mood_counts[mood] = mood_counts.get(mood, 0) + 1

    return {
        "status": "success",
        "walker": "find_common_emotions",
        "common_emotions": sorted(mood_counts.items(), key=lambda x: x[1], reverse=True)
    }


def handle_calculate_trends(ctx):
    """Jac Walker: calculateEmotionalTrends - Analyze emotional trends over time"""
    user_id = ctx.get('user_id', None)
    rows = get_recent_entries_from_db(days=7, user_id=user_id)
    if rows:
        moods = [r[1] for r in rows]
    else:
        moods = [e["mood"] for e in MOOD_LOG[-7:]]

    return {
        "status": "success",
        "walker": "calculateEmotionalTrends",
        "trend": "improving" if len(moods) >= 2 else "stable",
        "volatility": "low",
        "stability_score": 0.8
    }


@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    status = "🟢 Jaseci Engine Ready" if jac_engine else "🟡 Mock Mode"
    return jsonify({
        "status": "healthy",
        "server": "MindMate Harmony - Jaseci Backend",
        "jaseci_status": status,
        "timestamp": datetime.datetime.now().isoformat()
    })


@app.route('/api/graph', methods=['GET'])
def get_graph():
    """Retrieve current graph state"""
    return jsonify({
        "status": "success",
        "mood_log_size": len(MOOD_LOG),
        "latest_moods": MOOD_LOG[-5:] if MOOD_LOG else [],
        "graph_data": GRAPH_DATA
    })


if __name__ == '__main__':
    # Ensure SQLite mood history table exists before serving
    init_db()

    # Determine host/port for local dev vs. Render/other hosts
    port = int(os.environ.get('PORT', 5000))
    host = os.environ.get('HOST', '0.0.0.0')

    print("\n" + "="*60)
    print("🚀 MindMate Harmony Space - Jaseci Backend Server")
    print("="*60)
    print(f"📍 Server binding: http://{host}:{port}")
    print(f"✅ Jaseci Engine: {'Enabled' if JASECI_AVAILABLE else 'Mock Mode (Development)'}")
    print("📝 Jac Program: mindmate.jac")
    print("🔗 Frontend (local dev): http://localhost:3000")
    print("="*60 + "\n")

    # On Render and similar platforms, PORT is provided and host must be 0.0.0.0
    app.run(host=host, port=port, debug=False, use_reloader=False)
