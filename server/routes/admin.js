const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const  {Product}  = require("../models/product");
const Order = require("../models/order");
const Category = require("../models/category");
// const Order = require("../models/order");
// const { PromiseProvider } = require("mongoose");
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    const categoryRes = await Category.findById(category);
    if (!category) {
      return res.status(400).json({ msg: "Invalid category ID" });
    }
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category: categoryRes._id, // Assign the category ID
    });

    // Save the product to the database
    product = await product.save();

    if (!product) {
      return res.status(400).json({ msg: "Thêm sản phẩm thất bại!" });
    }

    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.put("/admin/update-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const {  name, description, images, quantity, price, category } = req.body;

    const categoryRes = await Category.findById(category);
    if (!categoryRes) {
      return res.status(400).json({ msg: "Invalid category ID" });
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
      return res.status(400).json({ msg: "Cập nhật sản phẩm thất bại!" });
    }

    res.json(product);
  }
  catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.delete("/admin/delete-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return res.status(400).json({ msg: "Xóa sản phẩm thất bại!" });
    }
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
adminRouter.get("/admin/get-products", admin, async (req, res) => {
    try {
        const products = await Product.find({});
        if (!products) {
        return res.status(400).json({ msg: "Không có sản phẩm nào!" });
        }
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
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

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
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
module.exports = adminRouter;