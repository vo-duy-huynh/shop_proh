
const express = require('express');
const dotenv = require('dotenv');
const path = require('path');
const envPath = path.resolve(__dirname, '..', '.env');
dotenv.config({ path: envPath });
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const app = express();

app.use(express.json())

app.use(authRouter);
DB_URI = process.env.MONGOOSE_URI;
mongoose.connect(`${DB_URI}`).then(() => {
    console.log('Connected to MongoDB');
}).catch((err) => {
    console.log('Error connecting to MongoDB', err);
});

app.listen(process.env.PORT,'0.0.0.0' ,() => {
    console.log(`Server is running on port ${process.env.PORT}`);
});