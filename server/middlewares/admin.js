const jwt = require('jsonwebtoken');
const User = require('../models/user');
var responseHandle = require('../helpers/responseHandle');

const admin = async (req, res, next) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) {
            return responseHandle.renderResponse(res, false, 'Không có token, quyền truy cập bị từ chối!');
            // return res.status(401).json({ msg: 'Không có token, quyền truy cập bị từ chối!' });
        }
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified) {
            return responseHandle.renderResponse(res, false, 'Token không hợp lệ!');
            // return res.status(401).json({ msg: 'Token không hợp lệ!' });
        }
        const user = await User.findById(verified.id);
        if(user.type == 'user' || user.type == 'seller'){
            return responseHandle.renderResponse(res, false, 'Bạn không phải là admin!');
            // return res.status(401).json({ msg: 'Bạn không phải là admin!' });
        }
        req.user = verified.id;
        req.token = token;
        next();
    }
    catch(err){
        return responseHandle.renderResponse(res, false, err.message);
        // res.status(500).json({ error: err.message });
    }
}

module.exports = admin;