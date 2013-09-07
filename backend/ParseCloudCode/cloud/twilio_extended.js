var _apiUrl = 'api.twilio.com/2010-04-01';
var _accountSid = '';
var _authToken = '';

exports.initialize = function(accountSid, authToken) {
	_accountSid = accountSid;
	_authToken = authToken;
};

exports.sendSMS = function(params, options) {
	Parse.Cloud.httpRequest({
		method: "POST",
		url: "https://" + _accountSid + ":" + _authToken + "@" + _apiUrl + "/Accounts/" + _accountSid + "/SMS/Messages.json",
		body: params,
		success: options.success,
		error: options.error
		});
	return this;
};

exports.callPhone = function(params, options){
	Parse.Cloud.httpRequest({
		method: "POST",
		url: "https://" + _accountSid + ":" + _authToken + "@" + _apiUrl + "/Accounts/" + _accountSid + "/Calls",
		body: params,
		success: options.success,
		error: options.error
	});
	return this;
};