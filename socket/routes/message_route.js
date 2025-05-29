import express from "express";
import { getAllMessages } from "../controllers/messageController.js";
import { verifyToken } from "../auth/middleware/authMiddleware.js";

const router = express.Router();

router.get("/", verifyToken, getAllMessages);

export default router;
