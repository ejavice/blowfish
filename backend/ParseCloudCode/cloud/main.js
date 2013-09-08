require('cloud/app.js');

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
	var smsOrPhoneArr = [];
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
					smsOrPhoneArr[i] = pillResults[i].get("smsOrPhoneArr");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr, smsOrPhoneArr));
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
	var smsOrPhoneArr = [];
	var pillQuery = new Parse.Query("Pills_To_Take");
	pillQuery.contains("days", dayofWeek);
	pillQuery.find({
		success: function(pillResults) {
			for (var i = 0; i < pillResults.length; ++i) {
				if(pillResults[i].get("time")=="afternoon"){
					lovedOneIdArr[i] = pillResults[i].get("lovedOne");
					pillNameArr[i] = pillResults[i].get("pillName");
					lovedOneNameArr[i] = pillResults[i].get("lovedOneName");
					lovedOneNumberArr[i] = pillResults[i].get("lovedOneNumber");
					smsOrPhoneArr[i] = pillResults[i].get("smsOrPhoneArr");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr, smsOrPhoneArr));
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
	var smsOrPhoneArr = [];
	var pillQuery = new Parse.Query("Pills_To_Take");
	pillQuery.contains("days", dayofWeek);
	pillQuery.find({
		success: function(pillResults) {
			for (var i = 0; i < pillResults.length; ++i) {
				if(pillResults[i].get("time")=="evening"){
					lovedOneIdArr[i] = pillResults[i].get("lovedOne");
					pillNameArr[i] = pillResults[i].get("pillName");
					lovedOneNameArr[i] = pillResults[i].get("lovedOneName");
					lovedOneNumberArr[i] = pillResults[i].get("lovedOneNumber");
					smsOrPhoneArr[i] = pillResults[i].get("smsOrPhoneArr");
				}
			}
			response.success(callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr, smsOrPhoneArr));
		},
		error: function() {
			response.error("Pill Search Fail");
		}
	});
});

function callPhones(lovedOneIdArr, pillNameArr, lovedOneNameArr, lovedOneNumberArr, smsOrPhoneArr){
	for(var i = 0; i < lovedOneNumberArr.length;++i){
		if(lovedOneNumberArr[i]!==undefined){
			var text = "Hello "+lovedOneNameArr[i]+"! Did you remember to take your "+ pillNameArr[i]+". If you did, press 1. If not, please take your medication now.";
			console.log("Text: "+text);
			if(smsOrPhoneArr[i]=="phone"){
				callPhoneOptions("+"+lovedOneNumberArr[i], text);
			}else{
				sendSms("+"+lovedOneNumberArr[i], text);
			}
			Parse.Cloud.run("dialIncrement", {"phone": ""+lovedOneNumberArr[i]});
		}
	}
}


//With Options
function callPhoneOptions(number, text){
	twilio.callPhone({
		From: twilioPhoneNumber,
		To: number,
		Url: "http://twimlets.com/menu?Message="+encodeURI(text)+"&Options%5B1%5D=http%3A%2F%2Fblowfish.parseapp.com%2Fphone/handle&"
	}, {
	success: function(httpResponse) {
		console.log(httpResponse);
	},
	error: function(httpResponse) {
		console.error(httpResponse);
	}
	});
}

function sendSms(number, text){
	console.log("GOt inside sms");
	twilio.sendSMS({
		From: twilioPhoneNumber,
		To: number,
		Body: "Did you remember to take your Benazepril? If so respond to this message with a 1"
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
	var updateQueryRem = new Parse.Query("Loved_Ones");
	var phoneNumber = request.params.From.replace('+','');
	updateQueryRem.equalTo("phoneNumber", ""+phoneNumber);
	updateQueryRem.find({
		success: function(results) {
			if(results[0].get("numRemembered")===undefined){
				results[0].set("numRemembered", 1);
			}else{
				results[0].increment("numRemembered");
				
			}
			results[0].save();
			response.success("Updated: User Remembered To take Meds");
		},
		error: function() {
			response.error("Update Remembered Fail");
		}
	});
});

//Update remembered
Parse.Cloud.define("updateRemembered", function(request, response) {
	var updateQueryRem = new Parse.Query("Loved_Ones");
	updateQueryRem.equalTo("phoneNumber", ""+request.params.phone);
	updateQueryRem.find({
		success: function(results) {
			if(results[0].get("numRemembered")===undefined){
				results[0].set("numRemembered", 1);
			}else{
				results[0].increment("numRemembered");
				
			}
			results[0].save();
			response.success("Updated: User Remembered To take Meds");
		},
		error: function() {
			response.error("Update Remembered Fail");
		}
	});
});

//update dialed
Parse.Cloud.define("dialIncrement", function(request, response) {
  var updatetotalCalls = new Parse.Query("Loved_Ones");
	updatetotalCalls.equalTo("phoneNumber", ""+request.params.phone);
	updatetotalCalls.find({
		success: function(results) {
			if(results[0].get("totalCalls")===undefined){
				results[0].set("totalCalls", 1);
			}else{
				results[0].increment("totalCalls");
				
			}
			results[0].save();
			response.success("Updated: Log user Dial");
		},
		error: function() {
			response.error("Update Dial Fail");
		}
	});
});
	