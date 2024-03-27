public with sharing class TabStatisticCompetitorController {

    /**
     * =====================================================
     * @Author : Surawat Sakulmontreechai
     * @CreatedBy : Surawat Sakulmontreechai
     * @Email : surawat.sakulmontreechai@hoya.com
     * @CreatedDate : 2023-09-04
     * @CreatedBy : Surawat Sakulmontreechai
     * @LastmodifiedDate : -
     * @LastmodifiedBy : Surawat Sakulmontreechai
     * @version : 1.0
     * @apiVersion : via api 49.0 or higher (force.com)
     * @description : This class support for LWC - in global competitor #Task-731 - SFDC V.2.0 Project
     */

private static final String Task_Status_SFDC_V2 = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultRecord(string recordId, string sObjectApiName){
        System.debug('Search Default Record '+recordId);
        string recId = recordId;
        
        string sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' '+
                        'and isactive = true and value LIKE :recId order by value asc limit 1';
        System.debug('soql is =>'+sQuery);
        /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Id=:recId limit 1';*/
        for(sObject obj : database.query(sQuery)){
            //System.debug(obj);
            return obj;
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupData(string searchKey, string sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String swildcardText = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardText = '%'+searchKey+'%';
            String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' and isactive = true '+
                        'and value LIKE: swildcardText order by value asc';
        
            /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Name LIKE: swildcardText order by name asc limit 100';*/
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardText = '';
        }
        
        
        //System.debug('XXX Get data =>'+returnList.size());
        return returnList;
    }

    @AuraEnabled(cacheable=false)
    public static void UpdateCompetitor(String recordId, String firstCompetitorName, String secondCompetitorName){
        try {
            List<Account> updateList = new List<Account>();
            Id recordIdValue = recordId;
            SObject recordToUpdate = Schema.getGlobalDescribe().get('Account').newSObject(recordIdValue); 
                if((String.isNotBlank(firstCompetitorName)) || (String.isNotBlank(secondCompetitorName))){
                    recordToUpdate.put('First_Competitor_local_name__c', String.valueOf(firstCompetitorName));
                    recordToUpdate.put('Second_Competitor_Local_Name__c', String.valueOf(secondCompetitorName));
                                    }else{
                    recordToUpdate.put('First_Competitor_local_name__c', ''); 
                recordToUpdate.put('Second_Competitor_Local_Name__c', ''); 
            }
            if(recordToUpdate != null){
                update recordToUpdate;
            }
                
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchLookupUserDefault(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+ ' WHERE Id=:recid LIMIT 1';

        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupUser(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String sCommunityUser = '%Customer Community%';
        String sWildCardText = searchKey;

        if(String.isNotBlank(searchKey)){
            sWildCardText = '%'+searchKey+'%';
        }

        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+ ' WHERE (Name LIKE:sWildCardText) AND (IsActive=true) AND (NOT(Profile.Name LIKE:sCommunityUser))';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static string getFirstLocalCompetitorName(String recordId){
        try {
            String FirstCompetitorLocalName = [SELECT Id, First_Competitor_Local_Name__c FROM Account WHERE Id=:recordId].First_Competitor_Local_Name__c;
            //System.debug(FirstCompetitorLocalName);
            return FirstCompetitorLocalName;
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static string getSecondLocalCompetitorName(String recordId){
        try {
            String SecondCompetitorLocalName = [SELECT Id, Second_Competitor_Local_Name__c FROM Account WHERE Id=:recordId].Second_Competitor_Local_Name__c;
            return SecondCompetitorLocalName;
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static double getFirstCompetitorSOW(String recordId){
        try {
            Double FirstComp = [SELECT First_Competitor_SOW_Last_3_Month__c FROM Last_Sales_Statistics__c WHERE Account__c=:recordId].First_Competitor_SOW_Last_3_Month__c;
            //System.debug(FirstComp);
            return FirstComp;
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static void CreateNewCompetitorReq(String subject, String Instruction, String assignto, Date duedate, String sStatus, String accountName){
        try {
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
            Task t = new Task(
                Subject = subject,
                Instructions__c = Instruction,
                OwnerId = assignto,
                ActivityDate = duedate,
                Status = sStatus,
                RecordTypeId = StandardHoyatask,
                WhatId = accountName,
                Account__c = accountName

            );
            insert t;
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultAccountName(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName+' WHERE Id=:recId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchAccountName(String recordId, String sObjectApiName, String searchKey){
        List<sObject> returnList = new List<sObject>();
        String recId = recordId;
        String swildcardtext = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardtext = '%'+searchKey+'%';
            String sQuery = 'SELECT Id, Hoya_Account_ID__c, Name FROM '+sObjectApiName+' WHERE Name LIKE:swildcardtext AND Id=:recId ORDER BY Name ASC';
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardtext = '';
        }
        return returnList;
    }

}