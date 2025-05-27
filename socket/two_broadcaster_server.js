const express = require("express");
const mongoose = require("mongoose");
const http = require("http");
const socketIo = require("socket.io");

// Set up Express and HTTP server
const app = express();
const server = http.createServer(app);

//connect mongoose connect
mongoose.connect("mongodb://localhost:27017/chat-app");

const db = mongoose.connection;
db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

const messageSchema = new mongoose.Schema({
  text: String,
  isUser: Boolean,
  time: String,
});

const Message = mongoose.model("Message", messageSchema);

// Attach socket.io to the server
const io = socketIo(server);

app.use(express.static("public"));

// Serve a basic route
app.get("/", async (req, res) => {
  const message = await Message.find({});
  res.json(message);
});

// Listen for client connections
io.on("connection", async (socket) => {
  console.log("A user connected:", socket.id);

  //load previous messages from the database
  const prevMessages = await Message.find({});
  socket.emit("previousMessages", prevMessages);

  // Listen to messages from the client
  socket.on("ai_message", async (msg) => {
    const message = new Message({
      text: msg,
      isUser: false,
      time: new Date().toLocaleTimeString(),
    });

    await message.save();

    console.log("AI message:", message.text);
    io.emit("ai_message", message);
  });

  socket.on("user", async (msg) => {
    const message = new Message({
      text: msg,
      isUser: true,
      time: new Date().toLocaleTimeString(),
    });

    console.log("user message:", msg);
    await message.save();
    io.emit("user", message);
  });

  // Handle disconnect
  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
});

// Start the server
server.listen(3000, () => {
  console.log("Server listening on http://localhost:3000");
});
