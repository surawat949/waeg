/*
    ==========================================
    Testing class for APACUserPerformanceController APEX Class
    Created date : 2022-06-07
    Created by : Surawat Sakulmontreechai
    ==========================================
*/
@IsTest
public with sharing class APACUserPerformanceController_Test {
    public APACUserPerformanceController_Test() {

    }

    @TestSetup
    static void makeData(){
        
        Integer month = date.today().month();
        Integer year = date.today().year();

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testini@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE-001';
        a.Name = 'TEST01';
        a.OwnerId = u.Id;
        a.CurrencyIsoCode = 'EUR';
        a.ShippingStreet = 'Bangkok Street 123';
        a.ShippingState = 'Bangkok';
        a.ShippingCity = 'Bangkok';
        a.ShippingPostalcode = '11112';
        a.ShippingCountry = 'Thailand';
        a.Potential__c = 1000000;
        a.Zonal__c = 'Sub-area 1';
        insert a;

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TE-002';
        a1.Name = 'TEST02';
        a1.OwnerId = u.Id;
        a1.CurrencyIsoCode = 'EUR';
        a1.ShippingStreet = 'Bangkok Street 123';
        a1.ShippingState = 'Bangkok';
        a1.ShippingCity = 'Bangkok';
        a1.ShippingPostalcode = '11112';
        a1.ShippingCountry = 'Thailand';
        insert a1;

        Visits__c v1 = new Visits__c();
        v1.Assigned_to__c = u.Id;
        v1.Account__c = a.Id;
        v1.Visit_Reason__c = 'Acquisition';
        v1.Visit_Reason_APAC__c = 'Acquisition';
        v1.Visit_Status__c = 'Planned';
        v1.Trainer__c = 'SURTEST';
        DateTime StartTime = DateTime.newInstance(2022, 4, 1, 8, 0, 0);
        DateTime EndTime = DateTime.newInstance(2022, 4, 1, 9, 0, 0);
        v1.Start_Time__c = StartTime;
        v1.End_Time__c = EndTime;
        insert v1;

        Visits__c v2 = new Visits__c();
        v2.Assigned_to__c = u.Id;
        v2.Account__c = a.Id;
        v2.Visit_Reason__c = 'Acquisition';
        v2.Visit_Reason_APAC__c = 'Acquisition';
        v2.Visit_Status__c = 'Complete';
        v2.Trainer__c = 'SURTEST2';
        v2.Start_Time__c = System.now().addHours(-720);
        v2.End_Time__c = System.now().addHours(-710);
        insert v2;

        Visits__c v3 = new Visits__c();
        v3.Assigned_to__c = u.Id;
        v3.Account__c = a.Id;
        v3.Visit_Reason__c = 'Acquisition';
        v3.Visit_Reason_APAC__c = 'Acquisition';
        v3.Visit_Status__c = 'Planned';
        v3.Start_Time__c = System.now().addHours(+720);
        v3.End_Time__c = System.now().addHours(+721);
        insert v3;
        
        Visit_Task_APAC__c vTask = new Visit_Task_APAC__c();
        vTask.Account__c = a.Id;
        vTask.Call_to_action_notes__c = 'test';
        DateTime dt1 = DateTime.newInstance(2023, 4, 1, 8, 0, 0);
        vTask.Checked_Location_Time__c = dt1;
        vTask.CurrencyIsoCode = 'EUR';
        vTask.Description__c = 'SURTEST';
        vTask.OwnerId = u.Id;
        vTask.Shop_City__c = 'Bangkok';
        vTask.Shop_Country__c = 'Thailand';
        vTask.Shop_State__c = 'Bangkok';
        vTask.Shop_Street__c = 'Phayathai Street, Rajathavee Road';
        vTask.Shop_Postal_Code__c = '11110';
        vTask.Shop_Phone__c = '022221111';
        vTask.Start_Location_Lattitude__c = 13.7365808;
        vTask.Start_Location_Longitude__c = 100.5622692;
        vTask.Visit__c = v1.Id;
        vTask.Visit_Notes__c = 'test';
        vTask.Visit_Reason__c = 'Acquisition';
        vTask.Visit_Reason_Global__c = 'Acquisition';
        vTask.Visit_Start_Type__c = 'SHOP';
        vTask.Visit_Status__c = 'Planned';
        vTask.Visit_Type__c = 'Visit';
        insert vTask;

        Campaign c = new Campaign();
        c.Name = 'TEST-Campaign';
        c.StartDate = System.today();
        c.EndDate = System.today()+30;
        c.CurrencyIsoCode = 'EUR';
        c.OwnerId = u.Id;
        c.CurrencyIsoCode = 'EUR';
        c.IsActive = true;
        insert c;

        Account_Campaing_Member__c cc = new Account_Campaing_Member__c();
        cc.Account_Name__c = a.Id;
        cc.Central_Campaign__c = c.Id;
        cc.Campaign_Start_Date_t__c = c.StartDate;
        cc.Campaign_End_Date_t__c = c.EndDate;
        cc.Target__c = true;
        cc.Campaign_Presented__c = false;
        insert cc;

        Account_Campaing_Member__c cam = new Account_Campaing_Member__c();
        cam.Account_Name__c = a1.Id;
        cam.Central_Campaign__c = c.Id;
        cam.Campaign_Start_Date_t__c = c.StartDate;
        cam.Campaign_End_Date_t__c = c.EndDate;
        cam.Target__c = false;
        insert cam;

        if((month < 5 && !Toolbox.isApac(u.CompanyName)) || (month<4 && Toolbox.isApac(u.CompanyName))){
            year = year-1;
        }

        String CurrFY = 'FY-'+String.valueOf(year).substring(2);
        String PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
        String N2FY = 'FY-'+String.valueOf(year-2).substring(2);

        QV_Sales__c qv = new QV_Sales__c();
        qv.FY__c = CurrFY;
        qv.Account__c = a.Id;
        qv.Generic_Design__c = 'SV';
        qv.Lensdesign__c = 'NE17VS-H';
        qv.April__c = 100; qv.April_qty__c = 1;
        qv.May__c = 100; qv.May_qty__c= 1;
        qv.June__c = 100; qv.June_qty__c = 1;
        qv.July__c = 100; qv.July_qty__c = 1;
        qv.August__c = 100; qv.August_qty__c = 1;
        qv.September__c = 100; qv.September_qty__c = 1;
        qv.October__c = 100; qv.October_qty__c = 1;
        qv.November__c = 100; qv.November_qty__c = 1;
        qv.December__c = 100; qv.December_qty__c = 1;
        qv.January__c = 100; qv.January_qty__c = 1;
        qv.February__c = 100; qv.February_qty__c = 1;
        qv.March__c = 100; qv.March_qty__c = 1;
        qv.RX_or_Stock__c = 'RX';
        qv.CurrencyIsoCode = 'AUD';
        qv.HOYA_Account_ID__c = a.HOYA_Account_ID__c;
        qv.External_Key__c = a.HOYA_Account_ID__c+CurrFY+'-'+'NE17VS-H';
        insert qv;

        QV_Sales__c qly = new QV_Sales__c();
        qly.FY__c = PrevFY;
        qly.Account__c = a.Id;
        qly.Generic_Design__c = 'PAL';
        qly.Lensdesign__c = 'MYSTYLE';
        qly.April__c = 100; qly.April_qty__c = 1;
        qly.May__c = 100; qly.May_qty__c= 1;
        qly.June__c = 100; qly.June_qty__c = 1;
        qly.July__c = 100; qly.July_qty__c = 1;
        qly.August__c = 100; qly.August_qty__c = 1;
        qly.September__c = 100; qly.September_qty__c = 1;
        qly.October__c = 100; qly.October_qty__c = 1;
        qly.November__c = 100; qly.November_qty__c = 1;
        qly.December__c = 100; qly.December_qty__c = 1;
        qly.January__c = 100; qly.January_qty__c = 1;
        qly.February__c = 100; qly.February_qty__c = 1;
        qly.March__c = 100; qly.March_qty__c = 1;
        qly.RX_or_Stock__c = 'RX';
        qly.currencyIsoCode = 'AUD';
        qly.HOYA_Account_ID__c = a.HOYA_Account_ID__c;
        qly.External_Key__c = a.HOYA_Account_ID__c+PrevFY+'-'+'MYSTYLE';
        insert qly;

        QV_Sales__c qn2 = new QV_Sales__c();
        qn2.FY__c = N2FY;
        qn2.Account__c = a.Id;
        qn2.Generic_Design__c = 'BF';
        qn2.Lensdesign__c = 'PFT28-70';
        qn2.january__c = 100; qn2.January_qty__c = 10;
        qn2.february__c = 100; qn2.February_qty__c = 10;
        qn2.march__c = 100; qn2.March_qty__c = 10;
        qn2.CurrencyIsoCode = 'AUD';
        qn2.RX_or_Stock__c = 'ST';
        qn2.hoya_Account_Id__c = a.Hoya_Account_ID__c;
        qn2.External_Key__c = a.Hoya_Account_ID__c+N2FY+'RX'+'-'+'PFT28-70';
        insert qn2;

        String HuntingOppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.Name = 'Target List : '+a.Name;
        opp.AccountId = a.Id;
        opp.OwnerId = u.Id;
        opp.RecordTypeId = HuntingOppRecId;
        opp.CurrencyIsoCode = a.CurrencyIsoCode;
        opp.Annual_Expected_Sales__c = a.Potential__c*0.5;
        opp.CloseDate = System.today()+180;
        opp.StageName = '1-Initial Contact';
        opp.Amount = 1000;
        opp.NextStep = 'Test';
        opp.Description = 'test1';
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        insert oppList;
        
    }

    @IsTest
    static void TestMultipleClass(){

        Account acc = [select Id, Hoya_Account_ID__c, Name, OwnerId, CurrencyIsoCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalcode from Account where Hoya_Account_ID__c = 'TE-001' limit 1];
        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];
        Visit_Task_APAC__c vTask = [select Id from Visit_Task_APAC__c where Description__c = 'SURTEST' limit 1];
        Campaign c = [select Id, Name from Campaign where Name = 'TEST-Campaign'];
        Date dt1 = Date.newInstance(2022, 4, 1);

        Test.StartTest();
        APACUserPerformanceController.getVisitDataList(u.Id, dt1, 'Planned');
        APACUserPerformanceController.getActiveTargetCampaign(u.Id);
        APACUserPerformanceController.initTotalVisits(u.Id);
        //APACUserPerformanceController.getLensDesignByOwner(u.Id);
        APACUserPerformanceController.getRxStockbyOwnerId(u.Id);
        //APACUserPerformanceController.getTopCustomerByOwner(u.Id);
        APACUserPerformanceController.getNewSegmentation(u.Id);
        APACUserPerformanceController.getNewSubArea(u.Id);
        APACUserPerformanceController.getTopTenCustomer(u.Id);
        List<APACUserPerformanceController.StockRx> newList = new List<APACUserPerformanceController.StockRx>();
        //APACUserPerformanceController.getDataSegmentationOwnerId(u.Id);
        //APACUserPerformanceController.getSubAreaSalesByOwnerId(u.Id);
        APACUserPerformanceController.getActiveAccCampaign(u.Id);
        APACUserPerformanceController.getCampaignNotPresented(u.Id);
        APACUserPerformanceController.DataSet dataset = new APACUserPerformanceController.DataSet('1-Initial Contact', 1);
        APACUserPerformanceController.getOppStageByLast3Month(u.Id);
        APACUserPerformanceController.getVisitZone(u.Id);
        APACUserPerformanceController.getPlannedVisit(u.Id);
        APACUserPerformanceController.getOpportunityInfo(u.Id);
        APACUserPerformanceController.getAccCampaignMember(u.Id, c.Id);
        APACUserPerformanceController.DataSetCampaignName cmpName = new APACUserPerformanceController.DataSetCampaignName('test campaign');
        Test.StopTest();

    }

    @isTest
    static void testOtherClass(){
        Account acc = [select Id, Hoya_Account_ID__c, Name, OwnerId, CurrencyIsoCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalcode from Account where Hoya_Account_ID__c = 'TE-001' limit 1];
        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];

        Test.StartTest();
        APACUserPerformanceController.getDataSetCampaignName(u.Id);
        APACUserPerformanceController.getDataSetStartDate(u.Id, 'LAST_N_DAYS:7', 'Planned');
        APACUserPerformanceController.getDataSetStartDate(u.Id, 'LAST_N_DAYS:30', 'Planned');
        APACUserPerformanceController.getDataSetStartDate(u.Id, 'LAST_N_DAYS:1', 'Complete');
        APACUserPerformanceController.GetPickListValuesForDesc('Opportunity', 'StageName');
        APACUserPerformanceController.getVisitPicklistValues();
        APACUserPerformanceController.getAccountCompetitorGlobalName();
        APACUserPerformanceController.getCampaignListByUser(u.Id);
        APACUserPerformanceController.getUserIdConversionRate(u.Id);
        Test.StopTest();
    }

    @isTest
    static void testOtherClass2(){

        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];
        Test.StartTest();
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'APR', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'MAY', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'JUN', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'JUL', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'AUG', 500);
        Test.StopTest();
    }

    @isTest
    static void testOtherClass3(){
        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];
        Test.StartTest();
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'SEP', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'OCT', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'NOV', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'DEC', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'JAN', 500);
        Test.StopTest();
    }

    @isTest
    static void testOtherClass4(){
        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];
        Test.StartTest();
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'FEB', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'MAR', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'ANNUAL', 500);
        APACUserPerformanceController.getAccountActiveCounting(u.Id, '2022', 'April', 500);
        
        Test.StopTest();
    }

    @isTest
    static void runTestVisited(){

        Integer month = System.today().month();

        User u = [select Id, FirstName, LastName, CompanyName from User where username='testini@hoya.com.pcpy' limit 1];
        Visits__c v = [select id from Visits__c where Trainer__c='SURTEST2' limit 1];

        Test.StartTest();
        APACUserPerformanceController.TotalVisited visited = APACUserPerformanceController.getTotalVisited(u.Id);
        APACUserPerformanceController.getLast2MthLabel(month);
        APACUserPerformanceController.getLast1MthLabel(month);
        APACUserPerformanceController.getLastMthLabel(month);
        APACUserPerformanceController.getLast2MthLabel(6);
        APACUserPerformanceController.getLast2MthLabel(7);
        APACUserPerformanceController.getLast2MthLabel(8);
        APACUserPerformanceController.getLast2MthLabel(9);
        APACUserPerformanceController.getLast2MthLabel(10);
        APACUserPerformanceController.getLast2MthLabel(11);
        APACUserPerformanceController.getLast2MthLabel(12);

        APACUserPerformanceController.getLast1MthLabel(6);
        APACUserPerformanceController.getLast1MthLabel(7);
        APACUserPerformanceController.getLast1MthLabel(8);
        APACUserPerformanceController.getLast1MthLabel(9);
        APACUserPerformanceController.getLast1MthLabel(10);
        APACUserPerformanceController.getLast1MthLabel(11);
        APACUserPerformanceController.getLast1MthLabel(12);

        APACUserPerformanceController.getLastMthLabel(6);
        APACUserPerformanceController.getLastMthLabel(7);
        APACUserPerformanceController.getLastMthLabel(8);
        APACUserPerformanceController.getLastMthLabel(9);
        APACUserPerformanceController.getLastMthLabel(10);
        APACUserPerformanceController.getLastMthLabel(11);
        APACUserPerformanceController.getLastMthLabel(12);

        APACUserPerformanceController.getLast2MthVisited(visited, month);
        APACUserPerformanceController.getLast1MthVisited(visited, month);
        APACUserPerformanceController.getLastMthVisited(visited, month);
        APACUserPerformanceController.getTotalVisited(u.Id);
        Test.StopTest();
    }

    @isTest
    static void runTestActiveDoorSales(){

        Integer month = date.today().month();
        Integer year = date.today().year();

        Account a = [select Id, Hoya_Account_ID__c from Account where hoya_Account_Id__c = 'TE-001' limit 1];
        User u = [select Id, CompanyName from User where Username='testini@hoya.com.pcpy' limit 1];
        String userCompany = u.CompanyName;
        if((month < 5 && !Toolbox.isApac(userCompany)) || (month < 4 && Toolbox.isApac(userCompany))){
            year = year-1;
        }

        String CurrFY = 'FY-'+String.valueOf(year).substring(2);
        String PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
        String NextFY = 'FY-'+String.valueOf(year+1).substring(2);

        List<QV_Sales__c> qvList = new List<QV_Sales__c>();
        QV_Sales__c qcy = new QV_Sales__c();
        qcy.FY__c = CurrFY;
        qcy.Account__c = a.Id;
        qcy.Generic_Design__c = 'SV';
        qcy.Lensdesign__c = 'HL16VS-H';
        qcy.April__c = 100; qcy.April_qty__c = 1;
        qcy.May__c = 100; qcy.May_qty__c= 1;
        qcy.June__c = 100; qcy.June_qty__c = 1;
        qcy.July__c = 100; qcy.July_qty__c = 1;
        qcy.August__c = 100; qcy.August_qty__c = 1;
        qcy.September__c = 100; qcy.September_qty__c = 1;
        qcy.October__c = 100; qcy.October_qty__c = 1;
        qcy.November__c = 100; qcy.November_qty__c = 1;
        qcy.December__c = 100; qcy.December_qty__c = 1;
        qcy.January__c = 100; qcy.January_qty__c = 1;
        qcy.February__c = 100; qcy.February_qty__c = 1;
        qcy.March__c = 100; qcy.March_qty__c = 1;
        qcy.RX_or_Stock__c = 'RX';
        qcy.CurrencyIsoCode = 'AUD';
        qcy.HOYA_Account_ID__c = a.HOYA_Account_ID__c;
        qcy.External_Key__c = a.HOYA_Account_ID__c+CurrFY+'-'+'HL16VS-H';
        qvList.add(qcy);
        
        QV_Sales__c qly = new QV_Sales__c();
        qly.FY__c = PrevFY;
        qly.Account__c = a.Id;
        qly.Generic_Design__c = 'PAL';
        qly.Lensdesign__c = 'LSV+';
        qly.April__c = 100; qly.April_qty__c = 1;
        qly.May__c = 100; qly.May_qty__c= 1;
        qly.June__c = 100; qly.June_qty__c = 1;
        qly.July__c = 100; qly.July_qty__c = 1;
        qly.August__c = 100; qly.August_qty__c = 1;
        qly.September__c = 100; qly.September_qty__c = 1;
        qly.October__c = 100; qly.October_qty__c = 1;
        qly.November__c = 100; qly.November_qty__c = 1;
        qly.December__c = 100; qly.December_qty__c = 1;
        qly.January__c = 100; qly.January_qty__c = 1;
        qly.February__c = 100; qly.February_qty__c = 1;
        qly.March__c = 100; qly.March_qty__c = 1;
        qly.RX_or_Stock__c = 'RX';
        qly.CurrencyIsoCode = 'AUD';
        qly.HOYA_Account_ID__c = a.HOYA_Account_ID__c;
        qly.External_Key__c = a.HOYA_Account_ID__c+PrevFY+'-'+'LSV+';
        qvList.add(qly);
        
        insert qvList;
        Test.StartTest();
        APACUserPerformanceController.ActiveDoorSales active = APACUserPerformanceController.getActiveDoorSales(u.Id);
        APACUserPerformanceController.getLast2MthLabel(month);
        APACUserPerformanceController.getLast1MthLabel(month);
        APACUserPerformanceController.getLastMthLabel(month);
        APACUserPerformanceController.getLast2MthAcitveSales(active, month);
        APACUserPerformanceController.getLast1MthActiveSales(active, month);
        APACUserPerformanceController.getLastMthActiveSales(active, month);
        APACUserPerformanceController.getActiveDoorSales(u.Id);
        Test.StopTest();

    }

    @isTest
    static void runTestLevelInterested(){
        User u = [select id, Firstname, LastName, username from User where username='testini@hoya.com.pcpy'];
        Account a = [select id, hoya_account_id__c, name from account where hoya_Account_Id__c ='TE-001' limit 1];
        Account a2 = [select id, hoya_Account_Id__c, name from account where hoya_account_id__c = 'TE-002' limit 1];
        Campaign c = [select Id, Name, StartDate, EndDate from Campaign where Name='TEST-Campaign' limit 1];

        Test.StartTest();
        List<Account_Campaing_Member__c> cmList = new List<Account_Campaing_Member__c>();
        Account_Campaing_Member__c cm = new Account_Campaing_Member__c();
        cm.Account_Name__c = a.Id;
        cm.Central_Campaign__c = c.Id;
        cm.Campaign_Start_Date_t__c = c.StartDate;
        cm.Campaign_End_Date_t__c = c.EndDate;
        cm.Target__c = false;
        cm.level_interest__c = 'Not interested';
        cmList.add(cm);

        Account_Campaing_Member__c cm1 = new Account_Campaing_Member__c();
        cm1.Account_Name__c = a2.Id;
        cm1.Central_Campaign__c = c.Id;
        cm1.Campaign_Start_Date_t__c = c.StartDate;
        cm1.Campaign_End_Date_t__c = c.EndDate;
        cm1.Target__c = false;
        cm1.level_interest__c = 'Partially interested';
        cmList.add(cm1);

        insert cmList;
        APACUserPerformanceController.getCampaignLevelInterested(u.Id);
        Test.StopTest();

    }

    @isTest
    static void runTestLevelInterested2(){
        User u = [select id, Firstname, LastName, username from User where username='testini@hoya.com.pcpy'];
        Account a = [select id, hoya_account_id__c, name from account where hoya_Account_Id__c ='TE-001' limit 1];
        Account a2 = [select id, hoya_Account_Id__c, name from account where hoya_account_id__c = 'TE-002' limit 1];
        Campaign c = [select Id, Name, StartDate, EndDate from Campaign where Name='TEST-Campaign' limit 1];

        Test.StartTest();
        List<Account_Campaing_Member__c> cmList = new List<Account_Campaing_Member__c>();
        Account_Campaing_Member__c cm = new Account_Campaing_Member__c();
        cm.Account_Name__c = a.Id;
        cm.Central_Campaign__c = c.Id;
        cm.Campaign_Start_Date_t__c = c.StartDate;
        cm.Campaign_End_Date_t__c = c.EndDate;
        cm.Target__c = false;
        cm.level_interest__c = 'Interested';
        cmList.add(cm);

        Account_Campaing_Member__c cm1 = new Account_Campaing_Member__c();
        cm1.Account_Name__c = a2.Id;
        cm1.Central_Campaign__c = c.Id;
        cm1.Campaign_Start_Date_t__c = c.StartDate;
        cm1.Campaign_End_Date_t__c = c.EndDate;
        cm1.Target__c = false;
        cm1.level_interest__c = 'Very Interested';
        cmList.add(cm1);

        insert cmList;
        APACUserPerformanceController.getCampaignLevelInterested(u.Id);
        Test.StopTest();

    }

    @isTest
    static void runGetOppColumnData(){
        User u = [select Id, FirstName, LastName from User where Username='testini@hoya.com.pcpy' limit 1];
        List<String> newList = new List<String>{'Name','StageName'};
        List<String> newList2 = new List<String>{'Start_Date_Time__c','Related_Account__c','Segmentation_Box__c','Visit_Reason_APAC__c','Visit_Notes__c','Start_Day__c'};
        Test.StartTest();
        APACUserPerformanceController.getOpportunityDataColumn('Opportunity', newList, u.Id, ' AND IsClosed=false AND AccountId!=null', ' WHERE OwnerId=', ' ORDER BY CloseDate DESC LIMIT 100');
        APACUserPerformanceController.getColumnsAndData('Visits__c', newList2, u.Id, 'LAST_N_DAYS:7', 'Complete');
        Test.StopTest();

    }

    @IsTest
    static void runTestUserComment(){
        User u = [SELECT Id, FirstName, LastName, Email, Username FROM User WHERE Username='testini@hoya.com.pcpy' limit 1];

        User_Comment__c uc = new User_Comment__c();
        uc.Comment_to_user__c = u.Id;
        uc.Comments__c = 'test';
        uc.CurrencyIsoCode = 'EUR';
        uc.OwnerId = u.Id;
        uc.Name = 'This is test';
        uc.Topic_Subject__c = 'Visits';
        uc.Send_Email__c = true;
        uc.Comments__c = 'this is test';
        uc.Topic_Sub_Subject__c = 'Sales process';
        List<User_Comment__c> newList = new List<User_Comment__c>();
        newList.add(uc);
        insert newList;
        Test.StartTest();
        APACUserPerformanceController.getUserCommentId(u.Id);
        APACSendEmailUserComment.SendEmail(newList);
        Test.StopTest();
    }

    @IsTest
    static void TestUserSalesFigured(){
        User u = [SELECT Id, FirstName, LastName, Email, Username FROM User WHERE Username='testini@hoya.com.pcpy' limit 1];
        Test.StartTest();
        APACUserPerformanceController.getUserSalesfigured(u.Id);
        APACUserPerformanceController.getUserQVSalesByTargetList(u.Id);
        Test.StopTest();
    }


    @IsTest
    static void runAPACUserPerformanceController(){
        Test.StartTest();
        User u = new User();
        u.Firstname = 'test';
        u.Lastname = 'testtest';
        u.Username = 'testtest@hoya.com';
        u.Email = 'testtest@hoya.com';
        u.ProfileId = '00eb0000000lainAAA';
        u.Alias = 'STest';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';

        insert u;

        Budget_by_ASM__c b = new Budget_by_ASM__c();
        b.Name = 'Test-Budget-01';
        b.OwnerId = u.Id;
        b.LookupUser__c = u.Id;
        b.Quota1CY__c = 100;
        b.Quota2CY__c = 100;
        b.Quota3CY__c = 100;
        b.Quota4CY__c = 100;
        b.Quota5CY__c = 100;
        b.Quota6CY__c = 100;
        b.Quota7CY__c = 100;
        b.Quota8CY__c = 100;
        b.Quota9CY__c = 100;
        b.Quota10CY__c = 100;
        b.Quota11CY__c = 100;
        b.Quota12CY__c = 100;
        b.Qu1LY__c = 10;
        b.Qu2LY__c = 10;
        b.Qu3LY__c = 10;
        b.Qu4LY__c = 10;
        b.Qu5LY__c = 10;
        b.Qu6LY__c = 10;
        b.Qu7LY__c = 10;
        b.Qu8LY__c = 10;
        b.Qu9LY__c = 10;
        b.Qu10LY__c = 10;
        b.Qu11LY__c = 10;
        b.Qu12LY__c = 10;
        b.LocalSales1CY__c = 10;
        b.LocalSales2CY__c = 10;
        b.LocalSales3CY__c = 10;
        b.LocalSales4CY__c = 10;
        b.LocalSales5CY__c = 10;
        b.LocalSales6CY__c = 10;
        b.LocalSales7CY__c = 10;
        b.LocalSales8CY__c = 10;
        b.LocalSales9CY__c = 10;
        b.LocalSales10CY__c = 10;
        b.LocalSales11CY__c = 10;
        b.LocalSales12CY__c = 10;
        b.LocalSales1LY__c = 10;
        b.LocalSales2LY__c = 10;
        b.LocalSales3LY__c = 10;
        b.LocalSales4LY__c = 10;
        b.LocalSales5LY__c = 10;
        b.LocalSales6LY__c = 10;
        b.LocalSales7LY__c = 10;
        b.LocalSales8LY__c = 10;
        b.LocalSales9LY__c = 10;
        b.LocalSales10LY__c = 10;
        b.LocalSales11LY__c = 10;
        b.LocalSales12LY__c = 10;
        insert b;

        Account a = new Account();
        a.Name = 'Test account';
        a.Hoya_Account_Id__c = '1234567890';
        a.OwnerId = u.Id;
        a.RecordTypeId = '012b00000000P38';
        insert a;

        Account acc = new Account();
        acc.Name = 'Test';
        acc.hoya_account_id__c = '123456';
        acc.OwnerId = u.Id;
        acc.RecordTypeId = '012b00000000P38';
        insert acc;

        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Assigned_to__c = u.Id;
        v.Visit_Status__c = 'Planned';
        v.Visit_Reason__c = 'Acquisition';
        V.Visit_Reason_APAC__c = 'Acquisition';
        v.Start_Time__c = date.today();
        v.End_Time__c = date.today() + 1;
        v.Visit_Notes__c = 'Test';
        insert v;

        String oppRecordTypeId = [select Id from RecordType where sObjectType='Opportunity' and developerName in ('Hunting_Opportunities')].Id;
        Opportunity o = new Opportunity();
        o.Name = 'test zxcv';
        o.RecordTypeId = oppRecordTypeId;
        o.AccountId = a.Id;
        o.OwnerId = u.Id;
        o.StageName ='1.start';
        o.CloseDate = System.today();
        insert o;

        Campaign c = new Campaign();
        c.Name = 'test campaign';
        c.StartDate = System.today();
        c.EndDate = System.today()+30;
        c.CurrencyIsoCode = 'EUR';
        c.IsActive = true;
        insert c;

        Account_Campaing_Member__c cc = new Account_Campaing_Member__c();
        cc.Account_Name__c = a.Id;
        cc.Central_Campaign__c = c.Id;
        cc.Campaign_Start_Date_t__c = c.StartDate;
        cc.Campaign_End_Date_t__c = c.EndDate;
        insert cc;

        Visit_Task_APAC__c VisitTaskAPAC = new Visit_Task_APAC__c();
        VisitTaskAPAC.Account__c = a.Id;
        VisitTaskAPAC.Call_to_action_notes__c = 'test';
        VisitTaskAPAC.OwnerId = v.Assigned_to__c;
        VisitTaskAPAC.Start_Location_Lattitude__c = 13.889055;
        VisitTaskAPAC.Start_Location_Longitude__c = 100.6028625;
        VisitTaskAPAC.Visit__c = v.Id;
        VisitTaskAPAC.Visit_Type__c = 'Visit';
        insert VisitTaskAPAC;

        Integer year = Date.today().year();
        Integer month = Date.today().month();

        //fiscal year is current year-1 from january to march, year from april to december
        if(month<5){
            year = year-1;
        }

        String CurrFY = 'FY-' + String.valueOf(year).substring(2);
        String PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        String n2FY = 'FY-' + String.valueOf(year-2).substring(2);

        String pDesign = 'Lens-X';
        Double pannualSales = 1000;
        Integer pannualQty = 50;

        String pBudName = 'Budget-XX';
        String pLookupName = 'Budget-LookX';

        String pIdVisit = 'a0N3O000002alznUAA';
        String pNameVisit = 'Test-xxx';

        QV_Sales__c qv = new QV_Sales__c();
        qv.FY__c = CurrFY;
        qv.Account__c = a.Id;
        qv.Generic_Design__c = 'SV';
        qv.April__c = 100; qv.April_qty__c = 1;
        qv.May__c = 100; qv.May_qty__c= 1;
        qv.June__c = 100; qv.June_qty__c = 1;
        qv.July__c = 100; qv.July_qty__c = 1;
        qv.August__c = 100; qv.August_qty__c = 1;
        qv.September__c = 100; qv.September_qty__c = 1;
        qv.October__c = 100; qv.October_qty__c = 1;
        qv.November__c = 100; qv.November_qty__c = 1;
        qv.December__c = 100; qv.December_qty__c = 1;
        qv.January__c = 100; qv.January_qty__c = 1;
        qv.February__c = 100; qv.February_qty__c = 1;
        qv.March__c = 100; qv.March_qty__c = 1;
        qv.RX_or_Stock__c = 'RX';
        qv.HOYA_Account_ID__c = a.HOYA_Account_ID__c;
        qv.External_Key__c = a.HOYA_Account_ID__c+'XXXYYY777';
        insert qv;

        QV_Sales__c qvLY = new QV_Sales__c();
        qvLY.FY__c = PrevFY;
        qvLY.Account__c = a.Id;
        qvLY.Generic_Design__c = 'PAL';
        qvLY.April__c = 100; qvLY.April_qty__c = 1;
        qvLY.May__c = 100; qvLY.May_qty__c= 1;
        qvLY.June__c = 100; qvLY.June_qty__c = 1;
        qvLY.July__c = 100; qvLY.July_qty__c = 1;
        qvLY.August__c = 100; qvLY.August_qty__c = 1;
        qvLY.September__c = 100; qvLY.September_qty__c = 1;
        qvLY.October__c = 100; qvLY.October_qty__c = 1;
        qvLY.November__c = 100; qvLY.November_qty__c = 1;
        qvLY.December__c = 100; qvLY.December_qty__c = 1;
        qvLY.January__c = 100; qvLY.January_qty__c = 1;
        qvLY.February__c = 100; qvLY.February_qty__c = 1;
        qvLY.March__c = 100; qvLY.March_qty__c = 1;
        qvLY.RX_or_Stock__c = 'RX';
        qvLY.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvLY.External_Key__c = acc.HOYA_Account_ID__c+'XXXYYY888';
        insert qvLY;
        
        APACUserPerformanceController.initUserSales(u.Id);
        APACUserPerformanceController.getCompanayName(u.Id);
        APACUserPerformanceController.getAccounts(u.Id);
        APACUserPerformanceController.QVData qvd = new APACUserPerformanceController.QVData(pDesign, pannualSales, pannualQty);
        APACUserPerformanceController.BudgetData budget = new APACUserPerformanceController.BudgetData(pBudName, pLookUpName);
        APACUserPerformanceController.VisitData visitdata = new APACUserPerformanceController.VisitData(pIdVisit, pNameVisit);
        APACUserPerformanceController.AccountUser sales = APACUserPerformanceController.initUserSales(u.Id);
        APACUserPerformanceController.DataSet dataset = new APACUserPerformanceController.DataSet('Balansis', 5);
        //APACUserPerformanceController.getVisitNote(v.Id);
        /*
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 1);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 2);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 3);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 4);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 5);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 6);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 7);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 8);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 9);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 10);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 11);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 12);
        APACUserPerformanceController.getUserBudgetLastMonth(sales, 0);
        */
        //APACUserPerformanceController.getAccCampaignMember(u.Id);

        Test.StopTest();
    }

    @IsTest
    static void TestRunningUserFicalYear(){

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testtest2@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;

        Integer year = Date.today().year();
        Integer month = Date.today().month();

        //fiscal year is current year-1 from january to march, year from april to december
        if(month<5){
            year = year-1;
        }

        String CurrFY = 'FY-' + String.valueOf(year).substring(2);
        String PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        String NextFY = 'FY-' + String.valueOf(year+1).substring(2);

        APACUserPerformanceController.FisCalYear fiscal = APACUserPerformanceController.getFiscalYear();
        System.runAs(u){
            Test.StartTest();
            APACUserPerformanceController.getFiscalYear();
            fiscal.CurrFY = CurrFY;
            fiscal.LastFY = PrevFY;
            Test.StopTest();
        }

    }

    /*
    @IsTest
    static void TestVisitTaskAPAC(){
        Test.StartTest();

        User u4 = new User();
        u4.Firstname = 'test4';
        u4.Lastname = 'testtest4';
        u4.Username = 'testtest4@hoya.com.pcpy';
        u4.Email = 'testtest4@hoya.com';
        u4.ProfileId = '00eb0000000lainAAA';
        u4.Alias = 'STest4';
        u4.TimeZoneSidKey = 'Asia/Bangkok';
        u4.LocaleSidKey = 'en_US';
        u4.EmailEncodingKey = 'UTF-8';
        u4.LanguageLocaleKey = 'en_US';

        insert u4;

        Account a4 = new Account();
        a4.Name = 'Test account2';
        a4.Hoya_Account_Id__c = '123456789011';
        a4.OwnerId = u4.Id;
        a4.RecordTypeId = '012b00000000P38';
        insert a4;

        Visits__c v3 = new Visits__c();
        v3.Account__c = a4.Id;
        v3.Assigned_to__c = u4.Id;
        v3.Visit_Status__c = 'Complete';
        v3.Visit_Reason__c = 'Acquisition';
        V3.Visit_Reason_APAC__c = 'Acquisition';
        v3.Start_Time__c = date.today()-1;
        v3.End_Time__c = date.today()-1;
        v3.Visit_Notes__c = 'Test';
        insert v3;

        Visit_Task_APAC__c vapac = new Visit_Task_APAC__c();
        vapac.Account__c = a4.Id;
        vapac.Visit__c = v3.Id;
        vapac.Checked_Location_Time__c = date.today();
        vapac.Start_Location_Lattitude__c = 13.889055;
        vapac.Start_Location_Longitude__c = 100.6028625;
        vapac.OwnerId = u4.Id;
        insert vapac;

        APACUserPerformanceController.getVisitCheckedIn(u4.Id, 7, 'C3', 'Visit', 'Essilor');
        Test.StopTest();

    }*/
}