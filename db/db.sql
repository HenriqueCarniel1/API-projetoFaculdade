-- Active: 1724873982032@@aws-0-sa-east-1.pooler.supabase.com@6543@postgres
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
