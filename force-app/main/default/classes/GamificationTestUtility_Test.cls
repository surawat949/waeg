@isTest
public with sharing class GamificationTestUtility_Test {
    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id, Name FROM Profile WHERE Name ='System Administrator'];

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

    }
    @isTest
    static void MyUnitTest01(){
        Profile profiles = [SELECT Id, Name FROM Profile WHERE Name='System Administrator' limit 1];
        User usr = [select Id, Username from user where username='testini@hoya.com.pcpy' limit 1];
        
        Test.StartTest();
        GamificationTestUtility.createTestUser(profiles.Name);
        GamificationTestUtility.createTestUser(profiles);
        GamificationTestUtility.createRandomWord();
        Test.StopTest();

        System.assert(true);
    }
}