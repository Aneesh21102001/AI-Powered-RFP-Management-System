// src/server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors');

const { parseRfpFromText } = require("./aiService");
const prisma = require("./prismaClient");   // <-- FIXED HERE

const app = express();
app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Create RFP from natural language
app.post("/api/rfps/from-text", async (req, res) => {
  try {
    const { text } = req.body;

    // 1. Convert NLP → structured JSON
    const structured = await parseRfpFromText(text);

    if (structured.error) {
      return res.status(400).json(structured);
    }

    // 2. Save to DB
    const rfp = await prisma.rfp.create({
      data: {
        title: structured.title || "Untitled RFP",
        description: text,
        structured: JSON.stringify(structured),
        totalBudget: structured.totalBudget || null,
        deliveryDays: structured.deliveryDays || null,
      },
    });

    res.json(rfp);
  } catch (err) {
    console.error("Error creating RFP:", err);
    res.status(500).json({ error: err.message });
  }
});

// Start server
const port = process.env.PORT || 4000;
app.listen(port, () => console.log(`Server listening on ${port}`));
