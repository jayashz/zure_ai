import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";
dotenv.config({ path: "./keys.env" }); // 👈 This must be called before accessing process.env

const ai = new GoogleGenAI({
  apiKey: process.env.gem_Api,
});

export const getAIResponse = async (msg) => {
  try {
    const response = await ai.models.generateContent({
      model: "gemini-2.0-flash-001",
      contents: msg,
    });
    return response.text;
  } catch (err) {
    console.error("Gemini error:", err);
    return "Sorry, I couldn't process that.";
  }
};
