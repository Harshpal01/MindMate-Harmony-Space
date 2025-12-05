# API Endpoints & Walker Reference

## MindMate Harmony Space - Complete Walker API Reference

All walkers are called via Jaseci's `Spawn()` mechanism through the REST API.

---

## 1. MOOD LOGGING & GRAPH MANAGEMENT

### Walker: `log_mood`

**Purpose:** Records a new mood entry and updates the graph with emotion node

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "log_mood",
  "ctx": {
    "user_id": "user_001",
    "mood_name": "anxious",
    "intensity": 7.5,
    "journal_text": "Had a tough day at work, feeling overwhelmed",
    "triggers_identified": ["work", "deadlines"]
  }
}
```

**Response:**

```json
{
  "status": "success",
  "mood": "anxious",
  "intensity": 7.5,
  "entry_created": true,
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**Error Response:**

```json
{
  "error": "invalid_mood",
  "message": "Mood 'xyz' not found in emotion catalog"
}
```

---

### Walker: `analyze_journal`

**Purpose:** Sends journal text to analytical LLM for emotional extraction

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "analyze_journal",
  "ctx": {
    "journal_text": "I'm feeling so overwhelmed with work and personal life...",
    "user_id": "user_001"
  }
}
```

**Response:**

```json
{
  "status": "analyzing",
  "journal_length": 156,
  "next_step": "emotion_from_text"
}
```

---

### Walker: `update_graph`

**Purpose:** Creates relationships between emotions, triggers, and activities

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "update_graph",
  "ctx": {
    "emotion_id": "emotion_anxious_001",
    "trigger_ids": ["trigger_work_001", "trigger_sleep_001"],
    "activity_ids": ["activity_exercise_001", "activity_meditation_001"],
    "suggestion_ids": [
      "suggestion_breathing_001",
      "suggestion_affirmation_001"
    ],
    "emotion_intensity": 7.5
  }
}
```

**Response:**

```json
{
  "triggers_connected": 2,
  "activities_connected": 2,
  "suggestions_connected": 2,
  "graph_updated": true
}
```

---

## 2. SUMMARIES & INSIGHTS

### Walker: `get_daily_summary`

**Purpose:** Returns current emotional state with AI-generated suggestions

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "get_daily_summary",
  "ctx": {
    "user_id": "user_001"
  }
}
```

**Response:**

```json
{
  "current_mood": "anxious",
  "intensity": 7.5,
  "triggers": ["work_stress", "poor_sleep"],
  "recommended_activities": [
    {
      "name": "meditation",
      "description": "10-minute guided meditation",
      "effectiveness": 0.85
    },
    {
      "name": "exercise",
      "description": "30-minute walk",
      "effectiveness": 0.78
    }
  ],
  "suggestions": [
    {
      "title": "4-7-8 Breathing Exercise",
      "type": "breathing_exercise",
      "content": "Inhale for 4, hold for 7, exhale for 8"
    }
  ],
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

---

### Walker: `get_weekly_summary`

**Purpose:** Generates emotional trend report for the past week

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "get_weekly_summary",
  "ctx": {
    "user_id": "user_001",
    "num_days": 7
  }
}
```

**Response:**

```json
{
  "period": "last_7_days",
  "total_entries": 6,
  "dominant_emotions": {
    "calm": 2,
    "anxious": 2,
    "stressed": 1,
    "happy": 1
  },
  "trend_analysis": "Your emotional state has been relatively stable...",
  "habit_recommendations": [
    "Maintain your evening meditation routine",
    "Try to get more consistent sleep",
    "Consider increasing physical activity"
  ]
}
```

---

## 3. RECOMMENDATIONS & ACTIVITIES

### Walker: `recommend_activities`

**Purpose:** Recommends activities based on current mood using graph traversal

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "recommend_activities",
  "ctx": {
    "emotion_name": "anxious",
    "intensity": 7.5
  }
}
```

**Response:**

```json
{
  "emotion": "anxious",
  "recommendations": [
    {
      "name": "deep_breathing",
      "description": "5-minute breathing exercise",
      "effectiveness": 0.92,
      "times_used": 15
    },
    {
      "name": "meditation",
      "description": "10-minute guided meditation",
      "effectiveness": 0.85,
      "times_used": 8
    },
    {
      "name": "nature_walk",
      "description": "30-minute walk in nature",
      "effectiveness": 0.78,
      "times_used": 5
    }
  ],
  "count": 3
}
```

---

### Walker: `suggest_habit_improvements`

**Purpose:** Suggests specific habits to improve emotional wellbeing

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "suggest_habit_improvements",
  "ctx": {
    "detected_triggers": ["work_stress", "poor_sleep", "isolation"],
    "dominant_emotions": ["anxious", "stressed"],
    "current_habits": ["meditation", "journaling"],
    "intensity_average": 6.2
  }
}
```

**Response:**

```json
{
  "suggested_habits": [
    {
      "name": "Morning Routine",
      "description": "15-minute morning routine with breathing and stretching",
      "helps_with": ["anxiety", "stress"],
      "difficulty": "easy",
      "implementation": "Start with just 5 minutes",
      "expected_benefit": "high"
    },
    {
      "name": "Exercise Routine",
      "description": "30-minute physical activity 3x/week",
      "helps_with": ["stress", "anxiety", "sleep"],
      "difficulty": "medium",
      "implementation": "Start with walks, progress to running",
      "expected_benefit": "high"
    }
  ]
}
```

---

## 4. LLM INTEGRATION WALKERS

### Walker: `emotion_from_text`

**Purpose:** Analytical LLM - Analyzes text to extract emotional information

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "emotion_from_text",
  "ctx": {
    "journal_text": "I'm feeling really anxious about the presentation tomorrow...",
    "user_id": "user_001"
  }
}
```

**Response:**

```json
{
  "user_id": "user_001",
  "raw_text": "I'm feeling really anxious about the presentation tomorrow...",
  "analysis": {
    "emotions": ["anxious", "nervous"],
    "intensity": 8,
    "triggers": ["presentation", "public_speaking"],
    "sentiment": "negative",
    "themes": ["fear_of_judgment", "performance_pressure"],
    "suggested_strategies": [
      "Practice your presentation out loud",
      "Do a grounding exercise before presenting",
      "Remember past successes"
    ]
  },
  "status": "complete"
}
```

---

### Walker: `generate_support_message`

**Purpose:** Generative LLM - Creates empathetic responses

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "generate_support_message",
  "ctx": {
    "emotion_name": "anxious",
    "intensity_score": 7.5,
    "detected_triggers": ["work_deadline", "poor_sleep"],
    "user_context": "I have a big presentation tomorrow"
  }
}
```

**Response:**

```json
{
  "emotion": "anxious",
  "intensity": 7.5,
  "message": "I hear you - feeling anxious about an upcoming presentation is completely natural. Your nervousness shows you care about doing well, which is actually a strength. Here's what might help...",
  "generated_at": "2024-01-15T10:30:00.000Z"
}
```

---

### Walker: `generate_breathing_exercise`

**Purpose:** Generative LLM - Creates personalized breathing exercises

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "generate_breathing_exercise",
  "ctx": {
    "emotion_name": "anxious",
    "intensity_score": 8,
    "duration_preference": 300
  }
}
```

**Response:**

```json
{
  "emotion": "anxious",
  "intensity": 8,
  "exercise": {
    "name": "Extended Exhale Breathing",
    "duration_seconds": 300,
    "steps": [
      "Sit or lie down in a comfortable position",
      "Breathe in through your nose for a count of 4",
      "Hold your breath for a count of 4",
      "Exhale through your mouth for a count of 8",
      "Repeat for 10 cycles (about 4 minutes total)"
    ],
    "benefit": "The extended exhale activates your parasympathetic nervous system, reducing anxiety"
  }
}
```

---

### Walker: `generate_affirmation`

**Purpose:** Generative LLM - Creates personalized affirmations

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "generate_affirmation",
  "ctx": {
    "emotion_name": "anxious",
    "intensity_score": 7,
    "user_name": "Sarah",
    "detected_triggers": ["perfectionism", "public_speaking"]
  }
}
```

**Response:**

```json
{
  "emotion": "anxious",
  "affirmation": "Sarah, I am capable and prepared. My nervousness is just energy waiting to be channeled. I trust in my abilities and know that it's okay to be imperfect.",
  "generated_at": "2024-01-15T10:30:00.000Z"
}
```

---

### Walker: `generate_weekly_reflection`

**Purpose:** Generative LLM - Creates comprehensive weekly summary

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "generate_weekly_reflection",
  "ctx": {
    "user_id": "user_001",
    "weekly_emotions": {
      "calm": 2,
      "anxious": 2,
      "stressed": 1,
      "happy": 1
    },
    "detected_patterns": [
      "anxiety spikes on Monday",
      "better mood after exercise"
    ],
    "week_number": 3
  }
}
```

**Response:**

```json
{
  "user_id": "user_001",
  "week_number": 3,
  "reflection": "What a meaningful week it's been! You've shown real emotional awareness...",
  "generated_at": "2024-01-15T10:30:00.000Z"
}
```

---

## 5. TREND ANALYSIS WALKERS

### Walker: `find_repeating_triggers`

**Purpose:** Identifies most common emotional triggers

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "find_repeating_triggers",
  "ctx": {
    "user_id": "user_001",
    "lookback_days": 30
  }
}
```

**Response:**

```json
{
  "user_id": "user_001",
  "period_days": 30,
  "triggers": [
    ["work_stress", 12],
    ["poor_sleep", 8],
    ["social_conflict", 5],
    ["financial_pressure", 3]
  ]
}
```

---

### Walker: `find_common_emotions`

**Purpose:** Detects prevalent mood patterns

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "find_common_emotions",
  "ctx": {
    "user_id": "user_001",
    "period_days": 30
  }
}
```

**Response:**

```json
{
  "user_id": "user_001",
  "period_days": 30,
  "emotion_distribution": {
    "calm": 8,
    "anxious": 6,
    "stressed": 5,
    "happy": 4,
    "peaceful": 3
  },
  "percentages": {
    "calm": 33.3,
    "anxious": 25.0,
    "stressed": 20.8,
    "happy": 16.7,
    "peaceful": 12.5
  }
}
```

---

### Walker: `calculate_emotional_trends`

**Purpose:** Computes emotional trajectory and volatility

**Endpoint:** `POST /api/walker`

**Request:**

```json
{
  "walker": "calculate_emotional_trends",
  "ctx": {
    "user_id": "user_001",
    "lookback_days": 14
  }
}
```

**Response:**

```json
{
  "user_id": "user_001",
  "period_days": 14,
  "trend": "stable",
  "volatility": 18.5,
  "stability_score": 81.5
}
```

**Trend Values:**

- `"improving"` - Average intensity increasing over time
- `"declining"` - Average intensity decreasing over time
- `"stable"` - Relatively consistent intensity
- `"insufficient_data"` - Not enough entries to calculate

---

## ERROR RESPONSES

### Standard Error Format

All errors follow this format:

```json
{
  "error": "error_code",
  "message": "Human-readable error message",
  "details": {
    "field": "Additional context"
  }
}
```

### Common Error Codes

| Code                | HTTP | Description                  |
| ------------------- | ---- | ---------------------------- |
| `invalid_emotion`   | 400  | Emotion not found in catalog |
| `invalid_intensity` | 400  | Intensity not between 1-10   |
| `user_not_found`    | 404  | User ID doesn't exist        |
| `llm_error`         | 500  | LLM API call failed          |
| `graph_error`       | 500  | Graph storage error          |
| `insufficient_data` | 400  | Not enough historical data   |
| `rate_limit`        | 429  | API rate limit exceeded      |
| `unauthorized`      | 401  | Missing or invalid API key   |

---

## RATE LIMITS

- **Mood Logging**: 60 requests per hour per user
- **LLM Calls**: 30 requests per hour per user
- **Summary Requests**: Unlimited (cached)
- **Analysis Walkers**: 10 requests per hour per user

---

## EXAMPLE REQUESTS (JavaScript/Fetch)

### Log a mood with journaling

```javascript
const response = await fetch("http://localhost:5000/api/walker", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    walker: "log_mood",
    ctx: {
      user_id: "user_001",
      mood_name: "anxious",
      intensity: 7.5,
      journal_text: "Worried about tomorrow's presentation...",
    },
  }),
});

const result = await response.json();
console.log(result);
```

### Get personalized support message

```javascript
const response = await fetch("http://localhost:5000/api/walker", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    walker: "generate_support_message",
    ctx: {
      emotion_name: "anxious",
      intensity_score: 7.5,
      detected_triggers: ["work", "presentation"],
      user_context: "Have a big presentation tomorrow",
    },
  }),
});

const support = await response.json();
console.log(support.message);
```

### Get weekly emotional summary

```javascript
const response = await fetch("http://localhost:5000/api/walker", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    walker: "get_weekly_summary",
    ctx: { user_id: "user_001" },
  }),
});

const summary = await response.json();
console.log(summary.dominant_emotions);
console.log(summary.habit_recommendations);
```
