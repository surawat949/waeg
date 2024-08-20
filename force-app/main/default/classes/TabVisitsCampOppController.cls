public With Sharing class TabVisitsCampOppController {
    
    @AuraEnabled(cacheable=true)
    public static List<Identified_Business_Opportunity__c> getBusinessOpportunityRelatedAccount(String accountId){
        List<Identified_Business_Opportunity__c> oppList = [SELECT  Name,  CreatedDate,  Project_Name__c,Account__c,Project_Category__c, Yearly_Incremental_Sales_Formula__c, Project_Status__c,Priority_level__c
                                                            FROM Identified_Business_Opportunity__c WHERE Account__c=:accountId ORDER BY Name ASC];
        return oppList;
    }
    
    //Method to get all Campaign Membership
    @AuraEnabled
    public static List<Account_Campaing_Member__c> getCampaignMembership(String accountId){
        List<Account_Campaing_Member__c> campaigns=[Select  id,Name, Campaign_Start_Date_t__c,Campaign_Name_t__c,  Campaign_End_Date_t__c, Date_of_presentation__c,Campaign_Interested__c,Account_Name__c 
                                                    from Account_Campaing_Member__c where Account_Name__c=:accountId];
        return campaigns;
    }
    
    //Method to get all Opportunities
    @AuraEnabled
    public static List<Opportunity> getOpportunity(String accountId){
        List<Opportunity> opportunities=[Select  id,Name, AccountId,StageName,CloseDate,Days_Remain_To_Close__c
                                         from Opportunity where AccountId=:accountId];
        return opportunities;
    }
    
    @AuraEnabled
    public static void createBusinessOpportunity(String projectName,String accountId, String description,String category, String nextSteps, String level, Decimal monthlyInc, String status){
        try {
                Identified_Business_Opportunity__c opp = new Identified_Business_Opportunity__c(
                Project_Name__c  = projectName,
                Description__c = description,
                Next_Steps__c = nextSteps,
                Priority_level__c  = level,
                Monthly_Incremental_Sales__c = monthlyInc,
                Project_Category__c = category,
                Account__c = accountId,
                Project_Status__c = status
            );
            insert opp;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }
 
}