-- Active: 1727040477672@@localhost@5432@postgres
-- BANCO DE DADOS PARA O PROJETO DE HUB MANUFATURADOS FEITO EM POSTGRESQL --

-- Criação do banco de dados --
-- Use um cliente PostgreSQL para criar o banco de dados --
-- CREATE DATABASE projetoFaculdade;

\c projetoFaculdade

-- Remover tabelas existentes se houver --
DROP TABLE IF EXISTS Telefone_vendedor CASCADE;
DROP TABLE IF EXISTS Avaliacao_vendedor CASCADE;
DROP TABLE IF EXISTS Vendedor CASCADE;
DROP TABLE IF EXISTS Avaliacao CASCADE;
DROP TABLE IF EXISTS Item_produto CASCADE;
DROP TABLE IF EXISTS Produto CASCADE;
DROP TABLE IF EXISTS Pedido CASCADE;
DROP TABLE IF EXISTS Telefone CASCADE;
DROP TABLE IF EXISTS Endereco CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;

-- Criando tipo ENUM para o Telefone --
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'telefone_tipo') THEN
        CREATE TYPE telefone_tipo AS ENUM ('Telefone_Cel', 'Telefone_Com', 'Telefone_Res');
    END IF;
END $$;

-- Criando tabela Endereco --
CREATE TABLE Endereco (
    idendereco SERIAL PRIMARY KEY,
    CEP CHAR(8) NOT NULL,
    BAIRRO VARCHAR(50) NOT NULL,
    CIDADE VARCHAR(50) NOT NULL,
    COMPLEMENTO VARCHAR(50),
    id_cliente INT NOT NULL
);

-- Criando tabela Telefone do cliente --
CREATE TABLE Telefone (
    idtelefone SERIAL PRIMARY KEY,
    tipo telefone_tipo NOT NULL,
    numero_tel CHAR(11),
    id_cliente INT NOT NULL
);

-- Criando tabela Cliente --
CREATE TABLE Cliente (
    idcliente SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    data_de_nascimento DATE NOT NULL,
    senha VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL
);

-- Criando tabela Pedido --
CREATE TABLE Pedido (
    idpedido SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_do_pedido DATE NOT NULL,
    quantidade INT NOT NULL,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL
);

-- Criando tabela Item_produto --
CREATE TABLE Item_produto (
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    id_pedido INT,
    id_produto INT,
    PRIMARY KEY (id_pedido, id_produto)
);

-- Criando tabela Produto --
CREATE TABLE Produto (
    idproduto SERIAL PRIMARY KEY,
    data_de_entrega DATE NOT NULL,
    descricao VARCHAR(80),
    nome VARCHAR(30) NOT NULL
);

-- Criando tabela Avaliacao do produto --
CREATE TABLE Avaliacao (
    idavaliacao SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    classificacao CHAR(5) NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(80),
    id_produto INT NOT NULL
);

-- Criando tabela Vendedor --
CREATE TABLE Vendedor (
    idvendedor SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    idade INT NOT NULL,
    cpf CHAR(11) NOT NULL
);

-- Criando tabela Avaliacao_vendedor --
CREATE TABLE Avaliacao_vendedor (
    idavaliacao SERIAL PRIMARY KEY,
    descricao VARCHAR(80),
    numero CHAR(5),
    id_vendedor INT NOT NULL
);

-- Criando tabela Telefone_vendedor --
CREATE TABLE Telefone_vendedor (
    idtelefone SERIAL PRIMARY KEY,
    tipo telefone_tipo NOT NULL,
    numero CHAR(11) NOT NULL,
    id_vendedor INT NOT NULL
);

-- Adicionando constraints --

ALTER TABLE Endereco
ADD CONSTRAINT FK_cliente_endereco
FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente);

ALTER TABLE Telefone
ADD CONSTRAINT FK_cliente_telefone
FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente);

ALTER TABLE Pedido
ADD CONSTRAINT FK_pedido_cliente
FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente);

ALTER TABLE Pedido
ADD CONSTRAINT FK_pedido_vendedor
FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor);

ALTER TABLE Telefone_vendedor
ADD CONSTRAINT FK_telefone_vendedor
FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor);

ALTER TABLE Avaliacao_vendedor
ADD CONSTRAINT FK_avaliacao_vendedor_vendedor
FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor);

ALTER TABLE Item_produto
ADD CONSTRAINT FK_Item_produto_pedido
FOREIGN KEY (id_pedido) REFERENCES Pedido(idpedido);

ALTER TABLE Item_produto
ADD CONSTRAINT FK_Item_produto_produto
FOREIGN KEY (id_produto) REFERENCES Produto(idproduto);

ALTER TABLE Avaliacao
ADD CONSTRAINT FK_produto_avaliacao
FOREIGN KEY (id_produto) REFERENCES Produto(idproduto);


INSERT INTO Cliente (nome, email, data_de_nascimento, senha, cpf)
VALUES 
('Gustavo Henrique', 'gustavo@example.com', '2000-01-01', 'senhaSegura123', '12345678901'),
('Maria Silva', 'maria.silva@example.com', '1990-05-12', 'senhaMaria2023', '98765432100'),
('teste', 'teste@gmail.com', '1990-05-12', '123', '98765432100');

INSERT INTO Endereco (CEP, Bairro, Cidade, Complemento, id_cliente)
VALUES
('70000000', 'Asa Norte', 'Brasília', 'Apt 101', 1),
('70000001', 'Asa Sul', 'Brasília', 'Casa 2', 2);

INSERT INTO Telefone (tipo, numero_tel, id_cliente)
VALUES
('Telefone_Cel', '61999999999', 1),
('Telefone_Com', '61333333333', 2);

INSERT INTO Vendedor (nome, idade, cpf)
VALUES
('João Vendedor', 35, '11111111111'),
('Pedro Vendedor', 42, '22222222222');

INSERT INTO Telefone_vendedor (tipo, numero, id_vendedor)
VALUES
('Telefone_Cel', '61888888888', 1),
('Telefone_Com', '61444444444', 2);

INSERT INTO Produto (data_de_entrega, descricao, nome)
VALUES
('2024-09-30', 'Produto Eletrônico', 'Smartphone'),
('2024-10-05', 'Produto Doméstico', 'Geladeira');

INSERT INTO Pedido (numero, valor_total, data_do_pedido, quantidade, id_cliente, id_vendedor)
VALUES
(1001, 2000.50, '2024-09-21', 2, 1, 1),
(1002, 3000.00, '2024-09-22', 1, 2, 2);

INSERT INTO Item_produto (quantidade, preco_unitario, valor_total, id_pedido, id_produto)
VALUES
(1, 1000.25, 2000.50, 1, 1),
(1, 3000.00, 3000.00, 2, 2);

INSERT INTO Avaliacao (data, classificacao, quantidade, descricao, id_produto)
VALUES
('2024-09-22', '5', 100, 'Ótimo produto!', 1),
('2024-09-23', '4', 50, 'Bom, mas pode melhorar.', 2);

INSERT INTO Avaliacao_vendedor (descricao, numero, id_vendedor)
VALUES
('Muito atencioso', '5', 1),
('Entrega rápida', '4', 2);

