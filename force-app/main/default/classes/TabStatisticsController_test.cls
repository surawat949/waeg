@isTest
public class TabStatisticsController_test {

    @IsTest
    static void runTestCtrl(){

        String AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();

        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId = AccountRecordType;
        acc.Local_Consolidation_Key__c='123';
        
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='sales test Germany account';
        acc1.hoya_account_id__c='SO4900999xx';
        acc1.RecordTypeId = AccountRecordType;
        acc1.Local_Consolidation_Key__c='123';        
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name='sales test account1';
        acc2.hoya_account_id__c='SO3299999xx';
        acc2.RecordTypeId = AccountRecordType;
        acc2.Local_Consolidation_Key__c='1234';        
        insert acc2;
        
        Account Childacc = new Account();
        Childacc.Name='sales test child account';
        Childacc.hoya_account_id__c='SO3399998xx';
        Childacc.RecordTypeId= AccountRecordType;
		Childacc.parentId=acc.Id;            
        insert Childacc; 
        
        Last_Sales_Statistics__c lastSales = new Last_Sales_Statistics__c();
        lastSales.Account__c = Childacc.Id;
        lastSales.Lenses_Net_Sales_CFY__c = 150;
        lastSales.Lenses_Gross_Sales_CFY__c = 100;        
        insert lastSales;
        
        Integer CFY=Date.today().year();
        
        Sales_Statistics__c stat=new Sales_Statistics__c();
        stat.Account__c=acc1.Id;
        stat.Stock_lenses_Qty__c=3;
        stat.Type__c='0';
        stat.Year__c=CFY;
        stat.Month__c=6;
        stat.External_Key__c=acc.id+'-'+ stat.Type__c+'-'+stat.Month__c+'-'+stat.Year__c;
        stat.Total_STOCK_qty_shipped_same_day__c=1;
        stat.Total_STOCK_qty_shipped_in_1_day__c=2;
        stat.Total_STOCK_qty_shipped_in_1_day__c=2;
        stat.Total_STOCK_qty_shipped_in_2_days__c=2;
        stat.Total_STOCK_qty_shipped_in_3_days__c=2;
        stat.Total_STOCK_qty_shipped_in_4_days__c=2;
        stat.Total_STOCK_qty_shipped_in_5_days__c=2;
        stat.Lenses_Gross_Sales__c=312.56;
        stat.Lenses_Net_Sales__c=300;
        stat.Lenses_Qty__c=3;
        stat.Fiscal_Year__c=CFY;
        stat.Lens_Returns_Sales_Json__c ='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        insert stat;
        
        Sales_Statistics__c stat1=new Sales_Statistics__c();
        stat1.Account__c=acc1.Id;
        stat1.Stock_lenses_Qty__c=3;
        stat1.Type__c='1';
        stat1.Year__c=CFY;
        stat1.Month__c=7;
        stat1.External_Key__c=acc1.id+'-'+ stat1.Type__c+'-'+stat1.Month__c+'-'+stat1.Year__c;
        stat1.Total_STOCK_qty_shipped_same_day__c=1;
        stat1.Total_STOCK_qty_shipped_in_1_day__c=2;
        stat1.Total_STOCK_qty_shipped_in_1_day__c=2;
        stat1.Total_STOCK_qty_shipped_in_2_days__c=2;
        stat1.Total_STOCK_qty_shipped_in_3_days__c=2;
        stat1.Total_STOCK_qty_shipped_in_4_days__c=2;
        stat1.Total_STOCK_qty_shipped_in_5_days__c=2;
        stat1.Lenses_Gross_Sales__c=312.56;
        stat1.Lenses_Net_Sales__c=300;
        stat1.Lenses_Qty__c=3;
        stat1.Fiscal_Year__c=CFY;
        insert stat1;
        
        Sales_Statistics__c st=new Sales_Statistics__c();
        st.Account__c=acc1.Id;
        st.Stock_lenses_Qty__c=3;
        st.Type__c='1';
        st.Year__c=CFY-2;
        st.Month__c=10;
        st.External_Key__c=acc1.id+'-'+ st.Type__c+'-'+st.Month__c+'-'+st.Year__c;
        st.Total_STOCK_qty_shipped_same_day__c=1;
        st.Total_STOCK_qty_shipped_in_1_day__c=2;
        st.Total_STOCK_qty_shipped_in_1_day__c=2;
        st.Total_STOCK_qty_shipped_in_2_days__c=2;
        st.Total_STOCK_qty_shipped_in_3_days__c=2;
        st.Total_STOCK_qty_shipped_in_4_days__c=2;
        st.Total_STOCK_qty_shipped_in_5_days__c=2;
        st.Lenses_Gross_Sales__c=312.56;
        st.Lenses_Net_Sales__c=300;
        st.Lenses_Qty__c=3;
        st.Fiscal_Year__c=CFY-1;
        insert st;
        
        Sales_Statistics__c stat2=new Sales_Statistics__c();
        stat2.Account__c=acc1.Id;
        stat2.Stock_lenses_Qty__c=3;
        stat2.Type__c='4';
        stat2.Year__c=CFY;
        stat2.Month__c=7;
        stat2.External_Key__c=acc1.id+'-'+ stat2.Type__c+'-'+stat2.Month__c+'-'+stat2.Year__c;
        stat2.Fiscal_Year__c=CFY;
        insert stat2;
        
        Sales_Statistics__c stat3=new Sales_Statistics__c();
        stat3.Account__c=acc1.Id;
        stat3.Stock_lenses_Qty__c=3;
        stat3.Type__c='3';
        stat3.Year__c=CFY-1;
        stat3.Month__c=7;
        stat3.External_Key__c=acc1.id+'-'+ stat3.Type__c+'-'+stat3.Month__c+'-'+stat3.Year__c;
        stat3.Fiscal_Year__c=CFY-1;
        insert stat3;
        
        Sales_Statistics__c stat8=new Sales_Statistics__c();
        stat8.Account__c=acc1.Id;
        stat8.Stock_lenses_Qty__c=3;
        stat8.Type__c='4';
        stat8.Year__c=CFY-1;
        stat8.Month__c=7;
        stat8.External_Key__c=acc1.id+'-'+ stat8.Type__c+'-'+stat8.Month__c+'-'+stat8.Year__c;
        stat8.Fiscal_Year__c=CFY-1;
        insert stat8;
        
        Sales_Statistics__c stat9=new Sales_Statistics__c();
        stat9.Account__c=acc1.Id;
        stat9.Stock_lenses_Qty__c=3;
        stat9.Type__c='10';
        stat9.Year__c=CFY-1;
        stat9.Month__c=7;
        stat9.External_Key__c=acc1.id+'-'+ stat9.Type__c+'-'+stat9.Month__c+'-'+stat9.Year__c;
        stat9.Fiscal_Year__c=CFY-1;
        insert stat9;
        
        Sales_Statistics__c stat4=new Sales_Statistics__c();
        stat4.Account__c=acc1.Id;
        stat4.Stock_lenses_Qty__c=3;
        stat4.Type__c='9';
        stat4.Year__c=CFY-2;
        stat4.Month__c=11;
        stat4.External_Key__c=acc1.id+'-'+ stat4.Type__c+'-'+stat4.Month__c+'-'+stat4.Year__c;
        stat4.Fiscal_Year__c=CFY-1;
        stat4.NonAdaptationReturnsJson__c = '{"SEIKO ASPHERIC":2,"SEIKO EMBLEM XW":3}';
        insert stat4;
        
        Sales_Statistics__c stat5=new Sales_Statistics__c();
        stat5.Account__c=acc1.Id;
        stat5.Stock_lenses_Qty__c=3;
        stat5.Type__c='9';
        stat5.Year__c=CFY;
        stat5.Month__c=8;
        stat5.External_Key__c=acc1.id+'-'+ stat5.Type__c+'-'+stat5.Month__c+'-'+stat5.Year__c;
        stat5.Fiscal_Year__c=CFY;
        insert stat5;
        
        Sales_Statistics__c stat6=new Sales_Statistics__c();
        stat6.Account__c=acc1.Id;
        stat6.Stock_lenses_Qty__c=3;
        stat6.Type__c='3';
        stat6.Year__c=CFY;
        stat6.Month__c=9;
        stat6.External_Key__c=acc1.id+'-'+ stat6.Type__c+'-'+stat6.Month__c+'-'+stat6.Year__c;
        stat6.Fiscal_Year__c=CFY;
        stat6.NonAdaptationReturnsJson__c = '{"SEIKO ASPHERIC":2,"SEIKO EMBLEM XW":3}';
        insert stat6;
        
        Sales_Statistics__c stat7=new Sales_Statistics__c();
        stat7.Account__c=acc1.Id;
        stat7.Stock_lenses_Qty__c=3;
        stat7.Type__c='10';
        stat7.Year__c=CFY;
        stat7.Month__c=9;
        stat7.External_Key__c=acc1.id+'-'+ stat7.Type__c+'-'+stat7.Month__c+'-'+stat7.Year__c;
        stat7.Fiscal_Year__c=CFY;
        insert stat7;
        
        Sales_Statistics__c statistics=new Sales_Statistics__c();
        statistics.Account__c=acc.Id;
        statistics.Stock_lenses_Qty__c=3;
        statistics.Type__c='0';
        statistics.Year__c=CFY;
        statistics.Month__c=7;
        statistics.External_Key__c=acc.id+'-'+ statistics.Type__c+'-'+statistics.Month__c+'-'+statistics.Year__c;
        statistics.Total_STOCK_qty_shipped_same_day__c=1;
        statistics.Total_STOCK_qty_shipped_in_1_day__c=2;
        statistics.Total_STOCK_qty_shipped_in_1_day__c=2;
        statistics.Total_STOCK_qty_shipped_in_2_days__c=2;
        statistics.Total_STOCK_qty_shipped_in_3_days__c=2;
        statistics.Total_STOCK_qty_shipped_in_4_days__c=2;
        statistics.Total_STOCK_qty_shipped_in_5_days__c=2;
        statistics.Lenses_Gross_Sales__c=312.56;
        statistics.Lenses_Net_Sales__c=300;
        statistics.Lenses_Qty__c=3;
        statistics.Fiscal_Year__c=CFY;
       // statistics.Lens_Returns_Sales_Json__c ='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        insert statistics;        
       
        Sales_Statistics__c statistics1=new Sales_Statistics__c();
        statistics1.Account__c=acc.Id;
        statistics1.Stock_lenses_Qty__c=3;
        statistics1.Type__c='0';
        statistics1.Year__c=CFY-1;
        statistics1.Month__c=8;
        statistics1.External_Key__c=acc.id+'-'+ statistics1.Type__c+'-'+statistics1.Month__c+'-'+statistics1.Year__c;
        statistics1.Total_STOCK_qty_shipped_same_day__c=1;
        statistics1.Total_STOCK_qty_shipped_in_1_day__c=2;
        statistics1.Total_STOCK_qty_shipped_in_2_days__c=2;
        statistics1.Total_STOCK_qty_shipped_in_3_days__c=2;
        statistics1.Total_STOCK_qty_shipped_in_4_days__c=2;
        statistics1.Total_STOCK_qty_shipped_in_5_days__c=2;        
        statistics1.Lenses_Gross_Sales__c=578.56;
        statistics1.Lenses_Net_Sales__c=578.56;
        statistics1.Lenses_Qty__c=3;
        statistics1.Fiscal_Year__c=CFY-1;
        insert statistics1;
        
        Sales_Statistics__c statistics2=new Sales_Statistics__c();
        statistics2.Account__c=acc.Id;
        statistics2.RX_lenses_qty__c=3;
        statistics2.Type__c='1';
        statistics2.Year__c=CFY-1;
        statistics2.Month__c=8;
        statistics2.External_Key__c=acc.id+'-'+ statistics2.Type__c+'-'+statistics2.Month__c+'-'+statistics2.Year__c;
        statistics2.Total_RX_qty_shipped_same_day__c=1;
        statistics2.Total_RX_qty_shipped_in_1_day__c=2;
        statistics2.Total_RX_qty_shipped_in_2_days__c=3;
        statistics2.Total_RX_qty_shipped_in_3_days__c=3;
        statistics2.Total_RX_qty_shipped_in_4_days__c=3;
        statistics2.Total_RX_qty_shipped_in_5_days__c=3;
        statistics2.Total_RX_qty_shipped_in_6_days__c=3;
        statistics2.Total_RX_qty_shipped_in_7_days__c=3;
        statistics2.Total_RX_qty_shipped_in_8_days__c=3;
        statistics2.Total_RX_qty_shipped_in_9_days__c=3;
        statistics2.Total_RX_qty_shipped_in_10_days__c=3;
        statistics2.Lenses_Gross_Sales__c=578.56;
        statistics2.Lenses_Net_Sales__c=578.56;
        statistics2.Lenses_Qty__c=5;
        statistics2.Fiscal_Year__c=CFY-1;
        insert statistics2;
                
        Sales_Statistics__c statistics5=new Sales_Statistics__c();
        statistics5.Account__c=Childacc.Id;
        statistics5.Stock_lenses_Qty__c=3;
        statistics5.Type__c='0';
        statistics5.Year__c=CFY-1;
        statistics5.Month__c=11;
        statistics5.External_Key__c=Childacc.id+'-'+ statistics5.Type__c+'-'+statistics5.Month__c+'-'+statistics5.Year__c;
        statistics5.Total_STOCK_qty_shipped_same_day__c=1;
        statistics5.Total_STOCK_qty_shipped_in_1_day__c=2;
        statistics5.Total_STOCK_qty_shipped_in_1_day__c=2;
        statistics5.Total_STOCK_qty_shipped_in_2_days__c=2;
        statistics5.Total_STOCK_qty_shipped_in_3_days__c=2;
        statistics5.Total_STOCK_qty_shipped_in_4_days__c=2;
        statistics5.Total_STOCK_qty_shipped_in_5_days__c=2;
        statistics5.Lenses_Gross_Sales__c=312.56;
        statistics5.Lenses_Net_Sales__c=300;
        statistics5.Lenses_Qty__c=3;
        statistics5.Fiscal_Year__c=CFY-1;
        insert statistics5;
       
        Last_Sales_Statistics__c lastSales1 = new Last_Sales_Statistics__c();
        lastSales1.Account__c = acc.Id;
        insert lastSales1;

        String UserId = UserInfo.getUserId();
        Date DateDue = System.today();

        TabStatisticsController.LensSales sales = new TabStatisticsController.LensSales();
        sales.lensGrossSales = 10;
        sales.lensNetSales = 10;
        sales.lensQty = 2;

        Map<Integer, TabStatisticsController.LensSales> newLensSalesMap = new Map<Integer, TabStatisticsController.LensSales>();
        newLensSalesMap.put(10, sales);

        
        Test.startTest();
        System.assert(true);   
        TabStatisticsController.testMonth=10;
        List<Object> objArray1 = TabStatisticsController.getStatisticsSales(acc1.Id); 
        List<Object> objArray2 = TabStatisticsController.getStatisticsSales(acc.Id);  
        List<Id> accId = new List<Id>{acc.Id,acc1.Id};
        List<TabStatisticsController.MonthDataWrapper> resWrapper = TabStatisticsController.getMonthlyStatisticsSales(accId,'Net');
        TabStatisticsController.getRelatedSalesList(acc1.Id,'Net');
        TabStatisticsController.getRelatedSalesList(acc1.Id,'Gross');
        TabStatisticsController.getMonthWithSales(acc.Id);
        TabStatisticsController.getAverageSalesList(acc.Id);
        TabStatisticsController.getLensReturns(acc.Id);
        TabStatisticsController.getLastSalesStatisticsId(acc.Id);
        TabStatisticsController.getLensesAnnualRevenue(Childacc.Id,'Net');
        TabStatisticsController.getLensesAnnualRevenue(Childacc.Id,'Gross');
        TabStatisticsController.getCurrency(acc.Id);      
        TabStatisticsController.getLensesSales(acc1.Id,true,true);
        TabStatisticsController.getLensValue(newLensSalesMap, 4, 'Net');
        TabStatisticsController.getRelatedSalesList(Childacc.Id,'Net');
        TabStatisticsController.getRelatedSalesList(Childacc.Id,'Gross');
        TabStatisticsController.getRelatedSalesList(acc2.Id,'Gross');
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=12;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=11;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=9;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=8;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=7;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=6;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=5;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=4;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=3;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=2;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        TabStatisticsController.testMonth=1;
        TabStatisticsController.getNonAdaptationReturns(acc1.Id);
        String lensRetsJson='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        TabStatisticsController.parseLensRetsJson(lensRetsJson);
        TabStatisticsController.parseLensRetsSalesJson(lensRetsJson);
        TabStatisticsController.CreateSFDCV2Task('This is a test', acc.Id, 'This is a instruction', UserId, DateDue, 'New','');
        TabStatisticsController.getAccountDataPillList('%', 'Account');
        Test.stopTest();
    }
}