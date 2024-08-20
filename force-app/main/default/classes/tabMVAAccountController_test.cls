/**
 *  Test class for tabAccountAddressLWCController #task1002 #task1003 #task1004
 * 
 */

@IsTest
public with sharing class tabMVAAccountController_test {
    public tabMVAAccountController_test() {

    }

    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testini@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;
        
        

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST-0001';
        a1.Name = 'This is a test';
        a1.Shop_Name__c = 'This is a test';
        a1.ShippingStreet = '123 Street';
        a1.ShippingCity = 'Bangkok';
        a1.ShippingState = 'Bangkok';
        a1.ShippingCountry = 'Thailand';
        a1.ShippingPostalCode = '11111';
        a1.ShippingLatitude = 0;
        a1.ShippingLongitude = 0;
        a1.Shop_Street__c = '123 Street';
        a1.Shop_City__c = 'Bangkok';
        a1.Shop_State__c = 'Bangkok';
        a1.Shop_Postal_Code__c = '2222';
        a1.Shop_Country__c = 'Thailand';
        a1.Seiko_Network__c = 'Visionary Alliance';
        a1.Phone = '12345678';
        a1.Agreed_Visits__c = 2;
        
        insert a1;

    }

    @IsTest
    static void testWholeClass(){
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name FROM Account WHERE Hoya_Account_ID__c='TEST-0001' LIMIT 1];

        Test.StartTest();
        tabMVAAccountController.fetchAccforMapAccountId(acc.Id);
        tabMVAAccountController.fetchAccforMapAccountId(null);
        
        Test.StopTest();
    }
}