public class AccountLastSalesUpdater {
  public AccountLastSalesUpdater(){ }
    
    public class StatisticsObj{
        public StatisticsObj(){
            grossSales = 0;
            netSales = 0;
            qty = 0;
        }
        public Id recId{get;set;}
        public double grossSales{get;set;}
        public double netSales{get;set;}
        public double qty{get;set;}    
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
    public class OrderingHabitsWrapper{        
        public String ManualOrders;
        public String HVCsys;
        public String OtherOrders;
        public String UnCutlens;
        public String RemoteEdging;
        public String Mounting;
        public String FramesByHvc;
        public String RealShape;
        public String StandShape;
        public String Boxing;
        public OrderingHabitsWrapper(){
            ManualOrders='0';
            HVCsys='0';
            OtherOrders='0';
            UnCutlens='0';
            RemoteEdging='0';
            Mounting='0';
            FramesByHvc='0';
            RealShape='0';
            StandShape='0';
            Boxing='0';
        }
        public OrderingHabitsWrapper parse(String json) {
            return (OrderingHabitsWrapper) System.JSON.deserialize(json, OrderingHabitsWrapper.class);
        }
    } 
    public class LensRetsWrapper{
        public String ProdRet; 
        public String CutRet;   
        public String MountRet; 
        public String SalesRet; 
        public String OrderMisRet;  
        public String NonAdapRet;   
        public String DeliveryRet; 
        public String OtherRet;
        public LensRetsWrapper(){
            ProdRet = '0';
            CutRet = '0';
            MountRet = '0';
            SalesRet = '0';
            OrderMisRet = '0';
            NonAdapRet = '0';
            DeliveryRet = '0';
            OtherRet = '0';
        }
        public LensRetsWrapper parse(String json){
            return (LensRetsWrapper) System.JSON.deserialize(json, LensRetsWrapper.class);
        }
    }
    public List<Last_Sales_Statistics__c> getLastSalesObject(Account acc){
        List<Last_Sales_Statistics__c> lastSalesStatisticsList = new List<Last_Sales_Statistics__c>();
        List<Sales_Statistics__c> salesStatisticsLst = new List<Sales_Statistics__c>();
        Integer CurrentFiscalyear = Date.today().year();
		Integer month = Date.today().month();
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
      //  String HoyaAccountID = null;
        Double strategicVal = 0;
        Double ecpAggrement = 0;
       // String shopCountry = null;
        //Query the Sales statistics for the passed accs for all types and all the Fiscal years required
        List<Sales_Statistics__c> salesStatistics=[SELECT Id,OrderingHabitsJson__c,LensReturnsJson__c,Account__c,Account__r.Hoya_Account_ID__c,Account__r.Shop_country__c,Account__r.Potential__c,Account__r.Seiko_objective_ECP_agr__c,Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,Instrument_Gross_Sales__c,Instrument_Net_Sales__c,
                                                   Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c,Contact_Lenses_Gross_Sales__c,Contact_Lenses_Net_Sales__c,Contact_Lenses_Qty__c,
                                                   	SV_Lenses_Qty__c,Progressive_Lenses_Net_Sales__c,Progressive_Lenses_Qty__c,Individualised_Lenses_Qty__c,Individualised_Lenses_Net_Sales__c,SEIKO_Brilliance_Qty__c,	SEIKO_2ndPairs_Qty__c,
                                                   	SEIKO_FR_Qty__c,SEIKO_XCEPTION_Qty__c,SEIKO_Smartzoom_Qty__c,MiyoSmart_Qty__c
                                                 from Sales_Statistics__c where Account__c =:acc.Id AND (Fiscal_Year__c =:CurrentFiscalyear OR Fiscal_Year__c =:CurrentFiscalyear-1 OR(Fiscal_Year__c =:CurrentFiscalyear-2 AND (Month__c =1 OR Month__c =2 OR Month__c = 3))) ORDER BY Account__c,Fiscal_Year__c,Month__c desc];
        Map<double,SalesData> accStatisticsCYMap = new Map<double,SalesData>(); 
        Map<double,SalesData> accStatisticsLYMap = new Map<double,SalesData>();    
        Map<double,SalesData> accStatisticsNYMap = new Map<double,SalesData>(); 
        Map<double,RxAndStockSales> rxLensCYMap =new Map<double,RxAndStockSales>();
        Map<double,RxAndStockSales> stockLensCYMap =new Map<double,RxAndStockSales>();
        Map<double,RxAndStockSales> rxLensLYMap =new Map<double,RxAndStockSales>();
        Map<double,RxAndStockSales> stockLensLYMap =new Map<double,RxAndStockSales>();
        Map<double,Map<String,StatisticsObj>> objLY = new Map<double,Map<String,StatisticsObj>>();
        Map<double,Map<String,StatisticsObj>> objCY = new Map<double,Map<String,StatisticsObj>>();
        //Oh
        Map<Double,Sales_Statistics__c> lensSalesCyHoya0Map = new Map<Double,Sales_Statistics__c>();
        Map<Double,Sales_Statistics__c> lensSalesCyHoya1Map = new Map<Double,Sales_Statistics__c>();

        Map<Double,Sales_Statistics__c> lensSalesLyHoya0Map = new Map<Double,Sales_Statistics__c>();
        Map<Double,Sales_Statistics__c> lensSalesLyHoya1Map = new Map<Double,Sales_Statistics__c>();
       
       double monthTobeUpdated = month-1;
        //split the data based on FiscalYear andalso prepare lens data for each Account
        if(salesStatistics.size() > 0){
            Map<String,StatisticsObj> typeMap = new Map<String,StatisticsObj>();
		  //  Map<String,StatisticsObj> typeMap = new Map<String,StatisticsObj>();
            for(Sales_Statistics__c sales:salesStatistics){ 
                //collect the account details
                if(sales.Account__r.Potential__c != null)
                	strategicVal = sales.Account__r.Potential__c ; 
                if(sales.Account__r.Seiko_objective_ECP_agr__c != null )
                	ecpAggrement = sales.Account__r.Seiko_objective_ECP_agr__c;
                if(sales.Fiscal_Year__c == CurrentFiscalyear){                   
                    //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        if(accStatisticsCYMap.size() > 0 && accStatisticsCYMap.containsKey(sales.Month__c) ){
                            SalesData lensSale=getLensTotalSales(sales,accStatisticsCYMap.get(sales.Month__c));
                            if(lensSale != null){
                                accStatisticsCYMap.put(sales.Month__c,lensSale);
                            }                               
                        }  
                        else{
                            SalesData lensSale=getLensTotalSales(sales,null); 
                            if(lensSale != null){
                                accStatisticsCYMap.put(sales.Month__c,lensSale);
                            }
                        }
                        //get RxandStockLens
                        if(sales.Type__c == '0'){ 
                            RxAndStockSales stockSales = new RxAndStockSales();
                            stockSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                            stockSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                            stockSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);                                
                            stockSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                            stockSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                            stockSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                            stockSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                            stockLensCYMap.put(sales.Month__c,stockSales);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Lenses_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);                                 
                            }
                            //For Oh
                            lensSalesCyHoya0Map.put(sales.Month__c,sales);
                            
                        }
                        else if(sales.Type__c == '1'){      
                            RxAndStockSales rxSales = new RxAndStockSales();
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
                            rxLensCYMap.put(sales.Month__c,rxSales);
                            
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Lenses_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);  
                            }
                            lensSalesCyHoya1Map.put(sales.Month__c,sales);
                        }
                        System.debug(rxLensCYMap);
                        System.debug(stockLensCYMap);
                    }
                    //For other than lenses
                    else{
                        SalesData salesDataObj;
                        if(accStatisticsCYMap.size() > 0 && accStatisticsCYMap.containsKey(sales.Month__c)){
                           salesDataObj = accStatisticsCYMap.get(sales.Month__c);
                        }
                        else{
                           salesDataObj = new SalesData();
                        }
                        if(sales.Type__c == '3'){
                            salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Frames_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Frames_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);  
                            }
                        }
                        else if(sales.Type__c == '4'){
                            salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Instruments_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);  
                            }
                        }
                        else if(sales.Type__c == '9'){
                            salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                            salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                            salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Contact_Lenses_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);  
                            }
                        }
                        else{
                            salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Other_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Other_Qty__c);
                                obj.recId = sales.Id;
                                if(objCY.size() > 0 && objCY.containsKey(sales.Month__c)) {
                                    typeMap = objCY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objCY.put(sales.Month__c,typeMap);  
                            }
                        }
                        accStatisticsCYMap.put(sales.Month__c,salesDataObj);
                    }
                    system.debug('CY'+accStatisticsCYMap);
                }
                else if(sales.Fiscal_Year__c == CurrentFiscalyear - 1){
                       //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(sales.Month__c) ){
                            SalesData lensSale=getLensTotalSales(sales,accStatisticsLYMap.get(sales.Month__c));
                            if(lensSale != null){
                                accStatisticsLYMap.put(sales.Month__c,lensSale);
                            }                               
                        }  
                        else{
                            SalesData lensSale=getLensTotalSales(sales,null); 
                            if(lensSale != null){
                                accStatisticsLYMap.put(sales.Month__c,lensSale);
                            }
                        }
                        //get RxandStockLens
                        if(sales.Type__c == '0'){ 
                            RxAndStockSales stockSales = new RxAndStockSales();
                            stockSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                            stockSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                            stockSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);                                
                            stockSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                            stockSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                            stockSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                            stockSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                            stockLensLYMap.put(sales.Month__c,stockSales);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Lenses_Qty__c);                            
                                if(objLY.size() > 0 && objLY.containsKey(sales.Month__c)) {
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                             }
                            //oh
                            lensSalesLyHoya0Map.put(sales.Month__c,sales);
                        }
                        else if(sales.Type__c == '1'){      
                            RxAndStockSales rxSales = new RxAndStockSales();
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
                            rxLensLYMap.put(sales.Month__c,rxSales);
                            if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Lenses_Qty__c);
                                if(objLY.size() > 0 && objLY.containsKey(sales.Month__c)) {
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                            }
                            //oh
                            lensSalesLyHoya1Map.put(sales.Month__c,sales);
                        }
                        System.debug(rxLensLYMap);
                        System.debug(stockLensLYMap);
                    }
                    //For other than lenses
                    else{
                        SalesData salesDataObj;
                        if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(sales.Month__c)){
                            salesDataObj = accStatisticsLYMap.get(sales.Month__c);
                        }
                        else{
                            salesDataObj = new SalesData();
                        }
                        if(sales.Type__c == '3'){
                            salesDataObj.framesGrossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)sales.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)sales.Frames_Qty__c);
                           // if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Frames_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Frames_Qty__c);
                               	if(objLY.size() > 0 && objLY.containsKey(sales.Month__c) ){
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                           // }
                        }
                        else if(sales.Type__c == '4'){
                            salesDataObj.instrumentsGrossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)sales.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)sales.Instruments_Qty__c);
                          //  if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Instrument_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Instruments_Qty__c);
                                if(objLY.size() > 0 && objLY.containsKey(sales.Month__c)) {
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                          //  }
                        }
                        else if(sales.Type__c == '9'){
                            salesDataObj.contactLensGrossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                            salesDataObj.contactLensNetSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                            salesDataObj.contactLensQty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                           // if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Contact_Lenses_Qty__c);
                                if(objLY.size() > 0 && objLY.containsKey(sales.Month__c)) {
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                           // }
                        }
                        else{
                            salesDataObj.otherGrossSales = parseNull((double)sales.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)sales.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)sales.Other_Qty__c);
                          //  if(sales.Month__c  == monthTobeUpdated){
                                StatisticsObj obj = new StatisticsObj();
                                obj.grossSales = parseNull((double)sales.Other_Gross_Sales__c);
                                obj.netSales = parseNull((double)sales.Other_Net_Sales__c);
                                obj.qty = parseNull((double)sales.Other_Qty__c);
                                if(objLY.size() > 0 && objLY.containsKey(sales.Month__c)) {
                                    typeMap = objLY.get(sales.Month__c);
                                    typeMap.put(sales.Type__c,obj);
                                }
                                else {
                                    typeMap = new Map<String,StatisticsObj>();
                                    typeMap.put(sales.Type__c,obj);
                                }				                                
                                objLY.put(sales.Month__c,typeMap);
                            //}
                        }
                        accStatisticsLYMap.put(sales.Month__c,salesDataObj);
                    }
                    system.debug('LY'+accStatisticsLYMap);
                }                
                else{
                    //total lenses                 
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        if(accStatisticsNYMap.size() > 0 && accStatisticsNYMap.containsKey(sales.Month__c) ){
                            SalesData lensSale=getLensTotalSales(sales,accStatisticsNYMap.get(sales.Month__c));
                            if(lensSale != null){
                                accStatisticsNYMap.put(sales.Month__c,lensSale);
                            }                               
                        }  
                        else{
                            SalesData lensSale=getLensTotalSales(sales,null); 
                            if(lensSale != null){
                                accStatisticsNYMap.put(sales.Month__c,lensSale);
                            }
                        }
                    }
                    System.debug(accStatisticsNYMap);
                }
            }
        }
        
        //ALl to update sales Statistics object
        if(objCY.size() > 0){
            for(double mon:objCY.keySet()){
                Map<String,StatisticsObj> typeMap = objCY.get(mon);
                if(typeMap.size() > 0){
                    for(String type:typeMap.keySet()){
                        StatisticsObj cyObj = typeMap.get(type);               
                        Sales_Statistics__c currentObj =new Sales_Statistics__c(Id=cyObj.recId);                
                        currentObj.Net_Sales__c = cyObj.netSales;
                        currentObj.Gross_Sales__c = cyObj.grossSales;
                        currentObj.Qty__c = cyObj.qty;
                        if(objLY.size() > 0 && objLY.containsKey(mon)){
                            Map<String,StatisticsObj> typeLYMap = objLY.get(mon);
                            if(typeLYMap.size() > 0 && typeLYMap.containsKey(type)){
                                StatisticsObj lyObj = typeLYMap.get(type);  
                                system.debug(lyObj);
                                system.debug(cyObj);
                                currentObj.Net_Sales_vs_LFY__c = getVariation(cyObj.netSales,lyObj.netSales);
                                currentObj.Gross_Sales_vs_LFY__c = getVariation(cyObj.grossSales,lyObj.grossSales);
                                currentObj.Qty_vs_LFY__c = getVariation(cyObj.qty,lyObj.qty);   
                            }
                            else{
                                currentObj.Net_Sales_vs_LFY__c = 0;
                                currentObj.Gross_Sales_vs_LFY__c = 0;
                                currentObj.Qty_vs_LFY__c = 0;
                            }
                        }
                        else{
                            currentObj.Net_Sales_vs_LFY__c = 0;
                            currentObj.Gross_Sales_vs_LFY__c = 0;
                            currentObj.Qty_vs_LFY__c = 0;
                        }
                        salesStatisticsLst.add(currentObj);
                    }
                }
            }
        }
       
     
        //To avoid null pointer exception while accessing last sales
        SalesData sales ;
        RxAndStockSales rxSales ;
        for(double i=1;i<=12;i++){  
            if(accStatisticsCYMap.size() > 0){
                if(!accStatisticsCYMap.containsKey(i)){  
                    sales = new SalesData();
                    accStatisticsCYMap.put(i,sales);
                }
            }
            else{
                sales = new SalesData();
                accStatisticsCYMap.put(i,sales);
            }
            if(rxLensCYMap.size() > 0){
                if(!rxLensCYMap.containsKey(i)){
                    rxSales = new RxAndStockSales();
                    rxLensCYMap.put(i,rxSales);
                }
            }
            else{
                rxSales = new RxAndStockSales();
                rxLensCYMap.put(i,rxSales);
            }
            if(stockLensCYMap.size() > 0){
                if(!stockLensCYMap.containsKey(i)){
                    rxSales = new RxAndStockSales();
                    stockLensCYMap.put(i,rxSales);
                }
            }      
            else{
                rxSales = new RxAndStockSales();
                stockLensCYMap.put(i,rxSales);
            }
            if(accStatisticsLYMap.size() > 0){
                if(!accStatisticsLYMap.containsKey(i)){
                    sales = new SalesData();
                    accStatisticsLYMap.put(i,sales);
                }
            }
            else{
                sales = new SalesData();
                accStatisticsLYMap.put(i,sales);
            }
            if(rxLensLYMap.size() > 0){
                if(!rxLensLYMap.containsKey(i)){
                    rxSales = new RxAndStockSales();
                    rxLensLYMap.put(i,rxSales);
                }
            }    
            else{
                rxSales = new RxAndStockSales();
                rxLensLYMap.put(i,rxSales);
            }            
            if(stockLensLYMap.size() > 0){
                if(!stockLensLYMap.containsKey(i)){
                    rxSales = new RxAndStockSales();
                    stockLensLYMap.put(i,rxSales);
                }
            }
            else{
                rxSales = new RxAndStockSales();
                stockLensLYMap.put(i,rxSales); 
            }
            if(i >= 1 && i <= 3){                        
                if(accStatisticsNYMap.size() > 0){
                    if(!accStatisticsNYMap.containsKey(i)){
                        sales = new SalesData(); 
                        accStatisticsNYMap.put(i,sales);
                    }
                }
                else{
                    sales = new SalesData(); 
                    accStatisticsNYMap.put(i,sales);
                }
            }
        }
        
        //calculate all the fields
        for(Integer i = 1;i<=12;i++){
             system.debug(accStatisticsCYMap.get(i));
        }
        for(Integer i = 1;i<=12;i++){
             system.debug(accStatisticsLYMap.get(i));
        }
       
        double lensesNetSalesLast12Mo = getLensesSalesLast12Mo(accStatisticsCYMap,accStatisticsLYMap,'Net',month);
        system.debug(lensesNetSalesLast12Mo);
        double lensesGrossSalesLast12Mo = getLensesSalesLast12Mo(accStatisticsCYMap,accStatisticsLYMap,'Gross',month);
        double lensesNetSalesLFY = getLensesSalesLFY(accStatisticsCYMap,accStatisticsLYMap,'Net');
        double lensesGrossSalesLFY = getLensesSalesLFY(accStatisticsCYMap,accStatisticsLYMap,'Gross');        
        double lensNetSaleslast12MosvsLFY = getVariation(lensesNetSalesLast12Mo,lensesNetSalesLFY);        
        double lensGrossSaleslast12MosvsLFY = getVariation(lensesGrossSalesLast12Mo,lensesGrossSalesLFY);
        
        double lensNetSOWLast12Mo = 0;
        if(strategicVal !=0){
            lensNetSOWLast12Mo =(lensesNetSalesLast12Mo/strategicVal)*100; 
            if(lensNetSOWLast12Mo > 100)
                lensNetSOWLast12Mo = 100;
        }        
        double lensGrossSOWLast12Mo = 0;
        if(strategicVal != 0){
            lensGrossSOWLast12Mo =(lensesGrossSalesLast12Mo/strategicVal)*100; 
            if(lensGrossSOWLast12Mo > 100)
                lensGrossSOWLast12Mo = 100;
        }    
        //New Code for Last Month Calculation
        double lensesNetSalesLastMonth = getLastMonthVal(accStatisticsCYMap,accStatisticsLYMap,month,'Net');
        System.debug(lensesNetSalesLastMonth);
        double lensesGrossSalesLastMonth = getLastMonthVal(accStatisticsCYMap,accStatisticsLYMap,month,'Gross');
        System.debug(lensesGrossSalesLastMonth);
        double lensQtyLastMonth = getLastMonthVal(accStatisticsCYMap,accStatisticsLYMap,month,'Qty');
        System.debug(lensQtyLastMonth);

        double lensNetSalesCFY = 0;
        double lensGrossSalesCFY = 0;
        if(accStatisticsCYMap.size() > 0){
            for(Integer i = 1;i <= 12; i++){
                if(accStatisticsCYMap.containsKey(i)){
                    lensGrossSalesCFY += accStatisticsCYMap.get(i).lensGrossSales;
                    lensNetSalesCFY += accStatisticsCYMap.get(i).lensNetSales;
                }
            }
        }
        double lensNetSalesLFYYTD = getLensesSalesYTD_LFY(accStatisticsCYMap,accStatisticsLYMap,'Net',month);
        double lensGrossSalesLFYYTD = getLensesSalesYTD_LFY(accStatisticsCYMap,accStatisticsLYMap,'Gross',month);        
        double lensNetSalesCFYvsLFYYTD = getVariation(lensNetSalesCFY,lensNetSalesLFYYTD);
        double lensGrossSalesCFYvsLFYYTD = getVariation(lensGrossSalesCFY,lensGrossSalesLFYYTD);  
        double lensNetSaleslast3MoCFY = getLensesSalesLast3Month(accStatisticsCYMap,accStatisticsLYMap,'Net',month);
        double lensGrossSaleslast3MoCFY = getLensesSalesLast3Month(accStatisticsCYMap,accStatisticsLYMap,'Gross',month);        
        double lensNetSaleslast3MoLFY = getLensesSalesLast3MonthLY(accStatisticsLYMap,accStatisticsNYMap,'Net',month);
        double lensGrossSaleslast3MoLFY = getLensesSalesLast3MonthLY(accStatisticsLYMap,accStatisticsNYMap,'Gross',month);
        double lensNetSalesLast3MoCFYvsLFY = getVariation(lensNetSaleslast3MoCFY,lensNetSaleslast3MoLFY);
        double lensGrossSalesLast3MoCFYvsLFY = getVariation(lensGrossSaleslast3MoCFY,lensGrossSaleslast3MoLFY);
        double discountOnLensGrossSalesLast12Mo = getVariation(lensesNetSalesLast12Mo,lensesGrossSalesLast12Mo);
        double lensNetSOWlast3Mo = 0;
        double lensGrossOWlast3Mo = 0;
        if(strategicVal != 0){
            double strategicShare = strategicVal/4;
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
        double lensNetSalesForecastCFY = getLensesSalesForecastCFY(accStatisticsCYMap,accStatisticsLYMap,lensNetSalesCFY,lensNetSalesLast3MoCFYvsLFY,'Net',month);
        double lensGrossSalesForecastCFY = getLensesSalesForecastCFY(accStatisticsCYMap,accStatisticsLYMap,lensGrossSalesCFY,lensGrossSalesLast3MoCFYvsLFY,'Gross',month);
        double lensesNetSalesForecastCFYvsLFY =getVariation(lensNetSalesForecastCFY,lensesNetSalesLFY);
        double lensesGrossSalesForecastCFYvsLFY =getVariation(lensGrossSalesForecastCFY,lensesGrossSalesLFY);
        
        double lensesNetForecastvsECPAgreement = 0;
        double lensesGrossForecastvsECPAgreement = 0;
        if(ecpAggrement != 0){                
            lensesNetForecastvsECPAgreement=(lensNetSalesForecastCFY/ecpAggrement)*100;
            lensesGrossForecastvsECPAgreement=(lensGrossSalesForecastCFY/ecpAggrement)*100;
        }   
        
        double lenslast12MoQty =getLensesQtyLast12Mo(accStatisticsCYMap,accStatisticsLYMap,month,'lens');
        double lensQtyLFY = 0;
        for(Integer i = 1; i<= 12 ; i++){
            lensQtyLFY += accStatisticsLYMap.get(i).lensQty;
        }
        double lensQty12MovsLFY = getVariation(lenslast12MoQty,lensQtyLFY);
        double lensQtyCFY = 0;
        for(Integer i = 1; i<= 12 ; i++){
            lensQtyCFY += accStatisticsCYMap.get(i).lensQty;
        }
        double lensQtyLFYYTD = getLensesQuantityYTD_LFY(accStatisticsCYMap,accStatisticsLYMap,month);
        double lensQtyCFyvsLFYYTD = getVariation(lensQtyCFY,lensQtyLFYYTD);
        double lensQty3MoCFY = getLensesQuantityLast3Month(accStatisticsCYMap,accStatisticsLYMap,month,'lens');
        double lensQty3MoLFY = getLensesQuantityLast3MonthLY(accStatisticsLYMap,accStatisticsNYMap,month);
        double lensQty3MoCFYvsLFY =getVariation(lensQty3MoCFY,lensQty3MoLFY);
         //All CFY and LFY Sales
        double frameNetSalesCFY = 0;           
        double frameNetSalesLFY = 0;
        double instNetSalesCFY = 0;
        double instNetSalesLFY = 0;
        double otherNetSalesCFY = 0;
        double otherNetSalesLFY = 0;
        double contactNetSalesCFY = 0;
        double contactNetSalesLFY = 0;
        double totalNetSalesCFY = 0;
        double totalNetSalesLFY = 0;
        
        double frameGrossSalesCFY = 0;
        double frameGrossSalesLFY = 0;
        double instGrossSalesCFY = 0;
        double instGrossSalesLFY = 0;
        double otherGrossSalesCFY = 0;
        double otherGrossSalesLFY = 0;        
        double contactGrossSalesCFY = 0;
        double contactGrossSalesLFY = 0;
        double totalGrossSalesCFY = 0;
        double totalGrossSalesLFY = 0;
        
        double framesQtyCFY = 0;
        double framesQtyLFY = 0;
        double instQtyCFY = 0;
        double instQtyLFY = 0;
        double otherQtyCFY = 0;
        double otherQtyLFY = 0;
        double contactQtyCFY = 0;
        double contactQtyLFY = 0;
        double totalQtyCFY = 0;
        double totalQtyLFY = 0;            
        
        if(accStatisticsCYMap.size() > 0){
            Set<double> monthList = accStatisticsCYMap.keySet();
            for(double mon:monthList){
                frameNetSalesCFY += accStatisticsCYMap.get(mon).framesNetSales;
                frameGrossSalesCFY += accStatisticsCYMap.get(mon).framesGrossSales;
                instNetSalesCFY += accStatisticsCYMap.get(mon).instrumentsNetSales;
                instGrossSalesCFY += accStatisticsCYMap.get(mon).instrumentsGrossSales;
                otherNetSalesCFY += accStatisticsCYMap.get(mon).otherNetSales;
                otherGrossSalesCFY += accStatisticsCYMap.get(mon).otherGrossSales; 
                contactNetSalesCFY += accStatisticsCYMap.get(mon).contactLensNetSales;
                contactGrossSalesCFY += accStatisticsCYMap.get(mon).contactLensGrossSales;
                instQtyCFY += accStatisticsCYMap.get(mon).instrumentsQty;
                otherQtyCFY += accStatisticsCYMap.get(mon).OthersQty;
                framesQtyCFY += accStatisticsCYMap.get(mon).framesQty;
                contactQtyCFY += accStatisticsCYMap.get(mon).contactLensQty;
            }
            totalNetSalesCFY += lensNetSalesCFY+frameNetSalesCFY+instNetSalesCFY+otherNetSalesCFY+contactNetSalesCFY;
            totalGrossSalesCFY += lensGrossSalesCFY+frameGrossSalesCFY+instGrossSalesCFY+otherGrossSalesCFY+contactGrossSalesCFY;
            totalQtyCFY += lensQtyCFY+framesQtyCFY+instQtyCFY+otherQtyCFY+contactQtyCFY;
        }
        if(accStatisticsLYMap.size() > 0){
            Set<double> monthList = accStatisticsLYMap.keySet();
            for(double mon:monthList){
                frameNetSalesLFY += accStatisticsLYMap.get(mon).framesNetSales;
                frameGrossSalesLFY += accStatisticsLYMap.get(mon).framesGrossSales;
                instNetSalesLFY += accStatisticsLYMap.get(mon).instrumentsNetSales;
                instGrossSalesLFY += accStatisticsLYMap.get(mon).instrumentsGrossSales;
                otherNetSalesLFY += accStatisticsLYMap.get(mon).otherNetSales;
                otherGrossSalesLFY += accStatisticsLYMap.get(mon).otherGrossSales;                
                contactNetSalesLFY += accStatisticsCYMap.get(mon).contactLensNetSales;
                contactGrossSalesLFY += accStatisticsCYMap.get(mon).contactLensGrossSales;
                instQtyLFY += accStatisticsLYMap.get(mon).instrumentsQty;
                otherQtyLFY += accStatisticsLYMap.get(mon).OthersQty;
                framesQtyLFY += accStatisticsLYMap.get(mon).framesQty;
                contactQtyLFY += accStatisticsLYMap.get(mon).contactLensQty;
            }
            totalNetSalesLFY += lensesNetSalesLFY+frameNetSalesLFY+instNetSalesLFY+otherNetSalesLFY+contactNetSalesLFY;
            totalGrossSalesLFY += lensesGrossSalesLFY+frameGrossSalesLFY+instGrossSalesLFY+otherGrossSalesLFY+contactGrossSalesLFY;
            totalQtyLFY += lensQtyLFY+framesQtyLFY+instQtyLFY+otherQtyLFY+contactQtyLFY;
        }
        
        //Leses Delays before shipment
        Integer rxShippedSameDay = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,0,'RX');
        Integer rxShippedin1Day = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,1,'RX');
        Integer rxShippedin2Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,2,'RX');
        Integer rxShippedin3Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,3,'RX');
        Integer rxShippedin4Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,4,'RX');
        Integer rxShippedin5Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,5,'RX');
        Integer rxShippedin6Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,6,'RX');
        Integer rxShippedin7Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,7,'RX');
        Integer rxShippedin8Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,8,'RX');
        Integer rxShippedin9Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,9,'RX');
        Integer rxShippedin10Days = (Integer)getLensesDelays(rxLensCYMap,rxLensLYMap,month,10,'RX');
        
        Integer stockShippedSameDay = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,0,'STOCK');
        Integer stockShippedin1Day = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,1,'STOCK');
        Integer stockShippedin2Days = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,2,'STOCK');
        Integer stockShippedin3Days = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,3,'STOCK');
        Integer stockShippedin4Days = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,4,'STOCK');
        Integer stockShippedin5Days = (Integer)getLensesDelays(stockLensCYMap,stockLensLYMap,month,5,'STOCK');
        
        double lensShipAvgDelay = getShipmentAvgDelay3Month(rxLensCYMap,rxLensLYMap,stockLensCYMap,stockLensLYMap,month,'both');            
        double rxLensShipAvgDelay = getShipmentAvgDelay3Month(rxLensCYMap,rxLensLYMap,null,null,month,'RX');
        double stockLensShipAvgDelay = getShipmentAvgDelay3Month(null,null,stockLensCYMap,stockLensLYMap,month,'Stock');
        //Ordering Habits //Production Returns
        Map<Integer,Object> CYOrderingHabitsMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'orderingHabits');
        Map<Integer,Object> LYOrderingHabitsMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'orderingHabits');
        Map<Integer,Object> CYLensRetsMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'returns');
        Map<Integer,Object> LYLensRetsMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'returns');
        Map<String,OrderingHabitsWrapper> OrderHabit3MoMap =new  Map<String,OrderingHabitsWrapper>();
        Map<String,OrderingHabitsWrapper> OrderHabit12MoMap =new  Map<String,OrderingHabitsWrapper>();
        Map<String,LensRetsWrapper> lensRet3MoMap =new Map<String,LensRetsWrapper>();
        Map<String,LensRetsWrapper> lensRet12MoMap =new Map<String,LensRetsWrapper>();
        try {
             switch on month {               
                when  1{                       
                    List<String> monthsList=new List<String>{'10:CY','11:CY','12:CY'};
                    List<String> twelveMonList=new List<String>{'1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY'};
                    OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList);
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);
                }
                when  2{
                    List<String> monthsList=new List<String>{'11:CY','12:CY','1:CY'};
                    List<String> twelveMonList=new List<String>{'2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList);
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);               
                }  
                when  3{
                    List<String> monthsList=new List<String>{'12:CY','1:CY','2:CY'};
                    List<String> twelveMonList=new List<String>{'3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);                
                }
                when  4{
                    List<String> monthsList=new List<String>{'1:CY','2:CY','3:CY'};
                    List<String> twelveMonList=new List<String>{'4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY','3:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList);
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);               
                }
                when  5{
                    List<String> monthsList=new List<String>{'2:LY','3:LY','4:CY'};
                    List<String> twelveMonList=new List<String>{'5:LY','6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);                
                }
                when  6{
                    List<String> monthsList=new List<String>{'3:LY','4:CY','5:CY'};
                    List<String> twelveMonList=new List<String>{'6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,twelveMonList);                 
                    System.debug(lensNetSaleslast3MoCFY);
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);   
                    System.debug(lensRet3MoMap);
                    System.debug(lensRet12MoMap);
                }
                when  7{
                    List<String> monthsList=new List<String>{'4:CY','5:CY','6:CY'};
                    List<String> twelveMonList=new List<String>{'7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);     
                }
                when  8{
                    List<String> monthsList=new List<String>{'5:CY','6:CY','7:CY'};
                    List<String> twelveMonList=new List<String>{'8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);    
                }
                when  9{
                    List<String> monthsList=new List<String>{'6:CY','7:CY','8:CY'};
                    List<String> twelveMonList=new List<String>{'9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);          
                }
                when  10{
                    List<String> monthsList=new List<String>{'7:CY','8:CY','9:CY'};
                    List<String> twelveMonList=new List<String>{'10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);         
                }
                when  11{
                    List<String> monthsList=new List<String>{'8:CY','9:CY','10:CY'};	
                    List<String> twelveMonList=new List<String>{'11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);    
                }
                when  12{
                    List<String> monthsList=new List<String>{'9:CY','10:CY','11:CY'};
                    List<String> twelveMonList=new List<String>{'12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY'};
					OrderHabit3MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,monthsList);
                    OrderHabit12MoMap=getMonthsOrderingHabits(CYOrderingHabitsMap,null,twelveMonList); 
                    lensRet3MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,monthsList,lensNetSaleslast3MoCFY);
                    lensRet12MoMap=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,lensesNetSalesLast12Mo);    
                }
                when else {
                  //do nothing
                } 
            }
         }
         catch (Exception e) {
            LogException.log(e);
        } 
        //Calculate Trackers
        double lensQtyTrend = getVariation(lensQty3MoCFY,lenslast12MoQty);
        double contactLensQtylast3Mon = getLensesQuantityLast3Month(accStatisticsCYMap,accStatisticsLYMap,month,'contactLens');
        double contactLensQtylast12Mon = getLensesQtyLast12Mo(accStatisticsCYMap,accStatisticsLYMap,month,'contactLens');
        double contactLensQtyTrend = getVariation(contactLensQtylast3Mon,contactLensQtylast12Mon);
        double framesQtylast3Mon = getLensesQuantityLast3Month(accStatisticsCYMap,accStatisticsLYMap,month,'frames');
        double framesQtylast12Mon = getLensesQtyLast12Mo(accStatisticsCYMap,accStatisticsLYMap,month,'frames');
        double framesQtyTrend = getVariation(framesQtylast3Mon,framesQtylast12Mon);
        //For Sv,FR lenses etc calculation
        Map<Integer,Object> CYSvLensMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'sv');
        Map<Integer,Object> LYSvLensMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'sv');
        double svLast12MoQty = getQtyLastMo(CYSvLensMap,LYSvLensMap,month,12);
        double svLast3MonQty = getQtyLastMo(CYSvLensMap,LYSvLensMap,month,3);
        double svVsTotalQty12 = getVariation(svLast12MoQty,lenslast12MoQty);
        double svVsTotalQty3 = getVariation(svLast3MonQty,lensQty3MoCFY);
        double svlastMonthQty = getLastMonthQty(CYSvLensMap,LYSvLensMap,month);        
        double svQtyTrend = getVariation(svLast3MonQty,svLast12MoQty);
        
        Map<Integer,Object> CYPalLensMap=getTotalValues(null,lensSalesCyHoya1Map,'pal');
        Map<Integer,Object> LYPalLensMap=getTotalValues(null,lensSalesLyHoya1Map,'pal');
        
        double palLast12MoNetSales = getSalesLastMo(CYPalLensMap,LYPalLensMap,month,12);
        System.debug(palLast12MoNetSales+'   '+lensesNetSalesLast12Mo);
        double palSalesVsTotalSales12Mo = getVariation(palLast12MoNetSales,lensesNetSalesLast12Mo);
        double palLast3MoNetSales = getSalesLastMo(CYPalLensMap,LYPalLensMap,month,3);
        double palSalesVsTotalSales3Mo = getVariation(palLast3MoNetSales,lensNetSaleslast3MoCFY);
        double palLast12MoQty = getQtyLastMo(CYPalLensMap,LYPalLensMap,month,12);
        double palLast3MonQty = getQtyLastMo(CYPalLensMap,LYPalLensMap,month,3);
        double palVsTotalQty12 = getVariation(palLast12MoQty,lenslast12MoQty);
        double palVsTotalQty3 = getVariation(palLast3MonQty,lensQty3MoCFY);
        double pallastMonthQty = getLastMonthQty(CYPalLensMap,LYPalLensMap,month);
        double palQtyTrend = getVariation(palLast3MonQty,palLast12MoQty);
        
        Map<Integer,Object> CYIndividualLensMap=getTotalValues(null,lensSalesCyHoya1Map,'individual');
        Map<Integer,Object> LYIndividualLensMap=getTotalValues(null,lensSalesLyHoya1Map,'individual');
        double indiLast12MoNetSales = getSalesLastMo(CYIndividualLensMap,LYIndividualLensMap,month,12);
        double indiLast3MoNetSales = getSalesLastMo(CYIndividualLensMap,LYIndividualLensMap,month,3);
        double indiLast12MoQty = getQtyLastMo(CYIndividualLensMap,LYIndividualLensMap,month,12);
        double indiLast3MonQty = getQtyLastMo(CYIndividualLensMap,LYIndividualLensMap,month,3);
        double indiVsTotalQty12 = getVariation(indiLast12MoQty,lenslast12MoQty);
        double indiVsTotalQty3 = getVariation(indiLast3MonQty,lensQty3MoCFY);
        double indilastMonthQty = getLastMonthQty(CYIndividualLensMap,LYIndividualLensMap,month);
        double indiQtyTrend = getVariation(indiLast3MonQty,indiLast12MoQty);
        double indiSalesVsTotalSales12Mo = getVariation(indiLast12MoNetSales,lensesNetSalesLast12Mo); 
        double indiSalesVsTotalSales3Mo = getVariation(indiLast3MoNetSales,lensNetSaleslast3MoCFY);
        
        Map<Integer,Object> CYBrillianceLensMap=getTotalValues(null,lensSalesCyHoya1Map,'brilliance');
        Map<Integer,Object> LYBrillianceLensMap=getTotalValues(null,lensSalesLyHoya1Map,'brilliance');
        double brillianceLast12MoQty = getQtyLastMo(CYBrillianceLensMap,LYBrillianceLensMap,month,12);
        double brillianceLast3MonQty = getQtyLastMo(CYBrillianceLensMap,LYBrillianceLensMap,month,3);
        double brilianceVsPalQty12 = getVariation(brillianceLast12MoQty,palLast12MoQty);
        double brilianceVsPalQty3 = getVariation(brillianceLast3MonQty,palLast3MonQty);
        double briliancelastMonthQty = getLastMonthQty(CYBrillianceLensMap,LYBrillianceLensMap,month);
        double brilianceQtyTrend = getVariation(brillianceLast3MonQty,brillianceLast12MoQty);
        
        Map<Integer,Object> CYTwoPairsMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'twoPairs');
        Map<Integer,Object> LYTwoPairsMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'twoPairs');
        double twoPairsLast12MoQty = getQtyLastMo(CYTwoPairsMap,LYTwoPairsMap,month,12);
        double twoPairsLast3MonQty = getQtyLastMo(CYTwoPairsMap,LYTwoPairsMap,month,3);
        double twopairsVsTotalQty12 = getVariation(twoPairsLast12MoQty,lenslast12MoQty);
        double twopairsVsTotalQty3 = getVariation(twoPairsLast3MonQty,lensQty3MoCFY);
        double twopairslastMonthQty = getLastMonthQty(CYTwoPairsMap,LYTwoPairsMap,month);
        double twopairsQtyTrend = getVariation(twoPairsLast3MonQty,twoPairsLast12MoQty);
        
        Map<Integer,Object> CYFrMap=getTotalValues(null,lensSalesCyHoya1Map,'fr');
        Map<Integer,Object> LYFrMap=getTotalValues(null,lensSalesLyHoya1Map,'fr');
        double frLast12MoQty = getQtyLastMo(CYFrMap,LYFrMap,month,12);
        double frLast3MonQty = getQtyLastMo(CYFrMap,LYFrMap,month,3);
        double frVsTotalQty12 = getVariation(frLast12MoQty,lenslast12MoQty);
        double frVsTotalQty3 = getVariation(frLast3MonQty,lensQty3MoCFY);
        double frlastMonthQty = getLastMonthQty(CYFrMap,LYFrMap,month);
        double frQtyTrend = getVariation(frLast3MonQty,frLast12MoQty);
        
        Map<Integer,Object> CYXceptionMap=getTotalValues(null,lensSalesCyHoya1Map,'xception');
        Map<Integer,Object> LYXceptionMap=getTotalValues(null,lensSalesLyHoya1Map,'xception');
        double xceptionLast12MoQty = getQtyLastMo(CYXceptionMap,LYXceptionMap,month,12);
        double xceptionLast3MonQty = getQtyLastMo(CYXceptionMap,LYXceptionMap,month,3);
        double xceptionVsTotalQty12 = getVariation(xceptionLast12MoQty,lenslast12MoQty);
        double xceptionVsTotalQty3 = getVariation(xceptionLast3MonQty,lensQty3MoCFY);
        double xceptionlastMonthQty = getLastMonthQty(CYXceptionMap,LYXceptionMap,month);
        double xceptionQtyTrend = getVariation(xceptionLast3MonQty,xceptionLast12MoQty);
        
        Map<Integer,Object> CYSmartZoomMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'smartZoom');
        Map<Integer,Object> LYSmartZoomMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'smartZoom');
        double smartZoomLast12MoQty = getQtyLastMo(CYSmartZoomMap,LYSmartZoomMap,month,12);
        double smartZoomLast3MonQty = getQtyLastMo(CYSmartZoomMap,LYSmartZoomMap,month,3);
        double smartZoomVsSvQty12 = getVariation(smartZoomLast12MoQty,svLast12MoQty);
        double smartZoomVsSvQty3 = getVariation(smartZoomLast3MonQty,svLast3MonQty);
        double smartZoomlastMonthQty = getLastMonthQty(CYSmartZoomMap,LYSmartZoomMap,month);
        double smartZoomQtyTrend = getVariation(smartZoomLast3MonQty,smartZoomLast12MoQty);
        
        Map<Integer,Object> CYMiyoSmartMap=getTotalValues(lensSalesCyHoya0Map,lensSalesCyHoya1Map,'miyoSmart');
        Map<Integer,Object> LYMiyoSmartMap=getTotalValues(lensSalesLyHoya0Map,lensSalesLyHoya1Map,'miyoSmart');
        double miyoLast12MoQty = getQtyLastMo(CYMiyoSmartMap,LYMiyoSmartMap,month,12);
        double miyoLast3MonQty = getQtyLastMo(CYMiyoSmartMap,LYMiyoSmartMap,month,3);
        double miyoSmartVsSvQty12 = getVariation(miyoLast12MoQty,svLast12MoQty);
        double miyoSmartVsSvQty3 = getVariation(miyoLast3MonQty,svLast3MonQty);
        double miyoSmartlastMonthQty = getLastMonthQty(CYMiyoSmartMap,LYMiyoSmartMap,month);
        double miyoSmartQtyTrend = getVariation(miyoLast3MonQty,miyoLast12MoQty);
        
        //Assign the values to new object
        Last_Sales_Statistics__c lastStatistics =new Last_Sales_Statistics__c();
        lastStatistics.Account__c = acc.Id;
        lastStatistics.Lenses_Gross_Sales_Last_Month__c = lensesNetSalesLastMonth;
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
        lastStatistics.Lenses_Net_Sales_Forecast_CFY_vs_LFY__c  = lensesNetSalesForecastCFYvsLFY;
        lastStatistics.Lenses_Net_Sales_Forecast_vs_ECP_Agreeme__c = lensesNetForecastvsECPAgreement;
        lastStatistics.Lenses_Qty_Last_Month__c = lensQtyLastMonth;
        lastStatistics.Lenses_Qty_Last_12Mo__c = lenslast12MoQty;
        lastStatistics.Lenses_Qty_LFY__c = lensQtyLFY;
        lastStatistics.Lenses_Qty_Last_12Mo_vs_LFY__c = lensQty12MovsLFY;
        lastStatistics.Lenses_Qty_CFY__c = lensQtyCFY;
        lastStatistics.Lenses_Qty_LFY_YTD__c = lensQtyLFYYTD;
        lastStatistics.Lenses_Qty_CFY_vs_LFY_YTD__c = lensQtyCFyvsLFYYTD;
        lastStatistics.Lenses_Qty_Last_3Mo_CFY__c = lensQty3MoCFY;
        lastStatistics.Lenses_Qty_Last_3Mo_LFY__c = lensQty3MoLFY;
        lastStatistics.Lenses_Qty_Last_3Mo_CFY_vs_LFY__c = lensQty3MoCFYvsLFY;   
        lastStatistics.Lenses_Gross_Sales_Last_Month__c  = lensesGrossSalesLastMonth;
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
        lastStatistics.Lenses_Gross_Sales_Forecast_vs_ECP_Agree__c = lensesGrossForecastvsECPAgreement;
        lastStatistics.Lenses_Gross_Sales_Forecast_CFY_vs_LFY__c = lensesGrossSalesForecastCFYvsLFY;
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
        lastStatistics.Discount_on_Lenses_Gross_Sales_Last_12Mo__c = discountOnLensGrossSalesLast12Mo;
        //Ordering Habits 
        if(OrderHabit3MoMap.size() > 0 && OrderHabit3MoMap.containsKey('perc')){
            OrderingHabitsWrapper OhPercWrapper = OrderHabit3MoMap.get('perc');
            System.debug(OhPercWrapper.ManualOrders);
            lastStatistics.Manual_Orders_L3Mo__c = Double.valueOf(OhPercWrapper.ManualOrders) ;
            lastStatistics.HVC_Systems_L3Mo__c = Double.valueOf(OhPercWrapper.HVCsys);
            lastStatistics.Other_Digital_Orders_L3Mo__c = Double.valueOf(OhPercWrapper.OtherOrders);
            lastStatistics.Frames_Provided_By_HVC_L3Mo__c = Double.valueOf(OhPercWrapper.FramesByHvc);
            lastStatistics.Uncut_Lenses_L3Mo__c = Double.valueOf(OhPercWrapper.UnCutlens);
            lastStatistics.Remote_Edging_L3Mo__c = Double.valueOf(OhPercWrapper.RemoteEdging);
            lastStatistics.Mounting_L3Mo__c = Double.valueOf(OhPercWrapper.Mounting);
            lastStatistics.Real_Shape_Precal_L3Mo__c = Double.valueOf(OhPercWrapper.RealShape);
            lastStatistics.Standard_Shape_Precal_L3Mo__c = Double.valueOf(OhPercWrapper.StandShape);
            lastStatistics.Boxing_Precal_L3Mo__c = Double.valueOf(OhPercWrapper.Boxing);
            if(OrderHabit12MoMap.size() > 0 && OrderHabit12MoMap.containsKey('value')){
                double month12RemoteQty = Double.valueOf(OrderHabit12MoMap.get('value').RemoteEdging);
                double month12Mounting = Double.valueOf(OrderHabit12MoMap.get('value').Mounting);
                if(month12RemoteQty != null && month12RemoteQty != 0)
                	lastStatistics.Remote_Edging_Qty_Trend__c = ((Double.valueOf(OhPercWrapper.RemoteEdging)-month12RemoteQty)/month12RemoteQty)*100;
                 if(month12Mounting != null && month12Mounting != 0)
                	lastStatistics.Mounting_Qty_Trend__c = ((Double.valueOf(OhPercWrapper.Mounting)-month12Mounting)/month12Mounting)*100;      
            }
        }
        //Production returns
        if(lensRet3MoMap.size() > 0 && lensRet3MoMap.containsKey('value') ){
            LensRetsWrapper lensRets= lensRet3MoMap.get('value');
            double totalProdRet = Double.valueOf(lensRets.ProdRet)+Double.valueOf(lensRets.CutRet)+Double.valueOf(lensRets.MountRet);
            double totalNonProdRet = Double.valueOf(lensRets.SalesRet)+Double.valueOf(lensRets.OrderMisRet)+Double.valueOf(lensRets.NonAdapRet)+Double.valueOf(lensRets.DeliveryRet)+Double.valueOf(lensRets.OtherRet);
            double totalCount = lensNetSaleslast3MoCFY+totalProdRet+totalNonProdRet;   
            lastStatistics.Total_Production_Returns_L3Mo__c = (totalProdRet/totalCount)*10000;
            lastStatistics.Total_Non_Production_Returns_L3Mo__c = (totalNonProdRet/totalCount)*10000;
            lastStatistics.Total_Returns_L3Mo__c = ((totalProdRet+totalNonProdRet)/totalCount)*10000;
        }
        if(lensRet12MoMap.size() > 0 && lensRet12MoMap.containsKey('value')){
            LensRetsWrapper lensRets= lensRet12MoMap.get('value');
            double totalProdRet = Double.valueOf(lensRets.ProdRet)+Double.valueOf(lensRets.CutRet)+Double.valueOf(lensRets.MountRet);
            double totalNonProdRet = Double.valueOf(lensRets.SalesRet)+Double.valueOf(lensRets.OrderMisRet)+Double.valueOf(lensRets.NonAdapRet)+Double.valueOf(lensRets.DeliveryRet)+Double.valueOf(lensRets.OtherRet);
            double totalCount = lensesNetSalesLast12Mo+totalProdRet+totalNonProdRet;   
            lastStatistics.Total_Production_Returns_L12Mo__c = (totalProdRet/totalCount)*10000;
            lastStatistics.Total_Non_Production_Returns_L12Mo__c = (totalNonProdRet/totalCount)*10000;
            lastStatistics.Total_Returns_L12Mo__c = ((totalProdRet+totalNonProdRet)/totalCount)*10000;
        }
        //Trackers assignments
        lastStatistics.Lenses_Qty_Trend__c = lensQtyTrend;
        lastStatistics.Contact_Lenses_Qty_Trend__c = contactLensQtyTrend;
        lastStatistics.Frames_Qty_Trend__c = framesQtyTrend;
        lastStatistics.SV_Lenses_vs_Total_Qty_L12Mo__c = svVsTotalQty12 ;
        lastStatistics.SV_Lenses_vs_Total_Qty_L3Mo__c = svVsTotalQty3 ;
        lastStatistics.SV_Lenses_Last_Mo_Qty__c = svlastMonthQty ;
        lastStatistics.SV_Lenses_Qty_Trend__c = svQtyTrend ;
        lastStatistics.PAL_Lenses_vs_Total_Qty_L12Mo__c = palVsTotalQty12 ;
        lastStatistics.PAL_Lenses_vs_Total_Qty_L3Mo__c = palVsTotalQty3 ;
        lastStatistics.PAL_Lenses_Last_Mo_Qty__c = pallastMonthQty ;
        lastStatistics.PAL_Lenses_Qty_Trend__c = palQtyTrend ;
        lastStatistics.PAL_Lenses_vs_Total_Net_Sales_L12Mo__c = palSalesVsTotalSales12Mo;
        lastStatistics.PAL_Lenses_vs_Total_Net_Sales_L3Mo__c = palSalesVsTotalSales3Mo;
        lastStatistics.Individualised_Lenses_vs_Total_Qty_L12M__c = indiVsTotalQty12 ;
        lastStatistics.Individualised_Lenses_vs_Total_Qty_L3Mo__c = indiVsTotalQty3 ;
        lastStatistics.Individualised_vs_Total_Net_Sales_L12Mo__c = indiSalesVsTotalSales12Mo;
        lastStatistics.Individualised_vs_Total_Net_Sales_L3Mo__c = indiSalesVsTotalSales3Mo;
        lastStatistics.Individualised_Lenses_Last_Mo_Qty__c = indilastMonthQty ;
        lastStatistics.Individualised_Lenses_Qty_Trend__c = indiQtyTrend ;
        lastStatistics.SEIKO_Brilliance_vs_Total_PAL_Qty_L12Mo__c = brilianceVsPalQty12 ;
        lastStatistics.SEIKO_Brilliance_vs_Total_PAL_Qty_L3Mo__c = brilianceVsPalQty3 ;
        lastStatistics.SEIKO_Brilliance_Last_Mo_Qty__c = briliancelastMonthQty ;
        lastStatistics.SEIKO_Brilliance_Qty_Trend__c = brilianceQtyTrend ;
        lastStatistics.SEIKO_2nd_Pairs_vs_Total_Qty_L12Mo__c = twopairsVsTotalQty12 ;
        lastStatistics.SEIKO_2nd_Pairs_vs_Total_Qty_L3Mo__c = twopairsVsTotalQty3 ;
        lastStatistics.SEIKO_2nd_Pairs_Last_Mo_Qty__c = twopairslastMonthQty  ;
        lastStatistics.SEIKO_2nd_Pairs_Qty_Trend__c = twopairsQtyTrend ;
        lastStatistics.SEIKO_FR_vs_Total_Qty_L12Mo__c = frVsTotalQty12  ;
        lastStatistics.SEIKO_FR_vs_Total_Qty_L3Mo__c = frVsTotalQty3 ;
        lastStatistics.SEIKO_FR_Last_Mo_Qty__c = frlastMonthQty ;
        lastStatistics.SEIKO_FR_Qty_Trend__c = frQtyTrend ;
        lastStatistics.SEIKO_Smartzoom_vs_Total_SV_Qty_L12Mo__c = smartZoomVsSvQty12 ;
        lastStatistics.SEIKO_Smartzoom_vs_Total_SV_Qty_L3Mo__c = smartZoomVsSvQty3 ;
        lastStatistics.SEIKO_Smartzoom_Last_Mo_Qty__c = smartZoomlastMonthQty ;
        lastStatistics.SEIKO_Smartzoom_Qty_Trend__c = smartZoomQtyTrend ;
        lastStatistics.SEIKO_XCEPTION_vs_Total_Qty_L12Mo__c = xceptionVsTotalQty12 ;
        lastStatistics.SEIKO_XCEPTION_vs_Total_Qty_L3Mo__c = xceptionVsTotalQty3 ;
        lastStatistics.SEIKO_XCEPTION_Last_Mo_Qty__c = xceptionlastMonthQty ;
        lastStatistics.SEIKO_XCEPTION_Qty_Trend__c = xceptionQtyTrend ;
        lastStatistics.MiyoSmart_vs_Total_SV_Qty_L12Mo__c = miyoSmartVsSvQty12 ;
        lastStatistics.MiyoSmart_vs_Total_SV_Qty_L3Mo__c = miyoSmartVsSvQty3; 
        lastStatistics.MiyoSmart_Last_Mo_Qty__c = miyoSmartlastMonthQty ;
        lastStatistics.MiyoSmart_Qty_Trend__c = miyoSmartQtyTrend ;
        
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
        lastStatistics.Lenses_Shipment_Avg_Delay_in_Days_3Mo__c = lensShipAvgDelay;
        lastStatistics.Lenses_Shipment_RX_Average_Delay_3Mo__c = rxLensShipAvgDelay;
        lastStatistics.Lenses_Shipment_STOCK_Average_Delay_3Mo__c = stockLensShipAvgDelay;
        lastSalesStatisticsList.add(lastStatistics);
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
    public double getVariation(double CYVal,double LYVal){
        double result =0;
        if(LYVal != 0)
        	result = ((CYVal -LYVal)/LYVal)*100;        
        return result;        
    }
    public static orderingHabitsWrapper parseOrderingHabitsJson(String orderHabitsJson){
        orderingHabitsWrapper wrapper=new orderingHabitsWrapper();
        JSONParser parser = JSON.createParser(orderHabitsJson);
        orderingHabitsWrapper obj = wrapper.parse(orderHabitsJson);        
        return obj;
    }
    public static LensRetsWrapper parseLensRetsJson(String lensReturnsJson){
        LensRetsWrapper wrapper=new LensRetsWrapper();
        JSONParser parser = JSON.createParser(lensReturnsJson);
        LensRetsWrapper obj = wrapper.parse(lensReturnsJson);        
        return obj;
    } 
    public static double getLastMonthQty(Map<Integer,Object> CurrentYearMap, Map<Integer,Object> LastYearMap, Integer month){
        double result = 0;
        Map<Integer,StatisticsObj> CYMap = changeObject(CurrentYearMap);
        Map<Integer,StatisticsObj> LYMap = changeObject(LastYearMap);
        Integer lastmon = month;
        if(month == 1)
            lastmon = 12;
        else
            lastmon = month-1;
        if(month == 4){
            if(LYMap.size() > 0 && LYMap.containsKey(lastmon))
                result=LYMap.get(lastmon).qty;
        }
        else{
            if(CYMap.size() > 0 && CYMap.containsKey(lastmon))
                result=CYMap.get(lastmon).qty;
        }      
        return result;
    }
    public Map<Integer,Object> getTotalValues(Map<Double,Sales_Statistics__c> salesMap0,Map<Double,Sales_Statistics__c> salesMap1,String type ){
        Map<Integer,Object> orderingHabitsMap=new Map<Integer,Object>();
        //To avoid null pointer exception and to avoid check every time adde the below loop for all months
        for(Integer i = 1 ; i <= 12 ; i++){ 
            if(type == 'orderingHabits'){
                OrderingHabitsWrapper orderType0 =new OrderingHabitsWrapper();                
                OrderingHabitsWrapper orderType1 =new OrderingHabitsWrapper();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    if(salesMap0.get(i).OrderingHabitsJson__c != null)
                        orderType0 =parseOrderingHabitsJson(salesMap0.get(i).OrderingHabitsJson__c);
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    if(salesMap1.get(i).OrderingHabitsJson__c != null)
                        orderType1 =parseOrderingHabitsJson(salesMap1.get(i).OrderingHabitsJson__c);
                }
                OrderingHabitsWrapper orderTypeall=new OrderingHabitsWrapper();
                double manualCount=0;
                double hvcCount = 0;
                double otherCount = 0;
                double uncutCount = 0;
                double remoteCount = 0;
                double mountingCount = 0;
                double framesHvcCount = 0;
                double realShapeCount = 0;
                double standShapeCount = 0;
                double boxingCount = 0;
                if(orderType0 != null ){
                    manualCount += double.valueOf(orderType0.ManualOrders);
                    hvcCount += double.valueOf(orderType0.HVCsys);                
                    otherCount += double.valueOf(orderType0.OtherOrders);
                    uncutCount += double.valueOf(orderType0.UnCutlens);
                    remoteCount += double.valueOf(orderType0.RemoteEdging);
                    mountingCount += double.valueOf(orderType0.Mounting);
                    framesHvcCount += double.valueOf(orderType0.FramesByHvc);
                    realShapeCount += double.valueOf(orderType0.RealShape);
                    standShapeCount += double.valueOf(orderType0.StandShape);
                    boxingCount += double.valueOf(orderType0.Boxing);                  
                }
                if(orderType1 != null ){
                    manualCount += double.valueOf(orderType1.ManualOrders);
                    hvcCount += double.valueOf(orderType1.HVCsys);                
                    otherCount += double.valueOf(orderType1.OtherOrders);
                    uncutCount += double.valueOf(orderType1.UnCutlens);
                    remoteCount += double.valueOf(orderType1.RemoteEdging);
                    mountingCount += double.valueOf(orderType1.Mounting);
                    framesHvcCount += double.valueOf(orderType1.FramesByHvc);
                    realShapeCount += double.valueOf(orderType1.RealShape);
                    standShapeCount += double.valueOf(orderType1.StandShape);
                    boxingCount += double.valueOf(orderType1.Boxing);
                }
                orderTypeall.ManualOrders = String.valueOf(manualCount);
                orderTypeall.HVCsys = String.valueOf(hvcCount);
                orderTypeall.OtherOrders = String.valueOf(otherCount);
                orderTypeall.UnCutlens = String.valueOf(uncutCount);
                orderTypeall.RemoteEdging = String.valueOf(remoteCount);
                orderTypeall.Mounting = String.valueOf(mountingCount);
                orderTypeall.FramesByHvc = String.valueOf(framesHvcCount);
                orderTypeall.RealShape = String.valueOf(realShapeCount);
                orderTypeall.StandShape = String.valueOf(standShapeCount);
                orderTypeall.Boxing = String.valueOf(boxingCount);
                orderingHabitsMap.put(i,orderTypeall);
            }
            else if(type == 'returns'){
                LensRetsWrapper lensRet0 = new LensRetsWrapper();
                LensRetsWrapper lensRet1 = new LensRetsWrapper();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    if(salesMap0.get(i).LensReturnsJson__c != null)
                        lensRet0 = parseLensRetsJson(salesMap0.get(i).LensReturnsJson__c);
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    if(salesMap1.get(i).LensReturnsJson__c != null)
                        lensRet1 = parseLensRetsJson(salesMap1.get(i).LensReturnsJson__c);
                }
                
                double prodRet = 0;
                double cutRet = 0;
                double mountingRet = 0;
                double agreementRet = 0;
                double mistakeRet = 0;
                double nonAdaptRet = 0;
                double deliveryRet = 0;
                double otherRet = 0;
                if(lensRet0 != null){
                    prodRet += double.valueOf(lensRet0.ProdRet);
                    cutRet += double.valueOf(lensRet0.CutRet);
                    mountingRet += double.valueOf(lensRet0.MountRet);
                    agreementRet += double.valueOf(lensRet0.SalesRet);
                    mistakeRet += double.valueOf(lensRet0.OrderMisRet);
                    nonAdaptRet += double.valueOf(lensRet0.NonAdapRet);
                    deliveryRet += double.valueOf(lensRet0.DeliveryRet);
                    otherRet += double.valueOf(lensRet0.OtherRet);
                }
                if(lensRet1 != null){
                    prodRet += double.valueOf(lensRet1.ProdRet);
                    cutRet += double.valueOf(lensRet1.CutRet);
                    mountingRet += double.valueOf(lensRet1.MountRet);
                    agreementRet += double.valueOf(lensRet1.SalesRet);
                    mistakeRet += double.valueOf(lensRet1.OrderMisRet);
                    nonAdaptRet += double.valueOf(lensRet1.NonAdapRet);
                    deliveryRet += double.valueOf(lensRet1.DeliveryRet);
                    otherRet += double.valueOf(lensRet1.OtherRet);
                }
                LensRetsWrapper lensWrapper = new LensRetsWrapper();
                lensWrapper.ProdRet = String.valueOf(prodRet);
                lensWrapper.CutRet = String.valueOf(cutRet);
                lensWrapper.MountRet = String.valueOf(mountingRet);
                lensWrapper.SalesRet = String.valueOf(agreementRet);
                lensWrapper.OrderMisRet = String.valueOf(mistakeRet);
                lensWrapper.NonAdapRet = String.valueOf(nonAdaptRet);
                lensWrapper.DeliveryRet = String.valueOf(deliveryRet);
                lensWrapper.OtherRet = String.valueOf(otherRet);
                orderingHabitsMap.put(i,lensWrapper);
            }
            else if(type == 'sv'){
                StatisticsObj obj =new StatisticsObj();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    obj.qty += salesMap0.get(i).SV_Lenses_Qty__c == null ? 0 : salesMap0.get(i).SV_Lenses_Qty__c;
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SV_Lenses_Qty__c == null? 0: salesMap1.get(i).SV_Lenses_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'pal'){
                StatisticsObj obj =new StatisticsObj();               
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.netSales += salesMap1.get(i).Progressive_Lenses_Net_Sales__c == null? 0 : salesMap1.get(i).Progressive_Lenses_Net_Sales__c;
                    obj.qty += salesMap1.get(i).Progressive_Lenses_Qty__c == null? 0 : salesMap1.get(i).Progressive_Lenses_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
                system.debug(orderingHabitsMap);
            }
            else if(type == 'individual'){
                StatisticsObj obj =new StatisticsObj();               
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.netSales += salesMap1.get(i).Individualised_Lenses_Net_Sales__c == null? 0: salesMap1.get(i).Individualised_Lenses_Net_Sales__c ;
                    obj.qty += salesMap1.get(i).Individualised_Lenses_Qty__c == null? 0 : salesMap1.get(i).Individualised_Lenses_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'brilliance'){
                StatisticsObj obj =new StatisticsObj();               
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SEIKO_Brilliance_Qty__c == null ? 0: salesMap1.get(i).SEIKO_Brilliance_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'twoPairs'){
                StatisticsObj obj =new StatisticsObj();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    obj.qty += salesMap0.get(i).SEIKO_2ndPairs_Qty__c == null ? 0: salesMap0.get(i).SEIKO_2ndPairs_Qty__c;
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SEIKO_2ndPairs_Qty__c == null ? 0 : salesMap1.get(i).SEIKO_2ndPairs_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'fr'){
                StatisticsObj obj =new StatisticsObj();               
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SEIKO_FR_Qty__c == null ? 0 :salesMap1.get(i).SEIKO_FR_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'xception'){
                StatisticsObj obj =new StatisticsObj();
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SEIKO_XCEPTION_Qty__c == null ? 0:salesMap1.get(i).SEIKO_XCEPTION_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
            else if(type == 'smartZoom'){
                StatisticsObj obj =new StatisticsObj();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    obj.qty += salesMap0.get(i).SEIKO_Smartzoom_Qty__c == null ? 0: salesMap0.get(i).SEIKO_Smartzoom_Qty__c;
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).SEIKO_Smartzoom_Qty__c == null ? 0: salesMap1.get(i).SEIKO_Smartzoom_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }       
            else if(type == 'miyoSmart'){  
                StatisticsObj obj =new StatisticsObj();
                if(salesMap0.size() > 0 && salesMap0.containsKey(i)){
                    obj.qty += salesMap0.get(i).MiyoSmart_Qty__c == null ? 0 :salesMap0.get(i).MiyoSmart_Qty__c;
                }
                if(salesMap1.size() > 0 && salesMap1.containsKey(i)){
                    obj.qty += salesMap1.get(i).MiyoSmart_Qty__c == null ? 0: salesMap1.get(i).MiyoSmart_Qty__c;
                }
                orderingHabitsMap.put(i,obj);
            }
        }
        return orderingHabitsMap;
    }
    public Map<String,OrderingHabitsWrapper> getMonthsOrderingHabits( Map<Integer,Object> CYOrderingHabitsMap,Map<Integer,Object> LYOrderingHabitsMap,List<String> monthNoList){
        Map<String,OrderingHabitsWrapper> valuePercMap = new Map<String,OrderingHabitsWrapper>();
        double manualOrderCount=0;
        double hvcOrderCount = 0;
        double otherOrderCount = 0;
        double unCutCount = 0;
        double remoteEdgingCount = 0;
        double mountingCount = 0;
        double framesByHvc = 0;
        double realShapeCount = 0;
        double standShapeCount = 0;
        double boxingCount = 0;
        
        
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
        if(CYOrderingHabitsMap != null && CYOrderingHabitsMap.size() > 0  && CYMonList.size() > 0){
            for(Integer CYmon:CYMonList){
                OrderingHabitsWrapper wrapper=(OrderingHabitsWrapper)CYOrderingHabitsMap.get(CYmon);
                manualOrderCount += double.valueOf(wrapper.ManualOrders) ;
                hvcOrderCount += double.valueOf(wrapper.HVCsys) ;
                otherOrderCount += double.valueOf(wrapper.OtherOrders) ;
                realShapeCount += double.valueOf(wrapper.RealShape) ;
                standShapeCount += double.valueOf(wrapper.StandShape);
                boxingCount += double.valueOf(wrapper.Boxing);
                unCutCount +=double.valueOf(wrapper.UnCutlens);
                remoteEdgingCount += double.valueOf(wrapper.RemoteEdging);
                mountingCount += double.valueOf(wrapper.Mounting);
                framesByHvc += double.valueOf(wrapper.FramesByHvc);
            }
        }
        system.debug(LYMonList.size()+''+LYOrderingHabitsMap);
        if(LYOrderingHabitsMap != null && LYOrderingHabitsMap.size() > 0 && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){
                OrderingHabitsWrapper wrapper=(OrderingHabitsWrapper)LYOrderingHabitsMap.get(LYmon);
                system.debug(wrapper);
                manualOrderCount += double.valueOf(wrapper.ManualOrders) ;
                hvcOrderCount += double.valueOf(wrapper.HVCsys) ;
                otherOrderCount += double.valueOf(wrapper.OtherOrders) ;
                realShapeCount += double.valueOf(wrapper.RealShape) ;
                standShapeCount += double.valueOf(wrapper.StandShape);
                boxingCount += double.valueOf(wrapper.Boxing);
                unCutCount +=double.valueOf(wrapper.UnCutlens);
                remoteEdgingCount += double.valueOf(wrapper.RemoteEdging);
                mountingCount += double.valueOf(wrapper.Mounting);
                framesByHvc += double.valueOf(wrapper.FramesByHvc);
                system.debug(manualOrderCount);
            }
        }
        OrderingHabitsWrapper OhWrapperVal=new OrderingHabitsWrapper();
        OhWrapperVal.ManualOrders=String.valueOf(manualOrderCount);
        OhWrapperVal.HVCsys=String.valueOf(hvcOrderCount);
        OhWrapperVal.OtherOrders=String.valueOf(otherOrderCount);
        OhWrapperVal.UnCutlens=String.valueOf(unCutCount);
        OhWrapperVal.RemoteEdging=String.valueOf(remoteEdgingCount);
        OhWrapperVal.Mounting=String.valueOf(mountingCount);
        OhWrapperVal.FramesByHvc=String.valueOf(framesByHvc);
        OhWrapperVal.RealShape=String.valueOf(realShapeCount);
        OhWrapperVal.StandShape=String.valueOf(standShapeCount);
        OhWrapperVal.Boxing=String.valueOf(boxingCount);
        valuePercMap.put('value',OhWrapperVal);
        OrderingHabitsWrapper OhWrapperPerc=new OrderingHabitsWrapper();
        
        double manualOrderPerc=0;
        double hvcOrderPerc=0;
        double otherOrderPerc=0;
        double unCutPerc=0;
        double remoteEdgingPerc=0;
        double mountingPerc=0;
        double framesByHvcPerc=0;
        double realShapePerc=0;
        double standShapePerc=0;
        double boxingPerc=0;
        //Calculate Percenatges
        double totalCount1 = manualOrderCount+hvcOrderCount+otherOrderCount;
        if(totalCount1 != 0){
            manualOrderPerc = (manualOrderCount/totalCount1)*100;
            system.debug(manualOrderPerc);
            hvcOrderPerc  = (hvcOrderCount/totalCount1)*100;
            otherOrderPerc = (otherOrderCount/(double)totalCount1)*100;            
        }
        double totalCount2 = unCutCount+remoteEdgingCount+mountingCount+framesByHvc;
        if(totalCount2 != 0){
            unCutPerc = (unCutCount/totalCount2)*100;
            remoteEdgingPerc = (remoteEdgingCount/totalCount2)*100;
            mountingPerc = (mountingCount/totalCount2)*100;
            framesByHvcPerc = (framesByHvc/totalCount2)*100;
        } 
        double totalCount3 = realShapeCount+standShapeCount+boxingCount;
        if(totalCount3 != 0){                            
            realShapePerc = (realShapeCount/totalCount3)*100;
            standShapePerc = (standShapeCount/totalCount3)*100;
            boxingPerc = (boxingCount/totalCount3)*100; 
        }
        OhWrapperPerc.ManualOrders=String.valueOf(manualOrderPerc);
        System.debug(OhWrapperPerc.ManualOrders);
        OhWrapperPerc.HVCsys=String.valueOf(hvcOrderPerc);
        OhWrapperPerc.OtherOrders=String.valueOf(otherOrderPerc);
        OhWrapperPerc.UnCutlens=String.valueOf(unCutPerc);
        OhWrapperPerc.RemoteEdging=String.valueOf(remoteEdgingPerc);
        OhWrapperPerc.Mounting=String.valueOf(mountingPerc);
        OhWrapperPerc.FramesByHvc=String.valueOf(framesByHvcPerc);
        OhWrapperPerc.RealShape=String.valueOf(realShapePerc);
        OhWrapperPerc.StandShape=String.valueOf(standShapePerc);
        OhWrapperPerc.Boxing=String.valueOf(boxingPerc);
        valuePercMap.put('perc',OhWrapperPerc);
        return valuePercMap;      
    }
    public Map<String,LensRetsWrapper> getlensRets(Map<Integer,Object> CYLensRetsMap,Map<Integer,Object> LYLensRetsMap,List<String> monthNoList,double lastMoSales){
        Map<String,LensRetsWrapper> valuePercMap =new Map<String,LensRetsWrapper>();
               
        double prodRetMon = 0;
        double cutRetMon = 0;
        double mountingRetMon = 0;
        double agrementRetMon = 0;
        double mistakeRetMon = 0;
        double nonAdapRetMon = 0;
        double deliveryRetMon = 0;
        double otherRetMon = 0;
        
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
                LensRetsWrapper wrapper=(LensRetsWrapper)CYLensRetsMap.get(CYmon);
                System.debug(CYmon+':'+CYLensRetsMap.get(CYmon));
                prodRetMon += Double.valueOf(wrapper.ProdRet) ;
                cutRetMon += Double.valueOf(wrapper.CutRet) ;
                mountingRetMon += Double.valueOf(wrapper.MountRet) ;
                agrementRetMon += Double.valueOf(wrapper.SalesRet) ;
                mistakeRetMon += Double.valueOf(wrapper.OrderMisRet) ;
                nonAdapRetMon += Double.valueOf(wrapper.NonAdapRet) ;
                deliveryRetMon += Double.valueOf(wrapper.DeliveryRet) ;
                otherRetMon += Double.valueOf(wrapper.OtherRet) ;                
            }
        }
        if(LYLensRetsMap != null && LYLensRetsMap.size() > 0  && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){
                LensRetsWrapper wrapper=(LensRetsWrapper)LYLensRetsMap.get(LYmon);
                System.debug(LYmon+':'+LYLensRetsMap.get(LYmon));
                prodRetMon += Double.valueOf(wrapper.ProdRet) ;
                cutRetMon += Double.valueOf(wrapper.CutRet) ;
                mountingRetMon += Double.valueOf(wrapper.MountRet) ;
                agrementRetMon += Double.valueOf(wrapper.SalesRet) ;
                mistakeRetMon += Double.valueOf(wrapper.OrderMisRet) ;
                nonAdapRetMon += Double.valueOf(wrapper.NonAdapRet) ;
                deliveryRetMon += Double.valueOf(wrapper.DeliveryRet) ;
                otherRetMon += Double.valueOf(wrapper.OtherRet) ;                
            }
        }     
        LensRetsWrapper lensRetVal=new LensRetsWrapper();
        lensRetVal.ProdRet=String.valueOf(prodRetMon);
        lensRetVal.CutRet=String.valueOf(cutRetMon);
        lensRetVal.MountRet=String.valueOf(mountingRetMon);
        lensRetVal.SalesRet=String.valueOf(agrementRetMon);
        lensRetVal.OrderMisRet=String.valueOf(mistakeRetMon);
        lensRetVal.NonAdapRet=String.valueOf(nonAdapRetMon);
        lensRetVal.DeliveryRet=String.valueOf(deliveryRetMon);
        lensRetVal.OtherRet=String.valueOf(otherRetMon);
        valuePercMap.put('value',lensRetVal);
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
        double totalProdRet = prodRetMon+cutRetMon+mountingRetMon;
        double totalNonProdRet = agrementRetMon+mistakeRetMon+nonAdapRetMon+deliveryRetMon+otherRetMon;
        double totalCount = lastMoSales+totalProdRet+totalNonProdRet;
        if(totalCount != 0){
            prodRetPerc = (prodRetMon/totalCount)*10000;
            cutRetPerc  = (cutRetMon/totalCount)*10000;
            mountingRetPerc = (mountingRetMon/totalCount)*10000;   
            salesRetperc = (agrementRetMon/totalCount)*10000;
            orderingRetPerc = (mistakeRetMon/totalCount)*10000;
            nonadapRetPerc = (nonAdapRetMon/totalCount)*10000;
            deliveryRetPerc = (deliveryRetMon/totalCount)*10000;
            otherRetPerc = (otherRetMon/totalCount)*10000;
        } 
        LensRetsWrapper lensRet=new LensRetsWrapper();
        lensRet.ProdRet=String.valueOf(prodRetPerc);
        lensRet.CutRet=String.valueOf(cutRetPerc);
        lensRet.MountRet=String.valueOf(mountingRetPerc);
        lensRet.SalesRet=String.valueOf(salesRetperc);
        lensRet.OrderMisRet=String.valueOf(orderingRetPerc);
        lensRet.NonAdapRet=String.valueOf(nonadapRetPerc);
        lensRet.DeliveryRet=String.valueOf(deliveryRetPerc);
        lensRet.OtherRet=String.valueOf(otherRetPerc);
        valuePercMap.put('perc',lensRet);
        return valuePercMap;
    }
    public static Map<Integer,StatisticsObj> changeObject(Map<Integer,Object> currentMap){
        Map<Integer,StatisticsObj> convertedMap = new Map<Integer,StatisticsObj>();
        if(currentMap.size() >  0){
            for(Integer key:currentMap.keySet()){
                convertedMap.put(key,(StatisticsObj)currentMap.get(key));
            }
    	}
    	return convertedMap;
    }
    public static Double getQtyLastMo(Map<Integer,Object> CurrentYearMap, Map<Integer,Object> LastYearMap, Integer month,Integer count){
        Double result = 0;        
        Map<Integer,StatisticsObj> CYMap = changeObject(CurrentYearMap);
        Map<Integer,StatisticsObj> LYMap = changeObject(LastYearMap);
        try{
            if(count == 12){
                switch on month {
                    when  1{result = LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty+CYMap.get(12).qty;}
                    when  2{result = LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty+CYMap.get(12).qty+CYMap.get(1).qty;}
                    when  3{result = LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty+CYMap.get(12).qty+CYMap.get(1).qty+CYMap.get(2).qty;}
                    when  4{result = CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty+CYMap.get(12).qty+CYMap.get(1).qty+CYMap.get(2).qty+CYMap.get(3).qty;}
                    when  5{result = LYMap.get(5).qty+LYMap.get(6).qty+LYMap.get(7).qty+LYMap.get(8).qty+LYMap.get(9).qty+LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty;}
                    when  6{result = LYMap.get(6).qty+LYMap.get(7).qty+LYMap.get(8).qty+LYMap.get(9).qty+LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty;}
                    when  7{result = LYMap.get(7).qty+LYMap.get(8).qty+LYMap.get(9).qty+LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty;}
                    when  8{result = LYMap.get(8).qty+LYMap.get(9).qty+LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty;}
                    when  9{result = LYMap.get(9).qty+LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty;}
                    when  10{result = LYMap.get(10).qty+LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty;}
                    when  11{result = LYMap.get(11).qty+LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty;}
                    when  12{result = LYMap.get(12).qty+LYMap.get(1).qty+LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty;}
                    when else {result=0;}
                }
            }
            else{
                switch on month {
                    when  1{result = CYMap.get(10).qty+CYMap.get(11).qty+CYMap.get(12).qty;}
                    when  2{result = CYMap.get(11).qty+CYMap.get(12).qty+CYMap.get(1).qty;}
                    when  3{result = CYMap.get(12).qty+CYMap.get(1).qty+CYMap.get(2).qty;}
                    when  4{result = CYMap.get(1).qty+CYMap.get(2).qty+CYMap.get(3).qty;}
                    when  5{result = LYMap.get(2).qty+LYMap.get(3).qty+CYMap.get(4).qty;}
                    when  6{result = LYMap.get(3).qty+CYMap.get(4).qty+CYMap.get(5).qty;}
                    when  7{result = CYMap.get(4).qty+CYMap.get(5).qty+CYMap.get(6).qty;}
                    when  8{result = CYMap.get(5).qty+CYMap.get(6).qty+CYMap.get(7).qty;}
                    when  9{result = CYMap.get(6).qty+CYMap.get(7).qty+CYMap.get(8).qty;}
                    when  10{result = CYMap.get(7).qty+CYMap.get(8).qty+CYMap.get(9).qty;}
                    when  11{result = CYMap.get(8).qty+CYMap.get(9).qty+CYMap.get(10).qty;}
                    when  12{result = CYMap.get(9).qty+CYMap.get(10).qty+CYMap.get(11).qty;}
                    when else {result=0;} 
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    public static double getSalesLastMo(Map<Integer,Object> CurrentYearMap,Map<Integer,Object> LastYearMap,Integer month,Integer monthCount){
        double result =0;
        Map<Integer,StatisticsObj> CYMap = changeObject(CurrentYearMap);
        Map<Integer,StatisticsObj> LYMap = changeObject(LastYearMap);
        if(monthCount == 12){
            switch on month {
                when  1{result = LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales+CYMap.get(12).netSales;}
                when  2{result = LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales+CYMap.get(12).netSales+CYMap.get(1).netSales;}
                when  3{result = LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales+CYMap.get(12).netSales+CYMap.get(1).netSales+CYMap.get(2).netSales;}
                when  4{result = CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales+CYMap.get(12).netSales+CYMap.get(1).netSales+CYMap.get(2).netSales+CYMap.get(3).netSales;}
                when  5{result = LYMap.get(5).netSales+LYMap.get(6).netSales+LYMap.get(7).netSales+LYMap.get(8).netSales+LYMap.get(9).netSales+LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales;}
                when  6{result = LYMap.get(6).netSales+LYMap.get(7).netSales+LYMap.get(8).netSales+LYMap.get(9).netSales+LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales;}
                when  7{result = LYMap.get(7).netSales+LYMap.get(8).netSales+LYMap.get(9).netSales+LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales;}
                when  8{result = LYMap.get(8).netSales+LYMap.get(9).netSales+LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales;}
                when  9{result = LYMap.get(9).netSales+LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales;}
                when  10{result = LYMap.get(10).netSales+LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales;}
                when  11{result = LYMap.get(11).netSales+LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales;}
                when  12{result = LYMap.get(12).netSales+LYMap.get(1).netSales+LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales;}
                when else {result=0;}
            }
        }
        else{
            switch on month {
                when  1{result = CYMap.get(10).netSales+CYMap.get(11).netSales+CYMap.get(12).netSales;}
                when  2{result = CYMap.get(11).netSales+CYMap.get(12).netSales+CYMap.get(1).netSales;}
                when  3{result = CYMap.get(12).netSales+CYMap.get(1).netSales+CYMap.get(2).netSales;}
                when  4{result = CYMap.get(1).netSales+CYMap.get(2).netSales+CYMap.get(3).netSales;}
                when  5{result = LYMap.get(2).netSales+LYMap.get(3).netSales+CYMap.get(4).netSales;}
                when  6{result = LYMap.get(3).netSales+CYMap.get(4).netSales+CYMap.get(5).netSales;}
                when  7{result = CYMap.get(4).netSales+CYMap.get(5).netSales+CYMap.get(6).netSales;}
                when  8{result = CYMap.get(5).netSales+CYMap.get(6).netSales+CYMap.get(7).netSales;}
                when  9{result = CYMap.get(6).netSales+CYMap.get(7).netSales+CYMap.get(8).netSales;}
                when  10{result = CYMap.get(7).netSales+CYMap.get(8).netSales+CYMap.get(9).netSales;}
                when  11{result = CYMap.get(8).netSales+CYMap.get(9).netSales+CYMap.get(10).netSales;}
                when  12{result = CYMap.get(9).netSales+CYMap.get(10).netSales+CYMap.get(11).netSales;}
                when else {result=0;}   
            }    
        }
        return result;
    }
    public SalesData getLensTotalSales(Sales_Statistics__c sales,SalesData lensSales){       
        SalesData lensSalesWrapper;
        if(lensSales != null){
            lensSalesWrapper = lensSales;
            if(lensSalesWrapper.lensQty > 0 || lensSalesWrapper.lensGrossSales > 0){
                system.debug(lensSalesWrapper.lensGrossSales);
                lensSalesWrapper.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                system.debug(lensSalesWrapper.lensGrossSales);
                lensSalesWrapper.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                lensSalesWrapper.lensQty += parseNullInt((Integer)sales.Lenses_Qty__c);
            }
            else{
                lensSalesWrapper=new SalesData();
                lensSalesWrapper.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                lensSalesWrapper.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c);
                lensSalesWrapper.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);  
            }
        }
        else{
            lensSalesWrapper=new SalesData();
            lensSalesWrapper.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
            lensSalesWrapper.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c);
            lensSalesWrapper.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);  
        }
        system.debug(lensSalesWrapper);
        return lensSalesWrapper;
    }
    public static Double getLensesSalesLast12Mo(Map<double,SalesData> CYMap, Map<double,SalesData> LYMap,String netOrGross,Integer month){
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
                    when  10{result = LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales+CYMap.get(4).lensGrossSales+CYMap.get(5).lensGrossSales+CYMap.get(6).lensGrossSales+CYMap.get(7).lensGrossSales+CYMap.get(8).lensGrossSales+CYMap.get(9).lensGrossSales;}
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
                    when  6{
                        System.debug(  LYMap.get(6).lensNetSales+'   '+LYMap.get(7).lensNetSales+'   '+LYMap.get(8).lensNetSales+'   '+LYMap.get(9).lensNetSales+'   '+LYMap.get(10).lensNetSales+'   '+LYMap.get(11).lensNetSales+'   '+LYMap.get(12).lensNetSales+'   '+LYMap.get(1).lensNetSales+'   '+LYMap.get(2).lensNetSales+'   '+LYMap.get(3).lensNetSales+'   '+CYMap.get(4).lensNetSales+'   '+CYMap.get(5).lensNetSales);
                        result = LYMap.get(6).lensNetSales+LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales;}
                    when  7{result = LYMap.get(7).lensNetSales+LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales;}
                    when  8{result = LYMap.get(8).lensNetSales+LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales;}
                    when  9{result = LYMap.get(9).lensNetSales+LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales;}
                    when  10{result = LYMap.get(10).lensNetSales+LYMap.get(11).lensNetSales+LYMap.get(12).lensNetSales+LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales+CYMap.get(4).lensNetSales+CYMap.get(5).lensNetSales+CYMap.get(6).lensNetSales+CYMap.get(7).lensNetSales+CYMap.get(8).lensNetSales+CYMap.get(9).lensNetSales;}
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
    public static Double getLensesSalesLFY(Map<double,SalesData> CYMap, Map<double,SalesData> LYMap,String netorGross){
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
    public static Double getLensesSalesYTD_LFY(Map<double,SalesData> CYMap, Map<double,SalesData> LYMap,String netOrGross,Integer month){
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
    public static Double getLensesSalesLast3Month(Map<double,SalesData> CYMap,Map<double,SalesData> LYMap,String netOrGross,Integer month){
        Double result = 0;
        try{
            if(netOrGross == 'Gross'){
                switch on month {
                    when  1{result = CYMap.get(10).lensGrossSales+CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales;}
                    when  2{result = CYMap.get(11).lensGrossSales+CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales;}
                    when  3{result = CYMap.get(12).lensGrossSales+CYMap.get(1).lensGrossSales+CYMap.get(2).lensGrossSales;}
                    when  4{result = CYMap.get(1).lensGrossSales+CYMap.get(2).lensGrossSales+CYMap.get(3).lensGrossSales;}
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
                    when  4{result = CYMap.get(1).lensNetSales+CYMap.get(2).lensNetSales+CYMap.get(3).lensNetSales;}
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
    public static Double getLensesSalesLast3MonthLY(Map<double,SalesData> LYMap,Map<double,SalesData> NYMap,String netOrGross,Integer month){
        Double result = 0;
        try{
            if(netOrGross == 'Gross'){
                switch on month {
                    when  1{result = LYMap.get(10).lensGrossSales+LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales;}
                    when  2{result = LYMap.get(11).lensGrossSales+LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales;}
                    when  3{result = LYMap.get(12).lensGrossSales+LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales;}
                    when  4{result = LYMap.get(1).lensGrossSales+LYMap.get(2).lensGrossSales+LYMap.get(3).lensGrossSales;}
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
                    when  4{result = LYMap.get(1).lensNetSales+LYMap.get(2).lensNetSales+LYMap.get(3).lensNetSales;}
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
    public static double getLensesSalesForecastCFY(Map<double,SalesData> CYMap,Map<double,SalesData> LYMap,double totalLensSales,double lensesSales3monthsCFYvsLFY,String netOrGross,Integer month){       
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
    public static Double getLensesQtyLast12Mo(Map<double,SalesData> CYMap, Map<double,SalesData> LYMap, Integer month,String type){
        Double result = 0;
        try{
            if(type == 'lens'){
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
            else if(type == 'frames'){
                switch on month {
                    when  1{result = LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty+CYMap.get(12).framesQty;}
                    when  2{result = LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty+CYMap.get(12).framesQty+CYMap.get(1).framesQty;}
                    when  3{result = LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty+CYMap.get(12).framesQty+CYMap.get(1).framesQty+CYMap.get(2).framesQty;}
                    when  4{result = CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty+CYMap.get(12).framesQty+CYMap.get(1).framesQty+CYMap.get(2).framesQty+CYMap.get(3).framesQty;}
                    when  5{result = LYMap.get(5).framesQty+LYMap.get(6).framesQty+LYMap.get(7).framesQty+LYMap.get(8).framesQty+LYMap.get(9).framesQty+LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty;}
                    when  6{result = LYMap.get(6).framesQty+LYMap.get(7).framesQty+LYMap.get(8).framesQty+LYMap.get(9).framesQty+LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty;}
                    when  7{result = LYMap.get(7).framesQty+LYMap.get(8).framesQty+LYMap.get(9).framesQty+LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty;}
                    when  8{result = LYMap.get(8).framesQty+LYMap.get(9).framesQty+LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty;}
                    when  9{result = LYMap.get(9).framesQty+LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty;}
                    when  10{result = LYMap.get(10).framesQty+LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty;}
                    when  11{result = LYMap.get(11).framesQty+LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty;}
                    when  12{result = LYMap.get(12).framesQty+LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty;}
                    when else {result=0;}
                }
            }
            else if(type == 'contactLens'){
                switch on month {
                    when  1{result = LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty;}
                    when  2{result = LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty+CYMap.get(1).contactLensQty;}
                    when  3{result = LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty+CYMap.get(1).contactLensQty+CYMap.get(2).contactLensQty;}
                    when  4{result = CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty+CYMap.get(1).contactLensQty+CYMap.get(2).contactLensQty+CYMap.get(3).contactLensQty;}
                    when  5{result = LYMap.get(5).contactLensQty+LYMap.get(6).contactLensQty+LYMap.get(7).contactLensQty+LYMap.get(8).contactLensQty+LYMap.get(9).contactLensQty+LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty;}
                    when  6{result = LYMap.get(6).contactLensQty+LYMap.get(7).contactLensQty+LYMap.get(8).contactLensQty+LYMap.get(9).contactLensQty+LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty;}
                    when  7{result = LYMap.get(7).contactLensQty+LYMap.get(8).contactLensQty+LYMap.get(9).contactLensQty+LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty;}
                    when  8{result = LYMap.get(8).contactLensQty+LYMap.get(9).contactLensQty+LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty;}
                    when  9{result = LYMap.get(9).contactLensQty+LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty;}
                    when  10{result = LYMap.get(10).contactLensQty+LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty;}
                    when  11{result = LYMap.get(11).contactLensQty+LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty;}
                    when  12{result = LYMap.get(12).contactLensQty+LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty;}
                    when else {result=0;}
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    public static double getLensesQuantityYTD_LFY(Map<double,SalesData> CYMap, Map<double,SalesData> LYMap,Integer month){
        double result = 0;
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
    public static double getLensesQuantityLast3Month(Map<double,SalesData> CYMap,Map<double,SalesData> LYMap,Integer month,String type){
        double result = 0;
        try{
            if(type == 'lens'){
                switch on month {
                    when  1{result = CYMap.get(10).lensQty+CYMap.get(11).lensQty+CYMap.get(12).lensQty;}
                    when  2{result = CYMap.get(11).lensQty+CYMap.get(12).lensQty+CYMap.get(1).lensQty;}
                    when  3{result = CYMap.get(12).lensQty+CYMap.get(1).lensQty+CYMap.get(2).lensQty;}
                    when  4{result = CYMap.get(1).lensQty+CYMap.get(2).lensQty+CYMap.get(3).lensQty;}
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
            else if(type == 'frames'){
                switch on month {
                    when  1{result = CYMap.get(10).framesQty+CYMap.get(11).framesQty+CYMap.get(12).framesQty;}
                    when  2{result = CYMap.get(11).framesQty+CYMap.get(12).framesQty+CYMap.get(1).framesQty;}
                    when  3{result = CYMap.get(12).framesQty+CYMap.get(1).framesQty+CYMap.get(2).framesQty;}
                    when  4{result = LYMap.get(1).framesQty+LYMap.get(2).framesQty+LYMap.get(3).framesQty;}
                    when  5{result = LYMap.get(2).framesQty+LYMap.get(3).framesQty+CYMap.get(4).framesQty;}
                    when  6{result = LYMap.get(3).framesQty+CYMap.get(4).framesQty+CYMap.get(5).framesQty;}
                    when  7{result = CYMap.get(4).framesQty+CYMap.get(5).framesQty+CYMap.get(6).framesQty;}
                    when  8{result = CYMap.get(5).framesQty+CYMap.get(6).framesQty+CYMap.get(7).framesQty;}
                    when  9{result = CYMap.get(6).framesQty+CYMap.get(7).framesQty+CYMap.get(8).framesQty;}
                    when  10{result = CYMap.get(7).framesQty+CYMap.get(8).framesQty+CYMap.get(9).framesQty;}
                    when  11{result = CYMap.get(8).framesQty+CYMap.get(9).framesQty+CYMap.get(10).framesQty;}
                    when  12{result = CYMap.get(9).framesQty+CYMap.get(10).framesQty+CYMap.get(11).framesQty;}
                    when else {result=0;}   
                }
            }
            else{
                switch on month {
                    when  1{result = CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty;}
                    when  2{result = CYMap.get(11).contactLensQty+CYMap.get(12).contactLensQty+CYMap.get(1).contactLensQty;}
                    when  3{result = CYMap.get(12).contactLensQty+CYMap.get(1).contactLensQty+CYMap.get(2).contactLensQty;}
                    when  4{result = LYMap.get(1).contactLensQty+LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty;}
                    when  5{result = LYMap.get(2).contactLensQty+LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty;}
                    when  6{result = LYMap.get(3).contactLensQty+CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty;}
                    when  7{result = CYMap.get(4).contactLensQty+CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty;}
                    when  8{result = CYMap.get(5).contactLensQty+CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty;}
                    when  9{result = CYMap.get(6).contactLensQty+CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty;}
                    when  10{result = CYMap.get(7).contactLensQty+CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty;}
                    when  11{result = CYMap.get(8).contactLensQty+CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty;}
                    when  12{result = CYMap.get(9).contactLensQty+CYMap.get(10).contactLensQty+CYMap.get(11).contactLensQty;}
                    when else {result=0;}   
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }    
    public static Double getLensesQuantityLast3MonthLY(Map<double,SalesData> LYMap,Map<double,SalesData> NYMap,Integer month){
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
    public static double getLensesDelays(Map<double,RxAndStockSales> CYMap, Map<double,RxAndStockSales> LYMap, Integer month, Integer days, String type){
        double result = 0;
        List<String> monthLst;
        switch on month {               
            when  1{monthLst = new List<String>{'10:CY','11:CY','12:CY'};}
            when  2{monthLst = new List<String>{'11:CY','12:CY','1:CY'};}
            when  3{monthLst = new List<String>{'12:CY','1:CY','2:CY'};}
            when  4{monthLst = new List<String>{'1:CY','2:CY','3:CY'};}
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
                            totalQty += getTotalCYMap.get(Integer.valueOf(mon.substringBefore(':')));
                            system.debug(qty+''+totalQty);
                        }
                        else{
                            qty += stockMapLY.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
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
    public static double getLastMonthVal(Map<Double,SalesData> CYMap,Map<Double,SalesData> LYMap,Integer month,String type) {
    	double result = 0.0;
    	Integer lastmon = month;
    	if(type == 'Net') {
			if(month == 1)
		    	lastmon = 12;
		    else
		    	lastmon = month-1;
		    if(month == 4){
		        if(LYMap.size() > 0 && LYMap.containsKey((double)lastmon))
		            result=LYMap.get(lastmon).lensNetSales;
		    }
		    else{
		        if(CYMap.size() > 0 && CYMap.containsKey((double)lastmon))
		            result=CYMap.get(lastmon).lensNetSales;
		    }  
    		
    	}else if(type == 'Gross') {
    		if(month == 1)
  	        	lastmon = 12;
  	        else
  	        	lastmon = month-1;
  	        if(month == 4){
  	            if(LYMap.size() > 0 && LYMap.containsKey((double)lastmon))
  	                result=LYMap.get((double)lastmon).lensGrossSales;
  	        }
  	        else{
  	            if(CYMap.size() > 0 && CYMap.containsKey(lastmon))
  	                result=CYMap.get(lastmon).lensGrossSales;
  	        }  
    		
    	}else {
    		if(month == 1)
  	        	lastmon = 12;
  	        else
  	        	lastmon = month-1;
  	        if(month == 4){
  	            if(LYMap.size() > 0 && LYMap.containsKey(lastmon))
  	                result=(double)LYMap.get(lastmon).lensQty;
  	        }
  	        else{
  	            if(CYMap.size() > 0 && CYMap.containsKey((double)lastmon))
  	                result=(double)CYMap.get((double)lastmon).lensQty;
  	        }  
    	}
    	return result;
    }
}