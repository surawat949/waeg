global class HoduAgentLogoutController {
@future (callout=true)
 public static void HoduAgentLogoutCC(string UserId) {
 User u = [select Id, username,email from User where Id = :UserId];
 String Body = JSON.serialize(u);
 HttpRequest req = new HttpRequest();
req.setEndpoint('https://_YOUR_DOMAIN_/HoduCC_api/v1.4/sfuserlogouted');
 req.setMethod('POST');
 req.setHeader('Content-Type', 'application/json');
 req.setbody(Body);
 Http http = new Http();
 HTTPResponse res = http.send(req);
 res.getBody();
 }
}