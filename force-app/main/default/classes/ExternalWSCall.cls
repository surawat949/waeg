global with sharing class ExternalWSCall {
    
    //static private String S_URL = 'https://kufangdev.theflag.digital';
    static private String ENDPOINT_LOGIN = '/api/oauth-server/server-login';
    static private String ENDPOINT_VALIDATE = '/api/oauth-server/server-validate';
    static private String ENDPOINT_ACTIVATION = '/api/server4server/seiko-activation/';
    //static private String PASSWORD = 'seikoemea';
    //static private String LOGIN = 'seikoemea';
    //static private String SECURITY_TOKEN = 'ARO59TypDSTOjxPCpBuSh9Gk2';
    //static private String CLIENT_SECRET = '8EE5UFAME229OWZTX6LIB47SZYX37UWELGEMGS0HTUIK4KD94DQ8PT1PXZ7C';
    //static private String CLIENT_ID = '1i2khwqf3eas0gkwk40gs4ocggscwck8480w4cs4k0wc8wkggs';
    static private String GRANT_TYPE_PASSWORD = 'password';
    //
    //static private String token = null;
    //static private String token_type = null;

    static public String getNewToken(String url){
        Http h = new Http();
        HttpRequest req = initHttp('GET', 120000);

        Seiko_RedHab_keys__mdt redhab = [SELECT login__c, password__c, client_id__c, client_secret__c, Redhab_URL__c, security_token__c FROM Seiko_RedHab_keys__mdt];
        String S_URL = redhab.Redhab_URL__c;
        String SECURITY_TOKEN = redhab.security_token__c;
        String CLIENT_SECRET = redhab.client_secret__c;
        String CLIENT_ID = redhab.client_id__c;
        String LOGIN = redhab.login__c;
        String PASSWORD = redhab.password__c;

        String params = 'grant_type=' + GRANT_TYPE_PASSWORD
                    + '&client_id=' + CLIENT_ID
                    + '&client_secret=' + CLIENT_SECRET
                    + '&security_token=' + SECURITY_TOKEN
                    + '&username=' + LOGIN
                    + '&password='+ PASSWORD;
        String query = S_URL+ENDPOINT_LOGIN;
        req.setEndpoint(query);
        req.setBody(params);

        system.debug('URL =' + S_URL);
        system.debug('ENDPOINT =' + query);
        system.debug('PARAMS =' + params);
        if(!test.isrunningtest()){
            HttpResponse res = h.send(req);
            if (res.getStatusCode()==200)
            {
                System.debug('[OPEN]XXX CALL succes ' + url );
                string result = res.getBody();            
                system.debug('result::::'+result);

                JSONtokenDeserializer jtoken  = (JSONtokenDeserializer)JSON.deserialize(result, JSONtokenDeserializer.class);
                ExternalWSToken.redabToken = jtoken.access_token;
                String expires = jtoken.expires_in;
                ExternalWSToken.redabTokenType = jtoken.token_type;
                System.debug('[OPEN] TOKEN[' + ExternalWSToken.redabToken + ']:EXPIRE['+expires+']:TYPE['+ExternalWSToken.redabTokenType+']');

            } else {
                system.debug('[OPEN]ERROR STATUS=' + res.getStatusCode());
                system.debug('[OPEN]ERROR BODY=' + res.getBody());
                JSONErrorDeserializer error  = (JSONErrorDeserializer)JSON.deserialize(res.getBody(), JSONErrorDeserializer.class);
                system.debug('[OPEN]ERROR MESSAGE=' + error.error_description);
            }
        }
        return ExternalWSToken.redabToken;
    }

    static public Boolean isTokenValid(){
        System.debug('[VALIDATION] call with ExternalWSToken.redabToken=' + ExternalWSToken.redabToken);
        if(ExternalWSToken.redabToken==null) return false;

        Seiko_RedHab_keys__mdt redhab = [SELECT login__c, password__c, client_id__c, client_secret__c, Redhab_URL__c, security_token__c FROM Seiko_RedHab_keys__mdt];
        String S_URL = redhab.Redhab_URL__c;
        String SECURITY_TOKEN = redhab.security_token__c;
        String CLIENT_SECRET = redhab.client_secret__c;
        String CLIENT_ID = redhab.client_id__c;
        String LOGIN = redhab.login__c;
        String PASSWORD = redhab.password__c;

        boolean isValid = false;
        Http h = new Http();
        HttpRequest req = initHttp('GET', 120000);
        String query = S_URL+ENDPOINT_VALIDATE;
        req.setEndpoint(query);
        req.setHeader('Authorization', ExternalWSToken.redabTokenType + ' ' + ExternalWSToken.redabToken);
        System.debug('[VALIDATION] query=' + query + ', Authorization='+ExternalWSToken.redabTokenType + ' ' + ExternalWSToken.redabToken);
        if(!test.isrunningtest()){
            HttpResponse res = h.send(req);
            if (res.getStatusCode()==200)
            {
                System.debug('[VALIDATION]XXX CALL succes ' + query );
                string result = res.getBody();            
                system.debug('result::::'+result);
                JSONtokenValidateDeserializer tokValid = (JSONtokenValidateDeserializer)JSON.deserialize(result, JSONtokenValidateDeserializer.class);
                System.debug('[VALIDATION]VALID TOKEN[' + ExternalWSToken.redabToken + ']:TYPE['+ExternalWSToken.redabTokenType+']:RESULT['+tokValid.result+']');
                isValid = tokValid.result=='valid';
            } else {
                system.debug('[VALIDATION]ERROR STATUS=' + res.getStatusCode());
                system.debug('[VALIDATION]ERROR BODY=' + res.getBody());
                JSONErrorDeserializer error  = (JSONErrorDeserializer)JSON.deserialize(res.getBody(), JSONErrorDeserializer.class);
                system.debug('[VALIDATION]ERROR MESSAGE=' + error.error_description);
            }
        }
        return isValid;
    }

    
    static public String activateAccount(Id accountId, Id seikoDataId){
        String error='ok';
        System.debug('CALL activateAccount');
        getValidToken();
        
        Seiko_RedHab_keys__mdt redhab = [SELECT login__c, password__c,client_id__c, client_secret__c, Redhab_URL__c, security_token__c FROM Seiko_RedHab_keys__mdt];
        String S_URL = redhab.Redhab_URL__c;
        String SECURITY_TOKEN = redhab.security_token__c;
        String CLIENT_SECRET = redhab.client_secret__c;
        String CLIENT_ID = redhab.client_id__c;
        String LOGIN = redhab.login__c;
        String PASSWORD = redhab.password__c;

        Http h = new Http();
        HttpRequest req = initHttp('GET', 120000);
        String query = S_URL+ENDPOINT_ACTIVATION + accountId;
        req.setHeader('Authorization', ExternalWSToken.redabTokenType + ' ' + ExternalWSToken.redabToken);
        req.setEndpoint(query);

        if(!Test.isrunningtest()){
            HttpResponse res = h.send(req);
            ExternalWSToken.error = null;

            Seiko_data__c sdc = [select id, SVS_Digital_communication_platform__c,WS_error__c from Seiko_data__c where id=:seikoDataId];

            if (res.getStatusCode()==200)
            {
                System.debug('[ACTIVATION]XXX CALL succes ' + query );
                System.debug('[ACTIVATION]XXX CALL succes ' + res.getBody() );
                //sdc.SVS_Digital_communication_platform__c = !sdc.SVS_Digital_communication_platform__c;
                sdc.WS_error__c = 'success';
            } else {
                error = res.getBody();//throw new IllegalArgumentException(res.getBody());
                error = error.substringAfter('message');
                error = error.substring(3,error.length()-3);
                sdc.WS_error__c =  error;
                system.debug('[ACTIVATION]ERROR STATUS=' + res.getStatusCode());
                system.debug('[ACTIVATION]ERROR BODY=' + res.getBody());
                ExternalWSToken.error = res.getBody();
                //JSONActivationErrorDeserializer error  = (JSONActivationErrorDeserializer)JSON.deserialize(res.getBody(), JSONActivationErrorDeserializer.class);
                
            }
            Database.update(sdc);
        }
        return error;
    }

    private class JSONtokenDeserializer{
        String access_token{get;set;}
        String expires_in{get;set;}
        String token_type{get;set;}
    }
    private class JSONtokenValidateDeserializer{
        String result{get;set;}
    }
    private class JSONErrorDeserializer{
        String error{get;set;}
        String error_description{get;set;}
    }
    private class JSONActivationErrorDeserializer{
        String error{get;set;}
        //String code{get;set;}
        //String message{get;set;}
    }

    private static  HttpRequest initHttp(String method, Integer timeout){
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setTimeout(timeout);
        return req;
    }

    public static void doTest(String hoyaAccountId){
        
        Account acc = [select id, hoya_account_id__c, name from account where hoya_account_id__c=:hoyaAccountId];
        String mytoken = getNewToken('url');
        System.debug('[DO_TEST] token = ' + ExternalWSToken.redabToken);
        if(isTokenValid()){
            activateAccount(acc.Id, null);
        }
    }

    public static void getValidToken(){
        System.debug('CALL getValidToken');
        if(!isTokenValid()){
            getNewToken('');
        }
    }
    @future(callout=true)
    public static void updateAccountList(List<Id> accountList){
        System.debug('CALL updateAccountList');
        //getValidToken();
        for(Id accountId : accountList){
            activateAccount(accountId, null);
        }
    }
}