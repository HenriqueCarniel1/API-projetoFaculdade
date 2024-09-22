const express = require('express');
const Router = express();

// Controllers
const usuarios = require('../controllers/UsuariosController');
const produtos = require('../controllers/ProdutosController');

//Middleware

//Routes
Router.post('/send/login/user', usuarios.EnviarDadosLogin);
Router.post('/send/register/user', usuarios.EnviarDadosRegistro);

//Produtos
Router.get('/get/produto', produtos.getTodosProdutos);

module.exports = Router;