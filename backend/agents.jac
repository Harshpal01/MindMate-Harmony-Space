"""
MindMate Harmony Space - AI Agent Walkers
Defines walker definitions for emotion analysis, support generation, and reflection
"""

walker emotion_from_text {
    has journal_text: str;
    has user_id: str = "";
}

walker generate_support_message {
    has emotion_name: str;
    has intensity_score: float;
    has detected_triggers: list[str] = [];
    has user_context: str = "";
}

walker generate_breathing_exercise {
    has emotion_name: str;
    has intensity_score: float;
    has duration_preference: int = 300;
}

walker generate_affirmation {
    has emotion_name: str;
    has intensity_score: float;
    has user_name: str = "Friend";
    has detected_triggers: list[str] = [];
}

walker generate_weekly_reflection {
    has user_id: str;
    has weekly_emotions: dict[str, int] = {};
    has detected_patterns: list[str] = [];
    has week_number: int = 1;
}

walker suggest_habit_improvements {
    has detected_triggers: list[str] = [];
    has dominant_emotions: list[str] = [];
    has current_habits: list[str] = [];
    has intensity_average: float = 0.0;
}
