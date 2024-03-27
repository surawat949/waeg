@isTest
public class TabVisitsControllerTest {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Shop_Country__c = 'FR'
        );
        insert acc;
        
        Contact Con = new Contact();
        con.LastName = 'last';
        con.firstName = 'first';
        con.accountId = acc.Id;
        con.ownerId=userInfo.getUserId();
        insert con;
        List<Visits__c> visitsData = new List<Visits__c>();
        Visits__c visit11 = new Visits__c();
        visit11.Account__c = acc.Id;
        visit11.Visit_Type__c = 'Visit';
        visit11.HVNA_Visit_Type__c = 'Shop Visit';
        visit11.CurrencyIsoCode = 'EUR';
        visit11.Visit_Status__c = 'Complete';
        visit11.End_Time__c = date.today() - 7;
        visit11.Start_Time__c = date.today()-9;
        visit11.Assigned_to__c = UserInfo.getUserId();
        visit11.Visitfreqchk_c__c = '1';
        visit11.contact__c = con.Id;
        visit11.MKT_No_campaign_presented__c=true;
        visitsData.add(visit11);
        
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.HVNA_Visit_Type__c = 'Shop Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Visit_Status__c = 'Planned';
        visit2.End_Time__c = date.today() + 7;
        visit2.Start_Time__c = date.today() + 1;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visitfreqchk_c__c = '1';
        visit2.contact__c = con.Id;
        visit2.MKT_No_campaign_presented__c=true;
        visitsData.add(visit2);
        
        Visits__c visit12 = new Visits__c();
        visit12.Account__c = acc.Id;
        visit12.Visit_Type__c = 'Visit';
        visit12.HVNA_Visit_Type__c = 'Shop Visit';
        visit12.CurrencyIsoCode = 'EUR';
        visit12.Visit_Status__c = 'Complete';
        visit12.End_Time__c = date.today() - 7;
        visit12.Start_Time__c = date.today()-9;
        visit12.Assigned_to__c = UserInfo.getUserId();
        visit12.Visitfreqchk_c__c = '1';
        visit12.contact__c = con.Id;
        visit12.MKT_No_campaign_presented__c=true;
        visitsData.add(visit12);
        
        Visits__c visit13 = new Visits__c();
        visit13.Account__c = acc.Id;
        visit13.Visit_Type__c = 'Digital Visit';
        visit13.HVNA_Visit_Type__c = 'Shop Visit';
        visit13.CurrencyIsoCode = 'EUR';
        visit13.Visit_Status__c = 'Complete';
        visit13.End_Time__c = date.today() - 7;
        visit13.Start_Time__c = date.today()-9;
        visit13.Assigned_to__c = UserInfo.getUserId();
        visit13.Visitfreqchk_c__c = '1';
        visit13.contact__c = con.Id;
        visit13.MKT_No_campaign_presented__c =true;
        visitsData.add(visit13); 
        insert visitsData;
        
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Subject = 'Anruf';
        task.Visit_Task_ID__c = visit11.Id;
        insert task;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'TestCampaign';
        campaign.CurrencyIsoCode = 'EUR';
        campaign.Button_Name__c = 'test';
        campaign.Campaign_Description__c = 'Test Campaign Description';
        campaign.company_code__c='EMEA';
        insert Campaign;
        /*
        Account_Campaing_Member__c acm = new Account_Campaing_Member__c();
        acm.Account_Name__c = acc.Id;
        acm.Central_Campaign__c = campaign.Id;
        insert acm;
        */
        String oppRecId = Schema.SobjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();
        Opportunity o = new Opportunity();
        o.Name = 'Hunting-HVNA';
        o.StageName = '1-Initial Contact';
        o.RecordTypeId = oppRecId;
        o.currencyIsoCode = 'USD';
        o.AccountId = acc.Id;
        o.CloseDate = System.today()+10;
        insert o;
        
        Account acc1 = new Account();
        acc1.Name='TesVl123';
        acc1.Hoya_Account_Id__c = 'SO0v1234';
        acc1.currencyIsoCode='EUR';
        acc1.Zonal__c = 'Sub-area 1';
        acc1.TACTICOM_SOF__c = 'Sub-area 1';
        acc1.Agreed_Visits__c= 44;
        acc1.Agreed_No_of_Digital_Visits__c=24;
        insert acc1;
        
        Account acc3 = new Account(
            Name = 'Account 3',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Hoya_account_Id__c = 'SO0033TESTACC3',
            Strategic_Value_Net_Sales__c =576
        );
        insert acc3;
        
        Last_Sales_Statistics__c stats =  new Last_Sales_Statistics__c();
        stats.Account__c = acc3.Id;
        stats.Lenses_Net_Sales_Last_12Mo__c = 130;
        insert stats;

        Account acc4 = new Account(
            Name = 'Account 4',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Hoya_account_Id__c = 'SO0033TESTACC4',
            ParentId = acc3.Id,
            Strategic_Value_Net_Sales__c =560
        );
        insert acc4;
        
        Last_Sales_Statistics__c stats2 =  new Last_Sales_Statistics__c();
        stats2.Account__c = acc4.Id;
        stats2.Lenses_Net_Sales_Last_12Mo__c = 120;
        insert stats2;
        
    }
    
    @isTest
    static void tabVisitTest(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId from Account LIMIT 1];

        TabVisitsController.recommendedAccountsByZone(acc.ownerId);
        TabVisitsController.getAccountsByZone(acc.ownerId);
        TabVisitsController.TacticomDetails(acc.Id);
        TabVisitsController.Aggregate(acc.Id);
        
        
        Account acc1=[Select Id,Name,ownerId from Account where Hoya_Account_Id__c='SO0v1234' LIMIT 1];
        TabVisitsController.TacticomDetails(acc1.Id);
        TabVisitsController.recommendedAccountsByZone(acc1.ownerId);

        Account acc2=[Select Id,Name,ownerId from Account where Hoya_Account_Id__c='SO0033TESTACC3' LIMIT 1];
        TabVisitsController.TacticomDetails(acc2.Id);
        TabVisitsController.recommendedAccountsByZone(acc2.ownerId);
        TabVisitsController.Aggregate(acc2.Id);
        
        Test.stopTest();
    }      
}