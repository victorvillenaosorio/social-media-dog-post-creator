const express = require('express');
const {
    getRandomPost,
    createPost,
    updatePost,
    deletePost,
    getAllPosts
} = require('../controllers/postsController');
const { validatePostCreation, validatePostUpdate } = require('../middlewares/validatePost');

const router = express.Router();

router.get('/post', getRandomPost);
router.post('/post', validatePostCreation, createPost);
router.put('/post', validatePostUpdate, updatePost);
router.delete('/post/:id', deletePost);
router.get('/posts', getAllPosts);

module.exports = router;