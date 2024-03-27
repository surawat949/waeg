@isTest
public class TabVisitsReportsControllerTest {
    
    public TabVisitsReportsControllerTest() {
        
    }
    
    @TestSetup
    static void makeData(){
        Account hvnaAcc = new Account();
        hvnaAcc.Hoya_Account_ID__c = 'TE1234512';
        hvnaAcc.CurrencyIsoCode = 'EUR';
        hvnaAcc.Name = 'HVNA Test';
        insert hvnaAcc;
        
        Account seiko = new Account();
        seiko.Hoya_Account_ID__c = 'SO1234512';
        seiko.CurrencyIsoCode = 'EUR';
        seiko.Name = 'SEIKO1 Test';
        insert seiko;
        
        Contact Con = new Contact();
        con.LastName = 'last';
        con.firstName = 'first';
        con.accountId = hvnaAcc.Id;
        con.ownerId=userInfo.getUserId();
        insert con;       
        
        Visits__c visit11 = new Visits__c();
        visit11.Account__c = hvnaAcc.Id;
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
        insert visit11;
        
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = hvnaAcc.Id;
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
        insert visit2;
        
        Visits__c visit12 = new Visits__c();
        visit12.Account__c = hvnaAcc.Id;
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
        insert visit12;
        
        Visits__c visit13 = new Visits__c();
        visit13.Account__c = hvnaAcc.Id;
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
        insert visit13;  
        
        Task task = new Task();
        task.WhatId = hvnaAcc.Id;
        task.ActivityDate = date.today();
        task.Subject = 'Anruf';
        task.Visit_Task_ID__c = visit11.Id;
        insert task;
    }
    
    @isTest
    static void visitTest(){
        Test.StartTest();
        Account a=[Select Id from account Limit 1];
        TabVisitsReportsController.getReportVisits(a.Id);
        TabVisitsReportsController.getTaskRecord(a.Id);
        TabVisitsReportsController.getVisitCompleted(a.Id);
        Test.StopTest();       
    }
    
}