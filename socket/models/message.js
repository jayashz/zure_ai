import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
  text: String,
  isUser: Boolean,
  time: String,
});

const Message = mongoose.model("Message", messageSchema);
export default Message;
