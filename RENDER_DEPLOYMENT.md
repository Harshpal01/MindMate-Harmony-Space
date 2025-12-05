# Render Deployment Guide - MindMate Harmony Space

## Step-by-Step Deployment Instructions

### Prerequisites

1. GitHub account with repository pushed (✅ Already done)
2. Render account (free tier available at https://render.com)
3. OpenAI API key (optional, for LLM features)

---

## Option 1: Deploy via Render Dashboard (Recommended)

### Part 1: Deploy Backend

1. **Go to Render Dashboard**

   - Visit: https://dashboard.render.com

2. **Create New Service**

   - Click: "New +" → "Web Service"
   - Connect your GitHub repository: `MindMate-Harmony-Space`
   - Select branch: `main`

3. **Configure Backend Service**

   - **Name:** `mindmate-backend`
   - **Runtime:** Python 3.11
   - **Build Command:** `cd backend && pip install -r requirements.txt`
   - **Start Command:** `cd backend && python jaseci_server.py`
   - **Plan:** Free (or Pro for production)

4. **Add Environment Variables**

   - Click: "Environment"
   - Add these variables:
     ```
     PYTHONUNBUFFERED=true
     PORT=5000
     LLM_PROVIDER=openai
     OPENAI_API_KEY=sk-your-key-here (optional)
     JASECI_HOST=0.0.0.0
     JASECI_PORT=5000
     DATABASE_URL=sqlite:///mindmate.db
     FLASK_ENV=production
     ```

5. **Deploy**
   - Click: "Create Web Service"
   - Wait for deployment to complete (~5 minutes)
   - Note the backend URL: `https://mindmate-backend.onrender.com`

### Part 2: Deploy Frontend

1. **Create New Service**

   - Click: "New +" → "Web Service"
   - Connect your GitHub repository: `MindMate-Harmony-Space`
   - Select branch: `main`

2. **Configure Frontend Service**

   - **Name:** `mindmate-frontend`
   - **Runtime:** Node
   - **Build Command:** `cd frontend && npm install && npm run build`
   - **Start Command:** `cd frontend && npm install -g serve && serve -s build -l 3000`
   - **Plan:** Free (or Pro for production)

3. **Add Environment Variables**

   - Click: "Environment"
   - Add these variables:
     ```
     REACT_APP_JASECI_API_URL=https://mindmate-backend.onrender.com
     NODE_ENV=production
     ```

4. **Deploy**
   - Click: "Create Web Service"
   - Wait for deployment to complete (~5 minutes)
   - Your frontend URL: `https://mindmate-frontend.onrender.com`

---

## Option 2: Deploy via Render YAML (Advanced)

If you prefer infrastructure-as-code:

1. **Render YAML is already in repository** (`render.yaml`)

2. **Connect via Dashboard**

   - Go to: https://dashboard.render.com
   - Click: "New +" → "Blueprint"
   - Select: `MindMate-Harmony-Space` repository
   - Select: `main` branch
   - Render will automatically read `render.yaml`

3. **Add Environment Variables**
   - During setup, add your secrets
   - Click: "Deploy"

---

## Step 3: Verify Deployment

### Backend Health Check

```bash
curl https://mindmate-backend.onrender.com/api/health
```

### Frontend Access

- Open: `https://mindmate-frontend.onrender.com`
- You should see: MindMate Harmony Space interface

### Test Application

1. Click "Log Mood"
2. Select an emotion
3. Set intensity (1-10)
4. Submit
5. View "Daily Check-in" and "Weekly Trends"

---

## Troubleshooting

### Backend Won't Start

**Error:** `ModuleNotFoundError: No module named 'jaseci'`

**Solution:**

- Ensure `backend/requirements.txt` is up to date
- Check Python version is 3.8+
- SSH into Render and check logs: `render logs mindmate-backend`

### Frontend Build Fails

**Error:** `npm ERR! code ERESOLVE`

**Solution:**

- Add to build command: `npm install --legacy-peer-deps && npm run build`
- Or update `frontend/package.json` dependencies

### API Connection Issues

**Error:** `Failed to connect to backend`

**Solution:**

- Verify backend URL in frontend env vars
- Check CORS is enabled in backend
- Ensure backend is fully deployed

### Out of Memory (Free Tier)

**Error:** Build process killed

**Solution:**

- Upgrade to paid Render plan
- Or deploy separately (backend on one service, frontend on another)

---

## Production Recommendations

### Security

- [ ] Set strong database credentials
- [ ] Use environment variables for API keys
- [ ] Enable HTTPS (Render does this by default)
- [ ] Implement rate limiting on backend

### Performance

- [ ] Use PostgreSQL instead of SQLite for backend
- [ ] Enable caching on frontend (Render default)
- [ ] Use CDN for static assets (Render includes)
- [ ] Monitor performance in Render dashboard

### Monitoring

- [ ] Set up error tracking (Sentry integration)
- [ ] Monitor logs regularly
- [ ] Set up alerts for failures
- [ ] Track API usage and performance

### Database

- [ ] Migrate from SQLite to PostgreSQL
- [ ] Set up automated backups
- [ ] Use Render's PostgreSQL service

---

## Deployment Checklist

- [ ] GitHub repository has all files
- [ ] `.gitignore` excludes sensitive files
- [ ] Environment variables configured in Render
- [ ] Backend deploys successfully
- [ ] Frontend deploys successfully
- [ ] Backend health check passes
- [ ] Frontend loads without errors
- [ ] Can log mood and view data
- [ ] API calls working correctly
- [ ] All walkers responding

---

## Environment Variables Reference

### Backend (.env.render)

```
PYTHONUNBUFFERED=true
PORT=5000
LLM_PROVIDER=openai
OPENAI_API_KEY=your_key
JASECI_HOST=0.0.0.0
DATABASE_URL=sqlite:///mindmate.db
FLASK_ENV=production
LOG_LEVEL=INFO
```

### Frontend (.env.production)

```
REACT_APP_JASECI_API_URL=https://mindmate-backend.onrender.com
NODE_ENV=production
```

---

## Useful Render Commands

### View Logs

```bash
# In Render Dashboard → Service → Logs
```

### Restart Service

```
# Render Dashboard → Service → Manual Deploy → Redeploy
```

### View Environment Variables

```
# Render Dashboard → Service → Environment
```

---

## Cost Estimate (Free Tier)

- **Backend (Python):** Free (up to 750 hours/month)
- **Frontend (Node):** Free (up to 750 hours/month)
- **Total:** Free for development/demo

**Upgrade to Paid:**

- Backend: $7/month (always on)
- Frontend: $7/month (always on)
- Total: $14/month production

---

## Support Resources

- **Render Docs:** https://render.com/docs
- **GitHub:** https://github.com/Harshpal01/MindMate-Harmony-Space
- **Issues:** Create GitHub issue for problems

---

## Next Steps After Deployment

1. ✅ Share deployed URL with others
2. ✅ Test all features on live server
3. ✅ Gather user feedback
4. ✅ Monitor performance
5. ✅ Plan improvements

---

**Your MindMate Harmony Space is now production-ready on Render!** 🚀
