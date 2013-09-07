
//twilio initialize
var twilio = require("cloud/twilio_extended.js");
var twilioSid = "AC373eaacb72f601e5fe64a9278197d0c3";
var twilioAuthToken = "46653b52833b0a2757d15e167610e5b6";
twilio.initialize(twilioSid, twilioAuthToken);

// Twilio  SMS
Parse.Cloud.define("sendSMS", function(request, response) {
	twilio.sendSMS({
		From: "+19142886105",
		To: "+16502457199",
		Body: "Hello from Cloud Code!"
	}, {
	success: function(httpResponse) {
		console.log(httpResponse);
		response.success("SMS sent!");
	},
	error: function(httpResponse) {
		console.error(httpResponse);
		response.error("Uh oh, something went wrong");
	}
	});
});

//Twilio  Call
var textTemp = "Test, this is a test.";
Parse.Cloud.define("callPhone", function(request, response) {
	twilio.callPhone({
		From: "+19142886105",
		To: "+16502457199",
		Url: "http://twimlets.com/echo?Twiml=%3CResponse%3E%3CSay%3E"+encodeURI(textTemp)+"%3C%2FSay%3E%3C%2FResponse%3E"
	}, {
	success: function(httpResponse) {
		console.log(httpResponse);
		response.success("Phone ");
	},
	error: function(httpResponse) {
		console.error(httpResponse);
		response.error("Uh oh, something went wrong");
	}
	});
});

//Twilio Handle Phone Response
Parse.Cloud.define("managePhoneAnswer", function(request, response) {
  console.log("Phone Log: " + request.params);
  response.success();
});


// test cloud code
Parse.Cloud.define("cloudTest", function(request, response) {
  response.success("true");
});
	