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
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = a.Id;
        visit1.Visit_Type__c = 'Support Direct Visit';
        visit1.Visit_Status__c = 'Complete';
        visit1.Visit_Reason__c = 'Retain';
        visit1.Start_Time__c = date.today()-1;
        visit1.End_Time__c = visit1.Start_Time__c.addMinutes(60);
        visit1.Assigned_to__c = UserInfo.getUserId();
        insert visit1;
        
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a.Id;
        visit2.Visit_Type__c = 'Support Digital Visit';
        visit2.Visit_Status__c = 'Complete';
        visit2.Visit_Reason__c = 'Retain';
        visit2.Start_Time__c = date.today()-1;
        visit2.End_Time__c = visit2.Start_Time__c.addMinutes(60);
        visit2.Assigned_to__c = UserInfo.getUserId();
        insert visit2;

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
        TabVisitsTacticomController.getSupportVisitsInfo(a.Id);
        Test.StopTest();

    }
}