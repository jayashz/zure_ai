import Message from "../models/message.js";

export const getAllMessages = async (req, res) => {
  const messages = await Message.find({});
  res.json(messages);
};

export const saveMessage = async (text, isUser) => {
  return await Message.create({
    text,
    isUser,
    time: new Date().toLocaleTimeString(),
  });
};
