public class tabVisitDetailFormController {
    @AuraEnabled
    public static List<Identified_Business_Opportunity__c> getBusinessOpportunityRelatedAccount(String VisitId){
        ID AccountId = [SELECT ID,Account__c FROM Visits__c WHERE Id=:VisitId].Account__c;
        List<Identified_Business_Opportunity__c> oppList = TabVisitsCampOppController.getBusinessOpportunityRelatedAccount(AccountId);
        return oppList;
    }
	
    @AuraEnabled(cacheable=true)
    public static user getUserInfo() {
        String userId = UserInfo.getUserId(); // current user
        return [SELECT ID, FirstName, LastName, Name, Title, Profile.Name,  Email From User WHERE ID =: userId LIMIT 1];
    }
}