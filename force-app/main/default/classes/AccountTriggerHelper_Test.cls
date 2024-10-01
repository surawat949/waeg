/*
    AccountTriggerHelper testing class - due for this class not due with code coverage before.
    Main target - AccountTriggerHelper class.
    Created by : Surawat Sakulmontreechai | sakulmontreechai@yahoo.com
    Created date : 2022-07-15
*/
@IsTest
public with sharing class AccountTriggerHelper_Test {
    public AccountTriggerHelper_Test() {

    }
    
    @TestSetup
    static void makeData(){
        Account hvnaAcc = new Account();
        hvnaAcc.Hoya_Account_ID__c = 'US1234512';
        hvnaAcc.CurrencyIsoCode = 'EUR';
        hvnaAcc.Name = 'HVNA Test';
        hvnaAcc.Strategic_Value_Gross_Sales__c = 1000;
        insert hvnaAcc;
        
        Account holkAcc = new Account();
        holkAcc.Hoya_Account_ID__c = 'KR1234512';
        holkAcc.CurrencyIsoCode = 'EUR';
        holkAcc.Name = 'HOLK Test';
        insert holkAcc;
        
        Account seikoAcc = new Account();
        seikoAcc.Hoya_Account_ID__c = 'SO4900559988';
        seikoAcc.CurrencyIsoCode = 'EUR';
        seikoAcc.Name = 'SAP Code Test';
        seikoAcc.shop_country__c = 'DE';
        seikoAcc.Strategic_Value_Net_Sales__c =10000;
        insert seikoAcc;


        Account seiko = new Account();
        seiko.Hoya_Account_ID__c = 'SO1234512';
        seiko.CurrencyIsoCode = 'EUR';
        seiko.Name = 'SEIKO1 Test';
        insert seiko;

        Account IQVIA = new Account();
        IQVIA.Hoya_Account_ID__c = 'WDS12345';
        IQVIA.CurrencyIsoCode = 'EUR';
        IQVIA.Name = 'NO NAME';
        IQVIA.QIDC__OneKeyId_IMS__c = 'WDS12345';
        insert IQVIA;
    }
    @isTest
    Static void testAlC() {
        Test.StartTest();
        String ACCOUNT_Chain_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain').getRecordTypeId();
        Account AlcAccount = new Account();
        AlcAccount.Hoya_Account_ID__c = 'SO1234514';
        AlcAccount.CurrencyIsoCode = 'EUR';
        AlcAccount.Name = 'SEIKO1 Test';
        AlcAccount.CHCUSTCLASSIFICATIONID__c = 'Ind';
        AlcAccount.RecordTypeId = ACCOUNT_Chain_RT;
        AlcAccount.TACTICOM_SOF__c = 'Sub-area 1';
        insert AlcAccount;
        
        Account AlcAccount1 = new Account();
        AlcAccount1.Hoya_Account_ID__c = 'SO1234515';
        AlcAccount1.CurrencyIsoCode = 'EUR';
        AlcAccount1.Name = 'SEIKO1 Test';
        AlcAccount1.CHCUSTCLASSIFICATIONID__c = 'Dis';
        AlcAccount1.RecordTypeId = ACCOUNT_Chain_RT;
        AlcAccount1.TACTICOM_SOF__c = 'Sub-area 1';
        insert AlcAccount1;
        
        AlcAccount1.CHCUSTCLASSIFICATIONID__c = 'Ind';
        update AlcAccount1;
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = AlcAccount1.Id;
        visit1.Visit_Type__c = 'Visit';
        visit1.Visit_Status__c = 'Complete';
        visit1.Visit_Reason__c = 'Retain';
        visit1.Start_Time__c = date.today()-1;
        visit1.End_Time__c = visit1.Start_Time__c.addMinutes(60);
        visit1.Assigned_to__c = UserInfo.getUserId();
        insert visit1;
        System.assert(true);
        Test.StopTest();
    }
    @isTest
    Static void testLastSalesUpdate() {
        Test.StartTest();
        Account GermanAcc = new Account();
        GermanAcc.Hoya_Account_ID__c = 'SO4900549988';
        GermanAcc.CurrencyIsoCode = 'EUR';
        GermanAcc.Name = 'Last Sales Update Test';
        GermanAcc.shop_country__c = 'DE';
        GermanAcc.Strategic_Value_Gross_Sales__c =10000;
        insert GermanAcc;
        
        Last_Sales_Statistics__c lastSales = new Last_Sales_Statistics__c();
        lastSales.Account__c = GermanAcc.Id;
        lastSales.Seiko_Lens_Gross_Sales_Last_3Mo__c = 150;
        lastSales.Hoya_Lens_Gross_Sales_Last_3Mo__c = 100;    
        lastSales.Seiko_Lens_Gross_Sales_Last_12Mo__c = 1500;
        lastSales.Hoya_Lens_Gross_Sales_Last_12Mo__c = 1000;
        lastSales.H_S_Lens_Gross_Sales_Last_12Mo__c = 1650;
     	lastSales.Account__c = GermanAcc.Id;
        insert lastSales;
        
        GermanAcc.Strategic_Value_Gross_Sales__c =15000;
        update GermanAcc;
        
        Account OtherAcc = new Account();
        OtherAcc.Hoya_Account_ID__c = 'US1254512';
        OtherAcc.CurrencyIsoCode = 'EUR';
        OtherAcc.Name = 'Other Account Test';
        OtherAcc.Strategic_Value_Net_Sales__c = 1000;
        insert OtherAcc;      
        
        Last_Sales_Statistics__c lastSales1 = new Last_Sales_Statistics__c();
        lastSales1.Seiko_Lens_Net_Sales_Last_12Mo__c = 1200;
        lastSales1.Hoya_Lens_Net_Sales_Last_12Mo__c = 1000;
        lastSales1.H_S_Lens_Net_Sales_Last_12Mo__c = 3200;
        lastSales1.Seiko_Lens_Net_Sales_Last_3Mo__c = 150;
        lastSales1.Hoya_Lens_Net_Sales_Last_3Mo__c = 100;
        lastSales1.H_S_Lens_Net_Sales_Last_3Mo__c=250;
        lastSales1.Account__c = OtherAcc.Id;
        insert lastSales1;
        
        OtherAcc.Strategic_Value_Net_Sales__c = 10000;
        update OtherAcc;      
       
        System.assert(true);
        Test.StopTest();
    }
    @isTest
    Static void testWholeClass() {
        Test.StartTest();
        Account acc = [Select Id, name,Create_New_Account_Tasks__c from Account Where Hoya_Account_Id__c = 'US1234512' limit 1];
        acc.Create_New_Account_Tasks__c = true;
        acc.HVNA_Create_Onboarding_Tasks__c = true;
        update acc;
        acc.additionnal_account_data__c = null;
        update acc;
        delete acc;
        
        /*
        Account accHOLK = [Select Id, name,Create_New_Account_Tasks__c from Account Where Hoya_Account_Id__c = 'KR1234512' limit 1];
        accHOLK.HOLK_account_data__c = null;
        update accHOLK;
        */
        
        Account accSeiko = [Select Id, name,Create_New_Account_Tasks__c from Account Where Hoya_Account_Id__c = 'SO1234512' limit 1];
        accSeiko.Potential__c = 10;
        accSeiko.Target_List__c = true;
        update accSeiko;
        accSeiko.Target_List__c = false;
        update accSeiko;
        Test.StopTest();

        
    }

    @IsTest
    static void runTestSeikoInsert(){
        Account seiko = new Account();
        seiko.Name = 'Seiko-test';
        seiko.Hoya_Account_ID__c = 'SO111111';
        seiko.CurrencyIsoCode = 'EUR';
        insert seiko;

        Seiko_data__c seikoaad = new Seiko_data__c();
        seikoaad.account__c = seiko.Id;
        seikoaad.CurrencyIsoCode = seiko.CurrencyIsoCode;
        seikoaad.Hoya_Account_Id__c = seiko.Hoya_Account_Id__c;
        seikoaad.Name = seiko.Name;

        List<Seiko_data__c> seikoList = new List<Seiko_data__c>();

        List<Account> accSeikoList = new List<Account>();
        for(Account a : accSeikoList){
            accSeikoList.add(a);
            seikoList.add(seikoaad);
        }

        Test.StartTest();
        AccountTriggerHelper.doSeikoInsert(accSeikoList);
        System.assert(true);
        Test.StopTest();

    }

    @IsTest
    static void runTestSeikoUpdate(){

        String oppRecordTypeId =  [select Id,Name from RecordType where sObjectType='Opportunity' and Name='Seiko Vision Specialist Hunting'].Id;
        String userId = UserInfo.getUserId();

        Opportunity_Custom__c oc = new Opportunity_Custom__c();
        oc.Name = 'HAPL';
        oc.Company_Name__c = 'HAPL';
        insert oc;

        Account seiko = new Account();
        seiko.Name = 'Seiko-test';
        seiko.Hoya_Account_ID__c = 'SO111111';
        seiko.CurrencyIsoCode = 'EUR';
        seiko.OwnerId = userId;
        seiko.Potential__c = 10;
        seiko.Target_List__c = true;
        insert seiko;

        List<Account> accList = new List<Account>();
        accList.add(seiko);

        Seiko_data__c seikoaad = new Seiko_data__c();
        seikoaad.account__c = seiko.Id;
        seikoaad.CurrencyIsoCode = seiko.CurrencyIsoCode;
        seikoaad.Hoya_Account_Id__c = seiko.Hoya_Account_Id__c;
        seikoaad.Name = seiko.Name;

        List<Seiko_data__c> seikoList = new List<Seiko_data__c>();
        seikoList.add(seikoaad);
    
        Account seiko2 = new Account();
        seiko2.Name = 'Seiko-test';
        seiko2.Hoya_Account_ID__c = 'SO-221';
        seiko2.CurrencyIsoCode = 'EUR';
        seiko2.OwnerId = userId;
        seiko2.Target_List__c = false;
        seiko2.Potential__c = 10;
        insert seiko2;
        accList.add(seiko2);

        Seiko_data__c seikoaad2 = new Seiko_data__c();
        seikoaad2.account__c = seiko2.Id;
        seikoaad2.CurrencyIsoCode = seiko2.CurrencyIsoCode;
        seikoaad2.Hoya_Account_Id__c = seiko2.Hoya_Account_Id__c;
        seikoaad2.Name = seiko2.Name;
        seikoList.add(seikoaad2);

        Opportunity opp = new Opportunity();
        opp.Name = 'Target List : '+seiko.Name;
        opp.AccountId = seiko.Id;
        opp.OwnerId = seiko.OwnerId;
        opp.RecordTypeId = oppRecordTypeId;
        opp.CurrencyIsoCode = seiko.CurrencyIsoCode;
        opp.Annual_Expected_Sales__c = seiko.Potential__c*0.5;
        opp.CloseDate = System.today()+180;
        opp.StageName = '1. 1st Appointment';
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Target List : '+seiko2.Name;
        opp2.AccountId = seiko2.Id;
        opp2.OwnerId = seiko2.OwnerId;
        opp2.RecordTypeId = oppRecordTypeId;
        opp2.CurrencyIsoCode = seiko2.CurrencyIsoCode;
        opp2.Annual_Expected_Sales__c = seiko2.Potential__c*0.5;
        opp2.CloseDate = System.today();
        opp2.StageName = '[SVS] Closed Lost';
        oppList.add(opp2);

        insert oppList;

        Map<Id, Account> accMap = new Map<Id, Account>();
        accMap.put(seiko.Id, seiko);
        accMap.put(seiko2.Id, seiko2);

        Test.StartTest();
        AccountTriggerHelper.doSeikoUpdate(accList, accMap);
        system.assert(true);
        Test.StopTest();

    }

    /*
    @IsTest
    static void runTestdoApacAfterInsert(){
        Test.StartTest();
        //String HuntingOppRecId = [select Id, Name from RecordType where DeveloperName='Hunting_Opportunities'].Id;
        String HuntingOppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();
        String taskRecId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunity_Task').getRecordTypeId();
        
        Opportunity_Custom__c oppdefault = new Opportunity_Custom__c();
        oppdefault.Name = 'DEFAULT';
        oppdefault.Company_Name__c = 'DEFAULT';
        insert oppdefault;

        Profile p = [select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HAPL';
        u.Alias = 'test';
        insert u;

        Opportunity_Custom__c oc = new Opportunity_Custom__c();
        oc.Name = 'HAPL';
        oc.Company_Name__c = 'HAPL';
        insert oc;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'test-1234';
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Target_List__c = true;
        a.Manual_Segment__c = 'A3';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Opportunity o1 = new Opportunity();
        o1.RecordTypeId = HuntingOppRecId;
        o1.Name = 'test-oopp-zxcv';
        o1.StageName = '1-Initial Contact';
        o1.CloseDate = System.today()+7;
        o1.AccountId = a.Id;
        o1.CurrencyIsoCode = 'EUR';
        o1.OwnerId = u.Id;
        insert o1;

        Task t = new Task();
        t.Subject = 'Please check for your opportunity will close in 7 days.';
        t.WhatId = o1.Id;
        t.Status = 'New';
        t.RecordTypeId = taskRecId;
        t.OwnerId = o1.OwnerId;
        t.ActivityDate = o1.CloseDate;
        t.Hoya_Account_ID__c = a.Hoya_Account_ID__c;
        t.Actions_Needed__c = 'Opportunity '+o1.Name+' will close on '+o1.CloseDate+' @11.59PM your local time-zone. Please update the opportunity details if this is still active.';
        t.CurrencyIsoCode = o1.CurrencyIsoCode;
        t.Description = 'This is reminder to updates for the opportunity. And this is will close within 14 days. Please updates the values of opportunity and expect close date. Please check this link: https://hoya.lightning.force.com/lightning/r/Opportunity/'+o1.Id+'/view';
        t.Priority = 'Hoch';
        insert t;

        List<Account> accList = new List<Account>();

        
        AccountTriggerHelper.doAPACAfterInsert(accList);
        system.assert(true);
        Test.StopTest();
    }*/

    /*
    @IsTest
    static void runTestdoAPACUpdateAfterInsert(){
        Test.StartTest();
        String HuntingOppRecId = [select Id, Name from RecordType where DeveloperName='Hunting_Opportunities'].Id;
        String taskRecId = [select Id, Name from RecordType where DeveloperName='Hunting_Opportunity_Task'].Id;
        
        Opportunity_Custom__c opdefault = new Opportunity_Custom__c();
        opdefault.Company_Name__c = 'DEFAULT';
        opdefault.Name = 'DEFAULT';
        insert opdefault;

        Profile p = [select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HAPL';
        u.Alias = 'test';
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'test-1234';
        a.Name = 'test';
        a.OwnerId = u.Id;
        a.Target_List__c = false;
        a.CurrencyIsoCode = 'EUR';
        List<Account> accList = new List<Account>();
        accList.add(a);

        Opportunity_Custom__c oc = new Opportunity_Custom__c();
        oc.Name = 'HAPL';
        oc.Company_Name__c = 'HAPL';
        insert oc;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'test-12345';
        a2.Name = 'test-zxcv';
        a2.OwnerId = u.Id;
        a2.Target_List__c = true;
        a2.Manual_Segment__c = 'A3';
        a2.CurrencyIsoCode = 'EUR';
        accList.add(a2);

        Account a3 = new Account();
        a3.Hoya_Account_ID__c = 't-11';
        a3.Name = 'testzxcccv';
        a3.OwnerId = u.Id;
        a3.Target_List__c = false;
        a3.CurrencyIsoCode = 'EUR';
        a3.Manual_Segment__c = 'C3';
        insert a3;

        Map<Id, Account> newMap = new Map<Id, Account>();
        newMap.put(a.Id, a);
        newMap.put(a2.Id, a2);

        Opportunity op = new Opportunity();
        op.Name = 'last-stage';
        op.AccountId = a2.Id;
        op.StageName = '1-Initial Contact';
        op.RecordTypeId = HuntingOppRecId;
        op.CloseDate = System.today();
        insert op;

        Task t = new Task();
        t.Subject = 'test-subject';
        t.WhatId = op.Id;
        t.ActivityDate = System.today();
        t.RecordTypeId = taskRecId;
        t.Description = 'test';
        t.Status='Completed';
        insert t;

     
        AccountTriggerHelper.doAPACUpdateAfterUpdate(accList, newMap);
        system.assert(true);
        Test.StopTest();

    }*/

    @isTest
    static void runTestUserController(){

        Profile p = [select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HLUK';
        u.Sales_Role__c = 'RSM';
        u.Alias = 'test';
        insert u;

        User u2 = new User();
        u2.FirstName = 'Test2';
        u2.LastName = 'Testlastname2';
        u2.Email = 'test@hoya.com.invalid2';
        u2.UserName = 'test2@hoya.com.pcpy';
        u2.EmailEncodingKey = 'UTF-8';
        u2.profileid = p.Id;
        u2.LocaleSidkey = 'en_US';
        u2.LanguageLocaleKey = 'en_US';
        u2.TimeZoneSidKey = 'America/Los_Angeles';
        u2.CompanyName = 'HVC';
        u2.Sales_Role__c = 'MD';
        u2.Alias = 'test2';
        insert u2;

        Test.StartTest();

        AccountTriggerHelper.getUserCompany(u.Id);
        AccountTriggerHelper.getUserSalesRoles(u.Id);
        AccountTriggerHelper.getUserCompany(u2.Id);
        AccountTriggerHelper.getUserSalesRoles(u2.Id);

        System.assert(true);
        Test.StopTest();
        
    }
    @isTest
    static void runToggleActivation(){
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 't1234';
        a2.Name = 'test-112';
        a2.Account_status__c = 'Open';
        insert a2;
        Contact Con = new Contact();
        con.lastName = 'ABC';
        con.firstname = 'PQR';
        con.AccountId = a2.Id;
        insert con;
        a2.Account_Status__c = 'Closed';
        update a2;
        a2.Account_Status__c = 'Open';
        update a2;

    }
    
    @isTest
    static void updateGlobalNamesTest(){
        Account a = new Account();
        a.Hoya_Account_ID__c = 'test-1234';
        a.Name = 'test';
        a.First_Competitor_Local_Name__c = 'Apsid';
        a.Second_Competitor_Local_Name__c = 'Zeiss';
        a.Target_List__c = false;
        a.CurrencyIsoCode = 'EUR';
        List<Account> accList = new List<Account>();
        accList.add(a);
        insert accList;
        
        a.First_Competitor_Local_Name__c = '';
        a.Second_Competitor_Local_Name__c = '';
        update a;
        a.First_Competitor_Local_Name__c = 'Zeiss';
        a.Second_Competitor_Local_Name__c = 'Apsid';
        update a;
        
    }
}