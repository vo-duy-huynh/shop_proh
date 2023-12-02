const jwt = require('jsonwebtoken');
const User = require('../models/user');

const admin = async (req, res, next) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) {
            return res.status(401).json({ msg: 'Không có token, quyền truy cập bị từ chối!' });
        }
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified) {
            return res.status(401).json({ msg: 'Token không hợp lệ!' });
        }
        const user = await User.findById(verified.id);
        if(user.type == 'user' || user.type == 'seller'){
            return res.status(401).json({ msg: 'Bạn không phải là admin!' });
        }
        req.user = verified.id;
        req.token = token;
        next();
    }
    catch(err){
        res.status(500).json({ error: err.message });
    }
}

module.exports = admin;