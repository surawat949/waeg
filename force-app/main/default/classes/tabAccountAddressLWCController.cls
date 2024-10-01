public with sharing class tabAccountAddressLWCController {

    /**
     * =====================================================
     * @Author : Surawat Sakulmontreechai
     * @CreatedBy : Surawat Sakulmontreechai
     * @Email : surawat.sakulmontreechai@hoya.com
     * @CreatedDate : 2023-06-06
     * @CreatedBy : Surawat Sakulmontreechai
     * @LastmodifiedDate : 2024-01-26
     * @LastmodifiedBy : Surawat Sakulmontreechai
     * @version : 1.0
     * @apiVersion : via api 49.0 or higher (force.com)
     * @description : This class support for LWC - tabAddressAccount and maybe another LWC using in project SFDC V.2.0 Project
     */

    /** Add this class for account tabAccountAddress LWC - 2023-06-06 **/
	
	
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsRelatedAccount(String receivedId){
        List<Contact> conList = [SELECT Id, Name, Contact_Record_Type__c, Salutation, Title, Email, Phone 
                                    FROM Contact WHERE AccountId=:receivedId ORDER BY Name ASC LIMIT 5];

        return conList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getConCount(String receivedId){
        List<Contact> con = [SELECT Id FROM Contact WHERE AccountId=:receivedId];
        return con;
    }

    /** Add this class for reuseable related list apex for Salesforce SFDC V.2.0 Project **/
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDataAndColumns(String sObjectName, List<String> sObjectFieldsName, String recordId, String AndWhere, String OwnerWhere, String OrderBy){
        try {
            Map<String, Schema.SObjectField> m = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();
            for(String fieldName : sObjectFieldsName){
                Schema.DescribeFieldResult dfr = m.get(fieldName).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => dfr.getLabel(),
                    'fieldName' => dfr.getName(),
                    'type' => String.valueOf(dfr.getType()).toLowerCase(),
                    'sorttable' => true
                };
                columns.add(column);
            }
            String query = 'SELECT '+String.join(sObjectFieldsName, ', ') + ' FROM ' + sObjectName + OwnerWhere + '\''+recordId+'\')'
                            + AndWhere + OrderBy;
            System.debug('Query String == > '+query);
            List<Object> records = Database.query(query);
            Map<String, Object> dataColumns = new Map<String, Object>{
                'columns' => columns,
                'data' => records
            };

            return dataColumns;
        } catch (Exception e) {
            return new Map<String, Object>{'Exception == > '=>e.getMessage()};
        }
    }

    /** Added below class for copied email address to all function - support in Salesforce SFDC V.2.0 Project */

    @AuraEnabled(cacheable=false)
    public static String UpdateAccountEmail(String receivedId){
        try {
            List<Account> accToUpdate = new List<Account>();
            List<Account> accList = [SELECT Surveys_Email__c, Email__c, Confidential_Email_Address__c, Shop_email_address__c 
                                    FROM Account WHERE (Id=:receivedId) LIMIT 1];

            
            for(Account a : accList){
                if(a.Shop_email_address__c!=null || a.Shop_email_address__c!=''){
                    if(a.Surveys_Email__c==null){a.Surveys_Email__c = a.Shop_email_address__c;}
                    if(a.Email__c==null){a.Email__c = a.Shop_email_address__c;}
                    if(a.Confidential_Email_Address__c==null){a.Confidential_Email_Address__c = a.Shop_email_address__c;}
                    
                    accToUpdate.add(a);
                }else{
                    accToUpdate.clear();
                }

            }

            if((!accToUpdate.isEmpty()) && accToUpdate!=null){
                update accToUpdate;
                return 'Account email copied to all update successful';
            }else{
                return 'No record update';
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static void createTask(String Sject, String relatedTo, String Comment, String assignTo, Date DueDate, String sStatus, String sFlowContact, String CopyTo, String AccountId){
        try {
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
            Task t = new Task(
                Subject = Sject,
                WhatId = relatedTo,
                Description = Comment,
                OwnerId = assignTo,
                ActivityDate = DueDate,
                Status = sStatus,
                RecordTypeId = StandardHoyatask,
                WhoId = sFlowContact,
                Copy_To__c = CopyTo,
                Account__c = AccountId
            );
            insert t;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=false)
    public static void createNewContact(String accountid, String salutation, String firstname, String lastname, String title, String recordtypeid, String education, String phone, String mobile, String email, String accTemplate, Boolean SystemInvitationEmail, Boolean SendInvitationPortal, Boolean SendImmDiately){
        try {
            Contact c = new Contact(
                AccountId = accountid,
                Salutation = salutation,
                FirstName = firstname,
                LastName = lastname,
                Title = title,
                RecordTypeId = recordtypeid,
                Education__c = education,
                Phone = phone,
                MobilePhone = mobile,
                Email = email,
                Account_Template__c = accTemplate


            );
            insert c;
            if(( SendImmDiately== true) && (c.Account_Template__c!=null)){
                SendRegistrationInvite_Controller.sendRegistrationInvite(c.Id);
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**Using this class for reusable in custom lookup field and you need to create by yourself
     * instead using record-api.
     * added : 2023-06-16
     * added by : Surawat Sakulmontreechai
     * last modified by : Surawat Sakulmontreechai
     */
    @AuraEnabled(cacheable=true)
    public static list<sObject> searchLookupData(string searchKey , string sObjectApiName, string CriteriaName, String recordId) {    
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        string sRecId = recordId;
        string sQuery;
        if(sObjectApiName =='Contact' &&  CriteriaName.contains('Opthalmologist')){
                sQuery = 'Select Id, Name, Account.Name, Hoya_Account_ID__c, Account.Shop_Postal_Code__c, Account.Shop_City__c From ' + sObjectApiName + ' Where Name Like : sWildCardText '+CriteriaName+' AND AccountId != :sRecId  order by name asc LIMIT 50';
            
            
         }
        else{
             sQuery = 'Select Id,Name,Hoya_Account_ID__c From ' + sObjectApiName + ' Where Name Like : sWildCardText '+CriteriaName+' AND AccountId= : sRecId order by name asc LIMIT 50';
        }
        
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupAccountData(String searchKey, String sObjectApiName, String recordId){
        List<sObject> returnList = new List<sObject>();
        String sWildCardText = '%'+searchKey+'%';
        String sRecId = recordId;
        String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName + ' WHERE Name LIKE : sWildCardText AND Id=:recordId ORDER BY Name ASC LIMIT 100';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchLookupAccountDefaultRecordData(String recordId, String sObjectApiName){
        String sRecId = recordId;
        String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName+' WHERE Id=:sRecId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }
    

    /**Add this class for contact id string */
    @AuraEnabled(cacheable=true)
    public static String getContactId(String recordId){
        String contactId = [SELECT Id FROM Contact WHERE AccountId=:recordId LIMIT 1].Id;
        
        return contactId;
       
    }
    /** Get Contact Record Type ***/
    @AuraEnabled(cacheable=true)
    public static List<RecordType> getContactRecordTypeDescribe(){
        List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE (SObjectType='Contact') 
                                    AND (IsActive=true) AND (Name IN('Shop Owner', 'Employee', 'Opthalmologist'))
                                    ORDER BY Name ASC];
        
        return rt;
    }
    /**get contact record type == not in contact rec.type above */
    @AuraEnabled(cacheable=true)
    public static List<RecordType> getContactRecordTypeDescribeNotIn(){
        try {
            List<RecordType> rt = [SELECT Id, Name FROM RecordType WHERE (SObjectType='Contact')
                                    AND (IsActive=true) AND (Name NOT IN('Shop Owner', 'Employee', 'Opthalmologist'))
                                    ORDER BY Name ASC];
            
            return rt;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**Get Account template data == Account__c = AccountId in Contact */
    @AuraEnabled(cacheable=true)
    public static List<Account_Template__c> getAccountTemplateForAccountId(String recordId){
        List<Account_Template__c> accTemplate = [SELECT Id, Name FROM Account_Template__c
                                                        WHERE Account__c=:recordId
                                                        ORDER BY LastmodifiedDate DESC LIMIT 1];
        
        return accTemplate;
       
    }

    /** Added 2023-06-27 to getting about label and value (api) for Langauge_pick__c Contact object 
     * should upgrade to dynamic by pass value sObjectType and sFieldName to value in apex class
    */
    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistLanguage(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Language_Pick__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry pickListVal : pEntry){
                if(pickListVal.IsActive()){
                    String PickListLabelName = pickListVal.getLabel();
                    String PickListValueName = pickListVal.getValue();
                    dataset.add(new optionSet(PickListLabelName, PickListValueName));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getpicklistEducationValues(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Education__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                if((picklistval.IsActive()) &&(picklistval.getValue()=='Optician' || picklistval.getValue()=='Optometrist' || picklistval.getValue()=='Ophthalmologist')){
                    String pListLabelName = picklistval.getLabel();
                    String pListValueName = picklistval.getValue();
                    dataset.add(new optionSet(pListLabelName, pListValueName));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getpicklistEducationValuesRest(){
        try {
            Schema.DescribeFieldResult fieldResult = Contact.Education__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                if((picklistval.IsActive()) && (picklistval.getValue()!='Optician') && (picklistval.getValue()!='Optometrist') && (picklistval.getValue()!='Ophthalmologist')){
                    String pListLabelName = picklistval.getLabel();
                    String pListValue = picklistval.getValue();
                    dataset.add(new optionSet(pListLabelName, pListValue));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeShopOwner(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Shop_Owner')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeEmployee(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Employee')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeOpthal(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.getDeveloperName()=='Opthalmologist')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }

            
            return dataset;
            
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getContactRecordTypeRest(){
        try {
            List<optionSet> dataset = new List<optionSet>();
            for(RecordTypeInfo info : Contact.SObjectType.getDescribe().getRecordTypeInfos()){
                if((info.IsActive()) && (info.IsMaster()==false) && (info.getDeveloperName()!='Shop_Owner' || info.getDeveloperName()!='Employee' || info.getDeveloperName()!='Opthalmologist')){
                    dataset.add(new optionSet(info.getName(), info.getRecordTypeId()));
                }
            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class optionSet{
        public optionSet(String label, String values){
            this.Label = label;
            this.values = values;
        }

        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String values{get;set;}
    }
    /**Fetch account for lightning map */

    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccforMapAccountId(String recordId){
        List<Account> acc = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, 
                                    ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude 
                                    FROM Account WHERE Id=: recordId];
        
        If(acc.size()>0){
            return acc;
        }else{
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static Boolean fetchRecordTypeId(String receivedId) {
        System.debug(receivedId);
        Boolean showExtraSection = true;
                    // Query the Account record
            Account acc = [SELECT RecordType.Name FROM Account WHERE Id = :receivedId LIMIT 1];
            
            // Get the RecordType.Name
            String recordTypeName = acc.RecordType.Name;
            System.debug('>>>>' + recordTypeName);
            
            // Determine whether to show the extra section
            if (recordTypeName == 'Health Insurance') {
                showExtraSection = false;
            }
            
        System.debug('>>>> showExtraSection: ' + showExtraSection);
        return showExtraSection;
    }
}