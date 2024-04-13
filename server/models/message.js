var mongoose = require('mongoose');

var messageSchema = new mongoose.Schema({
    from: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    to: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    group: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Group'
    },
    message : {
        type: String,
        required: true
    },
}, { timestamps: true });

module.exports = mongoose.model('Message', messageSchema);
