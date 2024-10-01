/**
 * @CreatedBy : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
 * @CreatedDate : 2024-05-15
 * @Description : support class VPMPlannedVisitsMapController, Task-1351
 * Code coverage : 100%
 */
@IsTest
public with sharing class VPMPlannedVisitsMapController_Test {
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE123456';
        a.Name = 'Test account';
        a.Shop_Street__c = '10/667 Test Street';
        a.Shop_City__c = 'Bangkok';
        a.Shop_State__c = 'Bangkok';
        a.Shop_Postal_Code__c = '11001';
        a.Shop_Country__c = 'Thailand';
        insert a;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Start_Time__c = System.now();
        v.End_Time__c = System.now()+7;
        v.Visit_Type__c = 'visit';
        v.Visit_Status__c = 'Planned';
        v.Assigned_to__c = UserInfo.getUserId();
        insert v;

    }
    @IsTest
    static void UnitTest01(){
        Test.StartTest();
        Date StartDate = date.today();
        Date EndDate = StartDate.addDays(7);
        List<Account> accList = [SELECT Id, Hoya_Account_ID__c, Name FROM Account WHERE Hoya_Account_ID__c = 'TE123456'];
        List<Id> AccountId = new List<Id>();
        for(Account a : accList){
            AccountId.add(a.Id);
        }

        List<Visits__c> vList = [SELECT Id, Name, Account__c FROM Visits__c WHERE Account__c IN:AccountId];
        VPMPlannedVisitsMapController.getVisitPlanning(StartDate, EndDate);
        VPMPlannedVisitsMapController.getMedicalVisitsPlanning(StartDate, EndDate);
        Test.StopTest();
    }
}