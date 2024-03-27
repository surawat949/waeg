@isTest
public with sharing class AccountSalesTabComponentController_test {
    public AccountSalesTabComponentController_test() {
    }

    @IsTest
    static void runTestCtrl(){
        
        Test.startTest();
        Door__c door = new Door__c();
        door.name = 'testDoor';
        door.geolocation__Latitude__s = 31.1;
        door.geolocation__Longitude__s = 1.5;
        insert door;

        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId='012b00000000P38';
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
        acc2.RecordTypeId='012b00000000P38';
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

        AccountSalesTabComponentController.getAccount(acc.Id);
        AccountSalesTabComponentController.getDoorRelatedAccount(acc.Id);
        AccountSalesTabComponentController.AccountSales sales = AccountSalesTabComponentController.initSales(acc.Id);
        AccountSalesTabComponentController.getAnnualQuantity(sales, 1);
        AccountSalesTabComponentController.getAnnualQuantityYTD_LFY(sales, 1);
        AccountSalesTabComponentController.getQuantityLast3Month(sales, 1);
        AccountSalesTabComponentController.getQuantityLast3MonthLY(sales, 1);
        AccountSalesTabComponentController.getTotalTurnoverYTD_LY(sales, 1);
        AccountSalesTabComponentController.getTotalVolumesYTD_LY(sales, 1);
        AccountSalesTabComponentController.getFiscalBudgetOfMonth(acc, 1);
        AccountSalesTabComponentController.getSeikoData(acc.id);
        AccountSalesTabComponentController.getRelatedSalesList(acc2.Id, false);
        AccountSalesTabComponentController.getRelatedSalesList(acc2.Id, true);
        AccountSalesTabComponentController.getContactList(acc.Id);
        AccountSalesTabComponentController.getAccountsLinkedToContact(acc.Id);
        AccountSalesTabComponentController.updateOpeningTimes(acc.Id, 'jsonStringTest');
        AccountSalesTabComponentController.getOpeningTimes(acc.Id);
        Contact c = new Contact();
        c.FirstName = 'ophta';
        c.LastName = 'test';
        c.AccountId = acc.Id;
        insert c;
        AccountSalesTabComponentController.getAccountsLinkedToContactbyContactId(c.Id);
        AccountSalesTabComponentController t = new AccountSalesTabComponentController();
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
        //AccountSalesTabComponentController.getSeikoObjectType();

        QvRelatedAccountSales rel = new QvRelatedAccountSales(acc.hoya_account_id__c, 'sales', acc.id);
        rel.april=1;
        rel.aprilLY=3;
        rel.may=2;
        rel.may=4;
        Double annualSales = rel.getAnnual();
        Double annualSalesLY = rel.getAnnualLY();
        Double budget = rel.getAnnualBudgetCY();
        rel.compareTo(rel);

        AccountSalesTabComponentController.getQvSalesYTD(rel, month);
        AccountSalesTabComponentController.getLastMediaUsage(acc.id, 'xxx');
        AccountSalesTabComponentController.AccountSales test = new AccountSalesTabComponentController.AccountSales();
        AccountSalesTabComponentController.QvData qvdata = new AccountSalesTabComponentController.QvData('pDesign', 100, 100);
        AccountSalesTabComponentController ctrl = new AccountSalesTabComponentController();
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

        //test on ECP_Training__c
        ECP_Training__c training = new ECP_Training__c();
        training.account__c = acc.Id;
        training.start__c = System.now();
        training.end__c = System.now();
        training.Training_status__c='Completed';
        training.Type__c='In Store';
        training.Training__c='SEIKO A-ZONE';
        insert training;
        AccountSalesTabComponentController.getLastTrainingDate(acc.Id, 'SEIKO A-ZONE');
        AccountSalesTabComponentController.isSocialMediaActive(acc.Id);
        AccountSalesTabComponentController.isSeikoProActive(acc.Id);
        AccountSalesTabComponentController.startEnroll(acc.Id);
        AccountSalesTabComponentController.isSeikoXtraNetNMU(acc.Id);
        AccountSalesTabComponentController.SeikoXIpad(acc.Id);     
        AccountSalesTabComponentController.getRelatedClinicsByContactId(c.Id);

        
        
        System.assert(true);
        //Test.stopTes;
        
    }
}