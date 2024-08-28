const jwt = require('jsonwebtoken');
const authConfig = require('../auth/auth');

let ensureAuthenticated = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Token JWT não informado' });
  }

  const token = authHeader.split(' ')[1];

  try {

    jwt.verify(token, authConfig.jwt.secret, (err, decoded) => {
      if (err) {
        console.log(err)
      } else {
        console.log(decoded)
        req.user = {
          id: Number(idcliente)
        }
      }
    });
    return next();
  } catch (error) {
    return res.status(401).json({ error: 'Token JWT inválido' });
  }

}

module.exports = ensureAuthenticated;