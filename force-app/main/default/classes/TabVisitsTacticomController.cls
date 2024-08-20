/**
 * @CreatedBy : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
 * @CreatedDate : 2024-05-16
 * @Description : for Task-1406
 */
public without sharing class TabVisitsTacticomController {
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
    @AuraEnabled(cacheable = true)
    public static SupportVisitWrapper getSupportVisitsInfo(Id AccountId){
        SupportVisitWrapper wrapper = new SupportVisitWrapper();
		Integer supportVisitCount=0;
        Integer supportDigitalVisitCount = 0;
        List<AggregateResult> AggregateResultList = [SELECT count(Id) visitCount,Max(End_Time__c) latestDate FROM Visits__c 
                                                     WHERE Account__c =:AccountId AND Visit_Type__c = 'Support Direct Visit' AND Visit_Status__c = 'Complete' AND End_Time__c = LAST_N_DAYS:365
                                                     Group By Account__c];
        List<AggregateResult> supportDigitalList = [SELECT count(Id) visitCount,Max(End_Time__c) latestDate FROM Visits__c 
                                                     WHERE Account__c =:AccountId AND Visit_Type__c = 'Support Digital Visit' AND Visit_Status__c = 'Complete' AND End_Time__c = LAST_N_DAYS:365
                                                     Group By Account__c];
        if(AggregateResultList.size() > 0){
           supportVisitCount = (Integer)AggregateResultList[0].get('visitCount');
           DateTime lastDate= (DateTime)AggregateResultList[0].get('latestDate');
           wrapper.supportVisitCount = supportVisitCount;
           Date latestSupportDate = lastDate.Date();
           wrapper.lastSupportVisitDate = latestSupportDate.format();
           List<Visits__c> visits =[SELECT Id,Assigned_to__r.Name FROM Visits__c 
                                    WHERE Account__c =:AccountId AND Visit_Type__c = 'Support Direct Visit' AND Visit_Status__c = 'Complete' AND End_Time__c =:lastDate ];
           wrapper.lastSupportVisitBy = visits[0].Assigned_to__r.Name;
        }
        if(supportDigitalList.size() > 0){
           supportDigitalVisitCount = (Integer)supportDigitalList[0].get('visitCount');
           DateTime lastDate= (DateTime)supportDigitalList[0].get('latestDate');
           wrapper.supportDigitalVisitCount = supportDigitalVisitCount;
           Date latestSupportDate = lastDate.Date();
           wrapper.lastSupportDigitalVisitDate = latestSupportDate.format();
           List<Visits__c> visits =[SELECT Id,Assigned_to__r.Name FROM Visits__c 
                                    WHERE Account__c =:AccountId AND Visit_Type__c = 'Support Digital Visit' AND Visit_Status__c = 'Complete' AND End_Time__c =:lastDate ];
           wrapper.lastSupportDigitalVisitBy = visits[0].Assigned_to__r.Name; 
        }
        
        System.debug(wrapper);
        return wrapper;
    }
    public Class SupportVisitWrapper{
        @AuraEnabled public Integer supportVisitCount{get;set;}
        @AuraEnabled public String lastSupportVisitBy{get;set;}
        @AuraEnabled public String lastSupportVisitDate{get;set;}
        @AuraEnabled public Integer supportDigitalVisitCount{get;set;}
        @AuraEnabled public String lastSupportDigitalVisitBy{get;set;}
        @AuraEnabled public String lastSupportDigitalVisitDate{get;set;}        
    }
}