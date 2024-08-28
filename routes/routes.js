const express = require('express');
const Router = express();

// Controllers
const SendRegisterData = require('../controllers/SendRegisterData');
const SendLoginData = require('../controllers/SendLoginData');

//Middleware

//Routes
Router.post('/send/login/user', SendLoginData.SendLoginData);
Router.post('/send/register/user', SendRegisterData.SendRegisterData);



module.exports = Router;