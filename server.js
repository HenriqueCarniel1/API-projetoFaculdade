const express = require('express');
const app = express();
const routes = require('./routes/routes');
const cors = require('cors');
const porta = 4000;

app.use(express.urlencoded({extended:true}));
app.use(cors());
app.use(express.json());
app.use(routes);


app.listen(porta, () => {
  console.log(`Server is running on port ${porta}`);
});
