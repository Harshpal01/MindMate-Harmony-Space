# API Endpoints & Walker Reference

## MindMate Harmony Space - Complete Walker API Reference

All walkers are called via HTTP POST to `/walker/{walker_name}` endpoints.

**Base URL (Local):** `http://localhost:8000`  
**Base URL (Production):** `https://mindmate-backend-9kok.onrender.com`

---

## 1. MOOD LOGGING & ANALYSIS

### Walker: `log_mood`

**Purpose:** Records a new mood entry and stores in root node

**Endpoint:** `POST /walker/log_mood`

**Request:**

```json
{
  "user_id": "user_001",
  "mood_name": "anxious",
  "intensity": 7.5,
  "journal_text": "Had a tough day at work, feeling overwhelmed"
}
```

**Response:**

```json
{
  "reports": [
    {
      "status": "success",
      "message": "Logged anxious mood at intensity 7.5",
      "data": {
        "user_id": "user_001",
        "mood_name": "anxious",
        "intensity": 7.5,
        "journal_text": "Had a tough day at work, feeling overwhelmed",
        "timestamp": "2025-12-19T10:30:00.123456"
      },
      "total_entries": 15
    }
  ]
}
```

---

### Walker: `analyze_journal`

**Purpose:** Analyzes journal text for emotional insights

**Endpoint:** `POST /walker/analyze_journal`

**Request:**

```json
{
  "journal_text": "I'm feeling so overwhelmed with work and personal life...",
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "status": "analyzing",
      "journal_length": 156,
      "analysis_complete": true
    }
  ]
}
```

---

## 2. SUMMARIES & INSIGHTS

### Walker: `get_daily_summary`

**Purpose:** Returns current emotional state with recommendations

**Endpoint:** `POST /walker/get_daily_summary`

**Request:**

```json
{
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "current_mood": "anxious",
      "intensity": 7.5,
      "triggers": ["work_stress", "poor_sleep"],
      "recommended_activities": [
        {
          "name": "meditation",
          "description": "10-minute guided meditation",
          "effectiveness_score": 0.85
        },
        {
          "name": "exercise",
          "description": "30-minute walk",
          "effectiveness_score": 0.78
        }
      ],
      "timestamp": "2025-12-19T10:30:00.123456"
    }
  ]
}
```

---

### Walker: `get_weekly_summary`

**Purpose:** Generates emotional trend report for the past week

**Endpoint:** `POST /walker/get_weekly_summary`

**Request:**

```json
{
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "period": "last_7_days",
      "total_entries": 6,
      "dominant_emotions": {
        "calm": 2,
        "anxious": 2,
        "stressed": 1,
        "happy": 1
      },
      "stability_score": 75.5,
      "trend_direction": "stable",
      "summary": "Your emotional state has been relatively stable this week..."
    }
  ]
}
```

---

## 3. RECOMMENDATIONS & ACTIVITIES

### Walker: `recommend_activities`

**Purpose:** Recommends activities based on current mood

**Endpoint:** `POST /walker/recommend_activities`

**Request:**

```json
{
  "emotion_name": "anxious",
  "intensity": 7.5
}
```

**Response:**

```json
{
  "reports": [
    {
      "emotion": "anxious",
      "recommendations": [
        {
          "name": "deep_breathing",
          "description": "5-minute breathing exercise",
          "effectiveness_score": 0.92
        },
        {
          "name": "meditation",
          "description": "10-minute guided meditation",
          "effectiveness_score": 0.85
        },
        {
          "name": "nature_walk",
          "description": "30-minute walk in nature",
          "effectiveness_score": 0.78
        }
      ],
      "count": 3
    }
  ]
}
```

---

### Walker: `suggest_habit_improvements`

**Purpose:** Suggests specific habits to improve emotional wellbeing

**Endpoint:** `POST /walker/suggest_habit_improvements`

**Request:**

```json
{
  "detected_triggers": ["work_stress", "poor_sleep", "isolation"],
  "dominant_emotions": ["anxious", "stressed"],
  "current_habits": ["meditation", "journaling"],
  "intensity_average": 6.2
}
```

**Response:**

```json
{
  "reports": [
    {
      "suggested_habits": [
        {
          "name": "Morning Routine",
          "description": "15-minute morning routine with breathing and stretching",
          "helps_with": ["anxiety", "stress"],
          "difficulty": "easy",
          "implementation": "Start with just 5 minutes"
        },
        {
          "name": "Exercise Routine",
          "description": "30-minute physical activity 3x/week",
          "helps_with": ["stress", "anxiety", "sleep"],
          "difficulty": "medium",
          "implementation": "Start with walks, progress to running"
        }
      ]
    }
  ]
}
```

---

## 4. LLM INTEGRATION WALKERS (byLLM)

### Walker: `emotion_from_text`

**Purpose:** Analytical byLLM - Analyzes text to extract emotional information

**Endpoint:** `POST /walker/emotion_from_text`

**Request:**

```json
{
  "journal_text": "I'm feeling really anxious about the presentation tomorrow...",
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "user_id": "user_001",
      "raw_text": "I'm feeling really anxious about the presentation tomorrow...",
      "analysis": {
        "emotions": ["anxious", "nervous"],
        "intensity": 8,
        "triggers": ["presentation", "public_speaking"],
        "sentiment": "negative",
        "themes": ["fear_of_judgment", "performance_pressure"]
      },
      "status": "complete"
    }
  ]
}
```

---

### Walker: `generate_support_message`

**Purpose:** Generative byLLM - Creates empathetic responses

**Endpoint:** `POST /walker/generate_support_message`

**Request:**

```json
{
  "emotion_name": "anxious",
  "intensity_score": 7.5,
  "detected_triggers": ["work_deadline", "poor_sleep"]
}
```

**Response:**

```json
{
  "reports": [
    {
      "emotion": "anxious",
      "intensity": 7.5,
      "message": "I hear you - feeling anxious about an upcoming presentation is completely natural. Your nervousness shows you care about doing well, which is actually a strength. Here's what might help...",
      "generated_at": "2025-12-19T10:30:00.123456"
    }
  ]
}
```

---

### Walker: `generate_breathing_exercise`

**Purpose:** Generative byLLM - Creates personalized breathing exercises

**Endpoint:** `POST /walker/generate_breathing_exercise`

**Request:**

```json
{
  "emotion_name": "anxious",
  "intensity_score": 8,
  "duration_preference": 300
}
```

**Response:**

```json
{
  "reports": [
    {
      "emotion": "anxious",
      "intensity": 8,
      "exercise_name": "Extended Exhale Breathing",
      "description": "The extended exhale activates your parasympathetic nervous system, reducing anxiety",
      "duration_minutes": 5,
      "steps": [
        "Sit or lie down in a comfortable position",
        "Breathe in through your nose for a count of 4",
        "Hold your breath for a count of 4",
        "Exhale through your mouth for a count of 8",
        "Repeat for 10 cycles (about 4 minutes total)"
      ]
    }
  ]
}
```

---

### Walker: `generate_affirmation`

**Purpose:** Generative byLLM - Creates personalized affirmations

**Endpoint:** `POST /walker/generate_affirmation`

**Request:**

```json
{
  "emotion_name": "anxious",
  "intensity_score": 7,
  "detected_triggers": ["perfectionism", "public_speaking"]
}
```

**Response:**

```json
{
  "reports": [
    {
      "emotion": "anxious",
      "affirmation": "I am capable and prepared. My nervousness is just energy waiting to be channeled. I trust in my abilities and know that it's okay to be imperfect.",
      "generated_at": "2025-12-19T10:30:00.123456"
    }
  ]
}
```

---

### Walker: `generate_weekly_reflection`

**Purpose:** Generative byLLM - Creates comprehensive weekly summary

**Endpoint:** `POST /walker/generate_weekly_reflection`

**Request:**

```json
{
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
  ]
}
```

**Response:**

```json
{
  "reports": [
    {
      "user_id": "user_001",
      "reflection": "What a meaningful week it's been! You've shown real emotional awareness...",
      "generated_at": "2025-12-19T10:30:00.123456"
    }
  ]
}
```

---

## 5. TREND ANALYSIS WALKERS

### Walker: `find_repeating_triggers`

**Purpose:** Identifies most common emotional triggers

**Endpoint:** `POST /walker/find_repeating_triggers`

**Request:**

```json
{
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "user_id": "user_001",
      "triggers": [
        ["work_stress", 12],
        ["poor_sleep", 8],
        ["social_conflict", 5],
        ["financial_pressure", 3]
      ]
    }
  ]
}
```

---

### Walker: `find_common_emotions`

**Purpose:** Detects prevalent mood patterns

**Endpoint:** `POST /walker/find_common_emotions`

**Request:**

```json
{
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "user_id": "user_001",
      "emotion_distribution": {
        "calm": 8,
        "anxious": 6,
        "stressed": 5,
        "happy": 4,
        "peaceful": 3
      },
      "percentages": {
        "calm": 30.8,
        "anxious": 23.1,
        "stressed": 19.2,
        "happy": 15.4,
        "peaceful": 11.5
      }
    }
  ]
}
```

---

### Walker: `calculate_emotional_trends`

**Purpose:** Computes emotional trajectory and stability score

**Endpoint:** `POST /walker/calculate_emotional_trends`

**Request:**

```json
{
  "user_id": "user_001"
}
```

**Response:**

```json
{
  "reports": [
    {
      "user_id": "user_001",
      "stability_score": 75.5,
      "trend_direction": "improving",
      "volatility": 2.3,
      "average_intensity": 5.8,
      "trend_analysis": "Your emotional stability has improved over the past week..."
    }
  ]
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
const response = await fetch("http://localhost:8000/walker/log_mood", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    user_id: "user_001",
    mood_name: "anxious",
    intensity: 7.5,
    journal_text: "Worried about tomorrow's presentation...",
  }),
});

const result = await response.json();
console.log(result.reports[0]);
```

### Get personalized support message

```javascript
const response = await fetch(
  "http://localhost:8000/walker/generate_support_message",
  {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      emotion_name: "anxious",
      intensity_score: 7.5,
      detected_triggers: ["work", "presentation"],
    }),
  }
);

const support = await response.json();
console.log(support.reports[0].message);
```

### Get weekly emotional summary

```javascript
const response = await fetch(
  "http://localhost:8000/walker/get_weekly_summary",
  {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      user_id: "user_001",
    }),
  }
);

const summary = await response.json();
console.log(summary.reports[0].dominant_emotions);
console.log(summary.reports[0].stability_score);
```
