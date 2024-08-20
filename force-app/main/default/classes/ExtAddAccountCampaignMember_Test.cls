/**.
 *  This test class is used to test APL_ClsRSMGroupingForecastService
 *  
 * @author Minghao Li
 * @created 2015-09-15
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changeloga
 * 2015-09-15 Minghao Li <minghao.li@oinio.com>
 * - Created
 *
 * coverage 92%
 */
@isTest
private class ExtAddAccountCampaignMember_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc = new Account(); 
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'demo account12121';        
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        acc.email__c = 'minghao.li@oinio.com';
        //acc.RecordTypeId = rt[0].Id;
        insert acc;
        
        Campaign campaign = new Campaign();
    	campaign.Name = 'TestCampaign';
    	campaign.CurrencyIsoCode = 'EUR';
    	campaign.Campaign_Description__c = 'Test Campaign Description';
		campaign.company_code__c='EMEA';
    	insert campaign;
    	
    	Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
    	acm.Account_Name__c = acc.Id;
    	acm.Central_Campaign__c = campaign.Id;
    	
        Apexpages.currentPage().getParameters().put('id',Campaign.Id);
        
        Test.startTest();
    	ExtAddAccountCampaignMember  sca = new ExtAddAccountCampaignMember();

		sca.getAccountFunction();

		ExtAddAccountCampaignMember.CustomObject co = new ExtAddAccountCampaignMember.CustomObject();
		co.aId = acc.Id;
		co.cId = campaign.Id;
		list<ExtAddAccountCampaignMember.CustomObject> list_co = new list<ExtAddAccountCampaignMember.CustomObject>();
		list_co.add(co);
		ExtAddAccountCampaignMember.insertCampaignMember(JSON.serialize(list_co));
		
    	Test.stopTest();
    }
}