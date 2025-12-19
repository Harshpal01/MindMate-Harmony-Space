# Jac Language Walker Syntax Reference

## Complete Walker Syntax Guide with Working Examples

Based on analysis of **Jaseci/jaclang** repository patterns and the MindMate project's actual working walkers.

---

## 1. WALKER BLOCK DEFINITION

### Basic Syntax

```jac
walker walker_name {
    has property_name: type;

    can ability_name {
        # statements
    }
}
```

### Key Components

- **`walker`** - Keyword to define a walker
- **`walker_name`** - Identifier for the walker (snake_case recommended)
- **`has`** - Property/field declaration keyword
- **`can`** - Ability block definition keyword

---

## 2. PROPERTY DECLARATIONS WITH `has`

### Basic Property Syntax

```jac
has property_name: type;
```

### Supported Type Declarations

#### Primitive Types

```jac
walker example_walker {
    has id: str;                          # String
    has count: int;                       # Integer
    has score: float;                     # Float/decimal
    has is_active: bool;                  # Boolean
}
```

#### Collection Types

```jac
walker collection_walker {
    has tags: list[str];                  # List of strings
    has scores: list[float];              # List of floats
    has metadata: dict[str, int];         # Dictionary/map
    has items: list[dict[str, str]];      # List of dictionaries
}
```

#### Type-Annotated Properties

All properties in Jac **REQUIRE explicit type annotations**. There is no implicit typing.

```jac
walker typed_walker {
    has name: str;        # ✅ Valid - explicit type
    has value: float;     # ✅ Valid - explicit type
    # has count;          # ❌ Invalid - missing type annotation
}
```

### Properties with Default Values

```jac
walker defaults_walker {
    has user_id: str;                     # Required (no default)
    has lookback_days: int = 30;          # Optional with default
    has journal_text: str = "";           # String default
    has tags: list[str] = [];             # Empty list default
    has tags: list[str] = ["default"];    # List with initial values
    has metadata: dict[str, int] = {};    # Empty dict default
    has duration: int = 300;              # Integer default
}
```

---

## 3. ABILITY BLOCKS WITH `can`

### Basic Ability Syntax

```jac
can ability_name {
    # Statements inside ability block
}
```

### Ability Rules

- Abilities are methods/functions on the walker
- Multiple abilities can be defined per walker
- Ability names should be descriptive verbs (log, analyze, calculate, etc.)
- No parameters are passed to `can` blocks - use walker properties instead

---

## 4. VALID STATEMENTS INSIDE `can` BLOCKS

### Standard Output

```jac
can log {
    std.out("Logging mood");              # Print to stdout
    std.out("User: " + user_id);          # String concatenation
}
```

### Report Statements (Return Values)

```jac
can summarize {
    report {
        "status": "success",
        "user_id": user_id,
        "summary": "Daily summary generated"
    };
}
```

### Control Flow

```jac
can analyze {
    # Conditional execution
    if (intensity > 5.0) {
        std.out("High intensity");
    }
}
```

### Variable Declaration & Assignment

```jac
can calculate {
    x: int = 10;                          # Local variable
    result: float = x * 1.5;
    std.out("Result: " + str(result));
}
```

### List and Dictionary Operations

```jac
can process {
    items: list[str] = ["a", "b", "c"];
    counts: dict[str, int] = {"x": 1, "y": 2};
    std.out("Items count: " + str(len(items)));
}
```

---

## 5. COMPLETE WORKING EXAMPLES

### Example 1: Simple Walker with Single Property

```jac
walker log_mood {
    has user_id: str;
    has mood_name: str;
    has intensity: float;
    has journal_text: str = "";

    can log {
        std.out("Logging mood");
    }
}
```

### Example 2: Walker with Multiple Property Types

```jac
walker emotion_from_text {
    has journal_text: str;                    # Required string
    has user_id: str = "";                    # Optional string

    can analyze {
        std.out("Analyzing emotion from text");
    }
}
```

### Example 3: Walker with Complex Properties

```jac
walker generate_support_message {
    has emotion_name: str;                    # String
    has intensity_score: float;               # Float
    has detected_triggers: list[str];         # List of strings
    has user_context: str = "";               # Optional string

    can support {
        std.out("Generating support message");
    }
}
```

### Example 4: Walker with Dictionary Property

```jac
walker generate_weekly_reflection {
    has user_id: str;                         # String
    has weekly_emotions: dict[str, int];      # Dictionary
    has detected_patterns: list[str];         # List of strings
    has week_number: int = 1;                 # Integer with default

    can reflect {
        std.out("Generating weekly reflection");
    }
}
```

### Example 5: Walker with Defaults and Multiple Abilities

```jac
walker recommend_activities {
    has emotion_name: str;                    # Required
    has intensity: float;                     # Required
    has user_id: str = "default";             # Optional
    has limit: int = 5;                       # Optional with default

    can recommend {
        std.out("Recommending activities");
    }

    can validate {
        std.out("Validating parameters");
    }
}
```

### Example 6: Walker with Complex Data Types

```jac
walker suggest_habit_improvements {
    has detected_triggers: list[str];         # List required
    has dominant_emotions: list[str];         # List required
    has current_habits: list[str];            # List required
    has intensity_average: float;             # Float required
    has habit_metadata: dict[str, float] = {};# Dict with default

    can suggest {
        std.out("Suggesting habit improvements");
    }
}
```

---

## 6. WALKER SYNTAX PATTERNS FROM JASECI

### Pattern: Parameter-Based Walker

Walkers pass parameters through their `has` properties (not function arguments):

```jac
walker good_pattern {
    has user_id: str;
    has days: int = 7;

    can process {
        std.out("Processing for user: " + user_id);
        std.out("Days: " + str(days));
    }
}

# ❌ This pattern does NOT work in Jac:
# walker bad_pattern(user_id: str, days: int) {  # ❌ Wrong
#     can process { }
# }
```

### Pattern: Initialization with Entry Point

```jac
walker initialize_graph {
    has graph_name: str;

    can setup {
        std.out("Setting up graph: " + graph_name);
    }
}

with entry {
    """Entry point to initialize walkers"""
    graph = spawn initialize_graph();
    report {
        "status": "ready"
    };
}
```

---

## 7. TYPE SYSTEM SUMMARY

### Type Annotations (REQUIRED)

| Type         | Example                    | Notes           |
| ------------ | -------------------------- | --------------- |
| `str`        | `has name: str;`           | Text strings    |
| `int`        | `has count: int;`          | Whole numbers   |
| `float`      | `has score: float;`        | Decimal numbers |
| `bool`       | `has active: bool;`        | True/False      |
| `list[T]`    | `has items: list[str];`    | Array of type T |
| `dict[K, V]` | `has map: dict[str, int];` | Key-value map   |

### Type Rules

- ✅ All properties **MUST** have explicit type annotations
- ✅ Default values must match declared type
- ✅ No implicit type coercion
- ✅ Nested collections supported: `list[dict[str, float]]`
- ✅ Collections are homogeneous (all items same type)

---

## 8. COMMON WALKER PATTERNS IN PRODUCTION

### Data Input Walker

```jac
walker log_mood {
    has user_id: str;
    has mood_name: str;
    has intensity: float;
    has journal_text: str = "";

    can log {
        std.out("Logging mood");
    }
}
```

### Data Analysis Walker

```jac
walker get_weekly_summary {
    has user_id: str;
    has num_days: int = 7;

    can reflect {
        std.out("Generating weekly summary");
    }
}
```

### LLM-Integrated Walker (Agent)

```jac
walker generate_support_message {
    has emotion_name: str;
    has intensity_score: float;
    has detected_triggers: list[str];
    has user_context: str = "";

    can support {
        std.out("Generating support message");
    }
}
```

### Trend Analysis Walker

```jac
walker calculate_emotional_trends {
    has user_id: str;
    has lookback_days: int = 14;

    can calculate {
        std.out("Calculating emotional trends");
    }
}
```

---

## 9. WALKER EXECUTION CONTEXT

### How Walkers are Called (spawn syntax)

```javascript
// From JavaScript/Frontend
{
  "walker": "log_mood",
  "ctx": {
    "user_id": "user_001",
    "mood_name": "anxious",
    "intensity": 7.5,
    "journal_text": "I'm feeling anxious today"
  }
}
```

### Context Maps to Walker Properties

The `ctx` object properties map directly to walker `has` declarations:

- `ctx.user_id` → `has user_id: str;`
- `ctx.intensity` → `has intensity: float;`
- `ctx.detected_triggers` → `has detected_triggers: list[str];`

---

## 10. COMPLETE VALID WALKER SYNTAX CHECKLIST

✅ **Valid Walker Structure:**

```jac
walker valid_example {
    # Properties with types (REQUIRED)
    has required_prop: str;

    # Properties with defaults (OPTIONAL)
    has optional_prop: int = 10;
    has list_prop: list[str] = [];
    has dict_prop: dict[str, float] = {};

    # Multiple abilities
    can ability_one {
        std.out("First ability");
    }

    can ability_two {
        std.out("Second ability");
    }
}
```

❌ **Invalid Patterns:**

```jac
# Missing type annotation
walker invalid_1 {
    has name;  # ❌ No type specified
}

# Function-style parameters
walker invalid_2(name: str) {  # ❌ Wrong syntax
    can process { }
}

# Bare variable declaration
walker invalid_3 {
    name = "test";  # ❌ Must use 'has' keyword
}
```

---

## 11. DOCUMENTATION REFERENCES

### Jac Language Resources

- **Repository:** Jaseci/jaclang (GitHub)
- **Walker Construct:** Used for stateful computation in Jaseci graphs
- **Key Features:**
  - Properties with explicit types
  - Ability methods for behavior
  - Integration with graph traversal
  - LLM agent support

### Your Project's Walker Usage

- **File:** `backend/walkers.jac` and `backend/agents.jac`
- **Count:** 13 working walkers
- **Types:** Data input, analysis, recommendation, LLM-integrated
- **Integration:** REST API via `/api/walker` endpoint

---

## SUMMARY: WALKER SYNTAX RULES

1. **Walker Definition:** `walker name { ... }`
2. **Properties:** `has name: type;` with optional defaults
3. **Types:** Explicit (str, int, float, bool, list[T], dict[K,V])
4. **Abilities:** `can name { statements }`
5. **Statements:** std.out(), report {}, if conditions, variable declaration
6. **Multiple Properties:** Comma-separated with unique types
7. **Multiple Abilities:** Multiple `can` blocks allowed
8. **No Parameters:** Abilities use walker properties, not function arguments

---

**Generated:** 2025-12-19
**Source:** Jaseci/jaclang repository patterns + MindMate project examples
