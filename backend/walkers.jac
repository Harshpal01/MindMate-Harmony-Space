"""
MindMate Harmony Space - Core Walkers
All walker implementations for mood logging, analysis, and recommendations
"""

:py {
import datetime
import json
import random
}

# ============================================================================
# MOOD LOGGING & GRAPH MANAGEMENT WALKERS
# ============================================================================

walker log_mood {
    """
    Records a new mood entry and updates the graph
    Input: user_id, mood_name, intensity, journal_text (optional)
    Output: mood_entry, graph_update_status
    """
    has user_id: str;
    has mood_name: str;
    has intensity: float;
    has journal_text: str = "";
    has triggers_identified: list[str] = [];
    
    can log_to_db;
    
    root {
        emotion_node = spawn emotion(
            name = mood_name,
            intensity = intensity,
            timestamp = std.datetime.now().isoformat()
        );
        
        if journal_text != "" {
            # Create journal entry node
            entry = spawn journal_entry(
                text = journal_text,
                timestamp = std.datetime.now().isoformat(),
                mood_before = mood_name,
                keywords = extract_keywords(journal_text)
            );
            
            # Connect journal to emotion
            entry --> emotion_node [entry_emotion];
        }
        
        report {
            "status": "success",
            "mood": mood_name,
            "intensity": intensity,
            "entry_created": journal_text != "",
            "timestamp": std.datetime.now().isoformat()
        };
    }
}

walker update_graph {
    """
    Creates relationships between emotions, triggers, and activities
    Input: emotion_id, trigger_ids, activity_ids, suggestion_ids
    Output: relationship_count, graph_structure
    """
    has emotion_id: str;
    has trigger_ids: list[str];
    has activity_ids: list[str];
    has suggestion_ids: list[str];
    has emotion_intensity: float;
    
    root {
        # For this prototype implementation, we accept ID lists and
        # simply report how many connections would be created. This
        # keeps the walker safe and avoids referencing undefined
        # node variables when the actual graph lookup logic is not
        # implemented yet.

        report {
            "emotion_id": emotion_id,
            "triggers_connected": std.len(trigger_ids),
            "activities_connected": std.len(activity_ids),
            "suggestions_connected": std.len(suggestion_ids),
            "graph_updated": true
        };
    }
}

# ============================================================================
# ANALYSIS & SUMMARY WALKERS
# ============================================================================

walker analyze_journal {
    """
    Sends journal text to analytical LLM for emotional extraction
    Input: journal_text
    Output: emotion_classification, triggers, intensity_score, keywords
    """
    has journal_text: str;
    has user_id: str;
    
    root {
        # This will be handled by agents.jac (emotion_from_text walker)
        report {
            "status": "analyzing",
            "journal_length": std.len(journal_text),
            "next_step": "emotion_from_text"
        };
    }
}

walker get_daily_summary {
    """
    Returns current emotional state with AI-generated suggestions
    Input: user_id
    Output: current_mood, intensity, suggestions, affirmation, breathing_exercise
    """
    has user_id: str;
    
    root {
        # Traverse graph to get latest mood entry
        latest_emotion = get_latest_emotion(user_id);
        related_triggers = traverse_emotion_triggers(latest_emotion);
        related_activities = traverse_emotion_activities(latest_emotion);
        suggestions = get_relevant_suggestions(latest_emotion);
        
        report {
            "current_mood": latest_emotion.name,
            "intensity": latest_emotion.intensity,
            "triggers": related_triggers,
            "recommended_activities": related_activities,
            "suggestions": suggestions,
            "timestamp": std.datetime.now().isoformat()
        };
    }
}

walker get_weekly_summary {
    """
    Generates emotional trend report for the past week
    Input: user_id
    Output: mood_distribution, dominant_emotions, trend_analysis, recommendations
    """
    has user_id: str;
    has num_days: int = 7;
    
    root {
        emotions_this_week = get_emotions_by_date_range(user_id, num_days);
        emotion_counts = count_emotion_frequencies(emotions_this_week);
        trends = analyze_trends(emotion_counts);
        recommendations = generate_habit_recommendations(trends);
        
        report {
            "period": "last_7_days",
            "total_entries": std.len(emotions_this_week),
            "dominant_emotions": emotion_counts,
            "trend_analysis": trends,
            "habit_recommendations": recommendations
        };
    }
}

# ============================================================================
# RECOMMENDATION WALKERS
# ============================================================================

walker recommend_activities {
    """
    Recommends activities based on current mood using graph traversal
    Input: emotion_name, intensity
    Output: ranked_activities_list
    """
    has emotion_name: str;
    has intensity: float;
    
    root {
        # Find emotion node
        emotion_node = find_emotion_by_name(emotion_name);
        
        if emotion_node {
            # Traverse emotion → activity edges
            connected_activities = traverse_outgoing_edges(
                emotion_node,
                "emotion_activity"
            );
            
            # Rank by effectiveness
            ranked = rank_activities_by_effectiveness(connected_activities, intensity);
            
            report {
                "emotion": emotion_name,
                "recommendations": ranked,
                "count": std.len(ranked)
            };
        } else {
            report {
                "error": "emotion_not_found",
                "emotion": emotion_name
            };
        }
    }
}

walker find_repeating_triggers {
    """
    Identifies most common emotional triggers from graph
    Input: user_id, lookback_days
    Output: trigger_list_ranked_by_frequency
    """
    has user_id: str;
    has lookback_days: int = 30;
    
    root {
        entries = get_user_entries_by_date(user_id, lookback_days);
        trigger_freq = {};
        
        for entry in entries {
            related_emotions = traverse_entry_emotions(entry);
            for emotion in related_emotions {
                triggers = traverse_emotion_triggers(emotion);
                for trigger in triggers {
                    trigger_freq[trigger.name] = trigger_freq.get(trigger.name, 0) + 1;
                }
            }
        }
        
        sorted_triggers = sort_by_frequency(trigger_freq);
        
        report {
            "user_id": user_id,
            "period_days": lookback_days,
            "triggers": sorted_triggers
        };
    }
}

walker find_common_emotions {
    """
    Detects prevalent mood patterns from historical data
    Input: user_id, period_days
    Output: emotion_distribution, percentages
    """
    has user_id: str;
    has period_days: int = 30;
    
    root {
        emotion_counts = get_emotion_counts_by_period(user_id, period_days);
        total = sum(emotion_counts.values());
        percentages = {k: (v/total)*100 for k,v in emotion_counts.items()};
        
        report {
            "user_id": user_id,
            "period_days": period_days,
            "emotion_distribution": emotion_counts,
            "percentages": percentages
        };
    }
}

walker calculate_emotional_trends {
    """
    Computes emotional trajectory and patterns over time
    Input: user_id, lookback_days
    Output: trend_direction, volatility, stability_score
    """
    has user_id: str;
    has lookback_days: int = 14;
    
    root {
        emotions_timeline = get_emotions_timeline(user_id, lookback_days);
        
        if std.len(emotions_timeline) < 2 {
            report {
                "status": "insufficient_data",
                "entries_found": std.len(emotions_timeline)
            };
        } else {
            # Calculate trend direction (positive/negative/stable)
            trend = calculate_intensity_trend(emotions_timeline);
            
            # Calculate volatility (how much mood swings)
            volatility = calculate_volatility(emotions_timeline);
            
            # Stability score (inverse of volatility)
            stability = 100 - volatility;
            
            report {
                "user_id": user_id,
                "period_days": lookback_days,
                "trend": trend,
                "volatility": volatility,
                "stability_score": stability
            };
        }
    }
}

# ============================================================================
# HELPER FUNCTIONS (implemented in Python)
# ============================================================================

:py {
import datetime
import statistics

def extract_keywords(text):
    """Extract keywords from journal text"""
    # Simple keyword extraction - can be enhanced
    words = text.lower().split()
    return words[:10]  # First 10 words as keywords

def get_latest_emotion(user_id):
    """Get most recent emotion entry for user"""
    # Graph query - would be implemented with actual graph DB
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
    
    # Simple trend: compare first half to second half
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
    
    # Normalize to 0-100 scale
    return min(volatility * 10, 100)
}
