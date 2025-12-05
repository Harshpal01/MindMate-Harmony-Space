# Architecture & System Design

## MindMate Harmony Space - Technical Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      FRONTEND (React)                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ MoodLogger   │  │DailySummary  │  │WeeklyTrends  │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                   │
│         └─────────────────┼─────────────────┘                   │
│                           │                                      │
│                    Spawn() API Calls                            │
└───────────────────────────┼──────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌──────────────────┬──────────────────┬──────────────────┐
│  Walker: log_    │  Walker: emotion │ Walker: generate │
│    mood          │  _from_text      │ _support_message │
│                  │                  │                  │
│ Updates OSP      │ Analytical LLM   │ Generative LLM   │
└────────┬─────────┴────────┬─────────┴────────┬─────────┘
         │                  │                  │
         └──────────────────┼──────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌──────────────────┬──────────────────┬──────────────────┐
│    JASECI        │    OSP GRAPH     │   byLLM System   │
│    Framework     │                  │                  │
│                  │ • Emotion Nodes  │ • OpenAI API     │
│ • Walkers        │ • Trigger Nodes  │ • Ollama (Local) │
│ • Graph Storage  │ • Activity Nodes │ • Anthropic      │
│ • State Machine  │ • Journal Nodes  │                  │
└──────────────────┴──────────────────┴──────────────────┘
         │                  │                  │
         └──────────────────┼──────────────────┘
                            │
                    ┌───────▼────────┐
                    │   DATABASE     │
                    │   (SQLite /    │
                    │   PostgreSQL)  │
                    └────────────────┘
```

---

## Core Components

### 1. Frontend Layer (React)

**Components:**

- `MoodLogger.jsx` - User mood entry interface
- `DailySummary.jsx` - Current mood and recommendations
- `WeeklyTrends.jsx` - Trend analysis and insights
- `App.jsx` - Main application shell

**Features:**

- Emoji mood picker
- Intensity slider (1-10)
- Journal text input
- Real-time LLM analysis
- Graph visualization (via Recharts)
- Responsive design

### 2. Backend Layer (Jaseci)

**Core Files:**

- `mindmate.jac` - OSP Graph node definitions
- `walkers.jac` - Walker implementations
- `agents.jac` - Multi-agent LLM system
- `config.py` - Configuration management
- `seed_data.py` - Initial data seeds

**Key Walkers:**

```
┌─ Mood Management
│  ├─ log_mood
│  ├─ analyze_journal
│  └─ update_graph
│
├─ Summaries
│  ├─ get_daily_summary
│  ├─ get_weekly_summary
│  └─ generate_weekly_reflection
│
├─ Recommendations
│  ├─ recommend_activities
│  ├─ suggest_habit_improvements
│  └─ find_repeating_triggers
│
├─ Analysis
│  ├─ find_common_emotions
│  └─ calculate_emotional_trends
│
└─ LLM Agents
   ├─ emotion_from_text (Analytical)
   ├─ generate_support_message (Generative)
   ├─ generate_breathing_exercise (Generative)
   └─ generate_affirmation (Generative)
```

### 3. OSP Graph Structure

**Node Types & Relationships:**

```
emotion (name, emoji, intensity, timestamp, frequency)
    ├─ [emotion_trigger] ──→ trigger (name, category, frequency)
    │
    ├─ [emotion_activity] ──→ activity (name, type, duration, effectiveness)
    │
    ├─ [emotion_suggestion] ──→ suggestion (title, content, type, duration)
    │
    ├─ [entry_emotion] ← journal_entry (text, keywords, mood_before/after)
    │
    └─ [emotion_emotion] ──→ emotion (transition patterns)
```

**Edge Weights:**

- `emotion_trigger`: strength (correlation), frequency
- `emotion_activity`: effectiveness (0-1), times_used
- `emotion_suggestion`: relevance (0-1), uses_count

---

## Multi-Agent System

### Agent 1: Emotional Analyzer (Analytical byLLM)

**Role:** Extract emotional intelligence from user input

**Input:**

- Journal text
- Mood description

**Processing:**

```
journal_text
  → NLP Analysis
  → Emotion Classification
  → Trigger Detection
  → Intensity Scoring
```

**Output:**

```json
{
  "emotions": ["anxious", "stressed"],
  "intensity": 7.5,
  "triggers": ["work deadline", "sleep deprivation"],
  "sentiment": "negative",
  "themes": ["pressure", "fatigue"],
  "keywords": ["deadline", "tired", "overwhelmed"]
}
```

**Prompt Template:**

```
You are an expert emotional intelligence analyst. Analyze the following
journal entry and extract:
1. Primary emotion(s) being expressed
2. Emotional intensity on a scale of 1-10
3. Identified triggers or causes
4. Sentiment (positive/neutral/negative)
5. Key emotional themes
6. Suggested coping strategies

Journal Entry: "{text}"

Please provide a structured JSON response...
```

---

### Agent 2: Supportive Companion (Generative byLLM)

**Role:** Generate empathetic responses and coping strategies

**Input:**

- Emotion name
- Intensity score
- Detected triggers
- User context (optional)

**Processing:**

```
emotion_profile
  → Empathy Generation
  → Strategy Selection
  → Personalization
```

**Output:**

```
empathetic_message: "I understand you're feeling anxious..."
coping_strategies: ["Try the 4-7-8 breathing exercise", "Take a 10-minute walk", ...]
affirmation: "You are capable of handling this..."
suggested_activities: ["meditation", "journaling", "exercise"]
```

**Prompt Template:**

```
You are a compassionate mental wellness companion. Based on the
following emotional state, provide supportive guidance:

Emotion: {emotion}
Intensity (1-10): {intensity}
Identified Triggers: {triggers}

Please provide:
1. Empathetic acknowledgment
2. 3-5 specific, actionable coping strategies
3. A personalized affirmation
4. Recommended activities
5. When to seek additional support
```

---

### Agent 3: Trend Detection & Planner

**Role:** Analyze patterns and suggest habit improvements

**Capabilities:**

- Graph traversal for pattern detection
- Historical data analysis
- Habit recommendation
- Progress tracking

**Metrics Calculated:**

- Emotion frequency distribution
- Trigger-emotion associations
- Emotional volatility
- Trend direction (improving/declining/stable)
- Stability score

---

## Data Flow

### Workflow: User Logs Mood

```
1. User selects mood, intensity, and writes journal entry
   └─> MoodLogger component captures data

2. Frontend calls log_mood walker via Spawn()
   └─> {user_id, mood_name, intensity, journal_text}

3. log_mood walker:
   a. Creates emotion node with timestamp
   b. Creates journal_entry node
   c. Connects entry → emotion [entry_emotion]
   d. Stores in Jaseci graph store
   └─> Returns {status: "success", ...}

4. Frontend simultaneously calls emotion_from_text walker
   └─> Analytical LLM extracts emotions, triggers, keywords

5. update_graph walker:
   a. Creates relationships between emotion → triggers
   b. Creates relationships emotion → activities
   c. Creates relationships emotion → suggestions
   └─> Returns relationship count

6. Frontend calls generate_support_message walker
   └─> Generative LLM creates empathetic response

7. Display support message and recommendations to user
```

### Workflow: User Requests Daily Summary

```
1. User navigates to Daily Check-in tab
   └─> DailySummary component mounts

2. Component calls get_daily_summary walker
   └─> Graph query: get latest emotion entry for user

3. Walker traverses graph:
   a. Find latest emotion node
   b. Traverse emotion → trigger edges
   c. Traverse emotion → activity edges
   d. Traverse emotion → suggestion edges

4. Component displays:
   - Current mood & intensity
   - Related triggers
   - Recommended activities
   - AI-generated suggestions

5. User can click to view:
   - Breathing exercise (generate_breathing_exercise walker)
   - Affirmation (generate_affirmation walker)
   - Support message (generate_support_message walker)
```

### Workflow: User Views Weekly Trends

```
1. User navigates to Weekly Trends tab
   └─> WeeklyTrends component mounts

2. Component calls in parallel:
   a. getWeeklySummary walker
   b. findCommonEmotions walker
   c. calculateEmotionalTrends walker

3. getWeeklySummary:
   - Graph query: get all emotion nodes from past 7 days
   - Count emotion frequencies
   - Calculate trend analysis
   - Generate recommendations

4. findCommonEmotions:
   - Graph traversal: all emotions for user
   - Generate frequency distribution
   - Calculate percentages

5. calculateEmotionalTrends:
   - Timeline analysis of intensity scores
   - Calculate volatility (stdev of intensities)
   - Determine trend direction
   - Calculate stability score

6. Frontend displays charts and insights
```

---

## Database Schema (Conceptual)

```sql
-- Core Tables (if using SQL backend)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  username TEXT,
  email TEXT,
  created_at TIMESTAMP
);

CREATE TABLE emotions (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users,
  name TEXT,
  emoji TEXT,
  intensity FLOAT,
  timestamp TIMESTAMP
);

CREATE TABLE triggers (
  id TEXT PRIMARY KEY,
  name TEXT,
  category TEXT,
  frequency INT
);

CREATE TABLE journal_entries (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users,
  text TEXT,
  emotion_id TEXT REFERENCES emotions,
  timestamp TIMESTAMP,
  keywords TEXT[]
);

CREATE TABLE emotion_trigger_edges (
  emotion_id TEXT REFERENCES emotions,
  trigger_id TEXT REFERENCES triggers,
  strength FLOAT,
  frequency INT
);

-- Graph storage is handled by Jaseci's OSP
```

---

## LLM Integration

**Supported Providers:**

- OpenAI (GPT-3.5, GPT-4)
- Ollama (Local inference)
- Anthropic (Claude)

**Configuration in `config.py`:**

```python
LLM_PROVIDER = "openai"  # or "ollama", "anthropic"
OPENAI_API_KEY = "sk-..."
OPENAI_MODEL = "gpt-3.5-turbo"
```

**API Integration Pattern:**

```python
# In agents.jac
response = requests.post(
    LLM_ENDPOINT,
    headers={"Authorization": f"Bearer {LLM_API_KEY}"},
    json={
        "model": LLM_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": temperature,
        "max_tokens": max_tokens
    }
)
```

---

## Performance Considerations

### Graph Optimization

- **Indexing**: Node types are indexed for fast lookups
- **Edge pruning**: Old relationships (> 90 days) can be archived
- **Traversal limits**: Maximum graph depth to prevent infinite loops

### LLM Optimization

- **Caching**: Response caching for identical inputs
- **Batch processing**: Multiple requests batched when possible
- **Token limits**: Prompt engineering to minimize token usage

### Frontend Optimization

- **Lazy loading**: Components load data on demand
- **Parallel requests**: Multiple walker calls in parallel where possible
- **Debouncing**: Input debouncing for search/filter operations

---

## Error Handling

**Error Types & Handling:**

```
LLM API Error
├─ Rate limit → Retry with exponential backoff
├─ Invalid API key → User notification
└─ Service unavailable → Fallback to default suggestions

Graph Error
├─ Node not found → Return empty result
├─ Circular reference → Depth limit prevention
└─ Storage error → Log and retry

Frontend Error
├─ Network timeout → Retry or show offline message
├─ Invalid input → Client-side validation
└─ Parse error → Graceful degradation
```

---

## Security

**Best Practices:**

1. **API Keys**: Stored in environment variables, never in code
2. **Input Validation**: All user inputs validated before processing
3. **CORS**: Frontend and backend CORS policies configured
4. **Authentication**: JWT tokens for user sessions (optional expansion)
5. **Data Privacy**: User data stored securely, GDPR-compliant

---

## Scalability

**Future Improvements:**

1. **Caching Layer**: Redis for frequently accessed data
2. **Graph Partitioning**: Shard users across multiple graph stores
3. **Worker Queue**: Celery for async LLM calls
4. **Load Balancing**: Multiple Jaseci server instances
5. **Monitoring**: Prometheus/Grafana for system metrics

---

## Testing Strategy

**Unit Tests:**

- Walker logic (mood logging, graph updates)
- LLM prompt formatting
- Data validation

**Integration Tests:**

- End-to-end workflows (mood logging → recommendation)
- Database consistency
- API response validation

**Performance Tests:**

- Graph traversal speed (< 100ms)
- LLM response time (< 5s)
- Frontend load time (< 3s)

---

## Deployment

**Development:**

```bash
# Backend
cd backend && python seed_database.py
jsctl -m jaseci_serv start

# Frontend
cd frontend && npm start
```

**Production:**

- Docker containerization for backend and frontend
- Kubernetes orchestration (optional)
- CI/CD pipeline via GitHub Actions
- Database backups and monitoring
