public with sharing class CustomerReviewPerfomanceController {
    public static String defaultCurrencyISOcode;
    public static Double selectedRepCurrencyRate = 1;
    public static Double usdCurrencyRate = 1;
    public static List<String> monthNameList = new List<String>();
    public static List<String> Last12MonthLst = new List<String>();
    public static List<Integer> monthNumLst =  new List<integer>();
    public static List<double> monthListLy = new List<double>();
    //Separated two methods as we are getting Limit Exception for SOQL Rows 50001 if the reportees are more
    @AuraEnabled
    public static visitsWrapper getVisitDetails(User user,Boolean requireConsolidation){
        visitsWrapper wrapper = new visitsWrapper();
        List<Id> userIdLst = new List<Id>();
        //current selected user
        userIdLst.add(user.Id);
        //get all the users who are reporting to the selected user
        if(requireConsolidation){           
            Set<Id> currentUserId = new Set<Id>();
            currentUserId.add(user.Id);
            userIdLst.addAll(Utility.getAllReportees(currentUserId));
        }
        Map<Integer,Integer> DvisitMonthMap = new Map<Integer,Integer>();
        Map<Integer,Set<Date>> uniqueDateMap = new Map<Integer,Set<Date>>();
        Map<Integer,Set<Id>> accountMonthMap = new Map<Integer,Set<Id>>();
        Map<Integer,Set<Id>> SegAccMonthMap = new Map<Integer,Set<Id>>();
        Map<Integer,Integer> segDVisitsMap = new Map<Integer,Integer>();
        Decimal totalDVisits=0;
        Decimal totalAccsVisited = 0;
        Decimal totalDays =0;
        Decimal totalVisitsPerDay = 0;
        Decimal totalVisitsA3 = 0;
        Decimal totalAccsVisitedA3 = 0;
        List<Object> dVisits = new List<Object>();
        List<Object> uniqueDaysCount = new List<Object>();
        List<Object> accountsVisitedLst = new List<Object>();
        List<Object> visitsA3 = new List<Object>();
        List<Object> accsVisitedA3 = new List<Object>();
        List<Object> visitsPerDayInField = new List<Object>();
        Integer month = Date.today().month();
        Map<Integer,String> monthNameMap = new Map<Integer,String>{1=>'JAN',2=>'FEB',3=>'MAR',4=>'APR',5=>'MAY',6=>'JUN',7=>'JUL',8=>'AUG',9=>'SEP',10=>'OCT',11=>'NOV',12=>'DEC'};
        Last12MonthLst.addAll(getLast12MonthList(month));
        for(String mon:Last12MonthLst){
            monthNumLst.add(Integer.valueOf(mon.substringBefore(':')));
            monthNameList.add(monthNameMap.get(Integer.valueOf(mon.substringBefore(':'))));
        } 
        List<Visits__c> visits = [SELECT id,Visit_Type__c,Visit_Status__c,End_Time__c,Account__c,Account__r.Segmentation_Net__c FROM Visits__c WHERE Assigned_to__c in : userIdLst
                            AND RecordType.DeveloperName = 'Standard_Visit' AND Visit_Status__c = 'Complete' AND Visit_Type__c in('Visit','Digital Visit') AND End_Time__c = LAST_N_MONTHS:12 ORDER BY End_Time__c ASC];
        if(visits.size() > 0){
        	for(Visits__c visit:visits){
                if(DvisitMonthMap.size() > 0 && DvisitMonthMap.containsKey(visit.End_Time__c.Month())){
                    Integer dCount = DvisitMonthMap.get(visit.End_Time__c.Month());
                    DvisitMonthMap.put(visit.End_Time__c.Month(),dCount+1);
                }else{
                    DvisitMonthMap.put(visit.End_Time__c.Month(),1);
                }
                if(visit.Account__r.Segmentation_Net__c == 'A3' || visit.Account__r.Segmentation_Net__c == 'B3' || visit.Account__r.Segmentation_Net__c == 'C3'){
                    if(segDVisitsMap.size() > 0 && segDVisitsMap.containsKey(visit.End_Time__c.Month())){
                        Integer dCount = segDVisitsMap.get(visit.End_Time__c.Month());
                        segDVisitsMap.put(visit.End_Time__c.Month(),dCount+1);
                    }else{
                        segDVisitsMap.put(visit.End_Time__c.Month(),1);
                    }
                    if(SegAccMonthMap.size() > 0 && SegAccMonthMap.containsKey(visit.End_Time__c.Month())){
                        Set<Id> accIdSet = SegAccMonthMap.get(visit.End_Time__c.Month());
                        accIdSet.add(visit.Account__c);
                        SegAccMonthMap.put(visit.End_Time__c.Month(),accIdSet);
                    }
                    else{
                        Set<Id> accIdSet = new Set<Id>();
                        accIdSet.add(visit.Account__c);
                        SegAccMonthMap.put(visit.End_Time__c.Month(),accIdSet);
                    }
                }
                if(uniqueDateMap.size() > 0 && uniqueDateMap.containsKey(visit.End_Time__c.Month())){
                    Set<Date> uniqueDaysSet = uniqueDateMap.get(visit.End_Time__c.Month());
                    uniqueDaysSet.add(visit.End_Time__c.Date());
                    uniqueDateMap.put(visit.End_Time__c.Month(),uniqueDaysSet);
                }
                else{
                    Set<Date> uniqueDaysSet = new Set<Date>();
                    uniqueDaysSet.add(visit.End_Time__c.Date());
                    uniqueDateMap.put(visit.End_Time__c.Month(),uniqueDaysSet);
                }
                
                if(accountMonthMap.size() > 0 && accountMonthMap.containsKey(visit.End_Time__c.Month())){
                    Set<Id> accIdSet = accountMonthMap.get(visit.End_Time__c.Month());
                    accIdSet.add(visit.Account__c);
                    accountMonthMap.put(visit.End_Time__c.Month(),accIdSet);
                }
                else{
                    Set<Id> accIdSet = new Set<Id>();
                    accIdSet.add(visit.Account__c);
                    accountMonthMap.put(visit.End_Time__c.Month(),accIdSet);
                }  
       		 }  
        }
        for(Integer mon:monthNumLst){
           //Visits
            Set<Date> uniqueDateSet = new Set<Date>();
            uniqueDateSet = uniqueDateMap.get(mon);
            Integer uniqueDayCount = (uniqueDateSet != null && uniqueDateSet.size() > 0) ? uniqueDateSet.size() : 0;
            uniqueDaysCount.add(uniqueDayCount);
            totalDays += uniqueDayCount;
            
            Set<Id> uniqueAccSet = new Set<Id>();
            uniqueAccSet = accountMonthMap.get(mon);
            Integer uniqueAccCount = (uniqueAccSet != null && uniqueAccSet.size() > 0) ? uniqueAccSet.size() : 0;
            accountsVisitedLst.add(uniqueAccCount);
            totalAccsVisited += uniqueAccCount;
            
            Set<Id> segUniqueAccSet = new Set<Id>();
            segUniqueAccSet = SegAccMonthMap.get(mon);
            Integer segUniqueAccCount = (segUniqueAccSet != null && segUniqueAccSet.size() > 0) ? segUniqueAccSet.size() : 0;
            accsVisitedA3.add(segUniqueAccCount);
            totalAccsVisitedA3 += segUniqueAccCount;
            
            decimal prospectionRate = 0;
            double segDCount = (segDVisitsMap.size() > 0 && segDVisitsMap.containsKey(mon))?segDVisitsMap.get(mon):0;
            double dVisitsCount = (DvisitMonthMap.size() > 0 && DvisitMonthMap.containsKey(mon))?DvisitMonthMap.get(mon):0;
            if(dVisitsCount > 0){
                prospectionRate = (segDCount/dVisitsCount)*100;
            }
            dVisits.add(dVisitsCount);
            totalDVisits += dVisitsCount;
            visitsA3.add(prospectionRate);
            totalVisitsA3 +=Math.round(prospectionRate);
            
            Double visitsPerDayInFieldCount = uniqueDayCount > 0 ? (dVisitsCount/uniqueDayCount) : 0;
            visitsPerDayInField.add(visitsPerDayInFieldCount);
            totalVisitsPerDay += visitsPerDayInFieldCount;    
        }
        wrapper.dVisitsAvg = (totalDVisits/12) > 0 ? (totalDVisits/12) : 0;
        wrapper.uniqueDaysCountAvg = (totalDays/12) > 0 ? (totalDays/12) : 0;
        wrapper.accountsVisitedLstAvg = (totalAccsVisited/12) > 0 ? (totalAccsVisited/12) : 0;
        wrapper.visitsA3Avg = (totalVisitsA3/12) > 0 ?  (totalVisitsA3/12).setScale(2) : 0;
        wrapper.accsVisitedA3Avg = (totalAccsVisitedA3/12) > 0 ? (totalAccsVisitedA3/12) : 0;
        wrapper.visitsPerDayInFieldAvg = (totalVisitsPerDay/12) > 0 ? (totalVisitsPerDay/12) : 0;
        wrapper.dVisits = dVisits;
        wrapper.uniqueDaysCount = uniqueDaysCount;
        wrapper.accountsVisitedLst = accountsVisitedLst;
        wrapper.visitsA3 = visitsA3;
        wrapper.accsVisitedA3 = accsVisitedA3;
        wrapper.visitsPerDayInField = visitsPerDayInField;
        wrapper.monthList = monthNameList;
        return wrapper;
    }
    @AuraEnabled
    public static PerformanceWrapper getPerformanceDetails(User user,Boolean requireConsolidation){        
        PerformanceWrapper wrapper = new PerformanceWrapper(); 
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
        //fiscal year is current year-1 from january to april, year from april to december   
        //April is considering as previous fiscal year till it enters to May         
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        List<Id> userIdLst = new List<Id>();
        //current selected user
        userIdLst.add(user.Id);
        String userRole = user.Sales_Role__c;
        String userRegion =  user.User_Region__c;
        
        //if rep company name is HODG/SOG show gross sales
        Boolean isNet = true;
        if(user.CompanyName == 'HODG' || user.CompanyName == 'SOG')
            isNet = false; 
            
        defaultCurrencyISOcode = user.defaultCurrencyISOcode;
        Set<String> currencySet = new Set<String>();
        currencySet.add('USD');
        currencySet.add(defaultCurrencyISOcode);
        for(CurrencyType currencyValue : [SELECT conversionrate,isocode FROM currencytype WHERE isocode IN : currencySet]){  
            if(currencyValue.isocode == defaultCurrencyISOcode)              
                selectedRepCurrencyRate = currencyValue.conversionrate;
            if(currencyValue.isocode == 'USD')
                usdCurrencyRate = currencyValue.conversionrate;
        }
        //get all the users who are reporting to the selected user
        if(requireConsolidation){           
            Set<Id> currentUserId = new Set<Id>();
            currentUserId.add(user.Id);
            userIdLst.addAll(Utility.getAllReportees(currentUserId));
            System.debug(userIdLst);
        }
        //For Budget Details
        List<MonthlyPerformanceWrapper> monthlyWrapperLst = new List<MonthlyPerformanceWrapper>();
        List<AggregateResult> budgetDataList = [SELECT sum(LocalSales1CY__c) localSales1CY, sum(LocalSales2CY__c) localSales2CY, sum(LocalSales3CY__c) localSales3CY,sum(LocalSales4CY__c) localSales4CY,sum(LocalSales5CY__c) localSales5CY,sum(LocalSales6CY__c) localSales6CY,
                                                sum(LocalSales7CY__c) localSales7CY, sum(LocalSales8CY__c) localSales8CY,sum(LocalSales9CY__c) localSales9CY,sum(LocalSales10CY__c) localSales10CY, sum(LocalSales11CY__c) localSales11CY, sum(LocalSales12CY__c) localSales12CY, sum(Local_Sales_YTD__c) localSalesYTD, 
                                                sum(LocalSales1LY__c) localSales1LY, sum(LocalSales2LY__c) localSales2LY, sum(LocalSales3LY__c) localSales3LY, sum(LocalSales4LY__c) localSales4LY, sum(LocalSales5LY__c) localSales5LY,sum(LocalSales6LY__c) localSales6LY,sum(LocalSales7LY__c) localSales7LY ,sum(LocalSales8LY__c) localSales8LY,
                                                sum(LocalSales9LY__c) localSales9LY, sum(LocalSales10LY__c) localSales10LY, sum(LocalSales11LY__c) localSales11LY, sum(LocalSales12LY__c) localSales12LY , sum(Sales_Apr_vsLY__c) salesAPRLY, sum(Sales_May_vsLY__c) salesMAYLY, sum(Sales_Jun_vsLY__c) salesJUNLY, sum(Sales_Jul_vsLY__c) salesJULLY,
                                                sum(Sales_Aug_vsLY__c) salesAUGLY, sum(Sales_Sep_vsLY__c) salesSEPLY, sum(Sales_Oct_vsLY__c) salesOCTLY, sum(Sales_Nov_vsLY__c) salesNOVLY, sum(Sales_Dec_vsLY__c) salesDECLY,sum(Sales_Jan_vsLY__c) salesJANLY,sum(Sales_Feb_vsLY__c) salesFEBLY,sum(Sales_Mar_vsLY__c) salesMARLY,sum(Sales_YTD_vsLY__c) salesYTD,sum(Quota1CY__c) quota1CY,sum(Quota2CY__c) quota2CY,sum(Quota3CY__c) quota3CY,sum(Quota4CY__c) quota4CY,
                                                sum(Quota5CY__c) quota5CY,sum(Quota6CY__c) quota6CY,sum(Quota7CY__c) quota7CY,sum(Quota8CY__c) quota8CY,sum(Quota9CY__c) quota9CY,sum(Quota10CY__c) quota10CY,sum(Quota11CY__c) quota11CY,sum(Quota12CY__c) quota12CY,
                                                sum(Quota_Ach_April__c) quotaAchAPR,sum(Quota_Ach_May__c) quotaAchMAY,sum(Quota_Ach_June__c) quotaAchJUN,sum(Quota_Ach_July__c) quotaAchJUL,sum(Quota_Ach_August__c) quotaAchAUG,sum(Quota_Ach_September__c) quotaAchSEP,sum(Quota_Ach_October__c) quotaAchOCT,sum(Quota_Ach_November__c) quotaAchNOV,sum(Quota_Ach_December__c) quotaAchDEC,
                                                sum(Quota_Ach_January__c) quotaAchJAN,sum(Quota_Ach_February__c) quotaAchFEB,sum(Quota_Ach_March__c) quotaAchMAR,sum(Quota_YTD__c) quotaYTD,sum(Quota_Ach_YTD__c) quotaAchYTD,sum(Local_Sales_LY_YTD__c) localSalesLYTD FROM Budget_by_ASM__c WHERE Lookupuser__c in :userIdLst];
        Map<Integer,String> budgetMonthNameMap =new Map<Integer,String>{1=>'APR',2=>'MAY',3=>'JUN',4=>'JUL',5=>'AUG',6=>'SEP',7=>'OCT',8=>'NOV',9=>'DEC',10=>'JAN',11=>'FEB',12=>'MAR'};
        Map<String,double> localSalesCYMap= new Map<String,double>();
        Map<String,double> localSalesLYMap= new Map<String,double>();
        Map<String,double> quotaCYMap= new Map<String,double>();
        Map<String,double> salesVsLYMap= new Map<String,double>();
        Map<String,double> quotaAchievedMap= new Map<String,double>();
     
        for(Integer i=1;i<=12;i++){
            String localSalesCY='localSales'+i+'CY';
            String localSalesLY='localSales'+i+'LY';
            String quotaCY='quota'+i+'CY';
            String salesVsLY='sales'+budgetMonthNameMap.get(i)+'LY';
            String quotaAchieved ='quotaAch'+budgetMonthNameMap.get(i);
            if(budgetDataList.size() > 0){
                if((double)budgetDataList[0].get(localSalesCY) != null)
                    localSalesCYMap.put(budgetMonthNameMap.get(i),(double)budgetDataList[0].get(localSalesCY));
                else
                    localSalesCYMap.put(budgetMonthNameMap.get(i),0);
                if((double)budgetDataList[0].get(localSalesLY) != null)
                    localSalesLYMap.put(budgetMonthNameMap.get(i),(double)budgetDataList[0].get(localSalesLY));
                else
                    localSalesLYMap.put(budgetMonthNameMap.get(i),0);                
                if((double)budgetDataList[0].get(quotaCY) != null)
                    quotaCYMap.put(budgetMonthNameMap.get(i),(double)budgetDataList[0].get(quotaCY));
                else
                    quotaCYMap.put(budgetMonthNameMap.get(i),0);
                if((double)budgetDataList[0].get(salesVsLY) != null){
                    if(requireConsolidation && (double)budgetDataList[0].get(localSalesCY) != null && (double)budgetDataList[0].get(localSalesLY) != 0 && (double)budgetDataList[0].get(localSalesLY) != null){
                        salesVsLYMap.put(budgetMonthNameMap.get(i),((double)budgetDataList[0].get(localSalesCY)/(double)budgetDataList[0].get(localSalesLY))*100);
                    }
                    else{
                        salesVsLYMap.put(budgetMonthNameMap.get(i),(double)budgetDataList[0].get(salesVsLY));
                    }
                }
                else
                    salesVsLYMap.put(budgetMonthNameMap.get(i),0);
                if((double)budgetDataList[0].get(quotaAchieved) != null){
                    if(requireConsolidation && (double)budgetDataList[0].get(localSalesCY) != null && (double)budgetDataList[0].get(quotaCY) != 0 && (double)budgetDataList[0].get(quotaCY) != null){
                       quotaAchievedMap.put(budgetMonthNameMap.get(i),((double)budgetDataList[0].get(localSalesCY)/(double)budgetDataList[0].get(quotaCY))*100);
                    }
                    else{
                        quotaAchievedMap.put(budgetMonthNameMap.get(i),((double)budgetDataList[0].get(quotaAchieved)));
                    }
                } 
                else
                    quotaAchievedMap.put(budgetMonthNameMap.get(i),0);
            }
        }
        MonthlyPerformanceWrapper wrapper1 = new MonthlyPerformanceWrapper();
        wrapper1.metric ='Quota FY';
        MonthValues values1= addMonthValues(quotaCYMap);
        if(budgetDataList.size() > 0 && (double)budgetDataList[0].get('quotaYTD') != null)
            values1.TOT_YTD = (double)budgetDataList[0].get('quotaYTD');
        else
            values1.TOT_YTD = 0;
        wrapper1.values=values1;
        monthlyWrapperLst.add(wrapper1);
        
        MonthlyPerformanceWrapper wrapper2 = new MonthlyPerformanceWrapper();
        wrapper2.metric ='Sales FY';
        MonthValues values2= addMonthValues(localSalesCYMap);
        if(budgetDataList.size() > 0 && (double)budgetDataList[0].get('localSalesYTD') != null)
            values2.TOT_YTD = (double)budgetDataList[0].get('localSalesYTD');
        else
            values2.TOT_YTD = 0;
        wrapper2.values=values2;
        monthlyWrapperLst.add(wrapper2);
        
        MonthlyPerformanceWrapper wrapper3 = new MonthlyPerformanceWrapper();
        wrapper3.metric ='% Quota Achievement';
        MonthValues values3= addMonthValues(quotaAchievedMap);
        if(budgetDataList.size() > 0 && (double)budgetDataList[0].get('quotaAchYTD') != null){
            if(requireConsolidation && values1.TOT_YTD != 0){
                 values3.TOT_YTD = (values2.TOT_YTD/values1.TOT_YTD)*100;
            }
            else{
                values3.TOT_YTD = (double)budgetDataList[0].get('quotaAchYTD');
            }
        } 
        else
            values3.TOT_YTD = 0;
        wrapper3.values=values3;
        monthlyWrapperLst.add(wrapper3);
        
        MonthlyPerformanceWrapper wrapper4 = new MonthlyPerformanceWrapper();
        wrapper4.metric ='Sales Last FY';
        MonthValues values4= addMonthValues(localSalesLYMap);
        if(budgetDataList.size() > 0 && (double)budgetDataList[0].get('localSalesLYTD') != null)
            values4.TOT_YTD = (double)budgetDataList[0].get('localSalesLYTD');
        else
            values4.TOT_YTD = 0;
        wrapper4.values=values4;
        monthlyWrapperLst.add(wrapper4);
        
        MonthlyPerformanceWrapper wrapper5 = new MonthlyPerformanceWrapper();
        wrapper5.metric ='% Last Year Achievement';
        MonthValues values5= addMonthValues(salesVsLYMap);
        if(budgetDataList.size() > 0 && (double)budgetDataList[0].get('salesYTD') != null){
            if(requireConsolidation && values4.TOT_YTD != 0){
                 values5.TOT_YTD = (values2.TOT_YTD/values4.TOT_YTD)*100;
            }
            else{
                values5.TOT_YTD = (double)budgetDataList[0].get('salesYTD');
            }
        } 
        else
            values5.TOT_YTD = 0;
        wrapper5.values=values5;
        monthlyWrapperLst.add(wrapper5);
        
        Map<Integer,String> monthNameMap = new Map<Integer,String>{1=>'JAN',2=>'FEB',3=>'MAR',4=>'APR',5=>'MAY',6=>'JUN',7=>'JUL',8=>'AUG',9=>'SEP',10=>'OCT',11=>'NOV',12=>'DEC'};
        Last12MonthLst.addAll(getLast12MonthList(month));
        for(String mon:Last12MonthLst){
            monthNumLst.add(Integer.valueOf(mon.substringBefore(':')));
            monthNameList.add(monthNameMap.get(Integer.valueOf(mon.substringBefore(':'))));
            if(mon.substringAfter(':') == 'LY'){
                monthListLy.add(double.valueOf(mon.substringBefore(':')));
            }
        } 
        List<Sales_Statistics__c> salesCY = [SELECT Id,Lenses_Net_Sales__c,Lenses_Gross_Sales__c,Month__c,Account__c,Fiscal_Year__c from Sales_Statistics__c where Account__r.OwnerId in:userIdLst
                                          AND (Type__c='0' OR Type__c='1') AND Fiscal_Year__c =: CurrentFiscalyear ORDER BY Month__c,Fiscal_Year__c asc];
        //For Last Year filtering only the required months.
        List<Sales_Statistics__c> salesLY = [SELECT Id,Lenses_Net_Sales__c,Lenses_Gross_Sales__c,Month__c,Account__c,Fiscal_Year__c from Sales_Statistics__c where Account__r.OwnerId in:userIdLst
                                          AND (Type__c='0' OR Type__c='1') AND  Fiscal_Year__c =: CurrentFiscalyear-1 AND Month__c in:monthListLy ORDER BY Month__c,Fiscal_Year__c asc];
        //collect monthly lens net sales per account CY/LY
        Map<Id,Map<Integer,double>> monthMapCY = new Map<Id,Map<Integer,double>>();
        Map<Id,Map<Integer,double>> monthMapLY = new Map<Id,Map<Integer,double>>(); 
        if(salesCY.size() > 0){
            for(Sales_Statistics__c salesStat:salesCY){
                double netOrGrossSales = 0;
                if(isNet){
                    netOrGrossSales = (double)salesStat.Lenses_Net_Sales__c;
                }else{ 
                    netOrGrossSales = (double)salesStat.Lenses_Gross_Sales__c;
                }
                if(monthMapCY.size() > 0 && monthMapCY.containsKey(salesStat.Account__c)){
                    Map<Integer,double> monthSaleMap =monthMapCY.get(salesStat.Account__c);
                    if(monthSaleMap.containsKey((Integer)salesStat.Month__c)){//to get the other lenses 0/1
                        double lensTotalSales =0;
                        if(netOrGrossSales != null)
                            lensTotalSales = (double)monthSaleMap.get((Integer)salesStat.Month__c)+netOrGrossSales;
                        else
                            lensTotalSales = (double)monthSaleMap.get((Integer)salesStat.Month__c);  
                        monthSaleMap.put((Integer)salesStat.Month__c,lensTotalSales);
                        monthMapCY.put(salesStat.Account__c,monthSaleMap);
                    }
                    else{
                        if(netOrGrossSales != null)
                            monthSaleMap.put((Integer)salesStat.Month__c,netOrGrossSales);
                        else
                            monthSaleMap.put((Integer)salesStat.Month__c,0);
                        monthMapCY.put(salesStat.Account__c,monthSaleMap);
                    }
                }
                else{
                    Map<Integer,double> monthSaleMap = new Map<Integer,double>();
                    if(netOrGrossSales != null)
                        monthSaleMap.put((Integer)salesStat.Month__c,netOrGrossSales);
                    else
                        monthSaleMap.put((Integer)salesStat.Month__c,0);
                    monthMapCY.put(salesStat.Account__c,monthSaleMap);
                }
            }
        }
        if(salesLY.size() > 0){
            for(Sales_Statistics__c salesStat:salesLY){
                double netOrGrossSales = 0;
                if(isNet){
                    netOrGrossSales = (double)salesStat.Lenses_Net_Sales__c;
                }else{
                    netOrGrossSales = (double)salesStat.Lenses_Gross_Sales__c;
                }
                if(monthMapLY.size() > 0 && monthMapLY.containsKey(salesStat.Account__c)){
                    Map<Integer,double> monthSaleMap =monthMapLY.get(salesStat.Account__c);
                    if(monthSaleMap.containsKey((Integer)salesStat.Month__c)){//to get the other lenses 0/1
                        double lensTotalSales =0;
                        if(netOrGrossSales != null)
                            lensTotalSales = (double)monthSaleMap.get((Integer)salesStat.Month__c)+netOrGrossSales;
                        else
                            lensTotalSales = (double)monthSaleMap.get((Integer)salesStat.Month__c);  
                        monthSaleMap.put((Integer)salesStat.Month__c,lensTotalSales);
                        monthMapLY.put(salesStat.Account__c,monthSaleMap);
                    }
                    else{
                        if(netOrGrossSales != null)
                            monthSaleMap.put((Integer)salesStat.Month__c,netOrGrossSales);
                        else
                            monthSaleMap.put((Integer)salesStat.Month__c,0);
                        monthMapLY.put(salesStat.Account__c,monthSaleMap);
                    }
                }
                else{
                    Map<Integer,double> monthSaleMap = new Map<Integer,double>();
                    if(netOrGrossSales != null)
                        monthSaleMap.put((Integer)salesStat.Month__c,netOrGrossSales);
                    else
                        monthSaleMap.put((Integer)salesStat.Month__c,0);
                    monthMapLY.put(salesStat.Account__c,monthSaleMap);
                }
            }   
        }
        System.debug(monthMapCY);
        System.debug(monthMapLY);
        Map<Integer,Sales> monthlyCountMap = getMonthlyCount(monthMapCY,monthMapLY,Last12MonthLst);
        List<Object> monthlySales = new List<Object>();
        List<Object> greaterThan0List = new List<Object>();
        List<Object> greaterThan500List = new List<Object>();       
        List<Object> greaterThan500USDPercentage = new List<Object>();
            
        //getDoorInfo
        Map<Integer,Integer> doorCountMap = new Map<Integer,Integer>();
        List<Integer> CYMonList=new List<Integer>();
        List<Integer> LYMonList=new List<Integer>();
        if(Last12MonthLst.size() > 0){
            for(String mon:Last12MonthLst){//2:CY
                if(mon.substringAfter(':') != null && mon.substringAfter(':').equalsIgnoreCase('CY'))
                    CYMonList.add(Integer.valueOf(mon.substringBefore(':')));
                else
                    LYMonList.add(Integer.valueOf(mon.substringBefore(':')));
            } 
        }
        Set<Id> accIdSet = new Set<Id>();
        if(monthMapCY.size() > 0)
        	accIdSet.addAll(monthMapCY.keySet());
        if(monthMapLY.size() > 0)   
            accIdSet.addAll(monthMapLY.keySet());
        Map<Integer,Integer> newDoorMonthlyCountMap = new Map<Integer,Integer>();
        Map<Integer,Integer> lostDoorMonthlyCountMap = new Map<Integer,Integer>(); 
        for(Id accId:accIdSet){ 
            Map<Integer,double> monthCySalesMap = new Map<Integer,double>();
            if(monthMapCY.size() > 0 && monthMapCY.containsKey(accId))
                monthCySalesMap = monthMapCY.get(accId);
            for(Integer mon:CYMonList){
                Integer lastMon = mon-1 ;
                Decimal lastMonSales = 0;
                Decimal currMonSales = 0;
                if(monthCySalesMap.size() > 0 && monthCySalesMap.containsKey(mon)){
                    currMonSales = monthCySalesMap.get(mon);
                }
                System.debug(currMonSales);
                if(mon == 4){
                    //if same account is there in last month
                    if(monthMapLY.size() > 0 && monthMapLY.containsKey(accId)){
                        Map<Integer,double> lastMonthMap =  monthMapLY.get(accId);
                        if(lastMonthMap.containsKey(lastMon)){
                            lastMonSales = lastMonthMap.get(lastMon);
                        }
                    }
                }else{
                    if(monthCySalesMap.containsKey(lastMon)){
                        lastMonSales = monthCySalesMap.get(lastMon);
                    }
                }
                System.debug(lastMonSales);
                if(currMonSales > 0 && lastMonSales <= 0){
                    //New
                    if(newDoorMonthlyCountMap.size() > 0 && newDoorMonthlyCountMap.containsKey(mon)){
                          newDoorMonthlyCountMap.put(mon,newDoorMonthlyCountMap.get(mon)+1);
                    }else{
                        newDoorMonthlyCountMap.put(mon,1);
                    }                    
                }else if(currMonSales <= 0 && lastMonSales > 0){
                    //lost
                    if(lostDoorMonthlyCountMap.size() > 0 && lostDoorMonthlyCountMap.containsKey(mon)){
                          lostDoorMonthlyCountMap.put(mon,lostDoorMonthlyCountMap.get(mon)+1);
                    }else{
                        lostDoorMonthlyCountMap.put(mon,1);
                    }
                }
            }
            for(Integer mon:LYMonList){
                Integer lastMon;
                Decimal lastMonSales = 0;
                Decimal currMonSales = 0;
                if(mon == 1){
                    lastMon = 12;
                }else{
                    lastMon = mon - 1;
                }
                Map<Integer,double> monthLySalesMap = new  Map<Integer,double>();
                if(monthMapLY.size() > 0 && monthMapLY.containsKey(accId)){
                    monthLySalesMap = monthMapLY.get(accId);
                }
                System.debug(monthLySalesMap);
                if(monthLySalesMap.size() > 0){
                    if(monthLySalesMap.containskey(mon)){
                        currMonSales = monthLySalesMap.get(mon);
                    }
                    if(monthLySalesMap.containsKey(lastMon)){
                        lastMonSales = monthLySalesMap.get(lastMon);
                    }
                }
                if(currMonSales > 0 && lastMonSales <= 0){
                    //New
                    if(newDoorMonthlyCountMap.size() > 0 && newDoorMonthlyCountMap.containsKey(mon)){
                        newDoorMonthlyCountMap.put(mon,newDoorMonthlyCountMap.get(mon)+1);
                    }else{
                        newDoorMonthlyCountMap.put(mon,1);
                    }                    
                }else if(currMonSales <= 0 && lastMonSales > 0){
                    //lost
                    if(lostDoorMonthlyCountMap.size() > 0 && lostDoorMonthlyCountMap.containsKey(mon)){
                        lostDoorMonthlyCountMap.put(mon,lostDoorMonthlyCountMap.get(mon)+1);
                    }else{
                        lostDoorMonthlyCountMap.put(mon,1);
                    }
                }
            }
        }        
        Decimal total12MoSales = 0;
        Decimal total12MoGreaterThan0 = 0;
        Decimal total12MonGreaterThan500 = 0;
        Decimal total12MoGreater500Perc = 0;       
        List<Object> newDoorCount = new List<Object>();
        List<Object> lostDoorCount =  new List<Object>();
        Decimal totalNewDoor = 0;
        Decimal totalLostDoor = 0;
        for(Integer mon:monthNumLst){
            if(monthlyCountMap.size() > 0 && monthlyCountMap.containsKey(mon)){
                double accSales = 0;
                System.debug(monthlyCountMap.get(mon).greaterThan0count);
                if(monthlyCountMap.get(mon).greaterThan0count > 0 )
                    accSales = monthlyCountMap.get(mon).totalSales/monthlyCountMap.get(mon).greaterThan0count;
                monthlySales.add(accSales);
                System.debug(mon+'--'+accSales);
                total12MoSales += accSales;
                if(monthlyCountMap.get(mon).greaterThan0count != null){
                    greaterThan0List.add(monthlyCountMap.get(mon).greaterThan0count);
                    total12MoGreaterThan0 += monthlyCountMap.get(mon).greaterThan0count;
                }
                else
                    greaterThan0List.add(0);
                if(monthlyCountMap.get(mon).greaterThan500count != null){
                    greaterThan500List.add(monthlyCountMap.get(mon).greaterThan500count);
                    total12MonGreaterThan500 += monthlyCountMap.get(mon).greaterThan500count;
                }
                else
                    greaterThan500List.add(0);
                
                //GREATER THAN 500 USD (%) calculation here    
                Decimal greaterThan0CountValue = monthlyCountMap.get(mon).greaterThan0count != null ? monthlyCountMap.get(mon).greaterThan0count : 0;
                Decimal greaterThan500CountValue = monthlyCountMap.get(mon).greaterThan500count != null ? monthlyCountMap.get(mon).greaterThan500count : 0;
                Double greaterThan500USDPrctg = greaterThan0CountValue > 0 ? (greaterThan500CountValue/greaterThan0CountValue)*100 : 0;
                total12MoGreater500Perc += greaterThan500USDPrctg;
                greaterThan500USDPercentage.add(greaterThan500USDPrctg);
            }
            else{
                monthlySales.add(0);
                greaterThan0List.add(0);
                greaterThan500List.add(0);
                greaterThan500USDPercentage.add(0);
            }
                     
            //Door Info
            if(newDoorMonthlyCountMap.size() > 0 && newDoorMonthlyCountMap.containsKey(mon)){
                newDoorCount.add(newDoorMonthlyCountMap.get(mon));
                totalNewDoor += newDoorMonthlyCountMap.get(mon);
            }  
            else{
                 newDoorCount.add(0);
            }
            if(lostDoorMonthlyCountMap.size() > 0 && lostDoorMonthlyCountMap.containsKey(mon)){
                lostDoorCount.add(lostDoorMonthlyCountMap.get(mon));
                totalLostDoor += lostDoorMonthlyCountMap.get(mon);
            }  
            else{
                lostDoorCount.add(0);
            }
        }
        wrapper.newDoorAvg = (totalNewDoor/12) > 0 ? (totalNewDoor/12) : 0;
        wrapper.lostDoorAvg = (totalLostDoor/12) > 0 ? (totalLostDoor/12) : 0;
        wrapper.activeSalesAvg = (total12MoSales/12) > 0 ? (total12MoSales/12) : 0;
        wrapper.greaterThan0Avg = (total12MoGreaterThan0/12) > 0 ? (total12MoGreaterThan0/12) : 0;
        wrapper.greaterThan500Avg = (total12MonGreaterThan500/12) > 0 ? (total12MonGreaterThan500/12) : 0;
        wrapper.greaterThan500USDPercAvg=(total12MoGreater500Perc/12) > 0?(total12MoGreater500Perc/12).setScale(2) : 0;       
        wrapper.greaterThan0 = greaterThan0List;
        wrapper.greaterThan500 = greaterThan500List;
        wrapper.monthList = monthNameList;
        wrapper.activeSales = monthlySales;       
        wrapper.budgetDetails = monthlyWrapperLst;
        wrapper.greaterThan500USDPercentage = greaterThan500USDPercentage;
        wrapper.newDoorCount = newDoorCount;
        wrapper.LostDoorCount = lostDoorCount; 
        if(isNet)
          wrapper.title = 'Lenses Net Sales ('+user.defaultCurrencyISOcode+')';
        else
            wrapper.title = 'Lenses Gross Sales ('+user.defaultCurrencyISOcode+')';
        System.debug(monthNameList);
        return wrapper;
    }
    private static MonthValues addMonthValues(Map<String,double> valueMap){
        MonthValues values = new MonthValues();
        values.APR=(valueMap.size() > 0 && valueMap.get('APR') > 0) ? valueMap.get('APR') : 0;
        values.MAY=(valueMap.size() > 0 && valueMap.get('MAY') > 0) ? valueMap.get('MAY') : 0;
        values.JUN=(valueMap.size() > 0 && valueMap.get('JUN') > 0) ? valueMap.get('JUN') : 0;
        values.JUL=(valueMap.size() > 0 && valueMap.get('JUL') > 0) ? valueMap.get('JUL') : 0;
        values.AUG=(valueMap.size() > 0 && valueMap.get('AUG') > 0) ? valueMap.get('AUG') : 0;
        values.SEP=(valueMap.size() > 0 && valueMap.get('SEP') > 0) ? valueMap.get('SEP') : 0;
        values.OCT=(valueMap.size() > 0 && valueMap.get('OCT') > 0) ? valueMap.get('OCT') : 0;
        values.NOV=(valueMap.size() > 0 && valueMap.get('NOV') > 0) ? valueMap.get('NOV') : 0;
        values.DEC=(valueMap.size() > 0 && valueMap.get('DEC') > 0) ? valueMap.get('DEC') : 0;
        values.JAN=(valueMap.size() > 0 && valueMap.get('JAN') > 0) ? valueMap.get('JAN') : 0;
        values.FEB=(valueMap.size() > 0 && valueMap.get('FEB') > 0) ? valueMap.get('FEB') : 0;
        values.MAR=(valueMap.size() > 0 && valueMap.get('MAR') > 0) ? valueMap.get('MAR') : 0;        
        return values;
    }   
    //get Last 12 months list based on current month
    private static List<String> getLast12MonthList(Integer currentMonth){
        List<String> twelveMonList = new List<String>();
        switch on currentMonth {
            when 1 {        
                twelveMonList = new List<String>{'1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY'};             
            }   
            when 2 {    
                twelveMonList = new List<String>{'2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY'};
            }
            when 3 {    
                twelveMonList = new List<String>{'3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY'};
            }
            when 4 {        
                twelveMonList = new List<String>{'4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY','12:CY','1:CY','2:CY','3:CY'};
            }
            when 5 {    
                twelveMonList = new List<String>{'5:LY','6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY'};
            }   
            when 6 {    
                twelveMonList = new List<String>{'6:LY','7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY'};
            }
            when 7 {        
                twelveMonList = new List<String>{'7:LY','8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY'};
            }
            when 8 {
                twelveMonList = new List<String>{'8:LY','9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY'};
            }
            when 9 {    
                twelveMonList = new List<String>{'9:LY','10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY'};
            }   
            when 10 {   
                twelveMonList = new List<String>{'10:LY','11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY'};
            }
            when 11 {   
                twelveMonList = new List<String>{'11:LY','12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY'};
            }
            when 12 {   
                twelveMonList = new List<String>{'12:LY','1:LY','2:LY','3:LY','4:CY','5:CY','6:CY','7:CY','8:CY','9:CY','10:CY','11:CY'};
            }
         }
         return twelveMonList;
    }
    //get the accountscount and total sales for each month from last 12 months
    private static Map<Integer,Sales> getMonthlyCount(Map<Id,Map<Integer,double>> monthlyMapCY,Map<Id,Map<Integer,double>> monthlyMapLY, List<String> Last12MonthLst){
        Map<Integer,Sales> monthlySalesCountMap = new Map<Integer,Sales>();
        List<Integer> CYMonList=new List<Integer>();
        List<Integer> LYMonList=new List<Integer>();
        if(Last12MonthLst.size() > 0){
            for(String month:Last12MonthLst){//2:CY
                if(month.substringAfter(':') != null && month.substringAfter(':').equalsIgnoreCase('CY'))
                    CYMonList.add(Integer.valueOf(month.substringBefore(':')));
                else
                    LYMonList.add(Integer.valueOf(month.substringBefore(':')));
            } 
        }
        Map<Integer,Sales> monthlyCYMap = getCountByYear(monthlyMapCY,CYMonList);
        Map<Integer,Sales> monthlyLYMap = getCountByYear(monthlyMapLY,LYMonList);
        monthlySalesCountMap.putAll(monthlyCYMap);
        monthlySalesCountMap.putAll(monthlyLYMap);
        return monthlySalesCountMap;
    }
    private static Map<Integer,Sales> getCountByYear(Map<Id,Map<Integer,double>> monthlyMap,List<Integer> monthLst){
        System.debug(monthlyMap);
        Map<Integer,Sales> monthlySalesCountMap = new Map<Integer,Sales>();
        if(monthlyMap.size() > 0){
            for(Id accId:monthlyMap.keySet()){ 
                Map<Integer,double> monthMap =  monthlyMap.get(accId);
                for(Integer mon:monthLst){
                    if(monthlySalesCountMap.size()>0 && monthlySalesCountMap.containsKey(mon)){
                        Sales monthSale= monthlySalesCountMap.get(mon);
                        if(monthMap.get(mon) > 0){
                            Integer count0 = 0;
                            if(monthSale.greaterThan0count != null)
                                count0 = monthSale.greaterThan0count;
                            Integer count500 = 0;
                            if(monthSale.greaterThan500count != null)
                                count500 = monthSale.greaterThan500count;
                            monthSale.totalSales = monthSale.totalSales+monthMap.get(mon);
                            System.debug(monthSale.totalSales);
                            System.debug(monthMap.get(mon));
                            monthSale.greaterThan0count = count0+1;
                            
                            if(defaultCurrencyISOcode != 'USD'){
                                Double usdConvertedRate = selectedRepCurrencyRate > 0 ? ((monthMap.get(mon)/selectedRepCurrencyRate)*usdCurrencyRate) : monthMap.get(mon);
                                if(usdConvertedRate > 500)
                                    monthSale.greaterThan500count = count500+1;
                            }else{
                                if(monthMap.get(mon) > 500)
                                    monthSale.greaterThan500count = count500+1;
                            }
                            monthlySalesCountMap.put(mon,monthSale);
                        }
                    }
                    else{
                        Integer accCount = 0;
                        if(monthMap.get(mon) > 0){ 
                            Sales monthSale= new Sales();
                            monthSale.greaterThan0count = accCount+1;
                            if(defaultCurrencyISOcode != 'USD'){
                                Double usdConvertedRate = selectedRepCurrencyRate > 0 ? ((monthMap.get(mon)/selectedRepCurrencyRate)*usdCurrencyRate) : monthMap.get(mon);
                                if(usdConvertedRate > 500)
                                    monthSale.greaterThan500count = accCount+1;
                            }else{
                                if(monthMap.get(mon) > 500)
                                    monthSale.greaterThan500count = accCount+1;
                            }   
                            monthSale.totalSales = monthMap.get(mon);
                            monthlySalesCountMap.put(mon,monthSale);
                        }
                    }
                }
            }
        }
        return monthlySalesCountMap;
    }    
    public class MonthlyPerformanceWrapper{
        public MonthlyPerformanceWrapper(){}
        @AuraEnabled public String metric{get;set;}
        @AuraEnabled public MonthValues values{get;set;}
    }
    public class MonthValues {
        @AuraEnabled public double APR;
        @AuraEnabled public double MAY;
        @AuraEnabled public double JUN;
        @AuraEnabled public double JUL;
        @AuraEnabled public double AUG;
        @AuraEnabled public double SEP;
        @AuraEnabled public double OCT;
        @AuraEnabled public double NOV;
        @AuraEnabled public double DEC;
        @AuraEnabled public double JAN;
        @AuraEnabled public double FEB;
        @AuraEnabled public double MAR;
        @AuraEnabled public double TOT_YTD;
    }
    public class PerformanceWrapper{
        public PerformanceWrapper(){}
        @AuraEnabled public List<Object> greaterThan0{get;set;} 
        @AuraEnabled public Decimal greaterThan0Avg{get;set;} 
        @AuraEnabled public List<Object> greaterThan500{get;set;}
        @AuraEnabled public Decimal greaterThan500Avg{get;set;}
        @AuraEnabled public List<Object> monthList{get;set;}
        @AuraEnabled public List<Object> activeSales{get;set;}
        @AuraEnabled public Decimal activeSalesAvg{get;set;}        
        @AuraEnabled public List<Object> budgetDetails{get;set;}
        @AuraEnabled public String title{get;set;}       
        @AuraEnabled public List<Object> greaterThan500USDPercentage{get;set;}  
        @AuraEnabled public Decimal greaterThan500USDPercAvg{get;set;}  
        @AuraEnabled public List<Object> newDoorCount{get;set;}
        @AuraEnabled public List<Object> LostDoorCount{get;set;}
        @AuraEnabled public Decimal newDoorAvg{get;set;} 
        @AuraEnabled public Decimal lostDoorAvg{get;set;}         
    }   
    public class visitsWrapper{
        @AuraEnabled public List<Object> monthList{get;set;}
        @AuraEnabled public List<Object> dVisits{get;set;}        
        @AuraEnabled public Decimal dVisitsAvg{get;set;}
        @AuraEnabled public List<Object> uniqueDaysCount{get;set;}
        @AuraEnabled public Decimal uniqueDaysCountAvg{get;set;}
        @AuraEnabled public List<Object> accountsVisitedLst{get;set;}
        @AuraEnabled public Decimal accountsVisitedLstAvg{get;set;}
        @AuraEnabled public List<Object> visitsA3{get;set;}
        @AuraEnabled public Decimal visitsA3Avg{get;set;}
        @AuraEnabled public List<Object> accsVisitedA3{get;set;}
        @AuraEnabled public Decimal accsVisitedA3Avg{get;set;}
        @AuraEnabled public List<Object> visitsPerDayInField{get;set;}
        @AuraEnabled public Decimal visitsPerDayInFieldAvg{get;set;}
    }
    public class Sales{
        @AuraEnabled public Decimal totalSales{get;set;}
        @AuraEnabled public Integer greaterThan0count{get;set;}
        @AuraEnabled public Integer greaterThan500count{get;set;}
    public Sales(){
            totalSales=0;
            greaterThan0count=0;
            greaterThan500count=0;
        }
    }  
}