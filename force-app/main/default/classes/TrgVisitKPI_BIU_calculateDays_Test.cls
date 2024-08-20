/**
 *  This test class is for trigger VisitKPI_BIU_calculateDays.
 *
 @author Yuda Zheng
 @created 2014-05-20
 @version 1.0
 @since 29.0 
 *
 @changelog
 * 2014-05-20 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 * - Test coverage 77%
 * 
 * - 2023-11-15 Surawat Sakulmontreechai <surawat.sakulmontreechai@hoya.com>
 * - Updated
 * - Code coverage 79%
 */
@isTest
private class TrgVisitKPI_BIU_calculateDays_Test {
    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User u = new User();
        u.Firstname = 'Testdata';
        u.Lastname = 'Datatest';
        u.Username = 'data@hoya.com.invalid';
        u.Email = 'data@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'data2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'THAI';
        u.Country__c = 'Thailand';
        u.Sales_District_Area__c = 'Region-1';
        u.Sales_Role__c = 'ASM';
        u.IsActive = true;
        u.Visit_Counter__c = true;
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE-001';
        a.Name = 'Test';
        a.ownerId = u.Id;
        insert a;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Start_Time__c = System.today()-1;
        v.End_Time__c = System.today()-1;
        v.Visit_Status__c = 'Complete';
        v.Assigned_to__c = u.Id;
        insert v;
        
        Time_off_Territory__c timeOff = new Time_off_Territory__c();
        timeOff.Name = 'Test time-off';
        timeOff.Country__c = 'Thailand';
        timeOff.Days_Off__c = 4;
        timeOff.Sales_District_Area__c = 'Region-1';
        timeOff.Month__c = 'November';
        timeOff.ownerId = u.Id;
        timeOff.Year__c = '2021';
        insert timeOff;

    }

    @isTest
    static void UnitTest1(){
        Map<Id,VISIT_KPI__c> mapOfUserIdKpiRecords=new Map<Id,VISIT_KPI__c>();
        User u = [select Id, Username from User where username='data@hoya.com.invalid' limit 1];
        Account acc = [SELECT Id, Name, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c='TE-001' limit 1];
        Visits__c visit = [SELECT Id, Account__c from Visits__c WHERE Account__c =:acc.Id];
        Time_off_Territory__c timesOff = [SELECT Id FROM Time_off_Territory__c WHERE Name ='Test time-off' limit 1];
        
        VISIT_KPI__c visitKPI = new VISIT_KPI__c();
        visitKPI.Area_Sales_Manager__c = u.Id;
        visitKPI.Date__c = System.today();

        Test.StartTest();
        insert visitKPI;
        
        visitKPI.Date__c = System.today().addMonths(-3);
        update visitKPI;
        
        visitKPI.Date__c = System.today().addMonths(-6);
        update visitKPI;
        
        visitKPI.Date__c = System.today().addMonths(-12);
        update visitKPI;
      
        VISIT_KPI__c vi = [SELECT Id,Area_Sales_Manager__c,Digital_Visits_completed__c,Visits_completed__c,Individual_Digital_Days_in_Field__c,Individual_Days_in_Field__c,Sum_of_Visits_Days_in_Field__c FROM VISIT_KPI__c WHERE Area_Sales_Manager__c=:u.Id LIMIT 1];
        mapOfUserIdKpiRecords.put(vi.Area_Sales_Manager__c,vi);
        VisitKPILastMonthCalculation.calculateAndStoreKPI(mapOfUserIdKpiRecords,true,false,null);

        Test.StopTest();
    }
}