const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
// const Order = require("../models/order");
// const { PromiseProvider } = require("mongoose");

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    if (!product) {
      return res.status(400).json({ msg: "Thêm sản phẩm thất bại!" });
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
module.exports = adminRouter;