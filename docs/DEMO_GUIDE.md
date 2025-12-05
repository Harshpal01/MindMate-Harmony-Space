# DEMO GUIDE

## MindMate Harmony Space - Full Demo Walkthrough

This guide shows how to run a complete demo of the system covering all core features.

---

## Prerequisites

- Python 3.8+
- Node.js 14+
- Git
- Postman (optional, for API testing)

---

## PART 1: BACKEND SETUP

### Step 1: Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Configure Environment

Create a `.env` file in the `backend` folder:

```env
# LLM Configuration (choose one provider)
LLM_PROVIDER=openai
OPENAI_API_KEY=sk-your-key-here
OPENAI_MODEL=gpt-3.5-turbo

# Or use Ollama (local)
# LLM_PROVIDER=ollama
# OLLAMA_ENDPOINT=http://localhost:11434

# Database
DATABASE_URL=sqlite:///mindmate.db

# Jaseci
JASECI_HOST=localhost
JASECI_PORT=5000

# Frontend
FRONTEND_URL=http://localhost:3000
```

### Step 3: Initialize Database & Load Seed Data

```bash
python seed_data.py
```

This will create:

- Preloaded emotions (10 emotions with emojis)
- Preloaded triggers (10 common triggers)
- Preloaded activities (10 coping activities)
- Preloaded suggestions (8 breathing exercises, affirmations, tips)
- Sample journal entries for testing

### Step 4: Start Jaseci Server

```bash
jsctl -m jaseci_serv start
```

Server starts at: `http://localhost:5000`

---

## PART 2: FRONTEND SETUP

### Step 1: Install Dependencies

```bash
cd frontend
npm install
```

### Step 2: Configure Environment

Create a `.env` file in the `frontend` folder:

```env
REACT_APP_JASECI_API_URL=http://localhost:5000
REACT_APP_JASECI_WALKER_PATH=/api/walker
REACT_APP_BACKEND_URL=http://localhost:5000
```

### Step 3: Start Development Server

```bash
npm start
```

Frontend opens at: `http://localhost:3000`

---

## PART 3: DEMO SCENARIOS

### Scenario 1: Log a Mood Entry

**Objective:** Demonstrate mood logging, LLM analysis, and support message generation

**Steps:**

1. Open http://localhost:3000
2. You're on the "📝 Log Mood" tab
3. Click on the **"😰 Anxious"** mood emoji
4. Move the intensity slider to **7** (quite intense)
5. In the journal text box, enter:
   ```
   Had a really tough day at work. My boss gave me critical feedback
   on my project and now I'm doubting myself. I didn't sleep well
   last night either, which is making everything feel worse.
   I'm struggling to see the positive side of things right now.
   ```
6. Click **"Log Mood & Get Support"**

**What happens:**

- ✅ Frontend logs mood via `log_mood` walker
- ✅ Analytical LLM analyzes journal text via `emotion_from_text` walker
  - Extracts: anxious, stressed
  - Identifies triggers: work feedback, poor sleep
  - Calculates intensity: 7.8/10
- ✅ Graph updated with emotion → trigger relationships
- ✅ Generative LLM creates empathetic support message via `generate_support_message`
- ✅ Success screen displays support message

**Expected Output:**

```
✨ Thank you for sharing! ✨

Your mood has been logged. Here's some support for you:

"I can hear the frustration and self-doubt in your words, and I want
you to know that what you're feeling is completely valid. Critical
feedback can feel overwhelming, especially when combined with poor sleep.

What's important to remember is that one piece of feedback doesn't define
your abilities or your worth as a professional. Here are some things that
might help:

1. Try a 5-minute breathing exercise to calm your nervous system
2. Get some natural light and movement - even a 10-minute walk
3. Journal about what went well in the project, not just the criticism
4. Prioritize sleep tonight - it will help you process emotions better
5. Remember one time you received feedback and bounced back stronger

You're capable of learning and growing from this. Be kind to yourself."
```

---

### Scenario 2: View Daily Check-in & Recommendations

**Objective:** Show current mood, related triggers, and AI-generated recommendations

**Steps:**

1. From the success screen, wait for redirect OR click **"🌞 Daily Check-in"** tab
2. Component loads and fetches data
3. Review sections:
   - **Current Mood**: Shows "anxious" with intensity bar
   - **Summary Tab**: Lists triggers (work feedback, poor sleep)
   - **Recommendations Tab**: Shows 3-5 suggested activities
   - **Breathing Tab**: Displays breathing exercise

**What happens:**

- ✅ `get_daily_summary` walker queries latest mood
- ✅ Graph traversal finds related triggers and activities
- ✅ `generate_breathing_exercise` creates personalized exercise
- ✅ Frontend displays interactive tabs

**Demo Interaction:**

- Click "Recommendations" tab → See exercise, meditation, nature walk
- Click "Breathing" tab → See "Extended Exhale Breathing" instructions

  ```
  Extended Exhale Breathing

  1. Sit or lie down in a comfortable position
  2. Breathe in through your nose for a count of 4
  3. Hold your breath for a count of 4
  4. Exhale through your mouth for a count of 8
  5. Repeat for 10 cycles (about 4 minutes total)

  This technique activates your parasympathetic nervous system,
  helping calm anxiety naturally.
  ```

---

### Scenario 3: View Weekly Trends & Analytics

**Objective:** Show emotional patterns, trend analysis, and habit recommendations

**Steps:**

1. Click **"📊 Weekly Trends"** tab
2. Component loads trend data in parallel:
   - Emotion distribution chart
   - Trend metrics (direction, stability, volatility)
   - Weekly summary with key insights
   - Habit recommendations

**What happens:**

- ✅ `get_weekly_summary` returns emotion frequencies and analysis
- ✅ `findCommonEmotions` provides distribution data
- ✅ `calculateEmotionalTrends` computes trend metrics
- ✅ Recharts renders bar chart visualization

**Demo Data (Sample from seed):**

```
Emotion Distribution (Last 7 Days):
- Calm: 2 times
- Anxious: 2 times
- Stressed: 1 time
- Happy: 1 time

Trend Metrics:
- Direction: Stable
- Stability Score: 75%
- Volatility: 2.1

Key Insights:
"Your emotional state this week has been relatively balanced,
though anxiety has appeared twice. There's a clear pattern of
anxiety emerging on work days. Consider implementing a weekend
self-care routine to build resilience."

Recommended Actions:
- Start a morning meditation routine (5-10 minutes daily)
- Take 3 exercise sessions this week, especially before stressful days
- Try the journaling exercise to process work-related stress
- Prioritize 8 hours of sleep on work nights
```

---

## PART 4: API TESTING (Optional - Postman)

### Test 1: Log Multiple Moods

Create Postman requests for different moods to build historical data:

**Request 1: Happy**

```json
{
  "walker": "log_mood",
  "ctx": {
    "user_id": "user_001",
    "mood_name": "happy",
    "intensity": 8,
    "journal_text": "Great day today! Finished my project and got positive feedback. Feeling accomplished!"
  }
}
```

**Request 2: Peaceful**

```json
{
  "walker": "log_mood",
  "ctx": {
    "user_id": "user_001",
    "mood_name": "peaceful",
    "intensity": 8,
    "journal_text": "Had a wonderful morning meditation and yoga session. Feeling centered and grounded."
  }
}
```

**Request 3: Stressed**

```json
{
  "walker": "log_mood",
  "ctx": {
    "user_id": "user_001",
    "mood_name": "stressed",
    "intensity": 6,
    "journal_text": "Too many things to do, not enough time. Feeling the pressure mount."
  }
}
```

### Test 2: Get Recommendations

```
POST http://localhost:5000/api/walker

{
  "walker": "recommend_activities",
  "ctx": {
    "emotion_name": "anxious",
    "intensity": 7.5
  }
}
```

### Test 3: Generate Breathing Exercise

```
POST http://localhost:5000/api/walker

{
  "walker": "generate_breathing_exercise",
  "ctx": {
    "emotion_name": "anxious",
    "intensity_score": 8,
    "duration_preference": 300
  }
}
```

### Test 4: Get Weekly Summary

```
POST http://localhost:5000/api/walker

{
  "walker": "get_weekly_summary",
  "ctx": {
    "user_id": "user_001"
  }
}
```

---

## PART 5: KEY FEATURES TO HIGHLIGHT IN DEMO VIDEO

### Feature 1: Mood Logging (20 seconds)

- Show mood emoji picker
- Adjust intensity slider
- Type journal entry
- Submit and see LLM analysis

### Feature 2: LLM Analysis (30 seconds)

- Show analytical LLM extracting emotions and triggers
- Display support message generation
- Emphasize personalized, empathetic responses

### Feature 3: Graph Relationships (15 seconds)

- Explain how emotion → trigger → activity → suggestion edges work
- Show relationship strengths in the data

### Feature 4: Daily Summary (20 seconds)

- Show current mood status
- Display related triggers
- Show recommended activities
- Play breathing exercise

### Feature 5: Weekly Trends (25 seconds)

- Show emotion distribution chart
- Explain trend analysis (improving/declining/stable)
- Display pattern detection insights
- Show habit recommendations

### Feature 6: Multi-Agent System (20 seconds)

- Agent 1: Analytical (emotion extraction)
- Agent 2: Supportive (empathetic responses)
- Agent 3: Planner (trend detection)

### Feature 7: OSP Graph (20 seconds)

- Show node types in the database
- Explain traversal for recommendations
- Demonstrate pattern discovery

---

## DEMO SCRIPT

### Opening (30 seconds)

```
"Welcome to MindMate Harmony Space - an AI-powered emotional wellness
companion. This system uses Jaseci's Object-Spatial Graph, three specialized
AI agents, and advanced NLP to help users track their emotions and receive
personalized support.

Today, I'll show you how a user can log their mood, receive AI-generated
support, and discover emotional patterns over time."
```

### Main Demo (3-4 minutes)

1. **Log a challenging emotion** (1 min)

   - Select anxious mood
   - Enter journal entry about work stress
   - Show real-time LLM analysis

2. **Get support and recommendations** (1 min)

   - Display empathetic support message
   - Show breathing exercises
   - Display activity recommendations

3. **View trends and insights** (1 min)

   - Show weekly emotional distribution
   - Display trend analysis
   - Show habit recommendations based on patterns

4. **Explain the architecture** (30 sec)
   - Three AI agents working together
   - OSP graph relationships
   - Real-time pattern detection

### Closing (30 seconds)

```
"MindMate Harmony Space combines the power of Jaseci's graph technology
with AI intelligence to create a compassionate wellness companion. It's
simple to build but powerful in its ability to support emotional wellbeing.
All required hackathon elements are present: OSP graph, multi-agent system,
walkers for backend logic, byLLM integration, and a full React frontend
using Spawn()."
```

---

## DEMO TIPS & TROUBLESHOOTING

### Tip 1: Pre-populate Data

Run multiple mood logs before demo to have meaningful weekly trends data.

### Tip 2: Use Ollama for Local LLM (No API Key Needed)

```bash
# Install Ollama: https://ollama.ai
# Pull a model: ollama pull mistral
# Start: ollama serve
# Set in backend/.env: LLM_PROVIDER=ollama
```

### Tip 3: Record Demo with Screen Capture

- Use OBS Studio (free) or ScreenFlow (Mac)
- Record at 1080p, 30fps
- Include audio narration
- Total video length: 5-7 minutes

### Tip 4: Common Issues

**Issue: API Connection Failed**

```bash
# Check backend is running
curl http://localhost:5000/health

# Check frontend .env has correct URL
cat frontend/.env
```

**Issue: LLM Timeout**

```bash
# Check API key is valid
# Increase timeout in config.py: LLM_TIMEOUT = 30

# Or use Ollama (local, no timeout issues)
```

**Issue: Empty Weekly Summary**

```bash
# Need multiple mood entries. Log several moods first:
# Log happy, anxious, stressed, peaceful, calm entries
# Then weekly summary will have data
```

---

## CHECKLIST FOR DEMO VIDEO

- [ ] Backend running and healthy
- [ ] Frontend loading without errors
- [ ] LLM API key is valid (or Ollama running)
- [ ] Seed data loaded (emotions, triggers, activities)
- [ ] Multiple mood entries logged (for trends)
- [ ] Microphone is working for narration
- [ ] Screen resolution set to 1080p
- [ ] Recording software configured
- [ ] Backup recording prepared
- [ ] Video uploaded to YouTube/Vimeo with timestamp links

---

## TIMESTAMPS FOR VIDEO LINKS

```
0:00 - Introduction to MindMate Harmony Space
0:30 - Logging a mood entry with journaling
1:30 - Real-time LLM analysis and support message
2:30 - Daily recommendations and breathing exercise
3:30 - Weekly trends visualization
4:30 - Architecture explanation (OSP, agents, walkers)
5:30 - Technical highlights and future roadmap
6:00 - Closing remarks
```

---

## NEXT STEPS AFTER DEMO

1. **Polish the frontend**: Add animations, improve UX
2. **Add authentication**: User accounts and profiles
3. **Implement notifications**: Daily wellness reminders
4. **Add more LLM features**: Journal summarization, goal setting
5. **Deploy to production**: Docker, Kubernetes, cloud hosting
6. **Gather user feedback**: Iterate based on real usage patterns
