import { verifySocketToken } from "../auth/middleware/authMiddleware.js";

export const socketAuth = (io) => {
  io.use(verifySocketToken);
};
