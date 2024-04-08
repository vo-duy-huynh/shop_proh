module.exports = {
    renderResponse: function (res, success, data) {
        if (success) {
            res.status(200).json({
                success: true,
                data: data
            });
        } else {
            res.status(404).json({
                success: false,
                data: data
            });
        }
    }
};
