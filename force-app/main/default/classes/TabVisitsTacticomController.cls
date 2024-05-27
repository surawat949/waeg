/**
 * @CreatedBy : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
 * @CreatedDate : 2024-05-16
 * @Description : for Task-1406
 */
public with sharing class TabVisitsTacticomController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookUpUser(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String communityUsrText = '%Customer Community%';
        String sWildCardText = '%'+searchKey+'%';
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+' WHERE Name LIKE: sWildCardText AND (IsActive=true) AND (NOT(Profile.Name LIKE:communityUsrText)) AND (Sales_Role__c IN (\'RSM\', \'NSM\')) ORDER BY Name ASC LIMIT 100';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        //System.debug('Return = > '+returnList);
        return returnList;
    }
    /*
    @AuraEnabled(cacheable=true)
    public static sObject searchLookUpUserDefault(String recordId, String sObjectApiName){
        String sRecId = recordId;
        String sQuery = 'SELECT Id, Name FROM '+sObjectApiName+' WHERE Id=:sRecId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }
        return null;
    }*/

    @AuraEnabled(cacheable=false)
    public static void CreateNewTaskRequestNewVisits(String status, String Subject, String WhatId, String AssignTo, String Description, Date duedate, Double requestVisitPlan, Double requestDigitalVisitPlan){
        String standardHoyaTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        List<Account> updAccList = new List<Account>();

        accList = [SELECT Requested_Direct_Visits__c, Requested_Digital_Visits__c FROM Account WHERE Id=:WhatId];
        for(Account a : accList){
            a.Requested_Direct_Visits__c = requestVisitPlan;
            a.Requested_Digital_Visits__c = requestDigitalVisitPlan;
            updAccList.add(a);
        }

        if(updAccList.size()>0){
            update updAccList;
        }
        
        Task t = new Task(
            Subject = Subject,
            Status = status,
            WhatId = WhatId,
            OwnerId = AssignTo,
            Description = Description,
            RecordTypeId = standardHoyaTask,
            Visit_Update_Request_Open__c = true,
            ActivityDate = duedate
        );
        insert t;
        System.debug('WhatId =>'+WhatId + 'Request Visit Plan => '+requestVisitPlan + ' Request Digital Visit Plan => '+requestDigitalVisitPlan);
        
    }
}