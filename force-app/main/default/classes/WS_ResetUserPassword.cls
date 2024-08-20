@RestResource(urlMapping = '/ResetUserPassword')
global with sharing class WS_ResetUserPassword {

    @HttpPost
    global static void resetPassword() {
        RestResponse res = RestContext.response;
        system.debug('requestbody: '+ RestContext.request.requestBody);
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String stringJson = RestContext.request.requestBody.toString();
        JSONDeserializer d;
        try {
            d = (JSONDeserializer) JSON.deserialize(stringJson, JSONDeserializer.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }

        if (String.isBlank(d.token) || String.isBlank(d.password) || String.isBlank(d.context)) {
            res.responseBody = Blob.valueOf('Missing Fields (token, password or context)');
            res.statusCode = 400;
            return;
        }
        
        try {
            User usr = [SELECT Id, Reset_Password_Token__c, Reset_Password_Token_Expiration__c, Reset_Password_Context__c, username FROM User WHERE Reset_Password_Token__c = :d.token];
            System.setPassword(usr.Id, d.password);
            usr.Reset_Password_Token__c = null;
            usr.Reset_Password_Token_Expiration__c = null;
            usr.Reset_Password_Context__c = d.context;
            update usr;
            if (d.context == 'NewEmployee') {
                LightningLoginFormController.sendEventToGA(usr.username, '', 'registration', '');    
            }
            
            res.responseBody = Blob.valueOf('1');
            res.statusCode = 200;
            return;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }
        

        
        
    }

    private class JSONDeserializer {
        String token {
            get;
            set;
        }
        String password {
            get;
            set;
        }
        String context {
            get;
            set;
        }
    }

}