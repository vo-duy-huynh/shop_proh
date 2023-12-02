const express = require('express');
const mongoose = require('mongoose');
const User = require('../models/user');
const bycrypt = require('bcryptjs');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');

authRouter.post('/api/signup',async (req, res) => {
    try{
        const {name, email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: 'Email đã tồn tại!' });
        }
        const passwordHash = await bycrypt.hash(password, 8);
        let user = new User({
            name,
            email,
            password: passwordHash,
        });
        user = await user.save();
        res.json(user);
    }
    catch(err){
        res.status(500).send(err);
    }
});

authRouter.post('/api/login', async (req, res) => {
    try{
        const { email, password } = req.body;
        // so sánh password
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: 'Email không tồn tại!' });
        }
        const isMatch = await bycrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: 'Mật khẩu không đúng!' });
        }

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
        res.json({
            token,
            ...user._doc,
        });


    }
    catch(err){
        res.status(500).send(err);
    }
}
);

authRouter.get('/api/tokenIsValid', async (req, res) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified) return res.json(false);
        const user =await User.findById(verified.id);
        if (!user) return res.json(false);
        return res.json(true);
    }
    catch(err){
        res.status(500).send(err);
    }
});

authRouter.get('/', auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({
        ...user._doc,
        token: req.token,
    });
}
);



module.exports = authRouter;