global with sharing class DeactivateAuthorizationCopiesBatch implements Database.Batchable<sObject> {
	
    String query;
    Set<Id> masterIds;
	
	global DeactivateAuthorizationCopiesBatch(Set<Id> masterIdsSent) {
        masterIds = masterIdsSent;
        query = 'SELECT Id, Active_Authorization__c FROM Authorization__c WHERE Active_Authorization__c = TRUE AND Copy_From__c IN :masterIds';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Authorization__c> scope) {
        for (Authorization__c a : scope) {
			a.Active_Authorization__c = false;
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