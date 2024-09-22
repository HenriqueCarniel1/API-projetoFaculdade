const express = require('express');
const app = express();
const routes = require('./routes/routes');
const cors = require('cors');
<<<<<<< HEAD
const porta = 3000;
=======
const porta = 4897;
>>>>>>> 00529a9 (unindo tudo nos controllers, ajeitando as rotas)

app.use(express.urlencoded({extended:true}));
app.use(cors());
app.use(express.json());
app.use(routes);


app.listen(porta, () => {
  console.log(`Server is running on port ${porta}`);
});
