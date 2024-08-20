public with sharing class AuthorizationTriggerHelper {

    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
	private static boolean assignedAfterNewAuth = false;
	public static Map<Id, String> masterToClaimsMap = new Map<Id, String>();
    
    public static void entry(
								System.TriggerOperation triggerEvent,
								List <Authorization__c> newList,
								Map<Id, Authorization__c> newMap,
								List <Authorization__c> oldList,
								Map<Id, Authorization__c> oldMap 
							) {
		// Dispatch trigger event to corresponding methods 
		switch on triggerEvent {
            when BEFORE_INSERT {
                // Check for duplicates
				checkDuplicates(newList);

				// auto populate claim formatted strings
				populateClaimFormattedValues(newList);

            }
			when AFTER_INSERT {
                  
				
                List<Authorization__c> scope = new List<Authorization__c>();
				Set<Id> scopeIds = new Set<Id>();
				
				// Assign new masters to all users (deactivated)
				// AB: No need for this logic now. We are no more replicating a new Master auth to all contacts.
				/*for (Authorization__c a : newList) {
					if (a.RecordTypeId == AUTHORIZATION_ORIGINAL_RT) {
						scope.add(a);
					}
				}
				if (!scope.isEmpty()) {
					assignMastersToAllUsers(scope);
					scope.clear();
				}*/

                // Copy all child authorizations when assigned to a user, when Copy Child Authorizations is selected
				for (Authorization__c a : newList) {
					if (a.RecordTypeId == AUTHORIZATION_COPY_RT) {
						scope.add(a);
					}
				}
				if (!scope.isEmpty()) {
					assignChildAuthorizations(scope);
					scope.clear();
				}
			}

	  		when AFTER_UPDATE {
               	List<Authorization__c> activateScopeList 	= new List<Authorization__c>();
				Set<Id> deactivateScopeIds 					= new Set<Id>();
				Set<Id> deactivateMastersIds 				= new Set<Id>();

	  			
				for (Authorization__c a : newList) {
					// Deactivate all child authorizations when authorization is set to inactive
					if (!a.Active_Authorization__c && oldMap.get(a.Id).Active_Authorization__c && a.RecordTypeId == AUTHORIZATION_COPY_RT) {
						deactivateScopeIds.add(a.Id);
					}
					// Activate all child/parent authorizations that are linked to the contact when authorization is set to active
					if (a.Active_Authorization__c && !oldMap.get(a.Id).Active_Authorization__c && a.RecordTypeId == AUTHORIZATION_COPY_RT ) {
						activateScopeList.add(a);
					}
					if (!a.Active_Authorization__c && oldMap.get(a.Id).Active_Authorization__c && a.RecordTypeId == AUTHORIZATION_ORIGINAL_RT) {
						deactivateMastersIds.add(a.Id);
					}
				}
				if (!deactivateScopeIds.isEmpty()) {
					deactivateChildrenAuthorizations(deactivateScopeIds);
				}
				if (!activateScopeList.isEmpty()) {
					//reactivateAuthorizations(activateScopeList);
				}

				if (!deactivateMastersIds.isEmpty()) {
					deactivateCopies(deactivateMastersIds);
				}


				

	  		}
            
            when BEFORE_DELETE {
				// Show error to the user as authorizations can't be deleted, only deactivated.
				/*Boolean hasCustomPermission = FeatureManagement.checkPermission('Can_Delete_Authorizations');
				if (!hasCustomPermission) {
					for (Authorization__c a : oldList) {
						a.addError('Authorizations cannot be deleted. Please deactivate the authorization.');
					}
				} else {
					for (Authorization__c a : oldList) {
						if (a.RecordTypeId == AUTHORIZATION_ORIGINAL_RT) {
							a.addError('Authorizations cannot be deleted. Please deactivate the authorization.');
						}
					}
				}*/
                
            }
	  	}  
	}

	// check if there an existing duplicates
	private static void checkDuplicates(List<Authorization__c> newAuthorizations) {
		Set<Id> contactIds = new Set<Id>();
		Set<Id> masterIds = new Set<Id>(); 
		for (Authorization__c newAuth : newAuthorizations) {
			if (!String.isBlank(newAuth.Contact__c)) {
				contactIds.add(newAuth.Contact__c);
			}
			if (!String.isBlank(newAuth.Copy_From__c)) {
				masterIds.add(newAuth.Copy_From__c);
			}
		}

		Set<String> masterAuthorizationNames = new Set<String>();
		Set<String> masterAuthorizationClaims = new Set<String>();

		for (Authorization__c master : [SELECT Id, Authorization_Name__c,Claim_Formatted__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_ORIGINAL_RT]) {
			masterToClaimsMap.put(master.Id, master.Claim_Formatted__c);
			if(master.Authorization_Name__c != null && master.Claim_Formatted__c != null){
				String authNameUpper = master.Authorization_Name__c.toUpperCase();
				String authClaimUpper = master.Claim_formatted__c.toUpperCase();
				masterAuthorizationNames.add(authNameUpper);
				masterAuthorizationClaims.add(authClaimUpper);
			}
		}

		List<Authorization__c> copyAuthorizations;
		if(!contactIds.isEmpty()) {
			copyAuthorizations = [SELECT Copy_From__c, Contact__c, DupCheck__c, Account_Template__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_COPY_RT AND Contact__c IN :contactIds AND copy_from__c IN :masterIds];
		} else {
			copyAuthorizations = new List<Authorization__c>();
		}

		for (Authorization__c a : newAuthorizations) {
			String newAuthToUpper = String.isBlank(a.Authorization_Name__c) ? '' : a.Authorization_Name__c.toUpperCase();
			String newAuthClaimToUpper = String.isBlank(a.Claim_Formatted__c) ? '' : a.Claim_Formatted__c.toUpperCase();
			if (a.RecordTypeId == AUTHORIZATION_ORIGINAL_RT && (masterAuthorizationNames.contains(newAuthToUpper) || masterAuthorizationClaims.contains(newAuthClaimToUpper))) {
				a.addError('A Master Authorization with the provided name or claim formatted already exists.');
			}
			if (a.RecordTypeId == AUTHORIZATION_COPY_RT) {
				String uniqueId = a.Copy_From__c +'-'+ a.Contact__c;
				// No need to check for duplicate if DupCheck__c value is already set. Happens in case of upsert hence no execution will reach this point.
				if (String.isBlank(a.DupCheck__c)) {
					for (Authorization__c copy : copyAuthorizations) {
						if (copy.DupCheck__c == uniqueId) {
							a.addError('This authorization is already associated with this user. Id: '+copy.Id);
						}
					}	
				}
				a.DupCheck__c = uniqueId;
			}
		}
	}

	/**
	 * For each new authorization automatically fill-in the claim_Formatted__c value based on 
	 * master Authorization claim Formatted value.
	 */
	private static void populateClaimFormattedValues (List<Authorization__c> newList) {
		for (Authorization__c eachAuth : newList) {
			if (eachAuth.RecordTypeId == AUTHORIZATION_COPY_RT && !masterToClaimsMap.isEmpty() && masterToClaimsMap.get(eachAuth.Copy_From__c) != null) {
				eachAuth.Claim_Formatted__c = masterToClaimsMap.get(eachAuth.Copy_From__c);
			}
		}
	}

	// assign child authorizations to all new
	private static void assignChildAuthorizations(List <Authorization__c> newAuthorizations) {
		List<Authorization__c> childAuthorizationsToCreate = new List<Authorization__c>();

		Set<Id> masterAuthorizationIds = new Set<Id>();
		for (Authorization__c a : newAuthorizations) {
			masterAuthorizationIds.add(a.Copy_From__c);
		}

		Map<Id, Authorization__c> masterAuthorizationsMap = new Map<Id, Authorization__c>([SELECT Id, Authorization_Name__c, Claim_Formatted__c, (SELECT Id, Claim_Formatted__c FROM Child_Authorizations__r) FROM Authorization__c WHERE Id IN :masterAuthorizationIds]);
		for (Authorization__c a : newAuthorizations) {
			Authorization__c master = masterAuthorizationsMap.get(a.Copy_From__c);
			for (Authorization__c child : master.Child_Authorizations__r) {
				Authorization__c childInstance = new Authorization__c(
					RecordTypeId = AUTHORIZATION_COPY_RT,
					Contact__c = a.Contact__c,
					Copy_From__c = child.Id,
					Active_Authorization__c = a.Active_Authorization__c,
					Parent_Authorization__c = a.Id,
					Claim_Formatted__c = child.Claim_Formatted__c,
					DupCheck__c = child.Id+'-'+a.Contact__c
				);
				childAuthorizationsToCreate.add(childInstance);
			}
		}
		System.debug('childAuthorizationsToCreate: '+childAuthorizationsToCreate);
		try {
			upsert childAuthorizationsToCreate DupCheck__c;
		}
		catch (Exception e) {
			system.debug(e.getMessage());
			//LogException.log(e);
		}
	}

	private static void deactivateChildrenAuthorizations(Set<Id> newAuthorizationIds) {
		List<Authorization__c> childAuthorizations = [SELECT Id, Active_Authorization__c FROM Authorization__c WHERE Parent_Authorization__c IN :newAuthorizationIds AND RecordTypeId = :AUTHORIZATION_COPY_RT];
		for (Authorization__c a : childAuthorizations) {
			a.Active_Authorization__c = false;
		}
		try {
			update childAuthorizations;
		} catch (Exception e) {
			system.debug(e.getMessage());
			LogException.log(e);
		}
	}

	/*private static void reactivateAuthorizations(List<Authorization__c> newAuthorizations) {
		Set<Id> parentIds = new Set<Id>();
		for (Authorization__c a : newAuthorizations) {
			parentIds.add(a.Parent_Authorization__c);
		}
		List<Authorization__c> parentAuthorizations = [SELECT Id, Active_Authorization__c FROM Authorization__c WHERE Id IN :parentIds AND Active_Authorization__c = FALSE];

		for (Authorization__c parent : parentAuthorizations) {
			parent.Active_Authorization__c = TRUE;
		}

		try {
			update parentAuthorizations;
		} catch (Exception e) {
			LogException.log(e);
		}
	}*/

	/*private static void assignMastersToAllUsers(List<Authorization__c> newMasters) {
		List<Authorization__c> copiesToCreate = new List<Authorization__c>();
		Integer newMastersCount = newMasters.size();
		Integer totalDMLRows = 0;
		Integer countContacts = 0;
		List<User> filteredOwners = [SELECT Id FROM User WHERE CompanyName IN ('HOLI', 'HOLA', 'HLCA', 'HVNA', 'VEUS')];
		//countContacts = Database.countQuery('select count() from contact WHERE OwnerId IN :filteredOwners');
		totalDMLRows = countContacts * newMastersCount;
		Integer atmDMLRows = Limits.getDMLRows();
		// verification to avoid DML Rows limit
		//if (totalDMLRows > 2000 && totalDMLRows != 0) {
			AssignMastersToAllUsersBatch b = new AssignMastersToAllUsersBatch(newMasters);
			Database.executeBatch(b, 200);
			return;
		//}
		
	}*/

	private static void deactivateCopies(Set<Id> masterIds) {
		DeactivateAuthorizationCopiesBatch b = new DeactivateAuthorizationCopiesBatch(masterIds);
		Database.executeBatch(b, 200);
	}

}