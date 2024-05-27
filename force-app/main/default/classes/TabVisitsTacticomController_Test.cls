/**
 * Test class support for TabVisitsTacticomController
 * CreatedBy : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
 * CreatedDate : 2024-05-20
 */
@IsTest
public class TabVisitsTacticomController_Test {
    private static final String TaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();

    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testuser';
        u.Email = 'test.testuser@hoya.com.invalid';
        u.UserName = 'test.testuser@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testusr';
        u.EmailEncodingKey = 'UTF-8';
        u.Sales_Role__c = 'RSM';
        u.IsActive = true;
        insert u;
        
        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE12345';
        a.Name = 'Test account';
        a.OwnerId = u.Id;
        insert a;

        Task t = new Task();
        t.Subject = 'Test';
        t.Status = 'New';
        t.WhatId = a.Id;
        t.OwnerId = u.Id;
        t.Description = 'This is a test';
        t.RecordTypeId = TaskRecordType;
        t.Visit_Update_Request_Open__c = true;
        t.ActivityDate = System.today();
        insert t;

    }
    @IsTest
    static void TestClassModule1(){
        Test.StartTest();
        User u = [SELECT Id, Name FROM User WHERE UserName = 'test.testuser@hoya.com.invalid'];
        Account a = [SELECT Id, Name FROM Account WHERE Hoya_Account_ID__c = 'TE12345'];
        Task t = [SELECT Id FROM Task WHERE WhatId =: a.Id];

        TabVisitsTacticomController.searchLookUpUser('Test', 'User');
        TabVisitsTacticomController.CreateNewTaskRequestNewVisits('New', 'Test', a.Id, u.Id, 'This is a test', System.today(), 1, 1);
        Test.StopTest();

    }
}