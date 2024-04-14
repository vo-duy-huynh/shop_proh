const mongoose = require('mongoose');

const groupSchema = new mongoose.Schema({
    name: String,
    admin: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    members: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }]
}, { timestamps: true });

module.exports = mongoose.model('Group', groupSchema);