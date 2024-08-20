/**
*  This test class is for ClsVisitUtil.
*
@author Jian Yin 
@created 2013-10-28
@version 1.0
@since 28.0 
*
@changelog
* 2013-10-28 Jian Yin <jian.yin@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class CtrlShowAccountOnGoogleMaps_Test {

    static testMethod void myUnitTest() {
    	
		Account acc = new Account();
		acc.Name = 'asdf';
		acc.Hoya_Account_ID__c = 'DE123456';
		acc.Shipping_Geo_Code_Lat__c = '12';
		acc.Shipping_Geo_Code_Long__c = '12';
		insert acc;
		
		//Account acc1 = new Account();
		//acc1.Name = 'asdf';
		//acc1.Hoya_Account_ID__c = 'DE123456';
		//insert acc1;
		
		//Account acc2 = new Account();
		//acc2.Name = 'asdf';
		//acc2.Hoya_Account_ID__c = 'DE123456';
		//insert acc2;
    	
    	String idsStr = acc.Id + '_' + 0 + ',' + acc.Id + '_' + 5 + ',' + acc.Id + '_' + 10;
    	
    	System.currentPageReference().getParameters().put('ids', idsStr);
    	Test.startTest();
    	CtrlShowAccountOnGoogleMaps  sca = new CtrlShowAccountOnGoogleMaps();
    	Test.stopTest();
    }
}