@isTest
public class TabVisitsCampOppControllerTest {
    
    public TabVisitsCampOppControllerTest() {
        
    }
    
    @TestSetup
    static void makeData(){
        Account hvnaAcc = new Account();
        hvnaAcc.Hoya_Account_ID__c = 'US1234512';
        hvnaAcc.CurrencyIsoCode = 'EUR';
        hvnaAcc.Name = 'HVNA Test';
        insert hvnaAcc;
        
        Account seiko = new Account();
        seiko.Hoya_Account_ID__c = 'SO1234512';
        seiko.CurrencyIsoCode = 'EUR';
        seiko.Name = 'SEIKO1 Test';
        insert seiko;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Target List : '+seiko.Name;
        opp.AccountId = seiko.Id;
        opp.OwnerId = seiko.OwnerId;
        opp.CurrencyIsoCode = seiko.CurrencyIsoCode;
        opp.CloseDate = System.today()+180;
        opp.StageName = '1. 1st Appointment';
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        
        Identified_Business_Opportunity__c indeifiedOpp = new Identified_Business_Opportunity__c();
        indeifiedOpp.Project_Name__c = 'Test01';
        indeifiedOpp.Project_Category__c = 'Product Mix';
        indeifiedOpp.Project_Status__c = 'In progress';
        indeifiedOpp.Priority_level__c = '1';
        indeifiedOpp.Account__c = seiko.Id;
        insert indeifiedOpp;
        
        /* create test campaign */
        Campaign campaign = new Campaign();
        campaign.Name = 'TestCampaign';
        campaign.CurrencyIsoCode = 'EUR';
        campaign.Campaign_Description__c = 'Test Campaign Description';
        campaign.company_code__c='EMEA';
        insert Campaign;
        
        /* create campaign member */
        Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
        acm.Account_Name__c = seiko.Id;
        acm.Central_Campaign__c = campaign.Id;
        Insert acm;
    }
    
    @isTest
    static void campTest(){
        Account a=[Select Id from account Limit 1];
        TabVisitsCampOppController.getOpportunity(a.Id);
        TabVisitsCampOppController.getBusinessOpportunityRelatedAccount(a.Id);
        TabVisitsCampOppController.getCampaignMembership(a.Id);
        TabVisitsCampOppController.createBusinessOpportunity( 'projectName', a.Id, 'Test', 'Product Mix', 'Next Steps test','2', 454, 'In progress');
    }
    
}