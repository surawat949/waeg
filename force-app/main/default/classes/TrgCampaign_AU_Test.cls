/**
 *  This test class is for Campaign_AU.
 *
 @author Lei Tang
 @created 2014-07-23
 @version 1.0
 @since 30.0 
 *
 @changelog
 * 2014-07-23 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest(SeeAllData=true)
private class TrgCampaign_AU_Test {

    static testMethod void myUnitTest() {
        Account account = new Account();
        account.Hoya_Account_ID__c = 'DE123456';
    	account.Name = 'TestAccount';
    	account.CurrencyIsoCode = 'EUR';
    	insert account;
    	
    	Campaign campaign = new Campaign();
    	campaign.Name = 'TestCampaign';
    	campaign.CurrencyIsoCode = 'EUR';
    	campaign.Button_Name__c = 'test';
    	campaign.Campaign_Description__c = 'Test Campaign Description';
		campaign.company_code__c='EMEA';
    	insert Campaign;
    	
    	Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
    	acm.Account_Name__c = account.Id;
    	acm.Central_Campaign__c = campaign.Id;
    	insert acm;
    	
    	
    	Test.startTest();
    	campaign.Button_Name__c = 'second test';
    	campaign.Campaign_Description__c = 'second Test Campaign Description';
    	campaign.StartDate = date.today();
    	
    	update campaign;
    	Test.stopTest();
    }
}