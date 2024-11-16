require('dotenv').config();
const db = require('./db/db');

async function testConnection() {
  try {
    const res = await db.query('SELECT NOW()');
    console.log('Conexão bem-sucedida:', res.rows[0]);
  } catch (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
  } finally {
    db.end();
  }
}

testConnection();
