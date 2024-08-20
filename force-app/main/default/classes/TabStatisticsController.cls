public with sharing class TabStatisticsController {
    @AuraEnabled public static Map<Integer,SalesData> MonthlyCYData{get;set;}
    @AuraEnabled public static Map<Integer,SalesData> MonthlyLYData{get;set;}
    public static Integer testMonth{get;set;} 
    public TabStatisticsController(){     

	}
     //Wrapper class to store Related Account details 
    public class AccountRelatedSales{
        public AccountRelatedSales(){}
        @AuraEnabled public double salesCFY{get;set;}
        @AuraEnabled public double salesLFYYTD{get;set;}
        @AuraEnabled public double variationSales{get;set;}
        @AuraEnabled public double volumesCFY{get;set;}        
        @AuraEnabled public double volumesLFYYTD{get;set;}
        @AuraEnabled public double variationVolumes{get;set;}
        @AuraEnabled public Id AccountId{get;set;}
        @AuraEnabled public String hoyaAccountId{get;set;}
    }
     //Wrapper class to store Rx ans Stock details
    public class RxAndStockSales{        
       @AuraEnabled public Integer rxQty{get;set;}
       @AuraEnabled public Integer stockQty{get;set;}
       @AuraEnabled public Integer stockShippedonSameDay{get;set;}
       @AuraEnabled public Integer stockShippedin1Day{get;set;}
       @AuraEnabled public Integer stockShippedin2Days{get;set;}
       @AuraEnabled public Integer stockShippedin3Days{get;set;}
       @AuraEnabled public Integer stockShippedin4Days{get;set;}
       @AuraEnabled public Integer stockShippedin5Days{get;set;}
       @AuraEnabled public Integer rxShippedonSameDay{get;set;}
       @AuraEnabled public Integer rxShippedin1Day{get;set;}
       @AuraEnabled public Integer rxShippedin2Days{get;set;}
       @AuraEnabled public Integer rxShippedin3Days{get;set;}
       @AuraEnabled public Integer rxShippedin4Days{get;set;}
       @AuraEnabled public Integer rxShippedin5Days{get;set;}
       @AuraEnabled public Integer rxShippedin6Days{get;set;}
       @AuraEnabled public Integer rxShippedin7Days{get;set;}
       @AuraEnabled public Integer rxShippedin8Days{get;set;}
       @AuraEnabled public Integer rxShippedin9Days{get;set;}
       @AuraEnabled public Integer rxShippedin10Days{get;set;}
       public RxAndStockSales(){
            rxQty=0;
            stockQty=0;
            rxShippedonSameDay = 0;
            stockShippedonSameDay=0;
            stockShippedin1Day=0;
            stockShippedin2Days=0;
            stockShippedin3Days=0;
            stockShippedin4Days=0;
            stockShippedin5Days=0;
            rxShippedin1Day=0;
            rxShippedin2Days=0;
            rxShippedin3Days=0;
            rxShippedin4Days=0;
            rxShippedin5Days=0;
            rxShippedin6Days=0;
            rxShippedin7Days=0;
            rxShippedin8Days=0;
            rxShippedin9Days=0;
            rxShippedin10Days=0;
        }
    }
    //Wrapper class to store lens(Rx+Stock) sales
    public class LensSales{
        public LensSales(){}
        @AuraEnabled public double lensGrossSales{get;set;}
        @AuraEnabled public double lensNetSales{get;set;}
        @AuraEnabled public Integer lensQty{get;set;}    
    }  
    public class SalesData{
        @AuraEnabled public Double lensNetSales{get;set;}
        @AuraEnabled public Double lensGrossSales{get;set;}
        @AuraEnabled public Double framesNetSales{get;set;}
        @AuraEnabled public Double framesGrossSales{get;set;}
        @AuraEnabled public Double instrumentsNetSales{get;set;}
        @AuraEnabled public Double instrumentsGrossSales{get;set;}
        @AuraEnabled public Double otherNetSales{get;set;}
        @AuraEnabled public Double otherGrossSales{get;set;}
        @AuraEnabled public Double totalNetSales{get;set;}
        @AuraEnabled public Double totalGrossSales{get;set;}
        @AuraEnabled public Integer lensQty{get;set;}
        @AuraEnabled public Integer framesQty{get;set;}
        @AuraEnabled public Integer instrumentsQty{get;set;}
        @AuraEnabled public Integer OthersQty{get;set;}
        @AuraEnabled public Integer totalQty{get;set;}
        @AuraEnabled public Integer rxQty{get;set;}
        @AuraEnabled public Integer stockQty{get;set;}
        @AuraEnabled public Integer remoteEdgingQty{get;set;}
        @AuraEnabled public Double contactLensNetSales{get;set;}
        @AuraEnabled public Double contactLensGrossSales{get;set;}
        @AuraEnabled public Integer contactLensQty{get;set;}
        
        public SalesData(){
            lensNetSales=0;
            lensGrossSales=0;
            framesNetSales=0;
            framesGrossSales=0;
            instrumentsNetSales=0;
            instrumentsGrossSales=0;
            otherNetSales=0;
            otherGrossSales=0;  
            totalNetSales=0;
            totalGrossSales=0;
            lensQty=0;
            framesQty=0;
            instrumentsQty=0;
            OthersQty=0;
            totalQty=0;
            rxQty=0;
            stockQty=0;
            remoteEdgingQty=0;      
            contactLensNetSales = 0;
            contactLensGrossSales = 0;
            contactLensQty = 0;
         }
    }
  
    @AuraEnabled(cacheable=true)
    public static Id getLastSalesStatisticsId(Id accId){
        List<Last_Sales_Statistics__c> sales = [Select Id From Last_Sales_Statistics__c Where Account__c=:accId];
        if(sales.size() > 0){
            return sales[0].Id;
        }
        else 
            return null;
    }    
    
  
    @AuraEnabled(cacheable=true)
    public static List<Object> getStatisticsSales(Id recordId){
        List<Object> salesList;
        /*
        * determine the current fiscal year
        */
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
        //Date dateFiveMonthsAgo = Date.today().addMonths(-5);
        //Integer month = dateFiveMonthsAgo.month();
        if(Test.isRunningTest())
            month=testMonth;
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        //get Lenses Sales
        List<Object> LensesSalesLst = getLensesSales(recordId,true,false);
        Map<Integer,LensSales> MonthlyCYLensMap=new Map<Integer,LensSales>();
        MonthlyCYLensMap =(Map<Integer,LensSales>)LensesSalesLst[0];
        Map<Integer,LensSales> MonthlyLYLensMap=new Map<Integer,LensSales>();
        MonthlyLYLensMap =(Map<Integer,LensSales>)LensesSalesLst[1];
        Map<Integer,LensSales> MonthlyNYLensMap=new Map<Integer,LensSales>();
        MonthlyNYLensMap =(Map<Integer,LensSales>)LensesSalesLst[2];     
																	 
																			
        /*
        * compute data other than lens
        */
        List<Sales_Statistics__c> AllSalesData=[SELECT Type__c,Month__c,Fiscal_Year__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,Instrument_Gross_Sales__c,Instrument_Net_Sales__c,
                                                Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c,Remote_edging_Qty__c,Contact_Lenses_Qty__c,Contact_Lenses_Net_Sales__c,Contact_Lenses_Gross_Sales__c
                                                from Sales_Statistics__c
                                                where Account__c=:recordId and Type__c != '0' and Type__c != '1'and (Fiscal_Year__c =: CurrentFiscalyear OR Fiscal_Year__c =: CurrentFiscalyear-1) order by Month__c asc ]; 
        List<Sales_Statistics__c> AllSalesDataCY=new List<Sales_Statistics__c>();
        List<Sales_Statistics__c> AllSalesDataLY=new List<Sales_Statistics__c>();
        
        if(AllSalesData.size() > 0){
            for(Sales_Statistics__c salesStat:AllSalesData){
                if((Integer)salesStat.Fiscal_Year__c == CurrentFiscalyear){ 
                    AllSalesDataCY.add(salesStat);
                }
                if((Integer)salesStat.Fiscal_Year__c == CurrentFiscalyear-1){ 
                    AllSalesDataLY.add(salesStat);
                }
            }
        }        
        //loop through the result and get the individual sales & qty and total sales & qty
        MonthlyCYData=new Map<Integer,SalesData>();
        MonthlyLYData=new Map<Integer,SalesData>();
        List<SalesData> SalesListCy=new List<SalesData>();
        List<SalesData> SalesListLy=new List<SalesData>();
        //prepare the data for Cy  
        for(Integer i = 1; i <= 12; i++){
            SalesData salesDataObj=new SalesData();       
            if(MonthlyCYLensMap.containsKey(i)){
                LensSales lensObj = MonthlyCYLensMap.get(i);
                salesDataObj.lensNetSales = parseNull(lensObj.lensNetSales); 
                salesDataObj.lensGrossSales = parseNull(lensObj.lensGrossSales);
                salesDataObj.lensQty = parseNullInt(lensObj.lensQty);
            } 
            if(AllSalesDataCY.size() > 0){                    
                for(Sales_Statistics__c salesStat:AllSalesDataCY){ 
                    if(salesStat.Month__c == (double)i){
                        if(salesStat.Type__c == '3'){
                            salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                        }
                        else if(salesStat.Type__c == '4'){
                            salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                        }
                        else if(salesStat.Type__c == '9'){
                            salesDataObj.contactLensGrossSales = parseNull((double)salesStat.Contact_Lenses_Gross_Sales__c);
                            salesDataObj.contactLensNetSales = parseNull((double)salesStat.Contact_Lenses_Net_Sales__c);
                            salesDataObj.contactLensQty = parseNullInt((Integer)salesStat.Contact_Lenses_Qty__c);
                        }
                        else{
                            salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                        }
                    } 
                }
            }
            salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales+salesDataObj.contactLensNetSales;
            salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales+salesDataObj.contactLensGrossSales;
            salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty+salesDataObj.contactLensQty;
            
            MonthlyCYData.put(i,salesDataObj);
											   
        }        
        //prepare the data for Ly        
        for(Integer i = 1; i <= 12; i++){
            SalesData salesDataObj=new SalesData();                       
            if(MonthlyLYLensMap.containsKey(i)){
                LensSales lensObj=MonthlyLYLensMap.get(i);
                salesDataObj.lensNetSales=lensObj.lensNetSales; 
                salesDataObj.lensGrossSales=lensObj.lensGrossSales;
                salesDataObj.lensQty=lensObj.lensQty;
            }  
            if(AllSalesDataLY.size() > 0){
                for(Sales_Statistics__c salesStat:AllSalesDataLY){  
                    if(salesStat.Month__c == (double)i){
                        if(salesStat.Type__c == '3'){
                            salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                        }
                        else if(salesStat.Type__c == '4'){
                            salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                        }
                        else if(salesStat.Type__c == '9'){
                            salesDataObj.contactLensGrossSales = parseNull((double)salesStat.Contact_Lenses_Gross_Sales__c);
                            salesDataObj.contactLensNetSales = parseNull((double)salesStat.Contact_Lenses_Net_Sales__c);
                            salesDataObj.contactLensQty = parseNullInt((Integer)salesStat.Contact_Lenses_Qty__c);
                        }
                        else{
                            salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                        }
                    }    
                }
            }
            salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales+salesDataObj.contactLensNetSales;
            salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales+salesDataObj.contactLensGrossSales;
            salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty+salesDataObj.contactLensQty;
            
            MonthlyLYData.put(i,salesDataObj);
        } 
        //get Account 
        List<Last_Sales_Statistics__c> lastSales = [select Id,Budget_April_Current_Year__c,Budget_May_Current_Year__c,Budget_June_Current_Year__c,Budget_July_Current_Year__c,
                                Budget_August_Current_Year__c,Budget_September_Current_Year__c,Budget_October_Current_Year__c,Budget_November_Current_Year__c,Budget_December_Current_Year__c,
                                Budget_January_Current_Year__c,Budget_February_Current_Year__c,Budget_March_Current_Year__c,Forecast_current_year__c
                                ,Forecast_Gross_April_current_FY__c,Forecast_Gross_May_current_FY__c,Forecast_Gross_June_current_FY__c,Forecast_Gross_July_current_FY__c,
                                Forecast_Gross_August_current_FY__c,Forecast_Gross_September_current_FY__c,Forecast_Gross_October_current_FY__c,Forecast_Gross_November_current_FY__c,
                                Forecast_Gross_December_current_FY__c,Forecast_Gross_January_current_FY__c,Forecast_Gross_February_current_FY__c,Forecast_Gross_March_current_FY__c,Forecast_Gross_Current_Year__c
                                from Last_Sales_Statistics__c where Account__c=:recordId];        
	    if(lastSales.size() > 0)               
        	salesList = new List<Object>{MonthlyCYLensMap,MonthlyLYLensMap,MonthlyNYLensMap,MonthlyCYData,MonthlyLYData,lastSales[0]};
        else
            salesList = new List<Object>{MonthlyCYLensMap,MonthlyLYLensMap,MonthlyNYLensMap,MonthlyCYData,MonthlyLYData,null};    
        System.debug(salesList);
        return salesList;
    }
    @AuraEnabled(cacheable=true)
    public static List<MonthDataWrapper> getMonthlyStatisticsSales(List<Id> accountList, string type){
        List<Object> salesList;
        List<String> labels = new List<String>{'Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec','Jan','Feb','Mar'};
        /*
        * determine the current fiscal year
        */
        Integer CurrentFiscalyear = Date.today().year();
        Integer currentMonth = Date.today().month();
        //Date dateFiveMonthsAgo = Date.today().addMonths(-5);
        //Integer currentMonth = dateFiveMonthsAgo.month();
        Map<String,MonthDataWrapper> accMonthlyData =  new Map<String,MonthDataWrapper>();
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(currentMonth <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        Integer previousFiscalYear = CurrentFiscalyear - 1;
        Set<Integer> yearstoBechecked = new Set<Integer>{CurrentFiscalyear,previousFiscalYear};
       /* List<Sales_Statistics__c> allsalesLensData = [SELECT Month__c, Fiscal_Year__c, Type__c, Lenses_Gross_Sales__c, Lenses_Net_Sales__c,
													  Lenses_Qty__c, Account__c FROM Sales_Statistics__c WHERE Account__c IN :accountList
                                                      AND (Type__c='0' OR Type__c='1') AND Fiscal_Year__c IN:yearstoBechecked ORDER BY Month__c asc];*/
       
        String query = 'SELECT Month__c, Fiscal_Year__c, Type__c, Lenses_Gross_Sales__c, Lenses_Net_Sales__c,Lenses_Qty__c, Account__c FROM Sales_Statistics__c WHERE Account__c IN :accountList AND Fiscal_Year__c IN:yearstoBechecked';
        Map<String, List<Object>> listParams = new Map<String, List<Object>>();
        listParams.put('accountList', accountList); // Example Account Ids
        listParams.put('yearstoBechecked', new List<Integer>(yearstoBechecked)); // Example years

        String additionalConditions = ' AND (Type__c = \'0\' OR Type__c = \'1\')';
        String orderBy = 'Month__c asc';

        List<Sales_Statistics__c> allsalesLensData = (List<Sales_Statistics__c>) Utility.queryRecords(query, listParams, additionalConditions, orderBy);
        if(allsalesLensData.size() > 0){
            for(Sales_Statistics__c salesStat:allsalesLensData){
                MonthDataWrapper monWrap = new MonthDataWrapper();
                String monthName = Utility.getMonthShortName(Integer.ValueOf(salesStat.Month__c));
                if(accMonthlyData.containsKey(monthName)){
                    monWrap = accMonthlyData.get(monthName);
                }
                monWrap.monthName = monthName;
                if((Integer)salesStat.Fiscal_Year__c == CurrentFiscalyear){ 
                    if(type == 'Gross'){
                      	monWrap.salesCFY += (salesStat.Lenses_Gross_Sales__c != null) ? salesStat.Lenses_Gross_Sales__c : 0;
                    }else if(type == 'Net'){
                    	monWrap.salesCFY += (salesStat.Lenses_Net_Sales__c != null) ? salesStat.Lenses_Net_Sales__c : 0;
                    }
                    monWrap.volumeCFY += (salesStat.Lenses_Qty__c != null) ?  salesStat.Lenses_Qty__c : 0;
                }
                if((Integer)salesStat.Fiscal_Year__c == previousFiscalYear){ 
                    if(type == 'Gross'){
                        monWrap.salesLFY += (salesStat.Lenses_Gross_Sales__c != null) ? salesStat.Lenses_Gross_Sales__c : 0;
                    }else if(type == 'Net'){
                    	monWrap.salesLFY += (salesStat.Lenses_Net_Sales__c != null) ? salesStat.Lenses_Net_Sales__c : 0;
                    }
                    monWrap.volumeLFY += (salesStat.Lenses_Qty__c != null) ? salesStat.Lenses_Qty__c : 0;
                }
                accMonthlyData.put(monthName,monWrap);
            }
        }  
        List<MonthDataWrapper> finalWrapperResult = new List<MonthDataWrapper>();
        for(String label : labels){
            MonthDataWrapper monWrap = new MonthDataWrapper();
            if(!accMonthlyData.containsKey(label)){
                monWrap.monthName = label;
            }else{
                monWrap = accMonthlyData.get(label);
            }
            finalWrapperResult.add(monWrap);
        }
        return finalWrapperResult;

    }
    @AuraEnabled(cacheable=true)
    public static List<AccountRelatedSales> getRelatedSalesList(Id recordId,String type){
        String EndConsumerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
        List<AccountRelatedSales> relatedAccountList =new List<AccountRelatedSales>(); 
        try {
            String parentId = '';
            Map<Id,String> hoyaAccIdMap = new Map<Id,String>();
            List<Account> accounts=[select Id,parentId,Hoya_Account_ID__c from account where id=:recordId];
            if(accounts.size() > 0){
                parentId = accounts[0].parentId;
                hoyaAccIdMap.put(accounts[0].Id,accounts[0].Hoya_Account_ID__c);
            }
            /* current account */
            Set<Id> accountIdLst =new Set<Id>();
            accountIdLst.add(recordId);
            
           	List<Account> childAccList=[select Id,Hoya_Account_ID__c from Account where parentid=:recordId AND RecordTypeId !=: EndConsumerRecordType];
            if(childAccList.size() > 0){
                for(Account acc:childAccList){
                    accountIdLst.add(acc.Id);
                    hoyaAccIdMap.put(acc.Id,acc.Hoya_Account_ID__c);
                }
        	}
            if(parentId != null){
                List<Account> parentsSiblingsList = [select id,Hoya_Account_ID__c from account where (parentid=:parentId or id=:parentId) AND RecordTypeId !=: EndConsumerRecordType ];
                 if(parentsSiblingsList.size() > 0){
                    for(Account acc:parentsSiblingsList){
                        accountIdLst.add(acc.Id);
                        hoyaAccIdMap.put(acc.Id,acc.Hoya_Account_ID__c);
                    }
                }
            }
            Map<Id,Last_Sales_Statistics__c> accountSalesMap = new Map<Id,Last_Sales_Statistics__c>();
            List<Last_Sales_Statistics__c> lastSalesLst = [select Account__c,Hoya_Account_Id__c,Lenses_Net_Sales_CFY__c,Lenses_Gross_Sales_CFY__c,Lenses_Net_Sales_LFY_YTD__c,Lenses_Gross_Sales_LFY_YTD__c,Lenses_Net_Sales_CFY_vs_LFY_YTD__c,Lenses_Gross_Sales_CFY_vs_LFY_YTD__c,Lenses_Qty_CFY__c,Lenses_Qty_LFY_YTD__c,Lenses_Qty_CFY_vs_LFY_YTD__c from Last_Sales_Statistics__c where Account__c in :accountIdLst];
            if(lastSalesLst.size() > 0){  
                for(Last_Sales_Statistics__c sale:lastSalesLst){
                    accountSalesMap.put(sale.Account__c,sale);
                }
            }
            
            AccountRelatedSales totalSales = new AccountRelatedSales();
            totalSales.salesCFY = 0;
            totalSales.salesLFYYTD = 0;
            totalSales.volumesCFY = 0;
            totalSales.volumesLFYYTD = 0;
            for(Id account:accountIdLst){
                AccountRelatedSales relatedSales=new AccountRelatedSales();                    
                relatedSales.AccountId = account ;
                relatedSales.hoyaAccountId = hoyaAccIdMap.get(account); 
                if(accountSalesMap.size() > 0 && accountSalesMap.containskey(account)){
                    if(type == 'Net'){
                        relatedSales.salesCFY = accountSalesMap.get(account).Lenses_Net_Sales_CFY__c;
                        relatedSales.salesLFYYTD = accountSalesMap.get(account).Lenses_Net_Sales_LFY_YTD__c;
                        relatedSales.variationSales = accountSalesMap.get(account).Lenses_Net_Sales_CFY_vs_LFY_YTD__c;
                        totalSales.salesCFY +=  accountSalesMap.get(account).Lenses_Net_Sales_CFY__c;     
                        totalSales.salesLFYYTD += accountSalesMap.get(account).Lenses_Net_Sales_LFY_YTD__c;
                    }
                    else{
                        relatedSales.salesCFY = accountSalesMap.get(account).Lenses_Gross_Sales_CFY__c;
                        relatedSales.salesLFYYTD = accountSalesMap.get(account).Lenses_Gross_Sales_LFY_YTD__c;
                        relatedSales.variationSales = accountSalesMap.get(account).Lenses_Gross_Sales_CFY_vs_LFY_YTD__c;
                        totalSales.salesCFY +=  accountSalesMap.get(account).Lenses_Gross_Sales_CFY__c;   
                        totalSales.salesLFYYTD += accountSalesMap.get(account).Lenses_Gross_Sales_LFY_YTD__c;
                    }                   
                    relatedSales.volumesLFYYTD =  accountSalesMap.get(account).Lenses_Qty_LFY_YTD__c;                  
                    relatedSales.volumesCFY =  accountSalesMap.get(account).Lenses_Qty_CFY__c;
                    relatedSales.variationVolumes = accountSalesMap.get(account).Lenses_Qty_CFY_vs_LFY_YTD__c;
                    totalSales.volumesCFY += accountSalesMap.get(account).Lenses_Qty_CFY__c;
                    totalSales.volumesLFYYTD += accountSalesMap.get(account).Lenses_Qty_LFY_YTD__c;
                }
                else{
                    relatedSales.salesCFY = 0;
                    relatedSales.salesLFYYTD = 0;
                    relatedSales.variationSales = 0;
                    relatedSales.volumesLFYYTD  = 0;                 
                    relatedSales.volumesCFY  = 0;
                    relatedSales.variationVolumes  = 0;                        
                }
                relatedAccountList.add(relatedSales); 
            }
            if(totalSales.salesLFYYTD != 0 )
                totalSales.variationSales=(( totalSales.salesCFY- totalSales.salesLFYYTD)/ totalSales.salesLFYYTD)*100;
            else
                totalSales.variationSales=0;
            
            if(totalSales.volumesLFYYTD != 0){
                totalSales.variationVolumes =((totalSales.volumesCFY-totalSales.volumesLFYYTD)/totalSales.volumesLFYYTD)*100;
            }
            else
                totalSales.variationVolumes = 0;
            totalSales.AccountId = null;
            totalSales.hoyaAccountId = null;
            relatedAccountList.add(totalSales);
            
        } catch (Exception e) {
            LogException.log(e);
        }
       
        return relatedAccountList;
    } 
   
    @AuraEnabled(cacheable=true)
    public static Double getMonthWithSales(Id recordId){
        Double CurrentMonth;
        Integer CurrentFiscalyear = Date.today().year();
        List<Account> account =[select Account_Owner_Company__c from Account where Id =:recordId];
        List<AggregateResult> result=[SELECT Max(Month__c) month FROM Sales_Statistics__c where Account__c =: recordId and Account__r.Account_Owner_Company__c =:account[0].Account_Owner_Company__c and Fiscal_year__c=:CurrentFiscalyear];     
        if(result.size() > 0){
            CurrentMonth = (Double)result[0].get('month');
        }
        return CurrentMonth;        
    }
    
    @AuraEnabled(cacheable=true)
    public static double getLensesAnnualRevenue(Id recordId,String type){
        double annualRevenue = 0;
        List<Last_Sales_Statistics__c> sales = [select Lenses_Net_Sales_Last_12Mo__c,Lenses_Gross_Sales_Last_12Mo__c from Last_Sales_Statistics__c where Account__c =: recordId];
        if(sales.size() > 0){
            if(type == 'Net')
                annualRevenue = sales[0].Lenses_Net_Sales_Last_12Mo__c;
            else
                annualRevenue = sales[0].Lenses_Gross_Sales_Last_12Mo__c;
        }
        return annualRevenue;
    }
   
    @AuraEnabled(cacheable=true)
    public static String getCurrency(Id recordId){
        String userCurrency = UserInfo.getDefaultCurrency();
        String accountCurrency = [select currencyisocode from Account where id=:recordId].currencyIsoCode;
        if(userCurrency != accountCurrency)      
        	return accountCurrency;   
        else
            return userCurrency;
    }
    public static Double getLensValue(Map<Integer,LensSales> lensSales,Integer month,String type){
        Double result = 0;
        if(lensSales.size() > 0 && lensSales.containsKey(month)){
            if(type == 'Net'){
                result = lensSales.get(month).lensNetSales;
            }            
        }
        return result;
    }
    public static List<Object> getLensesSales(Id recordId,Boolean isBeforeLastYearNeeded,Boolean isRxNeeded){
        List<Object> lensesSalesLst;
        /*
        * determine the current fiscal year
        */
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
        if(Test.isRunningTest())
            month=testMonth;
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        Map<Integer,LensSales> MonthlyCYLensMap=new Map<Integer,LensSales>();
        Map<Integer,LensSales> MonthlyLYLensMap=new Map<Integer,LensSales>();
        Map<Integer,LensSales> MonthlyNYLensMap=new Map<Integer,LensSales>();
        Map<Integer,RxAndStockSales> RxMapCY=new Map<Integer,RxAndStockSales>();
        Map<Integer,RxAndStockSales> StockMapCY=new Map<Integer,RxAndStockSales>();
        Map<Integer,RxAndStockSales> RxMapLY=new Map<Integer,RxAndStockSales>();
        Map<Integer,RxAndStockSales> StockMapLY=new Map<Integer,RxAndStockSales>();
        
        List<Sales_Statistics__c> salesLensCY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                               ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                               ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                               Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                               ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                               from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear ];
        if(isRxNeeded){
            //Prepare Rx and Stock data maps
            for(Sales_Statistics__c sales:salesLensCY){ 
                if(sales.Type__c == '0'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                    rxSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                    rxSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);
                    rxSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                    rxSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                    rxSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                    rxSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                    StockMapCY.put((Integer)sales.Month__c,rxSales);
                }
                if(sales.Type__c == '1'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.rxQty=(Integer)sales.RX_lenses_qty__c;
                    rxSales.rxShippedonSameDay=parseNullInt((Integer)sales.Total_RX_qty_shipped_same_day__c);
                    rxSales.rxShippedin1Day=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_1_day__c);
                    rxSales.rxShippedin2Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_2_days__c);
                    rxSales.rxShippedin3Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_3_days__c);
                    rxSales.rxShippedin4Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_4_days__c);
                    rxSales.rxShippedin5Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_5_days__c);
                    rxSales.rxShippedin6Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_6_days__c);
                    rxSales.rxShippedin7Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_7_days__c);
                    rxSales.rxShippedin8Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_8_days__c);
                    rxSales.rxShippedin9Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_9_days__c);
                    rxSales.rxShippedin10Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_10_days__c);
                    RxMapCY.put((Integer)sales.Month__c,rxSales);
                }
            }
        }
        List<Sales_Statistics__c> salesLensLY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                               ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                               ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                               Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                               ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                               from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-1 ];
        if(isRxNeeded){
            for(Sales_Statistics__c sales:salesLensLY){
                if(sales.Type__c == '1'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.rxQty=parseNullInt((Integer)sales.RX_lenses_qty__c);
                    rxSales.rxShippedonSameDay=parseNullInt((Integer)sales.Total_RX_qty_shipped_same_day__c);
                    rxSales.rxShippedin1Day=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_1_day__c);
                    rxSales.rxShippedin2Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_2_days__c);
                    rxSales.rxShippedin3Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_3_days__c);
                    rxSales.rxShippedin4Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_4_days__c);
                    rxSales.rxShippedin5Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_5_days__c); 
                    rxSales.rxShippedin6Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_6_days__c);
                    rxSales.rxShippedin7Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_7_days__c);
                    rxSales.rxShippedin8Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_8_days__c);
                    rxSales.rxShippedin9Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_9_days__c);
                    rxSales.rxShippedin10Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_10_days__c);
                    RxMapLY.put((Integer)sales.Month__c,rxSales);
                }
                if(sales.Type__c == '0'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                    rxSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                    rxSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);                                
                    rxSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                    rxSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                    rxSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                    rxSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                    StockMapLY.put((Integer)sales.Month__c,rxSales);
                }
            }
        }
        
        //prepare lens(sum of Rx and Stock) sales maps for each month 
        for(Sales_Statistics__c sales:salesLensCY){ 
            if(MonthlyCYLensMap.size() > 0 && MonthlyCYLensMap.containsKey((Integer)sales.Month__c))
            {
                LensSales lens = MonthlyCYLensMap.get((Integer)sales.Month__c);
                lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
            }
            else{
                LensSales lens = new LensSales();
                lens.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c);
                lens.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);    
                MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
            }
        }
        //prepare the Lens Map for last fy
        for(Sales_Statistics__c sales:salesLensLY){ 
            if(MonthlyLYLensMap.size() > 0 && MonthlyLYLensMap.containsKey((Integer)sales.Month__c))
            {
                LensSales lens = MonthlyLYLensMap.get((Integer)sales.Month__c);
                lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                MonthlyLYLensMap.put((Integer)sales.Month__c,lens); 
            }
            else{
                LensSales lens = new LensSales();
                lens.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c); 
                lens.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c); 
                MonthlyLYLensMap.put((Integer)sales.Month__c,lens);
            }
        }
        if(isBeforeLastYearNeeded){
            List<Sales_Statistics__c> salesLensNY=[SELECT Month__c,Fiscal_Year__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                   ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                   ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c, Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                   from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-2 ];
            
            //prepare lens map for N2FY
            
            for(Sales_Statistics__c sales:salesLensNY){  
                if(MonthlyNYLensMap.size() > 0 && MonthlyNYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens = MonthlyNYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens); 
                }
                else{
                    LensSales lens=new LensSales();
                    lens.lensGrossSales=parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales=parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
        }
        lensesSalesLst = new List<Object>{MonthlyCYLensMap,MonthlyLYLensMap,MonthlyNYLensMap};
        return lensesSalesLst;
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getAverageSalesList(Id recordId){
        List<Object> lensesSalesList = new List<Object>();
        lensesSalesList = getLensesSales(recordId,false,false);       
        return lensesSalesList;
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getNonAdaptationReturns(Id recordId){
        List<Object> returnsList;
 		Integer year = Date.today().year();
        Integer month = Date.today().month();
        if(Test.isRunningTest())
            month=testMonth;
        //fiscal year is current year-1 from january to April, year from may to december
        if(month <= 4){
            year = year-1;
        }
        List<Sales_Statistics__c> lensSales=[SELECT Month__c,NonAdaptationReturnsJson__c,Fiscal_Year__c,Type__c from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and (Fiscal_Year__c=:year OR Fiscal_Year__c=:year-1)];
        if(lensSales.size() > 0){
        	Map<Decimal,Sales_Statistics__c> lensSalesCyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
        	Map<Decimal,Sales_Statistics__c> lensSalesCyHoya1Map = new Map<Decimal,Sales_Statistics__c>();

            Map<Decimal,Sales_Statistics__c> lensSalesLyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
            Map<Decimal,Sales_Statistics__c> lensSalesLyHoya1Map = new Map<Decimal,Sales_Statistics__c>();
			if(lensSales.size() > 0){
                for(Sales_Statistics__c sale : lensSales){
                    if(sale.Fiscal_Year__c == year){
                        if(sale.Type__c == '0')
                            lensSalesCyHoya0Map.put(sale.Month__c,sale); 
                        else
                            lensSalesCyHoya1Map.put(sale.Month__c,sale);
                    }
                    else
                    {
                        if(sale.Type__c == '0')
                            lensSalesLyHoya0Map.put(sale.Month__c,sale); 
                        else
                            lensSalesLyHoya1Map.put(sale.Month__c,sale);
                    }
                       
                }
        	}
            //get total(stock+Rx) qty for each lenstype in each month
			Map<Integer,Map<String,Integer>> CYRetsMap=getNonAdaptationMap(lensSalesCyHoya0Map,lensSalesCyHoya1Map);
        	Map<Integer,Map<String,Integer>> LYRetsMap=getNonAdaptationMap(lensSalesLyHoya0Map,lensSalesLyHoya1Map);
            List<nonAdaptationWrapper> lensRets3MonJson = new List<nonAdaptationWrapper>(); 
            List<nonAdaptationWrapper> lensRets12MonJson = new List<nonAdaptationWrapper>();
            switch on month {               
                when  1{                       
                    List<String> monthNoList=new List<String>{'10:CY','11:CY','12:CY'};
                    List<String> twelveMonList=new List<String>{'1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);                 
                }
                when  2{
                    List<String> monthNoList=new List<String>{'11:CY','12:CY','1:CY'};
                    List<String> twelveMonList=new List<String>{'2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }  
                when  3{
                    List<String> monthNoList=new List<String>{'12:CY','1:CY','2:CY'};
                    List<String> twelveMonList=new List<String>{'3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  4{
                    List<String> monthNoList=new List<String>{'1:CY','2:CY','3:CY'};
                    List<String> twelveMonList=new List<String>{'4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY','3:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  5{
                    List<String> monthNoList=new List<String>{'2:LY','3:LY','4:CY'};
                    List<String> twelveMonList=new List<String>{'5:LY','6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  6{
                    List<String> monthNoList=new List<String>{'3:LY','4:CY','5:CY'};
                    List<String> twelveMonList=new List<String>{'6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  7{
                    List<String> monthNoList=new List<String>{'4:CY','5:CY','6:CY'};
                    List<String> twelveMonList=new List<String>{'7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList); 
                }
                when  8{
                    List<String> monthNoList=new List<String>{'5:CY','6:CY','7:CY'};
                    List<String> twelveMonList=new List<String>{'8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);              
                }
                when  9{
                    List<String> monthNoList=new List<String>{'6:CY','7:CY','8:CY'};
                    List<String> twelveMonList=new List<String>{'9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  10{
                    List<String> monthNoList=new List<String>{'7:CY','8:CY','9:CY'};
                    List<String> twelveMonList=new List<String>{'10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  11{
                    List<String> monthNoList=new List<String>{'8:CY','9:CY','10:CY'};	
                    List<String> twelveMonList=new List<String>{'11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList);
                }
                when  12{
                    List<String> monthNoList=new List<String>{'9:CY','10:CY','11:CY'};
                    List<String> twelveMonList=new List<String>{'12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY'};
                    lensRets3MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,monthNoList);
                    lensRets12MonJson = getNonAdaptationJson(CYRetsMap,LYRetsMap,twelveMonList); 
                }
                when else {
                    //Nothing to do
                } 
            }  
            returnsList = new Object[2];
            returnsList.add(0,lensRets3MonJson);          
            returnsList.add(1,lensRets12MonJson);  
        }
        return returnsList;
	}
    public static Map<Integer,Map<String,Integer>> getNonAdaptationMap(Map<Decimal,Sales_Statistics__c> Type0Map,Map<Decimal,Sales_Statistics__c> Type1Map){
        Map<String,Integer> nonAdaptationMap ;
        Map<Integer,Map<String,Integer>> nonAdaptationMonthlyMap = new Map<Integer,Map<String,Integer>>();
        if(Type0Map.size() > 0 || Type1Map.size() > 0){
              for(Integer i = 1 ; i <= 12 ; i++){ 
                  nonAdaptationMap = new Map<String,Integer>();
                  Map<String,Object> MapType0 = new Map<String,Object>();
                  Map<String,Object> MapType1 = new Map<String,Object>();
                  if(Type0Map.size() > 0 && Type0Map.containsKey(i)){
                      if(Type0Map.get(i).NonAdaptationReturnsJson__c != null){
                        MapType0  = (Map<String,Object>)JSON.deserializeUntyped(Type0Map.get(i).NonAdaptationReturnsJson__c); 
                      }  
                  }
                  if(Type1Map.size() > 0 && Type1Map.containsKey(i)){
                      if(Type1Map.get(i).NonAdaptationReturnsJson__c != null){
                        MapType1  = (Map<String,Object>)JSON.deserializeUntyped(Type1Map.get(i).NonAdaptationReturnsJson__c); 
                      }  
                  }
                  //Combine both Type0 and Type1 to single Map
                  if(MapType0.size() > 0){
                      for(String lens0Type : MapType0.keySet()){
                          Integer qty = (Integer)MapType0.get(lens0Type);
                          if(MapType1.size() > 0 && MapType1.containsKey(lens0Type)){
                              qty += Integer.valueOf(MapType1.get(lens0Type));
                          }
                          nonAdaptationMap.put(lens0Type,qty);
					  }
                  }
                  if( MapType1.size() > 0){
                     for(String lens1Type : MapType1.keySet()){
                          if(nonAdaptationMap.size() == 0 || (nonAdaptationMap.size() > 0 && !nonAdaptationMap.containsKey(lens1Type))){
                               nonAdaptationMap.put(lens1Type,Integer.valueOf(MapType1.get(lens1Type)));
                          }                       
                      }
                  }
                  nonAdaptationMonthlyMap.put(i,nonAdaptationMap);                  
              }
        }       
        return nonAdaptationMonthlyMap;
    }
    public static List<nonAdaptationWrapper> getNonAdaptationJson(Map<Integer,Map<String,Integer>> CYMap,Map<Integer,Map<String,Integer>> LYMap,List<String> monthNoList){
        String returnsJson ='';
        List<nonAdaptationWrapper> wrapperList = new List<nonAdaptationWrapper>();
        Integer totalQty = 0;
        List<Integer> CYMonList=new List<Integer>();
        List<Integer> LYMonList=new List<Integer>();
        if(monthNoList.size() > 0){
            for(String month:monthNoList){//2:CY
                if(month.substringAfter(':') == 'CY')
                    CYMonList.add(Integer.valueOf(month.substringBefore(':')));
                else
                   LYMonList.add(Integer.valueOf(month.substringBefore(':')));
            } 
        }
        Map<String,Integer> lensQtyMap = new Map<String,Integer>();
        if(CYMap != null && CYMap.size() > 0  && CYMonList.size() > 0){  
            for(Integer CYmon:CYMonList){ 
                Map<String,Integer> lensQtyTemp = new Map<String,Integer>();
                if(CYMap.containsKey(CYmon)){
                    lensQtyTemp = CYMap.get(CYmon);
                }
                if(lensQtyMap.size() > 0){
                    for(String lensType:lensQtyTemp.keySet()){
                        Integer qty = 0;
                        if(lensQtyMap.containsKey(lensType)){
                            qty = lensQtyMap.get(lensType);
                            qty += lensQtyTemp.get(lensType);
                        }
                        else{
                            qty = lensQtyTemp.get(lensType);
                        }
                        lensQtyMap.put(lensType,qty);
                    }
                }
                else{//Initial
                    lensQtyMap = lensQtyTemp;
                    if(lensQtyMap.size() > 0){
                        for(String lensType:lensQtyMap.keySet()){
                           	Integer qty = lensQtyMap.get(lensType);
                            lensQtyMap.put(lensType,qty);
                        }
                    }
                }
            }
        }
        if(LYMap != null && LYMap.size() > 0  && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){ 
                Map<String,Integer> lensQtyTemp = new Map<String,Integer>();
                if(LYMap.containsKey(LYmon)){
                    lensQtyTemp = LYMap.get(LYmon);
                }
                Set<String> allKeysSet =new Set<String>();
                allKeysSet.addAll(lensQtyTemp.keySet());
                if(lensQtyMap.size() > 0){                    
                	allKeysSet.addAll(lensQtyMap.keySet());
                    if(allKeysSet.size() > 0){
                        for(String lensType:allKeysSet){
                            Integer qty = 0;
                            if(lensQtyMap.containsKey(lensType)){
                                qty = lensQtyMap.get(lensType);
                                if(lensQtyTemp.size() > 0 && lensQtyTemp.containsKey(lensType))
                                	qty += lensQtyTemp.get(lensType);
                            }
                            else{
                                if(lensQtyTemp.size() > 0 && lensQtyTemp.containsKey(lensType))                               
                                	qty = lensQtyTemp.get(lensType);
                            }
                            lensQtyMap.put(lensType,qty);
                        } 
                    }
                }
                else{
                    lensQtyMap = lensQtyTemp;
                    if(lensQtyMap.size() > 0){
                        for(String lensType:allKeysSet){
                           	Integer qty = lensQtyMap.get(lensType);
                            lensQtyMap.put(lensType,qty);
                        }
                    }
                }                
            }
        }
        List<sortNonAdaptationWrapper> sortWrapperList = new List<sortNonAdaptationWrapper>();
        if(lensQtyMap.size() > 0){
            for(string key: lensQtyMap.keyset())
            {
                sortWrapperList.add(new sortNonAdaptationWrapper(key, lensQtyMap.get(key)));
                totalQty += lensQtyMap.get(key);
            }
            // sorting list in ascending order 
            sortWrapperList.sort();
            List<sortNonAdaptationWrapper> finalList = new List<sortNonAdaptationWrapper>();
            for(Integer i = sortWrapperList.size()-1; i>=0;i--)
            {
                finalList.add(sortWrapperList.get(i));
            }
            sortNonAdaptationWrapper wrap =new sortNonAdaptationWrapper('Total Non-Adaptation',totalQty);
			finalList.add(wrap);            
            for(sortNonAdaptationWrapper finalwrapper:finalList){
                nonAdaptationWrapper wrapper = new nonAdaptationWrapper();
                wrapper.lensType = finalwrapper.lensType;
                wrapper.qty = finalwrapper.qty;
                wrapper.qtyPerc = (wrapper.qty/totalQty)*100; 
                wrapperList.add(wrapper);
            }
    	}
        return wrapperList;
    }
    @AuraEnabled(cacheable=true)
    public static String getLensReturns(Id recordId){
        String returns='';
 		Integer year = Date.today().year();
        Integer month = Date.today().month();
        if(Test.isRunningTest())
            month=testMonth;
        //fiscal year is current year-1 from january to April, year from may to december
        if(month <= 4){
            year = year-1;
        }
        List<Sales_Statistics__c> lensSales=[SELECT LensReturnsJson__c,Lens_Returns_Sales_Json__c,Month__c,Fiscal_Year__c,Type__c from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and (Fiscal_Year__c=:year OR Fiscal_Year__c=:year-1)];
        List<Last_Sales_Statistics__c> lastSales = [SELECT Lenses_Net_Sales_Last_3Mo_CFY__c,Lenses_Net_Sales_Last_12Mo__c,Lenses_Qty_Last_3Mo_CFY__c,Lenses_Qty_LFY__c from Last_Sales_Statistics__c where Account__c =: recordId ];
        double last3MoSales = 0;
        double last12MoSales = 0;
        double last3MoQty = 0;
        double last12MoQty = 0;
        if(lastSales.size() > 0){
            if(lastSales[0].Lenses_Net_Sales_Last_3Mo_CFY__c != null)
            	last3MoSales = lastSales[0].Lenses_Net_Sales_Last_3Mo_CFY__c;
            if(lastSales[0].Lenses_Net_Sales_Last_12Mo__c != null)
            	last12MoSales = lastSales[0].Lenses_Net_Sales_Last_12Mo__c;
            if(lastSales[0].Lenses_Qty_Last_3Mo_CFY__c != null)
            	last3MoQty = lastSales[0].Lenses_Qty_Last_3Mo_CFY__c;
            if(lastSales[0].Lenses_Qty_LFY__c != null)
            	last12MoQty = lastSales[0].Lenses_Qty_LFY__c;
        }
       
        Map<Decimal,Sales_Statistics__c> lensSalesCyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
        Map<Decimal,Sales_Statistics__c> lensSalesCyHoya1Map = new Map<Decimal,Sales_Statistics__c>();

        Map<Decimal,Sales_Statistics__c> lensSalesLyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
        Map<Decimal,Sales_Statistics__c> lensSalesLyHoya1Map = new Map<Decimal,Sales_Statistics__c>();

        if(lensSales.size() > 0){
            for(Sales_Statistics__c sale : lensSales){
                if(sale.Fiscal_Year__c == year){
                    if(sale.Type__c == '0')
                        lensSalesCyHoya0Map.put(sale.Month__c,sale); 
                    else
                        lensSalesCyHoya1Map.put(sale.Month__c,sale);
                }
                else
                {
                    if(sale.Type__c == '0')
                        lensSalesLyHoya0Map.put(sale.Month__c,sale); 
                    else
                        lensSalesLyHoya1Map.put(sale.Month__c,sale);
                }
                   
            }
        }
        Map<Integer,Object> CYLensRetsMap=getLensReturnsMap(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'Qty');
        Map<Integer,Object> LYLensRetsMap=getLensReturnsMap(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'Qty');
        Map<Integer,Object> CYLensRetsSalesMap=getLensReturnsMap(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'Sales');
        Map<Integer,Object> LYLensRetsSalesMap=getLensReturnsMap(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'Sales');
        String lensRets3MonJson; 
        String lensRets12MonJson;
        String lensRetsSales3MonJson; 
        String lensRetsSales12MonJson; 
        switch on month {               
            when  1{                       
                List<String> monthNoList=new List<String>{'10:CY','11:CY','12:CY'};
                List<String> twelveMonList=new List<String>{'1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                System.debug(lensRets3MonJson+'---'+lensRets12MonJson);
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  2{
                List<String> monthNoList=new List<String>{'11:CY','12:CY','1:CY'};
                List<String> twelveMonList=new List<String>{'2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }  
            when  3{
                List<String> monthNoList=new List<String>{'12:CY','1:CY','2:CY'};
                List<String> twelveMonList=new List<String>{'3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  4{
                List<String> monthNoList=new List<String>{'1:CY','2:CY','3:CY'};
                List<String> twelveMonList=new List<String>{'4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY','3:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  5{
                List<String> monthNoList=new List<String>{'2:LY','3:LY','4:CY'};
                List<String> twelveMonList=new List<String>{'5:LY','6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  6{
                List<String> monthNoList=new List<String>{'3:LY','4:CY','5:CY'};
                List<String> twelveMonList=new List<String>{'6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  7{
                List<String> monthNoList=new List<String>{'4:CY','5:CY','6:CY'};
                List<String> twelveMonList=new List<String>{'7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty'); 
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  8{
                List<String> monthNoList=new List<String>{'5:CY','6:CY','7:CY'};
                List<String> twelveMonList=new List<String>{'8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty'); 
  				lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');                
            }
            when  9{
                List<String> monthNoList=new List<String>{'6:CY','7:CY','8:CY'};
                List<String> twelveMonList=new List<String>{'9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  10{
                List<String> monthNoList=new List<String>{'7:CY','8:CY','9:CY'};
                List<String> twelveMonList=new List<String>{'10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  11{
                List<String> monthNoList=new List<String>{'8:CY','9:CY','10:CY'};	
                List<String> twelveMonList=new List<String>{'11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty');
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when  12{
                List<String> monthNoList=new List<String>{'9:CY','10:CY','11:CY'};
                List<String> twelveMonList=new List<String>{'12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY'};
                lensRets3MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoQty,'Qty');
                lensRets12MonJson = getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoQty,'Qty'); 
                lensRetsSales3MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,monthNoList,last3MoSales,'Sales');
                lensRetsSales12MonJson = getlensRets(CYLensRetsSalesMap,LYLensRetsSalesMap,twelveMonList,last12MoSales,'Sales');
            }
            when else {
                //Nothing to do
            } 
        }  
        returns = lensRets3MonJson + lensRets12MonJson + lensRetsSales3MonJson + lensRetsSales12MonJson +'}';
        return returns;
    }
    public static lensRetsWrapper parseLensRetsJson(String lensReturnsJson){
        lensRetsWrapper wrapper=new lensRetsWrapper();
        JSONParser parser = JSON.createParser(lensReturnsJson);
        lensRetsWrapper obj = wrapper.parse(lensReturnsJson);        
        return obj;
    } 
    public static lensRetsSalesWrapper parseLensRetsSalesJson(String lensReturnsSalesJson){
        lensRetsSalesWrapper wrapper=new lensRetsSalesWrapper();
        JSONParser parser = JSON.createParser(lensReturnsSalesJson);
        lensRetsSalesWrapper obj = wrapper.parse(lensReturnsSalesJson);        
        return obj;
    } 

    public static Map<Integer,Object> getLensReturnsMap( Map<Decimal,Sales_Statistics__c> lensSalesType0Map,Map<Decimal,Sales_Statistics__c> lensSalesType1Map,String type){
        Map<Integer,Object> LensRetsMap=new Map<Integer,Object>();  
        if(lensSalesType0Map.size() > 0 || lensSalesType1Map.size() > 0){
            if(type == 'Sales'){
                for(Integer i = 1 ; i <= 12 ; i++){                 
                    lensRetsSalesWrapper lensRetSales0 = new lensRetsSalesWrapper();
                    lensRetsSalesWrapper lensRetSales1 = new lensRetsSalesWrapper();
                    if(lensSalesType0Map.size() > 0 && lensSalesType0Map.containsKey(i)){
                        if(lensSalesType0Map.get(i).Lens_Returns_Sales_Json__c != null)
                            lensRetSales0 = parseLensRetsSalesJson(lensSalesType0Map.get(i).Lens_Returns_Sales_Json__c);
                    }                   
                    if(lensSalesType1Map.size() > 0 && lensSalesType1Map.containsKey(i)){
                        if(lensSalesType1Map.get(i).Lens_Returns_Sales_Json__c != null)
                            lensRetSales1 = parseLensRetsSalesJson(lensSalesType1Map.get(i).Lens_Returns_Sales_Json__c);
                    }
                    double prodRetSales = 0;
                    double cutRetSales = 0;
                    double mountingRetSales = 0;
                    double agreementRetSales = 0;
                    double mistakeRetSales = 0;
                    double nonAdaptRetSales = 0;
                    double deliveryRetSales = 0;
                    double otherRetSales = 0;
                    if(lensRetSales0 != null){
                        prodRetSales += double.valueOf(lensRetSales0.ProdRetSales);
                        cutRetSales += double.valueOf(lensRetSales0.CutRetSales);
                        mountingRetSales += double.valueOf(lensRetSales0.MountRetSales);
                        agreementRetSales += double.valueOf(lensRetSales0.SalesRetSales);
                        mistakeRetSales += double.valueOf(lensRetSales0.OrderMisRetSales);
                        nonAdaptRetSales += double.valueOf(lensRetSales0.NonAdapRetSales);
                        deliveryRetSales += double.valueOf(lensRetSales0.DeliveryRetSales);
                        otherRetSales += double.valueOf(lensRetSales0.OtherRetSales);
                    }
                    if(lensRetSales1 != null){
                        prodRetSales += double.valueOf(lensRetSales1.ProdRetSales);
                        cutRetSales += double.valueOf(lensRetSales1.CutRetSales);
                        mountingRetSales += double.valueOf(lensRetSales1.MountRetSales);
                        agreementRetSales += double.valueOf(lensRetSales1.SalesRetSales);
                        mistakeRetSales += double.valueOf(lensRetSales1.OrderMisRetSales);
                        nonAdaptRetSales += double.valueOf(lensRetSales1.NonAdapRetSales);
                        deliveryRetSales += double.valueOf(lensRetSales1.DeliveryRetSales);
                        otherRetSales += double.valueOf(lensRetSales1.OtherRetSales);
                    }
                    lensRetsSalesWrapper totalWrapper = new lensRetsSalesWrapper();
                    totalWrapper.ProdRetSales = String.valueOf(prodRetSales);
                    totalWrapper.CutRetSales = String.valueOf(cutRetSales);
                    totalWrapper.MountRetSales = String.valueOf(mountingRetSales);
                    totalWrapper.SalesRetSales = String.valueOf(agreementRetSales);
                    totalWrapper.OrderMisRetSales = String.valueOf(mistakeRetSales);
                    totalWrapper.NonAdapRetSales = String.valueOf(nonAdaptRetSales);
                    totalWrapper.DeliveryRetSales = String.valueOf(deliveryRetSales);
                    totalWrapper.OtherRetSales = String.valueOf(otherRetSales);
                    LensRetsMap.put(i,totalWrapper); 
                }
            }
            else{
                for(Integer i = 1 ; i <= 12 ; i++){ 
                    lensRetsWrapper lensRet0 = new lensRetsWrapper();
                    lensRetsWrapper lensRet1 = new lensRetsWrapper();
                    if(lensSalesType0Map.size() > 0 && lensSalesType0Map.containsKey(i)){
                        if(lensSalesType0Map.get(i).LensReturnsJson__c != null)
                            lensRet0 = parseLensRetsJson(lensSalesType0Map.get(i).LensReturnsJson__c);  
                    }
                    if(lensSalesType1Map.size() > 0 && lensSalesType1Map.containsKey(i)){
                        if(lensSalesType1Map.get(i).LensReturnsJson__c != null)
                            lensRet1 = parseLensRetsJson(lensSalesType1Map.get(i).LensReturnsJson__c);
                    }
                    Integer prodRet = 0;
                    Integer cutRet = 0;
                    Integer mountingRet = 0;
                    Integer agreementRet = 0;
                    Integer mistakeRet = 0;
                    Integer nonAdaptRet = 0;
                    Integer deliveryRet = 0;
                    Integer otherRet = 0;
                    if(lensRet0 != null){
                        prodRet += Integer.valueOf(lensRet0.ProdRet);
                        cutRet += Integer.valueOf(lensRet0.CutRet);
                        mountingRet += Integer.valueOf(lensRet0.MountRet);
                        agreementRet += Integer.valueOf(lensRet0.SalesRet);
                        mistakeRet += Integer.valueOf(lensRet0.OrderMisRet);
                        nonAdaptRet += Integer.valueOf(lensRet0.NonAdapRet);
                        deliveryRet += Integer.valueOf(lensRet0.DeliveryRet);
                        otherRet += Integer.valueOf(lensRet0.OtherRet);
                    }
                    if(lensRet1 != null){
                        prodRet += Integer.valueOf(lensRet1.ProdRet);
                        cutRet += Integer.valueOf(lensRet1.CutRet);
                        mountingRet += Integer.valueOf(lensRet1.MountRet);
                        agreementRet += Integer.valueOf(lensRet1.SalesRet);
                        mistakeRet += Integer.valueOf(lensRet1.OrderMisRet);
                        nonAdaptRet += Integer.valueOf(lensRet1.NonAdapRet);
                        deliveryRet += Integer.valueOf(lensRet1.DeliveryRet);
                        otherRet += Integer.valueOf(lensRet1.OtherRet);
                    }
                    lensRetsWrapper totalWrapper = new lensRetsWrapper();
                    totalWrapper.ProdRet = String.valueOf(prodRet);
                    totalWrapper.CutRet = String.valueOf(cutRet);
                    totalWrapper.MountRet = String.valueOf(mountingRet);
                    totalWrapper.SalesRet = String.valueOf(agreementRet);
                    totalWrapper.OrderMisRet = String.valueOf(mistakeRet);
                    totalWrapper.NonAdapRet = String.valueOf(nonAdaptRet);
                    totalWrapper.DeliveryRet = String.valueOf(deliveryRet);
                    totalWrapper.OtherRet = String.valueOf(otherRet);
                    LensRetsMap.put(i,totalWrapper); 
                }
            }
        }
        return LensRetsMap;
    }
     
    public static String getlensRets(Map<Integer,Object> CYLensRetsMap,Map<Integer,Object> LYLensRetsMap,List<String> monthNoList,double lastMoSalesOrQty,String type){
        String lensRetsJson='';         
        Integer prodRetMon = 0;
        Integer cutRetMon = 0;
        Integer mountingRetMon = 0;
        Integer agrementRetMon = 0;
        Integer mistakeRetMon = 0;
        Integer nonAdapRetMon = 0;
        Integer deliveryRetMon = 0;
        Integer otherRetMon = 0;
        
        double prodRetMonSales = 0;
        double cutRetMonSales = 0;
        double mountingRetMonSales = 0;
        double agrementRetMonSales = 0;
        double mistakeRetMonSales = 0;
        double nonAdapRetMonSales = 0;
        double deliveryRetMonSales = 0;
        double otherRetMonSales = 0;
        
        List<Integer> CYMonList=new List<Integer>();
        List<Integer> LYMonList=new List<Integer>();
        if(monthNoList.size() > 0){
            for(String month:monthNoList){//2:CY
                if(month.substringAfter(':') == 'CY')
                    CYMonList.add(Integer.valueOf(month.substringBefore(':')));
                else
                   LYMonList.add(Integer.valueOf(month.substringBefore(':')));
            } 
        }
        if(CYLensRetsMap != null && CYLensRetsMap.size() > 0  && CYMonList.size() > 0){
            for(Integer CYmon:CYMonList){
                if(type == 'Qty'){
                    lensRetsWrapper wrapper=(lensRetsWrapper)CYLensRetsMap.get(CYmon);
                    prodRetMon += Integer.valueOf(wrapper.ProdRet) ;
                    cutRetMon += Integer.valueOf(wrapper.CutRet) ;
                    mountingRetMon += Integer.valueOf(wrapper.MountRet) ;
                    agrementRetMon += Integer.valueOf(wrapper.SalesRet) ;
                    mistakeRetMon += Integer.valueOf(wrapper.OrderMisRet) ;
                    nonAdapRetMon += Integer.valueOf(wrapper.NonAdapRet) ;
                    deliveryRetMon += Integer.valueOf(wrapper.DeliveryRet) ;
                    otherRetMon += Integer.valueOf(wrapper.OtherRet) ;    
                }else{
                    lensRetsSalesWrapper wrapper=(lensRetsSalesWrapper)CYLensRetsMap.get(CYmon);
                    prodRetMonSales += double.valueOf(wrapper.ProdRetSales) ;
                    cutRetMonSales += double.valueOf(wrapper.CutRetSales) ;
                    mountingRetMonSales += double.valueOf(wrapper.MountRetSales) ;
                    agrementRetMonSales += double.valueOf(wrapper.SalesRetSales) ;
                    mistakeRetMonSales += double.valueOf(wrapper.OrderMisRetSales) ;
                    nonAdapRetMonSales += double.valueOf(wrapper.NonAdapRetSales) ;
                    deliveryRetMonSales += double.valueOf(wrapper.DeliveryRetSales) ;
                    otherRetMonSales += double.valueOf(wrapper.OtherRetSales) ;  
                }
            }
        }
        if(LYLensRetsMap != null && LYLensRetsMap.size() > 0  && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){
                if(type == 'Qty'){
                    lensRetsWrapper wrapper=(lensRetsWrapper)LYLensRetsMap.get(LYmon);
                    prodRetMon += Integer.valueOf(wrapper.ProdRet) ;
                    cutRetMon += Integer.valueOf(wrapper.CutRet) ;
                    mountingRetMon += Integer.valueOf(wrapper.MountRet) ;
                    agrementRetMon += Integer.valueOf(wrapper.SalesRet) ;
                    mistakeRetMon += Integer.valueOf(wrapper.OrderMisRet) ;
                    nonAdapRetMon += Integer.valueOf(wrapper.NonAdapRet) ;
                    deliveryRetMon += Integer.valueOf(wrapper.DeliveryRet) ;
                    otherRetMon += Integer.valueOf(wrapper.OtherRet) ; 
                }else{
                    lensRetsSalesWrapper wrapper=(lensRetsSalesWrapper)LYLensRetsMap.get(LYmon);
                    prodRetMonSales += double.valueOf(wrapper.ProdRetSales) ;
                    cutRetMonSales += double.valueOf(wrapper.CutRetSales) ;
                    mountingRetMonSales += double.valueOf(wrapper.MountRetSales) ;
                    agrementRetMonSales += double.valueOf(wrapper.SalesRetSales) ;
                    mistakeRetMonSales += double.valueOf(wrapper.OrderMisRetSales) ;
                    nonAdapRetMonSales += double.valueOf(wrapper.NonAdapRetSales) ;
                    deliveryRetMonSales += double.valueOf(wrapper.DeliveryRetSales) ;
                    otherRetMonSales += double.valueOf(wrapper.OtherRetSales) ; 
                }
            }
        }
        lensRetsWrapper lensRet=new lensRetsWrapper();
        lensRetsSalesWrapper lensRetSales=new lensRetsSalesWrapper();
        if(type == 'Qty'){           
            lensRet.ProdRet=String.valueOf(prodRetMon);
            lensRet.CutRet=String.valueOf(cutRetMon);
            lensRet.MountRet=String.valueOf(mountingRetMon);
            lensRet.SalesRet=String.valueOf(agrementRetMon);
            lensRet.OrderMisRet=String.valueOf(mistakeRetMon);
            lensRet.NonAdapRet=String.valueOf(nonAdapRetMon);
            lensRet.DeliveryRet=String.valueOf(deliveryRetMon);
            lensRet.OtherRet=String.valueOf(otherRetMon);
        }else{            
            lensRetSales.ProdRetSales=String.valueOf(prodRetMonSales);
            lensRetSales.CutRetSales=String.valueOf(cutRetMonSales);
            lensRetSales.MountRetSales=String.valueOf(mountingRetMonSales);
            lensRetSales.SalesRetSales=String.valueOf(agrementRetMonSales);
            lensRetSales.OrderMisRetSales=String.valueOf(mistakeRetMonSales);
            lensRetSales.NonAdapRetSales=String.valueOf(nonAdapRetMonSales);
            lensRetSales.DeliveryRetSales=String.valueOf(deliveryRetMonSales);
            lensRetSales.OtherRetSales=String.valueOf(otherRetMonSales);
        }
        
        double prodRetPerc = 0;
        double cutRetPerc = 0;
        double mountingRetPerc = 0;
        double salesRetperc = 0;
        double orderingRetPerc = 0;
        double nonadapRetPerc = 0;
        double deliveryRetPerc = 0;
        double otherRetPerc = 0;
        double totalProdRetPerc = 0;
        double totalNonProdRetPerc = 0;
        double totalRetPerc = 0;
         //Calculate Percenatges
       
       
         if(type == 'Qty'){ 
             double totalProdRet = prodRetMon+cutRetMon+mountingRetMon;
             double totalNonProdRet = agrementRetMon+mistakeRetMon+nonAdapRetMon+deliveryRetMon+otherRetMon;
             double totalCount = lastMoSalesOrQty+totalProdRet+totalNonProdRet;
             if(totalCount != 0){
                 prodRetPerc = (prodRetMon/totalCount)*100;
                 cutRetPerc  = (cutRetMon/totalCount)*100;
                 mountingRetPerc = (mountingRetMon/totalCount)*100;   
                 salesRetperc = (agrementRetMon/totalCount)*100;
                 orderingRetPerc = (mistakeRetMon/totalCount)*100;
                 nonadapRetPerc = (nonAdapRetMon/totalCount)*100;
                 deliveryRetPerc = (deliveryRetMon/totalCount)*100;
                 otherRetPerc = (otherRetMon/totalCount)*100;
                 totalProdRetPerc = (totalProdRet/totalCount)*100;
                 totalNonProdRetPerc = (totalNonProdRet/totalCount)*100;
                 totalRetPerc = ((totalProdRet+totalNonProdRet)/totalCount)*100;
             }
         }
         else{
             double totalProdRet = prodRetMonSales+cutRetMonSales+mountingRetMonSales;
             double totalNonProdRet = agrementRetMonSales+mistakeRetMonSales+nonAdapRetMonSales+deliveryRetMonSales+otherRetMonSales;
             double totalCount = lastMoSalesOrQty+totalProdRet+totalNonProdRet;
             if(totalCount != 0){
                 prodRetPerc = (prodRetMonSales/totalCount)*100;
                 cutRetPerc  = (cutRetMonSales/totalCount)*100;
                 mountingRetPerc = (mountingRetMonSales/totalCount)*100;   
                 salesRetperc = (agrementRetMonSales/totalCount)*100;
                 orderingRetPerc = (mistakeRetMonSales/totalCount)*100;
                 nonadapRetPerc = (nonAdapRetMonSales/totalCount)*100;
                 
                 deliveryRetPerc = (deliveryRetMonSales/totalCount)*100;
                 otherRetPerc = (otherRetMonSales/totalCount)*100;
                 totalProdRetPerc = (totalProdRet/totalCount)*100;
                 totalNonProdRetPerc = (totalNonProdRet/totalCount)*100;
                 totalRetPerc = ((totalProdRet+totalNonProdRet)/totalCount)*100;
            }
        } 
        //String lensRetsJson='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        if(monthNoList.size() == 3){
            if(type == 'Qty')
               lensRetsJson = '{\"ProdRet3\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRet3\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRet3\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRet3\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRet3\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRet3\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRet3\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRet3\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRet3\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRet3\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRet3\":\"'+String.valueOf(totalRetPerc)+'\"';
			else
               lensRetsJson = ',\"ProdRetSales3\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRetSales3\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRetSales3\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRetSales3\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRetSales3\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRetSales3\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRetSales3\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRetSales3\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRetSales3\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRetSales3\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRetSales3\":\"'+String.valueOf(totalRetPerc)+'\"';
        }
        else{
            if(type == 'Qty')
                 lensRetsJson = ',\"ProdRet12\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRet12\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRet12\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRet12\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRet12\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRet12\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRet12\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRet12\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRet12\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRet12\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRet12\":\"'+String.valueOf(totalRetPerc)+'\"';
			else
                 lensRetsJson = ',\"ProdRetSales12\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRetSales12\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRetSales12\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRetSales12\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRetSales12\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRetSales12\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRetSales12\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRetSales12\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRetSales12\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRetSales12\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRetSales12\":\"'+String.valueOf(totalRetPerc)+'\"';
        }
        return lensRetsJson;
    }
	public class lensRetsWrapper{
        public String ProdRet; 
        public String CutRet;   
        public String MountRet; 
        public String SalesRet; 
        public String OrderMisRet;  
        public String NonAdapRet;   
        public String DeliveryRet; 
        public String OtherRet;
        public lensRetsWrapper(){
            ProdRet = '0';
            CutRet = '0';
            MountRet = '0';
            SalesRet = '0';
            OrderMisRet = '0';
            NonAdapRet = '0';
            DeliveryRet = '0';
            OtherRet = '0';
        }
        public lensRetsWrapper parse(String json){
            return (lensRetsWrapper) System.JSON.deserialize(json, lensRetsWrapper.class);
        }
    }
    public class lensRetsSalesWrapper{
        public String ProdRetSales; 
        public String CutRetSales;   
        public String MountRetSales; 
        public String SalesRetSales; 
        public String OrderMisRetSales;  
        public String NonAdapRetSales;   
        public String DeliveryRetSales; 
        public String OtherRetSales;
        public lensRetsSalesWrapper(){
            ProdRetSales = '0';
            CutRetSales = '0';
            MountRetSales = '0';
            SalesRetSales = '0';
            OrderMisRetSales = '0';
            NonAdapRetSales = '0';
            DeliveryRetSales = '0';
            OtherRetSales = '0';
        }
        public lensRetsSalesWrapper parse(String json){
            return (lensRetsSalesWrapper) System.JSON.deserialize(json, lensRetsSalesWrapper.class);
        }
    }
    public class nonAdaptationWrapper{
        @AuraEnabled public String lensType{get;set;}
        @AuraEnabled public double qty{get;set;}
        @AuraEnabled public double qtyPerc{get;set;}
    }
    public class sortNonAdaptationWrapper implements Comparable{
        public String lensType;
        public Integer qty;
        public sortNonAdaptationWrapper(String lensType,Integer qty){
            this.lensType = lensType;
            this.qty = qty;
        }
        public integer compareTo(Object other) {
        	// for descending order
      		return qty-((sortNonAdaptationWrapper)other).qty;
  		}
    }
    public static Double parseNull(Double num){
        Double result=0;
        if(num == null)
            result =0.0;
        else
            result=num;
        return result;            
    }
    public static Integer parseNullInt(Integer num){
        Integer result=0;
        if(num == null)
            result =0;
        else
            result=num;       
        return result;            
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> getAccountDataPillList(String searchKey, String objectApiName){
        List<sObject> sObjectList = new List<sObject>();
        if(String.isBlank(searchKey)){
            return sObjectList;
        }else{
            String key = '%' + searchKey + '%';
            String query = 'SELECT Id, Name, Hoya_Account_Id__c, Owner.Name, Shop_City__c, Shop_Postal_Code__c FROM ' + objectApiName + ' WHERE Name LIKE : key ORDER BY Name ASC LIMIT 5';
            sObjectList = Database.query(query, AccessLevel.USER_MODE);
            return sObjectList; 
        }
    }

    @AuraEnabled(cacheable=false)
    public static void CreateSFDCV2Task(String subject, String whatid, String instruction, String assignedTo, Date duedate, String status, String suggestion){
        String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
        Task t = new Task(
            Subject = subject,
            WhatId = whatid,
            Description = instruction,
            OwnerId = assignedTo,
            ActivityDate = duedate,
            Status = status,
            Instructions__c = suggestion,
            RecordTypeId = StandardHoyatask
        );
        insert t;
    }
    
    public class MonthDataWrapper{
        @AuraEnabled public String monthName{get;set;}
        @AuraEnabled public double salesCFY{get;set;}
        @AuraEnabled public double volumeCFY{get;set;}
        @AuraEnabled public double salesLFY{get;set;}
        @AuraEnabled public double volumeLFY{get;set;}
         public monthDataWrapper() {
            this.monthName = '';
            this.salesCFY = 0.0;
            this.volumeCFY = 0.0;
            this.salesLFY = 0.0;
            this.volumeLFY = 0.0;
        }
    }

}