var express = require("express");
var chatRouter = express.Router();
var admin = require("../middlewares/admin");
var chat = require("../models/message");
var room = require("../models/group");
var auth = require("../middlewares/auth");
var responseHandle = require('../helpers/responseHandle');

chatRouter.post("/messages", admin, async (req, res) => {
  try {
    const message = new chat({
        from: req.body.from,
        to: req.body.to,
        group: req.body.group,
        message: req.body.message
    });
    const savedMessage = await message.save();
    if (!savedMessage) {
        return responseHandle.renderResponse(res, false, "Gửi tin nhắn thất bại!");
    }
    responseHandle.renderResponse(res, true, savedMessage);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

chatRouter.get("/messages/:userId", auth, async (req, res) => {
  try {
    const { userId } = req.params;
    const messages = await chat.find({ to: userId }).populate("from").populate("to").populate("group");
    if (!messages) {
      return responseHandle.renderResponse(res, false, "Không có tin nhắn nào!");
    }
    responseHandle.renderResponse(res, true, messages);
  } catch (e) {
    responseHandle.renderResponse(res, false, e.message);
  }
});

chatRouter.delete("/message/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;
        const message = await chat.findByIdAndDelete(id);
        if (!message) {
            return responseHandle.renderResponse(res, false, "Xóa tin nhắn thất bại!");
        }
        responseHandle.renderResponse(res, true, message);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.get("/messages/:groupId", auth, async (req, res) => {
    try {
        const { groupId } = req.params;
        const messages = await chat.find({ group: groupId }).populate("from").populate("to").populate("group");
        if (!messages) {
            return responseHandle.renderResponse(res, false, "Không có tin nhắn nào!");
        }
        responseHandle.renderResponse(res, true, messages);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.post("/group", admin, async (req, res) => {
    try {
        const group = new room({
            name: req.body.name,
            admin: req.body.admin,
            members: req.body.members
        });
        const savedGroup = await group.save();
        if (!savedGroup) {
            return responseHandle.renderResponse(res, false, "Tạo nhóm thất bại!");
        }
        responseHandle.renderResponse(res, true, savedGroup);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.get("/groups", auth, async (req, res) => {
    try {
        const groups = await room.find({}).populate("admin").populate("members");
        if (!groups) {
            return responseHandle.renderResponse(res, false, "Không có nhóm nào!");
        }
        responseHandle.renderResponse(res, true, groups);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.delete("/group/:id", auth, async (req, res) => {
    try {
        const { id, userId } = req.params;
        const group = await room.findById(id);
        if (group.admin != userId) {
            return responseHandle.renderResponse(res, false, "Bạn không phải admin của group!");
        }

        const group2 = await room.findByIdAndDelete(id);
        if (!group2) {
            return responseHandle.renderResponse(res, false, "Xóa group thất bại!");
        }
        responseHandle.renderResponse(res, true, group2);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.put("/group/:id", auth, async (req, res) => {
    try {
        const { id, userId } = req.params;
        const { name } = req.body;
        const { admin } = req.body;
        const { members } = req.body;
        const group = await room.findById(id);
        if (group.admin != userId) {
            return responseHandle.renderResponse(res, false, "Bạn không phải admin của group!");
        }

        let group2 = await room.findById(id);
        group2.name = name;
        group2.admin = admin;
        group2.members = members;
        group2 = await group2.save();
        if (!group2) {
            return responseHandle.renderResponse(res, false, "Cập nhật group thất bại!");
        }
        responseHandle.renderResponse(res, true, group2);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});

chatRouter.get("/group/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;
        const group = await room.findById(id).populate("admin").populate("members");
        if (!group) {
            return responseHandle.renderResponse(res, false, "Không tìm thấy group!");
        }
        responseHandle.renderResponse(res, true, group);
    } catch (e) {
        responseHandle.renderResponse(res, false, e.message);
    }
});



module.exports = chatRouter;