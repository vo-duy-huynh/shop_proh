var express = require('express');
var mongoose = require('mongoose');
var User = require('../models/user');
var bcrypt = require('bcrypt');
var authRouter = express.Router();
var jwt = require('jsonwebtoken');
var auth = require('../middlewares/auth');
var otpGenerator = require("otp-generator");
let sendmail = require('../helpers/sendMail');
var responseHandle = require('../helpers/responseHandle');
const e = require('express');


authRouter.post('/changepassword', auth, async function (req, res, next) {
    let result = bcrypt.compareSync(req.body.oldpassword, req.user.password);
    if (result) {
      let user = req.user;
      user.password = req.body.newpassword;
      await user.save();
      responseHandle.renderResponse(res, true, user);
    } else {
      responseHandle.renderResponse(res, false, "Mật khẩu cũ không đúng");
    }
  
});
  
  
  
authRouter.post("/forgotPassword", async function (req, res, next) {
    try {
      const email = req.body.email;
      const user = await User.findOne({ email: email });
      if (!user) {
        responseHandle.renderResponse(res, false, "Email không tồn tại");
        return;
      }
      let otp = user.genResetPasswordOTP();
      await user.save();
  
      await sendmail(email,otp, user.name);
  
      responseHandle.renderResponse(res, true, "OTP đã được gửi đến email của bạn");
    } catch (error) {
      responseHandle.renderResponse(res, false, error.message);
    }
});
  
authRouter.post('/resetpassword', async function (req, res, next) {
    try{
        let user = await User.findOne({
            resetPasswordOTP : req.body.otp,
        })
        if (!user) {
          responseHandle.renderResponse(res, false, "OTP không hợp lệ hoặc đã hết hạn");
          return;
        }
        else {
          if (user.resetPasswordOTPExpires < Date.now()) {
            responseHandle.renderResponse(res, false, "OTP hết hạn hoặc đã sử dụng");// đỡ hacker check :))
            return;
          }
        }
        responseHandle.renderResponse(res, true, user);
    }
    catch(err){
        responseHandle.renderResponse(res, false, err.message);
    }
});

authRouter.put('/resetpassword', async function (req, res, next) {
    try{
        let user = await User.findOne({ email: req.body.email });
        if (!user) {
            responseHandle.renderResponse(res, false, "OTP không hợp lệ");
            return;
        }
        user.password = req.body.password;
        user.resetPasswordOTP = undefined;
        user.resetPasswordOTPExpires = undefined;
        await user.save();
        responseHandle.renderResponse(res, true, user);
    }
    catch(err){
        responseHandle.renderResponse(res, false, err.message);
    }
});
authRouter.post('/signup',async (req, res) => {
    try{
        const {name, email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            responseHandle.renderResponse(res, false, 'Email đã tồn tại!');
            return;
        }
        let user = new User({
            name,
            email,
            password: password,
        });
        user = await user.save();
        responseHandle.renderResponse(res, true, user);
    }
    catch(err){
        responseHandle.renderResponse(res, false, err.message);
    }
});

authRouter.post('/login', async (req, res) => {
    try{
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            responseHandle.renderResponse(res, false, 'Email không tồn tại!');
            return;
        }
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            responseHandle.renderResponse(res, false, 'Mật khẩu không đúng!');
            return;
        }

        let token = user.genJWT();
        responseHandle.renderResponse(res, true, {
            token,
            ...user._doc,
        });
    }
    catch(err){
        responseHandle.renderResponse(res, false, err.message);
    }
}
);

authRouter.get('/tokenIsValid', async (req, res) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) {
            responseHandle.renderResponse(res, false, 'Token không hợp lệ!');
            return;
        }
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (!verified){
            responseHandle.renderResponse(res, false, 'Token không hợp lệ!');
            return;
        }
        const user =await User.findById(verified.id);
        if (!user){
            responseHandle.renderResponse(res, false, 'User không tồn tại!');
            return;
        }
        return responseHandle.renderResponse(res, true, true);
    }
    catch(err){
        responseHandle.renderResponse(res, false, err.message);
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