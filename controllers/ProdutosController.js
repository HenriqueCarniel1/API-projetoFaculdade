const db = require('../db/db');

class ProdutosController {

    getTodosProdutos(req, res) {
        const sql = 'SELECT * FROM Produto';

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
        const {idProduto} = req.params;

        const sql = "SEELECT * FROM Produtos WHERE id = $1";

        db.query(sql, [idProduto], (err, result) => {
            if(err) {
                console.log(err);
            }
            if(result.rows.length > 0) {
                res.status(200).json(result.rows);
            }
        })
    }
}

module.exports = new ProdutosController();
