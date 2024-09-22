const db = require('../db/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const jwtData = require('../auth/auth');

let validarCamposVazios = ({ RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth }) => {
    return RegisterName && RegisterEmail && RegisterPassword && RegisterCpf && RegisterDateOfBirth;
};

let validarEmailExistenteNoBanco = (RegisterEmail) => {
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
};

exports.EnviarDadosRegistro = async (req, res) => {
    const { RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth } = req.body;

    if (!validarCamposVazios(req.body)) {
        return res.json({ msg: "Preencha todos os campos" });
    }

    try {
        if (await validarEmailExistenteNoBanco(RegisterEmail)) {
            return res.json({ userEmailAlreadyExist: "Email já registrado", Exist: true });
        }

        const sql = "INSERT INTO Cliente(nome, email, senha, cpf, data_de_nascimento) VALUES($1, $2, $3, $4, $5)";

        let salt = await bcrypt.genSalt(12);
        let senhaCriptografada = await bcrypt.hash(RegisterPassword, salt);

        db.query(sql, [RegisterName, RegisterEmail, senhaCriptografada, RegisterCpf, RegisterDateOfBirth], (err, result) => {
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
};

let validarCamposVaziosLogin = ({ LoginEmail, LoginPassword }) => {
    return LoginEmail && LoginPassword;
};

let validarCamposBancoLogin = (LoginEmail) => {
    return new Promise((resolve, reject) => {
        const sql = "SELECT * FROM Cliente WHERE email = $1";
        db.query(sql, [LoginEmail], (err, result) => {
            if (err) {
                reject(err);
                console.log(err);
            } else if (result.rows.length > 0) {
                resolve(result.rows[0]);
            } else {
                resolve(false);
            }
        });
    });
};

exports.EnviarDadosLogin = async (req, res) => {
    const { LoginEmail, LoginPassword } = req.body;

    if (!validarCamposVaziosLogin(req.body)) {
        return res.json({ msg: "Preencha todos os campos" });
    }

    try {
        let user = await validarCamposBancoLogin(LoginEmail);

        if (user) {
            let senhaCorreta = await bcrypt.compare(LoginPassword, user.senha);

            if (senhaCorreta) {
                const token = jwt.sign({}, jwtData.jwt.secret, {
                    subject: String(user.idcliente),
                    expiresIn: jwtData.jwt.expiresIn
                });

                res.status(201).json({ token: token, idusuario: user.idcliente, logado: true });

            } else {
                return res.json({ user: "Email ou senha incorretos", logado: false });
            }
        } else {
            return res.json({ user: "Email ou senha incorretos", logado: false });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).send("Erro no servidor");
    }
};
