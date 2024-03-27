@IsTest
public class TabActivationPortalStoreFinderTest{
    @TestSetup
    static void makeData(){
         Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.CurrencyIsoCode = 'EUR';
        a1.ShippingStreet = 'Bangkok Street 123';
        a1.ShippingCity = 'Bangkok';
        a1.ShippingState = 'Bangkok';
        a1.ShippingPostalCode = '12345';
        a1.ShippingCountry = 'Thailand';
        a1.Shop_email_address__c = 'test@gmail.com';
        a1.Surveys_Email__c = 'test@yahoo.com';
        a1.Email__c = 'test@hotmail.com';
        a1.Confidential_Email_Address__c = 'test@hanmail.com';
        insert a1;
        String SeikoRec = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();
        ECP_Training__c objECP = new ECP_Training__c();
        objECP.start__c = system.now();
        objECP.Training__c = 'SEIKO Store locator';
        objECP.Training_status__c = 'Completed';
        objECP.Type__c ='In Store';
        objECP.Account__c =a1.id;
        objECP.recordTypeId = SeikoRec;
        insert objECP;
        
        Last_Sales_Statistics__c lastSalesStatisticObj = new Last_Sales_Statistics__c();
        lastSalesStatisticObj.name = 'test';
        lastSalesStatisticObj.Lenses_Net_Sales_Last_3Mo_CFY__c = 1234;
        lastSalesStatisticObj.Account__c = a1.id;
        insert lastSalesStatisticObj;
    }
    @IsTest
    static void testmultipleMethod(){
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId
                        FROM Account
                        WHERE Hoya_Account_ID__c = 'TEST001' LIMIT 1];
         Test.StartTest();
         TabActivationPortalStoreFinderController.getLastTrainingDate(acc.id);
         TabActivationPortalStoreFinderController.getLastTotalMonthSale(acc.id);
    }    
}