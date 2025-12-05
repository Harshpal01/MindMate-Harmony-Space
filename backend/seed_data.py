"""
MindMate Harmony Space - Seed Data
Initial emotions, triggers, activities, and suggestions for demo
"""

import json
from datetime import datetime, timedelta

# Preload emotions with emojis
SEED_EMOTIONS = [
    {"name": "happy", "emoji": "😊", "intensity": 7},
    {"name": "sad", "emoji": "😢", "intensity": 3},
    {"name": "anxious", "emoji": "😰", "intensity": 4},
    {"name": "calm", "emoji": "😌", "intensity": 8},
    {"name": "stressed", "emoji": "😫", "intensity": 2},
    {"name": "content", "emoji": "😊", "intensity": 8},
    {"name": "overwhelmed", "emoji": "😵", "intensity": 1},
    {"name": "peaceful", "emoji": "🧘", "intensity": 9},
    {"name": "excited", "emoji": "🤩", "intensity": 9},
    {"name": "lonely", "emoji": "😔", "intensity": 3},
]

# Preload common triggers
SEED_TRIGGERS = [
    {"name": "work stress", "category": "work", "description": "Pressure and deadlines at work"},
    {"name": "social conflict", "category": "social", "description": "Arguments or disagreements with others"},
    {"name": "health concerns", "category": "health", "description": "Physical or mental health worries"},
    {"name": "financial pressure", "category": "finance", "description": "Money-related stress"},
    {"name": "personal loss", "category": "personal", "description": "Loss or grief"},
    {"name": "sleep deprivation", "category": "health", "description": "Lack of quality sleep"},
    {"name": "poor nutrition", "category": "health", "description": "Unhealthy eating habits"},
    {"name": "social isolation", "category": "social", "description": "Feeling disconnected from others"},
    {"name": "overwhelming schedule", "category": "work", "description": "Too many commitments"},
    {"name": "perfectionism", "category": "personal", "description": "High expectations of oneself"},
]

# Preload coping activities
SEED_ACTIVITIES = [
    {"name": "exercise", "type": "exercise", "duration_minutes": 30, "description": "Physical activity like walking, running, or gym"},
    {"name": "journaling", "type": "creative", "duration_minutes": 15, "description": "Writing about thoughts and feelings"},
    {"name": "meditation", "type": "mindful", "duration_minutes": 10, "description": "Guided or silent meditation practice"},
    {"name": "deep breathing", "type": "mindful", "duration_minutes": 5, "description": "Focused breathing exercises"},
    {"name": "social connection", "type": "social", "duration_minutes": 30, "description": "Call or meet with a friend"},
    {"name": "nature walk", "type": "exercise", "duration_minutes": 30, "description": "Walking in nature or park"},
    {"name": "reading", "type": "creative", "duration_minutes": 30, "description": "Read a book or inspiring content"},
    {"name": "creative hobby", "type": "creative", "duration_minutes": 45, "description": "Art, music, crafting, or other creative pursuits"},
    {"name": "rest and sleep", "type": "rest", "duration_minutes": 60, "description": "Nap or early bedtime"},
    {"name": "warm shower", "type": "rest", "duration_minutes": 15, "description": "Relaxing warm shower or bath"},
]

# Preload suggestions
SEED_SUGGESTIONS = [
    {
        "title": "4-7-8 Breathing Exercise",
        "type": "breathing_exercise",
        "content": "Inhale for 4 counts, hold for 7, exhale for 8. Repeat 4 times.",
        "duration_seconds": 120
    },
    {
        "title": "Grounding Technique - 5 Senses",
        "type": "coping_tip",
        "content": "Name 5 things you see, 4 you touch, 3 you hear, 2 you smell, 1 you taste.",
        "duration_seconds": 300
    },
    {
        "title": "Positive Affirmation",
        "type": "affirmation",
        "content": "I am capable of handling whatever comes my way. I have overcome challenges before.",
        "duration_seconds": 0
    },
    {
        "title": "Box Breathing",
        "type": "breathing_exercise",
        "content": "Inhale for 4, hold for 4, exhale for 4, hold for 4. Repeat for 2 minutes.",
        "duration_seconds": 120
    },
    {
        "title": "Progressive Muscle Relaxation",
        "type": "coping_tip",
        "content": "Tense and release each muscle group from toes to head.",
        "duration_seconds": 600
    },
    {
        "title": "Resilience Affirmation",
        "type": "affirmation",
        "content": "This feeling is temporary. I am strong and I will get through this.",
        "duration_seconds": 0
    },
    {
        "title": "Guided Body Scan",
        "type": "coping_tip",
        "content": "Starting at your head, mentally scan down your body, noticing and relaxing tension.",
        "duration_seconds": 900
    },
    {
        "title": "Loving-Kindness Meditation",
        "type": "mindful",
        "content": "Send compassion to yourself and others through gentle meditation.",
        "duration_seconds": 600
    },
]

# Sample journal entries for testing
SEED_JOURNAL_ENTRIES = [
    {
        "text": "Today was really stressful. Had a difficult meeting at work and couldn't stop thinking about it. Felt anxious all day. Tried going for a walk in the evening which helped a bit.",
        "mood_before": "anxious",
        "mood_after": "calm",
        "timestamp": (datetime.now() - timedelta(days=2)).isoformat()
    },
    {
        "text": "Woke up feeling sad today. Not sure why exactly, just felt down. Spent time journaling and it helped me understand that I'm missing my family. Decided to schedule a call with them.",
        "mood_before": "sad",
        "mood_after": "content",
        "timestamp": (datetime.now() - timedelta(days=3)).isoformat()
    },
    {
        "text": "Amazing day! Finished a big project at work and got great feedback. Feeling so accomplished and happy. Celebrated with friends. This is what I need more of in my life!",
        "mood_before": "excited",
        "mood_after": "happy",
        "timestamp": (datetime.now() - timedelta(days=5)).isoformat()
    },
    {
        "text": "Overwhelmed by everything on my plate. Too many deadlines, too many responsibilities. Tried meditation but couldn't focus. Maybe need to say no to some things.",
        "mood_before": "overwhelmed",
        "mood_after": "calm",
        "timestamp": (datetime.now() - timedelta(days=4)).isoformat()
    },
    {
        "text": "Peaceful morning. Did yoga and meditation. Had healthy breakfast. Feeling grounded and ready for the day. This routine is really making a difference.",
        "mood_before": "peaceful",
        "mood_after": "calm",
        "timestamp": (datetime.now() - timedelta(days=1)).isoformat()
    }
]

def export_seed_data():
    """Export seed data as JSON files"""
    
    seed_data = {
        "emotions": SEED_EMOTIONS,
        "triggers": SEED_TRIGGERS,
        "activities": SEED_ACTIVITIES,
        "suggestions": SEED_SUGGESTIONS,
        "sample_entries": SEED_JOURNAL_ENTRIES
    }
    
    return seed_data

def get_emotion_by_name(name):
    """Get emotion from seed data"""
    for emotion in SEED_EMOTIONS:
        if emotion["name"].lower() == name.lower():
            return emotion
    return None

def get_suggestions_for_emotion(emotion_name):
    """Get relevant suggestions for an emotion"""
    # This is a simple mapping - could be enhanced with ML
    relevant_suggestions = []
    
    if emotion_name.lower() in ["anxious", "stressed", "overwhelmed"]:
        relevant_suggestions = [s for s in SEED_SUGGESTIONS if s["type"] in ["breathing_exercise", "coping_tip"]]
    elif emotion_name.lower() in ["sad", "lonely"]:
        relevant_suggestions = [s for s in SEED_SUGGESTIONS if s["type"] in ["affirmation", "coping_tip"]]
    else:
        relevant_suggestions = SEED_SUGGESTIONS[:3]
    
    return relevant_suggestions

if __name__ == "__main__":
    # Export seed data to JSON files
    import os
    
    seed_data = export_seed_data()
    
    # Create samples directory if it doesn't exist
    os.makedirs("examples", exist_ok=True)
    
    with open("examples/seed_data.json", "w") as f:
        json.dump(seed_data, f, indent=2)
    
    print("✓ Seed data exported to examples/seed_data.json")
