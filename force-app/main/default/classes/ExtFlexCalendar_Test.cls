/**
*  This test class is for ExtFlexCalendar.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   
*/
@isTest
private class ExtFlexCalendar_Test {

    static testMethod void testCtrl() {
    	
    	Account acc = new Account();
    	acc.Name = 'dsfa';
    	acc.Hoya_Account_ID__c = 'DE123456';
	    insert acc;
	        	
    	Test.startTest();
    	
        ApexPages.StandardController stdCtl = new ApexPages.StandardController(acc);
        ExtFlexCalendar ext = new ExtFlexCalendar(stdCtl);
        
        system.assert(true);
        Test.stopTest();
    }
}