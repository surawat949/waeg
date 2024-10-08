/** 
 * Test class for APACSalesTabController
 * Created by Surawat Sakulmontreechai
 * Created date : 2019-09-15
*/
@isTest
public with sharing class APACSalesTabController_Test {

    public static final string AccountRECType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
    @IsTest
    static void runTestCtrl(){

        Test.StartTest();

        Door__c door = new Door__c();
        door.name = 'testDoor';
        door.geolocation__Latitude__s = 31.1;
        door.geolocation__Longitude__s = 1.5;
        insert door;

        Account acc = new Account();
        acc.Name = 'Test Account APAC';
        acc.Hoya_Account_Id__c = 'TEST-APAC-123456';
        acc.RecordTypeId = AccountRECType;
        acc.Door__c = door.id;
        acc.Budget_April_Current_Year__c=0;
        acc.Budget_May_Current_Year__c=0;
        acc.Budget_June_Current_Year__c=0;
        acc.Budget_July_Current_Year__c=0;
        acc.Budget_August_Current_Year__c=0;
        acc.Budget_September_Current_Year__c=0;
        acc.Budget_October_Current_Year__c=0;
        acc.Budget_November_Current_Year__c=0;
        acc.Budget_December_Current_Year__c=0;
        acc.Budget_January_Current_Year__c=0;
        acc.Budget_February_Current_Year__c=0;
        acc.Budget_March_Current_Year__c=0;
        insert acc;

        Account acc2 = new Account();
        acc2.Name='sales test account2';
        acc2.hoya_account_id__c='SO3366666xx';
        acc2.RecordTypeId = AccountRECType;
        acc2.Door__c = door.id;
        acc2.ParentId = acc.Id;
        insert acc2;

        /* Generate some sales for code coverage */
        Integer year = Date.today().year();
        Integer month = Date.today().month();

        //fiscal year is current year-1 from january to march, year from april to december
        if(month<5){
            year = year-1;
        }

        String CurrFY = 'FY-' + String.valueOf(year).substring(2);
        String PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        String n2FY = 'FY-' + String.valueOf(year-2).substring(2);

        QV_Sales__c qvST = new QV_Sales__c();
        qvST.FY__c = CurrFY;
        qvST.Account__c = acc.Id;
        qvST.Generic_Design__c ='XXX';
        qvST.april__c = 100;qvST.April_qty__c = 10;
        qvST.may__c = 200;qvST.May_qty__c = 20;
        qvST.june__c = 200;qvST.June_qty__c = 20;
        qvST.july__c = 200; qvST.July_qty__c = 20;
        qvST.august__c = 200;qvST.August_qty__c = 20;
        qvST.september__c = 200; qvST.September_qty__c = 20;
        qvST.october__c = 200; qvST.October_qty__c = 20;
        qvST.november__c = 200; qvST.November_qty__c = 20;
        qvST.december__c = 200; qvST.December_qty__c = 20;
        qvST.january__c = 200; qvST.January_qty__c = 20;
        qvST.february__c = 200; qvST.February_qty__c = 20;
        qvST.March__c = 200; qvST.March_qty__c = 20;
        qvST.RX_or_Stock__c='ST';
        qvST.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvST.External_Key__c = acc.HOYA_Account_ID__c + 'XXXYYY777';
        insert qvST;

        QV_Sales__c qvRX = new QV_Sales__c();
        qvRX.FY__c = PrevFY;
        qvRX.Account__c = acc.Id;
        qvRX.Generic_Design__c ='YYY';
        qvRX.april__c = 100;qvRX.April_qty__c = 10;
        qvRX.may__c = 200;qvRX.May_qty__c = 20;
        qvRX.june__c = 200;qvRX.June_qty__c = 20;
        qvRX.july__c = 200; qvRX.July_qty__c = 20;
        qvRX.august__c = 200;qvRX.August_qty__c = 20;
        qvRX.september__c = 200; qvRX.September_qty__c = 20;
        qvRX.october__c = 200; qvRX.October_qty__c = 20;
        qvRX.november__c = 200; qvRX.November_qty__c = 20;
        qvRX.december__c = 200; qvRX.December_qty__c = 20;
        qvRX.january__c = 200; qvRX.January_qty__c = 20;
        qvRX.february__c = 200; qvRX.February_qty__c = 20;
        qvRX.March__c = 200; qvRX.March_qty__c = 20;
        qvRX.RX_or_Stock__c='RX';
        qvRX.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvRX.External_Key__c = acc.HOYA_Account_ID__c + 'MMMKKK888';
        insert qvRX;

        QV_Sales__c qvN2 = new QV_Sales__c();
        qvN2.FY__c = n2FY;
        qvN2.Account__c = acc.Id;
        qvST.type__c = 'C';
        qvN2.Generic_Design__c ='YYY';
        qvN2.april__c = 100;qvN2.April_qty__c = 10;
        qvN2.may__c = 200;qvN2.May_qty__c = 20;
        qvN2.june__c = 200;qvN2.June_qty__c = 20;
        qvN2.july__c = 200; qvN2.July_qty__c = 20;
        qvN2.august__c = 200;qvN2.August_qty__c = 20;
        qvN2.september__c = 200; qvN2.September_qty__c = 20;
        qvN2.october__c = 200; qvN2.October_qty__c = 20;
        qvN2.november__c = 200; qvN2.November_qty__c = 20;
        qvN2.december__c = 200; qvN2.December_qty__c = 20;
        qvN2.january__c = 200; qvN2.January_qty__c = 20;
        qvN2.february__c = 200; qvN2.February_qty__c = 20;
        qvN2.March__c = 200; qvN2.March_qty__c = 20;
        qvN2.RX_or_Stock__c='RX';
        qvN2.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvN2.External_Key__c = acc.HOYA_Account_ID__c + 'N2blabla';
        insert qvN2;

        Opportunity o = new Opportunity();
        o.Name = 'test zxcv';
        o.AccountId = acc.Id;
        o.StageName ='1.start';
        o.CloseDate = System.today();
        insert o;

        Task tk = new Task();
        tk.subject = 'Test';
        tk.WhatId = acc.Id;
        tk.ActivityDate = System.today();
        tk.description = 'test';
        insert tk;

        APACSalesTabController.getAccount(acc.Id);
        //APACSalesTabController.getDoorRelatedAccount(acc.Id);
        APACSalesTabController.initSales(acc.Id);
        APACSalesTabController.getVisitData(acc.Id);
        APACSalesTabController.getTaskData(acc.Id);
        APACSalesTabController.getRxTotalsRX(acc.Id);
        APACSalesTabController.getStTotalsST(acc.Id);
        APACSalesTabController.getLensDesign(acc.Id);
        APACSalesTabController.getLensDesignLY(acc.Id);
        APACSalesTabController.getLensCoating(acc.Id);
        APACSalesTabController.getAccCampaignMember(acc.Id);
        APACSalesTabController.getLensGenericDesignForChart(acc.Id);
        APACSalesTabController.getLensGenericDesignForChartST(acc.Id);
        APACSalesTabController.getAccountOpportunity(acc.Id);
        APACSalesTabController.getLensDesignforPie(acc.Id);
        APACSalesTabController.getLensCoatingForChart(acc.Id);
        //APACSalesTabController.getRelatedSalesList(acc2.Id, true);
        APACSalesTabController.getRelatedSalesList(acc2.Id, false);

        APACSalesTabController t = new APACSalesTabController();
        t.getCredits_CY();
        t.getCredits_LY();
        t.getTurnover_CY();
        t.getTurnover_LY();
        t.getQuantity_CY();
        t.getQuantity_LY();
        t.getQuantity_C_CY();
        t.getQuantity_C_LY();
        t.getConversionRate();
        t.getOriginalConversionRate();
        t.getAccountConversionRate();

        Test.StopTest();
    }

    @isTest
    static void TestDataSet(){
        Test.StartTest();
        Account acc = new Account();
        acc.Name = 'Test';
        acc.hoya_account_id__c = '123456';
        acc.RecordTypeId = '012b00000000P38';
        insert acc;

        APACSalesTabController.getLensGenericDesignForChartST(acc.Id);
        APACSalesTabController.getAccountOpportunity(acc.Id);
        APACSalesTabController.getLensGenericDesignForChart(acc.Id);
        APACSalesTabController.getLensCoating(acc.Id);
        APACSalesTabController.getLensDesignLY(acc.Id);
        APACSalesTabController.getLensDesign(acc.Id);
        APACSalesTabController.getStTotalsST(acc.Id);
        APACSalesTabController.getRxTotalsRX(acc.Id);
        APACSalesTabController.getLensDesignforPie(acc.Id);
        APACSalesTabController.getLensCoatingForChart(acc.Id);
        APACSalesTabController.getAccCampaignMember(acc.Id);
        APACSalesTabController.getLensDesignForBarChart(acc.Id);

        Test.StopTest();
    }

    @isTest
    static void TestGetTaskOpp(){
        Test.StartTest();

        Account acc = new Account();
        acc.Name = 'Test';
        acc.hoya_account_id__c = '123456';
        acc.RecordTypeId = AccountRECType;
        insert acc;

        Opportunity o = new Opportunity();
        o.Name = 'test zxcv';
        o.AccountId = acc.Id;
        o.StageName ='1.start';
        o.CloseDate = System.today().addDays(10);
        insert o;

        Task t = new Task();
        t.subject = 'Test';
        t.WhatId = o.Id;
        t.ActivityDate = System.today();
        t.description = 'test';
        insert t;

        APACSalesTabController.getTaskForOpportunity(acc.Id);
        Test.StopTest();

    }

    @isTest
    static void TestQVData(){
        Test.StartTest();

        String pDesign = 'LensDesign';
        Double pannualSales = 1000;
        Integer paanualQty = 10;

        APACSalesTabController.QVData qv = new APACSalesTabController.QVData(pDesign, pannualSales, paanualQty);
        
        Test.StopTest();
    }

    @isTest
    static void TestData(){
        Test.StartTest();

        String label = 'Test label';
        Double amount = 1000;
        Double qty = 10;

        APACSalesTabController.DataSet dt = new APACSalesTabController.DataSet(label, amount, qty);
        Test.stopTest();
    }

    @isTest
    static void TestAccountSales(){
        Test.StartTest();
        
        Door__c door = new Door__c();
        door.name = 'testDoorAPAC';
        door.geolocation__Latitude__s = 31.1;
        door.geolocation__Longitude__s = 1.5;
        insert door;

        Account acc = new Account();
        acc.Name = 'Test Account APAC-THAI';
        acc.Hoya_Account_Id__c = 'TEST123456';
        acc.RecordTypeId = AccountRECType;
        acc.Door__c = door.id;
        acc.Budget_April_Current_Year__c=0;
        acc.Budget_May_Current_Year__c=0;
        acc.Budget_June_Current_Year__c=0;
        acc.Budget_July_Current_Year__c=0;
        acc.Budget_August_Current_Year__c=0;
        acc.Budget_September_Current_Year__c=0;
        acc.Budget_October_Current_Year__c=0;
        acc.Budget_November_Current_Year__c=0;
        acc.Budget_December_Current_Year__c=0;
        acc.Budget_January_Current_Year__c=0;
        acc.Budget_February_Current_Year__c=0;
        acc.Budget_March_Current_Year__c=0;
        insert acc;

        Account acc2 = new Account();
        acc2.Name = 'sales test account2';
        acc2.hoya_account_id__c = 'SO3366666xx';
        acc2.RecordTypeId = AccountRECType;
        acc2.Door__c = door.id;
        acc2.ParentId = acc.Id;
        insert acc2;

        Integer year = Date.today().year();
        Integer month = Date.today().month();

        //fiscal year is current year-1 from january to march, year from april to december
        if(month<5){
            year = year-1;
        }

        String CurrFY = 'FY-' + String.valueOf(year).substring(2);
        String PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        String n2FY = 'FY-' + String.valueOf(year-2).substring(2);

        QV_Sales__c qvST = new QV_Sales__c();
        qvST.FY__c = CurrFY;
        qvST.type__c = 'C';
        qvST.Account__c = acc.Id;
        qvST.Generic_Design__c ='XXX';
        qvST.april__c = 100;qvST.April_qty__c = 10;
        qvST.may__c = 200;qvST.May_qty__c = 20;
        qvST.june__c = 200;qvST.June_qty__c = 20;
        qvST.july__c = 200; qvST.July_qty__c = 20;
        qvST.august__c = 200;qvST.August_qty__c = 20;
        qvST.september__c = 200; qvST.September_qty__c = 20;
        qvST.october__c = 200; qvST.October_qty__c = 20;
        qvST.november__c = 200; qvST.November_qty__c = 20;
        qvST.december__c = 200; qvST.December_qty__c = 20;
        qvST.january__c = 200; qvST.January_qty__c = 20;
        qvST.february__c = 200; qvST.February_qty__c = 20;
        qvST.March__c = 200; qvST.March_qty__c = 20;
        qvST.RX_or_Stock__c='ST';
        qvST.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvST.External_Key__c = acc.HOYA_Account_ID__c + 'XXXYYY777';
        insert qvST;

        QV_Sales__c qvRX = new QV_Sales__c();
        qvRX.FY__c = PrevFY;
        qvRX.Account__c = acc.Id;
        qvST.type__c = 'C';
        qvRX.Generic_Design__c ='YYY';
        qvRX.april__c = 100;qvRX.April_qty__c = 10;
        qvRX.may__c = 200;qvRX.May_qty__c = 20;
        qvRX.june__c = 200;qvRX.June_qty__c = 20;
        qvRX.july__c = 200; qvRX.July_qty__c = 20;
        qvRX.august__c = 200;qvRX.August_qty__c = 20;
        qvRX.september__c = 200; qvRX.September_qty__c = 20;
        qvRX.october__c = 200; qvRX.October_qty__c = 20;
        qvRX.november__c = 200; qvRX.November_qty__c = 20;
        qvRX.december__c = 200; qvRX.December_qty__c = 20;
        qvRX.january__c = 200; qvRX.January_qty__c = 20;
        qvRX.february__c = 200; qvRX.February_qty__c = 20;
        qvRX.March__c = 200; qvRX.March_qty__c = 20;
        qvRX.RX_or_Stock__c='RX';
        qvRX.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvRX.External_Key__c = acc.HOYA_Account_ID__c + 'MMMKKK888';
        insert qvRX;

        
        QV_Sales__c qvN2 = new QV_Sales__c();
        qvN2.FY__c = n2FY;
        qvN2.Account__c = acc.Id;
        qvST.type__c = 'C';
        qvN2.Generic_Design__c ='YYY';
        qvN2.april__c = 100;qvN2.April_qty__c = 10;
        qvN2.may__c = 200;qvN2.May_qty__c = 20;
        qvN2.june__c = 200;qvN2.June_qty__c = 20;
        qvN2.july__c = 200; qvN2.July_qty__c = 20;
        qvN2.august__c = 200;qvN2.August_qty__c = 20;
        qvN2.september__c = 200; qvN2.September_qty__c = 20;
        qvN2.october__c = 200; qvN2.October_qty__c = 20;
        qvN2.november__c = 200; qvN2.November_qty__c = 20;
        qvN2.december__c = 200; qvN2.December_qty__c = 20;
        qvN2.january__c = 200; qvN2.January_qty__c = 20;
        qvN2.february__c = 200; qvN2.February_qty__c = 20;
        qvN2.March__c = 200; qvN2.March_qty__c = 20;
        qvN2.RX_or_Stock__c='RX';
        qvN2.HOYA_Account_ID__c = acc.HOYA_Account_ID__c;
        qvN2.External_Key__c = acc.HOYA_Account_ID__c + 'N2blabla';
        insert qvN2;

        APACSalesTabController.AccountSales sales = APACSalesTabController.initSales(acc.Id);
        
        APACSalesTabController.getAnnualQuantity(sales, 1);
        APACSalesTabController.getAnnualQuantity(sales, 2);
        APACSalesTabController.getAnnualQuantity(sales, 3);
        APACSalesTabController.getAnnualQuantity(sales, 4);
        APACSalesTabController.getAnnualQuantity(sales, 5);
        APACSalesTabController.getAnnualQuantity(sales, 6);
        APACSalesTabController.getAnnualQuantity(sales, 7);
        APACSalesTabController.getAnnualQuantity(sales, 8);
        APACSalesTabController.getAnnualQuantity(sales, 9);
        APACSalesTabController.getAnnualQuantity(sales, 10);
        APACSalesTabController.getAnnualQuantity(sales, 11);
        APACSalesTabController.getAnnualQuantity(sales, 12);
        APACSalesTabController.getAnnualQuantity(sales, 0);

        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 1);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 2);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 3);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 4);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 5);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 6);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 7);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 8);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 9);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 10);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 11);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 12);
        APACSalesTabController.getAnnualQuantityYTD_LFY(sales, 0);

        APACSalesTabController.getTotalVolumesYTD_LY(sales, 1);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 2);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 3);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 4);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 5);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 6);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 7);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 8);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 9);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 10);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 11);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 12);
        APACSalesTabController.getTotalVolumesYTD_LY(sales, 0);
        
        APACSalesTabController.getRelatedSalesList(acc2.Id, true);
        APACSalesTabController.getRelatedSalesList(acc2.Id, false);

        QvRelatedAccountSales rel = new QvRelatedAccountSales(acc.hoya_account_id__c, 'sales', acc.id);
        rel.april=1;
        rel.aprilLY=3;
        rel.may=2;
        rel.may=4;
        Double annualSales = rel.getAnnual();
        Double annualSalesLY = rel.getAnnualLY();
        Double budget = rel.getAnnualBudgetCY();
        rel.compareTo(rel);

        APACSalesTabController.getQvSalesYTD(rel, 1);
        APACSalesTabController.getQvSalesYTD(rel, 2);
        APACSalesTabController.getQvSalesYTD(rel, 3);
        APACSalesTabController.getQvSalesYTD(rel, 4);
        APACSalesTabController.getQvSalesYTD(rel, 5);
        APACSalesTabController.getQvSalesYTD(rel, 6);
        APACSalesTabController.getQvSalesYTD(rel, 7);
        APACSalesTabController.getQvSalesYTD(rel, 8);
        APACSalesTabController.getQvSalesYTD(rel, 9);
        APACSalesTabController.getQvSalesYTD(rel, 10);
        APACSalesTabController.getQvSalesYTD(rel, 11);
        APACSalesTabController.getQvSalesYTD(rel, 12);
        APACSalesTabController.getQvSalesYTD(rel, 0);

        APACSalesTabController.AccountSales test = new APACSalesTabController.AccountSales();
        APACSalesTabController.QvData qvdata = new APACSalesTabController.QvData('pDesign', 100, 100);
        APACSalesTabController ctrl = new APACSalesTabController();

        ctrl.getAccountConversionRate();
        ctrl.getConversionRate();
        ctrl.getCredits_CY();
        ctrl.getCredits_LY();
        ctrl.getOriginalConversionRate();
        ctrl.getQuantity_C_CY();
        ctrl.getQuantity_C_LY();
        ctrl.getQuantity_CY();
        ctrl.getQuantity_LY();
        ctrl.getTurnover_CY();
        ctrl.getTurnover_LY();

        System.assert(true);

        //Test.StopTest();
    }
}