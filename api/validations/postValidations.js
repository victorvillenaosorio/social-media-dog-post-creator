const Joi = require('joi');

const postCreationSchema = Joi.object({
    message: Joi.string().required(),
    imageUrl: Joi.string().uri().required(),
    hashtags: Joi.array().items(Joi.string()).required(),
    scheduledDate: Joi.date().optional()
});

const validatePostCreation = (req, res, next) => {
    const { error } = postCreationSchema.validate(req.body);
    if (error) {
        return res.status(400).json({ message: error.details[0].message });
    }
    next();
};

const postUpdateSchema = Joi.object({
    id: Joi.string().required(),
    message: Joi.string().required(),
    imageUrl: Joi.string().uri().required(),
    hashtags: Joi.array().items(Joi.string()).required(),
    scheduledDate: Joi.date().optional()
});

const validatePostUpdate = (req, res, next) => {
    const { error } = postUpdateSchema.validate(req.body);
    if (error) {
        return res.status(400).json({ message: error.details[0].message });
    }
    next();
};

module.exports = { validatePostCreation, validatePostUpdate };