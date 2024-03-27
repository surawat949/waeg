public class TabMVCVisitsCampOppController {
   @AuraEnabled(cacheable=true)
    public static List<Identified_Medical_Opportunity__c> getBusinessOpportunityRelatedToContact(String contactId){
        List<Identified_Medical_Opportunity__c> oppList = [SELECT Id, Name, Creation_Date__c, Project_Name__c,Contact__c,Category__c, Status__c,Priority_level__c,
                                       CreatedDate,Subject__c,Comments__c FROM Identified_Medical_Opportunity__c where Contact__c=: contactId];
        return oppList;
    }
    
    @AuraEnabled
    public static void createBusinessOpportunity(String projectName,String contactId, String description,String category, String nextSteps, String level, String status, String subject){
        try {
            Identified_Medical_Opportunity__c  opp = new Identified_Medical_Opportunity__c (
                Project_Name__c  = projectName ,
                Comments__c = description,
                Next_Steps__c = nextSteps,
                Priority_level__c = level,
                Category__c= category,
                Contact__c = contactId,
                Status__c= status,
                Subject__c = subject
            );
            insert opp;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    } 
}