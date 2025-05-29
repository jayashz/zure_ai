import Message from "../models/message.js";
import { getAIResponse } from "../services/aiService.js";
import { saveMessage } from "../controllers/messageController.js";

export const chatHandler = (io) => {
  io.on("connection", async (socket) => {
    console.log("User connected:", socket.user.username);

    const prevMessages = await Message.find({});
    socket.emit("previousMessages", prevMessages);

    socket.on("user", async (msg) => {
      const userMessage = await saveMessage(msg, true);
      io.emit("user", userMessage);

      const aiReply = await getAIResponse(msg);
      const aiMessage = await saveMessage(aiReply, false);
      io.emit("ai_message", aiMessage);
    });

    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
    });
  });
};
