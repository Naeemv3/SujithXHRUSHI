const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");
require("dotenv").config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

exports.generateQuiz = functions.https.onCall(async (data, context) => {
  const { skill } = data;
  const model = genAI.getGenerativeModel({ model: "gemini-pro" });

  const prompt = `
  Create a skill-based quiz on "${skill}".
  Include:
  - 3 Easy MCQs
  - 4 Medium MCQs
  - 3 Hard MCQs
  - 5 Written questions for conceptual understanding
  Output format:
  [
    {
      "type": "mcq",
      "difficulty": "easy",
      "question": "What is ...?",
      "options": ["A", "B", "C", "D"],
      "answer": "B"
    },
    ...
  ]
  `;

  try {
    const result = await model.generateContent(prompt);
    const text = result.response.text();
    return { success: true, quiz: text };
  } catch (err) {
    console.error("Gemini Error:", err);
    return { success: false, error: err.toString() };
  }
});

