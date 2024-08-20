public with sharing class TabMVAVisitsController {
    
    //get In Store Training and Webinars related list
    @AuraEnabled
    public static List<ECP_Training__c> getInStoreTrainingRelatedList(String accountId){

            List<ECP_Training__c> trainingLst = [SELECT Id,Name,Training__c,start__c,Assigned_to__c,Training_status__c,Assigned_to__r.Name
                                                 FROM ECP_Training__c
                                                 WHERE Account__c=:accountId
                                                 ORDER BY start__c DESC];
            return trainingLst;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisitsBasedOnContacts(String accountId){
        List<Visits__c> visits=[Select Id,Name,Contact__c,Contact__r.Name,Visit_Type__c,Visit_Reason__c,Start_Day__c, Account__C,Related_Contact__c,Visit_assigned_to__c from visits__c where Account__C =:accountId Order by Start_Day__c Desc ];
        return visits;
    }  
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getVisitFrequency(String accountId){
        List<Contact> Contacts=[Select Id,Name,Last_contact_visit_date__c,Contact_Direct_Visits_Frequency__c,Total_Visit_Achieved__c,Contact_Digital_Visits_Frequency__c  from Contact Where AccountId=:accountId Order by Last_contact_visit_date__c DESC NULLS LAST, LastName ASC];
        return Contacts;    
    }
      
}