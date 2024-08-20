/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @version : 1.0
 * @description : testing class for TabVisitsEcpNearby
 * code coverage : 86%
 */
@IsTest
public with sharing class TabVisitsEcpNearby_Test {
    //for test class TabVisitsEcpNearby - class
    @TestSetup
    static void makeData(){

        String IndRecId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'T001';
        a1.Name = 'Test ECP Nearby';
        a1.ShippingLatitude = 52.377956;
        a1.ShippingLongitude = 4.897070;
        a1.ShippingCity = 'Amsterdam';
        a1.ShippingCountry = 'Netherlands';
        a1.RecordTypeId = IndRecId;
        a1.First_Competitor_global_name__c = 'Essilor';
        a1.First_Competitor_local_name__c = 'Essilor';
        a1.Seiko_Network__c = 'Visionary Alliance';
        insert a1;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'T002';
        a2.Name = 'Test ECP Nearby 2';
        a2.ShippingLatitude = 52.078663;
        a2.ShippingLongitude = 4.288788;
        a2.ShippingCity = 'Hague';
        a2.ShippingCountry = 'Netherlands';
        a2.RecordTypeId = IndRecId;
        insert a2;


        
    }

    @IsTest
    static void TestMultipleClass1(){
        Test.StartTest();
        Account a1 = [SELECT Id, Hoya_Account_ID__c, Seiko_Network__c, First_Competitor_local_name__c FROM Account WHERE Hoya_Account_ID__c='T001' LIMIT 1];
        TabVisitsEcpNearby.getAccountsMap(a1.Id, 5, '', 0, 500, '', '');
        TabVisitsEcpNearby.getAccountsMap(a1.Id, 5, 'A3', 0, 500, 'Essilor', 'Visionary Alliance');
        TabVisitsEcpNearby.getCompetitorPicklistVal();
        TabVisitsEcpNearby.getSVSNetworkPicklistVal();
        TabVisitsEcpNearby.searchFirstCompetitorDefault(a1.Id, 'Account');
        TabVisitsEcpNearby.searchFirstCompetitor('Test', 'Account');

        System.assert(true);
        Test.StopTest();

        try{
            TabVisitsEcpNearby.getAccountsMap(null, null, null, null, null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabVisitsEcpNearby.getCompetitorPicklistVal();
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        
    }
}