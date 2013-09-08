
// initialize Express in Cloud Code.
var express = require('express');
var app = express();

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body

app.get('/hello', function(req, res) {
  res.render('hello', { message: 'Congrats, you just set up your app!' });
});

app.get('/phone/*', function(req, res) {
  res.header('Content-Type', 'application/xml');
  res.render('phonehandle');
  var phoneNumber = req.query.To.replace('+','');
  Parse.Cloud.run("updateRemembered", {"phone": ""+phoneNumber});
});


// Attach the Express app to Cloud Code.
app.listen();
