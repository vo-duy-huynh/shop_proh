const jwt = require('jsonwebtoken');
const User = require('../models/user');
var responseHandle = require('../helpers/responseHandle');

const admin = async (req, res, next) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) {
            return responseHandle.renderResponse(res, false, 'Không có token, quyền truy cập bị từ chối!');
        }
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified) {
            return responseHandle.renderResponse(res, false, 'Token không hợp lệ!');
        }
        const user = await User.findById(verified.id);
        if(user.type == 'user' || user.type == 'mod'){
            return responseHandle.renderResponse(res, false, 'Bạn không có quyền truy cập!');
        }
        req.user = verified.id;
        req.token = token;
        next();
    }
    catch(err){
        return responseHandle.renderResponse(res, false, err.message);
    }
}

module.exports = admin;