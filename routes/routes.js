const express = require('express');
const Router = express();

// Controllers
const SendLoginData = require('../controllers/SendLoginData');

//Middleware

//Routes
Router.post('/send/login/data', SendLoginData.SendLoginData);



module.exports = Router;