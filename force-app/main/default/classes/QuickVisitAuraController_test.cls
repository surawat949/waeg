@isTest
public with sharing class QuickVisitAuraController_test {
    private static final String VisitEyeDoctorsRT = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Eye_Doctor_Visit').getRecordTypeId();

    @TestSetup
    static void makeData(){
        
        Account a = new Account();
        a.Hoya_Account_Id__c = 'TE-001001';
        a.Name = 'Test Sleep';
        a.Billing_Email_address__c = 'account@email.com';
        insert a;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'TE-001002';
        a2.Name = 'test';
        insert a2;

        Contact c = new Contact();
        c.Firstname = 'Test';
        c.LastName = 'Sleep';
        c.AccountId = a.Id;
        insert c;

        Contact c1 = new Contact();
        c1.Firstname = 'Test';
        c1.LastName = 'Sleepallday';
        c1.AccountId = a2.Id;
        insert c1;

        AccountContactRelation AccCon = new AccountContactRelation();
        AccCon.AccountId = a.Id;
        AccCon.ContactId = c1.Id;
        AccCon.IsActive = true;
        insert AccCon;

    }

    @IsTest
    static void runCtrlTest(){
        Test.StartTest();

        Account a = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c = 'TE-001001'];
        Account a2 = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c = 'TE-001002'];
        Contact c = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId =: a2.Id];
        AccountContactRelation accCon = [SELECT AccountId, ContactId FROM AccountContactRelation WHERE ContactId=:c.Id LIMIT 1];

        QuickVisitAuraController.getContact(c.Id);
        QuickVisitAuraController.getStarndardVisitRecordType();
        QuickVisitAuraController.searchAccountContactRelation('Test', 'AccountContactRelation', a.Id);
        QuickVisitAuraController.getDefaultAccountId(a.Id, 'AccountContactRelation');
        QuickVisitAuraController.getStarndardVisitRecordType();

        Datetime pStart = DateTime.newInstance(2021,1,1);
        Datetime pEnd = DateTime.newInstance(2021,1,31);
        List<Event> eventList = QuickVisitAuraController.getUserIdEvents(pStart, pEnd, UserInfo.getUserId());

        Test.StopTest();
    }
}