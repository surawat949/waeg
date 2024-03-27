public with sharing class TabAccountMemberParentId {

    /**
     * =====================================================
     * @Author : Surawat Sakulmontreechai
     * @CreatedBy : Surawat Sakulmontreechai
     * @Email : surawat.sakulmontreechai@hoya.com
     * @CreatedDate : 2023-08-21
     * @CreatedBy : Surawat Sakulmontreechai
     * @LastmodifiedDate : 2023-08-24
     * @LastmodifiedBy : Surawat Sakulmontreechai
     * @version : 1.0
     * @apiVersion : via api 49.0 or higher (force.com)
     * @description : This class support for LWC - TabAccountMembership in SFDC V.2.0 Project
     */
	

    public class NumOfAccount{
        @AuraEnabled public double childAccount{get;set;}
    }


    @AuraEnabled(cacheable=true)
    public static List<NumOfAccount> getNumberOfAllAccount(String recordId){
        try {
            List<NumOfAccount> numList = new List<NumOfAccount>();
            //record type for End Consumer Record Type Id
            String ECRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
            //System.debug('End consumer rec type => '+ECRecTypeId);
            List<AggregateResult> arList = [SELECT COUNT(Id) counting
                                                FROM Account WHERE ParentId=:recordId
                                                AND RecordTypeId!=:ECRecTypeId];
            for(AggregateResult ar:arList){
                NumOfAccount n = new NumOfAccount();
                n.childAccount = (double)ar.get('counting');
                numList.add(n);
            }

            
            return numList;

        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
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

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupContactData(String searchKey, String sObjectApiName, String recordId){
        List<sObject> returnList = new List<sObject>();
        String sWildCardText = '%'+searchKey+'%';
        String sRecId = recordId;
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+' WHERE Name LIKE : sWildCardText AND AccountId=:sRecId ORDER BY Name ASC';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchLookUpContactDefault(String recordId, String sObjectApiName){
        String sRecId = recordId;
        String sQuery = 'SELECt Id, Name FROM '+sObjectApiName+' WHERE Id=:sRecId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookUpUser(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String communityUsrText = '%Customer Community%';
        String sWildCardText = '%'+searchKey+'%';
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+' WHERE Name LIKE: sWildCardText AND (IsActive=true) AND (NOT(Profile.Name LIKE:communityUsrText))';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchLookUpUserDefault(String recordId, String sObjectApiName){
        String sRecId = recordId;
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+' WHERE Id=:sRecId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static list<sObject> searchLookupData(string searchKey , string sObjectApiName, String recordId) {    
        System.debug('XXX Get Record Id =>'+recordId);
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        string sRecId = recordId;
        string sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM ' + sObjectApiName + ' WHERE Name LIKE : sWildCardText AND ParentId=null And Id!=:recordId ORDER BY Name ASC LIMIT 100';
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;    
        string sQuery = 'Select Id, Hoya_Account_ID__c, Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountNameId(String recordId){
        try {
            List<Account> acc = [SELECT Id, Hoya_Account_ID__c, Name FROM Account WHERE Id=:recordId LIMIT 1];
            if(!acc.isEmpty()){
                return acc;
            }else{
                return null;
            }
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static void CreateTask(String subject, String relatedTo, String Instruction, String assignTo, Date DueDate, String sStatus, String sFlowContact, String CopyTo, String AccountId){
        try {
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
            Task t = new Task(
                Subject = subject,
                WhatId = relatedTo,
                Instructions__c = Instruction,
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
	
}