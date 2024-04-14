var mongoose = require("mongoose");
var { productSchema } = require("./product");
var otpGenerator = require('otp-generator');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
    unique: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Hãy nhập đúng định dạng email",
    },
  },
  password: {
    required: true,
    type: String,
    validate: {
      validator: (value) => {
        const re = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$/gm;
        return value.match(re);
      },
      message: "Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ thường, chữ hoa và số",
    }
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },
  resetPasswordOTP: String,
  resetPasswordOTPExpires: String,
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        default: 0,
      },
    },
  ],
  wishlist: [
    {
      product: productSchema,
    },
  ]
}, { timestamps: true });

userSchema.pre('save', function () {
  if (this.isModified('password')) {
      this.password = bcrypt.hashSync(this.password, 10);
  }
})

userSchema.methods.genJWT = function () {
  return jwt.sign({
      id: this._id
  }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
}

userSchema.methods.genResetPasswordOTP = function () {
  let digits = '0123456789'; 
    let OTP = ''; 
    let len = digits.length 
    for (let i = 0; i < 6; i++) { 
        OTP += digits[Math.floor(Math.random() * len)]; 
    } 
     
  this.resetPasswordOTP = OTP;
  this.resetPasswordOTPExpires = Date.now() + 120000;
  return this.resetPasswordOTP;
}


const User = mongoose.model("User", userSchema);
module.exports = User;