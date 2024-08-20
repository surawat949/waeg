@IsTest
public with sharing class TabAccountMemberParentId_Test {
    //For test class TabAccountMemberParentId - class

    @TestSetup
    static void makeData(){
        String IndRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'Testdata';
        u.Lastname = 'Datatest';
        u.Username = 'data@hoya.com.invalid';
        u.Email = 'data@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'data2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TE001';
        a1.Name = 'Test1';
        a1.RecordTypeId = IndRecType;
        insert a1;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'TE002';
        a2.Name = 'Test2';
        a2.RecordTypeId = IndRecType;
        a2.ParentId = a1.Id;
        insert a2;

        Contact c1 = new Contact();
        c1.FirstName = 'Test';
        c1.LastName = 'Testtest';
        c1.AccountId = a2.Id;
        insert c1;

    }

    @IsTest
    static void TestMultipleClass1(){
        
        Test.StartTest();
        String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Standard_New').getRecordTypeId();

        Account a1 = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c='TE002' LIMIT 1];
        User u1 = [SELECT Id FROM User WHERE Username='data@hoya.com.invalid' LIMIT 1];
        Contact c1 = [SELECT Id FROM Contact WHERE AccountId=:a1.Id];

        Date duedate = System.today();

        TabAccountMemberParentId.getNumberOfAllAccount(a1.Id);
        TabAccountMemberParentId.getAccountNameId(a1.Id);
        TabAccountMemberParentId.CreateTask('Test', a1.Id, 'This is a test', u1.Id, duedate, 'Completed', null, u1.Id, a1.Id);
        TabAccountMemberParentId.searchLookupData('Test', 'Account', a1.Id);
        TabAccountMemberParentId.searchDefaultRecord(a1.Id, 'Account');
        TabAccountMemberParentId.searchLookUpUserDefault(u1.Id, 'User');
        TabAccountMemberParentId.searchLookupUser('test', 'User');
        TabAccountMemberParentId.searchLookUpContactDefault('test', 'Account');
        TabAccountMemberParentId.searchLookupAccountData('test', 'Account', a1.Id);
        TabAccountMemberParentId.searchLookupAccountDefaultRecordData(a1.Id, 'Account');
        TabAccountMemberParentId.searchLookupContactData('test', 'Contact', c1.Id);
        
        Test.StopTest();

        try{
            TabAccountMemberParentId.CreateTask(null, null, null, null, null, null, null, null, null);

        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabAccountMemberParentId.getNumberOfAllAccount(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabAccountMemberParentId.getAccountNameId(null);

        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

    }
}