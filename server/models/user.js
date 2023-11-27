const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
                return value.match(re);
            },
            message: "Hãy nhập một email hợp lệ!",
        },
    },
    password: {
        required: true,
        type: String,
        validate: {
            validator: (value) => {
                this.length >= 6;
            },
            message: "Mật khẩu phải có ít nhất 6 ký tự!",
        },
    },
    address: {
        type: String,
        default: "",
    },
    type: {
        type: String,
        default: "user",
    },
});

const User = mongoose.model('User', userSchema);

module.exports = User;