"""
MindMate Harmony Space - Backend Configuration
Environment and LLM settings
"""

import os
from dotenv import load_dotenv

load_dotenv()

# ============================================================================
# LLM CONFIGURATION
# ============================================================================

# LLM Provider options: "openai", "ollama", "anthropic"
LLM_PROVIDER = os.getenv("LLM_PROVIDER", "openai")

# OpenAI Configuration
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")
OPENAI_ENDPOINT = "https://api.openai.com/v1/chat/completions"

# Ollama Configuration (for local LLM)
OLLAMA_ENDPOINT = os.getenv("OLLAMA_ENDPOINT", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "mistral")

# Anthropic Configuration
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY", "")
ANTHROPIC_MODEL = os.getenv("ANTHROPIC_MODEL", "claude-3-sonnet-20240229")

# ============================================================================
# DATABASE CONFIGURATION
# ============================================================================

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///mindmate.db")
DATABASE_ECHO = os.getenv("DATABASE_ECHO", "False").lower() == "true"

# ============================================================================
# JASECI SERVER CONFIGURATION
# ============================================================================

JASECI_HOST = os.getenv("JASECI_HOST", "localhost")
JASECI_PORT = int(os.getenv("JASECI_PORT", "5000"))
JASECI_DEBUG = os.getenv("JASECI_DEBUG", "False").lower() == "true"

# ============================================================================
# FRONTEND CONFIGURATION
# ============================================================================

FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:3000")
CORS_ORIGINS = [FRONTEND_URL]

# ============================================================================
# APPLICATION SETTINGS
# ============================================================================

APP_NAME = "MindMate Harmony Space"
APP_VERSION = "1.0.0"
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

# Emotion configuration
EMOTION_INTENSITY_MIN = 1
EMOTION_INTENSITY_MAX = 10

# Journal analysis
MIN_JOURNAL_LENGTH = 10  # Minimum characters for analysis
MAX_JOURNAL_LENGTH = 5000  # Maximum characters for analysis

# Weekly summary configuration
DAYS_IN_WEEK = 7
SUMMARY_GENERATION_TIME = "08:00"  # Generate at 8 AM daily

# Recommendation system
MAX_RECOMMENDATIONS = 5
MIN_RECOMMENDATION_RELEVANCE = 0.7

# ============================================================================
# LLM PROMPT CONFIGURATION
# ============================================================================

# Temperature for analytical tasks (lower = more consistent)
ANALYTICAL_TEMPERATURE = 0.5

# Temperature for generative tasks (higher = more creative)
GENERATIVE_TEMPERATURE = 0.8

# Max tokens for different task types
MAX_TOKENS_ANALYSIS = 500
MAX_TOKENS_SUPPORT_MESSAGE = 800
MAX_TOKENS_BREATHING_EXERCISE = 600
MAX_TOKENS_AFFIRMATION = 300
MAX_TOKENS_WEEKLY_REFLECTION = 1000
MAX_TOKENS_HABIT_SUGGESTIONS = 1200

# ============================================================================
# NOTIFICATION SETTINGS
# ============================================================================

ENABLE_NOTIFICATIONS = os.getenv("ENABLE_NOTIFICATIONS", "True").lower() == "true"
NOTIFICATION_FREQUENCY = os.getenv("NOTIFICATION_FREQUENCY", "daily")  # daily, weekly, custom
NOTIFICATION_TIME = os.getenv("NOTIFICATION_TIME", "09:00")

# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================

SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION_HOURS = 24

# ============================================================================
# FEATURE FLAGS
# ============================================================================

ENABLE_GRAPH_VISUALIZATION = os.getenv("ENABLE_GRAPH_VISUALIZATION", "True").lower() == "true"
ENABLE_TREND_ANALYSIS = os.getenv("ENABLE_TREND_ANALYSIS", "True").lower() == "true"
ENABLE_HABIT_SUGGESTIONS = os.getenv("ENABLE_HABIT_SUGGESTIONS", "True").lower() == "true"
ENABLE_BREATHING_EXERCISES = os.getenv("ENABLE_BREATHING_EXERCISES", "True").lower() == "true"
ENABLE_WEEKLY_SUMMARIES = os.getenv("ENABLE_WEEKLY_SUMMARIES", "True").lower() == "true"

print(f"""
{'='*60}
MindMate Harmony Space - Configuration Loaded
{'='*60}
LLM Provider: {LLM_PROVIDER}
Database: {DATABASE_URL}
Jaseci Server: {JASECI_HOST}:{JASECI_PORT}
Frontend URL: {FRONTEND_URL}
{'='*60}
""")
