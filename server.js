const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

// Parse incoming JSON request bodies
app.use(express.json());

// Health check endpoint - crucial for AWS target groups and pipeline validation
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || "1.0.0",
  });
});

// Root endpoint - returns basic service info
app.get("/", (req, res) => {
  res.status(200).json({
    service: "infra-test-app",
    message: "Infrastructure Test Pipeline API",
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});