const db = require('../db/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const jwtData = require('../auth/auth');

class UsuariosController {
    validarCamposVazios({ RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth }) {
        return RegisterName && RegisterEmail && RegisterPassword && RegisterCpf && RegisterDateOfBirth;
    }

    validarCamposVaziosLogin({ LoginEmail, LoginPassword }) {
        return LoginEmail && LoginPassword;
    }

    async validarEmailExistenteNoBanco(RegisterEmail) {
        const sql = "SELECT * FROM Cliente WHERE email = $1";
        return new Promise((resolve, reject) => {
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

    async validarCamposBancoLogin(LoginEmail) {
        const sql = "SELECT * FROM Cliente WHERE email = $1";
        return new Promise((resolve, reject) => {
            db.query(sql, [LoginEmail], (err, result) => {
                if (err) {
                    console.log(err);
                    reject(err);
                } else if (result.rows.length > 0) {
                    resolve(result.rows[0]);
                } else {
                    resolve(false);
                }
            });
        });
    }

    async EnviarDadosRegistro(req, res) {
        const { RegisterName, RegisterEmail, RegisterPassword, RegisterCpf, RegisterDateOfBirth } = req.body;

        if (!this.validarCamposVazios(req.body)) {
            return res.json({ msg: "Preencha todos os campos" });
        }

        try {
            if (await this.validarEmailExistenteNoBanco(RegisterEmail)) {
                return res.json({ userEmailAlreadyExist: "Email já registrado", Exist: true });
            }

            const sql = "INSERT INTO Cliente(nome, email, senha, cpf, data_de_nascimento) VALUES($1, $2, $3, $4, $5)";

            const salt = await bcrypt.genSalt(12);
            const senhaCriptografada = await bcrypt.hash(RegisterPassword, salt);

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
    }

    async EnviarDadosLogin(req, res) {
        const { LoginEmail, LoginPassword } = req.body;

        if (!this.validarCamposVaziosLogin(req.body)) {
            return res.json({ msg: "Preencha todos os campos" });
        }

        try {
            const user = await this.validarCamposBancoLogin(LoginEmail);

            if (user) {
                const senhaCorreta = await bcrypt.compare(LoginPassword, user.senha);

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
    }
}

module.exports = new UsuariosController();
