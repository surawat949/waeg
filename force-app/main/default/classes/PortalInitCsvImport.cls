public with sharing class PortalInitCsvImport {

    private static final String ACCOUNT_TEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
	private static final String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
    private static final String CONTACT_SHOP_OWNER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
    
	
    @AuraEnabled
    public static List<Option> getMasterTemplate(){
        List<Option> options = new List<Option>();
        try {
            List<Account_Template__c> templateList = [select Id, Name from Account_Template__c where recordTypeId =:ACCOUNT_TEMPLATE_MASTER_RT order by name];
            for(Account_Template__c t: templateList){
                options.add(new Option(t.Id, t.Name));
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }

    @AuraEnabled
    public static List<Option> getLanguageList(){
        List<Option> options = new List<Option>();
        try {
            Schema.DescribeFieldResult fieldResult = Account.Language__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                    options.add(new Option(f.getValue(), f.getLabel()));
            }     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }

    @AuraEnabled
    public static List<Option> getPortalList(){
        List<Option> options = new List<Option>();
        try {
            Schema.DescribeFieldResult fieldResult = Account.Portal__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                    options.add(new Option(f.getValue(), f.getLabel()));
            }     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }

    @AuraEnabled
    public static List<Option> getSystemEmailList(){
        List<Option> options = new List<Option>();
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Invite_Portal_Email__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                    options.add(new Option(f.getValue(), f.getLabel()));
            }     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }

    public class Option
    {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;

        public Option(String Id, String Name)
        {
            this.Id = Id;
            this.Name = Name;
        }
    }
    @AuraEnabled
    public static List<String> insertData(String strfromle, String masterTemplateId, String language, String portal, String systemEmail){
        system.debug('calling insertData (' + strfromle + ','+ masterTemplateId +',' + language +','+ portal + ',' + systemEmail + ')');
        List<String> errorList = new List<String>();
        
        List<String> hoyaAccountIdList = new List<String>();
        List<Account> accountToUpdate = new List<Account>();
        List<Contact> contactToCreate = new List<Contact>();
        Map<String, Account_Template__c> templateMap = new Map<String, Account_Template__c>();

        Map<String, Account> accountMap = new Map<String, Account>();
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        system.debug('datalist = ' + datalist);
        system.debug('datalistSize = ' + datalist.size());
        system.debug('masterTemplateId = ' + masterTemplateId);
    
        Account_Template__c masterTemplate =[select id, name from Account_Template__c where id=:masterTemplateId and recordTypeId=:ACCOUNT_TEMPLATE_MASTER_RT limit 1];
        
        /* 1st Parse
        *   read hoya_account_id information to perform account query
        *   prepare template to create;
        */
        for(fieldWrapper wrapper: datalist){
            hoyaAccountIdList.add(wrapper.hoyaAccountID);
            System.debug('XXX hoyaAccountID=' + wrapper.hoyaAccountID);      
        }
        System.debug('hoyaAccountIdList size=' + hoyaAccountIdList.get(0));

        // prepare account list to update (portal__c, language__c fields)
        accountToUpdate = [select id, hoya_account_id__c, name, portal__c, language__c from account where hoya_account_id__c in :hoyaAccountIdList];
        List<Id> accountIdList = new List<Id>();
        for(Account a:accountToUpdate){
            System.debug('Parse ' + a.hoya_account_id__c);
            accountMap.put(a.hoya_account_id__c, a);
            a.portal__c = portal;
            a.language__c = language;

            // template list to create. If an account already have a template, this will be an error push in error list
            Account_Template__c template = new Account_Template__c();
            template.Account__c = a.Id;
            template.recordTypeId = ACCOUNT_TEMPLATE_COPY_RT;
            template.name = masterTemplate.Name + ' - ' + a.name;
            template.Master_Template__c = masterTemplate.Id;
			template.Default__c = true;
			template.Active_Authorization_Template__c = true;
            accountIdList.add(a.Id);
            templateMap.put(a.hoya_account_id__c, template);
        }
        System.debug('update accounts size=' + accountToUpdate.size());
        update accountToUpdate;
        System.debug('insert templates nb=' + templateMap.size());
        Database.SaveResult[] srTempList = Database.insert(templateMap.values(), false);
      
        //insert templateMap.values();
        // Iterate through each returned result
        for (Database.SaveResult sr : srTempList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted template. template ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Template fields that affected this error: ' + err.getFields());
                    //errorList.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }

        // Build a map of templateid - accountId: retrieve template id to associate to contact below (in case of error in template creation loop = template already exist)
        List<Account_Template__c> finalTmplList = [select id, Account__c from Account_Template__c where account__c in :accountIdList];
        Map<Id, Id> accountTemplateMap = new Map<Id, ID>();
        for(Account_Template__c at: finalTmplList){
            accountTemplateMap.put(at.account__c, at.id);
        }

        /* 2nd Parse
        *   init contact data - assign template
        *  used Hoya_Contact_ID__c as external key for upsert opetration, allow to reload a file already parse
        */
        for(fieldWrapper wrapper: datalist){
            System.debug('upserting contact');
            Contact c = new Contact();
            c.FirstName = wrapper.FirstName;
            c.LastName = wrapper.LastName;
            c.recordTypeId = CONTACT_SHOP_OWNER_RT;
            c.email = wrapper.Email;
            c.Invite_Portal_Email__c = systemEmail;
            c.Language_Pick__c = language;
            System.debug('+++++1' + accountMap);
            System.debug('+++++2' + accountMap.values());
            System.debug('+++++3' + wrapper.hoyaAccountID);
            System.debug('+++++4' + accountMap.get(wrapper.hoyaAccountID));
            c.AccountId = accountMap.get(wrapper.hoyaAccountID).Id;
            c.Account_Template__c = accountTemplateMap.get(c.AccountId);
            c.Hoya_Contact_ID__c=c.Firstname+c.Lastname+c.AccountId;

            contactToCreate.add(c);
        }
        

        Database.UpsertResult[] srList = Database.upsert(contactToCreate, Contact.Fields.Hoya_Contact_ID__c, false);

        // Iterate through each returned result
        for (Database.UpsertResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted contact ID: ' + sr.getId());
                errorList.add('[CALL Script]: SendRegistrationInvite_Controller.sendRegistrationInvite(\''+sr.getId()+'\');');
            }
            else {
                // Operation failed, so get all errors            
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                    errorList.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        
        
        return errorList;
    }
    
    public class fieldWrapper{        
        public String hoyaAccountID;        
        public String AccountName;        
        public String Title;
        public String FirstName;
        public String LastName;
        public String Email;
        public String Phone;
    } 
    
}