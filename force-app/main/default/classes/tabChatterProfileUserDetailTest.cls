@isTest
public class tabChatterProfileUserDetailTest {
    
    @isTest
    public static  void testMyController(){ 

        Profile p = [select Id from Profile where Name = 'Chatter Plus Marketing' limit 1];

        User u = new User();
        u.FirstName = 'Testcommunity1';
        u.LastName = 'Testlastcomm1';
        u.Email = 'testyyy@gmail.com.invalid';
        u.UserName = 'testyyy@tradeportal.hoya.com.waeg';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testzxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.Reset_Password_Token__c='KJWHE7346873';
        insert u;
        Test.StartTest();
        tabChatterProfileUserDetail.getUserDetail();
        Test.StopTest();
    }   
}