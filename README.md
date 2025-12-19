# MindMate Harmony Space - AI Mental-Wellbeing Companion

A compassionate AI-powered emotional wellness companion designed to help users track moods, understand emotional patterns, and receive personalized AI-generated support using Jaseci's Object-Spatial Graph (OSP), walkers, and byLLM intelligence.

## 🎯 Project Overview

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

### Mood & Logging Walkers

- **`log_mood`** - Records mood entry and updates OSP graph
- **`analyze_journal`** - Sends journaling text to analytical LLM
- **`update_graph`** - Creates relationships between emotions, triggers, activities

### Summary & Recommendation Walkers

- **`get_daily_summary`** - Returns current emotional state + AI suggestions
- **`get_weekly_summary`** - Graph-based emotional trend report
- **`recommend_activities`** - Uses mood→activity edges for coping habit suggestions

### LLM Integration Walkers

- **`emotion_from_text`** - Analytical LLM: extracts emotion data from text
- **`generate_support_message`** - Generative LLM: creates empathetic responses
- **`generate_breathing_exercise`** - Generative LLM: creates personalized breathing guides

### Graph Analysis Walkers

- **`find_repeating_triggers`** - Identifies most common emotional triggers
- **`find_common_emotions`** - Detects prevalent mood patterns
- **`calculate_emotional_trends`** - Computes emotional trajectory over time

## 🛠️ Tech Stack

### Backend

- **Jaseci + Jac** - OSP graph and walker definitions (mindmate.jac, walkers.jac, agents.jac)
- **Python + Flask** - HTTP server (`backend/jaseci_server.py`) exposing `/api/walker` and `/health`
- **Mock Graph/LLM Mode** - Safe in-memory graph + rule-based responses when no external LLM is configured
- **Google Gemini** - Primary generative provider for support messages via `GOOGLE_API_KEY` (when set)
- **OpenAI / Ollama / Anthropic** - Additional providers defined in `backend/config.py` (not required for this demo)

### Frontend

- **React** - UI library
- **jac-client** - Official Jaseci client library for Spawn() walker calls
- **Axios** - Fallback HTTP client for non-walker endpoints
- **Recharts** - Emotional trend visualization
- **Tailwind CSS** - Styling

### Database / Storage

- **In-memory log + simple persistence** for demo (`MOOD_LOG`, seed data)
- **Jaseci Graph Store** prepared via Jac files for future full graph persistence

## 📋 Project Structure

```
MindMate-Harmony-Space/
├── backend/
│   ├── mindmate.jac              # Main OSP graph & node definitions
│   ├── walkers.jac               # Core Jac walkers (graph + analysis)
│   ├── agents.jac                # AI agents (byLLM prompts and logic)
│   ├── jaseci_server.py          # Flask server exposing Jac-like walkers over HTTP
│   ├── seed_data.py              # Initial emotions, triggers, activities, suggestions
│   ├── config.py                 # Configuration (LLM providers, DB, server)
│   └── requirements.txt          # Python dependencies
├── frontend/
│   ├── public/
│   │   ├── index.html
│   │   └── favicon.ico
│   ├── src/
│   │   ├── components/
│   │   │   ├── MoodLogger.jsx
│   │   │   ├── JournalEntry.jsx
│   │   │   ├── DailySummary.jsx
│   │   │   ├── WeeklyTrends.jsx
│   │   │   ├── RecommendationCard.jsx
│   │   │   └── BreathingExercise.jsx
│   │   ├── pages/
│   │   │   ├── Home.jsx
│   │   │   ├── Dashboard.jsx
│   │   │   └── Analytics.jsx
│   │   ├── services/
│   │   │   └── api.js           # Jaseci Spawn() API calls
│   │   ├── App.jsx
│   │   ├── index.js
│   │   └── App.css
│   ├── package.json
│   └── .env.example
├── docs/
│   ├── ARCHITECTURE.md           # Detailed architecture
│   ├── AGENT_PROMPTS.md          # LLM prompt templates
│   ├── API_ENDPOINTS.md          # Walker API reference
│   └── DEMO_GUIDE.md             # How to run the demo
├── examples/
│   ├── sample_moods.json
│   ├── sample_journals.json
│   └── postman_collection.json
├── .github/
│   └── copilot-instructions.md
├── README.md
├── LICENSE
└── .gitignore
```

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- Node.js 14+
- pip & npm
- Jaseci CLI (`pip install jaseci`)

### Backend Setup (Local)

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# (Optional) Set GOOGLE_API_KEY if you want real Gemini-powered support messages
set GOOGLE_API_KEY=your_real_key_here        # Windows PowerShell: $env:GOOGLE_API_KEY="..."

# Start Flask backend (Jaseci mock mode + Gemini integration)
python jaseci_server.py
```

### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start React dev server
npm start
```

The frontend will be available at `http://localhost:3000`

## 📊 Example Workflow

1. **User logs mood**: "I'm feeling anxious about work"
2. **Analyzer Agent**: Extracts emotion=anxious, trigger=work stress, intensity=7
3. **Graph Update**: Creates relationships between anxiety node and work stress node
4. **Companion Agent**: Generates supportive message, suggests breathing exercise and meditation
5. **Trend Analysis**: Identifies pattern of anxiety spike on weekdays
6. **Daily Summary**: Provides emotional check-in with personalized recommendations
7. **Weekly Report**: Shows emotional trends and suggests stress-management activities

## 🧪 Testing & Evaluation

### Evaluation Metrics

- **Emotion Classification Accuracy**: LLM self-evaluation comparing extracted emotions to provided mood
- **Suggestion Relevance**: User feedback ratings on helpfulness of AI-generated coping strategies
- **Graph Pattern Detection**: Validation of identified triggers against user's actual stress patterns
- **User Satisfaction**: NPS-style scoring of emotional support quality

### Sample Test Data

Included in `examples/sample_moods.json` and `examples/sample_journals.json`:

- 15 pre-written mood entries
- 10 sample journal entries with varying emotional tones
- Expected emotion classifications and triggers

## 📹 Demo Video

The demo showcases:

1. ✅ Logging a mood with emoji picker and journal text
2. ✅ Real-time byLLM emotional analysis
3. ✅ Graph updates showing emotion-trigger-activity relationships
4. ✅ byLLM-generated coping strategies and breathing exercises
5. ✅ Daily emotional summary with personalized recommendations
6. ✅ Weekly trend report with pattern detection
7. ✅ Interactive frontend using Spawn() for walker calls

**[Demo Video Link - To be added after recording]**

## 🔧 Configuration

### Backend LLM Configuration

Most of the byLLM configuration lives in `backend/agents.jac` and `backend/config.py`. For this deployed demo:

- **Gemini Support Messages**

  - Env var: `GOOGLE_API_KEY`
  - Used by: `handle_generate_support_message` in `backend/jaseci_server.py`
  - Behavior: When `GOOGLE_API_KEY` is present, support messages are generated by Gemini (`gemini-1.5-flash`); otherwise, fallback rule-based messages are used.

- **Other Providers (optional)**
  - `LLM_PROVIDER` / `OPENAI_API_KEY` / `OLLAMA_ENDPOINT` / `ANTHROPIC_API_KEY` are defined in `backend/config.py` but are not required for this Render demo.

### Frontend API Base URL

The frontend talks to the backend via `REACT_APP_JASECI_API_URL`:

- Local dev:

  ```env
  REACT_APP_JASECI_API_URL=http://localhost:5000
  ```

- Render deployment (current):

  ```env
  REACT_APP_JASECI_API_URL=https://mindmate-backend-9kok.onrender.com
  ```

This is wired in `frontend/src/services/api.js` via:

```javascript
const API_BASE_URL =
  process.env.REACT_APP_JASECI_API_URL || "http://localhost:5000";
```

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

- Built with [Jaseci](https://jaseci.org/) framework
- Powered by OpenAI's GPT models (or Ollama)
- Inspired by mental health and wellness best practices

---

**MindMate Harmony Space** - Compassionate AI, Every Step of Your Wellness Journey 🌟
