const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
// nodeMailer
const nodemailer = require("nodemailer");
const functions = require("firebase-functions");

var transporter = nodemailer.createTransport({
  service: "Gmail",
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});

exports.sendEmail = functions.firestore
  .document("users/{kullaniciId}")
  .onCreate((snap, context) => {
    const mailOptions = {
      from: `UluApp uludagyazilimtoplulugu@gmail.com`,
      to: snap.data().email,
      subject: "Selamlarrr",
      html: `hoşgeldin maili`,
    };

    return transporter.sendMail(mailOptions, (error, data) => {
      if (error) {
        console.log(error);
        return;
      }
      console.log("Sent!");
    });
  });
