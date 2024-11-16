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
Router.get('/get/produto/unico/:idProduto', produtos.getProdutoUnico);
Router.post('/add/produto/carrinho/:idProduto/:idUsuario', produtos.addProdutoCarrinho);
Router.get('/get/produto/carrinho/:idUsuario', produtos.getProdutoCarrinho);
Router.delete('/delete/produto/carrinho/:idProduto', produtos.deteleProdutoCarrinho);

module.exports = Router;