public with sharing class EyeDoctorVisitPlanningController {
    private static String clinicRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    private static String opthalmologistRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    
    // Wrapper class to hold Account and related Contacts
    public class AccountWrapper {
        @AuraEnabled public Id acrId { get; set; }
        @AuraEnabled public Id accountId { get; set; }
        @AuraEnabled public String accountName { get; set; }
        @AuraEnabled public String shopStreet { get; set; }
        @AuraEnabled public String shopCity { get; set; }
        @AuraEnabled public String shopPostalCode { get; set; }
        @AuraEnabled public String shopState { get; set; }
        @AuraEnabled public String visitZone { get; set; }
        @AuraEnabled public Boolean isDirect { get; set; }
        @AuraEnabled public List<ContactWrapper> contacts { get; set; }
        @AuraEnabled public Integer contactCount { get; set; }
        // Constructor
        public AccountWrapper(AccountContactRelation acc,ID acrId) {
            this.acrId = acrId;
            this.accountId = acc.Id;
            this.accountName = acc.Account.Clinic_Name__c;
            this.shopStreet = acc.Account.Shop_Street__c;
            this.shopCity = acc.Account.Shop_City__c;
            this.shopPostalCode = acc.Account.Shop_Postal_Code__c;
            this.shopState = acc.Account.Shop_State__c;
            this.visitZone = acc.Account.Segmentation_Net__c;
            this.IsDirect = acc.IsDirect;
            this.contacts = new List<ContactWrapper>();
        }
        // Constructor
        public AccountWrapper() {
            this.contacts = new List<ContactWrapper>();
        }
    }
    
    // Wrapper class to hold Contact details
    public class ContactWrapper {
        @AuraEnabled public Id contactId { get; set; }
        @AuraEnabled public Id childAcrId { get; set; }
        @AuraEnabled public String contactName { get; set; }
        @AuraEnabled public String onekeyId { get; set; }
        @AuraEnabled public String ownerName { get; set; }
        @AuraEnabled public String individualStatus { get; set; }
        @AuraEnabled public String currentState { get; set; }
        @AuraEnabled public String miyoSmartSegmentation { get; set; }
        @AuraEnabled public String miyoSmartAttitude { get; set; }
        @AuraEnabled public Date lastContactVisitDate { get; set; }
        @AuraEnabled public String mainStructureName { get; set; }
        @AuraEnabled public String preferredContactDayTime { get; set; }
        @AuraEnabled public String specialization { get; set; }
        @AuraEnabled public Boolean preferredPlace { get; set; }
        @AuraEnabled public Boolean targetContact { get; set; }
        
        // Constructor
        public ContactWrapper(Contact con, Boolean pref, Id childAcrId) {
            this.childAcrId = childAcrId;
            this.contactId = con.Id;
            this.contactName = con.Name;
            this.onekeyId = con.OnekeyId__c;
            this.ownerName = con.Owner_Name__c;
            this.individualStatus = con.Individual_Status__c;
            this.currentState = con.Current_State__c;
            this.miyoSmartSegmentation = con.MiyoSmart_Segmentation__c;
            this.miyoSmartAttitude = con.MiyoSmart_Attitude__c;
            this.lastContactVisitDate = con.Last_contact_visit_date__c;
            this.mainStructureName = con.Main_structure_Name__c;
            this.preferredContactDayTime = con.Preferred_contact_day_time__c;
            this.specialization = con.Specialization__c;
            this.targetContact = con.Contact_Target_List__c;
            this.preferredPlace = pref;
        }
    }
    
    // Query the RecordType object to get the record type by developer name
    @AuraEnabled(cacheable=true)
    public static String getRecordTypeId(String objectName, String developerName) {
        try {
            RecordType recordType = [SELECT Id FROM RecordType WHERE SObjectType = :objectName AND DeveloperName = :developerName LIMIT 1];
            return recordType.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Record Type not found: ' + e.getMessage());
        }
    }
    
    // Method to fetch Account and related Contact data from AccountContactRelationship
    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountVisitPlanningData() {
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        Set<Id> accountIds = new Map<Id, Account>([SELECT Id FROM Account WHERE RecordTypeId = :clinicRecordTypeId LIMIT 5000]).keySet();
        // Query the AccountContactRelationship object and access related Account and Contact fields
        List<AccountContactRelation> acrList = [
            SELECT AccountId, ContactId, Contact.Name, Contact.OnekeyId__c, Contact.Owner_Name__c, Account.Clinic_Name__c, 
                   Contact.Individual_Status__c, Contact.Current_State__c, Contact.MiyoSmart_Segmentation__c,Contact.Contact_Target_List__c, 
                   Contact.MiyoSmart_Attitude__c, Contact.Last_contact_visit_date__c, Contact.Main_structure_Name__c, 
                   Contact.Preferred_contact_day_time__c, Contact.Specialization__c,IsDirect,Preferred_place_for_visit__c,
                   Account.Name, Account.Shop_Street__c, Account.Shop_City__c, Account.Shop_Postal_Code__c, 
                   Account.Shop_State__c, Account.Segmentation_Net__c, Account.TACTICOM_SOF__c
            FROM AccountContactRelation
            WHERE AccountId IN :accountIds AND Account.RecordTypeId = :clinicRecordTypeId AND Contact.RecordTypeId = :opthalmologistRecordTypeId
            AND IsActive = true Order By Contact.Name limit 10000
        ];
        
        // Create a map to group AccountContactRelation records by AccountId
        Map<Id, List<AccountContactRelation>> accountContactMap = new Map<Id, List<AccountContactRelation>>();
        
        for (AccountContactRelation acr : acrList) {
            if (!accountContactMap.containsKey(acr.AccountId)) {
                accountContactMap.put(acr.AccountId, new List<AccountContactRelation>());
            }
            accountContactMap.get(acr.AccountId).add(acr);
        }
        
        // Loop through each AccountContactRelation and create an AccountWrapper for each ACR
        for (AccountContactRelation acr : acrList) {
            // Create an AccountWrapper for each individual ACR
            AccountWrapper accWrapper = new AccountWrapper(acr, acr.Id);
            accWrapper.accountId = acr.AccountId;
            accWrapper.accountName = acr.Account.Clinic_Name__c;
            accWrapper.shopStreet = acr.Account.Shop_Street__c;
            accWrapper.shopCity = acr.Account.Shop_City__c;
            accWrapper.shopPostalCode = acr.Account.Shop_Postal_Code__c;
            accWrapper.shopState = acr.Account.Shop_State__c;
            accWrapper.visitZone = acr.Account.Segmentation_Net__c;
            
            // First, add the contact related to this particular ACR (so it appears first)
            ContactWrapper mainContactWrapper = new ContactWrapper(acr.Contact, acr.Preferred_place_for_visit__c, acr.Id);
            accWrapper.contacts.add(mainContactWrapper);
            
            // Then, add all other contacts related to this AccountId (excluding the current ACR)
            for (AccountContactRelation relatedAcr : accountContactMap.get(acr.AccountId)) {
                if (relatedAcr.Id != acr.Id) {  // Avoid adding the current ACR's contact again
                    ContactWrapper relatedContactWrapper = new ContactWrapper(relatedAcr.Contact, relatedAcr.Preferred_place_for_visit__c, relatedAcr.Id);
                    accWrapper.contacts.add(relatedContactWrapper);
                }
            }
            
            // Add the AccountWrapper to the final list
            accountWrapperList.add(accWrapper);
        }
        
        return accountWrapperList;
    }
    
    
    @AuraEnabled
    public static List<AccountWrapper> filterAccounts(List<Map<String, String>> filters) {
        Map<String, String> fieldMap = new Map<String, String>{
            'accountId' => 'AccountId',
                'accountName' => 'Account.Clinic_Name__c',
                'shopStreet' => 'Account.Shop_Street__c',
                'shopCity' => 'Account.Shop_City__c',
                'shopPostalCode' => 'Account.Shop_Postal_Code__c',
                'shopState' => 'Account.Shop_State__c',
                'visitZone' => 'Account.visitZone',
                'contactId' => 'ContactId',
                'contactName' => 'Contact.Name',
                'onekeyId' => 'Contact.OnekeyId__c',
                'ownerName' => 'Contact.Owner_Name__c',
                'individualStatus' => 'Contact.Individual_Status__c',
                'currentState' => 'Contact.Current_State__c',
                'miyoSmartSegmentation' => 'Contact.MiyoSmart_Segmentation__c',
                'miyoSmartAttitude' => 'Contact.MiyoSmart_Attitude__c',
                'lastContactVisitDate' => 'Contact.Last_contact_visit_date__c',
                'mainStructureName' => 'Contact.Main_structure_Name__c',
                'preferredContactDayTime' => 'Contact.Preferred_contact_day_time__c',
                'specialization' => 'Contact.Specialization__c',
                'preferredPlace' => 'Preferred_place_for_visit__c'
                // Add more field mappings as needed
                };
                    List<String> acrConditions = new List<String>();
        List<String> accountConditions = new List<String>();
        String sortString = '';
        Boolean fetchChildACR = false;
        // Loop through the account filters and dynamically build the conditions list for Account
        for (Map<String, String> filter : filters) {
            String field = filter.get('key');
            String value = filter.get('value');
            
            if (String.isNotBlank(value) && value != '' && value != 'undefined' && value != '[]') {
                System.debug('field '+field+ ' - ' +value);
                if (field == 'city') {
                    fetchChildACR = true;
                    accountConditions.add('Account.Shop_City__c LIKE \'' + value + '%\'');
                    acrConditions.add('Account.Shop_City__c LIKE \'' + value + '%\'');
                } else if (field == 'zip') {
                    fetchChildACR = true;
                    accountConditions.add('Account.Shop_Postal_Code__c LIKE \'' + value + '%\'');
                    acrConditions.add('Account.Shop_Postal_Code__c LIKE \'' + value + '%\'');
                } else if (field == 'state') {
                    fetchChildACR = true;
                    accountConditions.add('Account.Shop_State__c LIKE \'' + value + '%\'');
                    acrConditions.add('Account.Shop_State__c LIKE \'' + value + '%\'');
                } else if (field == 'visitZone') {
                    fetchChildACR = true;
                    accountConditions.add('Account.TACTICOM_SOF__c LIKE \'' + value + '%\'');
                    acrConditions.add('Account.TACTICOM_SOF__c LIKE \'' + value + '%\'');
                } else if (field == 'miyoSegmentation') {
                    fetchChildACR = true;
                    acrConditions.add('Contact.MiyoSmart_Segmentation__c LIKE \'' + value + '%\'');
                } else if (field == 'miyoAttitude') {
                    acrConditions.add('Contact.MiyoSmart_Attitude__c LIKE \'' + value + '%\'');
                } else if (field == 'localSpecialization') {
                    fetchChildACR = true;
                    acrConditions.add('Contact.Individual_Status__c = \'' + value + '\'');
                } else if (field == 'preferredDayTime') {
                    fetchChildACR = true;
                    value = value.replace('[', '').replace(']', '').replace('"', '');
                    List<String> valuesList = value.split(',');
                    for (Integer i = 0; i < valuesList.size(); i++) {
                        valuesList[i] = '\'' + valuesList[i].trim() + '\''; // Trim and wrap in single quotes
                    }
                    String includesClause = 'Contact.Preferred_contact_day_time__c INCLUDES (' + String.join(valuesList, ',') + ')';
                    acrConditions.add(includesClause);
                } else if (field == 'targetFlag') {
                    fetchChildACR = true;
                    acrConditions.add('Contact.Contact_Target_List__c = ' + value);
                } else if (field == 'quickFilter') {
                    fetchChildACR = true;
                    acrConditions.add(' (Contact.Name LIKE \'%' + value + '%\' OR Account.Clinic_Name__c LIKE \'%' + value + '%\')');
                }
                
                if(field == 'sortCondition'){ // contactName DESC/ASC
                    //fetchChildACR is not set to true to avoid extra SOQl while querying Related ACR's
                    List<String> sortParts = value.split(' ');
                    String fieldName = sortParts[0]; // The field name (e.g., 'accountName')
                    String actualFieldName = fieldMap.get(fieldName); // Get the API name of the field using fieldMap for sorting
                    String sortDirection = (sortParts.size() > 1) ? sortParts[1] : 'Asc'; // The sort direction (default to 'Asc' if not provided)
                    sortString = 'ORDER BY '+actualFieldName+' '+sortDirection;
                    if(sortDirection == 'Asc'){
                        sortString += ' NULLS LAST';
                    }
                }
                // Add more account filters as needed - Preferred_contact_day_time__c
            }
        }
        String accQuery = 'SELECT Id FROM Account WHERE RecordTypeId = :clinicRecordTypeId';
        if (accountConditions.size() > 0) {
            accQuery += ' AND ' + String.join(accountConditions, ' AND ');
        }
        accQuery += ' ORDER BY CreatedDate DESC LIMIT 30000';
        
        // Run the dynamic query and cast it to List<Account>
        List<Account> accountRecords = Database.query(accQuery);
        
        // Convert List<Account> to Map<Id, Account>
        Set<Id> accountIds = new Map<Id, Account>(accountRecords).keySet();        
        
        String query = 'SELECT AccountId, ContactId, Contact.Name, Contact.OnekeyId__c, Contact.Owner_Name__c,Account.Clinic_Name__c, '+
            'Contact.Individual_Status__c, Contact.Current_State__c, Contact.MiyoSmart_Segmentation__c,Contact.Contact_Target_List__c, '+
            'Contact.MiyoSmart_Attitude__c, Contact.Last_contact_visit_date__c, Contact.Main_structure_Name__c,'+ 
            'Contact.Preferred_contact_day_time__c, Contact.Specialization__c,IsDirect,Preferred_place_for_visit__c, '+
            'Account.Name, Account.Shop_Street__c, Account.Shop_City__c, Account.Shop_Postal_Code__c,'+
            'Account.Shop_State__c, Account.Segmentation_Net__c,Account.TACTICOM_SOF__c '+
            'FROM AccountContactRelation';
        
        query += ' WHERE Account.RecordTypeId = :clinicRecordTypeId AND Contact.RecordTypeId = :opthalmologistRecordTypeId AND IsActive = true';
        // Add the contact conditions to the inner query
        if (acrConditions.size() > 0) {
            query += ' AND ' + String.join(acrConditions, ' AND ');
        }
        
        query = query + ' ' + sortString + ' limit 10000';
        System.debug('final Query ' + query);
        List<AccountContactRelation> accountContactRelations  = Database.query(query);
        Set<AccountContactRelation> accounts = new Set<AccountContactRelation>(accountContactRelations);
        List<AccountContactRelation> additionalAcrs = new List<AccountContactRelation> ();
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        Map<Id, AccountWrapper> accountMap = new Map<Id, AccountWrapper>();
        if(fetchChildACR){
            
            // Collect all AccountIds from the filtered result
            accountIds = new Set<Id>();
            Set<Id> acrIds = new Set<Id>();
            for (AccountContactRelation acr : accounts) {
                accountIds.add(acr.AccountId);
                acrIds.add(acr.Id);
            }
            // Query ACR for the collected AccountIds
            additionalAcrs = [SELECT AccountId, ContactId, Contact.Name, Contact.OnekeyId__c, Contact.Owner_Name__c,Contact.Contact_Target_List__c,IsActive,
                              Contact.Individual_Status__c, Contact.Current_State__c, Contact.MiyoSmart_Segmentation__c, Contact.MiyoSmart_Attitude__c, 
                              Contact.Last_contact_visit_date__c, Contact.Main_structure_Name__c, Contact.Preferred_contact_day_time__c, 
                              Contact.Specialization__c, Preferred_place_for_visit__c ,Account.Clinic_Name__c,
                              Account.Name, Account.Shop_Street__c, Account.Shop_City__c, Account.Shop_Postal_Code__c,
                              Account.Shop_State__c, Account.Segmentation_Net__c,Account.TACTICOM_SOF__c
                              FROM AccountContactRelation WHERE AccountId IN :accountIds AND ID NOT IN :acrIds AND Account.RecordTypeId = :clinicRecordTypeId AND Contact.RecordTypeId = :opthalmologistRecordTypeId  AND IsActive = true];
            //accounts = new Set<AccountContactRelation>(additionalAcrs);
            //accounts.addAll(s);
        }
        // Loop through the ACR records and build individual AccountWrappers
        for (AccountContactRelation acr : accounts) {
            if(accountIds.contains(acr.AccountId)){
                AccountWrapper accWrapper = new AccountWrapper(acr,acr.Id);
                accWrapper.accountId = acr.AccountId;
                accWrapper.accountName = acr.Account.Clinic_Name__c;
                accWrapper.shopStreet = acr.Account.Shop_Street__c;
                accWrapper.shopCity = acr.Account.Shop_City__c;
                accWrapper.shopPostalCode = acr.Account.Shop_Postal_Code__c;
                accWrapper.shopState = acr.Account.Shop_State__c;
                accWrapper.visitZone = acr.Account.Segmentation_Net__c;
                
                ContactWrapper parentContact = new ContactWrapper(acr.Contact,acr.Preferred_place_for_visit__c,acr.Id);
                accWrapper.contacts.add(parentContact);
                
                for (AccountContactRelation otherAcr : additionalAcrs) {
                    if (otherAcr.AccountId == acr.AccountId && otherAcr.Id != acr.Id) {
                        // Create ContactWrapper for other contacts and add them to the list
                        ContactWrapper childContact = new ContactWrapper(otherAcr.Contact,otherAcr.Preferred_place_for_visit__c,otherAcr.Id);
                        accWrapper.contacts.add(childContact);
                    }
                }
                
                // Add the AccountWrapper to the final list
                accountWrapperList.add(accWrapper);
            }
        }     
        return accountWrapperList;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Map<String, String>> getPicklistValues() {
        Map<String, Map<String, String>> allPicklistValues = new Map<String, Map<String, String>>();
        // Fetch Specialization__c picklist values
        allPicklistValues.put('specialization', Utility.getTranslatedPicklistValues('Contact', 'Specialization__c'));
        // Fetch MiyoSmart_Attitude__c picklist values
        allPicklistValues.put('attitude', Utility.getTranslatedPicklistValues('Contact', 'MiyoSmart_Attitude__c'));
        // Fetch TACTICOM_SOF__c picklist values from Account
        allPicklistValues.put('visitZone', Utility.getTranslatedPicklistValues('Account', 'TACTICOM_SOF__c'));
        // Fetch Preferred_contact_day_time__c picklist values from Contact
        allPicklistValues.put('preferredDay', Utility.getTranslatedPicklistValues('Contact', 'Preferred_contact_day_time__c'));
        return allPicklistValues;
    }
}