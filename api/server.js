const express = require('express');
const axios = require('axios');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');
const { phrases, hashtags } = require('./data');
const { randomDogApiUrl } = require('./config'); // Import the URL from config

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

let posts = [];

const mp4Extension = '.mp4';

app.get('/post', async (req, res) => {
    try {
        let attempts = 0;
        let response;
        let url;

        do {
            response = await axios.get(randomDogApiUrl);
            url = response.data.url;
            attempts++;
        } while (url.endsWith(mp4Extension) && attempts < 5);

        if (url.endsWith(mp4Extension)) {
            return res.status(500).json({ message: "Failed to fetch a valid image URL after 5 attempts" });
        }

        const randomMessage = phrases[Math.floor(Math.random() * phrases.length)];
        const randomHashtags = hashtags.sort(() => 0.5 - Math.random()).slice(0, 2);

        res.json({
            message: randomMessage,
            imageUrl: url,
            hashtags: randomHashtags
        });
    } catch (error) {
        res.status(500).json({ message: "Error while trying to create the image", error: error.message });
    }
});

app.post('/post', (req, res) => {
    const { message, imageUrl, hashtags, scheduledDate } = req.body;
    if (!message || !imageUrl || !hashtags) {
        return res.status(400).json({ message: "All fields are required" });
    }
    const newPost = { id: uuidv4(), message, imageUrl, hashtags, scheduledDate };
    posts.push(newPost);
    res.status(201).json(newPost);
});

app.put('/post', (req, res) => {
    const { id, message, imageUrl, hashtags, scheduledDate } = req.body;

    if (!id || !message || !imageUrl || !hashtags) {
        return res.status(400).json({ message: "All fields are required" });
    }

    const postIndex = posts.findIndex(post => post.id === id);

    if (postIndex === -1) {
        return res.status(404).json({ message: "Post not found" });
    }

    posts[postIndex] = { id, message, imageUrl, hashtags, scheduledDate };

    res.status(200).json(posts[postIndex]);
});

app.delete('/post/:id', (req, res) => {
    const { id } = req.params;
    const postIndex = posts.findIndex(post => post.id === id);

    if (postIndex === -1) {
        return res.status(404).json({ message: "Post not found" });
    }

    posts.splice(postIndex, 1);
    res.status(200).json({ message: "Post deleted successfully" });
});

app.get('/posts', (req, res) => {
    res.json(posts);
});

app.listen(port, () => {
    console.log(`Server running: http://localhost:${port}`);
});
