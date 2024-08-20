/**
 * @Subject : Campaign Overview Map
 * @DevOpsURL : https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1350/
 * @Author : Surawat Sakulmontreechai
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Description : This apex TEST CLASS to support : Task-1350 Campaign Overview map | TEST support VPMCampaignOverviewMapController
 * @CreatedDate : 2024-04-23
 * @CreatedBy : Surawat Sakulmontreechai
 * @Code coverage : 93%
 */
@IsTest
public with sharing class VPMCampaignOverviewMapController_Test {
    @TestSetup
    static void makeData(){

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE0123456';
        a.Name = 'This is a test';
        a.ShippingStreet = '10/667 Test Street';
        a.ShippingCity = 'Bangkok';
        a.ShippingState = 'Bangkok';
        a.ShippingLatitude = 13.736717;
        a.ShippingLongitude = 100.523186;
        a.ShippingPostalCode = '11001';
        insert a;

        Campaign c = new Campaign();
        c.Name = 'This is a test campaign';
        c.IsActive = true;
        c.StartDate = System.today();
        c.EndDate = System.today()+120;
        c.Status = 'In progress';
        insert c;

        Account_Campaing_Member__c ac = new Account_Campaing_Member__c();
        ac.Central_Campaign__c = c.Id;
        ac.Account_Name__c = a.Id;
        ac.Campaign_Presented__c = true;
        insert ac;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Start_Time__c = System.now();
        v.End_Time__c = System.now().addDays(7);
        v.Visit_Status__c = 'Planned';
        v.Visit_Type__c = 'Visit';
        v.Assigned_to__c = UserInfo.getUserId();
        insert v;
        
    }

    @IsTest
    static void UnitTest01(){

        Test.StartTest();
        List<Account> accList = [SELECT Id, Hoya_Account_ID__c, Name FROM Account WHERE Hoya_Account_ID__c='TE0123456'];
        List<Campaign> campaignList = [SELECT Id, Name FROM Campaign WHERE Name = 'This is a test campaign'];

        List<Id> IdsCampaign = new List<Id>();
        List<Id> IdsAcc = new List<Id>();

        for(Account a : accList){
            IdsAcc.add(a.Id);
        }

        for(Campaign c : campaignList){
            IdsCampaign.add(c.Id);
        }

        List<Account_Campaing_Member__c> acMemberList = [SELECT Id, Name, Account_Name__c, Campaign_Presented__c, Central_Campaign__c 
                                                            FROM Account_Campaing_Member__c WHERE Central_Campaign__c IN:IdsCampaign];
        List<Visits__c> visit = [SELECT Id, Account__c, Start_Time__c, End_Time__c, Visit_Status__c, Visit_Type__c
                                    FROM Visits__c WHERE Account__c IN:IdsAcc];
        String campaignId = [SELECT Id FROM Campaign WHERE Name = 'This is a test campaign'].Id;
        VPMCampaignOverviewMapController.getAccountCampaignMember(campaignId);
        VPMCampaignOverviewMapController.getCampaignList();
        Test.StopTest();

    }
}