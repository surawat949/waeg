@isTest
public class tabAIIndicatorsController_test {
    
    @IsTest
    static void runTest(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId=Account_Ind_RecType; 
        acc.Account_Status__c = 'Closed';
        insert acc;
        //closed account
        tabAIIndicatorsController.getAIIndicators(acc.Id,'Address');
        acc.Strategic_Value_Net_Sales__c=0;
        update acc;
        tabAIIndicatorsController.getAIIndicators(acc.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest1(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name='sales test Germany account';
        acc1.hoya_account_id__c='SO4900999xx';
        acc1.RecordTypeId=Account_Ind_RecType;
        acc1.Local_Consolidation_Key__c='123';
        acc1.Account_Status__c = 'Open';
        acc1.Payment_issue__c = true;
        acc1.Net_Promoter_Score__c = 10; 
        acc1.Seiko_objective_ECP_agr__c = 0;
        insert acc1;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'Con';
        con.AccountId = acc1.Id;        
        insert con;
        Last_Sales_Statistics__c lastSales = new Last_Sales_Statistics__c();
        lastSales.Account__c = acc1.Id;
        lastSales.Lenses_Net_Sales_Last_12Mo__c = 10000;
        lastSales.Lenses_Net_Sales_Forecast_CFY__c = 12000;
        lastSales.Lenses_Net_Sales_Last_12Mo_vs_LFY__c = -3;
        lastSales.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c  =-5;
        lastSales.Lenses_Shipment_RX_Average_Delay_3Mo__c  = 10;
        lastSales.Uncut_Lenses_L3Mo__c = 1;
        lastSales.Remote_Edging_L3Mo__c = 2;
        lastSales.Mounting_L3Mo__c = 1;
        lastSales.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 4;
        insert lastSales;
        tabAIIndicatorsController.getAIIndicators(acc1.Id,'Address');
        tabAIIndicatorsController.getAIIndicators(acc1.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest2(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc2 = new Account();
        acc2.Name='sales test account';
        acc2.hoya_account_id__c='SO4950999xx';
        acc2.RecordTypeId=Account_Ind_RecType;
        acc2.Account_Status__c = 'Open';
        acc2.Payment_issue__c = false;
        acc2.Net_Promoter_Score__c = 5;   
        acc2.Seiko_objective_ECP_agr__c = 340;
        acc2.Second_Competitor_Local_Name__c ='Essilor';
        insert acc2;

        Contact con2 = new Contact();
        con2.Salutation = '';
        con2.FirstName = null;
        con2.LastName = 'Testcon2';
        con2.AccountId = acc2.Id;
        con2.RecordTypeId = Contact_Emp_RecType;
        insert con2;
        Last_Sales_Statistics__c lastSales1 = new Last_Sales_Statistics__c();
        lastSales1.Account__c = acc2.Id;
        lastSales1.Lenses_Net_Sales_Last_12Mo__c = 10000;
        lastSales1.Lenses_Net_Sales_Forecast_CFY__c = 12000;
        lastSales1.Lenses_Net_Sales_Last_12Mo_vs_LFY__c = -3;
        lastSales1.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c  =-5;
        lastSales1.Total_Returns_L12Mo__c  = 6;       
        lastSales1.Uncut_Lenses_L3Mo__c = 1;
        lastSales1.Remote_Edging_L3Mo__c = 2;
        lastSales1.Mounting_L3Mo__c = 1;
        lastSales1.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 1.2;
        insert lastSales1;
        
        tabAIIndicatorsController.getAIIndicators(acc2.Id,'Address');
        tabAIIndicatorsController.getAIIndicators(acc2.Id,'Statistics');
        
        Test.stopTest();
    }
    
    @IsTest
    static void runTest3(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc3 = new Account();
        acc3.Name='sales test account2';
        acc3.hoya_account_id__c='SO4950998xx';
        acc3.RecordTypeId=Account_Ind_RecType;
        acc3.Account_Status__c = 'Open';
        acc3.Payment_issue__c = true;
        acc3.Seiko_objective_ECP_agr__c = 0;
        acc3.Seiko_Network__c = 'Seiko Vision Specialist';
        insert acc3;

        Contact con3 = new Contact();
        con3.Salutation = 'Mr.';
        con3.FirstName = 'Testcon3';
        con3.LastName = 'Lastcon3';
        con3.AccountId = acc3.Id;
        con3.RecordTypeId = Contact_Emp_RecType;
        insert con3;
        
        Last_Sales_Statistics__c lastSales3 = new Last_Sales_Statistics__c();
        lastSales3.Account__c = acc3.Id;
        lastSales3.Lenses_Net_Sales_Last_12Mo__c = 1000;
        lastSales3.Lenses_Net_Sales_LFY__c = 12000;
        lastSales3.Lenses_Net_Sales_Last_Month__c = 50;
        lastSales3.Lenses_Net_Sales_Last_12Mo_vs_LFY__c  =5;
        lastSales3.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c  = -2;
        lastSales3.Lenses_Net_Sales_Forecast_CFY__c = 12000;
        lastSales3.Lenses_Shipment_RX_Average_Delay_3Mo__c  = 10;
        lastSales3.Uncut_Lenses_L3Mo__c = 1;
        lastSales3.Remote_Edging_L3Mo__c = 2;
        lastSales3.Mounting_L3Mo__c = 1;        
        lastSales3.Total_Returns_L12Mo__c  = 3;        
        lastSales3.Total_Production_Returns_L12Mo__c =1.8;
        lastSales3.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 4;
        insert lastSales3;
        
        tabAIIndicatorsController.getAIIndicators(acc3.Id,'Address');
        tabAIIndicatorsController.getAIIndicators(acc3.Id,'Statistics');
        acc3.Seiko_Network__c = 'Seiko Vision Specialist';
        update acc3;
        tabAIIndicatorsController.getAIIndicators(acc3.Id,'Statistics');
        
        Test.stopTest();
    }
    
    @IsTest
    static void runTest4(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc4 = new Account();
        acc4.Name='sales test account4';
        acc4.hoya_account_id__c='SO4950997xx';
        acc4.RecordTypeId=Account_Ind_RecType;
        acc4.Account_Status__c = 'Open';
        acc4.Payment_issue__c = true;
        acc4.First_Competitor_global_name__c = 'Essilor';
        acc4.First_Competitor_local_name__c = 'Essilor';
        acc4.Strategic_Value_Gross_Sales__c =100;
        insert acc4;
        
        Contact con4 = new Contact();
        con4.Salutation = 'Mr.';
        con4.FirstName = 'Test';
        con4.LastName = 'Testcon4';
        con4.AccountId = acc4.Id;
        insert con4;
        Test.stopTest();
        
        Last_Sales_Statistics__c lastSales4 = new Last_Sales_Statistics__c();
        lastSales4.Account__c = acc4.Id;
        lastSales4.Lenses_Net_Sales_Last_12Mo__c = 0;
        lastSales4.Lenses_Net_Sales_LFY__c = 1200;
        lastSales4.Lenses_Net_Sales_Last_Month__c = 50;
        lastSales4.Lenses_Net_Sales_Last_12Mo_vs_LFY__c  = -5;
        lastSales4.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c  = 30;
        lastSales4.Remote_Edging_L3Mo__c = 2;
        lastSales4.Mounting_L3Mo__c = 1;        
        lastSales4.Total_Returns_L12Mo__c  = 6;        
        lastSales4.Total_Production_Returns_L12Mo__c =1.8;
        lastSales4.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 4;
        
        tabAIIndicatorsController.getAIIndicators(acc4.Id,'Address');
        tabAIIndicatorsController.getAIIndicators(acc4.Id,'Statistics');
        
        insert lastSales4;
    }
    
    @IsTest
    static void runTest5(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc5 = new Account();
        acc5.Name='sales test account';
        acc5.hoya_account_id__c='SO4950989xx';
        acc5.RecordTypeId=Account_Ind_RecType;
        acc5.Account_Status__c = 'Open';
        acc5.Seiko_objective_ECP_agr__c = 340;
        insert acc5;

        Contact con5 = new Contact();
        con5.FirstName = 'Testcon5';
        con5.LastName = 'Contest5';
        con5.RecordTypeId = Contact_Emp_RecType;
        insert con5;
        
        Last_Sales_Statistics__c lastSales5 = new Last_Sales_Statistics__c();
        lastSales5.Account__c = acc5.Id;
        lastSales5.Lenses_Net_Sales_Last_12Mo__c = 300;
        lastSales5.Lenses_Net_Sales_Forecast_CFY__c = 500;
        insert lastSales5;
        tabAIIndicatorsController.getAIIndicators(acc5.Id,'Address');
        tabAIIndicatorsController.getAIIndicators(acc5.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest6(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc6 = new Account();
        acc6.Name='sales test account';
        acc6.hoya_account_id__c='SO4900889xx';
        acc6.RecordTypeId=Account_Ind_RecType;
        acc6.Account_Status__c = 'Open';
        acc6.Strategic_Value_Gross_Sales__c = 50;
        insert acc6;
        
        Last_Sales_Statistics__c lastSales6 = new Last_Sales_Statistics__c();
        lastSales6.Account__c = acc6.Id;
        lastSales6.Lenses_Net_Sales_Last_12Mo__c = 0;
        lastSales6.Lenses_Net_Sales_LFY__c = 0;        
        insert lastSales6;
        tabAIIndicatorsController.getAIIndicators(acc6.Id,'Statistics');
        acc6.Strategic_Value_Gross_Sales__c=0;
        update acc6;
        tabAIIndicatorsController.getAIIndicators(acc6.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest7(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc7 = new Account();
        acc7.Name='sales test account';
        acc7.hoya_account_id__c='SO3350889xx';
        acc7.RecordTypeId=Account_Ind_RecType;
        acc7.Account_Status__c = 'Open';
        acc7.Strategic_Value_Net_Sales__c = 50;
        insert acc7;
        
         Last_Sales_Statistics__c lastSales7 = new Last_Sales_Statistics__c();
        lastSales7.Account__c = acc7.Id;
        lastSales7.Lenses_Net_Sales_Last_12Mo__c = 0;
        lastSales7.Lenses_Net_Sales_LFY__c = 0;        
        insert lastSales7;
        tabAIIndicatorsController.getAIIndicators(acc7.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest8(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc8 = new Account();
        acc8.Name='sales test account8';
        acc8.hoya_account_id__c='SO49009991x';
        acc8.RecordTypeId=Account_Ind_RecType;
        acc8.Account_Status__c = 'Open';
        acc8.Strategic_Value_Gross_Sales__c = 90;
        insert acc8;
        
        Last_Sales_Statistics__c lastSales8 = new Last_Sales_Statistics__c();
        lastSales8.Account__c = acc8.Id;
        lastSales8.Lenses_Net_Sales_Last_12Mo__c = 150;
        lastSales8.Lenses_Gross_Sales_LFY__c = 100;        
        insert lastSales8;
        tabAIIndicatorsController.getAIIndicators(acc8.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest9(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc9 = new Account();
        acc9.Name='sales test account8';
        acc9.hoya_account_id__c='SO49009992x';
        acc9.RecordTypeId=Account_Ind_RecType;
        acc9.Account_Status__c = 'Open';
        acc9.Strategic_Value_Gross_Sales__c = 90;
        insert acc9;
        
        Last_Sales_Statistics__c lastSales9 = new Last_Sales_Statistics__c();
        lastSales9.Account__c = acc9.Id;
        lastSales9.Lenses_Net_Sales_Last_12Mo__c = 150;
        lastSales9.Lenses_Gross_Sales_Last_12Mo__c = 100;        
        insert lastSales9;
        tabAIIndicatorsController.getAIIndicators(acc9.Id,'Statistics');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest10(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc10 = new Account();
        acc10.Name='sales test account8';
        acc10.hoya_account_id__c='SO33008991x';
        acc10.RecordTypeId=Account_Ind_RecType;
        acc10.Account_Status__c = 'Blocked';
        acc10.Payment_issue__c = false;
        acc10.Strategic_Value_Net_Sales__c = 90;
        acc10.Net_Promoter_Score__c = 4;
        insert acc10;
        
        Last_Sales_Statistics__c lastSales10 = new Last_Sales_Statistics__c();
        lastSales10.Account__c = acc10.Id;
        lastSales10.Lenses_Net_Sales_Last_12Mo__c = 150;
        lastSales10.Lenses_Net_Sales_LFY__c = 100;        
        insert lastSales10;
        tabAIIndicatorsController.getAIIndicators(acc10.Id,'Statistics');
        tabAIIndicatorsController.getAIIndicators(acc10.Id,'Address');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest11(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc11 = new Account();
        acc11.Name='sales test account8';
        acc11.hoya_account_id__c='SO33008992x';
        acc11.RecordTypeId=Account_Ind_RecType;
        acc11.Account_Status__c = 'Blocked';
        acc11.Payment_issue__c = true;
        acc11.Strategic_Value_Net_Sales__c = 90;
        acc11.Net_Promoter_Score__c = 7;
        insert acc11;
        
        Last_Sales_Statistics__c lastSales11 = new Last_Sales_Statistics__c();
        lastSales11.Account__c = acc11.Id;
        lastSales11.Lenses_Net_Sales_Last_12Mo__c = 150;
        lastSales11.Lenses_Net_Sales_Last_12Mo__c = 100;        
        insert lastSales11;
        tabAIIndicatorsController.getAIIndicators(acc11.Id,'Statistics');
        tabAIIndicatorsController.getAIIndicators(acc11.Id,'Address');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest12(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc12 = new Account();
        acc12.Name='sales test account12';
        acc12.hoya_account_id__c='SO33008891x';
        acc12.RecordTypeId=Account_Ind_RecType;
        acc12.Account_Status__c = 'Blocked';
        acc12.Payment_issue__c = false;
        insert acc12;
        
        Last_Sales_Statistics__c lastSales12 = new Last_Sales_Statistics__c();
        lastSales12.Account__c = acc12.Id;
        lastSales12.Lenses_Net_Sales_Last_12Mo__c = 0;
        lastSales12.Lenses_Net_Sales_LFY__c = 100;        
        insert lastSales12;
        tabAIIndicatorsController.getAIIndicators(acc12.Id,'Address');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest13(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc13 = new Account();
        acc13.Name='sales test account13';
        acc13.hoya_account_id__c='SO33008892x';
        acc13.RecordTypeId=Account_Ind_RecType;
        acc13.Account_Status__c = 'Blocked';
        acc13.Payment_issue__c = true;
        insert acc13;
        Last_Sales_Statistics__c lastSales13 = new Last_Sales_Statistics__c();
        lastSales13.Account__c = acc13.Id;
        lastSales13.Lenses_Net_Sales_Last_12Mo__c = 0;
        lastSales13.Lenses_Net_Sales_Last_12Mo__c = 100; 
        lastSales13.Lenses_Shipment_RX_Average_Delay_3Mo__c  = 1;
        lastSales13.Uncut_Lenses_L3Mo__c = 50;
        lastSales13.Remote_Edging_L3Mo__c = 60;
        lastSales13.Mounting_L3Mo__c = 70;        
        lastSales13.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 0.5;
        insert lastSales13;
        tabAIIndicatorsController.getAIIndicators(acc13.Id,'Address');
        
        acc13.Payment_issue__c = true;
        update acc13;
        tabAIIndicatorsController.getAIIndicators(acc13.Id,'Address');
        lastSales13.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 1.7;
        update lastSales13;
        tabAIIndicatorsController.getAIIndicators(acc13.Id,'Address');
        lastSales13.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 2;
        update lastSales13;
         tabAIIndicatorsController.getAIIndicators(acc13.Id,'Address');
        lastSales13.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = 1;
        update lastSales13;
         tabAIIndicatorsController.getAIIndicators(acc13.Id,'Address');
        Test.stopTest();
    }
    
    @IsTest
    static void runTest14(){
        Test.startTest();
        Id Account_Ind_RecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
		Id Contact_Emp_RecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
        Account acc14 = new Account();
        acc14.Name = 'test no competitor';
        acc14.Hoya_Account_ID__c = 'SO3300987654';
        acc14.RecordTypeId = Account_Ind_RecType;
        acc14.First_Competitor_local_name__c = null;
        acc14.Second_Competitor_Local_Name__c = null;
        insert acc14;
        tabAIIndicatorsController.getAIIndicators(acc14.Id, 'Address');
        tabAIIndicatorsController.getAIIndicators(acc14.Id, 'Statistics');
        Test.stopTest();
    }
}