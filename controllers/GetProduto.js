const db = require('../db/db');

exports.getTodosProdutos = (req, res) => {
    const sql = 'SELECT * FROM Produto';
    
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: "Erro ao buscar produtos" });
        }
        if (result) {
            return res.status(200).json(result.rows);
        } else {
            return res.status(404).json({ error: "Nenhum produto encontrado" });
        }
    });
};
