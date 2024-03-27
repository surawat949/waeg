global class serviceFlow_SendEmailToManagers implements Database.Batchable < sObject > , Schedulable, Database.Stateful
{
    global Map < String, List < serviceFlow_Activities_Tracking__c >> mapOfCountriesListOfActivities = new Map < String, List < serviceFlow_Activities_Tracking__c >> ();
    global void execute(SchedulableContext sc)
    {
        ID BatchId = Database.executeBatch(new serviceFlow_SendEmailToManagers(), 2000);
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([Select Id, Name, Assigned_To__c, Assigned_To__r.Name, Origin__c, Comments__c, Hoya_reference_number__c, ECP_patient_order_number__c,
            Hoya_Account_ID__c, Created_Date__c, Call_Type__c, Task_Subtype__c, User_Country__c, Subject__c, Sub_Subject__c, Related_To_Account__c, Related_To_Account__r.Name,
            Remainder_Send_Date__c from serviceFlow_Activities_Tracking__c where Remainder_Send_Date__c <= today Order By User_Country__c ASC
        ]);
    }
    global void execute(Database.BatchableContext BC, List < serviceFlow_Activities_Tracking__c > scope)
    {
        for (serviceFlow_Activities_Tracking__c activity: scope)
        {
            if (mapOfCountriesListOfActivities.containsKey(activity.User_Country__c))
            {
                List < serviceFlow_Activities_Tracking__c > listOfActivities = mapOfCountriesListOfActivities.get(activity.User_Country__c);
                listOfActivities.add(activity);
                mapOfCountriesListOfActivities.put(activity.User_Country__c, listOfActivities);
            }
            else
            {
                mapOfCountriesListOfActivities.put(activity.User_Country__c, new List < serviceFlow_Activities_Tracking__c >
                {
                    activity
                });
            }
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        serviceFlow_SendEmailUtility.finish(mapOfCountriesListOfActivities);
    }
    
}