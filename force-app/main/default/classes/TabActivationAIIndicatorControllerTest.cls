@isTest
public class TabActivationAIIndicatorControllerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'TE012354',
            shippingPostalCode='23440',
            phone='0102030405',
            Onboarding_date__c = date.valueOf(system.now()),
            Onboarding_Customer__c = true,
            Lenses_Net_Sales_Last_12Mo__c = 2,
            Brand_Visibility__c='HOYA',
            CHCUSTCLASSIFICATIONID__c='Ind',
            Seiko_Network__c = 'Visionary Alliance',
            Visionary_Alliance__c = 'Insider'
        );
        insert acc;
         Account acc2 = new Account(
            Name = 'Test AccTESR',
            Hoya_Account_ID__c = 'TE012345',
            shippingPostalCode='23440',
            phone='0103030408',
            Account_Status__c='Closed'
        );
        insert acc2;
        Account acc1 = new Account(
            Name = 'Test Acc1',
            Hoya_Account_ID__c = 'SO013455',
            shippingPostalCode='234401',
            phone='0102030406',
            Onboarding_date__c = date.valueOf(system.now()),
            Onboarding_Customer__c = false,
            Lenses_Net_Sales_Last_12Mo__c = 10,
            Brand_Visibility__c='SEIKO',
            CHCUSTCLASSIFICATIONID__c='Ind'              
        );
        insert acc1;
       Last_Sales_Statistics__c  lastSalesStatisticObj = new Last_Sales_Statistics__c();
        lastSalesStatisticObj.name = 'test';
        lastSalesStatisticObj.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj.Account__c = acc.id;
        lastSalesStatisticObj.Remote_Edging_L3Mo__c=9;
        lastSalesStatisticObj.Mounting_L3Mo__c=39;
        lastSalesStatisticObj.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj.Other_Digital_Orders_L3Mo__c=69;
        insert lastSalesStatisticObj;
        
        Last_Sales_Statistics__c lastSalesStatisticObj1 = new Last_Sales_Statistics__c();
        lastSalesStatisticObj1.name = 'test';
        lastSalesStatisticObj1.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj1.Account__c = acc1.id;
        lastSalesStatisticObj1.Remote_Edging_L3Mo__c=1;
        lastSalesStatisticObj1.Mounting_L3Mo__c=9;
        lastSalesStatisticObj1.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj1.Other_Digital_Orders_L3Mo__c=49;
        insert lastSalesStatisticObj1;
        
        Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con1';
        con.AccountId = acc.Id;
        insert con;
     }   
     @IsTest
    static void getAIIndicatorsTest(){
        Account actId = [ Select id,Lenses_Net_Sales_Last_12Mo__c,Account_Status__c,Seiko_Network__c,Segmentation_Net__c,
                            CHCUSTCLASSIFICATIONID__c,Brand__c,Visionary_Alliance__c From Account where Hoya_Account_ID__c = 'TE012354'];
        Account actId1 = [ Select id,Lenses_Net_Sales_Last_12Mo__c,Account_Status__c,Seiko_Network__c,Segmentation_Net__c,
                            CHCUSTCLASSIFICATIONID__c,Brand__c,Visionary_Alliance__c From Account 
                         where name='Test Acc1'];
        Account actId2 = [ Select id,Account_Status__c From Account 
                         where Account_Status__c = 'Closed'];
        
       contact con = [SELECT Id, Name,Portal_User_Name__c,Send_Registration_Email_Flag__c,Contact_Record_Type__c,Recordtype.developerName, Salutation,CreatedDate, Title, Email, Phone 
                              FROM Contact where AccountId=:actId.Id];
        Last_Sales_Statistics__c lastSalesStatistics = [Select Id,Other_Digital_Orders_L3Mo__c,Remote_Edging_L3Mo__c,
                                                      Mounting_L3Mo__c,HVC_Systems_L3Mo__c, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c =:actId.Id];
         Last_Sales_Statistics__c lastSalesStatistic1 = [Select Id,Other_Digital_Orders_L3Mo__c,Remote_Edging_L3Mo__c,
                                                      Mounting_L3Mo__c,HVC_Systems_L3Mo__c, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c =:actId.Id And name = 'test'];
         
        Test.startTest();
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            TabActivationAIIndicatorController.getAIIndicators(actId1.Id);
            TabActivationAIIndicatorController.getAIIndicators(actId2.Id);
            actId.Hoya_Account_ID__c = 'SO12';
        	actId.Visionary_Alliance__c = 'Insider';
            actId.Seiko_Network__c = 'Seiko Vision Specialist';
            update actId;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            actId.CHCUSTCLASSIFICATIONID__c = 'Other';
            update actId;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
           // actId.Visionary_Alliance__c = '';
            actId.Hoya_Account_ID__c = '12';
            actId.Seiko_Network__c = 'Visionary Alliance';
            update actId;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            actId.CHCUSTCLASSIFICATIONID__c = 'Ind';
            update actId;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            TabActivationAIIndicatorController.getAIIndicators(actId1.Id);
            lastSalesStatistic1.Other_Digital_Orders_L3Mo__c=4;
            update lastSalesStatistic1;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            actId.Seiko_Network__c = '';
            update actId;
            TabActivationAIIndicatorController.getAIIndicators(actId.Id);
            
        Test.StopTest();
  } 
   @IsTest
    static void getAIIndicatorsTest1(){
     	Account acc = new Account(
            Name = 'Test Acc1',
            Hoya_Account_ID__c = 'SO013456',
            shippingPostalCode='234401',
            Lenses_Net_Sales_Last_12Mo__c = 11,
            Brand_Visibility__c='SEIKO',
           // Visionary_Alliance__c = 'Insider',
            Seiko_Network__c='Seiko Vision Specialist',
            CHCUSTCLASSIFICATIONID__c='Other'            
        );
        insert acc; 
        Last_Sales_Statistics__c lastSalesStatisticObj1 = new Last_Sales_Statistics__c();
        lastSalesStatisticObj1.name = 'test';
        lastSalesStatisticObj1.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj1.Account__c = acc.id;
        lastSalesStatisticObj1.Remote_Edging_L3Mo__c=1;
        lastSalesStatisticObj1.Mounting_L3Mo__c=9;
        lastSalesStatisticObj1.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj1.Other_Digital_Orders_L3Mo__c=49;
        insert lastSalesStatisticObj1;
        Test.startTest();
        TabActivationAIIndicatorController.getAIIndicators(acc.Id);
        lastSalesStatisticObj1.Remote_Edging_L3Mo__c=5;
        lastSalesStatisticObj1.Mounting_L3Mo__c=5;
        update lastSalesStatisticObj1;
        TabActivationAIIndicatorController.getAIIndicators(acc.Id);
        acc.Lenses_Net_Sales_Last_12Mo__c = 0;
        update acc;
        TabActivationAIIndicatorController.getAIIndicators(acc.Id);
        acc.Seiko_Network__c = 'Seiko Vision Specialist';
        update acc;
        TabActivationAIIndicatorController.getAIIndicators(acc.Id);
         lastSalesStatisticObj1.HVC_Systems_L3Mo__c=12;
         lastSalesStatisticObj1.Other_Digital_Orders_L3Mo__c=20;
         update lastSalesStatisticObj1;
        TabActivationAIIndicatorController.getAIIndicators(acc.Id);
        
        
        
        
         Test.StopTest();

    }
    
}