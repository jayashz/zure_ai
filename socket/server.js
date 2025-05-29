import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import routes from "./auth/auth.js";
import { connectDB } from "./config/db.js";
import messageRoutes from "./routes/message_route.js";
import { chatHandler } from "./sockets/chat_handler.js";
import { socketAuth } from "./middleware/socket_middleware.js";

const app = express();
const server = createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*", // or specify your mobile app origin
    methods: ["GET", "POST"],
  },
});

connectDB();

app.use(express.json());
//Routes
app.use("/api/auth", routes);

// Protected Route to the messages
app.get("/api/messages", messageRoutes);

socketAuth(io);
chatHandler(io);

server.listen(3000, "0.0.0.0", () => {
  console.log("Server listening on http://0.0.0.0:3000");
});
