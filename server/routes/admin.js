var express = require("express");
var adminRouter = express.Router();
var admin = require("../middlewares/admin");
var  {Product}  = require("../models/product");
var Order = require("../models/order");
var Category = require("../models/category");
var responseHandle = require('../helpers/responseHandle');
// const Order = require("../models/order");
// const { PromiseProvider } = require("mongoose");
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    const categoryRes = await Category.findById(category);
    if (!category) {
      return responseHandle.renderResponse(res, false, "Invalid category ID");
    }
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category: categoryRes._id, // Assign the category ID
    });

    product = await product.save();

    if (!product) {
      return responseHandle.renderResponse(res, false, "Thêm sản phẩm thất bại!");
    }

    responseHandle.renderResponse(res, true, product);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

adminRouter.put("/admin/update-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const {  name, description, images, quantity, price, category } = req.body;

    const categoryRes = await Category.findById(category);
    if (!categoryRes) {
      return responseHandle.renderResponse(res, false, "Invalid category ID");
    }
    let product = await Product.findById(id);
    product.name = name;
    product.description = description;
    product.images = images;
    product.quantity = quantity;
    product.price = price;
    product.category = categoryRes._id;
    product = await product.save();
    if (!product) {
      return responseHandle.renderResponse(res, false, "Cập nhật sản phẩm thất bại!");
    }

    responseHandle.renderResponse(res, true, product);
  }
  catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

adminRouter.delete("/admin/delete-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return responseHandle.renderResponse(res, false, "Xóa sản phẩm thất bại!");
    }
    res.json(product);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});
adminRouter.get("/admin/get-products", admin, async (req, res) => {
    try {
        const products = await Product.find({});
        if (!products) {
        return responseHandle.renderResponse(res, false, "Không có sản phẩm nào!");
        }
        responseHandle.renderResponse(res, true, products);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    if (!orders) {
      return responseHandle.renderResponse(res, false, "Không có đơn hàng nào!");
    }
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    responseHandle.renderResponse(res, true, order);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    responseHandle.renderResponse(res, true, earnings);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  let categoryOrders = await Order.find({
    "products.product.category": category,
  });

  for (let i = 0; i < categoryOrders.length; i++) {
    for (let j = 0; j < categoryOrders[i].products.length; j++) {
      earnings +=
        categoryOrders[i].products[j].quantity *
        categoryOrders[i].products[j].product.price;
    }
  }
  return earnings;
}

// /admin/admin/get-user-name/:userId
// Get user name by user ID
adminRouter.get("/admin/get-user-name/:userId", admin, async (req, res) => {
  try {
    const { userId } = req.params;
    const order = await Order.findOne({ _id: userId });
    responseHandle.renderResponse(res, true, order.user.name);
  } catch (e) {

    responseHandle.renderResponse(res, false, e.message);
  }
}
);
module.exports = adminRouter;