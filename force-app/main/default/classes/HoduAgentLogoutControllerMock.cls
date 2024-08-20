@isTest
global class HoduAgentLogoutControllerMock implements HttpCalloutMock {
 global HttpResponse respond(HttpRequest req) {
 HttpResponse res = new HttpResponse();
 res.setHeader('Content-Type', 'application/json');
 res.setBody('{"status":"ok"}');
 res.setStatusCode(200);
 return res;
 }
}