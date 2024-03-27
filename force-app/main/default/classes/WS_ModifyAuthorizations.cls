/**
 * This web service is used to for My Account page to modify the authorizations for any contact 
 * through My Account page (activate/deactivate/insert).
 * This web service does not support modification in country specific authorizations.
 * 
 */

@RestResource(urlMapping = '/ModifyAuthorizations')
global with sharing class WS_ModifyAuthorizations {
    
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    
    global WS_ModifyAuthorizations() {
    }

    @HttpPost
    global static void modifyAuthorizations() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String changeJson = RestContext.request.requestBody.toString();
        ChangeRequest reqWrapper;
        try {
            reqWrapper =  (ChangeRequest) JSON.deserialize(changeJson, ChangeRequest.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        if (String.isBlank(reqWrapper.contactId) || reqWrapper.authsMap.isEmpty()) {
            res.responseBody = Blob.valueOf('Missing Fields (ContactId or AuthsMap)');
            res.statusCode = 400;
            return;
        }

        Map<String, Authorization__c> allmasters =  new Map<String, Authorization__c>();
        for (Authorization__c master : [SELECT Id, Claim_Formatted__c, Authorization_Name__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_ORIGINAL_RT AND Claim_Formatted__c IN :reqWrapper.authsMap.keySet() AND Active_Authorization__c = TRUE]) {
            allmasters.put(master.Claim_Formatted__c, master);
        }
        List<Authorization__c> upsertList = new List<Authorization__c>();
        for (String claimFormatted : reqWrapper.authsMap.keySet()) {
            if (allmasters.get(claimFormatted) != null) {
                Authorization__c master = allmasters.get(claimFormatted);
                Authorization__c auth = new Authorization__c(
                RecordTypeId = AUTHORIZATION_COPY_RT,
                Copy_From__c = master.Id,
                Contact__c = reqWrapper.contactId,
                Claim_Formatted__c = master.Claim_Formatted__c,
                DupCheck__c = master.Id + '-' + reqWrapper.contactId,
                Active_Authorization__c = reqWrapper.authsMap.get(claimFormatted)
                );
                upsertList.add(auth);    
            } else {
                res.responseBody = Blob.valueOf('Could not find claimFormatted string:' + claimFormatted);
                res.statusCode = 400;
                return;
            }
            
        }

        try {
            upsert upsertList DupCheck__c;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        

    }

    public class ChangeRequest {
        public Id contactId {get;set;}
        Map<String, Boolean> authsMap {get;set;}
    }

}