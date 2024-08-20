/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @description : this test class test for TabMVAActivationContactController
 * @api : 55.0
 * @version : 1.0
 * @created date : 2023-11-24
 * code coverage : 91%
 */
@IsTest
public with sharing class TabMVAActivationContactController_test {

    @TestSetup
    static void makeData(){

        string CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

        Account ah = new Account();
        ah.Hoya_Account_ID__c = 'TEST-0000';
        ah.Name = 'Parent Account';
        ah.Shop_Name__c = 'Parent Account';
        insert ah;

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
        a1.ParentId = ah.Id;
        a1.Phone = '12345678';
        a1.Agreed_Visits__c = 2;
        insert a1;

        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'Test';
        c1.LastName = 'Thisistest';
        c1.OtherStreet = '123 Venue Street';
        c1.OtherCity = 'Bangkhen';
        c1.OtherState = 'Bangkok';
        c1.OtherCountry = 'Thailand';
        c1.MailingStreet = '456 Venue Street';
        c1.MailingCity = 'Bangkhen';
        c1.MailingState = 'Bangkok';
        c1.MailingCountry = 'Thailand';
        insert c1;

        Contact c2 = new Contact();
        c2.FirstName = 'test2null';
        c2.LastName = 'test1234';
        c2.AccountId = a1.Id;
        c2.RecordTypeId = CONTACT_OPTHO_RT;
        insert c2;

        AccountContactRelation ac = new AccountContactRelation();
        ac.ContactId = c1.Id;
        ac.AccountId = ah.Id;
        ac.Preferred_place_for_visit__c = true;
       // ac.Contact_Role__c = 'Other';
        insert ac;
    }

    @IsTest
    static void testWholeClass(){
        Test.StartTest();
        Account acc = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c = 'TEST-0001' LIMIT 1];
        Contact c1 = [SELECT Id FROM Contact WHERE AccountId=:acc.Id LIMIT 1];
        Contact c2 = [SELECT Id FROM Contact WHERE FirstName='test2null' LIMIT 1];
        Account ah = [SELECT Id, Name, ParentId FROM Account WHERE Hoya_Account_ID__c='TEST-0000' LIMIT 1];
        Account acch = [SELECT Id, Name, Shop_Name__c, ParentId FROM Account WHERE ParentId=:ah.Id];
        AccountContactRelation ac = [SELECT Id FROM AccountContactRelation WHERE AccountId=:ah.Id];

        Set<Id> accIds = new Set<Id>();
        List<Account> accList = new List<Account>([SELECT Id, Hoya_Account_ID__c, ParentId FROM Account WHERE ParentId=:ah.Id]);
        for(Account a : accList){
            accIds.add(a.ParentId);
        }
        TabMVAActivationContactController.getAllContactsHierarchy(acc.Id);
        TabMVAActivationContactController.getRecursiveAccountList(accIds);
        Test.StopTest();
    }
}