import express from "express";
import mongoose from "mongoose";

import { createServer } from "http";
import { Server } from "socket.io";
import { GoogleGenAI } from "@google/genai";
import Message from "./models/message.js";
import {
  verifyToken,
  verifySocketToken,
} from "./auth/middleware/authMiddleware.js";
import routes from "./auth/auth.js";

const { connect, connection } = mongoose;
const app = express();
const server = createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*", // or specify your mobile app origin
    methods: ["GET", "POST"],
  },
});

// Initialize Google GenAI client with API key
const ai = new GoogleGenAI({
  apiKey: "AIzaSyCX1khnmlkbXsw6CmT0msY6qVIoYCrABi8",
});

connect("mongodb://localhost:27017/chat-app");

//mongo db
const db = connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

//Routes
app.use("/api/auth", routes);

// Protected Route to the messages
app.get("/api/messages", verifyToken, async (req, res) => {
  const messages = await Message.find({});
  res.json(messages);
});

io.use(verifySocketToken);

io.on("connection", async (socket) => {
  console.log("A user connected:", socket.user.username);

  const prevMessages = await Message.find({});
  socket.emit("previousMessages", prevMessages);

  socket.on("user", async (msg) => {
    const userMessage = {
      text: msg,
      isUser: true,
      time: new Date().toLocaleTimeString(),
    };

    await Message.create(userMessage);

    io.emit("user", userMessage);

    try {
      // Use the new generateContent method
      const response = await ai.models.generateContent({
        model: "gemini-2.0-flash-001", // or any other supported model
        contents: msg,
      });

      const aiReply = response.text;

      const aiMessage = {
        text: aiReply,
        isUser: false,
        time: new Date().toLocaleTimeString(),
      };

      await Message.create(aiMessage);
      io.emit("ai_message", aiMessage);
    } catch (error) {
      console.error("Gemini error:", error);
    }
  });
  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
});

server.listen(3000, "0.0.0.0", () => {
  console.log("Server listening on http://0.0.0.0:3000");
});
