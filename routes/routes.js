const express = require('express');
const Router = express();

// Controllers
const SendRegisterData = require('../controllers/SendRegisterData');
const SendLoginData = require('../controllers/SendLoginData');
const GetProduto = require('../controllers/GetProduto');
//Middleware

//Routes
Router.post('/send/login/user', SendLoginData.SendLoginData);
Router.post('/send/register/user', SendRegisterData.SendRegisterData);

//Produtos
Router.get('/get/produto', GetProduto.getTodosProdutos)

module.exports = Router;