const express = require('express');
const cors = require('cors');
const postRoutes = require('./routes/posts');

const app = express();
const port = 3000;

const corsOptions = {
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  optionsSuccessStatus: 200
};

app.use(cors(corsOptions));
app.use(express.json());

app.use(postRoutes);

app.listen(port, () => {
    console.log(`Server running: http://localhost:${port}`);
});
