@IsTest
public class tabActivationBusiProgStoreInfoTest {
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
        
            Store_Characteristics__c storeCharObj = new Store_Characteristics__c(); 
            storeCharObj.Account__c = a1.id;
            storeCharObj.Last_Year_of_Reference__c = '2012';
            storeCharObj.Retail_Turnover_Last_Year_of_Ref__c = 12.2;
            storeCharObj.Annual_Growth_Last_Year_of_Ref__c=12.2;
            insert storeCharObj;
        
            Store_Related_Pictures__c storePicObj = new Store_Related_Pictures__c();
            //storePicObj.Date__c = date.valueOf(system.now());
            storePicObj.Description__c = 'test';
            storePicObj.Account__c = a1.id;
            insert storePicObj;
     }
    @IsTest
    static void testmultipleClass1(){
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId
                        FROM Account
                        WHERE Hoya_Account_ID__c = 'TEST001' LIMIT 1];
         list<Store_Related_Pictures__c> storeRelatedPic =[SELECT ID,Name,Description__c,Account__c
                                                          FROM Store_Related_Pictures__c WHERE Account__c=: acc.Id];
        list<Store_Characteristics__c> storeCharObj =[SELECT ID,Name, Last_Year_of_Reference__c,
                                                      Retail_Turnover_Last_Year_of_Ref__c,Account__c,Annual_Growth_Last_Year_of_Ref__c
                                                          FROM Store_Characteristics__c WHERE Account__c=: acc.Id];
         Test.StartTest();
         tabActivationBusiProgStoreInfoController.migrateLastYearToPreYear(acc.id);
         tabActivationBusiProgStoreInfoController.getStoredPictures(acc.id);
         tabActivationBusiProgStoreInfoController.getStoreId(acc.id);
         Test.StopTest();
        

    }    

}