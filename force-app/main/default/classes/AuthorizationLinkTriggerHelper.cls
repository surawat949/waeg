public with sharing class AuthorizationLinkTriggerHelper {
    
    private static final String ACCOUNT_TEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
	private static final String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();


    public static void entry(
		System.TriggerOperation triggerEvent,
		List < Authorization_Link__c > newList,
		Map < Id, Authorization_Link__c > newMap,
		List < Authorization_Link__c > oldList,
		Map < Id, Authorization_Link__c > oldMap
	) {
        switch on triggerEvent {
			when BEFORE_INSERT {
				// Check for duplicates
				checkDuplicates(newList);

			}
            when AFTER_INSERT {
                replicateAuthorizations(newList);
            }
        }
    }

    private static void checkDuplicates(List<Authorization_Link__c> authLinks) {
        for (Authorization_Link__c authLink : [SELECT Id, Account_Template__c, Authorization__c FROM Authorization_Link__c]) {
            for (Authorization_Link__c newAuthLink : authLinks) {
                if (authLink.Account_Template__c == newAuthLink.Account_Template__c && authLink.Authorization__c == newAuthLink.Authorization__c) {
                    newAuthLink.addError('An Authorization Link between these two entities already exists. Id: '+authLink.Id);
                }
            }
        }
    }

    /**
     * Replicate new aurhorization on each contact associated with the selected account template
     */
    private static void replicateAuthorizations(List<Authorization_Link__c> newList) {
        Set<Id> copyTemplateSet = new Set<Id>();
        Set<Id> masterTemplateSet = new Set<Id>();
        List<Authorization__c> authsToCreate = new List<Authorization__c>();
        List<Authorization_Link__c> newAuthLinkList = [SELECT Id, Account_Template__c, Account_Template__r.RecordTypeId, Account_Template__r.Active_Authorization_Template__c, Authorization__c, Authorization__r.Active_Authorization__c, Authorization__r.Claim_Formatted__c FROM Authorization_Link__c WHERE Id IN :newList];
        for (Authorization_Link__c authLink : newAuthLinkList) {
            if (authLink.Account_Template__r.RecordTypeId == ACCOUNT_TEMPLATE_COPY_RT) {
                // New auth Link is created using Copy Acc template
                copyTemplateSet.add(authLink.Account_Template__c);
            }
            if (authLink.Account_Template__r.RecordTypeId == ACCOUNT_TEMPLATE_MASTER_RT) {
                // New auth Link is created using Master Acc template
                masterTemplateSet.add(authLink.Account_Template__c);
            }            
        }

        // Get copy Acc templates for all master Acc templates
        // Create a mapping of master to its copies
        Map<Id, Set<Id>> masterToCopyTemplatesmap =  new Map<Id, Set<Id>>();
        for (Account_Template__c eachCopyTemp : [Select Id, Master_Template__c from Account_Template__c WHERE Master_Template__c IN: masterTemplateSet AND RecordTypeId = :ACCOUNT_TEMPLATE_COPY_RT]) {
            copyTemplateSet.add(eachCopyTemp.Id);
            if (masterToCopyTemplatesmap.containsKey(eachCopyTemp.Master_Template__c)) {
                Set<Id> tempCopy = masterToCopyTemplatesmap.get(eachCopyTemp.Master_Template__c);
                tempCopy.add(eachCopyTemp.Id);
                masterToCopyTemplatesmap.put(eachCopyTemp.Master_Template__c, tempCopy);
            } else {
                masterToCopyTemplatesmap.put(eachCopyTemp.Master_Template__c, new Set<Id> { eachCopyTemp.Id });
            }
        }

        // Get all the contacts associated with each copy templates
        Map <Id, List<Contact>> templateToContactsMap = new Map <Id, List<Contact>>();
        for (Contact eachCon : [Select Id, Account_Template__c from Contact Where Account_Template__c IN :copyTemplateSet]) {
            if (templateToContactsMap.containsKey(eachCon.Account_Template__c)) {
                List<Contact> contactList = templateToContactsMap.get(eachCon.Account_Template__c);
                contactList.add(eachCon);
                templateToContactsMap.put(eachCon.Account_Template__c, contactList);
            } else {
                templateToContactsMap.put(eachCon.Account_Template__c, new List<Contact> { eachCon });
            }
        }
        for (Authorization_Link__c authLink : newAuthLinkList) {
            if (authLink.Account_Template__r.RecordTypeId == ACCOUNT_TEMPLATE_COPY_RT) {
                if (templateToContactsMap.get(authLink.Account_Template__c) != null) {
                    for (Contact eachCon : templateToContactsMap.get(authLink.Account_Template__c)) {
                        Authorization__c a = new Authorization__c(
                        RecordTypeId = AUTHORIZATION_COPY_RT,
                        Copy_From__c = authLink.Authorization__c,
                        Contact__c = eachCon.Id,
                        Claim_Formatted__c = authLink.Authorization__r.Claim_Formatted__c,
                        DupCheck__c = authLink.Authorization__c + '-' + eachCon.Id,
                        Active_Authorization__c = authLink.Authorization__r.Active_Authorization__c && authLink.Account_Template__r.Active_Authorization_Template__c
                        );
                        authsToCreate.add(a);
                    }
                }
            } else if (authLink.Account_Template__r.RecordTypeId == ACCOUNT_TEMPLATE_MASTER_RT) {
                if (masterToCopyTemplatesmap.get(authLink.Account_Template__c) != null) {
                    for (Id eachCpTempId : masterToCopyTemplatesmap.get(authLink.Account_Template__c)) {
                        if (templateToContactsMap.get(eachCpTempId) != null) {
                            for (Contact eachCon : templateToContactsMap.get(eachCpTempId)) {
                                Authorization__c a = new Authorization__c(
                                RecordTypeId = AUTHORIZATION_COPY_RT,
                                Copy_From__c = authLink.Authorization__c,
                                Contact__c = eachCon.Id,
                                Claim_Formatted__c = authLink.Authorization__r.Claim_Formatted__c,
                                DupCheck__c = authLink.Authorization__c + '-' + eachCon.Id,
                                Active_Authorization__c = authLink.Authorization__r.Active_Authorization__c
                                );
                                authsToCreate.add(a);
                            }   
                        }                    
                    }   
                }
            }
        }
        upsert authsToCreate DupCheck__c;
    }

}