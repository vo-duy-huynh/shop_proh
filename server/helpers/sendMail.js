const nodemailer = require("nodemailer");
var path = require('path');
var envPath = path.resolve(__dirname, '../..', '.env');
require('dotenv').config({ path: envPath });
const transporter = nodemailer.createTransport({
    host: process.env.MAIL_HOST,
    port: process.env.MAIL_PORT,
    secure: false, // Use `true` for port 465, `false` for all other ports
    auth: {
        user: process.env.MAIL_USERNAME, // generated ethereal user
        pass: process.env.MAIL_PASSWORD, // generated ethereal password
    },
});

// async..await is not allowed in global scope, must use a wrapper
module.exports = async function (desEmail, otp_code, name) {
    // send mail with defined transport object
    const info = await transporter.sendMail({
        from: 'huynhpro@gmail.com', // sender address
        to: desEmail, // list of receivers
        subject: "Xác Minh OTP", // Subject line
        html: `
            <html>
                <head>
                    <style>
                        /* Add your CSS styles here */
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f4f4;
                            color: #333;
                        }
                        .container {
                            max-width: 600px;
                            margin: 0 auto;
                            padding: 20px;
                            background-color: #fff;
                            border-radius: 10px;
                            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                        }
                        .otp {
                            font-size: 24px;
                            text-align: center;
                            margin-bottom: 20px;
                        }
                        .code {
                            font-size: 32px;
                            color: #007bff;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="otp">
                            <p>Xin chào <strong>${name}</strong>,</p>
                            <p>Mã OTP của bạn là:</p>
                            <p class="code"><strong>${otp_code}</strong></p>
                        </div>
                    </div>
                </body>
            </html>
        `, // HTML body
    });

    // console.log("Message sent: %s", info.messageId);
    // Message sent: <d786aa62-4e0a-070a-47ed-0b0666549519@ethereal.email>
}
