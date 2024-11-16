-- Active: 1730291805645@@127.0.0.1@5432
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
DROP TABLE IF EXISTS Ofertas CASCADE;

-- Criando tipo ENUM para o Telefone --
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'telefone_tipo') THEN
        CREATE TYPE telefone_tipo AS ENUM ('Telefone_Cel', 'Telefone_Com', 'Telefone_Res');
    END IF;
END $$;

-- Criando tabela Cliente --
CREATE TABLE Cliente (
    idcliente SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    data_de_nascimento DATE NOT NULL,
    senha VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE
);

-- Criando tabela Endereco --
CREATE TABLE Endereco (
    idendereco SERIAL PRIMARY KEY,
    cep CHAR(8) NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    complemento VARCHAR(50),
    id_cliente INT NOT NULL,
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente)
);

-- Criando tabela Telefone do Cliente --
CREATE TABLE Telefone (
    idtelefone SERIAL PRIMARY KEY,
    tipo telefone_tipo NOT NULL,
    numero_tel CHAR(11) NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_cliente_telefone FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente)
);

-- Criando tabela Vendedor --
CREATE TABLE Vendedor (
    idvendedor SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    idade INT NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE
);

-- Criando tabela Telefone do Vendedor --
CREATE TABLE Telefone_vendedor (
    idtelefone SERIAL PRIMARY KEY,
    tipo telefone_tipo NOT NULL,
    numero CHAR(11) NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT fk_telefone_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor)
);

-- Criando tabela Produto --
CREATE TABLE Produto (
    idproduto SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao VARCHAR(80),
    preco DECIMAL(10, 2) NOT NULL,
    imagem VARCHAR(1000),
    ficha_tecnica TEXT,
    data_de_entrega DATE NOT NULL
);

-- Criando tabela Carrinho_Produto --
CREATE TABLE Carrinho_Produto (
    idcarrinho SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_carrinho_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente),
    CONSTRAINT fk_carrinho_produto FOREIGN KEY (id_produto) REFERENCES Produto(idproduto)
);

-- Index para melhorar consultas no carrinho
CREATE INDEX idx_carrinho_cliente_produto ON Carrinho_Produto (id_cliente, id_produto);

-- Criando tabela Ofertas --
CREATE TABLE Ofertas (
    idoferta SERIAL PRIMARY KEY,
    id_produto INT NOT NULL,
    preco_com_desconto DECIMAL(10, 2) NOT NULL,
    data_validade DATE NOT NULL,
    CONSTRAINT fk_oferta_produto FOREIGN KEY (id_produto) REFERENCES Produto(idproduto)
);

-- Criando tabela Pedido --
CREATE TABLE Pedido (
    idpedido SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_do_pedido DATE NOT NULL,
    quantidade INT NOT NULL,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente),
    CONSTRAINT fk_pedido_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor)
);

-- Criando tabela Item_produto --
CREATE TABLE Item_produto (
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_produto_pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(idpedido),
    CONSTRAINT fk_item_produto_produto FOREIGN KEY (id_produto) REFERENCES Produto(idproduto)
);

-- Criando tabela Avaliacao de Produto --
CREATE TABLE Avaliacao (
    idavaliacao SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    classificacao CHAR(1) NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(80),
    id_produto INT NOT NULL,
    CONSTRAINT fk_avaliacao_produto FOREIGN KEY (id_produto) REFERENCES Produto(idproduto)
);

-- Criando tabela Avaliacao do Vendedor --
CREATE TABLE Avaliacao_vendedor (
    idavaliacao SERIAL PRIMARY KEY,
    descricao VARCHAR(80),
    numero CHAR(1) NOT NULL,
    id_vendedor INT NOT NULL,
    CONSTRAINT fk_avaliacao_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(idvendedor)
);

-- Inserindo dados nas tabelas --

-- Inserindo dados na tabela Cliente
INSERT INTO Cliente (nome, email, data_de_nascimento, senha, cpf)
VALUES 
('Gustavo Henrique', 'gustavo@example.com', '2000-01-01', 'senhaSegura123', '12345678901'),
('Maria Silva', 'maria.silva@example.com', '1990-05-12', 'senhaMaria2023', '98765432100'),
('Ana Paula', 'ana.paula@example.com', '1985-08-20', 'senhaAna2024', '12312312399'),
('Carlos Souza', 'carlos.souza@example.com', '1992-11-30', 'senhaCarlos2024', '32132132111');

-- Inserindo dados na tabela Endereco
INSERT INTO Endereco (cep, bairro, cidade, complemento, id_cliente)
VALUES
('70000000', 'Asa Norte', 'Brasília', 'Apt 101', 1),
('70000001', 'Asa Sul', 'Brasília', 'Casa 2', 2),
('60000000', 'Centro', 'Fortaleza', 'Bloco A', 3),
('50000000', 'Boa Viagem', 'Recife', 'Apartamento 303', 4);

-- Inserindo dados na tabela Telefone do Cliente
INSERT INTO Telefone (tipo, numero_tel, id_cliente)
VALUES
('Telefone_Cel', '61999999999', 1),
('Telefone_Com', '61333333333', 1),
('Telefone_Cel', '85988888888', 3),
('Telefone_Res', '8133332222', 4);

-- Inserindo dados na tabela Vendedor
INSERT INTO Vendedor (nome, idade, cpf)
VALUES
('João Vendedor', 35, '11111111111'),
('Pedro Vendedor', 42, '22222222222'),
('Lucas Almeida', 28, '33333333333'),
('Fernanda Torres', 31, '44444444444');

-- Inserindo dados na tabela Telefone_vendedor
INSERT INTO Telefone_vendedor (tipo, numero, id_vendedor)
VALUES
('Telefone_Cel', '61888888888', 1),
('Telefone_Com', '61444444444', 2),
('Telefone_Cel', '6199991111', 3),
('Telefone_Res', '6133322233', 4);

-- Inserindo dados na tabela Produto
INSERT INTO Produto (nome, descricao, preco, imagem, ficha_tecnica, data_de_entrega)
VALUES
('Smartphone', 'Produto Eletrônico', 2500.00, 'https://th.bing.com/th/id/OIP.e0crVuj9YE3ut349FkKyLwHaE8?rs=1&pid=ImgDetMain', 'Ficha técnica do Smartphone', '2024-09-30'),
('Geladeira', 'Produto Doméstico', 3000.00, 'https://static.wixstatic.com/media/25e4aa_1c33ef69083743e7a636b49e73387974~mv2_d_2592_4608_s_4_2.jpg/v1/fill/w_2592,h_4607,al_c,q_85/25e4aa_1c33ef69083743e7a636b49e73387974~mv2_d_2592_4608_s_4_2.jpg', 'Ficha técnica da Geladeira', '2024-10-05'),
('Notebook', 'Computador Pessoal', 4500.00, 'https://th.bing.com/th/id/R.639f4ebbcd0829fa74b547e844b3c99f?rik=s%2bG7ktuGs67whA&pid=ImgRaw&r=0', 'Ficha técnica do Notebook', '2024-11-15'),
('Micro-ondas', 'Eletrodoméstico', 800.00, 'https://c.mlcdn.com.br/1500x1500/micro-ondas-panasonic-style-nn-st674srun-32linox-com-funcao-desodorizador-211479100.jpg', 'Ficha técnica do Micro-ondas', '2024-12-01');

-- Inserindo dados na tabela Ofertas
INSERT INTO Ofertas (id_produto, preco_com_desconto, data_validade)
VALUES
(1, 2000.00, '2024-10-30'),
(2, 2500.00, '2024-11-15'),
(3, 4000.00, '2024-12-10'),
(4, 700.00, '2024-12-20');

-- Inserindo dados na tabela Pedido
INSERT INTO Pedido (numero, valor_total, data_do_pedido, quantidade, id_cliente, id_vendedor)
VALUES
(1001, 5000.00, '2024-09-21', 2, 1, 1),
(1002, 3000.00, '2024-09-22', 1, 2, 2),
(1003, 8000.00, '2024-10-01', 3, 3, 3),
(1004, 800.00, '2024-10-10', 1, 4, 4);

-- Inserindo dados na tabela Item_produto
INSERT INTO Item_produto (quantidade, preco_unitario, valor_total, id_pedido, id_produto)
VALUES
(1, 2500.00, 2500.00, 1, 1),
(1, 3000.00, 3000.00, 1, 2),
(2, 4500.00, 9000.00, 3, 3),
(1, 800.00, 800.00, 4, 4);

-- Inserindo dados na tabela Avaliacao de Produto
INSERT INTO Avaliacao (data, classificacao, quantidade, descricao, id_produto)
VALUES
('2024-09-22', '5', 100, 'Ótimo produto!', 1),
('2024-09-23', '4', 50, 'Bom, mas pode melhorar.', 2),
('2024-09-24', '3', 30, 'Produto médio', 3),
('2024-09-25', '5', 200, 'Excelente qualidade', 4);

-- Inserindo dados na tabela Avaliacao_vendedor
INSERT INTO Avaliacao_vendedor (descricao, numero, id_vendedor)
VALUES
('Muito atencioso', '5', 1),
('Entrega rápida', '4', 2),
('Bom atendimento', '5', 3),
('Ótimo vendedor', '5', 4);

select *
from produto;

SELECT 
    p.nome,
    p.preco AS preco_original,
    o.preco_com_desconto,
    p.imagem,
    p.descricao,
    p.ficha_tecnica,
    o.data_validade
FROM 
    Ofertas o
JOIN 
    Produto p ON o.id_produto = p.idproduto
WHERE 
    o.data_validade >= CURRENT_DATE;