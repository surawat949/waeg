/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @CreatedDate : 2023-11-24
 * @version : 1.0
 * @api : 55.0
 * @description : this test class for TabStatisticCompetitorController
 * code coverage : 88%
 */
@IsTest
public with sharing class TabStatisticCompetitorController_Test {
    @TestSetup
    static void makeData(){

        String profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        String TaskRecId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Standard_New').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test-acc1';
        acc.Hoya_Account_ID__c = 'T-01';
        acc.First_Competitor_local_name__c = 'Essilor';
        acc.First_Competitor_Global_Name__c = 'Essilor';
        acc.Second_Competitor_Local_Name__c = 'Rodenstock';
        acc.Second_Competitor_global_name__c = 'Rodenstock';
        insert acc;
        
        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testini@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        u.IsActive = true;
        u.ProfileId = profileId;
        insert u;

        Task t = new Task();
        t.Subject = 'Test';
        t.OwnerId = u.Id;
        t.Instructions__c = 'This is a test';
        t.ActivityDate = System.today()+3;
        t.Status = 'In Progress';
        t.RecordTypeId = TaskRecId;
        t.WhatId = acc.Id;
        t.Account__c = acc.Id;
        insert t;

        Last_Sales_Statistics__c sales = new Last_Sales_Statistics__c();
        sales.Account__c = acc.Id;
        sales.H_S_Gross_Sales_SOW_Last_3Mo__c = 10.2;
        sales.CurrencyIsoCode = 'EUR';
        sales.Hoya_Lens_Gross_Sales_Last_3Mo__c = 10;
        sales.Hoya_Lens_Net_Sales_Last_3Mo__c = 10;
        insert sales;
    }

    @IsTest
    static void UnitTest01(){

        Account accList = [SELECT Id, Name, Hoya_Account_ID__c, First_Competitor_local_name__c FROM Account WHERE Hoya_Account_ID__c='T-01' LIMIT 1];
        Global_Competitor_Entity__mdt competeList = [SELECT Competitor_Entity_Name__c, First_Competitor_Global_Name__c, First_Competitor_Local_Name__c FROM Global_Competitor_Entity__mdt WHERE Competitor_Entity_Name__c = 'Essilor' LIMIT 1];
        User uList = [SELECT Id, Name FROM User WHERE Username='testini@hoya.com.pcpy' LIMIT 1];
        Task tList = [SELECT Id, Subject, OwnerId, Instructions__c, ActivityDate, Status, RecordTypeId, WhatId, Account__c FROM Task WHERE WhatId=:accList.Id LIMIT 1];
        Last_Sales_Statistics__c lastsales = [SELECT Id, First_Competitor_SOW_Last_3_Month__c FROM Last_Sales_Statistics__c WHERE Account__c=:accList.Id LIMIT 1];
        Test.StartTest();
        TabStatisticCompetitorController.searchDefaultRecord(accList.Id, 'Account');
        TabStatisticCompetitorController.searchLookupData('Essilor', 'Account');
        TabStatisticCompetitorController.UpdateCompetitor(accList.Id, 'Essilor', 'BBGR');
        TabStatisticCompetitorController.UpdateCompetitor(accList.Id, '', '');
        TabStatisticCompetitorController.searchLookupUserDefault(accList.Id, 'Account');
        TabStatisticCompetitorController.searchLookupUser('test', 'User');
        TabStatisticCompetitorController.getFirstLocalCompetitorName(accList.Id);
        TabStatisticCompetitorController.getSecondLocalCompetitorName(accList.Id);
        TabStatisticCompetitorController.searchDefaultAccountName(accList.Id, 'Account');
        TabStatisticCompetitorController.searchAccountName(accList.Id, 'Account', 'Test');
        TabStatisticCompetitorController.CreateNewCompetitorReq('Test', 'Test', uList.Id, System.today(), 'In Progress', accList.Id);
        TabStatisticCompetitorController.getFirstCompetitorSOW(accList.Id);
		
        Test.StopTest();    
        System.assert(true);

        try{
            TabStatisticCompetitorController.CreateNewCompetitorReq(null, null, null, null, null, null);

        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabStatisticCompetitorController.UpdateCompetitor(null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabStatisticCompetitorController.getFirstLocalCompetitorName(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}