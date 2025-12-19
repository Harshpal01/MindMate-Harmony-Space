"""
MindMate Harmony Space - Core Walkers
Implements mood logging, analysis, summaries, and pattern detection with data persistence
"""

# Node to store mood data persistently on the root node
node MoodStorage {
    has mood_logs: list = [];
    has user_moods: dict = {};
}

walker log_mood {
    has user_id: str;
    has mood_name: str;
    has intensity: float;
    has journal_text: str = "";

    can log with entry {
        # Get or create storage node
        storage_node = here;
        if not hasattr(storage_node, 'mood_logs') {
            storage_node.mood_logs = [];
            storage_node.user_moods = {};
        }

        # Create mood entry with proper ISO timestamp
        entry_data = {
            "user_id": self.user_id,
            "mood_name": self.mood_name,
            "intensity": self.intensity,
            "journal_text": self.journal_text,
            "timestamp": str(__import__('datetime').datetime.now().isoformat())
        };

        # Store in node's mood logs
        storage_node.mood_logs.append(entry_data);

        # Track user's moods
        if self.user_id not in storage_node.user_moods {
            storage_node.user_moods[self.user_id] = [];
        }
        storage_node.user_moods[self.user_id].append(entry_data);

        report {
            "status": "success",
            "message": f"Logged {self.mood_name} mood at intensity {self.intensity}",
            "data": entry_data,
            "total_entries": len(storage_node.mood_logs)
        } ;
    }
}

walker analyze_journal {
    has journal_text: str;
    has user_id: str;

    can analyze with entry {
        # Simple keyword-based emotion detection
        emotions = [];
        intensity = 5.0;

        if "happy" in self.journal_text.lower() or "great" in self.journal_text.lower() {
            emotions.append("happy");
            intensity = 7.5;
        }
        if "sad" in self.journal_text.lower() or "down" in self.journal_text.lower() {
            emotions.append("sad");
            intensity = 3.5;
        }
        if "stress" in self.journal_text.lower()
        or "anxious" in self.journal_text.lower() {
            emotions.append("stressed");
            intensity = 4.0;
        }

        report {
            "detected_emotions": emotions if emotions else ["neutral"],
            "intensity": intensity,
            "journal_length": len(self.journal_text)
        } ;
    }
}

walker get_daily_summary {
    has user_id: str;

    can summarize with entry {
        # Get storage from root node
        storage_node = here;
        if not hasattr(storage_node, 'user_moods') {
            storage_node.user_moods = {};
        }

        user_entries = storage_node.user_moods.get(self.user_id, []);

        if not user_entries {
            report {
                "status": "no_data",
                "message": "No mood entries found for this user",
                "current_mood": "Not Yet Logged",
                "total_entries": 0,
                "triggers": []
            } ;
        } else {
            latest = user_entries[-1];
            # Analyze triggers from journal entries
            triggers = [];
            # Check recent entries for trigger patterns
            recent_text = "";
            for entry in user_entries[-5:] {
                journal = entry.get("journal_text", "");
                if journal {
                    recent_text = recent_text + " " + journal.lower();
                }
            }
            # Detect trigger categories
            if "work" in recent_text
            or "job" in recent_text
            or "boss" in recent_text
            or "deadline" in recent_text {
                triggers.append("work stress");
            }
            if "friend" in recent_text
            or "family" in recent_text
            or "relationship" in recent_text
            or "argument" in recent_text {
                triggers.append("relationship issues");
            }
            if "sleep" in recent_text
            or "tired" in recent_text
            or "exhausted" in recent_text {
                triggers.append("lack of sleep");
            }
            if "money" in recent_text
            or "financial" in recent_text
            or "bills" in recent_text {
                triggers.append("financial stress");
            }
            if "sick" in recent_text
            or "pain" in recent_text
            or "health" in recent_text {
                triggers.append("health concerns");
            }
            # Infer triggers based on CURRENT emotion context (emotion-specific)
            if len(user_entries) >= 3 {
                current_emotion = latest["mood_name"].lower();
                # Only assign triggers relevant to the current emotion
                if current_emotion == "stressed" {
                    # Count recent stress patterns
                    stressed_count = 0;
                    for entry in user_entries[-5:] {
                        if entry["mood_name"].lower() == "stressed" {
                            stressed_count += 1;
                        }
                    }
                    if stressed_count >= 2
                    and "work or daily pressures" not in triggers {
                        triggers.append("work or daily pressures");
                    }
                    if stressed_count >= 1 and "time management" not in triggers {
                        triggers.append("time management");
                    }
                } elif current_emotion == "anxious" {
                    # Anxiety-specific triggers
                    anxious_count = 0;
                    for entry in user_entries[-5:] {
                        if entry["mood_name"].lower() == "anxious" {
                            anxious_count += 1;
                        }
                    }
                    if anxious_count >= 2
                    and "uncertainty or future worries" not in triggers {
                        triggers.append("uncertainty or future worries");
                    }
                    if anxious_count >= 1 and "stress or pressure" not in triggers {
                        triggers.append("stress or pressure");
                    }
                } elif current_emotion == "sad" {
                    # Sadness-specific triggers
                    sad_count = 0;
                    for entry in user_entries[-5:] {
                        if entry["mood_name"].lower() == "sad" {
                            sad_count += 1;
                        }
                    }
                    if sad_count >= 1 and "low energy or motivation" not in triggers {
                        triggers.append("low energy or motivation");
                    }
                    if sad_count >= 2 and "persistent low mood" not in triggers {
                        triggers.append("persistent low mood");
                    }
                } elif current_emotion == "lonely" {
                    # Loneliness-specific triggers
                    lonely_count = 0;
                    for entry in user_entries[-5:] {
                        if entry["mood_name"].lower() == "lonely" {
                            lonely_count += 1;
                        }
                    }
                    if lonely_count >= 1
                    and "lack of social connection" not in triggers {
                        triggers.append("lack of social connection");
                    }
                    if lonely_count >= 2 and "isolation patterns" not in triggers {
                        triggers.append("isolation patterns");
                    }
                } elif current_emotion == "overwhelmed" {
                    # Overwhelm-specific triggers
                    overwhelmed_count = 0;
                    for entry in user_entries[-5:] {
                        if entry["mood_name"].lower() == "overwhelmed" {
                            overwhelmed_count += 1;
                        }
                    }
                    if overwhelmed_count >= 1
                    and "too many responsibilities" not in triggers {
                        triggers.append("too many responsibilities");
                    }
                    if overwhelmed_count >= 2
                    and "difficulty prioritizing" not in triggers {
                        triggers.append("difficulty prioritizing");
                    }
                } elif current_emotion == "angry" {
                    # Anger-specific triggers
                    if "frustration or conflict" not in triggers {
                        triggers.append("frustration or conflict");
                    }
                }
                # Positive emotions (happy, content, peaceful, excited, calm) show no negative triggers
            }
            report {
                "status": "success",
                "current_mood": latest["mood_name"],
                "intensity": latest["intensity"],
                "journal_text": latest.get("journal_text", ""),
                "timestamp": latest["timestamp"],
                "total_entries": len(user_entries),
                "triggers": triggers
            } ;
        }
    }
}

walker get_weekly_summary {
    has user_id: str;
    has num_days: int = 7;

    can summarize with entry {
        # Get storage from root node
        storage_node = here;
        if not hasattr(storage_node, 'user_moods') {
            storage_node.user_moods = {};
        }

        user_entries = storage_node.user_moods.get(self.user_id, []);

        if not user_entries {
            report {
                "status": "no_data",
                "total_entries": 0,
                "weekly_moods": [],
                "emotion_distribution": {}
            } ;
        } else {
            # Count emotion frequencies
            emotion_counts = {};
            for entry in user_entries {
                mood = entry["mood_name"];
                emotion_counts[mood] = emotion_counts.get(mood, 0) + 1;
            }
            report {
                "status": "success",
                "total_entries": len(user_entries),
                "weekly_moods": user_entries,
                "emotion_distribution": emotion_counts,
                "dominant_emotions": emotion_counts
            } ;
        }
    }
}

walker recommend_activities {
    has emotion_name: str;
    has intensity: float;

    can recommend with entry {
        activities = {
            "sad": [
                "Take a walk in nature",
                "Listen to uplifting music",
                "Call a friend or family member"
            ],
            "stressed": [
                "Deep breathing exercises",
                "Meditation or mindfulness",
                "Light exercise or stretching"
            ],
            "anxious": [
                "Progressive muscle relaxation",
                "Journaling your thoughts",
                "Nature walk or time outdoors"
            ],
            "happy": [
                "Share your joy with others",
                "Creative activity or hobby",
                "Help someone in need"
            ],
            "angry": [
                "Physical exercise",
                "Cool down time alone",
                "Express feelings in a healthy way"
            ],
            "overwhelmed": [
                "Break tasks into smaller steps",
                "Take a short break",
                "Prioritize what's most important"
            ],
            "lonely": [
                "Reach out to a friend",
                "Join a community activity",
                "Video call a loved one"
            ],
            "excited": [
                "Channel energy into creative work",
                "Share your excitement",
                "Plan something fun"
            ],
            "calm": [
                "Enjoy the moment",
                "Practice gratitude",
                "Gentle yoga or stretching"
            ],
            "content": [
                "Reflect on positive aspects",
                "Continue healthy routines",
                "Express gratitude"
            ],
            "peaceful": [
                "Meditation or quiet reflection",
                "Read something inspiring",
                "Spend time in nature"
            ]
        };

        suggestions = activities.get(
            self.emotion_name.lower(),
            [
                "Rest and self-care",
                "Talk to someone you trust",
                "Do something that brings you comfort"
            ]
        );

        report {
            "emotion": self.emotion_name,
            "intensity": self.intensity,
            "recommended_activities": suggestions
        } ;
    }
}

walker find_repeating_triggers {
    has user_id: str;
    has lookback_days: int = 30;

    can find_triggers with entry {
        report {
            "user_id": self.user_id,
            "triggers": ["work stress", "social situations", "lack of sleep"],
            "frequency": {"work stress": 5, "social situations": 3, "lack of sleep": 4}
        } ;
    }
}

walker calculate_emotional_trends {
    has user_id: str;
    has lookback_days: int = 14;

    can calculate with entry {
        # Get storage from root node
        storage_node = here;
        if not hasattr(storage_node, 'user_moods') {
            storage_node.user_moods = {};
        }

        user_entries = storage_node.user_moods.get(self.user_id, []);

        if len(user_entries) < 3 {
            report {
                "trend": "stable",
                "stability_score": 0.8,
                "volatility": "low",
                "explanation": "Need more data to determine trends"
            } ;
        } else {
            # Classify emotions as positive/negative
            # Classify emotions as positive/negative
            positive_emotions = {"happy","calm","content","peaceful","excited","grateful","confident"};
            negative_emotions = {"sad","anxious","stressed","overwhelmed","angry","frustrated","lonely"};
            positive_count = 0;
            negative_count = 0;
            intensities = [];
            for entry in user_entries {
                mood = entry["mood_name"].lower();
                intensities.append(entry["intensity"]);
                if mood in positive_emotions {
                    positive_count += 1;
                } elif mood in negative_emotions {
                    negative_count += 1;
                }
            }
            # Calculate trend
            # Calculate trend
            total = positive_count + negative_count;
            if total > 0 {
                positive_ratio = positive_count / total;
                if positive_ratio >= 0.6 {
                    trend = "improving";
                } elif positive_ratio <= 0.4 {
                    trend = "declining";
                } else {
                    trend = "stable";
                }
            } else {
                trend = "stable";
            }
            # Calculate stability score based on intensity variance
            # Calculate stability score based on intensity variance
            avg_intensity = sum(intensities) / len(intensities);
            variance = sum([(x - avg_intensity) ** 2 for x in intensities]) / len(
                intensities
            );
            std_dev = variance ** 0.5;
            # Normalize: lower std_dev = higher stability (scale 0-1)
            # Normalize: lower std_dev = higher stability (scale 0-1)
            # Max expected std_dev around 3-4 for 1-10 scale
            # Max expected std_dev around 3-4 for 1-10 scale
            stability_score = max(0.0, min(1.0, 1.0 - (std_dev / 4.0)));
            # Determine volatility category
            # Determine volatility category
            if std_dev < 1.5 {
                volatility = "low";
            } elif std_dev < 2.5 {
                volatility = "medium";
            } else {
                volatility = "high";
            }
            report {
                "trend": trend,
                "stability_score": stability_score,
                "volatility": volatility,
                "positive_count": positive_count,
                "negative_count": negative_count,
                "explanation": f"Based on {len(user_entries)} entries: {positive_count} positive, {negative_count} negative"
            } ;
        }
    }
}

walker find_common_emotions {
    has user_id: str;
    has lookback_days: int = 7;

    can find_common with entry {
        # Get storage from root node
        # Get storage from root node
        storage_node = here;
        if not hasattr(storage_node, 'user_moods') {
            storage_node.user_moods = {};
        }

        user_entries = storage_node.user_moods.get(self.user_id, []);

        if not user_entries {
            report {"common_emotions": [], "period_days": self.lookback_days} ;
        } else {
            # Count emotion frequencies
            # Count emotion frequencies
            emotion_counts = {};
            for entry in user_entries {
                mood = entry["mood_name"];
                emotion_counts[mood] = emotion_counts.get(mood, 0) + 1;
            }
            # Convert to list of tuples
            # Convert to list of tuples
            common_list = [];
            for item in emotion_counts.items() {
                common_list.append([item[0], item[1]]);
            }
            report {
                "common_emotions": common_list,
                "period_days": self.lookback_days,
                "total_entries": len(user_entries)
            } ;
        }
    }
}

walker get_daily_affirmation {
    has emotion_name: str;
    has user_name: str = "";

    can affirm with entry {
        affirmations = {
            "sad": "You are stronger than you know, and this feeling will pass.",
            "stressed": "Take it one step at a time. You've got this.",
            "anxious": "Breathe. You are safe. You are capable.",
            "happy": "Your joy is a gift. Keep shining!",
            "overwhelmed": "It's okay to ask for help. You don't have to do it all alone."
        };

        message = affirmations.get(
            self.emotion_name.lower(), "You are worthy of love and kindness."
        );

        report {
            "affirmation": message,
            "emotion": self.emotion_name,
            "user_name": self.user_name if self.user_name else "Friend"
        } ;
    }
}

# ============================================================================
# ============================================================================
# AI AGENT WALKERS (from agents.jac)
# AI AGENT WALKERS (from agents.jac)
# ============================================================================
# ============================================================================
walker emotion_from_text {
    has journal_text: str;
    has user_id: str = "";

    can extract_emotions with entry {
        # Simple emotion extraction from text
        # Simple emotion extraction from text
        emotions = [];
        intensity = 5.0;
        triggers = [];

        text_lower = self.journal_text.lower();

        if "happy" in text_lower or "joy" in text_lower or "great" in text_lower {
            emotions.append("happy");
            intensity = 7.5;
        }
        if "sad" in text_lower or "down" in text_lower or "depressed" in text_lower {
            emotions.append("sad");
            intensity = 3.5;
        }
        if "stress" in text_lower or "anxious" in text_lower or "worried" in text_lower {
            emotions.append("stressed");
            intensity = 4.0;
        }
        if "angry" in text_lower or "frustrated" in text_lower {
            emotions.append("angry");
            intensity = 3.0;
        }
        if "calm" in text_lower or "peaceful" in text_lower or "relaxed" in text_lower {
            emotions.append("calm");
            intensity = 8.0;
        }

        # Detect triggers
        # Detect triggers
        if "work" in text_lower {
            triggers.append("work stress");
        }
        if "sleep" in text_lower {
            triggers.append("sleep issues");
        }
        if "relationship" in text_lower or "partner" in text_lower {
            triggers.append("relationship concerns");
        }

        report {
            "emotions": emotions if emotions else ["neutral"],
            "intensity": intensity,
            "triggers": triggers,
            "sentiment": "positive"
            if intensity > 6
            else ("negative" if intensity < 4 else "neutral")
        } ;
    }
}

walker generate_support_message {
    has emotion_name: str;
    has intensity_score: float;
    has detected_triggers: list[str] = [];
    has user_context: str = "";

    can generate_message with entry {
        messages = {
            "sad": "I understand you're feeling sad right now. It's okay to feel this way. Remember that emotions are temporary, and brighter days are ahead. Consider reaching out to someone you trust or doing something kind for yourself today.",
            "stressed": "Stress can feel overwhelming, but you're handling more than you realize. Take a moment to breathe deeply. Break down your tasks into smaller, manageable steps. You don't have to tackle everything at once.",
            "anxious": "Anxiety is tough, but you're tougher. Try grounding yourself in the present moment - notice 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste. You are safe right now.",
            "happy": "I'm so glad you're feeling happy! This positive energy is wonderful. Take a moment to savor this feeling and maybe share your joy with someone else. You deserve this happiness.",
            "overwhelmed": "Feeling overwhelmed is a sign you care deeply. It's okay to pause and prioritize. You don't have to do everything perfectly or all at once. What's one small thing you can focus on right now?",
            "angry": "Your anger is valid. It's telling you something needs attention. Take some deep breaths, give yourself space if needed, and then think about what you need to feel better. Physical activity or creative expression can help process these feelings.",
            "lonely": "Loneliness is difficult. Remember that feeling alone doesn't mean you are alone. Consider reaching out to someone, even with a simple message. Your presence matters to people, even when it doesn't feel that way."
        };

        default_message = "Thank you for sharing how you're feeling. Every emotion you experience is valid and part of being human. Be gentle with yourself today. If you need support, don't hesitate to reach out to someone you trust.";

        message = messages.get(self.emotion_name.lower(), default_message);

        report {
            "support_message": message,
            "emotion": self.emotion_name,
            "intensity": self.intensity_score,
            "coping_strategies": [
                "Practice deep breathing for 5 minutes",
                "Take a short walk outside",
                "Write in your journal",
                "Connect with a supportive friend",
                "Engage in a calming activity you enjoy"
            ]
        } ;
    }
}

walker generate_breathing_exercise {
    has emotion_name: str;
    has intensity_score: float;
    has duration_preference: int = 300;

    can generate_exercise with entry {
        exercises = {
            "stressed": {
                "name": "4-7-8 Breathing",
                "description": "Breathe in for 4 counts, hold for 7, exhale for 8. This activates your relaxation response.",
                "steps": [
                    "Sit comfortably",
                    "Breathe in through nose for 4 counts",
                    "Hold breath for 7 counts",
                    "Exhale through mouth for 8 counts",
                    "Repeat 4 times"
                ]
            },
            "anxious": {
                "name": "Box Breathing",
                "description": "Breathe in a square pattern to calm your nervous system.",
                "steps": [
                    "Breathe in for 4 counts",
                    "Hold for 4 counts",
                    "Exhale for 4 counts",
                    "Hold for 4 counts",
                    "Repeat 5-10 times"
                ]
            },
            "default": {
                "name": "Simple Deep Breathing",
                "description": "Basic deep breathing to center yourself.",
                "steps": [
                    "Find a comfortable position",
                    "Breathe in slowly through nose for 4 counts",
                    "Breathe out slowly through mouth for 6 counts",
                    "Repeat for 5 minutes"
                ]
            }
        };

        exercise = exercises.get(self.emotion_name.lower(), exercises["default"]);

        report {
            "exercise_name": exercise["name"],
            "description": exercise["description"],
            "steps": exercise["steps"],
            "duration_minutes": self.duration_preference / 60,
            "emotion": self.emotion_name
        } ;
    }
}

walker generate_affirmation {
    has emotion_name: str;
    has intensity_score: float;
    has user_name: str = "Friend";
    has detected_triggers: list[str] = [];

    can create_affirmation with entry {
        affirmations = {
            "sad": f"I am resilient and capable of weathering this storm. Better days are coming.",
            "stressed": f"I release what I cannot control and focus on what I can. I am doing my best.",
            "anxious": f"I am safe. I am grounded. I have everything I need in this moment.",
            "happy": f"I deserve this joy and I welcome more happiness into my life.",
            "overwhelmed": f"I take things one step at a time. I am capable and strong.",
            "angry": f"My feelings are valid. I choose to process them in healthy ways.",
            "lonely": f"I am worthy of connection and love. I reach out with courage."
        };

        default_affirmation = f"I am worthy of peace, happiness, and self-compassion.";

        affirmation = affirmations.get(self.emotion_name.lower(), default_affirmation);

        report {
            "affirmation": affirmation,
            "emotion": self.emotion_name,
            "usage_tip": "Repeat this affirmation 3 times, slowly, while taking deep breaths. Say it out loud if possible.",
            "user_name": self.user_name
        } ;
    }
}

walker generate_weekly_reflection {
    has user_id: str;
    has weekly_emotions: dict[str, int] = {};
    has detected_patterns: list[str] = [];
    has week_number: int = 1;

    can reflect with entry {
        report {
            "reflection": "This week you've experienced a range of emotions, which is completely normal. Every feeling you had taught you something about yourself and your needs.",
            "patterns": self.detected_patterns
            if self.detected_patterns
            else ["Showing up for yourself each day", "Being aware of your emotions"],
            "encouragement": "Keep tracking your moods - you're building valuable self-awareness!",
            "next_week_focus": "Try to notice what activities or people help you feel your best."
        } ;
    }
}

walker suggest_habit_improvements {
    has detected_triggers: list[str] = [];
    has dominant_emotions: list[str] = [];
    has current_habits: list[str] = [];
    has intensity_average: float = 0.0;

    can suggest with entry {
        suggestions = [
            "Establish a consistent sleep schedule - aim for 7-9 hours per night",
            "Practice 10 minutes of mindfulness or meditation daily",
            "Move your body for at least 20 minutes each day",
            "Connect with a friend or loved one regularly",
            "Limit screen time before bed",
            "Keep a gratitude journal - write 3 things you're grateful for each day"
        ];

        report {
            "habit_suggestions": suggestions,
            "priority_focus": "Start with just one small change this week",
            "encouragement": "Small, consistent actions create lasting change. Be patient with yourself!"
        } ;
    }
}
