const express = require('express');
const Router = express();

// Controllers


//Middleware
const ensureauth = require('../middlewares/ensureAuthenticated');



module.exports = Router;