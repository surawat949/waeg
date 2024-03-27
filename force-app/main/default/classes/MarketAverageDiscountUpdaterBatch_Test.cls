/**********************************************************************************************************************
* Name               : MarketAverageDiscountUpdaterBatch_Test                                                        
* Description        : Test class for MarketAverageDiscountUpdaterBatch
* Created By         : Encora                                                      
**********************************************************************************************************************/
@isTest
public class MarketAverageDiscountUpdaterBatch_Test {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'test Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Lenses_Net_Sales_Last_12Mo__c = 13000,
            Channel__c = 'Independent',
            shop_Country__c = 'DE',
            potential__c = 500000
        );
        insert acc;
        Last_Sales_Statistics__c sales = new Last_Sales_Statistics__c();
        sales.Account__c = acc.Id;
        sales.Lenses_Net_Sales_Last_12Mo__c = 13000;
        sales.Lenses_Gross_Sales_Last_12Mo__c = 12000;
        
        Insert sales;
    }
    @isTest
    static void MarketAverageDiscountUpdate(){       
        Test.startTest();
        String sch = '0 0 * * * ?';
		system.schedule('Test Check', sch, new MarketAverageDiscountUpdaterBatch());
        Test.stopTest();
    }
}