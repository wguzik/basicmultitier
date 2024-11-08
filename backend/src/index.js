const express = require('express');
const cors = require('cors');
const todoRoutes = require('./routes/todos');

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api', todoRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
}); 