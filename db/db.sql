-- BANCO DE DADOS PARA O PROJETO DE HUB MANUFATURADOS FEITO EM MYSQL --

show databases;
create database projetoFaculdade;
show tables;
use projetoFaculdade;
DROP TABLE ENDERECO;

-- Criando tabela endereço --
CREATE TABLE Endereco (
    idendereco INT PRIMARY KEY AUTO_INCREMENT,
    CEP CHAR(8) NOT NULL,
    BAIRRO VARCHAR(50) NOT NULL,
    CIDADE VARCHAR(50) NOT NULL,
    COMPLEMENTO VARCHAR(50),
    ID_CLIENTE INT NOT NULL
);
DROP TABLE TELEFONE;


-- Criando tabela telefone do cliente--
CREATE TABLE Telefone(
    IDTELEFONE INT PRIMARY KEY AUTO_INCREMENT,
    TIPO ENUM('Telefone_Cel', 'Telefone_Com', 'Telefone_Res') NOT NULL,
    NUMERO_TEL CHAR(11),
    ID_CLIENTE INT NOT NULL
);


-- Criando tabela cliente --
DROP TABLE CLIENTE;
CREATE TABLE Cliente (
    IDCLIENTE INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL UNIQUE,
    DATA_DE_NASCIMENTO DATE NOT NULL,
    SENHA VARCHAR(100) NOT NULL,
    CPF CHAR(11) NOT NULL
);
DROP TABLE Pedido;


-- Criando tabela pedido --
CREATE TABLE Pedido (
    IDPEDIDO INT PRIMARY KEY AUTO_INCREMENT,
    NUMERO INT UNIQUE NOT NULL,
    VALOR_TOTAL INT NOT NULL,
    DATA_DO_PEDIDO DATE NOT NULL,
    QUANTIDADE INT NOT NULL,
    ID_CLIENTE INT NOT NULL,
    ID_VENDEDOR INT NOT NULL
);
DROP TABLE ITEM_PRODUTO;


-- Criando tabela Item_produto --
CREATE TABLE Item_produto (
    quantidade int NOT NULL,
    preco_unitario decimal(10,2) NOT NULL,
    valor_total decimal(10,2) NOT NULL,
    id_pedido int,
    id_produto int,
    PRIMARY KEY (id_pedido, id_produto)
);


DROP TABLE Produto;


-- Criando tabela produto --
CREATE TABLE Produto (
    IDPRODUTO INT PRIMARY KEY AUTO_INCREMENT,
    DATA_DE_ENTREGA DATE NOT NULL,
    DESCRICAO VARCHAR(80),
    NOME VARCHAR(30) NOT NULL
);


DROP TABLE Avaliacao;


-- Criando tabela avaliação do produto --
CREATE TABLE Avaliacao (
    IDAVALIACAO INT PRIMARY KEY AUTO_INCREMENT,
    DATA DATE NOT NULL,
    CLASSIFICACAO CHAR(5) NOT NULL,
    QUANTIDADE INT NOT NULL,
    DESCRICAO VARCHAR(80),
    ID_PRODUTO INT NOT NULL
);


DROP TABLE Vendedor;


-- Criando tabela vendedor --
CREATE TABLE Vendedor (
    IDVENDEDOR INT PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(30) NOT NULL,
    IDADE DECIMAL(4) NOT NULL,
    CPF CHAR(11) NOT NULL
);
DROP TABLE AVALIACAO_VENDEDOR;


-- Criando tabela avaliação do vendedor --
CREATE TABLE Avaliacao_vendedor (
    IDAVALIACAO INT PRIMARY KEY AUTO_INCREMENT,
    DESCRICAO VARCHAR(80),
    NUMERO CHAR(5),
    ID_VENDEDOR INT NOT NULL
);


DROP TABLE TELEFONE_VENDEDOR;


-- Criando tabela telefoe do vendedor --
CREATE TABLE TELEFONE_VENDEDOR (
    IDTELEFONE INT PRIMARY KEY AUTO_INCREMENT,
    TIPO ENUM('Telefone_Cel', 'Telefone_Com', 'Telefone_Res') NOT NULL,
    NUMERO CHAR(11) NOT NULL,
    ID_VENDEDOR INT NOT NULL
);


-- adicionando constraints --


alter table endereco add constraint FK_cliente_endereco
Foreign Key (id_cliente) REFERENCES cliente(idcliente);


alter table telefone add constraint FK_cliente_telefone
Foreign Key (id_cliente) REFERENCES cliente(idcliente);


alter table pedido add constraint FK_pedido_cliente
Foreign Key (id_cliente) REFERENCES cliente(idcliente);


alter table pedido add constraint Fk_pedido_vendedor
foreign key (id_vendedor) references vendedor(idvendedor);


alter table telefone_vendedor add constraint Fk_telefone_vendedor
foreign key (id_vendedor) references vendedor(idvendedor);


alter table avaliacao_vendedor add constraint Fk_avaliacao_vendedor_vendedor
foreign key (id_vendedor) references vendedor(idvendedor);


alter table Item_produto add constraint Fk_Item_produto_pedido
foreign key (id_pedido) references pedido(idpedido);


alter table Item_produto add constraint Fk_Item_produto_produto
foreign key (id_produto) references produto(idproduto);


alter table avaliacao add constraint Fk_produto_avaiacao
foreign key (id_produto) references produto(idproduto);
