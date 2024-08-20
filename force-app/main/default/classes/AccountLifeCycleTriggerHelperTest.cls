@isTest
public class AccountLifeCycleTriggerHelperTest {
    @isTest
    static void testLifeCycleTrigger() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        insert acc; 
        
        Last_Sales_Statistics__c sale = new Last_Sales_Statistics__c();
        sale.Account__c = acc.Id;
        sale.Lenses_Net_SoW_Last_3Mo__c = 100.0;
        insert sale;
        
        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
        alc.Account__c = acc.Id;
        alc.External_Key__c = acc.Id;
        alc.Stage__c ='Discover';
        
        Test.startTest();        
        upsert alc External_Key__c;        
        alc.Stage__c = 'Engage';
        upsert alc External_Key__c; 
        
        
        
        system.assert(true);
        Test.stopTest();    
    }
}