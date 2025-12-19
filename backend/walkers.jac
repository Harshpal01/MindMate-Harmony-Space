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
