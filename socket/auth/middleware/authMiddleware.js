import jwt from "jsonwebtoken";
const { verify } = jwt;

export const secret = "Criticalityfity";

export function verifyToken(req, res, next) {
  console.log(
    "Recieved token in verifyToken:",
    req.headers["authorization"]?.split(" ")[1]
  );
  const token = req.headers["authorization"]?.split(" ")[1];
  if (!token) return res.status(403).json({ message: "No token provided" });

  verify(token, secret, (err, decoded) => {
    if (err) return res.status(401).json({ message: "Unauthorized" });
    req.user = decoded;
    next();
  });
}

export function verifySocketToken(socket, next) {
  console.log(
    "Recieved token in verifySocketToken:",
    socket.handshake.auth?.token
  );
  const token = socket.handshake.auth?.token;
  if (!token) return next(new Error("No token provided"));

  verify(token, secret, (err, decoded) => {
    if (err) {
      console.error("JWT error:", err.message); 
      return next(new Error("Unauthorized"));
    }
    socket.user = decoded;
    next();
  });
}
