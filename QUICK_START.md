# QUICK START GUIDE

## MindMate Harmony Space - Get Up and Running in 5 Minutes

### Prerequisites Check

```bash
python --version          # Should be 3.8+
node --version           # Should be 14+
npm --version            # Should be 6+
```

---

## OPTION 1: Using Ollama (Local LLM - No API Key Needed)

### Step 1: Install Ollama

Download from [https://ollama.ai](https://ollama.ai)

### Step 2: Pull a Model

```bash
ollama pull mistral
ollama serve
# Leave this running in a terminal
```

### Step 3: Backend Setup

```bash
cd backend

# Create .env file
echo LLM_PROVIDER=ollama > .env
echo OLLAMA_ENDPOINT=http://localhost:11434 >> .env
echo OLLAMA_MODEL=mistral >> .env

# Install and initialize
pip install -r requirements.txt
python seed_data.py

# Start Jaseci server (new terminal)
jsctl -m jaseci_serv start
```

### Step 4: Frontend Setup

```bash
cd frontend

# Create .env file
echo REACT_APP_JASECI_API_URL=http://localhost:5000 > .env

# Install and start
npm install
npm start
```

**Done!** Open http://localhost:3000

---

## OPTION 2: Using OpenAI API

### Step 1: Get API Key

1. Go to [https://platform.openai.com/api/keys](https://platform.openai.com/api/keys)
2. Create new secret key
3. Copy it

### Step 2: Backend Setup

```bash
cd backend

# Create .env file with your API key
echo LLM_PROVIDER=openai > .env
echo OPENAI_API_KEY=sk_your_key_here >> .env
echo OPENAI_MODEL=gpt-3.5-turbo >> .env

# Install and initialize
pip install -r requirements.txt
python seed_data.py

# Start Jaseci server
jsctl -m jaseci_serv start
```

### Step 3: Frontend Setup

```bash
cd frontend

# Create .env file
echo REACT_APP_JASECI_API_URL=http://localhost:5000 > .env

# Install and start
npm install
npm start
```

**Done!** Open http://localhost:3000

---

## QUICK TEST

### Test 1: Log a Mood (Browser)

1. Open http://localhost:3000
2. Click "😰 Anxious" emoji
3. Set intensity to 7
4. Type: "I'm stressed about work"
5. Click "Log Mood & Get Support"
6. See AI-generated support message ✅

### Test 2: View Daily Summary

1. Click "🌞 Daily Check-in" tab
2. See current mood and intensity
3. View recommendations and breathing exercises
4. ✅ Everything working!

### Test 3: Check Weekly Trends

1. Click "📊 Weekly Trends" tab
2. See emotion distribution chart
3. View trend analysis and metrics
4. ✅ Complete!

---

## TROUBLESHOOTING

### "Connection refused" on http://localhost:3000

```bash
# Frontend not running. Start it:
cd frontend && npm start
```

### "Error connecting to backend"

```bash
# Backend not running. Start it:
cd backend && jsctl -m jaseci_serv start
```

### "Invalid API key" (OpenAI)

```bash
# Fix .env file in backend/
# Make sure OPENAI_API_KEY=sk_ (starts with sk_)
# Restart backend after changing
```

### "Ollama connection failed"

```bash
# Ollama server not running. Start it:
ollama serve
# Should show: "Listening on 127.0.0.1:11434"
```

### Empty weekly data

```bash
# Need more mood entries. Log several moods first:
# 1. Log "happy" mood
# 2. Log "stressed" mood
# 3. Log "calm" mood
# Then weekly trends will show data
```

---

## PROJECT STRUCTURE

```
MindMate-Harmony-Space/
├── backend/                    # Jaseci & Python
│   ├── mindmate.jac           # OSP graph
│   ├── walkers.jac            # Backend logic
│   ├── agents.jac             # AI agents
│   ├── config.py              # Settings
│   ├── seed_data.py           # Initial data
│   └── requirements.txt        # Dependencies
├── frontend/                   # React app
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── services/          # API calls
│   │   └── App.jsx            # Main app
│   └── package.json           # Dependencies
├── docs/                       # Documentation
│   ├── ARCHITECTURE.md         # System design
│   ├── API_ENDPOINTS.md        # Walker reference
│   ├── AGENT_PROMPTS.md        # LLM prompts
│   └── DEMO_GUIDE.md           # Demo walkthrough
└── examples/                   # Sample data
```

---

## KEY FEATURES

✅ **Mood Logging** - Select emotion, set intensity, write journal entry
✅ **AI Analysis** - LLM extracts emotions, triggers, keywords automatically
✅ **Support Messages** - Personalized empathetic responses from AI
✅ **Breathing Exercises** - Custom breathing techniques for each emotion
✅ **Daily Summary** - Current mood + recommendations
✅ **Weekly Trends** - Emotion patterns, trend analysis, habit suggestions
✅ **OSP Graph** - Relationships between emotions, triggers, activities
✅ **Multi-Agent** - 3 specialized AI agents working together

---

## NEXT STEPS

### Want to customize?

- Edit `backend/seed_data.py` to add more emotions/triggers
- Modify `frontend/src/App.css` to change colors
- Adjust LLM prompts in `backend/agents.jac`

### Want to deploy?

- Follow Docker setup in ARCHITECTURE.md
- Deploy frontend to Vercel/Netlify
- Deploy backend to Heroku/AWS

### Want to extend?

- Add user authentication
- Add notification system
- Connect to more LLM providers
- Build mobile app

---

## DOCUMENTATION

- **Full Architecture**: See `docs/ARCHITECTURE.md`
- **API Reference**: See `docs/API_ENDPOINTS.md`
- **LLM Prompts**: See `docs/AGENT_PROMPTS.md`
- **Demo Guide**: See `docs/DEMO_GUIDE.md`

---

## GET HELP

### Check logs

```bash
# Backend logs show in terminal running Jaseci
# Frontend logs in browser DevTools (F12)
```

### Test connections

```bash
# Test backend
curl http://localhost:5000/health

# Test LLM (Ollama)
curl http://localhost:11434/api/tags
```

### Review configuration

```bash
# Backend config
cat backend/.env

# Frontend config
cat frontend/.env
```

---

**Enjoy building your emotional wellness companion! 🌟**

Questions? Issues? Check the full docs or open a GitHub issue.
