# WSL SETUP GUIDE

## For Windows Subsystem for Linux Users

If you're running this project in WSL (Windows Subsystem for Linux), follow these steps:

### Step 1: Initial Setup (Run Once)

Navigate to the backend directory and run the setup script:

```bash
cd /mnt/c/Users/Administrator/AI\ Mental-Wellbeing\ Companion/backend
bash setup-wsl.sh
```

This script automatically:

- ✅ Updates apt package manager
- ✅ Installs python3.12-venv and python3-full
- ✅ Creates a Python virtual environment (`venv`)
- ✅ Installs all dependencies from `requirements.txt`

### Step 2: Activate the Virtual Environment

Every time you open a new terminal, activate the virtual environment:

```bash
cd /mnt/c/Users/Administrator/AI\ Mental-Wellbeing\ Companion/backend
source venv/bin/activate
```

You should see `(venv)` in your terminal prompt, indicating the environment is active.

### Step 3: Run the Application

#### Option A: Run Jaseci Server with app.jac

```bash
jac serve app.jac
```

#### Option B: Run Individual Walkers

```bash
jac serve walkers.jac
```

#### Option C: Start Jaseci in Production Mode

```bash
python jaseci_server.py
```

### Step 4: Backend Testing

Test that everything is working:

```bash
python3 -c "import jaseci; print('Jaseci installed successfully!')"
```

### Troubleshooting

**Issue: Command 'jac' not found**

- Solution: Make sure virtual environment is activated (`source venv/bin/activate`)
- The `jac` command is only available inside the venv

**Issue: Permission denied on setup-wsl.sh**

- Solution: Make the script executable:
  ```bash
  chmod +x setup-wsl.sh
  bash setup-wsl.sh
  ```

**Issue: Python version mismatch**

- WSL is using Python 3.12.3 (which is fine)
- Minimum required: Python 3.8+

### What's in the Virtual Environment?

The `venv` directory contains:

- Isolated Python packages for this project
- `bin/activate` - Script to activate the environment
- `lib/python3.12/site-packages/` - Installed packages
- `bin/jac` - Jaseci CLI tool
- `bin/python` - Python interpreter

### Environment Variables

Optional: Create a `.env` file for LLM configuration:

```bash
# For Ollama (local LLM)
echo "LLM_PROVIDER=ollama" > .env
echo "OLLAMA_ENDPOINT=http://localhost:11434" >> .env

# For OpenAI
# echo "LLM_PROVIDER=openai" > .env
# echo "OPENAI_API_KEY=your_key_here" >> .env
```

### Next Steps

1. ✅ Run setup script
2. ✅ Activate venv
3. ✅ Start Jaseci server
4. 📦 (Separate terminal) Start frontend: `cd frontend && npm start`
5. 🌐 Open browser: http://localhost:3000

---

**For more details, see [QUICK_START.md](QUICK_START.md)**
