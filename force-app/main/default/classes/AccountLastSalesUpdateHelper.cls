public class AccountLastSalesUpdateHelper {
    public AccountLastSalesUpdateHelper(){
        
    }
    public class LensSales{
        public LensSales(){
            lensGrossSales = 0;
            lensNetSales = 0;
            lensQty = 0;
        }
        public double lensGrossSales{get;set;}
        public double lensNetSales{get;set;}
        public Integer lensQty{get;set;}
        public Integer remoteEdgingQty{get;set;}     
    }
    public class SalesData{
        public Double lensNetSales{get;set;}
        public Double lensGrossSales{get;set;}
        public Double framesNetSales{get;set;}
        public Double framesGrossSales{get;set;}
        public Double instrumentsNetSales{get;set;}
        public Double instrumentsGrossSales{get;set;}
        public Double otherNetSales{get;set;}
        public Double otherGrossSales{get;set;}    
        public Double contactLensGrossSales{get;set;}
        public Double contactLensNetSales{get;set;}
        public Double contactLensQty{get;set;}
        public Integer lensQty{get;set;}
        public Integer framesQty{get;set;}
        public Integer instrumentsQty{get;set;}
        public Integer OthersQty{get;set;}
        
        public SalesData(){
            lensNetSales=0;
            lensGrossSales=0;
            framesNetSales=0;
            framesGrossSales=0;
            instrumentsNetSales=0;
            instrumentsGrossSales=0;
            otherNetSales=0;
            otherGrossSales=0;   
            contactLensGrossSales = 0;
            contactLensNetSales = 0;
            contactLensQty = 0;
            lensQty=0;
            framesQty=0;
            instrumentsQty=0;
            OthersQty=0;    
        }
    }
     //Wrapper class to store Rx ans Stock details
    public class RxAndStockSales{  
        public Integer rxQty{get;set;}
        public Integer stockQty{get;set;}
        public Integer stockShippedonSameDay{get;set;}
        public Integer stockShippedin1Day{get;set;}
        public Integer stockShippedin2Days{get;set;}
        public Integer stockShippedin3Days{get;set;}
        public Integer stockShippedin4Days{get;set;}
        public Integer stockShippedin5Days{get;set;}
        public Integer rxShippedonSameDay{get;set;}
        public Integer rxShippedin1Day{get;set;}
        public Integer rxShippedin2Days{get;set;}
        public Integer rxShippedin3Days{get;set;}
        public Integer rxShippedin4Days{get;set;}
        public Integer rxShippedin5Days{get;set;}
        public Integer rxShippedin6Days{get;set;}
        public Integer rxShippedin7Days{get;set;}
        public Integer rxShippedin8Days{get;set;}
        public Integer rxShippedin9Days{get;set;}
        public Integer rxShippedin10Days{get;set;}
        public RxAndStockSales(){
            rxQty = 0;
            stockQty = 0;
            stockShippedonSameDay = 0;
            stockShippedin1Day = 0;
            stockShippedin2Days = 0;
            stockShippedin3Days = 0;
            stockShippedin4Days = 0;
            stockShippedin5Days = 0;
            rxShippedonSameDay = 0;
            rxShippedin1Day = 0;
            rxShippedin2Days = 0;
            rxShippedin3Days = 0;
            rxShippedin4Days = 0;
            rxShippedin5Days = 0;
            rxShippedin6Days = 0;
            rxShippedin7Days = 0;
            rxShippedin8Days = 0;
            rxShippedin9Days = 0;
            rxShippedin10Days = 0;            
        }
    }
    public List<Last_Sales_Statistics__c> getLastSalesObject(List<Account> accs){
        List<Last_Sales_Statistics__c> lastSalesStatisticsList = new List<Last_Sales_Statistics__c>();
        Integer CurrentFiscalyear = Date.today().year();
		Integer month = Date.today().month();
       
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        System.debug(accs.size());
        //Query the Sales statistics for the passed accs for all types and all the Fiscal years required
        List<Sales_Statistics__c> salesStatistics=[SELECT Account__c,Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,Instrument_Gross_Sales__c,Instrument_Net_Sales__c,
                                                   Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c
                                                 from Sales_Statistics__c where Account__c in:accs AND (Fiscal_Year__c =:CurrentFiscalyear OR Fiscal_Year__c =:CurrentFiscalyear-1 OR(Fiscal_Year__c =:CurrentFiscalyear-2 AND (Month__c =1 OR Month__c =2 OR Month__c = 3))) ORDER BY Account__c,Fiscal_Year__c,Month__c desc];
        Map<Id,Map<double,SalesData>> accStatisticsCYMap = new Map<Id,Map<double,SalesData>>(); 
        Map<Id,Map<double,SalesData>> accStatisticsLYMap = new Map<Id,Map<double,SalesData>>();    
        Map<Id,Map<double,SalesData>> accStatisticsNYMap = new Map<Id,Map<double,SalesData>>(); 
        Map<Id,Map<double,LensSales>> accLensesCYMap = new Map<Id,Map<double,LensSales>>(); 
        Map<Id,Map<double,LensSales>> accLensesLYMap = new Map<Id,Map<double,LensSales>>();
        Map<Id,Map<double,LensSales>> accLensesNYMap = new Map<Id,Map<double,LensSales>>();
        Map<Id,Map<double,RxAndStockSales>> rxLensCYMap =new Map<Id,Map<double,RxAndStockSales>>();
        Map<Id,Map<double,RxAndStockSales>> stockLensCYMap =new Map<Id,Map<double,RxAndStockSales>>();
        Map<Id,Map<double,RxAndStockSales>> rxLensLYMap =new Map<Id,Map<double,RxAndStockSales>>();
        Map<Id,Map<double,RxAndStockSales>> stockLensLYMap =new Map<Id,Map<double,RxAndStockSales>>();
      
        //split the data based on FiscalYear andalso prepare lens data for each Account
        if(salesStatistics.size() > 0){
            for(Sales_Statistics__c sales:salesStatistics){  
                if(sales.Fiscal_Year__c == CurrentFiscalyear){
                    Map<double,SalesData> monthlySalesMap ;
                    //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        Map<double,LensSales> monthlyLensMap;
                        if(accStatisticsCYMap.size() > 0 && accStatisticsCYMap.containsKey(sales.Account__c) ){
                            if(accLensesCYMap.size() > 0 && accLensesCYMap.containsKey(sales.Account__c)){
                                monthlyLensMap = accLensesCYMap.get(sales.Account__c);
                                monthlySalesMap = accStatisticsCYMap.get(sales.Account__c);
                                if(monthlyLensMap.containsKey(sales.Month__c) && monthlySalesMap.containsKey(sales.Month__c)){
                                    LensSales lensSale=getLensTotalSales(sales,monthlyLensMap.get(sales.Month__c));
                                    SalesData data = monthlySalesMap.get(sales.Month__c);
                                    if(lensSale != null){
                                        LensSales lensData = lensSale;
                                        data.lensNetSales = lensData.lensNetSales;
                                        data.lensGrossSales  = lensData.lensGrossSales;
                                        data.lensQty = lensData.lensQty;
                                        monthlyLensMap.put(sales.Month__c,lensData);
                                        monthlySalesMap.put(sales.Month__c,data);
                                    }
                                    accLensesCYMap.put(sales.Account__c,monthlyLensMap);
                                    accStatisticsCYMap.put(sales.Account__c,monthlySalesMap);
                                }
                                else{
                                    monthlyLensMap = accLensesCYMap.get(sales.Account__c);
                                    monthlySalesMap = accStatisticsCYMap.get(sales.Account__c);
                                    LensSales lensSale=getLensTotalSales(sales,null); 
                                    SalesData data;
                                    if(monthlySalesMap.containskey(sales.Month__c))
                                        data=monthlySalesMap.get(sales.Month__c);
                                    else
                                        data = new SalesData();
                                    if(lensSale != null){
                                        LensSales lensData = lensSale;
                                        data.lensNetSales =  lensData.lensNetSales;
                                        data.lensGrossSales  = lensData.lensGrossSales;
                                        data.lensQty = lensData.lensQty;
                                        monthlyLensMap.put(sales.Month__c,lensData);
                                        monthlySalesMap.put(sales.Month__c,data);
                                    }
                                    accLensesCYMap.put(sales.Account__c,monthlyLensMap);
                                    accStatisticsCYMap.put(sales.Account__c,monthlySalesMap);
                                }
                            }
                            else{
                                monthlyLensMap = new Map<double,LensSales>();
                                monthlySalesMap = accStatisticsCYMap.get(sales.Account__c);
                                LensSales lensSale=getLensTotalSales(sales,null); 
                                SalesData data;
                                if(monthlySalesMap.containskey(sales.Month__c))
                                	data=monthlySalesMap.get(sales.Month__c);
                                else
                                    data = new SalesData();
                                if(lensSale != null){
                                    LensSales lensData = lensSale;
                                    data.lensNetSales =  lensData.lensNetSales;
                                    data.lensGrossSales  = lensData.lensGrossSales;
                                    data.lensQty = lensData.lensQty;
                                    monthlyLensMap.put(sales.Month__c,lensData);
                                    monthlySalesMap.put(sales.Month__c,data);
                                }
                                accLensesCYMap.put(sales.Account__c,monthlyLensMap);
                                accStatisticsCYMap.put(sales.Account__c,monthlySalesMap);
                            }
                        }
                        else{
                            monthlyLensMap = new Map<double,LensSales>();
                            monthlySalesMap =new Map<double,SalesData>();
                            LensSales lensSale=getLensTotalSales(sales,null); 
                            SalesData data=new SalesData();
                            if(lensSale != null){
                                LensSales lensData = lensSale;
                                data.lensNetSales = lensData.lensNetSales;
                                data.lensGrossSales  = lensData.lensGrossSales;
                                data.lensQty = lensData.lensQty;
                                monthlyLensMap.put(sales.Month__c,lensData);
                                monthlySalesMap.put(sales.Month__c,data);
                            }
                            accLensesCYMap.put(sales.Account__c,monthlyLensMap);
                            accStatisticsCYMap.put(sales.Account__c,monthlySalesMap);
                        }
                        //get RxandStockLens
                        Map<double,RxAndStockSales> monthLensMap;
                        if(sales.Type__c == '0'){
                            if(stockLensCYMap.size() > 0 && stockLensCYMap.containsKey(sales.Account__c)){
                                monthLensMap = stockLensCYMap.get(sales.Account__c);
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                stockLensCYMap.put(sales.Account__c,monthLensMap);
                            }
                            else
                            {
                                monthLensMap = new Map<double,RxAndStockSales>();
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                stockLensCYMap.put(sales.Account__c,monthLensMap);
                            }
                            System.debug(stockLensCYMap);
                        }
                        else{//Type=1
                            if(rxLensCYMap.size() > 0 && rxLensCYMap.containsKey(sales.Account__c)){
                                monthLensMap = rxLensCYMap.get(sales.Account__c);
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                rxLensCYMap.put(sales.Account__c,monthLensMap);
                            }
                            else{
                                monthLensMap = new Map<double,RxAndStockSales>();
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                rxLensCYMap.put(sales.Account__c,monthLensMap);
                            }
                        }
                        System.debug(rxLensCYMap);
                    }
                    //For other than lenses
                    else{
                        if(accStatisticsCYMap.size() > 0 && accStatisticsCYMap.containsKey(sales.Account__c)){
                            Map<double,SalesData> salesMap = accStatisticsCYMap.get(sales.Account__c);
                            if(salesMap.containsKey(sales.Month__c)){
                                SalesData salesDataObj = salesMap.get(sales.Month__c);
                                if(sales.Type__c == '3'){
                                    salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                    salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                                    salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                                }
                                else if(sales.Type__c == '4'){
                                    salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                    salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                    salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                                }
                                else if(sales.Type__c == '9'){
                                    salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                    salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                    salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                                }
                                else{
                                    salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                    salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                                    salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                                }
                                salesMap.put(sales.Month__c,salesDataObj);
                                accStatisticsCYMap.put(sales.Account__c,salesMap);
                            }
                        }
                        else
                        {
                            Map<double,SalesData> salesMap =new Map<double,SalesData>();
                            SalesData salesDataObj = new SalesData();
                            if(sales.Type__c == '3'){
                                salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                                salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                            }
                            else if(sales.Type__c == '4'){
                                salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                            }
                            else if(sales.Type__c == '9'){
                                salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                            }
                            else{
                                salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                                salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                            }
                            salesMap.put(sales.Month__c,salesDataObj);
                            accStatisticsCYMap.put(sales.Account__c,salesMap);
                        }
                    }
                    system.debug('CY'+accStatisticsCYMap);
                }
                else if(sales.Fiscal_Year__c == CurrentFiscalyear - 1){
                    Map<double,SalesData> monthlySalesMap;
                    //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        Map<double,LensSales> monthlyLensMap;
                        if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(sales.Account__c) ){
                            if(accLensesLYMap.size() > 0 && accLensesLYMap.containsKey(sales.Account__c)){
                                monthlyLensMap = accLensesLYMap.get(sales.Account__c);
                                System.debug(monthlyLensMap);
                                monthlySalesMap = accStatisticsLYMap.get(sales.Account__c);
                                if(monthlyLensMap.containsKey(sales.Month__c) && monthlySalesMap.containsKey(sales.Month__c)){
                                    LensSales lensSale=getLensTotalSales(sales,monthlyLensMap.get(sales.Month__c)); 
                                    SalesData data = monthlySalesMap.get(sales.Month__c);
                                    if(lensSale != null){
                                        LensSales lensData = lensSale;
                                        data.lensNetSales =  lensData.lensNetSales;
                                        data.lensGrossSales  = lensData.lensGrossSales;
                                        data.lensQty = lensData.lensQty;
                                        monthlyLensMap.put(sales.Month__c,lensData);
                                        monthlySalesMap.put(sales.Month__c,data);
                                    }
                                    accLensesLYMap.put(sales.Account__c,monthlyLensMap);
                                    accStatisticsLYMap.put(sales.Account__c,monthlySalesMap);
                                }
                                else{
                                    monthlyLensMap = accLensesLYMap.get(sales.Account__c);
                                    monthlySalesMap = accStatisticsLYMap.get(sales.Account__c);
                                    LensSales lensSale=getLensTotalSales(sales,null); 
                                    SalesData data;
                                    if(monthlySalesMap.containskey(sales.Month__c))
                                        data=monthlySalesMap.get(sales.Month__c);
                                    else
                                        data = new SalesData();
                                    if(lensSale != null){
                                        LensSales lensData = lensSale;
                                        data.lensNetSales =  lensData.lensNetSales;
                                        data.lensGrossSales  = lensData.lensGrossSales;
                                        data.lensQty = lensData.lensQty;
                                        monthlyLensMap.put(sales.Month__c,lensData);
                                        monthlySalesMap.put(sales.Month__c,data);
                                    }
                                    accLensesLYMap.put(sales.Account__c,monthlyLensMap);
                                    accStatisticsLYMap.put(sales.Account__c,monthlySalesMap);
                                }
                            }
                            else{
                                monthlyLensMap = new Map<double,LensSales>();
                                monthlySalesMap = accStatisticsLYMap.get(sales.Account__c);
                                LensSales lensSale=getLensTotalSales(sales,null); 
                                SalesData data;
                                if(monthlySalesMap.containskey(sales.Month__c))
                                	data=monthlySalesMap.get(sales.Month__c);
                                else
                                    data = new SalesData();
                                if(lensSale != null){
                                    LensSales lensData = lensSale;
                                    data.lensNetSales =  lensData.lensNetSales;
                                    data.lensGrossSales  = lensData.lensGrossSales;
                                    data.lensQty = lensData.lensQty;
                                    monthlyLensMap.put(sales.Month__c,lensData);
                                    monthlySalesMap.put(sales.Month__c,data);
                                }
                                accLensesLYMap.put(sales.Account__c,monthlyLensMap);
                                accStatisticsLYMap.put(sales.Account__c,monthlySalesMap);
                            }
                        }
                        else{
                            monthlyLensMap = new Map<double,LensSales>();
                            monthlySalesMap =new Map<double,SalesData>();
                            LensSales lensSale=getLensTotalSales(sales,null);
                            SalesData data=new SalesData();
                            if(lensSale != null){
                                LensSales lensData = lensSale;
                                data.lensNetSales =  lensData.lensNetSales;
                                data.lensGrossSales  = lensData.lensGrossSales;
                                data.lensQty = lensData.lensQty;
                                monthlyLensMap.put(sales.Month__c,lensData);
                                monthlySalesMap.put(sales.Month__c,data);
                            }
                            accLensesLYMap.put(sales.Account__c,monthlyLensMap);
                            accStatisticsLYMap.put(sales.Account__c,monthlySalesMap);
                        }                  
                        //get RxandStockLens
                        Map<double,RxAndStockSales> monthLensMap;
                        if(sales.Type__c == '0'){
                            if(stockLensLYMap.size() > 0 && stockLensLYMap.containsKey(sales.Account__c)){
                                monthLensMap = stockLensLYMap.get(sales.Account__c);
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                stockLensLYMap.put(sales.Account__c,monthLensMap);
                            }
                            else
                            {
                                monthLensMap = new Map<double,RxAndStockSales>();
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                stockLensLYMap.put(sales.Account__c,monthLensMap);
                            }
                        }
                        else{//Type=1
                            if(rxLensLYMap.size() > 0 && rxLensLYMap.containsKey(sales.Account__c)){
                                monthLensMap = rxLensLYMap.get(sales.Account__c);
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                rxLensLYMap.put(sales.Account__c,monthLensMap);
                            }
                            else{
                                monthLensMap = new Map<double,RxAndStockSales>();
                                RxAndStockSales lenssales = getRxandStockLenses(sales);
                                monthLensMap.put(sales.Month__c,lenssales);
                                rxLensLYMap.put(sales.Account__c,monthLensMap);
                            }
                        }
                    }
                    //For other than lenses
                    else{
                        if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(sales.Account__c)){
                            Map<double,SalesData> salesMap = accStatisticsLYMap.get(sales.Account__c);
                            if(salesMap.containsKey(sales.Month__c)){
                                SalesData salesDataObj = salesMap.get(sales.Month__c);
                                if(sales.Type__c == '3'){
                                    salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                    salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                                    salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                                }
                                else if(sales.Type__c == '4'){
                                    salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                    salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                    salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                                }
                                else if(sales.Type__c == '9'){
                                    salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                    salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                    salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                                }
                                else{
                                    salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                    salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                                    salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                                }
                                salesMap.put(sales.Month__c,salesDataObj);
                                accStatisticsLYMap.put(sales.Account__c,salesMap);
                            }
                        }
                        else
                        {
                            Map<double,SalesData> salesMap =new Map<double,SalesData>();
                            SalesData salesDataObj = new SalesData();
                            if(sales.Type__c == '3'){
                                salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                                salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                            }
                            else if(sales.Type__c == '4'){
                                salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                            }
                            else if(sales.Type__c == '9'){
                                salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                            }
                            else{
                                salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                                salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                            }
                            salesMap.put(sales.Month__c,salesDataObj);
                            accStatisticsLYMap.put(sales.Account__c,salesMap);
                        }
                    }
                    system.debug('LY'+accStatisticsLYMap);
                }                
                else{
                    Map<double,SalesData> monthlySalesMap ;
                    //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        Map<double,LensSales> monthlyLensMap;
                        if(accLensesNYMap.size() > 0 && accLensesNYMap.containsKey(sales.Account__c) && accStatisticsNYMap.size() > 0 && accStatisticsNYMap.containsKey(sales.Account__c) ){
                            monthlyLensMap = accLensesNYMap.get(sales.Account__c);
                            monthlySalesMap = accStatisticsNYMap.get(sales.Account__c);
                            if(monthlyLensMap.containsKey(sales.Month__c) && monthlySalesMap.containsKey(sales.Month__c)){
                                LensSales lensSale=getLensTotalSales(sales,monthlyLensMap.get(sales.Month__c)); 
                                SalesData data = monthlySalesMap.get(sales.Month__c);
                                if(lensSale != null){
                                    LensSales lensData = lensSale;
                                    data.lensNetSales = lensData.lensNetSales;
                                    data.lensGrossSales  = lensData.lensGrossSales;
                                    data.lensQty = lensData.lensQty;
                                    monthlyLensMap.put(sales.Month__c,lensData);
                                    monthlySalesMap.put(sales.Month__c,data);
                                }
                                accLensesNYMap.put(sales.Account__c,monthlyLensMap);
                                accStatisticsNYMap.put(sales.Account__c,monthlySalesMap);
                            }
                            else{
                                monthlyLensMap = accLensesNYMap.get(sales.Account__c);
                                monthlySalesMap = new Map<double,SalesData>();
                                LensSales lensSale=getLensTotalSales(sales,null);
                                SalesData data=new SalesData();
                                if(lensSale !=null){
                                    LensSales lensData = lensSale;
                                    data.lensNetSales =  lensData.lensNetSales;
                                    data.lensGrossSales  = lensData.lensGrossSales;
                                    data.lensQty = lensData.lensQty;
                                    monthlyLensMap.put(sales.Month__c,lensData);
                                    monthlySalesMap.put(sales.Month__c,data);
                                }
                                accLensesNYMap.put(sales.Account__c,monthlyLensMap);
                                accStatisticsNYMap.put(sales.Account__c,monthlySalesMap);
                            }
                        }
                        else{
                            monthlyLensMap = new Map<double,LensSales>();
                            monthlySalesMap =new Map<double,SalesData>();
                            LensSales lensSale=getLensTotalSales(sales,null);
                            SalesData data=new SalesData();
                            if(lensSale != null){
                                LensSales lensData = lensSale;
                                data.lensNetSales =  lensData.lensNetSales;
                                data.lensGrossSales  = lensData.lensGrossSales;
                                data.lensQty = lensData.lensQty;
                                monthlyLensMap.put(sales.Month__c,lensData);
                                monthlySalesMap.put(sales.Month__c,data);
                            }
                            accLensesNYMap.put(sales.Account__c,monthlyLensMap);
                            accStatisticsNYMap.put(sales.Account__c,monthlySalesMap);
                        }
                        system.debug(accLensesNYMap);
                    }
                }
            }
        }
        
        List<Account> accsList=[select Hoya_Account_ID__c,Shop_country__c,Potential__c,Seiko_objective_ECP_agr__c from Account where id in:accs];
        Map<Id,String> countryMap =new Map<Id,String>();
        Map<Id,double> strategicValMap = new Map<Id,double>();
        Map<Id,double> ecpAggrementMap = new Map<Id,double>();
        for(Account acc:accsList){
            String HoyaAccountID = acc.Hoya_Account_ID__c;
            Double StrategicVal = acc.Potential__c;
            Double ecpAggrement = acc.Seiko_objective_ECP_agr__c;
            String countryName='';
            if( HoyaAccountID.startsWith('SO4900') ||  HoyaAccountID.startsWith('SO4990'))
                countryName='Germany';
            else if(HoyaAccountID.startsWith('SO2700') || (HoyaAccountID.startsWith('SO3200') && acc.Shop_country__c == 'NL') || (HoyaAccountID.startsWith('SO3200') && acc.Shop_country__c != 'BE'))
                countryName='SOSAorSONL';
            else
                countryName='Other';
            countryMap.put(acc.Id,countryName);
            strategicValMap.put(acc.Id,StrategicVal);
            ecpAggrementMap.put(acc.Id,ecpAggrement);
        }
        
    
    //calculate last sales for each account
    //get all Accounts in CY and LY Map
    Set<Id> accountIdSet = new Set<Id>();
    accountIdSet.addAll(accLensesCYMap.keySet());
    accountIdSet.addAll(accLensesLYMap.keySet());
    for(Id account : accountIdSet){
        Map<double,LensSales> LYMap = accLensesLYMap.get(account);
        Map<double,LensSales> CYMap = accLensesCYMap.get(account);
        Map<double,LensSales> NYMap = accLensesNYMap.get(account);
        Map<double,RxAndStockSales> CYRXMap = rxLensCYMap.get(account);
        Map<double,RxAndStockSales> CYStockMap = stockLensCYMap.get(account);
        Map<double,RxAndStockSales> LYRXMap = rxLensLYMap.get(account);
        system.debug(LYRXMap);
        system.debug(LYRXMap);
        Map<double,RxAndStockSales> LYStockMap = stockLensLYMap.get(account);
        LensSales sales ;
        RxAndStockSales rxSales ;
        System.debug(LYMap.size());
        //to avoid null pointer exception while accessing
        for(double i=1;i<=12;i++){  
            if(CYMap.size() > 0){
                if(!CYMap.containsKey(i)){  
                    CYMap = accLensesCYMap.get(account);
                    sales = new LensSales();
                    CYMap.put(i,sales);
                }
            }
            else{
                sales = new LensSales();
                CYMap.put(i,sales);
            }
            if(CYRXMap.size() > 0){
                if(!CYRXMap.containsKey(i)){
                    CYRXMap = rxLensCYMap.get(account);
                    rxSales = new RxAndStockSales();
                    CYRXMap.put(i,rxSales);
                }
            }
            else{
                rxSales = new RxAndStockSales();
                CYRXMap.put(i,rxSales);
            }
            if(CYStockMap.size() > 0){
                if(!CYStockMap.containsKey(i)){
                    CYStockMap = stockLensCYMap.get(account);
                    rxSales = new RxAndStockSales();
                    CYStockMap.put(i,rxSales);
                }
            }      
            else{
                rxSales = new RxAndStockSales();
                CYStockMap.put(i,rxSales);
            }
            if(LYMap.size() > 0){
                if(!LYMap.containsKey(i)){
                    LYMap = accLensesLYMap.get(account);
                    sales = new LensSales();
                    LYMap.put(i,sales);
                }
            }
            else{
                sales = new LensSales();
                LYMap.put(i,sales);
            }
            if(LYRXMap.size() > 0){
                if(!LYRXMap.containsKey(i)){
                    LYRXMap = rxLensLYMap.get(account);
                    rxSales = new RxAndStockSales();
                    LYRXMap.put(i,rxSales);
                }
            }    
            else{
                rxSales = new RxAndStockSales();
                LYRXMap.put(i,rxSales);
            }            
            if(LYStockMap.size() > 0){
                if(!LYStockMap.containsKey(i)){
                    LYStockMap = stockLensLYMap.get(account);
                    rxSales = new RxAndStockSales();
                    LYStockMap.put(i,rxSales);
                }
            }
            else{
                rxSales = new RxAndStockSales();
                LYStockMap.put(i,rxSales); 
            }
            if(i >= 1 && i <= 3){                        
                if(NYMap.size() > 0){
                    if(!NYMap.containsKey(i)){
                        NYMap = accLensesNYMap.get(account);
                        sales = new LensSales(); 
                        NYMap.put(i,sales);
                    }
                }
                else{
                    sales = new LensSales(); 
                    NYMap.put(i,sales);
                }
            }
        }
        system.debug(LYRXMap.get(2));
        system.debug(LYRXMap.get(3));
        double lensesNetSalesLast12Mo = getLensesSalesLast12Mo(CYMap,LYMap,'Net',month);
        double lensesGrossSalesLast12Mo = getLensesSalesLast12Mo(CYMap,LYMap,'Gross',month);
        double lensesNetSalesLFY = getLensesSalesLFY(CYMap,LYMap,'Net');
        double lensesGrossSalesLFY = getLensesSalesLFY(CYMap,LYMap,'Gross');
        
        double lensNetSaleslast12MosvsLFY = 0;
        if(lensesNetSalesLFY != null && lensesNetSalesLFY != 0)
            lensNetSaleslast12MosvsLFY=((lensesNetSalesLast12Mo-lensesNetSalesLFY)/lensesNetSalesLFY)*100;
        
        double lensGrossSaleslast12MosvsLFY = 0;
        if(lensesGrossSalesLFY != null && lensesGrossSalesLFY != 0)
            lensGrossSaleslast12MosvsLFY=((lensesGrossSalesLast12Mo-lensesGrossSalesLFY)/lensesGrossSalesLFY)*100;
        
        double lensNetSOWLast12Mo = 0;
        if(strategicValMap.size() > 0 && strategicValMap.get(account) != null && strategicValMap.get(account) !=0){
            lensNetSOWLast12Mo =(lensesNetSalesLast12Mo/strategicValMap.get(account))*100; 
            if(lensNetSOWLast12Mo > 100)
                lensNetSOWLast12Mo = 100;
        }
        
        double lensGrossSOWLast12Mo = 0;
        if(strategicValMap.size() > 0 && strategicValMap.get(account) != null && strategicValMap.get(account) !=0){
            lensGrossSOWLast12Mo =(lensesGrossSalesLast12Mo/strategicValMap.get(account))*100; 
            if(lensGrossSOWLast12Mo > 100)
                lensGrossSOWLast12Mo = 100;
        }            
        
        double lensNetSalesCFY = 0;
        double lensGrossSalesCFY = 0;
        if(CYMap.size() > 0){
            for(Integer i = 1;i <= 12; i++){
                if(CYMap.containsKey(i)){
                    if(countryMap.get(account) == 'Germany')
                        lensGrossSalesCFY += CYMap.get(i).lensGrossSales;
                    else if(countryMap.get(account) == 'SOSAorSONL' || countryMap.get(account) == 'Other')
                        lensNetSalesCFY += CYMap.get(i).lensNetSales;
                }
            }
        }
        double lensNetSalesLFYYTD = getLensesSalesYTD_LFY(CYMap,LYMap,'Net',month);
        double lensGrossSalesLFYYTD = getLensesSalesYTD_LFY(CYMap,LYMap,'Gross',month);
        
        double lensNetSalesCFYvsLFYYTD = 0;
        if(lensNetSalesLFYYTD != null && lensNetSalesLFYYTD != 0)
            lensNetSalesCFYvsLFYYTD=((lensNetSalesCFY-lensNetSalesLFYYTD)/lensNetSalesLFYYTD)*100;
        double lensGrossSalesCFYvsLFYYTD = 0;
        if(lensGrossSalesLFYYTD != null && lensGrossSalesLFYYTD != 0)
            lensGrossSalesCFYvsLFYYTD=((lensGrossSalesCFY-lensGrossSalesLFYYTD)/lensGrossSalesLFYYTD)*100;            
        
        double lensNetSaleslast3MoCFY = getLensesSalesLast3Month(CYMap,LYMap,'Net',month);
        double lensGrossSaleslast3MoCFY = getLensesSalesLast3Month(CYMap,LYMap,'Gross',month);
        
        double lensNetSaleslast3MoLFY = 0;
        lensNetSaleslast3MoLFY = getLensesSalesLast3MonthLY(LYMap,NYMap,'Net',month);
        double lensGrossSaleslast3MoLFY = 0;
        lensGrossSaleslast3MoLFY = getLensesSalesLast3MonthLY(LYMap,NYMap,'Gross',month);
        
        double lensNetSalesLast3MoCFYvsLFY = 0;
        if(lensNetSaleslast3MoLFY != null && lensNetSaleslast3MoLFY != 0)
            lensNetSalesLast3MoCFYvsLFY=((lensNetSaleslast3MoCFY-lensNetSaleslast3MoLFY)/lensNetSaleslast3MoLFY)*100;
        double lensGrossSalesLast3MoCFYvsLFY = 0;
        if(lensGrossSaleslast3MoLFY != null && lensGrossSaleslast3MoLFY != 0)
            lensGrossSalesLast3MoCFYvsLFY=((lensGrossSaleslast3MoCFY-lensGrossSaleslast3MoLFY)/lensGrossSaleslast3MoLFY)*100;
        
        double lensNetSOWlast3Mo = 0;
        double lensGrossOWlast3Mo = 0;
        if(strategicValMap.size() > 0 && strategicValMap.get(account) != null && strategicValMap.get(account) != 0){
            double strategicShare = strategicValMap.get(account)/4;
            if(strategicShare != 0)
            {
                lensNetSOWlast3Mo = (lensNetSaleslast3MoCFY/strategicShare)*100;
                lensGrossOWlast3Mo = (lensGrossSaleslast3MoCFY/strategicShare)*100;
                if(lensNetSOWlast3Mo > 100 )
                    lensNetSOWlast3Mo = 100;
                if(lensGrossOWlast3Mo > 100 )
                    lensGrossOWlast3Mo = 100;
            }
        }            
        
        double lensNetSalesForecastCFY = getLensesSalesForecastCFY(CYMap,LYMap,lensNetSalesCFY,lensNetSalesLast3MoCFYvsLFY,'Net',month);
        double lensGrossSalesForecastCFY = getLensesSalesForecastCFY(CYMap,LYMap,lensGrossSalesCFY,lensGrossSalesLast3MoCFYvsLFY,'Gross',month);
        
        double lensesNetSalesForecastCFYvsLFY =0;
        if(lensesNetSalesLFY != 0)
            lensesNetSalesForecastCFYvsLFY=((lensNetSalesForecastCFY-lensesNetSalesLFY)/lensesNetSalesLFY)*100; 
        double lensesGrossSalesForecastCFYvsLFY =0;
        if(lensesGrossSalesLFY != 0)
            lensesGrossSalesForecastCFYvsLFY=((lensGrossSalesForecastCFY-lensesGrossSalesLFY)/lensesGrossSalesLFY)*100;
        
        double lensesNetForecastvsECPAgreement = 0;
        double lensesGrossForecastvsECPAgreement = 0;
        if(ecpAggrementMap.size() > 0 && ecpAggrementMap.get(account) != null && ecpAggrementMap.get(account) != 0){                
            lensesNetForecastvsECPAgreement=(lensNetSalesForecastCFY/ecpAggrementMap.get(account))*100;
            lensesGrossForecastvsECPAgreement=(lensGrossSalesForecastCFY/ecpAggrementMap.get(account))*100;
        }   
        
        double lenslast12MoQty =getLensesQtyLast12Mo(CYMap,LYMap,month);
        double lensQtyLFY = LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty;
        double lensQty12MovsLFY = 0;
        if(lensQtyLFY != null && lensQtyLFY != 0)
            lensQty12MovsLFY=((lenslast12MoQty-lensQtyLFY)/lensQtyLFY)*100;
        double lensQtyCFY = (double)(CYMap.get(1).lensQty+CYMap.get(2).lensQty+CYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty);
        double lensQtyLFYYTD = getLensesQuantityYTD_LFY(CYMap,LYMap,month);
        double lensQtyCFyvsLFYYTD = 0;
        if(lensQtyLFYYTD != null && lensQtyLFYYTD != 0)
            lensQtyCFyvsLFYYTD=((lensQtyCFY-lensQtyLFYYTD)/lensQtyLFYYTD)*100;
        double lensQty3MoCFY = getLensesQuantityLast3Month(CYMap,LYMap,countryMap.get(account),month);
        double lensQty3MoLFY = 0;
        lensQty3MoLFY = getLensesQuantityLast3MonthLY(LYMap,NYMap,month);
        double lensQty3MoCFYvsLFY =0;
        if(lensQty3MoLFY != null && lensQty3MoLFY != 0)
            lensQty3MoCFYvsLFY=((lensQty3MoCFY-lensQty3MoLFY)/lensQty3MoLFY)*100;
        //All CFY and LFY Sales
        double frameNetSalesCFY = 0;           
        double frameNetSalesLFY = 0;
        double instNetSalesCFY = 0;
        double instNetSalesLFY = 0;
        double otherNetSalesCFY = 0;
        double otherNetSalesLFY = 0;
        double totalNetSalesCFY = 0;
        double totalNetSalesLFY = 0;
        
        double frameGrossSalesCFY = 0;
        double frameGrossSalesLFY = 0;
        double instGrossSalesCFY = 0;
        double instGrossSalesLFY = 0;
        double otherGrossSalesCFY = 0;
        double otherGrossSalesLFY = 0;
        double totalGrossSalesCFY = 0;
        double totalGrossSalesLFY = 0;
        
        double framesQtyCFY = 0;
        double framesQtyLFY = 0;
        double instQtyCFY = 0;
        double instQtyLFY = 0;
        double otherQtyCFY = 0;
        double otherQtyLFY = 0;
        double totalQtyCFY = 0;
        double totalQtyLFY = 0;            
        
        if(accStatisticsCYMap.size() > 0 && accStatisticsCYMap.containsKey(account)){
            Map<double,SalesData> salesDataMap = accStatisticsCYMap.get(account);
            Set<double> monthList = salesDataMap.keySet();
            for(double mon:monthList){
                frameNetSalesCFY += salesDataMap.get(mon).framesNetSales;
                frameGrossSalesCFY += salesDataMap.get(mon).framesGrossSales;
                instNetSalesCFY += salesDataMap.get(mon).instrumentsNetSales;
                instGrossSalesCFY += salesDataMap.get(mon).instrumentsGrossSales;
                otherNetSalesCFY += salesDataMap.get(mon).otherNetSales;
                otherGrossSalesCFY += salesDataMap.get(mon).otherGrossSales; 
                instQtyCFY += salesDataMap.get(mon).instrumentsQty;
                otherQtyCFY += salesDataMap.get(mon).OthersQty;
                framesQtyCFY += salesDataMap.get(mon).framesQty;
            }
            totalNetSalesCFY += lensNetSalesCFY+frameNetSalesCFY+instNetSalesCFY+otherNetSalesCFY;
            totalGrossSalesCFY += lensGrossSalesCFY+frameGrossSalesCFY+instGrossSalesCFY+otherGrossSalesCFY;
            totalQtyCFY += lensQtyCFY+framesQtyCFY+instQtyCFY+otherQtyCFY;
        }
        if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(account)){
            Map<double,SalesData> salesDataMap = accStatisticsLYMap.get(account);
            Set<double> monthList = salesDataMap.keySet();
            for(double mon:monthList){
                frameNetSalesLFY += salesDataMap.get(mon).framesNetSales;
                frameGrossSalesLFY += salesDataMap.get(mon).framesGrossSales;
                instNetSalesLFY += salesDataMap.get(mon).instrumentsNetSales;
                instGrossSalesLFY += salesDataMap.get(mon).instrumentsGrossSales;
                otherNetSalesLFY += salesDataMap.get(mon).otherNetSales;
                otherGrossSalesLFY += salesDataMap.get(mon).otherGrossSales;  
                instQtyLFY += salesDataMap.get(mon).instrumentsQty;
                otherQtyLFY += salesDataMap.get(mon).OthersQty;
                framesQtyLFY += salesDataMap.get(mon).framesQty;
            }
            totalNetSalesLFY += lensesNetSalesLFY+frameNetSalesLFY+instNetSalesLFY+otherNetSalesLFY;
            totalGrossSalesLFY += lensesGrossSalesLFY+frameGrossSalesLFY+instGrossSalesLFY+otherGrossSalesLFY;
            totalQtyLFY += lensQtyLFY+framesQtyLFY+instQtyLFY+otherQtyLFY;
        }
        
        //Leses Delays before shipment
        Integer rxShippedSameDay = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,0,'RX');
        Integer rxShippedin1Day = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,1,'RX');
        Integer rxShippedin2Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,2,'RX');
        Integer rxShippedin3Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,3,'RX');
        Integer rxShippedin4Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,4,'RX');
        Integer rxShippedin5Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,5,'RX');
        Integer rxShippedin6Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,6,'RX');
        Integer rxShippedin7Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,7,'RX');
        Integer rxShippedin8Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,8,'RX');
        Integer rxShippedin9Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,9,'RX');
        Integer rxShippedin10Days = (Integer)getLensesDelays(CYRXMap,LYRXMap,month,10,'RX');
        
        Integer stockShippedSameDay = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,0,'STOCK');
        Integer stockShippedin1Day = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,1,'STOCK');
        Integer stockShippedin2Days = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,2,'STOCK');
        Integer stockShippedin3Days = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,3,'STOCK');
        Integer stockShippedin4Days = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,4,'STOCK');
        Integer stockShippedin5Days = (Integer)getLensesDelays(CYStockMap,LYStockMap,month,5,'STOCK');
        
        double lensShipAvgDelay = getShipmentAvgDelay3Month(CYRXMap,LYRXMap,CYStockMap,LYStockMap,month,'both');            
        double rxLensShipAvgDelay = getShipmentAvgDelay3Month(CYRXMap,LYRXMap,null,null,month,'RX');
        double stockLensShipAvgDelay = getShipmentAvgDelay3Month(null,null,CYStockMap,LYStockMap,month,'Stock');            
        //Ordering Habits
        
        //Production Returns
        //Assign the values to new object
        Last_Sales_Statistics__c lastStatistics =new Last_Sales_Statistics__c();
        lastStatistics.Account__c = account;
        lastStatistics.Lenses_Net_Sales_Last_12Mo__c = lensesNetSalesLast12Mo;
        lastStatistics.Lenses_Net_Sales_LFY__c = lensesNetSalesLFY;
        lastStatistics.Lenses_Net_Sales_Last_12Mo_vs_LFY__c = lensNetSaleslast12MosvsLFY;
        lastStatistics.Lenses_Net_SoW_Last_12Mo__c = lensNetSOWLast12Mo;
        lastStatistics.Lenses_Net_Sales_CFY__c = lensNetSalesCFY;
        lastStatistics.Lenses_Net_Sales_LFY_YTD__c = lensNetSalesLFYYTD;
        lastStatistics.Lenses_Net_Sales_CFY_vs_LFY_YTD__c = lensNetSalesCFYvsLFYYTD;
        lastStatistics.Lenses_Net_Sales_Last_3Mo_CFY__c = lensNetSaleslast3MoCFY;
        lastStatistics.Lenses_Net_Sales_Last_3Mo_LFY__c = lensNetSaleslast3MoLFY;
        lastStatistics.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c = lensNetSalesLast3MoCFYvsLFY;
        lastStatistics.Lenses_Net_SoW_Last_3Mo__c = lensNetSOWlast3Mo;
        lastStatistics.Lenses_Net_Sales_Forecast_CFY__c = lensNetSalesForecastCFY;
        lastStatistics.Lenses_Net_Sales_Forecast_vs_ECP_Agreeme__c = lensesNetForecastvsECPAgreement;
        lastStatistics.Lenses_Qty_Last_12Mo__c = lenslast12MoQty;
        lastStatistics.Lenses_Qty_LFY__c = lensQtyLFY;
        lastStatistics.Lenses_Qty_Last_12Mo_vs_LFY__c = lensQty12MovsLFY;
        lastStatistics.Lenses_Qty_CFY__c = lensQtyCFY;
        lastStatistics.Lenses_Qty_LFY_YTD__c = lensQtyLFYYTD;
        lastStatistics.Lenses_Qty_CFY_vs_LFY_YTD__c = lensQtyCFyvsLFYYTD;
        //lastStatistics.Lenses_Qty_Last_3Mo_CFY__c = lensQty3MoCFY;
        //lastStatistics.Lenses_Qty_Last_3Mo_LFY__c = lensQty3MoLFY;
        lastStatistics.Lenses_Qty_Last_3Mo_CFY_vs_LFY__c = lensQty3MoCFYvsLFY;            
        lastStatistics.Lenses_Gross_Sales_Last_12Mo__c = lensesGrossSalesLast12Mo;
        lastStatistics.Lenses_Gross_Sales_LFY__c = lensesGrossSalesLFY;
        lastStatistics.Lenses_Gross_Sales_Last_12Mo_vs_LFY__c = lensGrossSaleslast12MosvsLFY;
        lastStatistics.Lenses_Gross_SoW_Last_12Mo__c = lensGrossSOWLast12Mo;
        lastStatistics.Lenses_Gross_Sales_CFY__c = lensGrossSalesCFY;
        lastStatistics.Lenses_Gross_Sales_LFY_YTD__c = lensGrossSalesLFYYTD;
        lastStatistics.Lenses_Gross_Sales_CFY_vs_LFY_YTD__c = lensGrossSalesCFYvsLFYYTD;
        lastStatistics.Lenses_Gross_Sales_Last_3Mo_CFY__c = lensGrossSaleslast3MoCFY;
        lastStatistics.Lenses_Gross_Sales_Last_3Mo_LFY__c = lensGrossSaleslast3MoLFY;
        lastStatistics.Lenses_Gross_Sales_Last_3Mo_CFY_vs_LFY__c = lensGrossSalesLast3MoCFYvsLFY;
        lastStatistics.Lenses_Gross_SoW_Last_3Mo__c = lensGrossOWlast3Mo;
        lastStatistics.Lenses_Gross_Sales_Forecast_CFY__c = lensGrossSalesForecastCFY;
        lastStatistics.Lenses_Gross_Sales_Forecast_vs_ECP_Agree__c = lensesGrossSalesForecastCFYvsLFY;
        
        lastStatistics.Frames_Net_Sales_CFY__c = frameNetSalesCFY;
        lastStatistics.Frames_Net_Sales_LFY__c = frameNetSalesLFY;
        lastStatistics.Instruments_Net_Sales_CFY__c = instNetSalesCFY;
        lastStatistics.Instruments_Net_Sales_LFY__c = instNetSalesLFY;
        lastStatistics.Other_Net_Sales_CFY__c = otherNetSalesCFY;
        lastStatistics.Other_Net_Sales_LFY__c = otherNetSalesLFY;
        lastStatistics.Total_Net_Sales_CFY__c = totalNetSalesCFY;
        lastStatistics.Total_Net_Sales_LFY__c = totalNetSalesLFY;
        lastStatistics.Frames_Qty_CFY__c = framesQtyCFY;
        lastStatistics.Frames_Qty_LFY__c = framesQtyLFY;
        lastStatistics.Total_Qty_CFY__c =  totalQtyCFY;
        lastStatistics.Total_Qty_LFY__c = totalQtyLFY;
        lastStatistics.Frames_Gross_Sales_CFY__c = frameGrossSalesCFY;
        lastStatistics.Frames_Gross_Sales_LFY__c = frameGrossSalesLFY;
        lastStatistics.Instruments_Gross_Sales_CFY__c = instGrossSalesCFY;
        lastStatistics.Instruments_Gross_Sales_LFY__c = instGrossSalesLFY;
        lastStatistics.Other_Gross_Sales_CFY__c = otherGrossSalesCFY;
        lastStatistics.Other_Gross_Sales_LFY__c = otherGrossSalesLFY;
        lastStatistics.Total_Gross_Sales_CFY__c = totalGrossSalesCFY;
        lastStatistics.Total_Gross_Sales_LFY__c = totalGrossSalesLFY;                
        //lenses delays
        lastStatistics.Lenses_RX_Shipped_Same_Day_3Mo__c = rxShippedSameDay;
        lastStatistics.Lenses_RX_Shipped_In_Max_1_Day_3Mo__c = rxShippedin1Day;
        lastStatistics.Lenses_RX_Shipped_In_Max_2_Days_3Mo__c = rxShippedin2Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_3_Days_3Mo__c = rxShippedin3Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_4_Days_3Mo__c = rxShippedin4Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_5_Days_3Mo__c = rxShippedin5Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_6_Days_3Mo__c = rxShippedin6Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_7_Days_3Mo__c = rxShippedin7Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_8_Days_3Mo__c = rxShippedin8Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_9_Days_3Mo__c = rxShippedin9Days;
        lastStatistics.Lenses_RX_Shipped_In_Max_10_Days_3Mo__c = rxShippedin10Days;
        lastStatistics.Lenses_STOCK_Shipped_Same_Day_3Mo__c = stockShippedSameDay;
        lastStatistics.Lenses_STOCK_Shipped_In_Max_1_Day_3Mo__c = stockShippedin1Day;
        lastStatistics.Lenses_STOCK_Shipped_In_Max_2_Days_3M__c = stockShippedin2Days;
        lastStatistics.Lenses_STOCK_Shipped_In_Max_3_Days_3M__c = stockShippedin3Days;
        lastStatistics.Lenses_STOCK_Shipped_In_Max_4_Days_3M__c = stockShippedin4Days;
        lastStatistics.Lenses_STOCK_Shipped_In_Max_5_Days_3M__c = stockShippedin5Days;
       // lastStatistics.Lenses_Shipment_Average_Delay_in_Days_3__c = lensShipAvgDelay;
        lastStatistics.Lenses_Shipment_RX_Average_Delay_3Mo__c = rxLensShipAvgDelay;
        lastStatistics.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = stockLensShipAvgDelay;
        lastSalesStatisticsList.add(lastStatistics);
    }
    
    
    return lastSalesStatisticsList;
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
public LensSales getLensTotalSales(Sales_Statistics__c sales,LensSales lensSales){       
    LensSales lensSalesWrapper;
    if(lensSales != null){
        lensSalesWrapper = lensSales;
        lensSalesWrapper.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
        lensSalesWrapper.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
        lensSalesWrapper.lensQty += parseNullInt((Integer)sales.Lenses_Qty__c);
        // monthlyMap.put(sales.Month__c,lensSalesWrapper);  
    }
    else{
        lensSalesWrapper=new LensSales();
        //monthlyMap =new Map<double,LensSales>();
        lensSalesWrapper.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
        lensSalesWrapper.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c);
        lensSalesWrapper.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);
        //monthlyMap.put(sales.Month__c,lensSalesWrapper);                         
    }
    return lensSalesWrapper;
}
public RxAndStockSales getRxandStockLenses(Sales_Statistics__c sales){
    RxAndStockSales rxSales=new RxAndStockSales();
    if(sales.Type__c == '1'){      
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
    }
    if(sales.Type__c == '0'){ 
        rxSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
        rxSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
        rxSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);                                
        rxSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
        rxSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
        rxSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
        rxSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
    }
    return rxSales;
}
public static Double getLensesSalesLast12Mo(Map<double,LensSales> CYMap, Map<double,LensSales> LYMap,String netOrGross,Integer month){
    Double result = 0;
    try{
        if(netOrGross == 'Gross'){
            switch on month {
                when  1{result = LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales;}
                when  2{result = LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales;}
                when  3{result = LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales+CYMap.get(2).lensGrossSales;}
                when  4{result = CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales+CYMap.get(2).lensGrossSales+CYMap.get(3).lensGrossSales;}
                when  5{result = LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales;}
                when  6{result = LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales;}
                when  7{result = LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales;}
                when  8{result = LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales;}
                when  9{result = LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales;}
                when  10{result = LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+CYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales;}
                when  11{result = LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales;}
                when  12{result = LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales;}
                when else {result=0;}
            }
        }
        else {
            switch on month {
                when  1{result = LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales;}
                when  2{result = LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales+CYMap.get(1).lensNetSales;}
                when  3{result = LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales+CYMap.get(1).lensNetSales+CYMap.get(2).lensNetSales;}
                when  4{result = CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales+CYMap.get(1).lensNetSales+CYMap.get(2).lensNetSales+CYMap.get(3).lensNetSales;}
                when  5{result = LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales;}
                when  6{result = LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales;}
                when  7{result = LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales;}
                when  8{result = LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales;}
                when  9{result = LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales;}
                when  10{result = LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+CYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales;}
                when  11{result = LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales;}
                when  12{result = LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales;}
                when else {result=0;}
            }
            
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
    
    
}
public static Double getLensesSalesLFY(Map<double,LensSales> CYMap, Map<double,LensSales> LYMap,String netorGross){
    double totalLensesSalesLY = 0;        
    if(netorGross == 'Gross'){
        totalLensesSalesLY=LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+ LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales
            +LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;
    }
    else{
        totalLensesSalesLY=LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+ LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales
            +LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;
    }
    return totalLensesSalesLY;
}
public static Double getLensesQtyLast12Mo(Map<double,LensSales> CYMap, Map<double,LensSales> LYMap, Integer month){
    Double result = 0;
    try{
        switch on month {
            when  1{result = LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty;}
            when  2{result = LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty+CYMap.get(1).lensQty;}
            when  3{result = LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty+CYMap.get(1).lensQty+CYMap.get(2).lensQty;}
            when  4{result = CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty+CYMap.get(1).lensQty+CYMap.get(2).lensQty+CYMap.get(3).lensQty;}
            when  5{result = LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty;}
            when  6{result = LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty;}
            when  7{result = LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty;}
            when  8{result = LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty;}
            when  9{result = LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty;}
            when  10{result = LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty;}
            when  11{result = LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty;}
            when  12{result = LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty;}
            when else {result=0;}
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
}   
public static Double getLensesSalesYTD_LFY(Map<double,LensSales> CYMap, Map<double,LensSales> LYMap,String netOrGross,Integer month){
    Double result = 0;
    try{
        if(netOrGross == 'Gross'){
            switch on month{
                when  1{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales;}
                when  2{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales;}
                when  3{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales;}
                when  4{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  5{result = LYMap.get(4).lensGrossSales;}
                when  6{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales;}
                when  7{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales;}
                when  8{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales;}
                when  9{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales;}
                when  10{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales;}
                when  11{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales;}
                when  12{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales;}
                when else {result=0;}               
            }
        }
        else{
            switch on month{
                when  1{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales;}
                when  2{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales;}
                when  3{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales;}
                when  4{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  5{result = LYMap.get(4).lensNetSales;}
                when  6{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales;}
                when  7{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales;}
                when  8{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales;}
                when  9{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales;}
                when  10{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales;}
                when  11{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales;}
                when  12{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales;}
                when else {result=0;}            
            }
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
}
public static Integer getLensesQuantityYTD_LFY(Map<double,LensSales> CYMap, Map<double,LensSales> LYMap,Integer month){
    Integer result = 0;
    try{
        switch on month{
            when  1{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty;}
            when  2{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty;}
            when  3{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty;}
            when  4{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty;}
            when  5{result = LYMap.get(4).lensQty;}
            when  6{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty;}
            when  7{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty;}
            when  8{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty;}
            when  9{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty;}
            when  10{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty;}
            when  11{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty;}
            when  12{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty;}
            when else {result=0;}              
        }           
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
} 
public static Double getLensesSalesLast3Month(Map<double,LensSales> CYMap,Map<double,LensSales> LYMap,String netOrGross,Integer month){
    Double result = 0;
    try{
        if(netOrGross == 'Gross'){
            switch on month {
                when  1{result = CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales;}
                when  2{result = CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales;}
                when  3{result = CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales+CYMap.get(2).lensGrossSales;}
                when  4{result = LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  5{result = LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales;}
                when  6{result = LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales;}
                when  7{result = CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales;}
                when  8{result = CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales;}
                when  9{result = CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales;}
                when  10{result = CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales;}
                when  11{result = CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales;}
                when  12{result = CYMap.get(9).lensGrossSales+CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales;}
                when else {result=0;}
            }
        }
        else{
            switch on month {
                when  1{result = CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales;}
                when  2{result = CYMap.get(11).lensNetSales+CYMap.get(12).lensNetSales+CYMap.get(1).lensNetSales;}
                when  3{result = CYMap.get(12).lensNetSales+CYMap.get(1).lensNetSales+CYMap.get(2).lensNetSales;}
                when  4{result = LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  5{result = LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales;}
                when  6{result = LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales;}
                when  7{result = CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales;}
                when  8{result = CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales;}
                when  9{result = CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales;}
                when  10{result = CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales;}
                when  11{result = CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales;}
                when  12{result = CYMap.get(9).lensNetSales+CYMap.get(10).lensNetSales+CYMap.get(11).lensNetSales;}
                when else {result=0;}
            }
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
}
public static Double getLensesSalesLast3MonthLY(Map<double,LensSales> LYMap,Map<double,LensSales> NYMap,String netOrGross,Integer month){
    Double result = 0;
    try{
        if(netOrGross == 'Gross'){
            switch on month {
                when  1{result = LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales;}
                when  2{result = LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales;}
                when  3{result = LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales;}
                when  4{result = NYMap.get(1).lensGrossSales+NYMap.get(2).lensGrossSales+NYMap.get(3).lensGrossSales;}
                when  5{result = NYMap.get(2).lensGrossSales+NYMap.get(3).lensGrossSales+LYMap.get(4).lensGrossSales;}
                when  6{result = NYMap.get(3).lensGrossSales+LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales;}
                when  7{result = LYMap.get(4).lensGrossSales+LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales;}
                when  8{result = LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales;}
                when  9{result = LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales;}
                when  10{result = LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales;}
                when  11{result = LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales;}
                when  12{result = LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales;}
                when else {result=0;}
            }
        }
        else{
            switch on month {
                when  1{result = LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales;}
                when  2{result = LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales;}
                when  3{result = LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales;}
                when  4{result = NYMap.get(1).lensNetSales+NYMap.get(2).lensNetSales+NYMap.get(3).lensNetSales;}
                when  5{result = NYMap.get(2).lensNetSales+NYMap.get(3).lensNetSales+LYMap.get(4).lensNetSales;}
                when  6{result = NYMap.get(3).lensNetSales+LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales;}
                when  7{result = LYMap.get(4).lensNetSales+LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales;}
                when  8{result = LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales;}
                when  9{result = LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales;}
                when  10{result = LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales;}
                when  11{result = LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales;}
                when  12{result = LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales;}
                when else {result=0;}
            }
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
} 
public static Integer getLensesQuantityLast3Month(Map<double,LensSales> CYMap,Map<double,LensSales> LYMap,String countryName,Integer month){
    Integer result = 0;
    try{
        switch on month {
            when  1{result = CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty;}
            when  2{result = CYMap.get(11).lensQty+CYMap.get(12).lensQty+CYMap.get(1).lensQty;}
            when  3{result = CYMap.get(12).lensQty+CYMap.get(1).lensQty+CYMap.get(2).lensQty;}
            when  4{result = LYMap.get(1).lensQty+LYMap.get(2).lensQty+LYMap.get(3).lensQty;}
            when  5{result = LYMap.get(2).lensQty+LYMap.get(3).lensQty+CYMap.get(4).lensQty;}
            when  6{result = LYMap.get(3).lensQty+CYMap.get(4).lensQty+CYMap.get(5).lensQty;}
            when  7{result = CYMap.get(4).lensQty+CYMap.get(5).lensQty+CYMap.get(6).lensQty;}
            when  8{result = CYMap.get(5).lensQty+CYMap.get(6).lensQty+CYMap.get(7).lensQty;}
            when  9{result = CYMap.get(6).lensQty+CYMap.get(7).lensQty+CYMap.get(8).lensQty;}
            when  10{result = CYMap.get(7).lensQty+CYMap.get(8).lensQty+CYMap.get(9).lensQty;}
            when  11{result = CYMap.get(8).lensQty+CYMap.get(9).lensQty+CYMap.get(10).lensQty;}
            when  12{result = CYMap.get(9).lensQty+CYMap.get(10).lensQty+CYMap.get(11).lensQty;}
            when else {result=0;}   
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
}    
public static Double getLensesQuantityLast3MonthLY(Map<double,LensSales> LYMap,Map<double,LensSales> NYMap,Integer month){
    Double result = 0;
    try{
        switch on month {
            when  1{result = LYMap.get(10).lensQty+LYMap.get(11).lensQty+LYMap.get(12).lensQty;}
            when  2{result = LYMap.get(11).lensQty+LYMap.get(12).lensQty+LYMap.get(1).lensQty;}
            when  3{result = LYMap.get(12).lensQty+LYMap.get(1).lensQty+LYMap.get(2).lensQty;}
            when  4{result = NYMap.get(1).lensQty+NYMap.get(2).lensQty+NYMap.get(3).lensQty;}
            when  5{result = NYMap.get(2).lensQty+NYMap.get(3).lensQty+LYMap.get(4).lensQty;}
            when  6{result = NYMap.get(3).lensQty+LYMap.get(4).lensQty+LYMap.get(5).lensQty;}
            when  7{result = LYMap.get(4).lensQty+LYMap.get(5).lensQty+LYMap.get(6).lensQty;}
            when  8{result = LYMap.get(5).lensQty+LYMap.get(6).lensQty+LYMap.get(7).lensQty;}
            when  9{result = LYMap.get(6).lensQty+LYMap.get(7).lensQty+LYMap.get(8).lensQty;}
            when  10{result = LYMap.get(7).lensQty+LYMap.get(8).lensQty+LYMap.get(9).lensQty;}
            when  11{result = LYMap.get(8).lensQty+LYMap.get(9).lensQty+LYMap.get(10).lensQty;}
            when  12{result = LYMap.get(9).lensQty+LYMap.get(10).lensQty+LYMap.get(11).lensQty;}
            when else {result=0;}
        }
    }
    catch (Exception e) {
        LogException.log(e);
    }
    return result;
}
public static double getLensesSalesForecastCFY(Map<double,LensSales> CYMap,Map<double,LensSales> LYMap,double totalLensSales,double lensesSales3monthsCFYvsLFY,String netOrGross,Integer month){       
    double result=0;
    double remainingMonthLFY=0;
    
    try{   
        if(netOrGross == 'Gross'){
            switch on month {               
                when  1{remainingMonthLFY = LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}               
                when  2{remainingMonthLFY = LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  3{remainingMonthLFY = LYMap.get(3).lensGrossSales;}
                when  4{remainingMonthLFY = 0;}
                when  5{remainingMonthLFY = LYMap.get(5).lensGrossSales+LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  6{remainingMonthLFY = LYMap.get(6).lensGrossSales+LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  7{remainingMonthLFY = LYMap.get(7).lensGrossSales+LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  8{remainingMonthLFY = LYMap.get(8).lensGrossSales+LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  9{remainingMonthLFY = LYMap.get(9).lensGrossSales+LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  10{remainingMonthLFY = LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  11{remainingMonthLFY = LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when  12{remainingMonthLFY = LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
                when else {remainingMonthLFY=0;}  
            }                 
        }
        else{
            switch on month {               
                when  1{remainingMonthLFY = LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}               
                when  2{remainingMonthLFY = LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  3{remainingMonthLFY = LYMap.get(3).lensNetSales;}
                when  4{remainingMonthLFY = 0;}
                when  5{remainingMonthLFY = LYMap.get(5).lensNetSales+LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  6{remainingMonthLFY = LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  7{remainingMonthLFY = LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  8{remainingMonthLFY = LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  9{remainingMonthLFY = LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  10{remainingMonthLFY = LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  11{remainingMonthLFY = LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when  12{remainingMonthLFY = LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
                when else {remainingMonthLFY=0;}
            } 
        }
        result=totalLensSales+(remainingMonthLFY*(1+(lensesSales3monthsCFYvsLFY/100)));
        
    }
    catch (Exception e) {
        LogException.log(e);
    }        
    return result;
}
public static double getLensesDelays(Map<double,RxAndStockSales> CYMap, Map<double,RxAndStockSales> LYMap, Integer month, Integer days, String type){
    double result = 0;
    List<String> monthLst;
    switch on month {               
        when  1{monthLst = new List<String>{'10:CY','11:CY','12:CY'};}
        when  2{monthLst = new List<String>{'11:CY','12:CY','1:CY'};}
        when  3{monthLst = new List<String>{'12:CY','1:CY','2:CY'};}
        when  4{monthLst = new List<String>{'1:LY','2:LY','3:LY'};}
        when  5{monthLst = new List<String>{'2:LY','3:LY','4:CY'};}
        when  6{monthLst = new List<String>{'3:LY','4:CY','5:CY'};}
        when  7{monthLst = new List<String>{'4:CY','5:CY','6:CY'};}
        when  8{monthLst = new List<String>{'5:CY','6:CY','7:CY'};}
        when  9{monthLst = new List<String>{'6:CY','7:CY','8:CY'};}
        when  10{monthLst = new List<String>{'7:CY','8:CY','9:CY'};}
        when  11{monthLst = new List<String>{'8:CY','9:CY','10:CY'};}
        when  12{monthLst = new List<String>{'9:CY','10:CY','11:CY'};}
        when else {monthLst = new List<String>();}
    }
    double shipOnDayCount =0;
    double qty = 0;
    if(type == 'RX'){          
        if(days == 0){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedonSameDay;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        system.debug(shipOnDayCount+''+qty);
                    }
                    else{
                        System.debug(LYMap.get(Integer.valueOf(mon.substringBefore(':'))));
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedonSameDay;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        system.debug(shipOnDayCount+''+qty);
                    }
                }
            }
        }
        else if(days == 1){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin1Day;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin1Day;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 2){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin2Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin2Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 3){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin3Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin3Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 4){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin4Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin4Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 5){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin5Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin5Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 6){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin6Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin6Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 7){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin7Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin7Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 8){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin8Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin8Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 9){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin9Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin9Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        else if(days == 10){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin10Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin10Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                    }
                }
            }
        }
        
    }
    else{
        if(days == 0){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedonSameDay;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedonSameDay;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
        else if(days == 1){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin1Day;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin1Day;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
        else if(days == 2){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin2Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin2Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
        else if(days == 3){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin3Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin3Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
        else if(days == 4){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin4Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin4Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
        else if(days == 5){
            if(monthLst.size() > 0){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin5Days;
                        qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                    else{
                        shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin5Days;
                        qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                    }
                }
            }
        }
    }
    if(qty != 0)
        result=(shipOnDayCount/qty)*100;
    return result;
}
public static Map<Integer,double> getTotalrxShippedDelay(Map<double,RxandStockSales> rxMapCY,Map<double,RxandStockSales> rxMapLY,String year){
    double total =0;
    Integer monthcount =0;
    
    Map<Integer,double> monthlydelayMap =new  Map<Integer,double>();    
    Map<double,RxandStockSales> rxMap= new Map<double,RxandStockSales>();
    if(year == 'CY'){
        rxMap.putAll(rxMapCY);
        monthcount = 12;
    }
    else{
        rxMap.putAll(rxMapLY);
        monthcount = 3;
    }
    if(rxMap.size() > 0){
        for(Integer i=1 ; i<=monthcount ;i++){
            if(rxMap.containsKey(i)){
                Integer RxQty = rxMap.get(i).rxQty;
                Integer rxQtyShippedin10days=rxMap.get(i).rxShippedin10Days;
                Integer rxQtyinDelay=RxQty-rxQtyShippedin10days;
                double shipped0=0;
                double shipped1=0;
                double shipped2=0;
                double shipped3=0;
                double shipped4=0;
                double shipped5=0;
                double shipped6=0;
                double shipped7=0;
                double shipped8=0;
                double shipped9=0;
                double shipped10=0;                
                if(rxMap.get(i).rxShippedonSameDay > 0)
                    shipped0=rxMap.get(i).rxShippedonSameDay;
                if(rxMap.get(i).rxShippedin1Day > 0  ){
                    shipped1=rxMap.get(i).rxShippedin1Day - shipped0;
                }
                if(rxMap.get(i).rxShippedin2Days > 0  ){                     
                    shipped2=rxMap.get(i).rxShippedin2Days -(shipped0 + shipped1) ;
                }
                if(rxMap.get(i).rxShippedin3Days > 0  ){
                    shipped3=rxMap.get(i).rxShippedin3Days -(shipped0 + shipped1 + shipped2) ;
                }
                if(rxMap.get(i).rxShippedin4Days > 0  ){
                    shipped4=rxMap.get(i).rxShippedin4Days -(shipped0 + shipped1 +shipped2 +shipped3) ;
                }
                if(rxMap.get(i).rxShippedin5Days > 0  ){
                    shipped5=rxMap.get(i).rxShippedin5Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4) ;
                }
                if(rxMap.get(i).rxShippedin6Days > 0  ){
                    shipped6=rxMap.get(i).rxShippedin6Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5) ;
                }
                if(rxMap.get(i).rxShippedin7Days > 0  ){
                    shipped7=rxMap.get(i).rxShippedin7Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 +shipped5 +shipped6) ;
                }
                if(rxMap.get(i).rxShippedin8Days > 0  ){
                    shipped8=rxMap.get(i).rxShippedin8Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7) ;
                }
                if(rxMap.get(i).rxShippedin9Days > 0  ){
                    shipped9=rxMap.get(i).rxShippedin9Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7 +shipped8) ;
                }
                if(rxMap.get(i).rxShippedin10Days > 0  ){
                    shipped10=rxMap.get(i).rxShippedin10Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7+shipped8+shipped9) ;
                }
                
                total= (shipped0 * 0)+(shipped1 * 1)+(shipped2 * 2) +(shipped3 * 3)+(shipped4 * 4)
                    +(shipped5 * 5)+(shipped6 * 6)+(shipped7 * 7)+( shipped8 * 8)+(shipped9 * 9)+(shipped10 * 10)+(rxQtyinDelay*10);
                
            }
            monthlydelayMap.put(i,total);
        }
    }
    return monthlydelayMap;
}
public static Map<Integer,double> getTotalstockShippedDelay(Map<double,RxandStockSales> stockMapCY,Map<double,RxandStockSales> stockMapLY,String year){
    Map<Integer,double> monthlydelayMap =new  Map<Integer,double>();
    double total=0;
    Integer monthcount =0;
    Map<double,RxandStockSales> stockMap= new Map<double,RxandStockSales>();
    if(year == 'CY'){
        stockMap.putAll(stockMapCY);
        monthcount = 12;
    }
    else{
        stockMap.putAll(stockMapLY);
        monthcount = 3;
    }
    if(stockMap.size() > 0){
        for(Integer i=1 ; i<=monthcount ;i++){ 
            if(stockMap.containsKey(i)){
                Integer stockQty = stockMap.get(i).stockQty;
                Integer stockQtyShippedin5days=stockMap.get(i).stockShippedin5Days;
                Integer stockQtyinDelay=stockQty-stockQtyShippedin5days;
                double shipped0=0;
                double shipped1=0;
                double shipped2=0;
                double shipped3=0;
                double shipped4=0;
                double shipped5=0;               
                if(stockMap.get(i).stockShippedonSameDay > 0)
                    shipped0=stockMap.get(i).stockShippedonSameDay;
                if(stockMap.get(i).stockShippedin1Day  > 0  ){
                    shipped1=stockMap.get(i).stockShippedin1Day - shipped0;
                }
                if(stockMap.get(i).stockShippedin2Days > 0  ){                     
                    shipped2=stockMap.get(i).stockShippedin2Days -(shipped0 + shipped1) ;
                }
                if(stockMap.get(i).stockShippedin3Days > 0  ){
                    shipped3=stockMap.get(i).stockShippedin3Days -(shipped0 + shipped1 + shipped2) ;
                }
                if(stockMap.get(i).stockShippedin4Days > 0  ){
                    shipped4=stockMap.get(i).stockShippedin4Days -(shipped0 + shipped1 +shipped2 +shipped3) ;
                }
                if(stockMap.get(i).stockShippedin5Days > 0  ){
                    shipped5=stockMap.get(i).stockShippedin5Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4) ;
                }
                if(stockQty > 0)
                    Total= (shipped0 * 0)+(shipped1 * 1)+(shipped2 * 2) +(shipped3 * 3)+(shipped4 * 4)+(shipped5 * 5)+(stockQtyinDelay*5);
            }
            monthlydelayMap.put(i,total);
        }
    }
    return monthlydelayMap;
}
public static double getShipmentAvgDelay3Month(Map<double,RxandStockSales> rxMapCY,Map<double,RxandStockSales> rxMapLY,Map<double,RxandStockSales> stockMapCY,Map<double,RxandStockSales> stockMapLY,Integer month,String type){
    double delay=0;
    
    Map<Integer,double> getTotalCYMap = new Map<Integer,double>();
    Map<Integer,double> getTotalLYMap = new Map<Integer,double>();
    if(type == 'RX' ){
        getTotalCYMap=getTotalrxShippedDelay(rxMapCY,rxMapLY,'CY');
        getTotalLYMap=getTotalrxShippedDelay(rxMapCY,rxMapLY,'LY'); 
         system.debug(getTotalCYMap);
        system.debug(getTotalLYMap);
    }
    else if(type == 'Stock'){
        getTotalCYMap=getTotalstockShippedDelay(stockMapCY,stockMapLY,'CY');
        system.debug(getTotalCYMap);
        getTotalLYMap=getTotalstockShippedDelay(stockMapCY,stockMapLY,'LY'); 
        system.debug(getTotalLYMap);
    }
    else{
        Map<Integer,double> getRxCYMap = getTotalrxShippedDelay(rxMapCY,rxMapLY,'CY');
        Map<Integer,double> getRxLYMap = getTotalrxShippedDelay(rxMapCY,rxMapLY,'LY');
        Map<Integer,double> getStockCYMap = getTotalstockShippedDelay(stockMapCY,stockMapLY,'CY');
        Map<Integer,double> getStockLYMap = getTotalstockShippedDelay(stockMapCY,stockMapLY,'LY');
        
        for(Integer i=1;i<=12;i++){
            double totalCY = 0;
            if(getRxCYMap.size() > 0 && getRxCYMap.containsKey(i) )
                totalCY += getRxCYMap.get(i);     
            if(getStockCYMap.size() > 0 && getStockCYMap.containsKey(i))
                totalCY += getStockCYMap.get(i); 
            
            double totalLY = 0;
            if(getRxLYMap.size() > 0 && getRxLYMap.containsKey(i) )
                totalLY += getRxLYMap.get(i);     
            if(getStockLYMap.size() > 0 && getStockLYMap.containsKey(i))
                totalLY += getStockLYMap.get(i); 
            getTotalCYMap.put(i,totalCY);
            getTotalLYMap.put(i,totalLY);                
        }           
    }
    List<String> monthLst;
    switch on month {               
        when  1{monthLst = new List<String>{'10:CY','11:CY','12:CY'};}
        when  2{monthLst = new List<String>{'11:CY','12:CY','1:CY'};}
        when  3{monthLst = new List<String>{'12:CY','1:CY','2:CY'};}
        when  4{monthLst = new List<String>{'1:LY','2:LY','3:LY'};}
        when  5{monthLst = new List<String>{'2:LY','3:LY','4:CY'};}
        when  6{monthLst = new List<String>{'3:LY','4:CY','5:CY'};}
        when  7{monthLst = new List<String>{'4:CY','5:CY','6:CY'};}
        when  8{monthLst = new List<String>{'5:CY','6:CY','7:CY'};}
        when  9{monthLst = new List<String>{'6:CY','7:CY','8:CY'};}
        when  10{monthLst = new List<String>{'7:CY','8:CY','9:CY'};}
        when  11{monthLst = new List<String>{'8:CY','9:CY','10:CY'};}
        when  12{monthLst = new List<String>{'9:CY','10:CY','11:CY'};}
        when else {monthLst=new List<String>();}
    }      
    try{
        double qty =0;
        double totalQty = 0;
        if(monthLst.size() > 0){
            if(type == 'RX' || type == 'both'){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        qty += rxMapCY.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        totalQty += getTotalCYMap.get(Integer.valueOf(mon.substringBefore(':')));
                          system.debug(qty+'-'+totalQty);
                    }
                    else{
                        qty += rxMapLY.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        totalQty += getTotalLYMap.get(Integer.valueOf(mon.substringBefore(':')));
                          system.debug(qty+'-'+totalQty);
                    }
                }
                 system.debug(qty+'-'+totalQty);
            }
            if(type == 'Stock' || type == 'both'){
                for(String mon:monthLst){
                    if(mon.substringAfter(':') == 'CY'){
                        qty += stockMapCY.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        if(type == 'Stock' )
                        	totalQty += getTotalCYMap.get(Integer.valueOf(mon.substringBefore(':')));
                        system.debug(qty+''+totalQty);
                    }
                    else{
                        qty += stockMapLY.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        if(type == 'Stock' )
                            totalQty += getTotalLYMap.get(Integer.valueOf(mon.substringBefore(':')));
                        system.debug(qty+'-'+totalQty);
                    }
                }
                system.debug(qty+'-'+totalQty);
            }
        }
        if(qty != 0)
            delay=totalQty/qty ;    
        System.debug(delay);        
    }
    catch (Exception e){
        LogException.log(e);         
    }        
    return delay;
}
}