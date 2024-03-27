global with sharing class AssignMastersToAllUsersBatch implements Database.Batchable<sObject> {
	
	String query;
    private List<Authorization__c> myList;
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();

	
	global AssignMastersToAllUsersBatch(List<Authorization__c> masters) {
		myList = masters;
		String portal = 'HOYA Contact Lenses';
        query = 'SELECT Id FROM Contact WHERE owner.companyName in (\'HOLI\', \'HOLA\', \'HLCA\', \'HVNA\', \'VEUS\')';
		//Account_portal__c != null AND Account_portal__c != \'HOYA Contact Lenses\'
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Contact> scope) {
        List<Authorization__c> copiesToCreate = new List<Authorization__c>();
        for (Contact c : scope) {
            for (Authorization__c master : myList) {
				Authorization__c a = new Authorization__c(
					RecordTypeId = AUTHORIZATION_COPY_RT,
					Copy_From__c = master.Id,
					Active_Authorization__c = true,
					Contact__c = c.Id,
					Claim_Formatted__c = master.Claim_Formatted__c
				);
				copiesToCreate.add(a);
			}
        }
        try {
            insert copiesToCreate;
        } catch (Exception e) {
            LogException.log(e);
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}