# 🤖 Zure AI Assistant

Zure AI Assistant is a real-time chat application powered by Google Gemini AI. It allows users to interact with an AI chatbot and see live message responses. Built with **Node.js**, **Socket.IO**, **MongoDB**, and **Google GenAI**, Zure provides an intelligent and scalable foundation for any smart assistant platform.

---

## 🚀 Features

- 🧠 **AI-Powered Chat** – Integrates Google Gemini for generating intelligent, human-like responses.
- 🔐 **JWT Authentication** – Secures API and WebSocket access.
- 📡 **Real-Time Messaging** – Instant communication using Socket.IO.
- 💾 **MongoDB Storage** – All messages (user & AI) are stored in MongoDB for persistence.
- 🛡️ **Protected Routes** – Secure access to messages with token-based middleware.

---

## 🧱 Tech Stack

- **Backend**: Node.js, Express.js
- **Database**: MongoDB + Mongoose
- **Real-time**: Socket.IO
- **AI**: Google Gemini via `@google/genai`
- **Authentication**: JWT
- **Environment Config**: dotenv

---

## 🗂️ Project Structure
<pre>
zure-ai/
├── auth/           → 🔐 Authentication logic (signup, login, token generation)
├── config/         → ⚙️ Database connection & environment configuration
├── controllers/    → 🧠 Core logic for handling messages (optional abstraction)
├── middleware/     → 🛡️ JWT and Socket.IO token validation
├── models/         → 🗃️ Mongoose schemas for MongoDB collections
├── routes/         → 🌐 REST API route handlers
├── services/       → 🤖 Google GenAI integration logic
├── sockets/        → 📡 WebSocket event handlers
├── keys.env        → 🔑 Environment variables (DO NOT commit this!)
└── server.js       → 🚀 Entry point to start the server
</pre>
---

## ⚙️ Setup Instructions for the backend service

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/zure-ai.git
cd zure-ai
```
### 2. Install dependencies
```bash
npm install
```

### 3. Creating Environment
```bash
gem_Api=your_google_genai_api_key
JWT_SECRET=your_jwt_secret
```
### 4. Start the server
```bash
node server.js
```
Server will start at: http://0.0.0.0:3000

## ⚙️ Setup Instruction for the flutter frontend

### 1. Install dependencies
```bash
cd flutter
flutter pub get
```

### 2. Modify the Ip
Modify the ip according to your in the 'lib/core/constants.dart'. 
To see your current ip:
for mac:
```bash
ifconfig
```
for windows:
```bash
ipconfig
```

### 3. Run the flutter app
```bash
flutter run
```
