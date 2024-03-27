public class StatisticsController {
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
        public Integer remoteEdgingQty{get;set;}
        public RxAndStockSales(){
            rxQty=0;
            stockQty=0;
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
            remoteEdgingQty=0;
        }
    }
    //Wrapper class to store lens(Rx+Stock) sales
    public class LensSales{
        public LensSales(){}
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
        public Double totalNetSales{get;set;}
        public Double totalGrossSales{get;set;}
        public Integer lensQty{get;set;}
        public Integer framesQty{get;set;}
        public Integer instrumentsQty{get;set;}
        public Integer OthersQty{get;set;}
        public Integer totalQty{get;set;}
        public Integer rxQty{get;set;}
        public Integer stockQty{get;set;}
        public Integer remoteEdgingQty{get;set;}
        
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
           
        }
    }

    public class MonthlySales{
         @AuraEnabled public double monthlyGrossSales{get;set;}
         @AuraEnabled public double monthlyNetSales{get;set;}
         @AuraEnabled public Integer monthlyQty{get;set;}
         @AuraEnabled public double monthlyLensSales{get;set;}
         @AuraEnabled public double monthlyLensNetSales{get;set;}
         @AuraEnabled public Integer lensQty{get;set;}
         @AuraEnabled public double monthlyFramesSales{get;set;}
         @AuraEnabled public double monthlyFramesNetSales{get;set;}
         @AuraEnabled public Integer framesQty{get;set;}
         @AuraEnabled public double monthlyInstSales{get;set;}
         @AuraEnabled public double monthlyInstNetSales{get;set;}
         @AuraEnabled public Integer instQty{get;set;}
         @AuraEnabled public double monthlyOtherSales{get;set;}
         @AuraEnabled public double monthlyOtherNetSales{get;set;} 
         @AuraEnabled public Integer otherQty{get;set;}  
        public MonthlySales(){
            monthlyGrossSales=0;
            monthlyNetSales=0;
            monthlyQty=0;
            monthlyLensSales=0;
            monthlyLensNetSales=0;
            lensQty=0;
            monthlyFramesSales=0;
            monthlyFramesNetSales=0;
            framesQty=0;
            monthlyInstSales=0;
            monthlyInstNetSales=0;
            instQty=0;
            monthlyOtherSales=0;
            monthlyOtherNetSales=0;
            otherQty=0;
        }
    }
    public class AccountSales {
        public AccountSales(){
            isGermanyAccount=false;
            isSOSAorSONLAccount=false;
            isOtherCountryAccount=false;
            cyGrossSales=0;
            lfyGrossSales=0;
            cyNetSales=0;
            lfyNetSales=0;
            cyTotalQty=0;
            lyTotalQty=0;
        }
        @AuraEnabled public Map<Integer,MonthlySales> CYMonthlySalesMap{get;set;}
        @AuraEnabled public Map<Integer,MonthlySales> LYMonthlySalesMap{get;set;}
        @AuraEnabled public Boolean isGermanyAccount{get;set;}
        @AuraEnabled public Boolean isSOSAorSONLAccount{get;set;}
        @AuraEnabled public Boolean isOtherCountryAccount{get;set;}
        @AuraEnabled public Account account{get;set;}
        @AuraEnabled public double cyGrossSales{get;set;}
        @AuraEnabled public double lfyGrossSales{get;set;}
        @AuraEnabled public double cyNetSales{get;set;}
        @AuraEnabled public double lfyNetSales{get;set;}     
        @AuraEnabled public Integer cyTotalQty{get;set;}
        @AuraEnabled public Integer lyTotalQty{get;set;}   
    }
    private static Map<Integer,SalesData> MonthlyCYData{get;set;}
    private static Map<Integer,SalesData> MonthlyLYData{get;set;}
    private static Double conversionRate{get;set;}
    private static Double originalConversionRate{get;set;}
    private static Double AccountConversionRate{get;set;}
    
    @AuraEnabled
    public static AccountSales initSales(Id recordId){
        AccountSales accountSales = new AccountSales();
        accountSales.CYMonthlySalesMap=new Map<Integer,MonthlySales>();
        accountSales.LYMonthlySalesMap=new Map<Integer,MonthlySales>();
       /* MonthlySales sales1=new MonthlySales();
        sales1.monthlyGrossSales=234;
        sales1.monthlyNetSales=130;
        sales1.monthlyLensSales=20;
        sales1.lensQty=3;
        accountSales.CYMonthlySalesMap.put('4',sales1);
        accountSales.CYMonthlySalesMap.put('5',sales1);*/
        
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
      
        //fiscal year is current year-1 from january to march, year from april to december            
        if(month < 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        
        String userCompany = [select companyName from User where id=: UserInfo.getUserId()].companyName;
        String userCurrency = UserInfo.getDefaultCurrency();
        originalConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        String accountCurrency = [select currencyisocode from Account where id=:recordId].currencyIsoCode;
        AccountConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;
        if(conversionRate == AccountConversionRate){AccountConversionRate=1;}
        if(userCurrency != 'EUR' && accountCurrency != 'EUR'){AccountConversionRate=1;conversionRate=1;}
        if(userCurrency == accountCurrency)
        {
            AccountConversionRate=1;
            conversionRate=1;
        }
        system.debug(conversionRate);
            Map<Integer,LensSales> MonthlyCYLensMap=new Map<Integer,LensSales>();
            Map<Integer,LensSales> MonthlyLYLensMap=new Map<Integer,LensSales>();
            Map<Integer,LensSales> MonthlyNYLensMap=new Map<Integer,LensSales>();
            Map<Integer,RxAndStockSales> RxMapCY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> StockMapCY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> RxMapLY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> StockMapLY=new Map<Integer,RxAndStockSales>();
            List<Sales_Statistics__c> salesLensCY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                   ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                   ,	Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                   from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear ];
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
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
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
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    RxMapCY.put((Integer)sales.Month__c,rxSales);
                }
            }
            
            List<Sales_Statistics__c> salesLensLY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                   ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                   ,	Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                   from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-1 ];
            
            for(Sales_Statistics__c sales:salesLensLY){
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
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
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
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    StockMapLY.put((Integer)sales.Month__c,rxSales);
                }
            }
            
            //prepare lens(sum of Rx and Stock) sales maps for each month 
            for(Sales_Statistics__c sales:salesLensCY){ 
                if(MonthlyCYLensMap.size() > 0 && MonthlyCYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens=MonthlyCYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
                }
                else{
                    LensSales lens=new LensSales();
                    lens.lensGrossSales=parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales=parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
        
        //prepare the Lens Map for last fy
        for(Sales_Statistics__c sales:salesLensLY){ 
            if(MonthlyLYLensMap.size() > 0 && MonthlyLYLensMap.containsKey((Integer)sales.Month__c))
            {
                LensSales lens=MonthlyLYLensMap.get((Integer)sales.Month__c);
                lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                MonthlyLYLensMap.put((Integer)sales.Month__c,lens); 
            }
            else{
                LensSales lens=new LensSales();
                lens.lensGrossSales=parseNull((double)sales.Lenses_Gross_Sales__c);
                lens.lensNetSales=parseNull((double)sales.Lenses_Net_Sales__c);
                lens.lensQty=parseNullInt((Integer)sales.Lenses_Qty__c);   
                lens.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                MonthlyLYLensMap.put((Integer)sales.Month__c,lens);
            }            
        }	
          List<Sales_Statistics__c> salesLensNY=[SELECT Month__c,Fiscal_Year__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,	Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,	Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-2 ];
            
            //prepare lens map for N2FY
           
            for(Sales_Statistics__c sales:salesLensNY){  
                if(MonthlyNYLensMap.size() > 0 && MonthlyNYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens=MonthlyNYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens); 
                }
                else{
                    LensSales lens=new LensSales();
                    lens.lensGrossSales=parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales=parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
            system.debug(MonthlyCYLensMap.size()+'   '+MonthlyCYLensMap);
            system.debug(MonthlyCYLensMap.size()+'   '+MonthlyLYLensMap);
      
            String HoyaAccountID=[select Hoya_Account_ID__c from Account where id=:recordId].Hoya_Account_ID__c;
            
            if( HoyaAccountID.startsWith('SO4900') ||  HoyaAccountID.startsWith('SO4990'))
                accountSales.isGermanyAccount=true;
            else if(HoyaAccountID.startsWith('SO2700') || (HoyaAccountID.startsWith('SO3200') && accountSales.account.Shop_country__c == 'NL') || (HoyaAccountID.startsWith('SO3200') && accountSales.account.Shop_country__c != 'BE'))
                accountSales.isSOSAorSONLAccount=true;
            else
                accountSales.isOtherCountryAccount=true;
             /*
             * compute data other than lens
             */
            List<Sales_Statistics__c> AllSalesData=[SELECT Month__c,Fiscal_Year__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,Instrument_Gross_Sales__c,Instrument_Net_Sales__c,
                                                   Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c,Remote_edging_Qty__c
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
                Boolean IsfirstTime=true;                     
                if(MonthlyCYLensMap.containsKey(i) && IsfirstTime){
                    LensSales lensObj=MonthlyCYLensMap.get(i);
                    salesDataObj.lensNetSales=parseNull(lensObj.lensNetSales); 
                    salesDataObj.lensGrossSales=parseNull(lensObj.lensGrossSales);
                    salesDataObj.lensQty=parseNullInt(lensObj.lensQty);
                    salesDataObj.remoteEdgingQty=parseNullInt(lensObj.remoteEdgingQty);
                    IsfirstTime = false;
                } 
                if(AllSalesDataCY.size() > 0){                    
                    for(Sales_Statistics__c salesStat:AllSalesDataCY){ 
                        if(salesStat.Month__c == (double)i){
                            salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                            salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                            salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                        } 
                    }
                }
                salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales;
                salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales;
                salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty;
                
                MonthlyCYData.put(i,salesDataObj);
                system.debug(MonthlyCYData.size());
            }        
            //prepare the data for Ly
          
            for(Integer i = 1; i <= 12; i++){
                SalesData salesDataObj=new SalesData();
                Boolean IsfirstTime=true;                                      
                if(MonthlyLYLensMap.containsKey(i) && IsfirstTime ){
                    LensSales lensObj=MonthlyLYLensMap.get(i);
                    salesDataObj.lensNetSales=lensObj.lensNetSales; 
                    salesDataObj.lensGrossSales=lensObj.lensGrossSales;
                    salesDataObj.lensQty=lensObj.lensQty;
                    IsfirstTime=false;
                }  
                if(AllSalesDataLY.size() > 0){
                    for(Sales_Statistics__c salesStat:AllSalesDataLY){  
                        if(salesStat.Month__c == (double)i){
                            salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                            salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                            salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                            salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                            salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                            salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                            salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                            salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                            salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                        }    
                    }
                }
                salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales;
                salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales;
                salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty;
                
                MonthlyLYData.put(i,salesDataObj);
            }
            //Filter monthly sales
            if(MonthlyCYData.size() > 0){   
                for(Integer i = 1; i <= 12 ;i++){                  
                     if(MonthlyCYData.ContainsKey(i)){ 
                         SalesData data=MonthlyCYData.get(i);
                         MonthlySales sales=new MonthlySales();
                         sales.monthlyGrossSales = data.totalGrossSales * conversionRate;
                         sales.monthlyNetSales +=  data.totalNetSales * conversionRate;
                         sales.monthlyQty += data.totalQty;
                         sales.monthlyLensSales +=  data.lensGrossSales * conversionRate;
                         sales.monthlyLensNetSales += data.lensNetSales * conversionRate;
                         sales.lensQty += data.lensQty;
                         sales.monthlyFramesSales += data.framesGrossSales * conversionRate;
                         sales.monthlyFramesNetSales += data.framesNetSales * conversionRate;
                         sales.framesQty += data.framesQty;
                         sales.monthlyInstSales +=  data.instrumentsGrossSales * conversionRate;
                         sales.monthlyInstNetSales += data.instrumentsNetSales * conversionRate;
                         sales.instQty += data.instrumentsQty;
                         sales.monthlyOtherSales +=  data.otherGrossSales * conversionRate;
                         sales.monthlyOtherNetSales += data.otherNetSales * conversionRate;
                         sales.otherQty += data.OthersQty;
                         accountSales.CYMonthlySalesMap.put(i,sales);
                         
                       /*  sales.totalLensNetSales += accountSales.aprLensNetSales;
                         sales.totalFramesNetSales += accountSales.aprFramesNetSales;
                         sales.totalInstNetSales += accountSales.aprInstNetSales;
                         sales.totalOtherNetSales += accountSales.aprOtherNetSales;
                         sales.totalLensSales += accountSales.aprLensSales;
                         sales.totalFramesSales += accountSales.aprFramesSales;
                         sales.totalInstSales += accountSales.aprInstSales;
                         sales.totalOtherSales += accountSales.aprOtherSales;
                         sales.totalLensQty += accountSales.aprLensQty;
                         sales.totalFramesQty += accountSales.aprFramesQty;
                         sales.totalInstQty += accountSales.aprInstQty;
                         sales.totalOtherQty += accountSales.aprOtherQty;
                         sales.totalSales += accountSales.aprSales ;
                         sales.totalNetSales += accountSales.aprNetSales;
                         sales.totalQty += accountSales.aprQty;
                         sales.aprLensremoteEdgeQty += data.remoteEdgingQty;
                         sales.totalLensremoteEdgeQty +=accountSales.aprLensremoteEdgeQty;*/
                     }
                    
                }
            }
        return accountSales;
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
    

}