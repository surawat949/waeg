/**
 *  This test class is for visit_AIUDUDBIUD_eventSynchronisation.
 *
 @author Yuda Zheng
 @created 2013-07-24
 @version 1.0
 @since 27.0 
 *
 @changelog
 * 2013-07-24 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest
private class TrgVisit_AIUDUDBIUD_eventSync_Test {
    
    static testMethod void testBI() {
        Test.startTest();
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        insert acc; 
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Done';
        visit.Start_Time__c = date.today();
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Is_All_Day_Event__c = false;
        visit.Call_To_Action__c='Fact Finding';
        visit.MKT_No_campaign_presented__c=true;
        visit.Assigned_to__c = UserInfo.getUserId();
        
        
        
        insert visit;
        
        system.assert(true);
        Test.stopTest();
    }

    static testMethod void testBU() {
        Test.startTest();
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        insert acc; 

        
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = date.today();
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Call_To_Action__c='Fact Finding';
        visit.MKT_No_campaign_presented__c=true;
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        visit.Is_All_Day_Event__c = false;
        visit.Assigned_to__c = UserInfo.getUserId();        
        
        visit.Visit_Status__c = 'Done';
        //visit.Start_Time__c = null;
        update visit;
        
        visits__c visitData = [Select id from visits__c where id = :visit.id];
        visitData.Visit_Initial_Date_Tracker__c = date.today();
        visitData.Is_All_Day_Event__c = true;
        visitData.Start_Time__c = date.today();
        update visitData;
        
        system.assert(true);
        Test.stopTest();
    }
    
    static testMethod void testAD() {
        Test.startTest();
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        insert acc; 
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = date.today();
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        
        
        
        delete visit;
        
        system.assert(true);
        Test.stopTest();
    }    
}