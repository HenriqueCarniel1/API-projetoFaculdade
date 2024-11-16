const db = require('../db/db');

class ProdutosController {

    getTodosProdutos(req, res) {
        const sql = 'SELECT * FROM PRODUTO;';

        db.query(sql, (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: "Erro ao buscar produtos" });
            }
            if (result.rows.length > 0) {
                return res.status(200).json(result.rows);
            } else {
                return res.status(404).json({ error: "Nenhum produto encontrado" });
            }
        });
    }

    getProdutoUnico(req, res) {
        const { idProduto } = req.params;

        const sql = "SELECT * FROM produto WHERE idproduto = $1";

        db.query(sql, [idProduto], (err, result) => {
            if (err) {
                console.log(err);
            }
            if (result.rows.length > 0) {
                res.status(200).json(result.rows);
            }
        })
    }

    addProdutoCarrinho(req, res) {
        const { idProduto, idUsuario } = req.params;

        const inserirNoCarrinho = `
            INSERT INTO Carrinho_Produto (id_cliente, id_produto)
            VALUES ($1, $2);
        `;

        db.query(inserirNoCarrinho, [idUsuario, idProduto], (err, insertResult) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: "Erro ao adicionar produto ao carrinho." });
            }

            return res.status(200).json({ message: "Produto adicionado ao carrinho com sucesso!" });
        });
    }

    getProdutoCarrinho(req, res) {
        const { idUsuario } = req.params;
    
        const sql = `
            SELECT produto.*
            FROM carrinho_produto
            JOIN cliente ON carrinho_produto.id_cliente = cliente.idcliente
            JOIN produto ON carrinho_produto.id_produto = produto.idproduto
            WHERE cliente.idcliente = $1;
        `;
    
        db.query(sql, [idUsuario], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: "Erro ao buscar produtos no carrinho." });
            }
    
            if (result.rows.length > 0) {
                return res.status(200).json(result.rows);
            } else {
                return res.status(200).json({ message: "Carrinho vazio." });
            }
        });
    }    

    deteleProdutoCarrinho(req, res) {
        const { idProduto } = req.params;
    
        const sql = `
            DELETE 
            FROM carrinho_produto
            WHERE id_produto = $1
        `;
    
        db.query(sql, [idProduto], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: "Erro ao buscar produtos no carrinho." });
            } else {
                return res.status(200).json({ msg: "Produto Deletado com sucesso" });
            }
        });
    }    


}

module.exports = new ProdutosController();
