public class SalesStatisticsUpaterHelper {
     public class SalesData{
        public Double netSales{get;set;}
        public Double grossSales{get;set;}   
        public Double qty{get;set;}
        public SalesData(){
            netSales=0;
            grossSales=0;
            qty=0;    
        }
    }
    public void handleBeforeInsert(List<Sales_Statistics__c> salesStatisticsLst){
        //collect all the accounts 
        Set<Id> accountIds = new Set<Id>();
        //Assuming that all the records are related to same month
        double monthofData ;
        for(Sales_Statistics__c sale:salesStatisticsLst){
            accountIds.add(sale.Account__c);
            monthofData = sale.Month__c;
        }
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
        
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        //Map of Account,Type and its salesdata
        Map<Id,Map<String,SalesData>> accStatisticsLYMap = new Map<Id,Map<String,SalesData>>(); 
        if(accountIds.size() > 0){
            List<Sales_Statistics__c> salesStatistics=[SELECT Account__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,
                                                       Instrument_Gross_Sales__c,Instrument_Net_Sales__c,Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c,
                                                       Contact_Lenses_Gross_Sales__c,Contact_Lenses_Net_Sales__c,Contact_Lenses_Qty__c
                                                       from Sales_Statistics__c where Account__c in:accountIds AND Fiscal_Year__c =:CurrentFiscalyear-1 AND Month__c =:monthofData]; 
            if(salesStatistics.size() > 0){
                for(Sales_Statistics__c sales:salesStatistics){
                    Map<String,SalesData> salesDataMap;                   
                    if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(sales.Account__c)){                        
                        salesDataMap = accStatisticsLYMap.get(sales.Account__c);
                    }
                    else
                        salesDataMap = new Map<String,SalesData>();
                    SalesData data = new SalesData();
                    if(sales.Type__c == '0' || sales.Type__c == '1'){
                        data.grossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                        data.netSales = parseNull((double)sales.Lenses_Net_Sales__c);
                        data.qty = parseNullInt((Integer)sales.Lenses_Qty__c);
                    }
                    else if(sales.Type__c == '3'){
                        data.grossSales = parseNull((double)sales.Frames_Gross_Sales__c);
                        data.netSales = parseNull((double)sales.Frames_Net_Sales__c);
                        data.qty = parseNullInt((Integer)sales.Frames_Qty__c);
                    }
                    else if(sales.Type__c == '4'){
                        data.grossSales = parseNull((double)sales.Instrument_Gross_Sales__c);
                        data.netSales = parseNull((double)sales.Instrument_Net_Sales__c);
                        data.qty = parseNullInt((Integer)sales.Instruments_Qty__c);
                    }
                    else if(sales.Type__c == '9'){
                        data.grossSales = parseNull((double)sales.Contact_Lenses_Gross_Sales__c);
                        data.netSales = parseNull((double)sales.Contact_Lenses_Net_Sales__c);
                        data.qty = parseNullInt((Integer)sales.Contact_Lenses_Qty__c);
                    }
                    else{
                        data.grossSales = parseNull((double)sales.Other_Gross_Sales__c);
                        data.netSales = parseNull((double)sales.Other_Net_Sales__c);
                        data.qty = parseNullInt((Integer)sales.Other_Qty__c);
                    }
                    salesDataMap.put(sales.Type__c,data);
                    accStatisticsLYMap.put(sales.Account__c,salesDataMap);
                }
            }
        }
       /* for(Sales_Statistics__c newSale:salesStatisticsLst){
            if(accStatisticsLYMap.size() > 0 && accStatisticsLYMap.containsKey(newSale.Account__c)){
                if(newSale.Type__c == '0' || newSale.Type__c == '1'){
                    newSale.Lenses_Net_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Lenses_Net_Sales__c),newSale.Type__c,'net',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Lenses_Gross_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Lenses_Gross_Sales__c),newSale.Type__c,'gross',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Lenses_Qty_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Lenses_Qty__c),newSale.Type__c,'qty',accStatisticsLYMap.get(newSale.Account__c));
                }
                else if(newSale.Type__c == '3'){                    
                    newSale.Frames_Gross_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Frames_Gross_Sales__c),newSale.Type__c,'net',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Frames_Net_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Frames_Net_Sales__c),newSale.Type__c,'gross',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Frames_Qty_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Frames_Qty__c),newSale.Type__c,'qty',accStatisticsLYMap.get(newSale.Account__c));
                }
                else if(newSale.Type__c == '4'){
                    newSale.Instrument_Gross_Sales__c = getVariation(parseNull((double)newSale.Instrument_Gross_Sales__c),newSale.Type__c,'gross',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Instrument_Net_Sales__c = getVariation(parseNull((double)newSale.Instrument_Net_Sales__c),newSale.Type__c,'net',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Instruments_Qty__c = getVariation(parseNull((double)newSale.Instruments_Qty__c),newSale.Type__c,'qty',accStatisticsLYMap.get(newSale.Account__c));
                }
                else if(newSale.Type__c == '9'){
                    newSale.Contact_Lenses_Gross_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Contact_Lenses_Gross_Sales__c),newSale.Type__c,'gross',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Contact_Lenses_Net_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Contact_Lenses_Net_Sales__c),newSale.Type__c,'net',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Contact_Lenses_Qty_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Contact_Lenses_Qty__c),newSale.Type__c,'qty',accStatisticsLYMap.get(newSale.Account__c));
                }
                else{
                    newSale.Other_Gross_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Other_Gross_Sales__c),newSale.Type__c,'gross',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Other_Net_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Other_Net_Sales__c),newSale.Type__c,'net',accStatisticsLYMap.get(newSale.Account__c));
                    newSale.Other_Qty_Sales_vs_LFY__c = getVariation(parseNull((double)newSale.Other_Qty__c),newSale.Type__c,'qty',accStatisticsLYMap.get(newSale.Account__c));
                }
       
			}
        }     */   
    }
    public static double getVariation(double saleVal,String type,String saleType, Map<String,SalesData> lastSalesMap){
        double result =0;
        if(lastSalesMap.size() > 0 && lastSalesMap.containsKey(type)){
            if(saleType == 'net'){
                if(lastSalesMap.get(type).netSales != 0){
                    result = ((saleVal - lastSalesMap.get(type).netSales)/lastSalesMap.get(type).netSales)*100;
                }
            }
            else if(saleType == 'gross'){
                if(lastSalesMap.get(type).grossSales != 0){
                    result = ((saleVal - lastSalesMap.get(type).grossSales)/lastSalesMap.get(type).grossSales)*100;
                }
            }
            else{
                if(lastSalesMap.get(type).qty != 0){
                    result = ((saleVal - lastSalesMap.get(type).qty)/lastSalesMap.get(type).qty)*100;
                }
            }
        }        
        return result;        
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