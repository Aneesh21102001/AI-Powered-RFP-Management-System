const OpenAI = require("openai");
require("dotenv").config();

const client = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

async function parseRfpFromText(text) {
  const prompt = `
    Convert this procurement request into structured JSON only. 
    DO NOT wrap the JSON in markdown code blocks.

    Required format:
    {
      "title": string,
      "description": string,
      "items": [
        {
          "name": string,
          "qty": number,
          "specs": object
        }
      ],
      "totalBudget": number?,
      "deliveryDays": number?,
      "paymentTerms": string?,
      "warrantyMonthsMin": number?
    }

    Text:
    """${text}"""
  `;

  const response = await client.chat.completions.create({
    model: "gpt-4.1-mini",
    messages: [{ role: "user", content: prompt }],
  });

  let content = response.choices[0].message.content.trim();

  // 🔥 Remove markdown code fences if present
  if (content.startsWith("```")) {
    content = content.replace(/```json|```/g, "").trim();
  }

  try {
    return JSON.parse(content);
  } catch (err) {
    return { error: "Invalid JSON from AI", raw: content };
  }
}

module.exports = { parseRfpFromText };
