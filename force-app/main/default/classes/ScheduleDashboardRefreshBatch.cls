public class ScheduleDashboardRefreshBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    public string accesstoken;
    public Database.QueryLocator start(Database.BatchableContext bc) { 
        string orgId = UserInfo.getOrganizationId();
        string suborgId=orgId.substring(0,15);
        string orgbody=Label.LoginRequest.replace('@@@@OrgId@@@@',suborgId);
        string userbody=orgbody.replace('@@@@Username@@@@',Label.Username);
        string Pwdbody=userbody.replace('@@@@Password@@@@',Label.Password);
        string body = Pwdbody;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://test.salesforce.com/services/Soap/u/29.0');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction', '""');
        req.setBody(body);
        Http p = new Http();
        HttpResponse res = p.send(req);
        Xmlstreamreader reader = new Xmlstreamreader(res.getbody());
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.Characters) {
                if (string.valueof(reader.getText()).startswith(suborgId + '!')) {
                    accesstoken = reader.getText();
                }
            }
            reader.next();
        }  
        String queryString = 'Select Id from Dashboard'; 
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext info, List<Dashboard> scope) { 
        try {
            for(Sobject s : scope){
                Dashboard dr = (Dashboard)s;
                String requestUrl = '/dash/dashboardRefresh.apexp?id='+dr.Id;
               /* Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + requestUrl);
                req.setMethod('GET');
                req.setHeader('Cookie','sid='+accesstoken+''); 
                HTTPResponse res = http.send(req);*/
                HttpRequest req = new HttpRequest();
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                req.setMethod('PUT');
                req.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/v35.0/analytics/dashboards/01Z0X0000005i8DUAQ'); 
                Http http = new Http();
                HttpResponse res = http.send(req);
                String output = res.getBody();
                System.debug('>>>>'+output);
            }
        } catch(Exception ex){
            system.debug('>>>>Refresh failed Due to :'+ ex.getmessage());
        }
         
    }
     public void finish(Database.BatchableContext bc) {
    }
}