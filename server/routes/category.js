const express = require("express");
const categoryRouter = express.Router();
const admin = require("../middlewares/admin");
const Category = require("../models/category");

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
      return res.status(400).json({ msg: "Thêm danh mục thất bại!" });
    }
    res.json(category);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

categoryRouter.get("/admin/get-categories", admin, async (req, res) => {
  try {
    const categories = await Category.find({});
    if (!categories) {
      return res.status(400).json({ msg: "Không có danh mục nào!" });
    }
    res.json(categories);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

categoryRouter.delete("/admin/delete-category/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.findByIdAndDelete(id);
    if (!category) {
      return res.status(400).json({ msg: "Xóa danh mục thất bại!" });
    }
    res.json(category);
  } catch (e) {
    res.status(500).json({ error: e.message });
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
            return res.status(400).json({ msg: "Cập nhật danh mục thất bại!" });
        }
        res.json(category);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }     
});
module.exports = categoryRouter;