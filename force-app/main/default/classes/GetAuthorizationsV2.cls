@RestResource(urlMapping = '/GetAuthorizationsV2')
global with sharing class GetAuthorizationsV2 {

    private static final String COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();

    @HttpPost
    global static void getAuthorizations() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        JSONDeserializer j;
        try {
            j = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            system.debug('res 2 - fail of json deserialize: '+res);
            return;
        }
        List<Authorization__c> authorizationList = [SELECT Id, Master_Authorization_Name__c, Claim_Formatted__c, Active_Authorization__c, Contact__c, Contact__r.Account_Portal__c, Country_Specific_Copy__c FROM Authorization__c WHERE RecordTypeId = :COPY_RT AND Contact__c = :j.contactId AND Active_Authorization__c = true];
        Map<String, Assign_default_permissions__mdt> allMetadadata = Assign_default_permissions__mdt.getAll();
        Map<String, String> portalCountryMap = new Map<String, String>();
        for (Assign_default_permissions__mdt eachRecord : allMetadadata.values()) {
                        portalCountryMap.put(eachRecord.Account_Portal__c, eachRecord.Authorization_Country_Name__c);
        }
        for (Authorization__c eachAuth : authorizationList) {
            if (eachAuth.Country_Specific_Copy__c && eachAuth.Contact__c != null && eachAuth.Contact__r.Account_Portal__c != null && portalCountryMap.get(eachAuth.Contact__r.Account_Portal__c) != null) {
                // modify claim formatted text
                String[] splits = eachAuth.Claim_Formatted__c.split('-country-');
                eachAuth.Claim_Formatted__c = splits[0] + portalCountryMap.get(eachAuth.Contact__r.Account_Portal__c) + splits[1];
            }

        }
        
        
        res.responseBody = Blob.valueOf(JSON.serialize(authorizationList));
        res.statusCode = 200;
    }

    private class JSONDeserializer {
        Id contactId {
            get;
            set;
        }
    }

}