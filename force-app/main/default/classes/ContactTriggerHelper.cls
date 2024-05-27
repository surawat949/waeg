public with sharing class ContactTriggerHelper {

    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_MASTER_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    private static final String CONTACT_SHOP_OWNER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
    private static final String CONTACT_SUBSCRIPTION_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
    private static final String CONTACT_ENDCONSUMER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('End_Consumer').getRecordTypeId();
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
	private static final String CONTACT_Technician_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Technician').getRecordTypeId();

    public static void entry(
        System.TriggerOperation triggerEvent,
        List < Contact > newList,
        Map < Id, Contact > newMap,
        List < Contact > oldList,
        Map < Id, Contact > oldMap
    ) {
        // Dispatch trigger event to corresponding methods 
        switch on triggerEvent {
            when BEFORE_INSERT {
                // populate hash field
                populateHashes(newList);
                populateLanguageDefault(newList);
                populateHoyaContactId(newList);
                modifyOneKeyRecords(newList);
				UpdateSyncFlag(newList,'BEFORE_INSERT',oldMap);
            }
			when BEFORE_UPDATE {
                // populate hash field
                UpdateSyncFlag(newList,'BEFORE_UPDATE',oldMap);
            }
            when AFTER_INSERT {
                Set<Id> nonPortalContacts = new Set<Id>();
                for (Contact c : newList) {
                    /**
                     * Do not create authorizations for-
                     * Subscription contacts
                     * End consumer contacts
                     * One key IQVIA contacts
                     */
                    if(!c.Created_on_portal__c  && c.recordTypeId != CONTACT_SUBSCRIPTION_RT && c.recordTypeId != CONTACT_ENDCONSUMER_RT && c.OnekeyId__c == null) {
                        nonPortalContacts.add(c.Id);
                    }
                }
                Set<Id> contactsToPutDefaultOwner = new Set<Id>();
                for (Contact c : newList) {
                    contactsToPutDefaultOwner.add(c.Id);
                }
                assignAllPermissions(nonPortalContacts, new List<String>());
                setContactOwner(contactsToPutDefaultOwner);
            }
            when AFTER_UPDATE {
                // if Account Template filled, assign permissions
                Set<Id> newAssignmentContacts = new Set<Id>();
                for (Contact c: newList) {
                    if (!String.isBlank(c.Account_Template__c) && String.isBlank(oldMap.get(c.Id).Account_Template__c)) {
                        newAssignmentContacts.add(c.Id);
                    }
                }
                if (!newAssignmentContacts.isEmpty()) {
                    assignPermissions(newAssignmentContacts);
                }

                // if Account Template changed, update assigned permissions
                Map<Id, Contact> contactsMap = new Map<Id, Contact>();
                Set<Id> oldAccTempIds = new Set<Id>();
                for (Contact c: newList) {
                    if (!String.isBlank(c.Account_Template__c) && !String.isBlank(oldMap.get(c.Id).Account_Template__c) && c.Account_Template__c != oldMap.get(c.Id).Account_Template__c) {
                        contactsMap.put(c.Id, c);
                        oldAccTempIds.add(oldMap.get(c.Id).Account_Template__c);
                    }
                }
                if (!contactsMap.isEmpty()) {
                    updatePermissions(contactsMap.keySet(), oldAccTempIds);
                    oldAccTempIds.clear();
                }

                // if Account Template removed, remove permissions related to template
                Set<Id> contactIds = new Set<Id>();
                for (Contact c: newList) {
                    if (String.isBlank(c.Account_Template__c) && !String.isBlank(oldMap.get(c.Id).Account_Template__c)) {
                        oldAccTempIds.add(oldMap.get(c.Id).Account_Template__c);
                        contactIds.add(c.Id);
                    }
                }
                if (!oldAccTempIds.isEmpty() && !contactIds.isEmpty()) {
                    removePermissions(contactIds, oldAccTempIds);
                }
                
                Set<Id> contactIdsToActivate = new Set<Id>();
                Set<Id> contactIdsToDeactivate = new Set<Id>();
                for (Contact c: newList) {
                    if (c.Deactivate__c && !oldMap.get(c.Id).Deactivate__c) {
                        contactIdsToDeactivate.add(c.Id);
                    }
                    else if (!c.Deactivate__c && oldMap.get(c.Id).Deactivate__c) {
                        contactIdsToActivate.add(c.Id);
                    }
                } 
                if (!contactIdsToDeactivate.isEmpty()) {
                    deactivateUsers(contactIdsToDeactivate);
                }

                if (!contactIdsToActivate.isEmpty()) {
                    activateUsers(contactIdsToActivate);
                }
            }
        }
    }

    @future
    public static void assignAllPermissions(Set<Id> contactIds, List<String> activePermsList) {
        List<Contact> contacts = [SELECT Id, RecordTypeId, Account_Portal__c, Account_Template__c, Account_Brand__c, AccountId FROM Contact WHERE Id IN :contactIds];
        Set<Id> newAssignmentContacts = new Set<Id>();
        List<Contact> acctTemplateEmptyList = new List<Contact>();
        List<Authorization__c> newAuths = new List<Authorization__c>();
        Map<String, String> mapPortalToClaimString = new Map<String, String>();


        for (Assign_default_permissions__mdt defAuth : Assign_default_permissions__mdt.getAll().values()) {
            mapPortalToClaimString.put(defAuth.Account_Portal__c, defAuth.Authorization_Claim_Formatted__c);
        }

        Map<String, Authorization__c> allmasters =  new Map<String, Authorization__c>();
        for (Authorization__c master : [SELECT Id, Claim_Formatted__c, Authorization_Name__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_MASTER_RT]) {
            allmasters.put(master.Claim_Formatted__c, master);
        }
            for (Contact c : contacts) {
            // create Authorizations for Employees with permission sent through REST request
            for (String eachPermission : activePermsList) {
                if (allmasters.get(eachPermission) != null) {
                    Authorization__c master = allmasters.get(eachPermission);
                    Authorization__c auth = new Authorization__c(
                    RecordTypeId = AUTHORIZATION_COPY_RT,
                    Copy_From__c = master.Id,
                    Contact__c = c.Id,
                    Claim_Formatted__c = master.Claim_Formatted__c,
                    DupCheck__c = master.Id+'-'+c.Id,
                    Active_Authorization__c = true
                );
                    newAuths.add(auth);
                }
            }

            // Creating country specific Auth OR portal Specific Auth like demoportalUser etc.
            String claimFormatted = mapPortalToClaimString.get(c.Account_Portal__c);
            if (String.isNotBlank(claimFormatted) && allmasters.get(claimFormatted) != null) {
                Authorization__c master = allmasters.get(claimFormatted);
                Authorization__c auth = new Authorization__c(
                RecordTypeId = AUTHORIZATION_COPY_RT,
                Copy_From__c = master.Id,
                Contact__c = c.Id,
                Claim_Formatted__c = master.Claim_Formatted__c,
                DupCheck__c = master.Id+'-'+c.Id,
                Active_Authorization__c = true
                );
                newAuths.add(auth);
            }

            // Creating Default Auth for all users - 'istradeportaluser'
            String defaultPermission = mapPortalToClaimString.get('default');
            if (String.isNotBlank(defaultPermission) && allmasters.get(defaultPermission) != null) {
                Authorization__c master = allmasters.get(defaultPermission);
                Authorization__c auth = new Authorization__c(
                RecordTypeId = AUTHORIZATION_COPY_RT,
                Copy_From__c = master.Id,
                Contact__c = c.Id,
                Claim_Formatted__c = master.Claim_Formatted__c,
                DupCheck__c = master.Id+'-'+c.Id,
                Active_Authorization__c = true
                );
                newAuths.add(auth);
            }

            // Creating Default Auth for SEIKO users - 'isseikotradeportaluser'
            String defaultSeikoPermission = mapPortalToClaimString.get('defaultseiko');
            if (c.Account_Brand__c == 'SEIKO' && String.isNotBlank(defaultSeikoPermission) && allmasters.get(defaultSeikoPermission) != null) {
                Authorization__c master = allmasters.get(defaultSeikoPermission);
                Authorization__c auth = new Authorization__c(
                    RecordTypeId = AUTHORIZATION_COPY_RT,
                    Copy_From__c = master.Id,
                    Contact__c = c.Id,
                    Claim_Formatted__c = master.Claim_Formatted__c,
                DupCheck__c = master.Id+'-'+c.Id,
                Active_Authorization__c = true
                );
                newAuths.add(auth);
                }

            if(String.isNotBlank(c.Account_Template__c)) {
                    newAssignmentContacts.add(c.Id);
                }
                else if(c.RecordTypeId == CONTACT_SHOP_OWNER_RT) {
                    acctTemplateEmptyList.add(c);
                }
            }

        try {
            upsert newAuths DupCheck__c;
            if (!newAssignmentContacts.isEmpty()) {
                // assign all other authorizations related to template
                assignPermissions(newAssignmentContacts);
            }

            if (!acctTemplateEmptyList.isEmpty()) {
                checkForDefaultAccountTemplate(acctTemplateEmptyList);
            }
        } catch (Exception e) {
            LogException.log(e);
        }

    }

    private static void assignPermissions(Set<Id> contactIds) {
        Map < Id, List < Contact >> masterTemplateContactsMap = new Map < Id, List < Contact >> ();
        Set < Id > masterContactsRequired = new Set < Id > ();
        List < Authorization__c > authsToCreate = new List < Authorization__c > ();
        try {
            List < Contact > contacts = [SELECT Id, Account_Template__c, Account_Template__r.Active_Authorization_Template__c, Account_Template__r.Master_Template__c FROM Contact WHERE Id IN: contactIds];

            for (Contact c: contacts) {
                masterContactsRequired.add(c.Account_Template__r.Master_Template__c);
                if (masterTemplateContactsMap.containsKey(c.Account_Template__r.Master_Template__c)) {
                    List < Contact > existingContacts = masterTemplateContactsMap.get(c.Account_Template__r.Master_Template__c);
                    existingContacts.add(c);
                    masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, existingContacts);
                } else {
                    masterTemplateContactsMap.put(c.Account_Template__r.Master_Template__c, new List < Contact > {
                        c
                    });
                }
            }

            for (Account_Template__c master: [SELECT Id, (SELECT Authorization__c, Authorization__r.Claim_Formatted__c FROM Authorizations__r) FROM Account_Template__c WHERE Id IN: masterContactsRequired]) {
                for (Contact c: masterTemplateContactsMap.get(master.Id)) {
                    for (Authorization_Link__c authLink: master.Authorizations__r) {
                        Authorization__c a = new Authorization__c(
                            RecordTypeId = AUTHORIZATION_COPY_RT,
                            Copy_From__c = authLink.Authorization__c,
                            Active_Authorization__c = c.Account_Template__r.Active_Authorization_Template__c,
                            Contact__c = c.Id,
                            Account_Template__c = c.Account_Template__c,
                            DupCheck__c = authLink.Authorization__c+'-'+c.Id,
                            Claim_Formatted__c = authLink.Authorization__r.Claim_Formatted__c
                        );
                        authsToCreate.add(a);
                    }
                }
            }
            system.debug('179: '+authsToCreate);
            upsert authsToCreate DupCheck__c;
        } catch (Exception e) {
            system.debug(e.getMessage());
            LogException.log(e);
        }

    }

    private static void checkForDefaultAccountTemplate(List < Contact > scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, List<Contact>> accountWithContactsMap = new Map<Id, List<Contact>>();
        for (Contact c : scope) {
            if (accountWithContactsMap.containsKey(c.AccountId)) {
                List<Contact> existingContacts = accountWithContactsMap.get(c.AccountId);
                existingContacts.add(c);
                accountWithContactsMap.put(c.AccountId, existingContacts);
            }
            else {
                accountWithContactsMap.put(c.AccountId, new List<Contact> { c });
            }
        }
        for (Account_Template__c at : [SELECT Id, Account__c FROM Account_Template__c WHERE Default__c = TRUE AND Account__c IN :accountWithContactsMap.keySet()]) {
            for (Contact c : accountWithContactsMap.get(at.Account__c)) {
                c.Account_Template__c = at.Id;
                contactsToUpdate.add(c);
            }
        }
        update contactsToUpdate;
    }

    private static void updatePermissions(/*Map<Id, Contact> contactsMap*/Set<Id> contactIds, Set<Id> oldAccTempIds) {
        try {
            removePermissions(contactIds, oldAccTempIds);
            assignPermissions(contactIds);
            
        } catch (Exception e) {
            LogException.log(e);
        }
    }

    private static void removePermissions(Set<Id> contactIds, Set<Id> oldAccTempIds) {

        List<Authorization__c> authsToUpdate = [SELECT Id, Active_Authorization__c, Account_Template__c FROM Authorization__c WHERE Account_Template__c IN :oldAccTempIds AND Contact__c IN :contactIds];
        for (Authorization__c a : authsToUpdate) {
            a.Active_Authorization__c = false;
            a.Account_Template__c = null;
        }
        try {
            update authsToUpdate;
        } catch (Exception e) {
            LogException.log(e);
        }
        
    }

    private static void populateHashes(List<Contact> contacts) {
        Blob requestBlob;
        Blob hash;
        String getTime = string.valueOf(Datetime.Now().getTime()/1000); 
        String hashString;
        for (Contact c : contacts) {
            Integer randomNumber = Integer.valueof((Math.random() * 100000));
            requestBlob = Blob.valueOf(c.LastName+getTime+String.valueOf(randomNumber));
            hash = Crypto.generateDigest('MD5', requestBlob);
            hashString = EncodingUtil.convertToHex(hash);
            c.Registration_Invitation_Hash__c = hashString;
        }        
    }

    // set default language equal to account language 
    private static void populateLanguageDefault(List<Contact> contacts) {
        for (Contact c : contacts) {
            if(c.Language_Pick__c==null){
                c.Language_Pick__c = c.Account_Language__c == 'us' ? 'en-us' : c.Account_Language__c;
            }
        }        
    }

    // currently SEIKO only
    private static void populateHoyaContactId(List<Contact> lstContacts) {
        try {
            Set<Id> accIdSet = new Set<Id>();
            String brand = 'SEIKO';
            for (Contact eachCon : lstContacts) {
                if (eachCon.AccountId != null) {
                    accIdSet.add(eachCon.AccountId);
                }
            }
            Map<Id, Account> accMap = new Map<Id,Account>([Select Id,name,Brand__c from Account Where Id IN: accIdSet]);
            for (Contact eachCon : lstContacts) {
                if (eachCon.AccountId != null) {
                    if (accMap.get(eachCon.AccountId).Brand__c == brand) {
                        eachCon.Hoya_Contact_ID__c = eachCon.Firstname + eachCon.Lastname + eachCon.AccountId;
                    }
                }
            }
        } catch (Exception e) {
            LogException.log(e);
        }
    }


    private static void modifyOneKeyRecords (List<Contact> lstContacts) {
        Set<Id> oneKeyAccIds = new Set<Id>();
        List<Contact> lstOnekeyCon = new List<Contact>();
        Map<String, Owner_Assignmet_Rules_IQVIA__mdt> allMetadadata = Owner_Assignmet_Rules_IQVIA__mdt.getAll();
        for (Contact eachCon : lstContacts) {
            if (eachCon.OnekeyId__c != null && eachCon.OnekeyId__c != '') {
                eachCon.recordTypeId = CONTACT_OPTHO_RT;
                oneKeyAccIds.add(eachCon.AccountId);
                lstOnekeyCon.add(eachCon);

                // Set the country specific pre-defined owners for newly inserted iqvia records
                if (eachCon.OwnerId == '005b0000000EOhtAAG') { // record downloaded using automated process
                    for (Owner_Assignmet_Rules_IQVIA__mdt eachCountry : allMetadadata.values()) {
                        if (eachCon.OnekeyId__c.startsWith(eachCountry.Country_Code__c) && !String.isEmpty(eachCountry.Default_Owner_Id__c)) {
                            eachCon.OwnerId = eachCountry.Default_Owner_Id__c;
                        }
                    }   
                }
            }

        }
        Map<Id, Account> mapAccount;
        if (!oneKeyAccIds.isEmpty()) {
            mapAccount = new Map<Id,Account>([Select Id, shippingCity, shippingCountry, shippingpostalCode,shippingStreet, shippingState FROM Account Where Id IN: oneKeyAccIds]);
        }
        if (mapAccount != null && !mapAccount.isEmpty()) {
            for (Contact eachCon : lstOnekeyCon) {
                if (eachCon.AccountId != null && mapAccount.get(eachCon.AccountId) != null) {
                    Account parentAcc = mapAccount.get(eachCon.AccountId);
                    eachCon.MailingCity = parentAcc.ShippingCity;
                    eachCon.MailingCountry = parentAcc.ShippingCountry;
                    eachCon.MailingPostalCode = parentAcc.ShippingPostalCode;
                    eachCon.MailingState = parentAcc.ShippingState;
                    eachCon.MailingStreet = parentAcc.ShippingStreet;
                }
            }
        }

    }

    // set the default owner when created by integration user
    private static void setContactOwner(Set<Id> contactsId) {
        List<Contact> contacts = [SELECT Id, Name,Owner.Profile.Name,OwnerId,Account.OwnerId,recordTypeId FROM Contact Where Id =: contactsId];
        List<Contact> list_to_update = new List<Contact>();
        for (Contact c : contacts) {
            system.debug('#### c  ' + c.Owner.Profile.Name);
            if(c.Owner.Profile.Name == 'API ONLY Data Integration SYSADMIN' && c.recordTypeId != CONTACT_ENDCONSUMER_RT){
                c.OwnerId = c.Account.OwnerId;
                list_to_update.add(c);
            }
        }
        if(list_to_update.size() > 0)
            update list_to_update;
    }

    @future
    private static void deactivateUsers(Set<Id> contactIds) {
        List<User> usersToDeactivateList = [SELECT Id, IsActive FROM User WHERE ContactId IN :contactIds];
        for (User u : usersToDeactivateList) {
            u.IsActive = false;
        }
        try {
            update usersToDeactivateList;
        } catch (Exception e) {
            LogException.log(e);
        }
    }

    @future
    private static void activateUsers(Set<Id> contactIds) {
        List<User> usersToActivateList = [SELECT Id, IsActive FROM User WHERE ContactId IN :contactIds];
        for (User u : usersToActivateList) {
            u.IsActive = true;
        }
        try {
            update usersToActivateList;
        } catch (Exception e) {
            LogException.log(e);
        }
    }
	
	public static void UpdateSyncFlag(List<Contact> newContacts, String type,Map < Id, Contact > oldMap){
		Set<String> settings = Countries_With_MC_Sync_Activation__c.getAll().keySet();
        List<Contact> contactlist = new List<Contact>();
        Set<String> allowedRecordTypes = new Set<String>{CONTACT_OPTHO_RT, CONTACT_Technician_RT, CONTACT_SUBSCRIPTION_RT, CONTACT_ENDCONSUMER_RT};
        Map<Id, String> accountCountries = new Map<Id, String>();
        List<Id> accountIds = new List<Id>();
        for (Contact con : newContacts) {
        	if (con.AccountId != null) {
				accountIds.add(con.AccountId);
        	}
    	}
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,Shop_Country__c FROM Account WHERE Id IN :accountIds]);
		for(Contact newContact : newContacts) {
            if((accountMap.get(newContact.AccountId)) != null){
                if (!allowedRecordTypes.contains(newContact.RecordTypeId) && settings.contains((accountMap.get(newContact.AccountId)).Shop_Country__c)) {//Email has to be changed
                    if(type == 'BEFORE_INSERT' && newContact.Email != ''){
                        newContact.sync_marketing_cloud__c = true;
                    }else if(type == 'BEFORE_Update' && String.isNotBlank(newContact.Email) && newContact.Email != oldMap.get(newContact.Id).Email){
                        newContact.sync_marketing_cloud__c = true;
                    }else if(String.isBlank(newContact.Email)){
                        newContact.sync_marketing_cloud__c = false;
                    }
                }
           	}
        }
    }
}