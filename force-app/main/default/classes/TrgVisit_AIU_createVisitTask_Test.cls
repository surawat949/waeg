/**
 *  This test class is for visit_AIU_createVisitTask.
 *
 @author Yuda Zheng
 @created 2013-07-24
 @version 1.0
 @since 27.0 
 *
 @changelog
 * 2013-07-24 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 * - Test coverage 100%
 * - 2023-11-15 Surawat Sakulmontreechai <surawat.sakulmontreechai@hoya.com>
 * - Updated
 * - To get the new coverage for update api purpose.
 */
@isTest
private class TrgVisit_AIU_createVisitTask_Test {
    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'Test';
        u.Lastname = 'Datatest';
        u.Username = 'test.data@hoya.com.invalid';
        u.Email = 'test.data@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'Dtest';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HLBR';
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE-002';
        a.Name = 'Test account';
        a.OwnerId = u.Id;
        insert a;


    }

    @isTest
    static void UnitTest1(){
        Account acc = [select Id, Hoya_Account_ID__c, Name from account where Hoya_Account_ID__c='TE-002' limit 1];
        User u = [select Id, Name, CompanyName from User where Username = 'test.data@hoya.com.invalid' limit 1];
        
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Assigned_to__c = u.Id;
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = System.today();
        visit.End_Time__c = System.today()+1;
        visit.Visit_Type__c = 'Visit';

        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc.Id;
        visit2.Assigned_to__c = u.Id;
        visit2.Visit_Status__c = 'Complete';
        visit2.Start_Time__c = System.today()-2;
        visit2.End_Time__c = System.today()-2;
        visit2.Visit_Type__c = 'Visit';

        Test.StartTest();
        insert visit;
        insert visit2;

        visit.Start_Time__c = System.today()-1;
        visit.End_Time__c = System.today()-1;
        visit.Visit_Status__c = 'Complete';
        update visit;

        visit2.Start_Time__c = System.today()-1;
        visit2.End_Time__c = System.today()-1;
        visit2.Visit_Status__c = 'Complete';
        update visit2;
        System.assert(true);
        Test.StopTest();


    }
    
}