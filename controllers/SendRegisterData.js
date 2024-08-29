const db = require('../db/db');
const bcrypt = require('bcrypt');

let validateEmptyFields = ({ RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth }) => {
    return RegisterName && RegisterEmail && RegisterPassword && RegisterCpf && RegisterDateOfBirth;
}

let validateDatabaseDataExist = (RegisterEmail) => {
    return new Promise((resolve, reject) => {
        const sql = "SELECT * FROM Cliente WHERE email = $1";

        db.query(sql, [RegisterEmail], (err, result) => {
            if (err) {
                console.log(err);
                reject(err);
            } else {
                resolve(result.rows.length > 0);
            }
        });
    });
}

exports.SendRegisterData = async (req, res) => {
    const { RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth } = req.body;

    if (!validateEmptyFields(req.body)) {
        return res.send("Preencha todos os campos");
    }

    try {
        if (await validateDatabaseDataExist(RegisterEmail)) {
            return res.json({ userEmailAlreadyExist: "Email já registrado", Exist: true });
        }

        const sql = "INSERT INTO Cliente(nome, email, senha, cpf, data_de_nascimento) VALUES($1, $2, $3, $4, $5)";

        let salt = await bcrypt.genSalt(12);
        let encryptedPassword = await bcrypt.hash(RegisterPassword, salt);

        db.query(sql, [RegisterName, RegisterEmail, encryptedPassword, RegisterCpf, RegisterDateOfBirth], (err, result) => {
            if (err) {
                console.log(err);
                return res.json("Erro ao registrar os dados");
            } else {
                console.log(result);
                return res.json({ userInsert: true });
            }
        });

    } catch (err) {
        console.log(err);
        return res.status(500).send("Erro no servidor");
    }
}
