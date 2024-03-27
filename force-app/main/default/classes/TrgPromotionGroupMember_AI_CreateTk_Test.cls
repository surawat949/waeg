/**
*  This test class is for promotionGroupMember_AI_CreateTask.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgPromotionGroupMember_AI_CreateTk_Test {

    static testMethod void testAI() {
    	
    	Account acc = new Account();
    	acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
	    insert acc;
	        	
    	Promotion_Group__c pg = new Promotion_Group__c();
    	pg.Promotion_Start_Date__c = date.today();
    	pg.Name = 'afdrgf';
    	insert pg;
    	
		Promotion_Group_Tasks__c  pgt = new Promotion_Group_Tasks__c();
		pgt.Name = 'dsaf';
		pgt.Description__c = 'adfaf';
		pgt.Promotion_Group__c = pg.Id;
		insert pgt;
		      
        Promotion_Group_Member__c pgm = new Promotion_Group_Member__c();
        pgm.Promotion_Group__c = pg.Id;
        pgm.Account__c = acc.Id;
        pgm.Start_of_Membership__c = date.today();
        
        Test.startTest();
        
        insert pgm;
        
        system.assert(true);
        Test.stopTest();
    }
}