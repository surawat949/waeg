/**
 * This is a test class for DoorSalesPerformanceTest
 *
 @author cdupre
 @created 2019-07-05
 *
 */
 @isTest
public with sharing class DoorSalesPerformanceTest {
    
    static testMethod void testCtrl(){
        
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'test acc doorperf';
        acc.Hoya_Account_Id__c = 'EMEA1234';
        insert acc;

        Door__c door = new Door__c();
        door.Main_Account__c = acc.Id;
        door.Name=' test door perf';
        door.Geolocation__Latitude__s = 0;
        door.Geolocation__Longitude__s = 0;
        insert door;

        acc.door__c = door.Id;
        update acc;

        ApexPages.StandardController sc = new ApexPages.StandardController(door);
        DoorSalesPerformanceHoyaCtrl ctrl = new DoorSalesPerformanceHoyaCtrl(sc);
        ctrl.getPerformanceList(door.id);

        Test.stopTest();
        
    }
}