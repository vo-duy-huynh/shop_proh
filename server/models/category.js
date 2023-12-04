const mongoose = require("mongoose");

const categorySchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  imageCover: {
    type: String,
    trim: true,
    default: "https://res.cloudinary.com/dvcwwbrqw/image/upload/v1701669723/CATEGORIES/DEFAULT/u21ay6q55xkererdgm05.png",
  },
  description: {
    type: String,
    trim: true,
  },
});

const Category = mongoose.model("Category", categorySchema);

module.exports = Category;