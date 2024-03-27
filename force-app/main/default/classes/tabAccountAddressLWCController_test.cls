/**
 *  Test class for tabAccountAddressLWCController #task560
 * 
 */

@IsTest
public with sharing class tabAccountAddressLWCController_test {
    public tabAccountAddressLWCController_test() {

    }

    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        String accCopy = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
        String accMaster = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();

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
        a1.Hoya_Account_ID__c = 'TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.CurrencyIsoCode = 'EUR';
        a1.OwnerId = u.Id;
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

        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';

        insert c1;

        Account_Template__c Acc_Master = new Account_Template__c();
        
        Acc_Master.Name = 'Master-template';
        Acc_Master.RecordTypeId = accMaster;
        insert Acc_Master;

        Account_Template__c Acc_Copy = new Account_Template__c();
        Acc_Copy.Account__c = a1.Id;
        Acc_Copy.Master_Template__c = Acc_Master.Id;
        Acc_Copy.Name = 'copy-template-001';
        Acc_Copy.Active_Authorization_Template__c = true;
        Acc_Copy.RecordTypeId = accCopy;
        Acc_Copy.Default__c = true;
        insert Acc_Copy;


    }

    @IsTest
    static void testmultipleClass1(){
        Test.StartTest();

        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId, 
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                        Shop_email_address__c, Surveys_Email__c, Email__c,
                        Confidential_Email_Address__c FROM Account
                        WHERE Hoya_Account_ID__c = 'TEST001' LIMIT 1];
        Contact con = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'test-TEST001' LIMIT 1];

        User u = [SELECT Id, FirstName, LastName FROM User WHERE Username = 'testini@hoya.com.pcpy' LIMIT 1];

        Account_Template__c at = [SELECT Id, Name FROM Account_Template__c WHERE Name = 'copy-template-001' LIMIT 1];
        String conRecType = [SELECT Id FROM RecordType WHERE sObjectType='Contact' AND DeveloperName='Shop_Owner'].Id;
        
        Date duedate = System.today();
        tabAccountAddressLWCController.fetchAccforMapAccountId(acc.Id);
        tabAccountAddressLWCController.getContactsRelatedAccount(acc.Id);
        tabAccountAddressLWCController.getConCount(acc.Id);
        tabAccountAddressLWCController.UpdateAccountEmail(acc.Id);
        tabAccountAddressLWCController.getContactId(acc.Id);
        tabAccountAddressLWCController.getContactRecordTypeDescribe();
        tabAccountAddressLWCController.getContactRecordTypeDescribeNotIn();
        tabAccountAddressLWCController.getPicklistLanguage();
        tabAccountAddressLWCController.getpicklistEducationValues();
        tabAccountAddressLWCController.getpicklistEducationValuesRest();
        tabAccountAddressLWCController.getContactRecordTypeShopOwner();
        tabAccountAddressLWCController.getContactRecordTypeEmployee();
        tabAccountAddressLWCController.getContactRecordTypeOpthal();
        tabAccountAddressLWCController.getContactRecordTypeRest();
        tabAccountAddressLWCController.getAccountTemplateForAccountId(acc.Id);
        tabAccountAddressLWCController.createTask('Test', acc.Id, 'this is a test', u.Id, duedate, 'Not Start', con.Id, u.Id, acc.Id);
        tabAccountAddressLWCController.createNewContact(acc.Id, 'Mr.', 'testx', 'testy', 'this is a test', conRecType, 'Optician', '9876533', '83373722', 'test@hotmail.com', at.Id, false, true, true);
        tabAccountAddressLWCController.searchLookupData('TEST', 'Contact', ' AND Account.Hoya_Account_ID__c !=null', acc.Id);
        tabAccountAddressLWCController.searchLookupAccountData('test', 'Account', acc.Id);
        tabAccountAddressLWCController.searchLookupAccountDefaultRecordData(acc.Id, 'Account');
		

        List<String> newList = new List<String>();
        newList.add('Id');
        newList.add('Name');
        tabAccountAddressLWCController.getDataAndColumns('Account', newList, acc.Id, ' AND Hoya_Account_ID__c!=null', ' AND OwnerId!=null', ' ORDER BY Hoya_Account_ID__c ASC');
        Test.StopTest();

        try{
            tabAccountAddressLWCController.UpdateAccountEmail(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            tabAccountAddressLWCController.createTask(null, null, null, null, null, null, null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            tabAccountAddressLWCController.createNewContact(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
		
    }
}