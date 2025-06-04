# 📱 WhatsApp Setup Guide - FireWatch

## 🎯 Overview
This guide will help you configure Twilio WhatsApp integration so users can report fire incidents by sending their location via WhatsApp.

## 📋 Prerequisites
- Twilio account (free trial available)
- Domain with HTTPS (for production) OR ngrok (for testing)
- WhatsApp Business account (managed by Twilio)

---

## 🚀 Step 1: Create Twilio Account

1. Go to [Twilio.com](https://www.twilio.com/)
2. Click **"Sign up"** and create a free account
3. Verify your email and phone number
4. Complete the onboarding questionnaire

---

## 🔧 Step 2: Configure WhatsApp Sandbox (Testing)

For testing, Twilio provides a WhatsApp Sandbox:

1. In Twilio Console, go to **"Messaging" → "Try it out" → "Send a WhatsApp message"**
2. Note the sandbox number (e.g., `+1 415 523 8886`)
3. Note the sandbox code (e.g., `join abc-def`)
4. On your phone, send the join code to the sandbox number via WhatsApp

Example:
```
Send: "join abc-def"
To: +1 415 523 8886
```

---

## 🔑 Step 3: Get Your Credentials

1. In Twilio Console, go to **Dashboard**
2. Copy these values:
   - **Account SID** (starts with AC...)
   - **Auth Token** (click "show" to reveal)
   - **WhatsApp From Number** (the sandbox number)

---

## 📝 Step 4: Configure Environment Variables

Create or update `.env` file in your project root:

```bash
cd /home/leo/Área\ de\ trabalho/firewatch_crewai/FireWatchProject
```

```env
# Twilio Configuration
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_FROM=+14155238886

# Database
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/firewatch
SPRING_DATASOURCE_USERNAME=firewatch_user
SPRING_DATASOURCE_PASSWORD=firewatch_pass

# Optional: OpenAI (if using AI features)
OPENAI_API_KEY=your_openai_key_here
```

---

## 🌐 Step 5: Expose Your Local Server

### Option A: Using ngrok (Recommended for testing)

1. **Install ngrok:**
```bash
# Download from https://ngrok.com/download
# Or using package manager:
sudo snap install ngrok  # Ubuntu/Debian
# brew install ngrok     # macOS
```

2. **Start your FireWatch backend:**
```bash
cd backend
./mvnw spring-boot:run
```

3. **In another terminal, expose port 8080:**
```bash
ngrok http 8080
```

4. **Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

### Option B: Deploy to Cloud (Production)

Deploy to Heroku, AWS, or any cloud provider with HTTPS support.

---

## 🔗 Step 6: Configure Twilio Webhook

1. Go to Twilio Console → **"Messaging" → "Settings" → "WhatsApp sandbox settings"**

2. **Configure the webhook:**
   - **When a message comes in:** `https://your-ngrok-url.ngrok.io/api/webhook/whatsapp`
   - **HTTP method:** `POST`
   - **Status callback:** Leave empty for now

3. **Save Configuration**

Example webhook URL:
```
https://abc123.ngrok.io/api/webhook/whatsapp
```

---

## 🧪 Step 7: Test the Integration

### Manual Test (Recommended)

1. **Start your backend:**
```bash
cd backend
./mvnw spring-boot:run
```

2. **Start ngrok:**
```bash
ngrok http 8080
```

3. **Send test message to WhatsApp sandbox:**

**Option 1: Send location**
- Open WhatsApp
- Send to your sandbox number (+1 415 523 8886)
- Tap attachment (📎) → Location → Send Live Location

**Option 2: Send coordinates in text**
```
Incêndio urgente! Lat: -23.5505, Long: -46.6333
```

**Option 3: Send simple coordinates**
```
-22.9068, -43.1729 - Fogo na floresta!
```

### Automated Test

```bash
# Make sure backend is running first
./test_webhook.sh
```

---

## 📱 Step 8: Start Frontend

```bash
cd frontend
npm install
npm start
```

Open http://localhost:3000 and you should see new incidents appearing on the map!

---

## ✅ What Should Happen

When a user sends a WhatsApp message with location:

1. **User sends message** → WhatsApp → Twilio → Your webhook
2. **Backend processes** location and creates incident
3. **Database stores** the new fire incident
4. **Notifications sent** to other users in the area
5. **Frontend updates** automatically (every 10 seconds)
6. **Map shows** new incident with fire icon
7. **User gets confirmation** via WhatsApp

---

## 🚨 Troubleshooting

### Webhook not receiving messages
```bash
# Check ngrok is running
curl https://your-ngrok-url.ngrok.io/api/webhook/whatsapp

# Check Twilio webhook logs
# Go to Twilio Console → Monitor → Logs → Errors
```

### Database connection issues
```bash
# Start database
docker-compose up firewatch-mysql

# Check connection
docker-compose exec firewatch-mysql mysql -u firewatch_user -p
```

### Frontend not updating
- Check browser console for errors
- Verify API is running on port 8080
- Check if polling is working (10-second intervals)

### No notifications received
- Verify Twilio credentials in `.env`
- Check backend logs for errors
- Ensure users exist in database with valid phone numbers

---

## 🔄 Quick Start Commands

```bash
# 1. Start database
docker-compose up firewatch-mysql firewatch-redis -d

# 2. Start backend
cd backend && ./mvnw spring-boot:run

# 3. In new terminal: Start ngrok
ngrok http 8080

# 4. Configure Twilio webhook with ngrok URL

# 5. In new terminal: Start frontend
cd frontend && npm start

# 6. Test by sending WhatsApp message with location
```

---

## 🎯 Production Deployment

For production, replace ngrok with a proper domain:

1. Deploy backend to cloud service
2. Configure HTTPS domain
3. Update Twilio webhook to production URL
4. Set up environment variables in production
5. Configure production database

---

## 📞 Support

If you encounter issues:

1. Check Twilio Console → Monitor → Logs
2. Check backend terminal for error logs
3. Verify webhook URL is accessible: `curl your-webhook-url`
4. Test with the provided `test_webhook.sh` script

**Webhook endpoint:** `/api/webhook/whatsapp`
**Method:** `POST`
**Expected parameters:** `From`, `Body`, `Latitude`, `Longitude`