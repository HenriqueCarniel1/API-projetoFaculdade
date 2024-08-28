const express = require('express');
const Router = express();

// Controllers
const SendLoginData = require('../controllers/SendLoginData');

//Middleware

//Routes
Router.post('/send/login/user', SendLoginData.SendLoginData);
Router.post('/send/register/user', SendLoginData.SendLoginData);



module.exports = Router;