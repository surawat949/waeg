public With Sharing class TabVisitsReportsController {
    
    //Method to get all Visits
    @AuraEnabled
    public static List<Visits__c> getReportVisits(String accountId){
        List<Visits__c> visits=[select Id,Name,Start_Date_Time__c, Visit_Type__c, Visit_Reason__c,  Visit_Status__c,Start_Day__c,Start_Time__c from Visits__c where Account__c=:accountId order by Start_Time__c desc];
        return visits;
    } 
    
    //Method to get Last 3 Tasks
    @AuraEnabled(cacheable=true)
    public static List<Task> getTaskRecord(String accountId){
        List<Task> task = [select Id,CreatedById,format(Created_Date__c),CreatedBy.Name, Subject, Owner.Name, format(ActivityDate), toLabel(Status) from Task
                           where WhatId =: accountId order by ActivityDate desc nulls last limit 3];
        return task;
    }
    
    //Method to get Last 3 Visits Completed
    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisitCompleted(String accountId){
        List<Visits__c> visits=[select Id,Name,Visit_Reason__c,Visit_Notes__c,Visit_completed_date__c,Call_To_Action__c, Call_To_Action_Notes__c, Visit_assigned_to__c,Start_Day__c,Start_Date_Time__c from Visits__c
                                where Account__c=:accountId AND Visit_Status__c ='Complete' Order By Visit_completed_date__c Desc nulls last limit 3];
        return visits;
    } 
    
}