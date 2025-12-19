"""
MindMate Harmony Space - OSP Graph Structure
Defines nodes, edges, and graph walker for emotional wellness tracking
"""

# NODE DEFINITIONS
node user {
    has user_id: str;
    has name: str;
    has created_at: str;
}

node emotion {
    has name: str;
    has emoji: str;
    has intensity: int;
    has frequency: int = 0;
}

node trigger {
    has name: str;
    has category: str;
    has description: str;
    has occurrence_count: int = 0;
}

node activity {
    has name: str;
    has type: str;
    has duration_minutes: int;
    has description: str;
    has effectiveness_score: float = 0.0;
}

node suggestion {
    has text: str;
    has category: str;
    has relevance_score: float = 0.0;
}

node journal_entry {
    has user_id: str;
    has entry_text: str;
    has timestamp: str;
    has detected_emotions: list[str] = [];
    has sentiment_score: float = 0.0;
}

node mood_log {
    has user_id: str;
    has emotion_name: str;
    has intensity: float;
    has timestamp: str;
    has journal_text: str = "";
}

# EDGE DEFINITIONS
edge feels {
    has timestamp: str;
    has intensity: float;
}

edge caused_by {
    has strength: float;
    has timestamp: str;
}

edge helps_with {
    has effectiveness: float;
    has usage_count: int = 0;
}

edge suggests {
    has relevance: float;
    has confidence: float;
}

edge correlates_with {
    has correlation_strength: float;
    has co_occurrence_count: int = 0;
}

edge influences {
    has impact_score: float;
    has direction: str;
}

# MAIN GRAPH WALKER
walker mindmate_graph {
    has users: list[dict[str, str]] = [];
    has emotions: list[dict[str, str]] = [];
    has triggers: list[dict[str, str]] = [];
    has activities: list[dict[str, str]] = [];
    has suggestions: list[dict[str, str]] = [];
    has entries: list[dict[str, str]] = [];
}
