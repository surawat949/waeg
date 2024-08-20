global with sharing class GenerateInvitationHashesBatch implements Database.Batchable<sObject> {
    
    String query;
    private static String SHOP_OWNER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
	
	global GenerateInvitationHashesBatch() {
		query = 'SELECT Id, Registration_Invitation_Hash__c FROM Contact WHERE RecordTypeId = :SHOP_OWNER_RT AND Registration_Invitation_Hash__c = null AND Id NOT IN (SELECT ContactId FROM User)';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Blob requestBlob;
        Blob hash;
        String getTime = string.valueOf(Datetime.Now().getTime()/1000); 
        String hashString;
        for (Contact c : scope) {
            requestBlob = Blob.valueOf(c.Id+getTime);
            hash = Crypto.generateDigest('MD5', requestBlob);
            hashString = EncodingUtil.convertToHex(hash);
            c.Registration_Invitation_Hash__c = hashString;
        }
        try {
            update scope;
        } catch (Exception e) {
            LogException.log(e);
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	

}