const { v4: uuidv4 } = require('uuid');
const axios = require('axios');
const { phrases, hashtags } = require('../data');
const { randomDogApiUrl, maxRetryAttempts } = require('../config');

let posts = [];
const mp4Extension = '.mp4';

const getRandomPost = async (req, res) => {
    try {
        let attempts = 0;
        let response;
        let url;

        do {
            response = await axios.get(randomDogApiUrl);
            url = response.data.url;
            attempts++;
        } while (url.endsWith(mp4Extension) && attempts < maxRetryAttempts);

        if (url.endsWith(mp4Extension)) {
            return res.status(500).json({ message: "Failed to fetch a valid image URL after maximum retry attempts" });
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
};

const createPost = (req, res) => {
    const { message, imageUrl, hashtags, scheduledDate } = req.body;
    const newPost = { id: uuidv4(), message, imageUrl, hashtags, scheduledDate };
    posts.push(newPost);
    res.status(201).json(newPost);
};

const updatePost = (req, res) => {
    const { id, message, imageUrl, hashtags, scheduledDate } = req.body;

    const postIndex = posts.findIndex(post => post.id === id);

    if (postIndex === -1) {
        return res.status(404).json({ message: "Post not found" });
    }

    posts[postIndex] = { id, message, imageUrl, hashtags, scheduledDate };
    res.status(200).json(posts[postIndex]);
};

const deletePost = (req, res) => {
    const { id } = req.params;
    const postIndex = posts.findIndex(post => post.id === id);

    if (postIndex === -1) {
        return res.status(404).json({ message: "Post not found" });
    }

    posts.splice(postIndex, 1);
    res.status(200).json({ message: "Post deleted successfully" });
};

const getAllPosts = (req, res) => {
    res.json(posts);
};

module.exports = {
    getRandomPost,
    createPost,
    updatePost,
    deletePost,
    getAllPosts
};