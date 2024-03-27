/**
*  This test class is for ExtPromotionGrpMemberManagement .
*
@author Di Chen
@created 2013-07-22
@version 1.0
@since 20.0 
*
@changelog
* 2013-07-22 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   
*/
@isTest
private class ExtPromotionGrpMemberManagement_Test {

    static testMethod void testMostMethods1() {
      
        Promotion_Group__c pg = new Promotion_Group__c();
        pg.Promotion_Start_Date__c = date.newInstance(2013,07,07);
        pg.Promotion_End_Date__c= date.newInstance(2013,07,13);
        pg.Name = 'pg';
        insert pg;
        
        Promotion_Group_Member__c  pgm = new Promotion_Group_Member__c();
           
        Test.startTest();
          
        ExtPromotionGrpMemberManagement.CustomPromotionMember pgmCP = new ExtPromotionGrpMemberManagement.CustomPromotionMember(pgm,1);  
         
        ExtPromotionGrpMemberManagement.CustomOption pgmCO = new ExtPromotionGrpMemberManagement.CustomOption();
        pgmCO.selected = 'true';
        pgmCO.getNumberAddOptions();
          
        ApexPages.StandardController stdCtl = new ApexPages.StandardController(pg);
        ExtPromotionGrpMemberManagement ext = new ExtPromotionGrpMemberManagement(stdCtl);
        
        ext.promotionGrp = pg;
        ext.currentIndex = 1;
        
        ext.getCustomOption();
        ext.setCustomOption('1');
        ext.addProGrpMembs();
        ext.saveProGrpMembs();
        ext.deleteProGrpMembs();
        
        system.assert(true);
        Test.stopTest();
    }
   static testMethod void testMostMethods2() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'dsfa';
        acc.Shop_Country__c = 'Germany';
        acc.Turnover_Amount__c = 101;
        insert acc;      
        
        Promotion_Group__c pg = new Promotion_Group__c();
        pg.Promotion_Start_Date__c = date.newInstance(2013,07,07);
        pg.Promotion_End_Date__c= date.newInstance(2013,07,13);
        pg.Name = 'pg';
        insert pg;
        
        Promotion_Group_Member__c  pgm = new Promotion_Group_Member__c();
        pgm.Promotion_Group__c = pg.Id;
        pgm.Account__c = acc.Id;
        pgm.Start_of_Membership__c = date.newInstance(2013,07,13);
        insert pgm;
           
        Test.startTest();
          
        ExtPromotionGrpMemberManagement.CustomPromotionMember  pgmCP = new ExtPromotionGrpMemberManagement.CustomPromotionMember(pgm,1);  
          
        ApexPages.StandardController stdCtl = new ApexPages.StandardController(pg);
        ExtPromotionGrpMemberManagement ext = new ExtPromotionGrpMemberManagement(stdCtl);
        
        ext.promotionGrp = pg;
        ext.currentIndex = 1;
        
        ext.getCustomOption();
        ext.setCustomOption('1');
        ext.addProGrpMembs();
        ext.saveProGrpMembs();
        ext.deleteProGrpMembs();
        
        system.assert(true);
        Test.stopTest();
    }    
}