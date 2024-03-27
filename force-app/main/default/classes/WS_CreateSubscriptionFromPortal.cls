@RestResource(urlMapping = '/CreateSubscriptionFromPortal')
global with sharing class WS_CreateSubscriptionFromPortal {
    global WS_CreateSubscriptionFromPortal() {

    }

    @HttpPost
    global static void createSubscription() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String recordJson = RestContext.request.requestBody.toString();
        SubRecord subJson;
        try {
            subJson = (SubRecord) JSON.deserialize(recordJson, SubRecord.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        if (String.isBlank(subJson.accountId) || String.isBlank(subJson.subscriptionType) || String.isBlank(subJson.operation) || String.isBlank(subJson.email)) {
            res.responseBody = Blob.valueOf('Missing Fields (AccountId, subscriptionType, email or Operation)');
            res.statusCode = 400;
            return;
        }
        try {
            String CONTACT_SUBSCRIPTION_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
            List<Account> accRecord = [Select Id, Hoya_Account_Id__c From Account Where Id =:subJson.accountId limit 1];
            List<Contact> existingRec = [Select Id, Active_Subscription__c, email, Last_Activation_Date__c, Last_deactivation_date__c, Sync_to_Pardot__c,Subscription_Type__c from Contact Where RecordTypeId =:CONTACT_SUBSCRIPTION_RT AND AccountId =:subJson.accountId AND Subscription_Type__c =:subJson.subscriptionType limit 1];
            List<Contact> insertList = new List<Contact>();
            if (subJson.operation == 'ACTIVATE') {
                if (!existingRec.isEmpty()) {
                    existingRec.get(0).Active_Subscription__c = true;
                    existingRec.get(0).Email = subJson.email;
                    existingRec.get(0).Last_Activation_Date__c = System.today();
                    existingRec.get(0).Last_deactivation_date__c = null;
                    existingRec.get(0).Sync_to_Pardot__c = 'YES';
                    update existingRec;
                } else {
                    Contact con  = new Contact();
                    con.AccountId = subJson.accountId;
                    con.Email = subJson.email;
                    con.Active_Subscription__c = true;
                    con.Last_Activation_Date__c = System.today();
                    con.recordTypeId = CONTACT_SUBSCRIPTION_RT;
                    con.FirstName =accRecord.get(0).Hoya_Account_Id__c + '-'; 
                    con.LastName = subJson.subscriptionType;
                    con.Sync_to_Pardot__c = 'YES';
                    con.Subscription_Type__c = subJson.subscriptionType;
                    insertList.add(con);
                    insert insertList;
                }
            } else if (subJson.operation == 'DEACTIVATE') {
                if (!existingRec.isEmpty()) {
                    existingRec.get(0).Active_Subscription__c = false;
                    existingRec.get(0).Last_deactivation_date__c = System.today();
                    existingRec.get(0).Sync_to_Pardot__c = null;
                    update existingRec;
                } else {
                    res.responseBody = Blob.valueOf('No Active subscription found with this combination');
                    res.statusCode = 400;
                    return;
                }
            } else {
                res.responseBody = Blob.valueOf('Invalid operation specified. Use ACTIVATE or DEACTIVATE');
                res.statusCode = 400;
                return;
            }
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }
    }

    global class SubRecord {
        public Id accountId {get;set;}
        public String subscriptionType {get;set;}
        public String operation {get;set;}
        public String email {get;set;}
    }
}