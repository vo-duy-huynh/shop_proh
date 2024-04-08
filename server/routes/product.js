const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const Category = require("../models/category");
var responseHandle = require('../helpers/responseHandle');

productRouter.get("/products/", auth, async (req, res) => {
  try {
    const products = await Product.find({ category: req.query.category });
    responseHandle.renderResponse(res, true, products);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

productRouter.get("/products/search/:name", auth, async (req, res) => {
    try {
      const searchTerm = req.params.name;
      const products = await Product.find({
        $or: [
          { name: { $regex: searchTerm, $options: "i" } },
        ],
      });
      let category = await Category.findOne({
        name: { $regex: searchTerm, $options: "i" },
      });
      if (category) {
        const productList = await Product.find({ category: category._id });
        responseHandle.renderResponse(res, true, productList);
      }
      else {
        responseHandle.renderResponse(res, true, products);
      }
    } catch (e) {
      responseHandle.renderResponse(res, false, e.message);
    }
  });

productRouter.post("/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);
    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }
    const ratingSchema = {
      userId: req.user,
      rating,
    };
    product.ratings.push(ratingSchema);
    product = await product.save();
    responseHandle.renderResponse(res, true, product);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

productRouter.get("/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    responseHandle.renderResponse(res, true, products[0]);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});
// get all

productRouter.get("/all-products", auth, async (req, res) => {
  try {
    const products = await Product.find({});
    responseHandle.renderResponse(res, true, products);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

// fetch product by category
productRouter.get("/products/:category", async (req, res) => {
  try {
    // nếu không có category thì lấy tất cả sản phẩm
    if (req.params.category === 'All') {
      const products = await Product.find({});
      return responseHandle.renderResponse(res, true, products);
    }
    const products = await Product.find({ category: req.params.category });
    responseHandle.renderResponse(res, true, products);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
}
);
module.exports = productRouter;