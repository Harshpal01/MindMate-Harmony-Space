"""
MindMate Harmony Space - OSP Graph Definition
Defines all node types and graph structure for emotional wellness tracking
"""

# ============================================================================
# NODE DEFINITIONS
# ============================================================================

node emotion {
    has name: str;
    has emoji: str;
    has intensity: float = 0;  # 0-10 scale
    has timestamp: str;
    has frequency: int = 0;    # How often this emotion occurs
}

node trigger {
    has name: str;
    has description: str;
    has category: str;  # work, social, health, finance, personal, other
    has frequency: int = 0;
}

node activity {
    has name: str;
    has description: str;
    has type: str;  # exercise, creative, social, mindful, rest, hobby
    has duration_minutes: int;
    has effectiveness_score: float = 0;
}

node journal_entry {
    has text: str;
    has timestamp: str;
    has mood_before: str;
    has mood_after: str;
    has keywords: list[str];
}

node suggestion {
    has title: str;
    has content: str;
    has type: str;  # breathing_exercise, affirmation, coping_tip, activity_recommendation
    has duration_seconds: int = 0;
}

node user {
    has username: str;
    has email: str;
    has created_at: str;
    has total_entries: int = 0;
}

# ============================================================================
# EDGE RELATIONSHIPS
# ============================================================================

edge emotion_trigger {
    has strength: float = 1.0;  # Correlation strength
    has frequency: int = 1;
}

edge emotion_activity {
    has effectiveness: float;   # How well activity helps with emotion
    has times_used: int = 0;
}

edge emotion_suggestion {
    has relevance: float;       # How relevant suggestion is to emotion
    has uses_count: int = 0;
}

edge entry_emotion {
    has extracted_score: float;
    has confidence: float;
}

edge emotion_emotion {
    has transition_strength: float;  # How often emotion A leads to emotion B
}

edge activity_result {
    has result_emotion: str;
    has effectiveness: float;
}

# ============================================================================
# MAIN GRAPH WALKER INITIALIZATION
# ============================================================================

graph mindmate_graph {
    has users: list[user];
    has emotions: list[emotion];
    has triggers: list[trigger];
    has activities: list[activity];
    has suggestions: list[suggestion];
    has entries: list[journal_entry];
}
