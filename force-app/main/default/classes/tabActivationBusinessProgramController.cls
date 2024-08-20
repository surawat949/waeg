public with sharing class tabActivationBusinessProgramController {
    //Test class name: tabActivationBusinessProgramCtrlrTest
    public tabActivationBusinessProgramController() {

    }

    @AuraEnabled
    public static void updateOnboardingFlag(Id accountId, boolean state){
        try {
            List<Account> accList =  [Select Id, Onboarding_Customer__c, Onboarding_date__c FROM Account Where Id = :accountId];
            accList.get(0).Onboarding_Customer__c = state;
            if (state) {
                accList.get(0).Onboarding_date__c = System.today();    
            } else {
               accList.get(0).Onboarding_date__c = null;   
            }
            
            update accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Loyalty_Points__c> getRelatedLoyaltyPoints(Id accountId){
            List<Loyalty_Points__c> pointsList =  [Select Id, Name, MonthYear__c, Description__c, Points__c,external_key__c, Date_of_transaction__c FROM Loyalty_Points__c Where Account__c = :accountId];
            return pointsList;
    }    
}