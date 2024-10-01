/**
 * @Author : Surawat Sakulmontreechai
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Description : test class support visitZonesMapController
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2024-06-20
 * 
 * Code coverage : 92%
 */
@IsTest
public with sharing class visitZonesMapController_Test {
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Hoya_Account_ID__c = 'TEST-001';
        a.Name = 'Test account';
        a.Shop_Street__c = 'Test street';
        a.Shop_City__c = 'Test city';
        a.Shop_State__c = 'Bangkok';
        a.Shop_Country__c = 'Thailand';
        a.Shop_Postal_Code__c = '11111';
        a.ShippingLatitude = 13.736717;
        a.ShippingLongitude = 100.523186;
        a.TACTICOM_SOF__c = 'Sub-area 1';
        //a.Seiko_Network__c = 'Visionary Alliance';
        //a.Visionary_Alliance__c = 'Insider';
        insert a;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'TEST-002';
        a2.Name = 'test zone name';
        a2.Shop_Street__c = 'Test street';
        a2.Shop_City__c = 'test city';
        a2.Shop_State__c = 'Bangkok';
        a2.Shop_Country__c = 'Thailand';
        a2.Shop_Postal_Code__c = '11111';
        a2.ShippingLatitude = 13.736717;
        a2.ShippingLongitude = 100.523186;
        a2.TACTICOM_SOF__c = '';
        a2.Seiko_Network__c = 'Visionary Alliance';
        a2.Visionary_Alliance__c = 'Insider';
        a2.Lenses_Net_Sales_Last_12Mo__c = 10;
        a2.Account_Status__c = 'Open';
        insert a2;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Assigned_to__c = UserInfo.getUserId();
        v.Start_Time__c = System.today();
        v.End_Time__c = System.today()+1;
        v.Visit_Type__c = 'Visit';
        v.Visit_Status__c = 'Planned';
        insert v;

        Visits__c v2 = new Visits__c();
        v2.Account__c = a2.Id;
        v2.Assigned_to__c = UserInfo.getUserId();
        v2.Start_Time__c = System.today();
        v2.End_Time__c = System.today()+2;
        v2.Visit_Type__c = 'Visit';
        v2.Visit_Status__c = 'Planned';
        insert v2;

    }
    @isTest
    static void TestClassAccountVisit(){
        Test.startTest();

        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Hoya_Account_Id__c, Name FROM Account WHERE Hoya_Account_Id__c = 'TEST-001'];

        List<Account> accList2 = new List<Account>();
        accList2 = [SELECT Id, Hoya_Account_Id__c, Name FROM Account WHERE Hoya_Account_ID__c = 'TEST-002'];

        Set<Id> accId = new Set<Id>();
        for(Account a : accList){
            accId.add(a.Id);
        }

        Set<Id> accId2 = new Set<Id>();
        for(Account a2 : accList2){
            accId2.add(a2.Id);
        }

        List<Visits__c> vList = new List<Visits__c>();
        vList = [SELECT Id, Account__c, Name FROM Visits__c WHERE Account__c IN:accId];

        List<Visits__c> vList2 = new List<Visits__c>();
        vList2 = [SELECT Id, Account__c FROM Visits__c WHERE Account__c IN:accId2];


        visitZonesMapController.getAccountForMapData('Sub-area 1', false,UserInfo.getUserId(),7);
        visitZonesMapController.getAccountForMapData(null, true, UserInfo.getUserId(), 7);
        visitZonesMapController.getAccountForMapData('Not Selected Customers', true, UserInfo.getUserId(), 7);
        visitZonesMapController.getAccountForMapData(null, false,UserInfo.getUserId(),30);
        visitZonesMapController.getTranslations();
        
        Test.stopTest();
    }
}