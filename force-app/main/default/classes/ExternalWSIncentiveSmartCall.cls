public with sharing class ExternalWSIncentiveSmartCall {

    static public String S_URL_TEST = 'https://api.isstage.com';
    static public String S_URL = 'https://api.incentivesmart.com';
    static private String ENDPOINT_APIKEY='/apikey/';
    static private String API_USERNAME = '75';
    static private String API_KEY = '877afcecd7984ebfabf2c854876ad353';
    public ExternalWSIncentiveSmartCall() {

    }

    @Future(callout=true)
    static public void synchronizeUser(String hoyaAccountId){

        String customerId = hoyaAccountId.removeStart('UK').removeStart('0').removeStart('0').removeStart('0').removeStart('0');
        System.debug('Synchronize User ['+hoyaAccountId+']['+customerId+']');
        Account acc = [select id, hoya_account_id__c from account where hoya_account_id__c =: hoyaAccountId];

        //get incentive user id from our customer id
        Http h = new Http();
        HttpRequest req = initHttp('GET', 120000);
        String query = S_URL+'/v2/user/cid/' + customerId;//test account UK009028
        req.setEndpoint(query);
        system.debug('Calling ' + query);
        HttpResponse res = h.send(req);
        system.debug('RES CODE =' + res.getStatusCode());
  

        List<IncentiveUser> userList = null;
        if (res.getStatusCode()==200){
            String result = res.getBody();
            System.debug('[OPEN] CALL succes ' + query );
            System.debug('[OPEN] response body= ' + result );
            userList = (List<IncentiveUser>)JSON.deserialize(result, List<IncentiveUser>.class);
            System.debug('[RESULT] userList size = ' + userList.size());
            for(IncentiveUser u : userList){
                
                Map<String, Loyalty_Points__c> userTypePointMap = new Map<String, Loyalty_Points__c>();
                System.debug('[synchronizeUser method]-[USER ID:' + u.uid + '][USER Name=' + u.name + '] [USER pending='+u.pending+']');

                Http hStatement = new Http();
                HttpRequest reqStatement = initHttp('GET', 120000);
                //String queryStatement = S_URL+'/v2/statement/72350';//  + u.uid;
                String queryStatement = S_URL+'/v2/statement/'+u.uid;
                reqStatement.setEndpoint(queryStatement);
                system.debug('Calling ' + queryStatement);
                
                HttpResponse respStmt = hStatement.send(reqStatement);
                PointResponse pointResp = null;
                system.debug('RES CODE =' + respStmt.getStatusCode());
                if (respStmt.getStatusCode()==200){
                    String result2 = respStmt.getBody();
                    System.debug('[OPEN] response2 body= ' + result2 );
                    pointResp = (PointResponse)JSON.deserialize(result2, PointResponse.class);
                    System.debug('YYY allocated =' + String.valueOf(pointResp.ob));
                    for(IncentivePoint t : pointResp.items){
                        DateTime timestamp = Datetime.newInstance(t.ts);
                        System.debug('XXX TRANSACTION [date:'+t.ts+'][type:'+t.type+'][points:'+t.points+']');
                        //System.debug('XXX YYYYMM = ' + timestamp.year() + translateMonth(timestamp.month()));

                        String externalKey = hoyaAccountId + String.valueOf(timestamp.year()) + translateMonth(timestamp.month())+t.type;
                        Loyalty_Points__c lp = userTypePointMap.get(externalKey);
                        if(lp==null){
                            lp = new Loyalty_Points__c();
                            lp.external_key__c = externalKey;
                            lp.Indicator__c = translateType(t.type);
                            lp.Description__c = t.typeDescription;
                            lp.Points__c = t.points;
                            lp.Account__c=acc.Id;
                            lp.MonthYear__c =timestamp.year() + translateMonth(timestamp.month());
                            userTypePointMap.put(externalKey, lp);
                        } else {
                            lp.Points__c = lp.Points__c + t.points;
                            userTypePointMap.put(externalKey, lp);
                        }
                    }
                    

                    Database.UpsertResult[] srList = Database.upsert(userTypePointMap.values(), Loyalty_Points__c.external_key__c, false);
                    // Iterate through each returned result
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted contact ID: ' + sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors            
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Contact fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                }
            }
        }
    }

    private static HttpRequest initHttp(String method, Integer timeout){
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setTimeout(timeout);
        req.setHeader('api-key-v2', API_KEY);
        req.setHeader('api-username-v2', API_USERNAME);
        return req;
    }

    public with sharing class IncentivePoint{
        public String id;
        public Long ts;
        public String type;
        public String typeDescription;
        public String source;
        public String sourceDescription;
        public Integer points;
    }
    public with sharing class IncentiveUser{
        public String uid;
        public String name;
        public Integer allocated;
        public Integer pending;
        public Integer logins;
        public String an;
        public String status;
        public Boolean valid;
    }
    private class PointResponse{
        public IncentiveUser user;
        public Long ob;
        public List<IncentivePoint> items;
    }

    private class JSONUserDeserializer{
        String uid{get;set;}
        String name{get;set;}
        String allocated{get;set;}
        Integer logins{get;set;}
        String status{get;set;}
        String em{get;set;}
        Boolean isRegistered{get;set;}
    }

    private static String translateMonth(Integer month){
        switch on month {
            when  1 {return '01';}
            when  2 {return '02';}
            when  3 {return '03';}
            when  4 {return '04';}
            when  5 {return '05';}
            when  6 {return '06';}
            when  7 {return '07';}
            when  8 {return '08';}
            when  9 {return '09';}
            when else {
                return String.valueOf(month);
            }
        }
    }
    private static String translateType(String code){
        switch on code {
            when  'o' {return 'Order';}
            when  'or' {return 'OrderRefund';}
            when  'c' {return 'Claim';}
            when  'cq' {return 'ClaimQuote';}
            when  'cb' {return 'ClaimBonus';}
            when  'acb' {return 'AutomatedClaimBonus';}
            when  'exp' {return 'Expired';}
            when  'ma' {return 'ManagerAllocated';}
            when  'extapi' {return 'ExternalApi';}
            when  't' {return 'Token';}
            when  'nom' {return 'Nomination';}
            when  'bday' {return 'Birthday';}
            when  'empa' {return 'LoyalService';}
            when  'idea' {return 'Idea';}
            when  'st' {return 'SalesTarget';}
            when  'kpit' {return 'KpiTarget';}
            when  'referral' {return 'Referral';}
            when  'empreferral' {return 'EmployeeReferral';}
            when  'regb' {return 'RegistrationBonus';}
            when  'quizp' {return 'QuizParticipation';}
            when  'quizpoints' {return 'QuizPoints';}
            when  'giveaway' {return 'Giveaway';}
            when  'news' {return 'News';}
            when else {
                return 'unknow';
            }
        }
    }
}