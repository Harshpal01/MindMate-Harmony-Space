# MindMate Harmony Space - AI Mental-Wellbeing Companion

A compassionate AI-powered emotional wellness companion designed to help users track moods, understand emotional patterns, and receive personalized AI-generated support using Jaseci's Object-Spatial Graph (OSP), walkers, and byLLM intelligence.

## � Demo Video

**[Watch the Demo Video Here](https://drive.google.com/file/d/1Nkj72sAz7G5QHL_zmcoNLTXvX4Ep6pez/view?usp=sharing)**

> See the full walkthrough of MindMate Harmony Space features, including mood logging, AI-generated insights, and emotional trend analysis.

## �🎯 Project Overview

**MindMate Harmony Space** is built on the Jaseci framework and features:

- **OSP Graph**: Relationship mapping between emotions, triggers, activities, journaling entries, and AI suggestions
- **Multi-Agent System**: 3 specialized AI agents for emotional analysis, support generation, and trend detection
- **Jac Walkers**: Backend logic for mood logging, graph updates, LLM integration, and emotional analysis
- **React Frontend**: User-friendly interface for mood logging, journaling, and viewing AI-generated insights
- **byLLM Integration**: Both analytical and generative LLM capabilities for emotional understanding and supportive responses

## 🏗️ Architecture

### OSP Graph Structure

```
Emotion Nodes ──→ Trigger Nodes
    ↓
Relationship Edges
    ↓
Activity Nodes ──→ Suggestion Nodes
    ↓
Journal Entries
```

**Node Types (7):**

1. **user** - User profile (user_id, name, created_at)
2. **emotion** - Emotional states (name, emoji, intensity, frequency)
3. **trigger** - Emotional triggers (name, category, description, occurrence_count)
4. **activity** - Coping activities (name, type, duration_minutes, description, effectiveness_score)
5. **suggestion** - AI-generated recommendations (text, category, relevance_score)
6. **journal_entry** - Daily reflections (user_id, entry_text, timestamp, detected_emotions, sentiment_score)
7. **mood_log** - Mood tracking entries (user_id, emotion_name, intensity, timestamp, journal_text)

**Edge Types (6):**

1. **feels** - User → Emotion (timestamp, intensity)
2. **caused_by** - Emotion → Trigger (strength, timestamp)
3. **helps_with** - Activity → Emotion (effectiveness, usage_count)
4. **suggests** - Emotion → Suggestion (relevance, confidence)
5. **correlates_with** - Emotion ↔ Emotion (correlation_strength, co_occurrence_count)
6. **influences** - Trigger → Emotion (impact_score, direction)

### Multi-Agent System

#### Agent 1: Emotional Analyzer (Analytical byLLM)

- Classifies emotional tone from journaling text
- Detects triggers and stress causes
- Extracts emotional keywords
- Scores emotional intensity (1-10)
- **Input**: User's journal entry text
- **Output**: Emotion classification, triggers, intensity score, keywords

#### Agent 2: Supportive Companion (Generative byLLM)

- Generates empathetic responses
- Suggests personalized coping strategies
- Recommends breathing exercises
- Creates daily/weekly emotional summaries
- Provides affirmations
- **Input**: Emotion classification, intensity score, user context
- **Output**: Supportive message, breathing exercises, affirmations

#### Agent 3: Trend Detection & Planner

- Analyzes mood patterns over time using graph traversal
- Detects negative emotional cycles
- Suggests corrective habits and activities
- Identifies most common triggers and emotions
- **Input**: Historical mood data, graph relationships
- **Output**: Trend analysis, habit recommendations, pattern insights

## 🚀 Core Walkers

**15 Walkers** implemented in `walkers.jac`:

### Mood & Logging Walkers

- **`log_mood`** - Records mood entry with timestamp and stores in root node
- **`analyze_journal`** - Analyzes journal text for emotional insights

### Summary & Recommendation Walkers

- **`get_daily_summary`** - Returns emotional state with triggers and recommendations
- **`get_weekly_summary`** - Weekly emotional trend report with stability score
- **`recommend_activities`** - Suggests coping activities based on current mood
- **`get_daily_affirmation`** - Provides daily personalized affirmation

### LLM Integration Walkers (byLLM)

- **`emotion_from_text`** - Analytical LLM: extracts emotion data from text
- **`generate_support_message`** - Generative LLM: creates empathetic responses
- **`generate_breathing_exercise`** - Generative LLM: creates personalized breathing guides
- **`generate_affirmation`** - Generative LLM: creates personalized affirmations
- **`generate_weekly_reflection`** - Generative LLM: creates weekly emotional summary
- **`suggest_habit_improvements`** - Generative LLM: suggests lifestyle improvements

### Graph Analysis Walkers

- **`find_repeating_triggers`** - Identifies most common emotional triggers
- **`find_common_emotions`** - Detects prevalent mood patterns
- **`calculate_emotional_trends`** - Computes emotional trajectory and stability score

## 🛠️ Tech Stack

### Backend

- **Jaseci v0.9.3 + JacLang** - OSP graph and walker definitions (mindmate.jac, walkers.jac, agents.jac, app.jac)
- **jac serve** - Built-in Jaseci HTTP server exposing walker endpoints
- **byLLM Integration** - Built-in Jaseci LLM capabilities (analytical and generative modes)
- **Python** - Helper functions and configuration (config.py, mind_functions.py, seed_data.py)

### Frontend

- **React 18** - UI library
- **Axios** - HTTP client for walker API calls
- **jac-client** - Official Jaseci client library (installed as dependency)
- **Recharts** - Emotional trend visualization
- **React Icons** - Icon components
- **Emoji Picker React** - Emoji selection for mood logging
- **Custom CSS** - Component-specific styling

### Database / Storage

- **Root Node Storage** - Persistent data stored on Jaseci root node using `here` keyword
- **Session File** - walkers.session (SQLite-based, auto-generated)
- **OSP Graph** - Full graph structure defined in mindmate.jac with 7 node types and 6 edge types

## 📋 Project Structure

```
MindMate-Harmony-Space/
├── backend/
│   ├── mindmate.jac              # Main OSP graph & node definitions
│   ├── walkers.jac               # Core Jac walkers (graph + analysis)
│   ├── agents.jac                # AI agents (byLLM prompts and logic)
│   ├── app.jac                   # Application initialization
│   ├── seed_data.py              # Initial emotions, triggers, activities, suggestions
│   ├── config.py                 # Configuration (LLM providers, DB, server)
│   ├── mind_functions.py         # Helper functions
│   └── requirements.txt          # Python dependencies
├── frontend/
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── components/
│   │   │   ├── MoodLogger.jsx
│   │   │   ├── DailySummary.jsx
│   │   │   └── WeeklyTrends.jsx
│   │   ├── pages/               # (Empty - future expansion)
│   │   ├── services/
│   │   │   └── api.js           # Walker API calls
│   │   ├── styles/
│   │   │   ├── DailySummary.css
│   │   │   ├── MoodLogger.css
│   │   │   └── WeeklyTrends.css
│   │   ├── App.jsx
│   │   ├── App.css
│   │   ├── index.js
│   │   └── index.css
│   ├── package.json
│   └── .env.example
├── docs/
│   ├── ARCHITECTURE.md           # Detailed architecture
│   ├── AGENT_PROMPTS.md          # LLM prompt templates
│   ├── API_ENDPOINTS.md          # Walker API reference
│   └── DEMO_GUIDE.md             # How to run the demo
├── examples/
│   └── seed_data.json            # Sample data for testing
├── Procfile                      # Deployment configuration
├── render.yaml                   # Render deployment settings
├── RENDER_DEPLOYMENT.md          # Deployment guide
├── QUICK_START.md                # Quick start guide
├── README.md
└── LICENSE
└── .gitignore
```

## 🚀 Quick Start

### Prerequisites

- Python 3.10+
- Node.js 16+
- pip & npm
- JacLang v0.9.3 (`pip install jaclang==0.9.3`)

### Backend Setup (Local)

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Start Jaseci server with walkers
jac serve walkers.jac -p 8000
```

Backend will be available at `http://localhost:8000`

### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start React dev server
npm start
```

Frontend will be available at `http://localhost:3000`

**Note**: Update API endpoint in `src/services/api.js` if needed:

```javascript
const API_BASE_URL = "http://localhost:8000";
```

## 📊 Example Workflow

1. **User logs mood**: "I'm feeling anxious about work"
2. **Analyzer Agent**: Extracts emotion=anxious, trigger=work stress, intensity=7
3. **Graph Update**: Creates relationships between anxiety node and work stress node
4. **Companion Agent**: Generates supportive message, suggests breathing exercise and meditation
5. **Trend Analysis**: Identifies pattern of anxiety spike on weekdays
6. **Daily Summary**: Provides emotional check-in with personalized recommendations
7. **Weekly Report**: Shows emotional trends and suggests stress-management activities

## 🧪 Testing & Demo Data

### Sample Test Data

Included in `examples/seed_data.json`:

- Pre-configured emotions (Happy, Sad, Anxious, Stressed, etc.)
- Sample triggers and activities
- Initial suggestions for mood support
- Test mood logs for demonstration

### Testing the API

You can test walkers using PowerShell:

```powershell
# Test log_mood walker
$body = @{user_id='test_user'; mood_name='happy'; intensity=7; journal_text='Feeling great today!'} | ConvertTo-Json
Invoke-RestMethod -Uri 'http://localhost:8000/walker/log_mood' -Method Post -Body $body -ContentType 'application/json'

# Test get_weekly_summary walker
$body = @{user_id='test_user'} | ConvertTo-Json
Invoke-RestMethod -Uri 'http://localhost:8000/walker/get_weekly_summary' -Method Post -Body $body -ContentType 'application/json'
```

## 📹 Demo Features

The application demonstrates:

1. ✅ Mood logging with emoji picker and intensity slider
2. ✅ Real-time byLLM emotional analysis from journal text
3. ✅ Daily summary with emotion-specific triggers and recommendations
4. ✅ byLLM-generated breathing exercises (structured with steps and duration)
5. ✅ Weekly trend visualization with emotion distribution chart
6. ✅ Emotional stability score calculation
7. ✅ Persistent data storage on Jaseci root node
8. ✅ 15 fully functional walkers with OSP graph integration

## 🔧 Configuration

### Backend Configuration

byLLM settings are defined in `backend/agents.jac` using Jaseci's built-in LLM capabilities:

- **Analytical Agent**: Uses `by llm(method="Reason")` for emotion analysis
- **Generative Agents**: Use `by llm(method="Generate")` for support messages, breathing exercises, affirmations
- **Configuration**: LLM provider options in `backend/config.py` (OpenAI, Ollama, Anthropic)

### Frontend API Configuration

API endpoint is set in `frontend/src/services/api.js`:

- **Local Development**:

  ```javascript
  const API_BASE_URL = "http://localhost:8000";
  ```

- **Production (Render)**:
  ```javascript
  const API_BASE_URL = "https://mindmate-backend-9kok.onrender.com";
  ```

### Deployment

- **Backend**: Deployed on Render at https://mindmate-backend-9kok.onrender.com
- **Command**: `jac serve walkers.jac -p ${PORT:-8000}`
- **Health Check**: GET `/walkers` endpoint

## 📚 Documentation

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Detailed technical architecture
- **[AGENT_PROMPTS.md](docs/AGENT_PROMPTS.md)** - LLM prompt engineering
- **[API_ENDPOINTS.md](docs/API_ENDPOINTS.md)** - Complete walker API reference
- **[DEMO_GUIDE.md](docs/DEMO_GUIDE.md)** - Step-by-step demo walkthrough

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Jaseci](https://jaseci.org/) framework (JacLang v0.9.3)
- Powered by Jaseci's byLLM capabilities
- Deployed on [Render](https://render.com/)
- Inspired by mental health and wellness best practices

---

**MindMate Harmony Space** - Compassionate AI, Every Step of Your Wellness Journey 🌟
