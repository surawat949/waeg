@isTest
public class TabVisitsControllerTest {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Shop_Country__c = 'FR',
            Local_Consolidation_Key__c = 'Test 2'
        );
        insert acc;
    }
    
    /*@isTest
    static void tabVisitTest(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId,Local_Consolidation_Key__c from Account LIMIT 1];
        //TabVisitsController.recommendedAccountsByZone(acc.ownerId);
        //TabVisitsController.getAccountsByZone(acc.ownerId);
        Test.stopTest();
    } 
    */     
    
    @isTest
    static void tabVisitTestOne(){
        Test.startTest();
        Account acc1 = new Account();
        acc1.Name='TesVl123';
        acc1.Hoya_Account_Id__c = 'SO0v1234';
        acc1.currencyIsoCode='EUR';
        acc1.Zonal__c = 'Sub-area 1';
        acc1.TACTICOM_SOF__c = 'Sub-area 1';
        acc1.Agreed_Visits__c= 44;
        acc1.Agreed_No_of_Digital_Visits__c=24;
        acc1.Local_Consolidation_Key__c = 'Test 2';
        insert acc1;

        TabVisitsController.TacticomDetails(acc1.Id);
        //TabVisitsController.recommendedAccountsByZone(acc1.ownerId);
        Test.stopTest();
    }
    
    @isTest
    static void tabVisitTestTwo(){
        Test.startTest();
        Account acc3 = new Account(
            Name = 'Account 3',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Hoya_account_Id__c = 'SO0033TESTACC3',
            Strategic_Value_Net_Sales__c =576 ,
            Local_Consolidation_Key__c = 'Test 2'
        );
        insert acc3;
        
        Last_Sales_Statistics__c stats =  new Last_Sales_Statistics__c();
        stats.Account__c = acc3.Id;
        stats.Lenses_Net_Sales_Last_12Mo__c = 130;
        insert stats;

        TabVisitsController.TacticomDetails(acc3.Id);
        //TabVisitsController.recommendedAccountsByZone(acc3.ownerId);
        TabVisitsController.Aggregate(acc3.Id, acc3.Local_Consolidation_Key__c);
        Test.stopTest();
    }
    
    @isTest
    static void tabVisitTestThree(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId,Local_Consolidation_Key__c from Account LIMIT 1];
        TabVisitsController.TacticomDetails(acc.Id);
        TabVisitsController.Aggregate(acc.Id, acc.Local_Consolidation_Key__c);
        Test.stopTest();
    }
}