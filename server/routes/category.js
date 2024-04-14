var express = require("express");
var categoryRouter = express.Router();
var admin = require("../middlewares/admin");
var Category = require("../models/category");
var auth = require("../middlewares/auth");
var responseHandle = require('../helpers/responseHandle');

categoryRouter.post("/admin/add-category", admin, async (req, res) => {
  try {
    const { name, imageCover, description } = req.body;
    let category = new Category({
      name,
      imageCover,
      description,
    });
    category = await category.save();
    if (!category) {
      return responseHandle.renderResponse(res, false, "Thêm danh mục thất bại!");
    }
    responseHandle.renderResponse(res, true, category);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

categoryRouter.get("/admin/get-categories", auth, async (req, res) => {
  try {
    const categories = await Category.find({});
    if (!categories) {
      return responseHandle.renderResponse(res, false, "Không có danh mục nào!");
    }
    responseHandle.renderResponse(res, true, categories);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

categoryRouter.delete("/admin/delete-category/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.findByIdAndDelete(id);
    if (!category) {
      return responseHandle.renderResponse(res, false, "Xóa danh mục thất bại!");
    }
    responseHandle.renderResponse(res, true, category);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

categoryRouter.put("/admin/update-category/:id", admin, async (req, res) => {
    try {
        const { id } = req.params;
        const { name } = req.body;
        const { imageCover } = req.body;
        const { description } = req.body;
        let category = await Category.findById(id);
        category.name = name;
        category.imageCover = imageCover;
        category.description = description;
        category = await category.save();
        if (!category) {
            return responseHandle.renderResponse(res, false, "Cập nhật danh mục thất bại!");
        }
        responseHandle.renderResponse(res, true, category);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }     
});
categoryRouter.get("/get-top-categories", async (req, res) => {
  try {
    const categories = await Category.find({});
    if (!categories) {
      return responseHandle.renderResponse(res, false, "Không có danh mục nào!");
    }
    responseHandle.renderResponse(res, true, categories.slice(0, 6));
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

categoryRouter.get("/get-categoryname/:categoryid", async (req, res) => {
  try {
    const { categoryid } = req.params;
    const category = await Category.findById(categoryid);
    if (!category) {
      return responseHandle.renderResponse(res, false, "Không có danh mục nào!");
    }
    responseHandle.renderResponse(res, true, category.name);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
}
);
module.exports = categoryRouter;