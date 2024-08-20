@isTest
public class LifeCycleReportingControllerTest {
	@isTest
    static void testLifeCycleTrigger() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        acc.CHCUSTCLASSIFICATIONID__c = 'Chain';
        acc.Seiko_Network__c = 'Visionary Alliance';
        insert acc; 
        
        Last_Sales_Statistics__c sale = new Last_Sales_Statistics__c();
        sale.Account__c = acc.Id;
        sale.Lenses_Net_SoW_Last_3Mo__c = 10.0;
        sale.Lenses_Net_Sales_CFY_vs_LFY_YTD__c = 18.44;
        insert sale;
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Start_Time__c = date.today()-3;
        visit2.End_Time__c = date.today();
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Complete';
        visit2.Visitfreqchk_c__c='1';
        visit2.Visit_Type__c='Visit';
        visit2.Visit_Reason__c='On Board - Business Review';
        insert visit2;
        
        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
        alc.Account__c = acc.Id;
        alc.External_Key__c = acc.Id;
        alc.Retain_Stage__c = true;
        alc.Stage__c ='Engage'; 
        alc.Active__c =true;
        alc.Latest_Visit_Considered__c=visit2.id;
        insert alc;
        
        Test.startTest();        
        LifeCycleReportingController.getAccountLifeCycleRecords();
        system.assert(true);
        Test.stopTest();    
    }
}