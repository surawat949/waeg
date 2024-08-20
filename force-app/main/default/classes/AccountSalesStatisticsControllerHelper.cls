public class AccountSalesStatisticsControllerHelper {
    public AccountSalesStatisticsControllerHelper(){ 
    }
    public static Integer testMonth{get;set;}
    @AuraEnabled
    public static String orderHabitsJson{get;set;}
    public List<Sales_Statistics__c> lensSales{get;set;}  
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
   
    public String getOrderingHabits(Id recordId,double last12MonSales,double last3MonSales){
        system.debug(recordId);
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        if(Test.isRunningTest())
            month=testMonth;
        //fiscal year is current year-1 from january to April, year from may to december
        if(month <= 4){
            year = year-1;
        }
        lensSales=[SELECT OrderingHabitsJson__c,LensReturnsJson__c,Month__c,Fiscal_Year__c,Type__c from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and (Fiscal_Year__c=:year OR Fiscal_Year__c=:year-1)];
        /*String orderHabitsJson='{"ManualOrders":"10", "HVCsys":"5", "OtherOrders" : "3", "UnCutlens" : "6 ","RemoteEdging" : "0","Mounting" : "1","FramesByHvc" : "0","RealShape" : "2","StandShape" : "1","Boxing" : "1"}';
        
        String lensRetsJson='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        */
        Map<Decimal,Sales_Statistics__c> lensSalesCyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
        Map<Decimal,Sales_Statistics__c> lensSalesCyHoya1Map = new Map<Decimal,Sales_Statistics__c>();

        Map<Decimal,Sales_Statistics__c> lensSalesLyHoya0Map = new Map<Decimal,Sales_Statistics__c>();
        Map<Decimal,Sales_Statistics__c> lensSalesLyHoya1Map = new Map<Decimal,Sales_Statistics__c>();

       // List<Sales_Statistics__c> lensSalesLy=new List<Sales_Statistics__c>();
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
        Map<Integer,Object> CYOrderingHabitsMap=new Map<Integer,Object>();
        Map<Integer,Object> LYOrderingHabitsMap=new Map<Integer,Object>();
        Map<Integer,Object> CYLensRetsMap=new Map<Integer,Object>();
        Map<Integer,Object> LYLensRetsMap=new Map<Integer,Object>();
        if(lensSalesCyHoya0Map.size() > 0 || lensSalesCyHoya1Map.size() > 0){
            for(Integer i = 1 ; i <= 12 ; i++){ 
                OrderingHabitsWrapper orderType0 =new OrderingHabitsWrapper();                
                OrderingHabitsWrapper orderType1 =new OrderingHabitsWrapper();
                
                lensRetsWrapper lensRet0 = new lensRetsWrapper();
                lensRetsWrapper lensRet1 = new lensRetsWrapper();
                if(lensSalesCyHoya0Map.size() > 0 && lensSalesCyHoya0Map.containsKey(i)){
                    if(lensSalesCyHoya0Map.get(i).OrderingHabitsJson__c != null)
                    	orderType0 =parseOrderingHabitsJson(lensSalesCyHoya0Map.get(i).OrderingHabitsJson__c);
                    if(lensSalesCyHoya0Map.get(i).LensReturnsJson__c != null)
                    	lensRet0 = parseLensRetsJson(lensSalesCyHoya0Map.get(i).LensReturnsJson__c);
                }
                if(lensSalesCyHoya1Map.size() > 0 && lensSalesCyHoya1Map.containsKey(i)){
                    if(lensSalesCyHoya1Map.get(i).OrderingHabitsJson__c != null)
                   		orderType1 =parseOrderingHabitsJson(lensSalesCyHoya1Map.get(i).OrderingHabitsJson__c);
                    if(lensSalesCyHoya1Map.get(i).LensReturnsJson__c != null)
                    	lensRet1 = parseLensRetsJson(lensSalesCyHoya1Map.get(i).LensReturnsJson__c);
                }
                OrderingHabitsWrapper orderTypeall=new OrderingHabitsWrapper();
                Integer manualCount=0;
                Integer hvcCount = 0;
                Integer otherCount = 0;
                Integer uncutCount = 0;
                Integer remoteCount = 0;
                Integer mountingCount = 0;
                Integer framesHvcCount = 0;
                Integer realShapeCount = 0;
                Integer standShapeCount = 0;
                Integer boxingCount = 0;
                
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
                CYLensRetsMap.put(i,totalWrapper);
                
                if(orderType0 != null ){
                    manualCount += Integer.valueOf(orderType0.ManualOrders);
                    hvcCount += Integer.valueOf(orderType0.HVCsys);                
                    otherCount += Integer.valueOf(orderType0.OtherOrders);
                    uncutCount += Integer.valueOf(orderType0.UnCutlens);
                    remoteCount += Integer.valueOf(orderType0.RemoteEdging);
                    mountingCount += Integer.valueOf(orderType0.Mounting);
                    framesHvcCount += Integer.valueOf(orderType0.FramesByHvc);
                    realShapeCount += Integer.valueOf(orderType0.RealShape);
                    standShapeCount += Integer.valueOf(orderType0.StandShape);
                    boxingCount += Integer.valueOf(orderType0.Boxing);                  
                }
                if(orderType1 != null ){
                    manualCount += Integer.valueOf(orderType1.ManualOrders);
                    hvcCount += Integer.valueOf(orderType1.HVCsys);                
                    otherCount += Integer.valueOf(orderType1.OtherOrders);
                    uncutCount += Integer.valueOf(orderType1.UnCutlens);
                    remoteCount += Integer.valueOf(orderType1.RemoteEdging);
                    mountingCount += Integer.valueOf(orderType1.Mounting);
                    framesHvcCount += Integer.valueOf(orderType1.FramesByHvc);
                    realShapeCount += Integer.valueOf(orderType1.RealShape);
                    standShapeCount += Integer.valueOf(orderType1.StandShape);
                    boxingCount += Integer.valueOf(orderType1.Boxing);
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
                CYOrderingHabitsMap.put(i,orderTypeall);
            }
        }
        
        if(lensSalesLyHoya0Map.size() > 0 || lensSalesLyHoya1Map.size() > 0 ){
            for(Integer i = 1 ; i <= 12 ; i++){
                OrderingHabitsWrapper orderType0 =new OrderingHabitsWrapper();
                OrderingHabitsWrapper orderType1 =new OrderingHabitsWrapper();
                lensRetsWrapper lensRet0 = new lensRetsWrapper();
                lensRetsWrapper lensRet1 = new lensRetsWrapper();
                if(lensSalesLyHoya0Map.size() > 0 && lensSalesLyHoya0Map.containsKey(i)){
                    if(lensSalesLyHoya0Map.get(i).OrderingHabitsJson__c != null)
                    	orderType0 =parseOrderingHabitsJson(lensSalesLyHoya0Map.get(i).OrderingHabitsJson__c);
                    if(lensSalesLyHoya0Map.get(i).LensReturnsJson__c != null)                                                                      
                   	    lensRet0 = parseLensRetsJson(lensSalesLyHoya0Map.get(i).LensReturnsJson__c);
                }
                if(lensSalesLyHoya1Map.size() > 0 && lensSalesLyHoya1Map.containsKey(i)){
                    if(lensSalesLyHoya1Map.get(i).OrderingHabitsJson__c != null)
                   		 orderType1 =parseOrderingHabitsJson(lensSalesLyHoya1Map.get(i).OrderingHabitsJson__c);
                    if(lensSalesLyHoya1Map.get(i).LensReturnsJson__c != null)  
                    	lensRet1 = parseLensRetsJson(lensSalesLyHoya1Map.get(i).LensReturnsJson__c);
                }
                OrderingHabitsWrapper orderTypeall=new OrderingHabitsWrapper();
                Integer manualCount=0;
                Integer hvcCount = 0;
                Integer otherCount = 0;
                Integer uncutCount = 0;
                Integer remoteCount = 0;
                Integer mountingCount = 0;
                Integer framesHvcCount = 0;
                Integer realShapeCount = 0;
                Integer standShapeCount = 0;
                Integer boxingCount = 0;
                
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
                LYLensRetsMap.put(i,totalWrapper);
                
                if(orderType0 != null ){
                    manualCount += Integer.valueOf(orderType0.ManualOrders);
                    hvcCount += Integer.valueOf(orderType0.HVCsys);                
                    otherCount += Integer.valueOf(orderType0.OtherOrders);
                    uncutCount += Integer.valueOf(orderType0.UnCutlens);
                    remoteCount += Integer.valueOf(orderType0.RemoteEdging);
                    mountingCount += Integer.valueOf(orderType0.Mounting);
                    framesHvcCount += Integer.valueOf(orderType0.FramesByHvc);
                    realShapeCount += Integer.valueOf(orderType0.RealShape);
                    standShapeCount += Integer.valueOf(orderType0.StandShape);
                    boxingCount += Integer.valueOf(orderType0.Boxing);
                }
                if(orderType1 != null ){
                    manualCount += Integer.valueOf(orderType1.ManualOrders);
                    hvcCount += Integer.valueOf(orderType1.HVCsys);                
                    otherCount += Integer.valueOf(orderType1.OtherOrders);
                    uncutCount += Integer.valueOf(orderType1.UnCutlens);
                    remoteCount += Integer.valueOf(orderType1.RemoteEdging);
                    mountingCount += Integer.valueOf(orderType1.Mounting);
                    framesHvcCount += Integer.valueOf(orderType1.FramesByHvc);
                    realShapeCount += Integer.valueOf(orderType1.RealShape);
                    standShapeCount += Integer.valueOf(orderType1.StandShape);
                    boxingCount += Integer.valueOf(orderType1.Boxing);
                }
                orderTypeall.ManualOrders = String.valueof(manualCount);
                orderTypeall.HVCsys = String.valueof(hvcCount);
                orderTypeall.OtherOrders = String.valueof(otherCount);
                orderTypeall.UnCutlens = String.valueof(uncutCount);
                orderTypeall.RemoteEdging = String.valueof(remoteCount);
                orderTypeall.Mounting = String.valueof(mountingCount);
                orderTypeall.FramesByHvc = String.valueof(framesHvcCount);
                orderTypeall.RealShape = String.valueof(realShapeCount);
                orderTypeall.StandShape = String.valueof(standShapeCount);
                orderTypeall.Boxing = String.valueof(boxingCount);
                LYOrderingHabitsMap.put(i,orderTypeall);
                system.debug(LYOrderingHabitsMap);
            }
        }
        //Calculate last 3/12 Months Ordering habits
        Integer manualOrderCount = 0;
        Integer hvcOrderCount = 0;
        Integer otherOrderCount = 0;
        Integer realShapeCount = 0;
        Integer standShapeCount = 0;
        Integer boxingCount = 0;
        Integer unCutCount = 0;
        Integer remoteEdgingCount = 0;
        Integer mountingCount = 0;
        Integer framesByHvc = 0;
  	    try {
             switch on month {               
                when  1{                       
                    List<String> monthsList=new List<String>{'10:CY','11:CY','12:CY'};
                    List<String> twelveMonList=new List<String>{'1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales); 
                }
                when  2{
                    List<String> monthsList=new List<String>{'11:CY','12:CY','1:CY'};
                    List<String> twelveMonList=new List<String>{'2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);  
                }  
                when  3{
                    List<String> monthsList=new List<String>{'12:CY','1:CY','2:CY'};
                    List<String> twelveMonList=new List<String>{'3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales); 
                }
                when  4{
                    List<String> monthsList=new List<String>{'1:CY','2:CY','3:CY'};
                    List<String> twelveMonList=new List<String>{'4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY','3:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);                  
                }
                when  5{
                    List<String> monthsList=new List<String>{'2:LY','3:LY','4:CY'};
                    List<String> twelveMonList=new List<String>{'5:LY','6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);                   
                }
                when  6{
                    List<String> monthsList=new List<String>{'3:LY','4:CY','5:CY'};
                    List<String> twelveMonList=new List<String>{'6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,LYOrderingHabitsMap,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales); 					             
                }
                when  7{
                    List<String> monthsList=new List<String>{'4:CY','5:CY','6:CY'};
                    List<String> twelveMonList=new List<String>{'7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);                     
                 }
                when  8{
                    List<String> monthsList=new List<String>{'5:CY','6:CY','7:CY'};
                    List<String> twelveMonList=new List<String>{'8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);                    
                 }
                when  9{
                    List<String> monthsList=new List<String>{'6:CY','7:CY','8:CY'};
                    List<String> twelveMonList=new List<String>{'9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);
                 }
                when  10{
                    List<String> monthsList=new List<String>{'7:CY','8:CY','9:CY'};
                    List<String> twelveMonList=new List<String>{'10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);
                 }
                when  11{
                    List<String> monthsList=new List<String>{'8:CY','9:CY','10:CY'};	
                    List<String> twelveMonList=new List<String>{'11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales);                            
                }
                when  12{
                    List<String> monthsList=new List<String>{'9:CY','10:CY','11:CY'};
                    List<String> twelveMonList=new List<String>{'12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY'};
                    orderHabitsJson=getMonthsOrderingHabits(CYOrderingHabitsMap,null,CYLensRetsMap,LYLensRetsMap,monthsList,twelveMonList,last12MonSales,last3MonSales); 
                }
                when else {
                   orderHabitsJson='NoData';
                } 
            }
         }
         catch (Exception e) {
            LogException.log(e);
        }  
        return orderHabitsJson;
    }    

    public static orderingHabitsWrapper parseOrderingHabitsJson(String orderHabitsJson){
        orderingHabitsWrapper wrapper=new orderingHabitsWrapper();
        JSONParser parser = JSON.createParser(orderHabitsJson);
        orderingHabitsWrapper obj = wrapper.parse(orderHabitsJson);        
        return obj;
    }
    public static lensRetsWrapper parseLensRetsJson(String lensReturnsJson){
        lensRetsWrapper wrapper=new lensRetsWrapper();
        JSONParser parser = JSON.createParser(lensReturnsJson);
        lensRetsWrapper obj = wrapper.parse(lensReturnsJson);        
        return obj;
    }   
    public String getMonthsOrderingHabits( Map<Integer,Object> CYOrderingHabitsMap,Map<Integer,Object> LYOrderingHabitsMap,Map<Integer,Object> CYLensRetsMap,Map<Integer,Object> LYLensRetsMap,List<String> monthNoList,List<String> twelveMonList,double last12MoSales,double last3MoSales){
       
        OrderingHabitsWrapper OhWrapper=new OrderingHabitsWrapper();
        Integer manualOrderCount=0;
        Integer hvcOrderCount = 0;
        Integer otherOrderCount = 0;
        Integer unCutCount = 0;
        Integer remoteEdgingCount = 0;
        Integer mountingCount = 0;
        Integer framesByHvc = 0;
        Integer realShapeCount = 0;
        Integer standShapeCount = 0;
        Integer boxingCount = 0;
       
        
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
                manualOrderCount += Integer.valueOf(wrapper.ManualOrders) ;
                hvcOrderCount += Integer.valueOf(wrapper.HVCsys) ;
                otherOrderCount += Integer.valueOf(wrapper.OtherOrders) ;
                realShapeCount += Integer.valueOf(wrapper.RealShape) ;
                standShapeCount += Integer.valueOf(wrapper.StandShape);
                boxingCount += Integer.valueOf(wrapper.Boxing);
                unCutCount +=Integer.valueOf(wrapper.UnCutlens);
                remoteEdgingCount += Integer.valueOf(wrapper.RemoteEdging);
                mountingCount += Integer.valueOf(wrapper.Mounting);
                framesByHvc += Integer.valueOf(wrapper.FramesByHvc);
            }
        }
        system.debug(LYMonList.size()+''+LYOrderingHabitsMap);
        if(LYOrderingHabitsMap != null && LYOrderingHabitsMap.size() > 0 && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){
                OrderingHabitsWrapper wrapper=(OrderingHabitsWrapper)LYOrderingHabitsMap.get(LYmon);
                system.debug(wrapper);
                manualOrderCount += Integer.valueOf(wrapper.ManualOrders) ;
                hvcOrderCount += Integer.valueOf(wrapper.HVCsys) ;
                otherOrderCount += Integer.valueOf(wrapper.OtherOrders) ;
                realShapeCount += Integer.valueOf(wrapper.RealShape) ;
                standShapeCount += Integer.valueOf(wrapper.StandShape);
                boxingCount += Integer.valueOf(wrapper.Boxing);
                unCutCount +=Integer.valueOf(wrapper.UnCutlens);
                remoteEdgingCount += Integer.valueOf(wrapper.RemoteEdging);
                mountingCount += Integer.valueOf(wrapper.Mounting);
                framesByHvc += Integer.valueOf(wrapper.FramesByHvc);
                 system.debug(manualOrderCount);
            }
        }
        OhWrapper.ManualOrders=String.valueOf(manualOrderCount);
        OhWrapper.HVCsys=String.valueOf(hvcOrderCount);
        OhWrapper.OtherOrders=String.valueOf(otherOrderCount);
        OhWrapper.UnCutlens=String.valueOf(unCutCount);
        OhWrapper.RemoteEdging=String.valueOf(remoteEdgingCount);
        OhWrapper.Mounting=String.valueOf(mountingCount);
        OhWrapper.FramesByHvc=String.valueOf(framesByHvc);
        OhWrapper.RealShape=String.valueOf(realShapeCount);
        OhWrapper.StandShape=String.valueOf(standShapeCount);
        OhWrapper.Boxing=String.valueOf(boxingCount);
        
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
        double totalCount1 = Double.valueOf(OhWrapper.ManualOrders)+Double.valueOf(OhWrapper.HVCsys)+Double.valueOf(OhWrapper.OtherOrders);
        if(totalCount1 != 0){
            manualOrderPerc = (Double.valueOf(OhWrapper.ManualOrders)/totalCount1)*100;
            system.debug(manualOrderPerc);
            hvcOrderPerc  = (Double.valueOf(OhWrapper.HVCsys)/totalCount1)*100;
            otherOrderPerc = (Double.valueOf(OhWrapper.OtherOrders)/(double)totalCount1)*100;            
        }
        double totalCount2 = Double.valueOf(OhWrapper.UnCutlens)+Double.valueOf(OhWrapper.RemoteEdging)+Double.valueOf(OhWrapper.Mounting)+Double.valueOf(OhWrapper.FramesByHvc);
        if(totalCount2 != 0){
            unCutPerc = (Double.valueOf(OhWrapper.UnCutlens)/totalCount2)*100;
            remoteEdgingPerc = (Double.valueOf(OhWrapper.RemoteEdging)/totalCount2)*100;
            mountingPerc = (Double.valueOf(OhWrapper.Mounting)/totalCount2)*100;
            framesByHvcPerc = (Double.valueOf(OhWrapper.FramesByHvc)/totalCount2)*100;
        } 
        double totalCount3 = Double.valueOf(OhWrapper.RealShape)+Double.valueOf(OhWrapper.StandShape)+Double.valueOf(OhWrapper.Boxing);
        if(totalCount3 != 0){                            
            realShapePerc = (Double.valueOf(OhWrapper.RealShape)/totalCount3)*100;
            standShapePerc = (Double.valueOf(OhWrapper.StandShape)/totalCount3)*100;
            boxingPerc = (Double.valueOf(OhWrapper.Boxing)/totalCount3)*100; 
        }
        String lensRets3MonJson=getlensRets(CYLensRetsMap,LYLensRetsMap,monthNoList,last3MoSales);
        String lensRets12MonJson=getlensRets(CYLensRetsMap,LYLensRetsMap,twelveMonList,last12MoSales);

        String orderHabitsJson = '{\"ManualOrders\":\"'+String.valueOf(manualOrderPerc)+'\",\"HVCsys\":\"'+String.valueOf(hvcOrderPerc)+'\",\"OtherOrders\":\"'+String.valueOf(otherOrderPerc)+'\",\"UnCutlens\":\"'+String.valueOf(unCutPerc)+'\",\"RemoteEdging\":\"'+String.valueOf(remoteEdgingPerc)+'\",\"Mounting\":\"'+String.valueOf(mountingPerc)+'\",\"FramesByHvc\":\"'+String.valueOf(framesByHvcPerc)+'\",\"RealShape\":\"'+String.valueOf(realShapePerc)+'\",\"StandShape\":\"'+String.valueOf(standShapePerc)+'\",\"Boxing\":\"'+String.valueOf(boxingPerc)+'\"';
        orderHabitsJson += lensRets3MonJson;
        orderHabitsJson += lensRets12MonJson;
        orderHabitsJson += '}';
        system.debug(orderHabitsJson);
        return orderHabitsJson;      
    }
    
    public String getlensRets(Map<Integer,Object> CYLensRetsMap,Map<Integer,Object> LYLensRetsMap,List<String> monthNoList,double lastMoSales){
        String lensRetsJson='';         
        Integer prodRetMon = 0;
        Integer cutRetMon = 0;
        Integer mountingRetMon = 0;
        Integer agrementRetMon = 0;
        Integer mistakeRetMon = 0;
        Integer nonAdapRetMon = 0;
        Integer deliveryRetMon = 0;
        Integer otherRetMon = 0;
        
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
                lensRetsWrapper wrapper=(lensRetsWrapper)CYLensRetsMap.get(CYmon);
                prodRetMon += Integer.valueOf(wrapper.ProdRet) ;
                cutRetMon += Integer.valueOf(wrapper.CutRet) ;
                mountingRetMon += Integer.valueOf(wrapper.MountRet) ;
                agrementRetMon += Integer.valueOf(wrapper.SalesRet) ;
                mistakeRetMon += Integer.valueOf(wrapper.OrderMisRet) ;
                nonAdapRetMon += Integer.valueOf(wrapper.NonAdapRet) ;
                deliveryRetMon += Integer.valueOf(wrapper.DeliveryRet) ;
                otherRetMon += Integer.valueOf(wrapper.OtherRet) ;                
            }
        }
        if(LYLensRetsMap != null && LYLensRetsMap.size() > 0  && LYMonList.size() > 0){
            for(Integer LYmon:LYMonList){
                lensRetsWrapper wrapper=(lensRetsWrapper)LYLensRetsMap.get(LYmon);
                prodRetMon += Integer.valueOf(wrapper.ProdRet) ;
                cutRetMon += Integer.valueOf(wrapper.CutRet) ;
                mountingRetMon += Integer.valueOf(wrapper.MountRet) ;
                agrementRetMon += Integer.valueOf(wrapper.SalesRet) ;
                mistakeRetMon += Integer.valueOf(wrapper.OrderMisRet) ;
                nonAdapRetMon += Integer.valueOf(wrapper.NonAdapRet) ;
                deliveryRetMon += Integer.valueOf(wrapper.DeliveryRet) ;
                otherRetMon += Integer.valueOf(wrapper.OtherRet) ;                
            }
        }
        lensRetsWrapper lensRet=new lensRetsWrapper();
        lensRet.ProdRet=String.valueOf(prodRetMon);
        lensRet.CutRet=String.valueOf(cutRetMon);
        lensRet.MountRet=String.valueOf(mountingRetMon);
        lensRet.SalesRet=String.valueOf(agrementRetMon);
        lensRet.OrderMisRet=String.valueOf(mistakeRetMon);
        lensRet.NonAdapRet=String.valueOf(nonAdapRetMon);
        lensRet.DeliveryRet=String.valueOf(deliveryRetMon);
        lensRet.OtherRet=String.valueOf(otherRetMon);
        
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
        double totalProdRet = Double.valueOf(lensRet.ProdRet)+Double.valueOf(lensRet.CutRet)+Double.valueOf(lensRet.MountRet);
        double totalNonProdRet = Double.valueOf(lensRet.SalesRet)+Double.valueOf(lensRet.OrderMisRet)+Double.valueOf(lensRet.NonAdapRet)+Double.valueOf(lensRet.DeliveryRet)+Double.valueOf(lensRet.OtherRet);
        double totalCount = lastMoSales+totalProdRet+totalNonProdRet;
        if(totalCount != 0){
            prodRetPerc = (Double.valueOf(lensRet.ProdRet)/totalCount)*10000;
            cutRetPerc  = (Double.valueOf(lensRet.CutRet)/totalCount)*10000;
            mountingRetPerc = (Double.valueOf(lensRet.MountRet)/totalCount)*10000;   
            salesRetperc = (Double.valueOf(lensRet.SalesRet)/totalCount)*10000;
            orderingRetPerc = (Double.valueOf(lensRet.OrderMisRet)/totalCount)*10000;
            nonadapRetPerc = (Double.valueOf(lensRet.NonAdapRet)/totalCount)*10000;
            deliveryRetPerc = (Double.valueOf(lensRet.DeliveryRet)/totalCount)*10000;
            System.debug(salesRetperc+''+lensRet.SalesRet+''+totalCount);
            otherRetPerc = (Double.valueOf(lensRet.OtherRet)/totalCount)*10000;
            totalProdRetPerc = (totalProdRet/totalCount)*10000;
            totalNonProdRetPerc = (totalNonProdRet/totalCount)*10000;
            System.debug(totalNonProdRetPerc);
            totalRetPerc = ((totalProdRet+totalNonProdRet)/totalCount)*10000;
        } 
        //String lensRetsJson='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
		if(monthNoList.size() == 3)
            lensRetsJson = ',\"ProdRet3\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRet3\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRet3\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRet3\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRet3\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRet3\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRet3\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRet3\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRet3\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRet3\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRet3\":\"'+String.valueOf(totalRetPerc)+'\"';
        else
            lensRetsJson = ',\"ProdRet12\":\"'+String.valueOf(prodRetPerc)+'\",\"CutRet12\":\"'+String.valueOf(cutRetPerc)+'\",\"MountRet12\":\"'+String.valueOf(mountingRetPerc)+'\",\"SalesRet12\":\"'+String.valueOf(salesRetperc)+'\",\"OrderMisRet12\":\"'+String.valueOf(orderingRetPerc)+'\",\"NonAdapRet12\":\"'+String.valueOf(nonadapRetPerc)+'\",\"DeliveryRet12\":\"'+String.valueOf(deliveryRetPerc)+'\",\"OtherRet12\":\"'+String.valueOf(otherRetPerc)+'\",\"TotalProdRet12\":\"'+String.valueOf(totalProdRetPerc)+'\",\"TotalNonProdRet12\":\"'+String.valueOf(totalNonProdRetPerc)+'\",\"TotalRet12\":\"'+String.valueOf(totalRetPerc)+'\"';
            
        return lensRetsJson;
    }
  
}