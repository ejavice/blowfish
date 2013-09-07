var twilio = require("twilio");

var twilioSid = "AC373eaacb72f601e5fe64a9278197d0c3";
var twilioAuthToken = "46653b52833b0a2757d15e167610e5b6";

twilio.initialize(twilioSid, twilioAuthToken);


// Twilio Test
Parse.Cloud.define("testTwilio", function(request, response) {
	twilio.sendSMS({
		From: "+19142886105",
		To: "+19145759309",
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

// test cloud code
Parse.Cloud.define("cloudTest", function(request, response) {
  response.success("true");
});
	