var express = require("express");
var userRouter = express.Router();
var auth = require("../middlewares/auth");
var { Product } = require("../models/product");
var User = require("../models/user");
var Order = require("../models/order");
var responseHandle = require('../helpers/responseHandle');

userRouter.post("/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

userRouter.delete("/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

userRouter.post("/add-to-wishlist", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    let isProductFound = false;
    for (let i = 0; i < user.wishlist.length; i++) {
      if (user.wishlist[i].product._id.equals(product._id)) {
        isProductFound = true;
        user.wishlist.splice(i, 1);
        break;
      }
    }

    if (!isProductFound) {
      user.wishlist.push({ product });
    }

    user = await user.save();
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});
userRouter.post("/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

userRouter.post("/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address, date, phoneNumber } = req.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({ product, quantity: cart[i].quantity });
        await product.save();
      } else {
        return responseHandle.renderResponse(res, false, `${product.name} is out of stock!`);
      }
    }

    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      date,
      address,
      phoneNumber,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();
    responseHandle.renderResponse(res, true, order);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

userRouter.get("/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    responseHandle.renderResponse(res, true, orders);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});


// get cart of user'
userRouter.get("/cart", auth, async (req, res) => {
  try {
    let user = await User.findById(req.user);
    responseHandle.renderResponse(res, true, user.cart);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

// add to wishlist
userRouter.post("/add-to-wishlist", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.wishList.length == 0) {
      user.wishList.push({ product});
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.wishList.length; i++) {
        if (user.wishList[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.wishList.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.wishList.push({ product});
      }
    }
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

// get user name by userId
userRouter.get("/users/:id", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});
//tạo 1 api ảo xuất 2 người dùng
userRouter.get("/users", async (req, res) => {
  try {
    //tạo 1 json user
    const user = {
      name: "Nguyen Van A",
      email: "aa@"
    }
    responseHandle.renderResponse(res, true, user);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});
module.exports = userRouter;