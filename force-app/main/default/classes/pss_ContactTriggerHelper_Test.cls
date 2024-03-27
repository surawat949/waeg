@isTest
public with sharing class pss_ContactTriggerHelper_Test {
    public pss_ContactTriggerHelper_Test() {

    }

    @TestSetup
    static void makeData(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
        String MasterTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and Name='Master'].Id;
        String CopyTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and DeveloperName='Copy'].Id;

        Account_Template__c master = new Account_Template__c();
        master.RecordTypeId = MasterTempId;
        master.Name = 'HOLK-Test-master';
        insert master;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'KR1112';
        a.Name = 'Test-sk';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Account a1 = new Account();
        a1.Hoya_Account_Id__c = 'KR1113';
        a1.Name = 'Test-sk2';
        a1.currencyisocode = 'EUR';
        insert a1;

        Account_Template__c copy = new Account_Template__c();
        copy.Name = 'holk-test-copy';
        copy.Account__c = a.Id;
        copy.Default__c = true;
        copy.Master_Template__c = master.Id;
        copy.Active_Authorization_Template__c = true;
        copy.RecordTypeId = CopyTempId;
        insert copy;

        Contact c = new Contact();
        c.FirstName = 'testh';
        c.LastName = 'lasth';
        c.Account_Template__c = copy.Id;
        c.AccountId = a.Id;
        c.Email = 'test@hotmail.com';
        c.RecordTypeId = RecTypeId;
        insert c;

        Profile p = [select Id from Profile where Name = 'Customer Community Plus User' limit 1];
        Profile license = [select Id from profile where profile.userlicense.name = 'Customer Community Plus' limit 1];

        User u = new User();
        u.FirstName = 'Testcommunity';
        u.LastName = 'Testlastcomm';
        u.Email = 'testyyy@gmail.com';
        u.UserName = 'testyyy2@tradeportal.hoya.com.waeg';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testzxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.ContactId = c.Id;
        insert u;


    }

    @isTest
    static void testWhole(){
        Contact cc = [select Id, FirstName, LastName, Create_New_Account_Template__c, Email, MobilePhone from Contact where Account.Hoya_Account_Id__c='KR1112' limit 1];
        cc.FirstName = 'test123';
        cc.LastName = 'test456';
        cc.Create_New_Account_Template__c = true;
        cc.MobilePhone = '010-1458-222';
        cc.Email = 'testxxx_1@yahoo.co.th';
        update cc;
    }

 /*   @isTest
    static void runCreatContactTest(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'TE-1111';
        a.Name = 'Test-zxcv';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Test-cons';
        c.LastName = 'Test-lastname';
        c.RecordTypeId = RecTypeId;
        c.AccountId = a.Id;
        c.pss_Moodle_User_ID__c = 'zxcv1234';
        c.CurrencyIsoCode = 'EUR';
        insert c;

        Test.StartTest();
        List<Contact> newCons = new List<Contact>();
        Map<Id, Contact> mapCons = new Map<Id, Contact>();
        mapCons.put(c.Id, c);
        Test.StopTest();

    }

    @isTest
    static void runUpdateUserFlagTest(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
        String MasterTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and Name='Master'].Id;
        String CopyTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and DeveloperName='Copy'].Id;

        Account_Template__c at = new Account_Template__c();
        at.Name = 'HOLK Shop Owner-test';
        at.RecordTypeId = MasterTempId;
        insert at;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'KR-1112';
        a.Name = 'Test-SK';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Account_Template__c cpat = new Account_Template__c();
        cpat.Name = 'HOLK Shop Owner-copy-test';
        cpat.Account__c = a.Id;
        cpat.Master_Template__c = at.Id;
        cpat.Default__c = true;
        cpat.Active_Authorization_Template__c = true;
        //cpat.RecordTypeId = CopyTempId;
        insert cpat;

        List<Account_Template__c> cpatList = new List<Account_Template__c>();
        cpatList.add(cpat);

        Contact cnew = new Contact();
        cnew.FirstName = 'testnew';
        cnew.LastName = 'testlastnew';
        cnew.Email = 'testnew@yahoo.com';
        cnew.pss_Moodle_User_ID__c = 'cxzc1234';
        cnew.Account_Template__c = cpat.Id;
        cnew.pss_Needs_Moodle_Update__c = true;
        cnew.AccountId = a.Id;
        cnew.RecordTypeId = RecTypeId;
        cnew.CurrencyIsoCode = 'EUR';
        insert cnew;
        List<Contact> consList = new List<Contact>();
        consList.add(cnew);

        Contact cold = new Contact();
        cold.FirstName = 'testold';
        cold.LastName = 'testlastold';
        cold.Email = 'testold@yahoo.com';
        cold.AccountId = a.Id;
        cold.pss_Moodle_User_ID__c = 'cxzt1234';
        cold.Account_Template__c = cpat.Id;
        cold.pss_Needs_Moodle_Update__c = false;
        cold.RecordTypeId = RecTypeId;
        cold.CurrencyIsoCode = 'EUR';
        insert cold;
        consList.add(cold);

        Map<Id, Contact> consMap = new Map<Id, Contact>();
        consMap.put(cnew.Id, cnew);
        consMap.put(cold.Id, cold);

    }*/
    
    
    @isTest
    static void runHOLKTest(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
        String MasterTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and Name='Master'].Id;
        String CopyTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and DeveloperName='Copy'].Id;

        Account_Template__c at = new Account_Template__c();
        at.Name = 'HOLK Shop Owner';
        at.RecordTypeId = MasterTempId;
        insert at;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'KR-1112';
        a.Name = 'Test-SK';
        a.CurrencyIsoCode = 'EUR';
        insert a;
        
        Contact cnew = new Contact();
        cnew.FirstName = 'testnew';
        cnew.LastName = 'testlastnew';
        cnew.Email = 'testnew@yahoo.com';
        cnew.pss_Moodle_User_ID__c = 'cxzc1234';
        cnew.pss_Needs_Moodle_Update__c = true;
        cnew.AccountId = a.Id;
        cnew.RecordTypeId = RecTypeId;
        cnew.CurrencyIsoCode = 'EUR';
        insert cnew;
        List<Contact> consList = new List<Contact>();
        consList.add(cnew);

        Contact cold = new Contact();
        cold.FirstName = 'testold';
        cold.LastName = 'testlastold';
        cold.Email = 'testold@yahoo.com';
        cold.AccountId = a.Id;
        cold.pss_Moodle_User_ID__c = 'cxzt1234';
        cold.pss_Needs_Moodle_Update__c = false;
        cold.RecordTypeId = RecTypeId;
        cold.CurrencyIsoCode = 'EUR';
        insert cold;
        consList.add(cold);

        Map<Id, Contact> consMap = new Map<Id, Contact>();
        consMap.put(cnew.Id, cnew);
        consMap.put(cold.Id, cold);

    }
}