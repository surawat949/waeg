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
        a.Seiko_Network__c = 'Visionary Alliance';
        a.Visionary_Alliance__c = 'Insider';
        insert a;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Assigned_to__c = UserInfo.getUserId();
        v.Start_Time__c = System.today();
        v.End_Time__c = System.today()+1;
        v.Visit_Type__c = 'Visit';
        v.Visit_Status__c = 'Planned';
        insert v;
    }
    @isTest
    static void TestClassAccountVisit(){
        Test.startTest();

        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Hoya_Account_Id__c, Name FROM Account WHERE Hoya_Account_Id__c = 'TEST-001'];
        Set<Id> accId = new Set<Id>();
        
        for(Account a : accList){
            accId.add(a.Id);
        }

        List<Visits__c> vList = new List<Visits__c>();
        vList = [SELECT Id, Account__c, Name FROM Visits__c WHERE Account__c IN:accId];
        visitZonesMapController.getAccountForMapData('Sub-area 1', false,UserInfo.getUserId(),7);
        visitZonesMapController.getAccountForMapData(null, false,UserInfo.getUserId(),30);
        visitZonesMapController.getTranslations();
        Test.stopTest();
    }
}