//twilio initialize
var twilio = require("cloud/twilio_extended.js");
var twilioSid = "AC373eaacb72f601e5fe64a9278197d0c3";
var twilioAuthToken = "46653b52833b0a2757d15e167610e5b6";
var twilioPhoneNumber = "+19142886105";
twilio.initialize(twilioSid, twilioAuthToken);

Parse.Cloud.job("callMorningPhones", function(request, response) {
	var date = new Date();
	var dayofWeek = ""+date.getDay();
	var lovedOneIdArr =  [];
	var pillNameArr = [];
	var lovedOneNameArr = [];
	var lovedOneNumberArr = [];
	var pillQuery = new Parse.Query("Pills_To_Take");
	pillQuery.contains("days", dayofWeek);
	pillQuery.find({
		success: function(pillResults) {
			for (var i = 0; i < pillResults.length; ++i) {
				if(pillResults[i].get("time")=="morning"){
					lovedOneIdArr[i] = pillResults[i].get("lovedOne");
					pillNameArr[i] = pillResults[i].get("pillName");
					lovedOneNameArr[i] = pillResults[i].get("lovedOneName");
					lovedOneNumberArr[i] = pillResults[i].get("lovedOneNumber");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr));
		},
		error: function() {
			response.error("Pill Search Fail");
		}
	});
});

Parse.Cloud.job("callNoonPhones", function(request, response) {
	var date = new Date();
	var dayofWeek = ""+date.getDay();
	var lovedOneIdArr =  [];
	var pillNameArr = [];
	var lovedOneNameArr = [];
	var lovedOneNumberArr = [];
	var pillQuery = new Parse.Query("Pills_To_Take");
	pillQuery.contains("days", dayofWeek);
	pillQuery.find({
		success: function(pillResults) {
			for (var i = 0; i < pillResults.length; ++i) {
				if(pillResults[i].get("time")=="noon"){
					lovedOneIdArr[i] = pillResults[i].get("lovedOne");
					pillNameArr[i] = pillResults[i].get("pillName");
					lovedOneNameArr[i] = pillResults[i].get("lovedOneName");
					lovedOneNumberArr[i] = pillResults[i].get("lovedOneNumber");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr));
		},
		error: function() {
			response.error("Pill Search Fail");
		}
	});
});

Parse.Cloud.job("callNightPhones", function(request, response) {
	var date = new Date();
	var dayofWeek = ""+date.getDay();
	var lovedOneIdArr =  [];
	var pillNameArr = [];
	var lovedOneNameArr = [];
	var lovedOneNumberArr = [];
	var pillQuery = new Parse.Query("Pills_To_Take");
	pillQuery.contains("days", dayofWeek);
	pillQuery.find({
		success: function(pillResults) {
			for (var i = 0; i < pillResults.length; ++i) {
				if(pillResults[i].get("time")=="night"){
					lovedOneIdArr[i] = pillResults[i].get("lovedOne");
					pillNameArr[i] = pillResults[i].get("pillName");
					lovedOneNameArr[i] = pillResults[i].get("lovedOneName");
					lovedOneNumberArr[i] = pillResults[i].get("lovedOneNumber");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr));
		},
		error: function() {
			response.error("Pill Search Fail");
		}
	});
});

function callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr){
	for(var i = 0; i < lovedOneNumberArr.length;++i){
		if(lovedOneNumberArr[i]!==undefined){
			var text = "Hello "+lovedOneNameArr[i]+"! Did you remember to take your "+ pillNameArr[i]+". If you did, press 1. If not, please take your medication now.";
			console.log("Text: "+text);
			callPhone("+"+lovedOneNumberArr[i], text);
		}
	}
}

function callPhone(number, text){
	twilio.callPhone({
		From: twilioPhoneNumber,
		To: number,
		Url: "http://twimlets.com/echo?Twiml=%3CResponse%3E%3CSay%3E"+encodeURI(text)+"%3C%2FSay%3E%3C%2FResponse%3E"
	}, {
	success: function(httpResponse) {
		console.log(httpResponse);
	},
	error: function(httpResponse) {
		console.error(httpResponse);
	}
	});
}

// Twilio send SMS
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

//Twilio receive SMS
Parse.Cloud.define("receiveSMS", function(request, response) {
	console.log("Received a new text: " + request.params.From);
	response.success();
});

	