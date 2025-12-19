"""
MindMate Harmony Space - Core Walkers
Defines walker definitions for mood logging, analysis, summaries, and pattern detection
"""

walker log_mood {
    has user_id: str;
    has mood_name: str;
    has intensity: float;
    has journal_text: str = "";
}

walker analyze_journal {
    has journal_text: str;
    has user_id: str;
}

walker get_daily_summary {
    has user_id: str;
}

walker get_weekly_summary {
    has user_id: str;
    has num_days: int = 7;
}

walker recommend_activities {
    has emotion_name: str;
    has intensity: float;
}

walker find_repeating_triggers {
    has user_id: str;
    has lookback_days: int = 30;
}

walker calculate_emotional_trends {
    has user_id: str;
    has lookback_days: int = 14;
}

walker find_common_emotions {
    has user_id: str;
    has lookback_days: int = 7;
}

walker get_daily_affirmation {
    has emotion_name: str;
    has user_name: str = "";
}

# ============================================================================
# AI AGENT WALKERS (from agents.jac)
# ============================================================================
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
