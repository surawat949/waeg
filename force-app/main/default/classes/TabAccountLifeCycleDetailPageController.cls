public class TabAccountLifeCycleDetailPageController{
    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisits(Id recordId) {
        return [SELECT Id, Start_Day__c,Visit_Notes__c,Call_To_Action__c,Visit_Reason__c,Visit_Objective_follow_up_notes__c,Assigned_to__c,Visit_assigned_to__c
               FROM Visits__c Where Account__c =:recordId AND Visit_Type__c = 'Visit' AND (Visit_Status__c ='Complete' OR Visit_Status__c ='Planned')
                order by Start_Time__c desc limit 3];
    }
    @AuraEnabled(cacheable=true)
    public static List<Identified_Business_Opportunity__c> getBusinessOpp(Id recordId) {
       List<Identified_Business_Opportunity__c> oppList = TabVisitsCampOppController.getBusinessOpportunityRelatedAccount(recordId);
       return oppList;
       }
}