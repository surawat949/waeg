global class serviceFlow_DeleteActivities implements Database.Batchable < sObject > , Schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchId = Database.executeBatch(new serviceFlow_DeleteActivities(), 2000);
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([Select Id from serviceFlow_Activities_Tracking__c where 
            Delete_Record_Date__c <= today Order By User_Country__c ASC
        ]);
    }
    global void execute(Database.BatchableContext BC, List < serviceFlow_Activities_Tracking__c > scope)
    {
        delete scope;
    }
    global void finish(Database.BatchableContext BC)
    {

    }
}