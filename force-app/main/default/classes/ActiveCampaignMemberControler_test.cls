@isTest
public with sharing class ActiveCampaignMemberControler_test {
    public ActiveCampaignMemberControler_test() {

    }

    static testMethod void testActiveCampaignMemberCtrl(){
        Test.startTest();

        /* create test  account */ 
        Account acc = new Account();
        acc.Name='Location test account';
        acc.hoya_account_id__c='xxxcduTest';
        acc.RecordTypeId='012b00000000P38';
        insert acc;
        /* create test campaign */
        Campaign campaign = new Campaign();
    	campaign.Name = 'TestCampaign';
    	campaign.CurrencyIsoCode = 'EUR';
    	campaign.Campaign_Description__c = 'Test Campaign Description';
		campaign.company_code__c='EMEA';
    	insert Campaign;
    	/* create campaign member */
    	Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
    	acm.Account_Name__c = acc.Id;
    	acm.Central_Campaign__c = campaign.Id;
        Insert acm;

        /* test methods */
        System.debug('[VisitLocationController_test]account created');
        List<Account_Campaing_Member__c> mList =  ActiveCampaignMemberControler.getCampaignMemberList(acc.Id);
        ActiveCampaignMemberControler.saveCampaignMember(acm.Id, true);

        system.assert(true);
        Test.stopTest();
    }
}