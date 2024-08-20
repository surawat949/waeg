/**
 *  This test class is for Account_Campaing_Member_AIU_postInAccountFeed.
 *
 @author Jian Yin
 @created 2013-08-15
 @version 1.0
 @since 24.0 
 *
 @changelog
 * 2013-08-15 Jian Yin <jian.yin@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest(SeeAllData=true)
private class TrgAcc_Cam_Member_AIU_postInAccFeed_Test {

    static testMethod void myUnitTest() {
    	
    	Account account = new Account();
    	account.Hoya_Account_ID__c = 'DE123456';
    	account.Name = 'TestAccount';
    	account.CurrencyIsoCode = 'EUR';
    	insert account;
    	
    	Campaign campaign = new Campaign();
    	campaign.Name = 'TestCampaign';
    	campaign.CurrencyIsoCode = 'EUR';
    	campaign.Campaign_Description__c = 'Test Campaign Description';
		campaign.company_code__c='EMEA';
    	insert Campaign;
    	
    	Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
    	acm.Account_Name__c = account.Id;
    	acm.Central_Campaign__c = campaign.Id;
    	
    	Test.startTest();
    	insert acm;
    	Test.stopTest();
    }
}