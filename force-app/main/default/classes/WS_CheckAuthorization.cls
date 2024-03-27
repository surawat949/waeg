@RestResource(urlMapping = '/CheckAuthorization')
global with sharing class WS_CheckAuthorization {
    private static final String COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();

    @HttpPost
    global static void checkAuthorization() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String authJson = RestContext.request.requestBody.toString();
        AuthDetails authData;
        try {
            authData = (AuthDetails) JSON.deserialize(authJson, AuthDetails.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }

        if (String.isBlank(authData.contactId) || String.isBlank(authData.claimFormatted)) {
            res.responseBody = Blob.valueOf('Missing Fields (ContactId or claimFormatted)');
            res.statusCode = 400;
            return;
        }

        try {
            List<Authorization__c> lstAuths = [Select Id, Active_authorization__c FROM Authorization__c WHERE recordTypeId =:COPY_RT AND Contact__c =:authData.contactId AND claim_Formatted__c =: authData.claimFormatted AND Active_Authorization__c = true];
            if (!lstAuths.isEmpty()) {
                res.responseBody = Blob.valueOf('1');
                res.statusCode = 200;
                return;
            } else {
                res.responseBody = Blob.valueOf('0');
                res.statusCode = 200;
                return;
            }
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }

    }

    global class AuthDetails {
        public Id contactId {get;set;}
        public String claimFormatted {get;set;}
    }


}