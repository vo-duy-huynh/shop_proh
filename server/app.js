
const express = require('express');
const dotenv = require('dotenv');
const path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const envPath = path.resolve(__dirname, '..', '.env');
dotenv.config({ path: envPath });
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
const categoryRouter = require('./routes/category');
const app = express();
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(categoryRouter);
DB_URI = process.env.MONGOOSE_URI;
console.log(DB_URI);
// mongoose.connect(`${DB_URI}`).then(() => {
//     console.log('Connected to MongoDB');
// }).catch((err) => {
//     console.log('Error connecting to MongoDB', err);
// });

mongoose.connect('mongodb://127.0.0.1:27017/shop_proh').then(
  function () {
    console.log("connect");
  }
).catch(function (err) {
  console.log(err);
})

// app.listen(process.env.PORT,'0.0.0.0' ,() => {
//     console.log(`Server is running on port ${process.env.PORT}`);
// });

//localhost:3000/api/v1
app.use('/api/v1/', require('./routes/index'));

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.send(err.message);
});

module.exports = app;