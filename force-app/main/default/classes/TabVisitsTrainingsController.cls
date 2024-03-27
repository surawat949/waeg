public With Sharing class TabVisitsTrainingsController {
    
    //Method to get all Training Records
    @AuraEnabled
    public static List<ECP_Training__c> getTrainingRecords(String accountId){
        List<ECP_Training__c> trainings=[Select Id,Name,Account__c,start__c,Training__c,Training_status__c from ECP_Training__c where Account__c=:accountId order by Name DESC];
        return trainings;
    } 
    
     //Method to get all eLearing Records
    @AuraEnabled(cacheable=true)
    public static List<eLearning__c> getElearningRecords(String accountId){
        List<eLearning__c> eLearnings=[Select Id,Account__c,Name,User_Name__c,email__c,End_Date__c,status__c,CreatedDate from eLearning__c where Account__c=:accountId];
        return eLearnings;
    } 

}