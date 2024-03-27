public with sharing class AccountTemplateTriggerHelper {

	private static final String ACCOUNT_TEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
	private static final String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();

	 

	public static void entry(
		System.TriggerOperation triggerEvent,
		List < Account_Template__c > newList,
		Map < Id, Account_Template__c > newMap,
		List < Account_Template__c > oldList,
		Map < Id, Account_Template__c > oldMap
	) {
		// Dispatch trigger event to corresponding methods 
		switch on triggerEvent {
			when BEFORE_INSERT {
				// Check for duplicates
				checkDuplicates(newList);

			}
			when AFTER_UPDATE {
				
				Set < Id > scopeActive = new Set < Id > ();
				Set < Id > scopeInactive = new Set < Id > ();
				Set<Id> scopeDefault = new Set<Id>();
				Set<Id> accountIds = new Set<Id>();
				for (Account_Template__c at: newList) {
					//Activate all authorizations
					if (at.Active_Authorization_Template__c && !oldMap.get(at.Id).Active_Authorization_Template__c && at.RecordTypeID == ACCOUNT_TEMPLATE_COPY_RT) {
						scopeActive.add(at.Id);
					}
					//Deactivate all authorizations
					if (!at.Active_Authorization_Template__c && oldMap.get(at.Id).Active_Authorization_Template__c && at.RecordTypeID == ACCOUNT_TEMPLATE_COPY_RT) {
						scopeInactive.add(at.Id);
					}
					//Remove previous Default flag
					if(at.Default__c && !oldMap.get(at.Id).Default__c && at.RecordTypeID == ACCOUNT_TEMPLATE_COPY_RT) {
						scopeDefault.add(at.Id);
						accountIds.add(at.Account__c);
					}
				}

				activateAllAuthorizations(scopeActive);
				deactivateAllAuthorizations(scopeInactive);
				removePreviousDefault(scopeDefault, accountIds);

				

			}
			when BEFORE_DELETE {
				Map<Id, Account_Template__c> masterAccTemplates = new Map<Id, Account_Template__c> ();
				Map<Id, Account_Template__c> copyAccTemplates = new Map<Id, Account_Template__c> ();
				for (Account_Template__c at: oldList) {
					
					if (at.RecordTypeId == ACCOUNT_TEMPLATE_MASTER_RT) {
						masterAccTemplates.put(at.Id, at);
					} else {
						copyAccTemplates.put(at.Id, at);
					}
				}
				if (!copyAccTemplates.isEmpty()) {
					checkForContacts(copyAccTemplates);
				}
				if (!masterAccTemplates.isEmpty()) {
					checkForContactsOnInstances(masterAccTemplates);
				}
			}
		}
	}

	private static void checkDuplicates(List < Account_Template__c > newList) {
		// As the total templates are more than 50K in system, a single transaction wont handle processing all records at once.
		// Hence splitting the master and copy to process and filtering based on accounts for copy templates
		Set<Id> accountIdSet = new Set<Id>();
		List<Account_Template__c> newMasterList = new List<Account_Template__c>();
		
		for (Account_Template__c eachAccTemp : newList) {
			if (eachAccTemp.RecordTypeId == ACCOUNT_TEMPLATE_COPY_RT) {
				accountIdSet.add(eachAccTemp.Account__c);	
			} else if (eachAccTemp.RecordTypeId == ACCOUNT_TEMPLATE_MASTER_RT) {
				newMasterList.add(eachAccTemp);
			}
		}

		List<Account_Template__c> masterList;
		List<Account_Template__c> copyList;
		try {
			masterList = [SELECT Name, RecordTypeId, Account__c, Master_Template__c FROM Account_Template__c Where recordType.Name = 'Master'];
			copyList = [SELECT Name, RecordTypeId, Account__c, Master_Template__c FROM Account_Template__c Where Account__c IN :accountIdSet AND recordTypeId =: ACCOUNT_TEMPLATE_COPY_RT];	
		} catch (Exception ex) {
			LogException.log(ex);
		}

		

		if (!newMasterList.isEmpty()) {
			for (Account_Template__c existingMaster : masterList) {
				String existingName = existingMaster.Name.toUpperCase();
				for (Account_Template__c newAT : newMasterList) {
					String newName = newAT.Name.toUpperCase();
					if (existingName == newName) {
						// Master template only
						newAT.addError('An Account Template with the provided name already exists.');
					}	
				}
			}	
		}
		
		if (copyList != null && !copyList.isEmpty()) {
			for (Account_Template__c existingCopy : copyList) {
				for (Account_Template__c newAT : newList) {
					if (existingCopy.Account__c == newAT.Account__c && existingCopy.Master_Template__c == newAT.Master_Template__c && newAT.RecordTypeId == ACCOUNT_TEMPLATE_COPY_RT) {
						newAT.addError('This Template is already associated with this account. Id: ' + existingCopy.Id);
					}
				}
			}
		}
	}

	private static void activateAllAuthorizations(Set < Id > accTempIds) {
		// get contacts
		try {
			Map < Id, Set < Id >> masterTemplateContactsMap = new Map < Id, Set < Id >> ();
			for (Contact c: [SELECT Id, Account_Template__r.Master_Template__c FROM Contact WHERE Account_Template__c IN: accTempIds]) {
				if (masterTemplateContactsMap.containsKey(c.Account_Template__r.Master_Template__c)) {
					Set < Id > contacts = masterTemplateContactsMap.get(c.Account_Template__r.Master_Template__c);
					contacts.add(c.Id);
					masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, contacts);
				} else {
					masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, new Set < Id > {
						c.Id
					});
				}
			}
			// get authorizations from master
			List < Authorization__c > authorizationsToActivate = new List < Authorization__c > ();
			for (Account_Template__c master: [SELECT Id, (SELECT Id, Authorization__c FROM Authorizations__r) FROM Account_Template__c WHERE Id IN: masterTemplateContactsMap.keySet()]) {
				Set < Id > contactIds = masterTemplateContactsMap.get(master.Id);
				for (Authorization_Link__c a: master.Authorizations__r) {
					for (Id contactId: contactIds) {
						Authorization__c authToActivate = new Authorization__c(
							DupCheck__c = a.Authorization__c + '-' + contactId,
							Active_Authorization__c = true
						);
						authorizationsToActivate.add(authToActivate);
					}
				}
			}
			upsert authorizationsToActivate DupCheck__c;
		} catch (Exception e) {
			system.debug(e.getMessage());
			LogException.log(e);
		}

	}

	private static void deactivateAllAuthorizations(Set < Id > accTempIds) {
		// get contacts
		try {
			Map < Id, Set < Id >> masterTemplateContactsMap = new Map < Id, Set < Id >> ();
			for (Contact c: [SELECT Id, Account_Template__r.Master_Template__c FROM Contact WHERE Account_Template__c IN: accTempIds]) {
				if (masterTemplateContactsMap.containsKey(c.Account_Template__r.Master_Template__c)) {
					Set < Id > contacts = masterTemplateContactsMap.get(c.Account_Template__r.Master_Template__c);
					contacts.add(c.Id);
					masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, contacts);
				} else {
					masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, new Set < Id > {
						c.Id
					});
				}
			}
			// get authorizations from master
			List < Authorization__c > authorizationsToActivate = new List < Authorization__c > ();
			for (Account_Template__c master: [SELECT Id, (SELECT Id, Authorization__c FROM Authorizations__r) FROM Account_Template__c WHERE Id IN: masterTemplateContactsMap.keySet()]) {
				Set < Id > contactIds = masterTemplateContactsMap.get(master.Id);
				for (Authorization_Link__c a: master.Authorizations__r) {
					for (Id contactId: contactIds) {
						Authorization__c authToActivate = new Authorization__c(
							DupCheck__c = a.Authorization__c + '-' + contactId,
							Active_Authorization__c = false
						);
						authorizationsToActivate.add(authToActivate);
					}
				}
			}
			upsert authorizationsToActivate DupCheck__c;
		} catch (Exception e) {
			system.debug(e.getMessage());
			LogException.log(e);
		}
	}

	private static void removePreviousDefault(Set<Id> accTempIds, Set<Id> accountIds) {
		try {
			List<Account_Template__c> templateList = [SELECT Id, Default__c FROM Account_Template__c WHERE Account__c IN :accountIds AND Id NOT IN :accTempIds AND Default__c = true];
			for (Account_Template__c at : templateList) {
				at.Default__c = false;
			}
			update templateList;	
		} catch (Exception e) {
			LogException.log(e);
		}
		
	}

	private static void checkForContacts(Map<Id, Account_Template__c> deletedATs) {
		try {
			for (Account_Template__c at : [SELECT Id, (SELECT Id FROM Contacts__r) FROM Account_Template__c WHERE Id IN :deletedATs.keySet()]) {
				if (!at.Contacts__r.isEmpty()) {
					deletedATs.get(at.Id).addError('An Account Template with associated Contacts cannot be deleted.');
				}
			}	
		} catch (Exception e) {
			LogException.log(e);
		}
	}

	private static void checkForContactsOnInstances(Map<Id, Account_Template__c> deletedATs) {
		Map<Id, List<Account_Template__c>> atsChildrenToDelete = new Map<Id, List<Account_Template__c>>();
		Map<Id, Boolean> canDeleteChildrenMap = new Map<Id, Boolean>(); 
		for (Id deletedMasterId : deletedATs.keySet()){
			canDeleteChildrenMap.put(deletedMasterId, true);
		}
		for (Account_Template__c at : [SELECT Id, Master_Template__c, (SELECT Id FROM Contacts__r) FROM Account_Template__c WHERE Master_Template__c IN :deletedATs.keySet()]) {
			if (!at.Contacts__r.isEmpty()) {
				canDeleteChildrenMap.put(at.Master_Template__c, false);
				deletedATs.get(at.Master_Template__c).addError('An instance of this Account Template has associated contacts. This Account Template cannot be deleted.');
			}
			else {
				if (atsChildrenToDelete.containsKey(at.Master_Template__c)) {
					List<Account_Template__c> atList = atsChildrenToDelete.get(at.Master_Template__c);
					atList.add(at);
					atsChildrenToDelete.put(at.Master_Template__c, atList);
				}
				else {
					atsChildrenToDelete.put(at.Master_Template__c, new List<Account_Template__c> { at });
				}
			}
		}
		List<Account_Template__c> atsToDeleteFiltered = new List<Account_Template__c>();
		for (Id masterId : canDeleteChildrenMap.keySet()) {
			if (canDeleteChildrenMap.get(masterId)) {
				if (atsChildrenToDelete.containsKey(masterId)) {
					atsToDeleteFiltered.addAll(atsChildrenToDelete.get(masterId));
				}
			}
		}
		try {
			delete atsToDeleteFiltered;
		} catch (Exception e) {
			LogException.log(e);
		}
	}
}