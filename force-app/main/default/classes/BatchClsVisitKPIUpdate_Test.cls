/**
 * Created : 2023-11-23 | Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * Test class for : ClsRunVisitKPIBatch | BatchCls_UpdateVisitKPI
 */
@IsTest
public with sharing class BatchClsVisitKPIUpdate_Test {
    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        String accCopy = [SELECT Id FROM RecordType WHERE SObjectType='Account_Template__c' AND DeveloperName='Copy'].Id;
        String accMaster = [SELECT Id FROM RecordType WHERE SObjectType='Account_Template__c' AND DeveloperName = 'MasterRT'].Id;

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
        u.Visit_counter__c = true;
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'DE012';
        a.Name = 'testacc';
        insert a;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Assigned_to__c = u.Id;
        v.Visit_Reason__c = 'Acquisition';
        v.Start_Time__c = System.today()-4;
        v.End_Time__c = System.today();
        v.Visit_Status__c = 'Complete';
        insert v;

        VISIT_KPI__c visit = new VISIT_KPI__c();
        visit.Area_Sales_Manager__c = u.Id;
        visit.Name = 'Test-visit-kpi';
        visit.Visits_completed__c = 1;
        insert visit;

    }

    @IsTest
    static void myUnitTest01(){
        Test.StartTest();
        String sch = '0 0 * * * ?';
        System.schedule('test', sch, new ClsSchedule_runBatchUpdateVisitKPI());
        Test.StopTest();
    }
}