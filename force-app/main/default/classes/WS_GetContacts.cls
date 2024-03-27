@RestResource(urlMapping = '/GetContacts')
global with sharing class WS_GetContacts {
    public static final string END_CONSUMER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('End_Consumer').getRecordTypeId();
    private static final String CONTACT_SUBSCRIPTION_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();

    @HttpPost
    global static void getContacts() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
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
            return;
        }
        if (String.isBlank(d.accountId) || String.isBlank(String.valueOf(d.getAll))) {
            res.responseBody = Blob.valueOf('Missing Fields (accountId or getAll)');
            res.statusCode = 400;
            return;
        }

        try {
            List<Contact> contacts;
            if (d.getAll) {
                contacts = [SELECT Id, Title, FirstName, LastName, RecordTypeId, Email, Phone, Deactivate__c, Language_Pick__c, Invite_Portal_Email__c, Contact_Record_Type__c FROM Contact WHERE AccountId = :d.accountId AND recordTypeId != :END_CONSUMER_RT AND recordTypeId != :CONTACT_SUBSCRIPTION_RT];
            } else {
                contacts = [SELECT Id, Title, FirstName, LastName, RecordTypeId, Email, Phone, Deactivate__c, Language_Pick__c,Invite_Portal_Email__c, Contact_Record_Type__c FROM Contact WHERE AccountId = :d.accountId AND Deactivate__c = FALSE AND recordTypeId != :END_CONSUMER_RT  AND recordTypeId != :CONTACT_SUBSCRIPTION_RT];
            }
            res.responseBody = Blob.valueOf(JSON.serialize(contacts));
            res.statusCode = 200;
            return;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        
        
    }

    private class JSONDeserializer {
        private Id accountId {
            get;
            set;
        }

        private boolean getAll {
            get;
            set;
        }
    }

}