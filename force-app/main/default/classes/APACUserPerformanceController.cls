public with sharing class APACUserPerformanceController {

    /*
        ========================================================================
        This class to support for User performance review in User tab (lightning)
        Create as Lightning component (Aura bundled)
        @Auther : Surawat Sakulmontreechai | sakulmontreechai@yahoo.com
        @Created : 2022-05-12
        @Version : 1.0
        @LastUpdated : 2022-05-12
        Aura component distribute attached in User tab
        =========================================================================
    */

    /*
        *** Starting class for budget by asm (Budget_by_ASM__c) ***
        @author : Surawat Sakulmontreechai
        @Email : sakulmontreechai@yahoo.com
        @version : 1.0
        @since : v.49.0 (via api force.com)
        @Created date : 2022-05-17
        @Wrapper Class for budget by asm
        *** this class must compare with QV_Sales__c to calculate what achive with Sales reps.***
        return : accountUser (dataList)
        ==================================================================
    */

    public class AccountUser{
        
        //@AuraEnabled public User user{get;set;}

        //@AuraEnabled public Budget_by_ASM__c budget{get;set;}

        @AuraEnabled public Double QuoApr{get;set;}
        @AuraEnabled public Double QuoMay{get;set;}
        @AuraEnabled public Double QuoJun{get;set;}
        @AuraEnabled public Double QuoJul{get;set;}
        @AuraEnabled public Double QuoAug{get;set;}
        @AuraEnabled public Double QuoSep{get;set;}
        @AuraEnabled public Double QuoOct{get;set;}
        @AuraEnabled public Double QuoNov{get;set;}
        @AuraEnabled public Double QuoDec{get;set;}
        @AuraEnabled public Double QuoJan{get;set;}
        @AuraEnabled public Double QuoFeb{get;set;}
        @AuraEnabled public Double QuoMar{get;set;}
        @AuraEnabled public Double TotalBudget{get;set;}

        @AuraEnabled public Double AprSales{get;set;}
        @AuraEnabled public Double MaySales{get;set;}
        @AuraEnabled public Double JunSales{get;set;}
        @AuraEnabled public Double JulSales{get;set;}
        @AuraEnabled public Double AugSales{get;set;}
        @AuraEnabled public Double SepSales{get;set;}
        @AuraEnabled public Double OctSales{get;set;}
        @AuraEnabled public Double NovSales{get;set;}
        @AuraEnabled public Double DecSales{get;set;}
        @AuraEnabled public Double JanSales{get;set;}
        @AuraEnabled public Double FebSales{get;set;}
        @AuraEnabled public Double MarSales{get;set;}
        @AuraEnabled public Double TotalSales{get;set;}

        //get Data for Quantity
        /*
        @AuraEnabled public Double AprQty{get;set;}
        @AuraEnabled public Double MayQty{get;set;}
        @AuraEnabled public Double JunQty{get;set;}
        @AuraEnabled public Double JulQty{get;set;}
        @AuraEnabled public Double AugQty{get;set;}
        @AuraEnabled public Double SepQty{get;set;}
        @AuraEnabled public Double OctQty{get;set;}
        @AuraEnabled public Double NovQty{get;set;}
        @AuraEnabled public Double DecQty{get;set;}
        @AuraEnabled public Double JanQty{get;set;}
        @AuraEnabled public Double FebQty{get;set;}
        @AuraEnabled public Double MarQty{get;set;}
        @AuraEnabled public Double TotalQty{get;set;}
        
        //get data for quantity last FY
        @AuraEnabled public Double AprQtyLY{get;set;}
        @AuraEnabled public Double MayQtyLY{get;set;}
        @AuraEnabled public Double JunQtyLY{get;set;}
        @AuraEnabled public Double JulQtyLY{get;set;}
        @AuraEnabled public Double AugQtyLY{get;set;}
        @AuraEnabled public Double SepQtyLY{get;set;}
        @AuraEnabled public Double OctQtyLY{get;set;}
        @AuraEnabled public Double NovQtyLY{get;set;}
        @AuraEnabled public Double DecQtyLY{get;set;}
        @AuraEnabled public Double JanQtyLY{get;set;}
        @AuraEnabled public Double FebQtyLY{get;set;}
        @AuraEnabled public Double MarQtyLY{get;set;}
        @AuraEnabled public Double TotalQtyLY{get;set;}
        */
        @AuraEnabled public double QuoAprLY{get;set;}
        @AuraEnabled public double QuoMayLY{get;set;}
        @AuraEnabled public double QuoJunLY{get;set;}
        @AuraEnabled public double QuoJulLY{get;set;}
        @AuraEnabled public double QuoAugLY{get;set;}
        @AuraEnabled public double QuoSepLY{get;set;}
        @AuraEnabled public double QuoOctLY{get;set;}
        @AuraEnabled public double QuoNovLY{get;set;}
        @AuraEnabled public double QuoDecLY{get;set;}
        @AuraEnabled public double QuoJanLY{get;set;}
        @AuraEnabled public double QuoFebLY{get;set;}
        @AuraEnabled public double QuoMarLY{get;set;}
        @AuraEnabled public double QuoTotalLY{get;set;}

        @AuraEnabled public Double AprSalesLY{get;set;}
        @AuraEnabled public Double MaySalesLY{get;set;}
        @AuraEnabled public Double JunSalesLY{get;set;}
        @AuraEnabled public Double JulSalesLY{get;set;}
        @AuraEnabled public Double AugSalesLY{get;set;}
        @AuraEnabled public Double SepSalesLY{get;set;}
        @AuraEnabled public Double OctSalesLY{get;set;}
        @AuraEnabled public Double NovSalesLY{get;set;}
        @AuraEnabled public Double DecSalesLY{get;set;}
        @AuraEnabled public Double JanSalesLY{get;set;}
        @AuraEnabled public Double FebSalesLY{get;set;}
        @AuraEnabled public Double MarSalesLY{get;set;}
        @AuraEnabled public Double TotalSalesLY{get;set;}

        //@AuraEnabled public Double LastMonthQuota{get;set;}

        //visit per day variables
        @AuraEnabled public Double VisitPerDayApr{get;set;}
        @AuraEnabled public Double VisitPerDayMay{get;set;}
        @AuraEnabled public Double VisitPerDayJun{get;set;}
        @AuraEnabled public Double VisitPerDayJul{get;set;}
        @AuraEnabled public Double VisitPerDayAug{get;set;}
        @AuraEnabled public Double VisitPerDaySep{get;set;}
        @AuraEnabled public Double VisitPerDayOct{get;set;}
        @AuraEnabled public Double VisitPerDayNov{get;set;}
        @AuraEnabled public Double VisitPerDayDec{get;set;}
        @AuraEnabled public Double VisitPerDayJan{get;set;}
        @AuraEnabled public Double VisitPerDayFeb{get;set;}
        @AuraEnabled public Double VisitPerDayMar{get;set;}
        @AuraEnabled public Double VisitPerDayTotal{get;set;}

        @AuraEnabled public Double Ind_Day_in_field_Apr{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_May{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Jun{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Jul{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Aug{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Sep{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Oct{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Nov{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Dec{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Jan{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Feb{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Mar{get;set;}
        @AuraEnabled public Double Ind_Day_in_field_Total{get;set;}
        @AuraEnabled public Double getConversionRate{get;set;}

        //@AuraEnabled public Double Last3MonthSalesCY{get;set;}
        //@AuraEnabled public Double Last3MonthSalesLY{get;set;}
        //@AuraEnabled public Double Last3MonthQtyCY{get;set;}
        //@AuraEnabled public Double Last3MonthQtyLY{get;set;}

        public string CurrFY{get;set;}
        public string PrevFY{get;set;}
        public string CurFY{get;set;}       //For visit kpi fiscal year
        public String NextFY{get;set;}
        public Integer CurrYear{get;set;}
        public Integer LastYear{get;set;}
        public Integer NextYear{get;set;}

        @AuraEnabled public String getCurrFY(){return CurrFY;}
        @AuraEnabled public String getPrevFY(){return PrevFY;}
        @AuraEnabled public String getCurFY(){return CurFY;}
        @AuraEnabled public String getNextFY(){return NextFY;}
    }

    public class TotalVisits{
        @AuraEnabled public double AprTotalVisits{get;set;}
        @AuraEnabled public double MayTotalVisits{get;set;}
        @AuraEnabled public double JunTotalVisits{get;set;}
        @AuraEnabled public double JulTotalVisits{get;set;}
        @AuraEnabled public double AugTotalVisits{get;set;}
        @AuraEnabled public double SepTotalVisits{get;set;}
        @AuraEnabled public double OctTotalVisits{get;set;}
        @AuraEnabled public double NovTotalVisits{get;set;}
        @AuraEnabled public double DecTotalVisits{get;set;}
        @AuraEnabled public double JanTotalVisits{get;set;}
        @AuraEnabled public double FebTotalVisits{get;set;}
        @AuraEnabled public double MarTotalVisits{get;set;}
        @AuraEnabled public double TotalTotalVisits{get;set;}

        @AuraEnabled public double AprTotalVisitsLY{get;set;}
        @AuraEnabled public double MayTotalVisitsLY{get;set;}
        @AuraEnabled public double JunTotalVisitsLY{get;set;}
        @AuraEnabled public double JulTotalVisitsLY{get;set;}
        @AuraEnabled public double AugTotalVisitsLY{get;set;}
        @AuraEnabled public double SepTotalVisitsLY{get;set;}
        @AuraEnabled public double OctTotalVisitsLY{get;set;}
        @AuraEnabled public double NovTotalVisitsLY{get;set;}
        @AuraEnabled public double DecTotalVisitsLY{get;set;}
        @AuraEnabled public double JanTotalVisitsLY{get;set;}
        @AuraEnabled public double FebTotalVisitsLY{get;set;}
        @AuraEnabled public double MarTotalVisitsLY{get;set;}
        @AuraEnabled public double TotalTotalVisitsLY{get;set;}

        public Integer CurrYear{get;set;}
        public Integer NextYear{get;set;}
        public Integer PrevYear{get;set;}
        
    }

    public class TotalVisited{
        @AuraEnabled public String Last2MthLabel{get;set;}
        @AuraEnabled public String Last1MthLabel{get;set;}
        @AuraEnabled public String LastMthLabel{get;set;}

        @AuraEnabled public double AprVisited{get;set;}
        @AuraEnabled public double MayVisited{get;set;}
        @AuraEnabled public double JunVisited{get;set;}
        @AuraEnabled public double JulVisited{get;set;}
        @AuraEnabled public double AugVisited{get;set;}
        @AuraEnabled public double SepVisited{get;set;}
        @AuraEnabled public double OctVisited{get;set;}
        @AuraEnabled public double NovVisited{get;set;}
        @AuraEnabled public double DecVisited{get;set;}
        @AuraEnabled public double JanVisited{get;set;}
        @AuraEnabled public double FebVisited{get;set;}
        @AuraEnabled public double MarVisited{get;set;}

        @AuraEnabled public double AprVisitedLY{get;set;}
        @AuraEnabled public double MayVisitedLY{get;set;}
        @AuraEnabled public double JunVisitedLY{get;set;}
        @AuraEnabled public double JulVisitedLY{get;set;}
        @AuraEnabled public double AugVisitedLY{get;set;}
        @AuraEnabled public double SepVisitedLY{get;set;}
        @AuraEnabled public double OctVisitedLY{get;set;}
        @AuraEnabled public double NovVisitedLY{get;set;}
        @AuraEnabled public double DecVisitedLY{get;set;}
        @AuraEnabled public double JanVisitedLY{get;set;}
        @AuraEnabled public double FebVisitedLY{get;set;}
        @AuraEnabled public double MarVisitedLY{get;set;}
        
        @AuraEnabled public double Last2MthVisited{get;set;}
        @AuraEnabled public double Last1MthVisited{get;set;}
        @AuraEnabled public double LastMthVisited{get;set;}

        @AuraEnabled public Integer CurrFY{get;set;}
        @AuraEnabled public Integer PrevFY{get;set;}
        @AuraEnabled public Integer NextFY{get;set;}
    }
    /*
    public class TotalVisitsBySegmA{
        @AuraEnabled public double AprVisitsA1{get;set;}
        @AuraEnabled public double MayVisitsA1{get;set;}
        @AuraEnabled public double JunVisitsA1{get;set;}
        @AuraEnabled public double JulVisitsA1{get;set;}
        @AuraEnabled public double AugVisitsA1{get;set;}
        @AuraEnabled public double SepVisitsA1{get;set;}
        @AuraEnabled public double OctVisitsA1{get;set;}
        @AuraEnabled public double NovVisitsA1{get;set;}
        @AuraEnabled public double DecVisitsA1{get;set;}
        @AuraEnabled public double JanVisitsA1{get;set;}
        @AuraEnabled public double FebVisitsA1{get;set;}
        @AuraEnabled public double MarVisitsA1{get;set;}

        @AuraEnabled public double AprVisitsA2{get;set;}
        @AuraEnabled public double MayVisitsA2{get;set;}
        @AuraEnabled public double JunVisitsA2{get;set;}
        @AuraEnabled public double JulVisitsA2{get;set;}
        @AuraEnabled public double AugVisitsA2{get;set;}
        @AuraEnabled public double SepVisitsA2{get;set;}
        @AuraEnabled public double OctVisitsA2{get;set;}
        @AuraEnabled public double NovVisitsA2{get;set;}
        @AuraEnabled public double DecVisitsA2{get;set;}
        @AuraEnabled public double JanVisitsA2{get;set;}
        @AuraEnabled public double FebVisitsA2{get;set;}
        @AuraEnabled public double MarVisitsA2{get;set;}

        @AuraEnabled public double AprVisitsA3{get;set;}
        @AuraEnabled public double MayVisitsA3{get;set;}
        @AuraEnabled public double JunVisitsA3{get;set;}
        @AuraEnabled public double JulVisitsA3{get;set;}
        @AuraEnabled public double AugVisitsA3{get;set;}
        @AuraEnabled public double SepVisitsA3{get;set;}
        @AuraEnabled public double OctVisitsA3{get;set;}
        @AuraEnabled public double NovVisitsA3{get;set;}
        @AuraEnabled public double DecVisitsA3{get;set;}
        @AuraEnabled public double JanVisitsA3{get;set;}
        @AuraEnabled public double FebVisitsA3{get;set;}
        @AuraEnabled public double MarVisitsA3{get;set;}

        public Integer CurrYear{get;set;}
        public Integer NextYear{get;set;}
        public Integer PrevYear{get;set;}
    }

    public class TotalVisitsBySegmB{
        @AuraEnabled public double AprVisitsB1{get;set;}
        @AuraEnabled public double MayVisitsB1{get;set;}
        @AuraEnabled public double JunVisitsB1{get;set;}
        @AuraEnabled public double JulVisitsB1{get;set;}
        @AuraEnabled public double AugVisitsB1{get;set;}
        @AuraEnabled public double SepVisitsB1{get;set;}
        @AuraEnabled public double OctVisitsB1{get;set;}
        @AuraEnabled public double NovVisitsB1{get;set;}
        @AuraEnabled public double DecVisitsB1{get;set;}
        @AuraEnabled public double JanVisitsB1{get;set;}
        @AuraEnabled public double FebVisitsB1{get;set;}
        @AuraEnabled public double MarVisitsB1{get;set;}

        @AuraEnabled public double AprVisitsB2{get;set;}
        @AuraEnabled public double MayVisitsB2{get;set;}
        @AuraEnabled public double JunVisitsB2{get;set;}
        @AuraEnabled public double JulVisitsB2{get;set;}
        @AuraEnabled public double AugVisitsB2{get;set;}
        @AuraEnabled public double SepVisitsB2{get;set;}
        @AuraEnabled public double OctVisitsB2{get;set;}
        @AuraEnabled public double NovVisitsB2{get;set;}
        @AuraEnabled public double DecVisitsB2{get;set;}
        @AuraEnabled public double JanVisitsB2{get;set;}
        @AuraEnabled public double FebVisitsB2{get;set;}
        @AuraEnabled public double MarVisitsB2{get;set;}

        @AuraEnabled public double AprVisitsB3{get;set;}
        @AuraEnabled public double MayVisitsB3{get;set;}
        @AuraEnabled public double JunVisitsB3{get;set;}
        @AuraEnabled public double JulVisitsB3{get;set;}
        @AuraEnabled public double AugVisitsB3{get;set;}
        @AuraEnabled public double SepVisitsB3{get;set;}
        @AuraEnabled public double OctVisitsB3{get;set;}
        @AuraEnabled public double NovVisitsB3{get;set;}
        @AuraEnabled public double DecVisitsB3{get;set;}
        @AuraEnabled public double JanVisitsB3{get;set;}
        @AuraEnabled public double FebVisitsB3{get;set;}
        @AuraEnabled public double MarVisitsB3{get;set;}

        public Integer CurrYear{get;set;}
        public Integer NextYear{get;set;}
        public Integer PrevYear{get;set;}
    }

    public class TotalVisitsBySegmC{
        @AuraEnabled public double AprVisitsC1{get;set;}
        @AuraEnabled public double MayVisitsC1{get;set;}
        @AuraEnabled public double JunVisitsC1{get;set;}
        @AuraEnabled public double JulVisitsC1{get;set;}
        @AuraEnabled public double AugVisitsC1{get;set;}
        @AuraEnabled public double SepVisitsC1{get;set;}
        @AuraEnabled public double OctVisitsC1{get;set;}
        @AuraEnabled public double NovVisitsC1{get;set;}
        @AuraEnabled public double DecVisitsC1{get;set;}
        @AuraEnabled public double JanVisitsC1{get;set;}
        @AuraEnabled public double FebVisitsC1{get;set;}
        @AuraEnabled public double MarVisitsC1{get;set;}

        @AuraEnabled public double AprVisitsC2{get;set;}
        @AuraEnabled public double MayVisitsC2{get;set;}
        @AuraEnabled public double JunVisitsC2{get;set;}
        @AuraEnabled public double JulVisitsC2{get;set;}
        @AuraEnabled public double AugVisitsC2{get;set;}
        @AuraEnabled public double SepVisitsC2{get;set;}
        @AuraEnabled public double OctVisitsC2{get;set;}
        @AuraEnabled public double NovVisitsC2{get;set;}
        @AuraEnabled public double DecVisitsC2{get;set;}
        @AuraEnabled public double JanVisitsC2{get;set;}
        @AuraEnabled public double FebVisitsC2{get;set;}
        @AuraEnabled public double MarVisitsC2{get;set;}

        @AuraEnabled public double AprVisitsC3{get;set;}
        @AuraEnabled public double MayVisitsC3{get;set;}
        @AuraEnabled public double JunVisitsC3{get;set;}
        @AuraEnabled public double JulVisitsC3{get;set;}
        @AuraEnabled public double AugVisitsC3{get;set;}
        @AuraEnabled public double SepVisitsC3{get;set;}
        @AuraEnabled public double OctVisitsC3{get;set;}
        @AuraEnabled public double NovVisitsC3{get;set;}
        @AuraEnabled public double DecVisitsC3{get;set;}
        @AuraEnabled public double JanVisitsC3{get;set;}
        @AuraEnabled public double FebVisitsC3{get;set;}
        @AuraEnabled public double MarVisitsC3{get;set;}

        public Integer CurrYear{get;set;}
        public Integer NextYear{get;set;}
        public Integer PrevYear{get;set;}
    }*/
    /*
    public class RxStockSale{
        @AuraEnabled public double AprRxSales{get;set;}
        @AuraEnabled public double MayRxSales{get;set;}
        @AuraEnabled public double JunRxSales{get;set;}
        @AuraEnabled public double JulRxSales{get;set;}
        @AuraEnabled public double AugRxSales{get;set;}
        @AuraEnabled public double SepRxSales{get;set;}
        @AuraEnabled public double OctRxSales{get;set;}
        @AuraEnabled public double NovRxSales{get;set;}
        @AuraEnabled public double DecRxSales{get;set;}
        @AuraEnabled public double JanRxSales{get;set;}
        @AuraEnabled public double FebRxSales{get;set;}
        @AuraEnabled public double MarRxSales{get;set;}
        @AuraEnabled public double TotalRxSales{get;set;}

        @AuraEnabled public double AprRxSalesLY{get;set;}
        @AuraEnabled public double MayRxSalesLY{get;set;}
        @AuraEnabled public double JunRxSalesLY{get;set;}
        @AuraEnabled public double JulRxSalesLY{get;set;}
        @AuraEnabled public double AugRxSalesLY{get;set;}
        @AuraEnabled public double SepRxSalesLY{get;set;}
        @AuraEnabled public double OctRxSalesLY{get;set;}
        @AuraEnabled public double NovRxSalesLY{get;set;}
        @AuraEnabled public double DecRxSalesLY{get;set;}
        @AuraEnabled public double JanRxSalesLY{get;set;}
        @AuraEnabled public double FebRxSalesLY{get;set;}
        @AuraEnabled public double MarRxSalesLY{get;set;}
        @AuraEnabled public double TotalRxSalesLY{get;set;}

        @AuraEnabled public double AprRxQty{get;set;}
        @AuraEnabled public double MayRxQty{get;set;}
        @AuraEnabled public double JunRxQty{get;set;}
        @AuraEnabled public double JulRxQty{get;set;}
        @AuraEnabled public double AugRxQty{get;set;}
        @AuraEnabled public double SepRxQty{get;set;}
        @AuraEnabled public double OctRxQty{get;set;}
        @AuraEnabled public double NovRxQty{get;set;}
        @AuraEnabled public double DecRxQty{get;set;}
        @AuraEnabled public double JanRxQty{get;set;}
        @AuraEnabled public double FebRxQty{get;set;}
        @AuraEnabled public double MarRxQty{get;set;}
        @AuraEnabled public double TotalRxQty{get;set;}

        @AuraEnabled public double AprRxQtyLY{get;set;}
        @AuraEnabled public double MayRxQtyLY{get;set;}
        @AuraEnabled public double JunRxQtyLY{get;set;}
        @AuraEnabled public double JulRxQtyLY{get;set;}
        @AuraEnabled public double AugRxQtyLY{get;set;}
        @AuraEnabled public double SepRxQtyLY{get;set;}
        @AuraEnabled public double OctRxQtyLY{get;set;}
        @AuraEnabled public double NovRxQtyLY{get;set;}
        @AuraEnabled public double DecRxQtyLY{get;set;}
        @AuraEnabled public double JanRxQtyLY{get;set;}
        @AuraEnabled public double FebRxQtyLY{get;set;}
        @AuraEnabled public double MarRxQtyLY{get;set;}
        @AuraEnabled public double TotalRxQtyLY{get;set;}

        @AuraEnabled public double AprStSales{get;set;}
        @AuraEnabled public double MayStSales{get;set;}
        @AuraEnabled public double JunStSales{get;set;}
        @AuraEnabled public double JulStSales{get;set;}
        @AuraEnabled public double AugStSales{get;set;}
        @AuraEnabled public double SepStSales{get;set;}
        @AuraEnabled public double OctStSales{get;set;}
        @AuraEnabled public double NovStSales{get;set;}
        @AuraEnabled public double DecStSales{get;set;}
        @AuraEnabled public double JanStSales{get;set;}
        @AuraEnabled public double FebStSales{get;set;}
        @AuraEnabled public double MarStSales{get;set;}
        @AuraEnabled public double TotalStSales{get;set;}

        @AuraEnabled public double AprStSalesLY{get;set;}
        @AuraEnabled public double MayStSalesLY{get;set;}
        @AuraEnabled public double JunStSalesLY{get;set;}
        @AuraEnabled public double JulStSalesLY{get;set;}
        @AuraEnabled public double AugStSalesLY{get;set;}
        @AuraEnabled public double SepStSalesLY{get;set;}
        @AuraEnabled public double OctStSalesLY{get;set;}
        @AuraEnabled public double NovStSalesLY{get;set;}
        @AuraEnabled public double DecStSalesLY{get;set;}
        @AuraEnabled public double JanStSalesLY{get;set;}
        @AuraEnabled public double FebStSalesLY{get;set;}
        @AuraEnabled public double MarStSalesLY{get;set;}
        @AuraEnabled public double TotalStSalesLY{get;set;}

        @AuraEnabled public double AprStQty{get;set;}
        @AuraEnabled public double MayStQty{get;set;}
        @AuraEnabled public double JunStQty{get;set;}
        @AuraEnabled public double JulStQty{get;set;}
        @AuraEnabled public double AugStQty{get;set;}
        @AuraEnabled public double SepStQty{get;set;}
        @AuraEnabled public double OctStQty{get;set;}
        @AuraEnabled public double NovStQty{get;set;}
        @AuraEnabled public double DecStQty{get;set;}
        @AuraEnabled public double JanStQty{get;set;}
        @AuraEnabled public double FebStQty{get;set;}
        @AuraEnabled public double MarStQty{get;set;}
        @AuraEnabled public double TotalStQty{get;set;}

        @AuraEnabled public double AprStQtyLY{get;set;}
        @AuraEnabled public double MayStQtyLY{get;set;}
        @AuraEnabled public double JunStQtyLY{get;set;}
        @AuraEnabled public double JulStQtyLY{get;set;}
        @AuraEnabled public double AugStQtyLY{get;set;}
        @AuraEnabled public double SepStQtyLY{get;set;}
        @AuraEnabled public double OctStQtyLY{get;set;}
        @AuraEnabled public double NovStQtyLY{get;set;}
        @AuraEnabled public double DecStQtyLY{get;set;}
        @AuraEnabled public double JanStQtyLY{get;set;}
        @AuraEnabled public double FebStQtyLY{get;set;}
        @AuraEnabled public double MarStQtyLY{get;set;}
        @AuraEnabled public double TotalStQtyLY{get;set;}

        @AuraEnabled public double AprOthSales{get;set;}
        @AuraEnabled public double MayOthSales{get;set;}
        @AuraEnabled public double JunOthSales{get;set;}
        @AuraEnabled public double JulOthSales{get;set;}
        @AuraEnabled public double AugOthSales{get;set;}
        @AuraEnabled public double SepOthSales{get;set;}
        @AuraEnabled public double OctOthSales{get;set;}
        @AuraEnabled public double NovOthSales{get;set;}
        @AuraEnabled public double DecOthSales{get;set;}
        @AuraEnabled public double JanOthSales{get;set;}
        @AuraEnabled public double FebOthSales{get;set;}
        @AuraEnabled public double MarOthSales{get;set;}
        @AuraEnabled public double TotalOthSales{get;set;}

        @AuraEnabled public double AprOthSalesLY{get;set;}
        @AuraEnabled public double MayOthSalesLY{get;set;}
        @AuraEnabled public double JunOthSalesLY{get;set;}
        @AuraEnabled public double JulOthSalesLY{get;set;}
        @AuraEnabled public double AugOthSalesLY{get;set;}
        @AuraEnabled public double SepOthSalesLY{get;set;}
        @AuraEnabled public double OctOthSalesLY{get;set;}
        @AuraEnabled public double NovOthSalesLY{get;set;}
        @AuraEnabled public double DecOthSalesLY{get;set;}
        @AuraEnabled public double JanOthSalesLY{get;set;}
        @AuraEnabled public double FebOthSalesLY{get;set;}
        @AuraEnabled public double MarOthSalesLY{get;set;}
        @AuraEnabled public double TotalOthSalesLY{get;set;}

        @AuraEnabled public double AprOthQty{get;set;}
        @AuraEnabled public double MayOthQty{get;set;}
        @AuraEnabled public double JunOthQty{get;set;}
        @AuraEnabled public double JulOthQty{get;set;}
        @AuraEnabled public double AugOthQty{get;set;}
        @AuraEnabled public double SepOthQty{get;set;}
        @AuraEnabled public double OctOthQty{get;set;}
        @AuraEnabled public double NovOthQty{get;set;}
        @AuraEnabled public double DecOthQty{get;set;}
        @AuraEnabled public double JanOthQty{get;set;}
        @AuraEnabled public double FebOthQty{get;set;}
        @AuraEnabled public double MarOthQty{get;set;}
        @AuraEnabled public double TotalOthQty{get;set;}

        @AuraEnabled public double AprOthQtyLY{get;set;}
        @AuraEnabled public double MayOthQtyLY{get;set;}
        @AuraEnabled public double JunOthQtyLY{get;set;}
        @AuraEnabled public double JulOthQtyLY{get;set;}
        @AuraEnabled public double AugOthQtyLY{get;set;}
        @AuraEnabled public double SepOthQtyLY{get;set;}
        @AuraEnabled public double OctOthQtyLY{get;set;}
        @AuraEnabled public double NovOthQtyLY{get;set;}
        @AuraEnabled public double DecOthQtyLY{get;set;}
        @AuraEnabled public double JanOthQtyLY{get;set;}
        @AuraEnabled public double FebOthQtyLY{get;set;}
        @AuraEnabled public double MarOthQtyLY{get;set;}
        @AuraEnabled public double TotalOthQtyLY{get;set;}

        public String CurrFY{get;set;}
        public String PrevFY{get;set;}
        
    }*/
    /*
    public class GenericDesignSales{

        @AuraEnabled public double AprSVSales{get;set;}
        @AuraEnabled public double MaySVSales{get;set;}
        @AuraEnabled public double JunSVSales{get;set;}
        @AuraEnabled public double JulSVSales{get;set;}
        @AuraEnabled public double AugSVSales{get;set;}
        @AuraEnabled public double SepSVSales{get;set;}
        @AuraEnabled public double OctSVSales{get;set;}
        @AuraEnabled public double NovSVSales{get;set;}
        @AuraEnabled public double DecSVSales{get;set;}
        @AuraEnabled public double JanSVSales{get;set;}
        @AuraEnabled public double FebSVSales{get;set;}
        @AuraEnabled public double MarSVSales{get;set;}
        @AuraEnabled public double TotalSVSales{get;set;}

        @AuraEnabled public double AprSVSalesLY{get;set;}
        @AuraEnabled public double MaySVSalesLY{get;set;}
        @AuraEnabled public double JunSVSalesLY{get;set;}
        @AuraEnabled public double JulSVSalesLY{get;set;}
        @AuraEnabled public double AugSVSalesLY{get;set;}
        @AuraEnabled public double SepSVSalesLY{get;set;}
        @AuraEnabled public double OctSVSalesLY{get;set;}
        @AuraEnabled public double NovSVSalesLY{get;set;}
        @AuraEnabled public double DecSVSalesLY{get;set;}
        @AuraEnabled public double JanSVSalesLY{get;set;}
        @AuraEnabled public double FebSVSalesLY{get;set;}
        @AuraEnabled public double MarSVSalesLY{get;set;}
        @AuraEnabled public double TotalSVSalesLY{get;set;}

        @AuraEnabled public double AprSVQty{get;set;}
        @AuraEnabled public double MaySVQty{get;set;}
        @AuraEnabled public double JunSVQty{get;set;}
        @AuraEnabled public double JulSVQty{get;set;}
        @AuraEnabled public double AugSVQty{get;set;}
        @AuraEnabled public double SepSVQty{get;set;}
        @AuraEnabled public double OctSVQty{get;set;}
        @AuraEnabled public double NovSVQty{get;set;}
        @AuraEnabled public double DecSVQty{get;set;}
        @AuraEnabled public double JanSVQty{get;set;}
        @AuraEnabled public double FebSVQty{get;set;}
        @AuraEnabled public double MarSVQty{get;set;}
        @AuraEnabled public double TotalSVQty{get;set;}

        @AuraEnabled public double AprSVQtyLY{get;set;}
        @AuraEnabled public double MaySVQtyLY{get;set;}
        @AuraEnabled public double JunSVQtyLY{get;set;}
        @AuraEnabled public double JulSVQtyLY{get;set;}
        @AuraEnabled public double AugSVQtyLY{get;set;}
        @AuraEnabled public double SepSVQtyLY{get;set;}
        @AuraEnabled public double OctSVQtyLY{get;set;}
        @AuraEnabled public double NovSVQtyLY{get;set;}
        @AuraEnabled public double DecSVQtyLY{get;set;}
        @AuraEnabled public double JanSVQtyLY{get;set;}
        @AuraEnabled public double FebSVQtyLY{get;set;}
        @AuraEnabled public double MarSVQtyLY{get;set;}
        @AuraEnabled public double TotalSVQtyLY{get;set;}

        public String CurrFY{get;set;}
        public String PrevFY{get;set;}
    }
    */
    /*
    public class GenDesignOthsSales{

        @AuraEnabled public double AprOthsSales{get;set;}
        @AuraEnabled public double MayOthsSales{get;set;}
        @AuraEnabled public double JunOthsSales{get;set;}
        @AuraEnabled public double JulOthsSales{get;set;}
        @AuraEnabled public double AugOthsSales{get;set;}
        @AuraEnabled public double SepOthsSales{get;set;}
        @AuraEnabled public double OctOthsSales{get;set;}
        @AuraEnabled public double NovOthsSales{get;set;}
        @AuraEnabled public double DecOthsSales{get;set;}
        @AuraEnabled public double JanOthsSales{get;set;}
        @AuraEnabled public double FebOthsSales{get;set;}
        @AuraEnabled public double MarOthsSales{get;set;}
        @AuraEnabled public double TotalOthsSales{get;set;}

        @AuraEnabled public double AprOthsSalesLY{get;set;}
        @AuraEnabled public double MayOthsSalesLY{get;set;}
        @AuraEnabled public double JunOthsSalesLY{get;set;}
        @AuraEnabled public double JulOthsSalesLY{get;set;}
        @AuraEnabled public double AugOthsSalesLY{get;set;}
        @AuraEnabled public double SepOthsSalesLY{get;set;}
        @AuraEnabled public double OctOthsSalesLY{get;set;}
        @AuraEnabled public double NovOthsSalesLY{get;set;}
        @AuraEnabled public double DecOthsSalesLY{get;set;}
        @AuraEnabled public double JanOthsSalesLY{get;set;}
        @AuraEnabled public double FebOthsSalesLY{get;set;}
        @AuraEnabled public double MarOthsSalesLY{get;set;}
        @AuraEnabled public double TotalOthsSalesLY{get;set;}

        @AuraEnabled public double AprOthsQty{get;set;}
        @AuraEnabled public double MayOthsQty{get;set;}
        @AuraEnabled public double JunOthsQty{get;set;}
        @AuraEnabled public double JulOthsQty{get;set;}
        @AuraEnabled public double AugOthsQty{get;set;}
        @AuraEnabled public double SepOthsQty{get;set;}
        @AuraEnabled public double OctOthsQty{get;set;}
        @AuraEnabled public double NovOthsQty{get;set;}
        @AuraEnabled public double DecOthsQty{get;set;}
        @AuraEnabled public double JanOthsQty{get;set;}
        @AuraEnabled public double FebOthsQty{get;set;}
        @AuraEnabled public double MarOthsQty{get;set;}
        @AuraEnabled public double TotalOthsQty{get;set;}

        @AuraEnabled public double AprOthsQtyLY{get;set;}
        @AuraEnabled public double MayOthsQtyLY{get;set;}
        @AuraEnabled public double JunOthsQtyLY{get;set;}
        @AuraEnabled public double JulOthsQtyLY{get;set;}
        @AuraEnabled public double AugOthsQtyLY{get;set;}
        @AuraEnabled public double SepOthsQtyLY{get;set;}
        @AuraEnabled public double OctOthsQtyLY{get;set;}
        @AuraEnabled public double NovOthsQtyLY{get;set;}
        @AuraEnabled public double DecOthsQtyLY{get;set;}
        @AuraEnabled public double JanOthsQtyLY{get;set;}
        @AuraEnabled public double FebOthsQtyLY{get;set;}
        @AuraEnabled public double MarOthsQtyLY{get;set;}
        @AuraEnabled public double TotalOthsQtyLY{get;set;}

        public string CurrFY{get;set;}
        public string PrevFY{get;set;}
    }
    */
    public class Salesfigure{
        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}
        //@AuraEnabled public double TotalVal{get;set;}

        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}
        //@AuraEnabled public double TotalValLY{get;set;}

        @AuraEnabled public double AprVol{get;set;}
        @AuraEnabled public double MayVol{get;set;}
        @AuraEnabled public double JunVol{get;set;}
        @AuraEnabled public double JulVol{get;set;}
        @AuraEnabled public double AugVol{get;set;}
        @AuraEnabled public double SepVol{get;set;}
        @AuraEnabled public double OctVol{get;set;}
        @AuraEnabled public double NovVol{get;set;}
        @AuraEnabled public double DecVol{get;set;}
        @AuraEnabled public double JanVol{get;set;}
        @AuraEnabled public double FebVol{get;set;}
        @AuraEnabled public double MarVol{get;set;}
        //@AuraEnabled public double TotalVol{get;set;}

        @AuraEnabled public double AprVolLY{get;set;}
        @AuraEnabled public double MayVolLY{get;set;}
        @AuraEnabled public double JunVolLY{get;set;}
        @AuraEnabled public double JulVolLY{get;set;}
        @AuraEnabled public double AugVolLY{get;set;}
        @AuraEnabled public double SepVolLY{get;set;}
        @AuraEnabled public double OctVolLY{get;set;}
        @AuraEnabled public double NOvVolLY{get;set;}
        @AuraEnabled public double DecVolLY{get;set;}
        @AuraEnabled public double JanVolLY{get;set;}
        @AuraEnabled public double FebVolLY{get;set;}
        @AuraEnabled public double MarVolLY{get;set;}
        //@AuraEnabled public double TotalVolLY{get;set;}
        /*
        @AuraEnabled public double AprASP{get;set;}
        @AuraEnabled public double MayASP{get;set;}
        @AuraEnabled public double JunASP{get;set;}
        @AuraEnabled public double JulASP{get;set;}
        @AuraEnabled public double AugASP{get;set;}
        @AuraEnabled public double SepASP{get;set;}
        @AuraEnabled public double OctASP{get;set;}
        @AuraEnabled public double NovASP{get;set;}
        @AuraEnabled public double DecASP{get;set;}
        @AuraEnabled public double JanASP{get;set;}
        @AuraEnabled public double FebASP{get;set;}
        @AuraEnabled public double MarASP{get;set;}
        @AuraEnabled public double TotalASP{get;set;}

        @AuraEnabled public double AprASPLY{get;set;}
        @AuraEnabled public double MayASPLY{get;set;}
        @AuraEnabled public double JunASPLY{get;set;}
        @AuraEnabled public double JulASPLY{get;set;}
        @AuraEnabled public double AugASPLY{get;set;}
        @AuraEnabled public double SepASPLY{get;set;}
        @AuraEnabled public double OctASPLY{get;set;}
        @AuraEnabled public double NovASPLY{get;set;}
        @AuraEnabled public double DecASPLY{get;set;}
        @AuraEnabled public double JanASPLY{get;set;}
        @AuraEnabled public double FebASPLY{get;set;}
        @AuraEnabled public double MarASPLY{get;set;}
        @AuraEnabled public double TotalASPLY{get;set;}
        */
        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public string PrevFY{get;set;}
        @AuraEnabled public double getConversionRate{get;set;}
    }

    public class ActiveDoorSales{
        /**==== This class maintain for Active Door Sales more than $1 USD ====****/
        @AuraEnabled public double AprActiveSales{get;set;}
        @AuraEnabled public double MayActiveSales{get;set;}
        @AuraEnabled public double JunActiveSales{get;set;}
        @AuraEnabled public double JulActiveSales{get;set;}
        @AuraEnabled public double AugActiveSales{get;set;}
        @AuraEnabled public double SepActiveSales{get;set;}
        @AuraEnabled public double OctActiveSales{get;set;}
        @AuraEnabled public double NovActiveSales{get;set;}
        @AuraEnabled public double DecActiveSales{get;set;}
        @AuraEnabled public double JanActiveSales{get;set;}
        @AuraEnabled public double FebActiveSales{get;set;}
        @AuraEnabled public double MarActiveSales{get;set;}

        @AuraEnabled public double AprActiveSalesLY{get;set;}
        @AuraEnabled public double MayActiveSalesLY{get;set;}
        @AuraEnabled public double JunActiveSalesLY{get;set;}
        @AuraEnabled public double JulActiveSalesLY{get;set;}
        @AuraEnabled public double AugActiveSalesLY{get;set;}
        @AuraEnabled public double SepActiveSalesLY{get;set;}
        @AuraEnabled public double OctActiveSalesLY{get;set;}
        @AuraEnabled public double NovActiveSalesLY{get;set;}
        @AuraEnabled public double DecActiveSalesLY{get;set;}
        @AuraEnabled public double JanActiveSalesLY{get;set;}
        @AuraEnabled public double FebActiveSalesLY{get;set;}
        @AuraEnabled public double MarActiveSalesLY{get;set;}

        @AuraEnabled public string Last2MthLabel{get;set;}
        @AuraEnabled public string Last1MthLabel{get;set;}
        @AuraEnabled public string LastMthLabel{get;set;}

        @AuraEnabled public double Last2MthActiveSales{get;set;}
        @AuraEnabled public double Last1MthActiveSales{get;set;}
        @AuraEnabled public double LastMthActiveSales{get;set;}

        @AuraEnabled public double Last2MthActiveSalesLY{get;set;}
        @AuraEnabled public double Last1MthActiveSalesLY{get;set;}
        @AuraEnabled public double LastMthActiveSalesLY{get;set;}

        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public string PrevFY{get;set;}
        @AuraEnabled public string NextFY{get;set;}
    }

    public class UserQVSalesByTargetList{

        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}

        @AuraEnabled public double AprVol{get;set;}
        @AuraEnabled public double MayVol{get;set;}
        @AuraEnabled public double JunVol{get;set;}
        @AuraEnabled public double JulVol{get;set;}
        @AuraEnabled public double AugVol{get;set;}
        @AuraEnabled public double SepVol{get;set;}
        @AuraEnabled public double OctVol{get;set;}
        @AuraEnabled public double NovVol{get;set;}
        @AuraEnabled public double DecVol{get;set;}
        @AuraEnabled public double JanVol{get;set;}
        @AuraEnabled public double FebVol{get;set;}
        @AuraEnabled public double MarVol{get;set;}

        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}

        @AuraEnabled public double AprVolLY{get;set;}
        @AuraEnabled public double MayVolLY{get;set;}
        @AuraEnabled public double JunVolLY{get;set;}
        @AuraEnabled public double JulVolLY{get;set;}
        @AuraEnabled public double AugVolLY{get;set;}
        @AuraEnabled public double SepVolLY{get;set;}
        @AuraEnabled public double OctVolLY{get;set;}
        @AuraEnabled public double NovVolLY{get;set;}
        @AuraEnabled public double DecVolLY{get;set;}
        @AuraEnabled public double JanVolLY{get;set;}
        @AuraEnabled public double FebVolLY{get;set;}
        @AuraEnabled public double MarVolLY{get;set;}

        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public string PrevFY{get;set;}
        @AuraEnabled public string N2FY{get;set;}

        @AuraEnabled public string LastMonthLabel{get;set;}
        @AuraEnabled public string LastMonthLabelLY{get;set;}

        @AuraEnabled public double MarValLYN2{get;set;}
        @AuraEnabled public double MarVolLYN2{get;set;}

        @AuraEnabled public double LastMonthVal{get;set;}
        @AuraEnabled public double LastMonthValLY{get;set;}
        @AuraEnabled public double LastMonthVol{get;set;}
        @AuraEnabled public double LastMonthVolLY{get;set;}

    }

    public class FisCalYear{
        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public string LastFY{get;set;}
    }

    public class QVData{

        public QVData(String pDesign, Double pannualSales, Integer paanualQty){
            design = pDesign;
            annualSales = pannualSales;
            annualQty = paanualQty;
        }
            public String design{get; set;}
            public Double annualSales{get; set;}
            public Integer annualQty{get; set;}
    }

    public class BudgetData{
        public BudgetData(String pName, String pLookUpName){
            BudgetName = pName;
            Lookupname = pLookUpName;
        }
        public String BudgetName{get;set;}
        public String Lookupname {get;set;}
    }

    public class VisitData{
        public VisitData(String pId, String pName){
            pIdName = pId;
            pVName = pName;
        }
        public String pIdName{get;set;}
        public String pVName{get;set;}
    }

    public class LevelInterested{
        public LevelInterested(){
            this.InterestedLevel1=InterestedLevel2=InterestedLevel3=InterestedLevel4 = 0;
        }

        @AuraEnabled public String CampaignName{get;set;}
        @AuraEnabled public Double InterestedLevel1{get;set;}
        @AuraEnabled public Double InterestedLevel2{get;set;}
        @AuraEnabled public Double InterestedLevel3{get;set;}
        @AuraEnabled public Double InterestedLevel4{get;set;}

    }
    /*
    public class TopCustomer{
        public TopCustomer(){
            this.AprVal=MayVal=JunVal=JulVal=AugVal=SepVal=OctVal=NovVal=DecVal=JanVal=FebVal=MarVal=Annual=AprValLY=MayValLY=JunValLY=JulValLY=AugValLY=SepValLY=OctValLY=NovValLY=DecValLY=JanValLY=FebValLY=MarValLY=AnnualLY=0;
        }
        @AuraEnabled public string AccountId{get;set;}
        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}
        @AuraEnabled public double Annual{get;set;}
        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}
        @AuraEnabled public double AnnualLY{get;set;}
    }
    */
    public class TopTenCustomer{
        public TopTenCustomer(){
            this.AprVal=MayVal=JunVal=JulVal=AugVal=SepVal=OctVal=NovVal=DecVal=JanVal=FebVal=MarVal=AnnualVal=AprVol=MayVol=JunVol=JulVol=AugVol=SepVol=OctVol=NovVol=DecVol=JanVol=FebVol=MarVol=AnnualVol=AprValLY=MayValLY=JunValLY=JulValLY=AugValLY=SepValLY=OctValLY=NovValLY=DecValLY=JanValLy=FebValLY=MarValLY=AnnualValLY=AprVolLY=MayVolLY=JunVolLY=JulVolLY=AugVolLY=SepVolLY=OctVolLY=NovVolLY=DecVolLY=JanVolLY=FebVolLY=MarVolLY=AnnualVolLY=RollingVal=RollingVol=0;
        }
        @AuraEnabled public String AccountId{get;set;}
        @AuraEnabled public String AccountName{get;set;}
        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}
        @AuraEnabled public double AnnualVal{get;set;}
        @AuraEnabled public double AprVol{get;set;}
        @AuraEnabled public double MayVol{get;set;}
        @AuraEnabled public double JunVol{get;set;}
        @AuraEnabled public double JulVol{get;set;}
        @AuraEnabled public double AugVol{get;set;}
        @AuraEnabled public double SepVol{get;set;}
        @AuraEnabled public double OctVol{get;set;}
        @AuraEnabled public double NovVol{get;set;}
        @AuraEnabled public double DecVol{get;set;}
        @AuraEnabled public double JanVol{get;set;}
        @AuraEnabled public double FebVol{get;set;}
        @AuraEnabled public double MarVol{get;set;}
        @AuraEnabled public double AnnualVol{get;set;}
        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}
        @AuraEnabled public double AnnualValLY{get;set;}
        @AuraEnabled public double AprVolLY{get;set;}
        @AuraEnabled public double MayVolLY{get;set;}
        @AuraEnabled public double JunVolLY{get;set;}
        @AuraEnabled public double JulVolLY{get;set;}
        @AuraEnabled public double AugVolLY{get;set;}
        @AuraEnabled public double SepVolLY{get;set;}
        @AuraEnabled public double OctVolLY{get;set;}
        @AuraEnabled public double NovVolLY{get;set;}
        @AuraEnabled public double DecVolLY{get;set;}
        @AuraEnabled public double JanVolLY{get;set;}
        @AuraEnabled public double FebVolLY{get;set;}
        @AuraEnabled public double MarVolLY{get;set;}
        @AuraEnabled public double AnnualVolLY{get;set;}
        @AuraEnabled public double RollingVal{get;set;}
        @AuraEnabled public double RollingVol{get;set;}
    }
    /*
    public class SalesSegmentation{
        public SalesSegmentation(String segmentation, Double AprValLY, Double MayValLY, Double JunValLY, Double JulValLY, Double AugValLY, Double SepValLY, Double OctValLY, Double NovValLY, Double DecValLY, Double JanValLY, Double FebValLY, Double MarValLY, Double AnnualRevenue){
            this.segmentation = segmentation;
            this.AprValLY = AprValLY;
            this.MayValLY = MayValLY;
            this.JunValLY = JunValLY;
            this.JulValLY = JulValLY;
            this.AugValLY = AugValLY;
            this.SepValLY = SepValLY;
            this.OctValLY = OctValLY;
            this.NovValLY = NovValLY;
            this.DecValLY = DecValLY;
            this.JanValLY = JanValLY;
            this.FebValLY = FebValLY;
            this.MarValLY = MarValLY;
            this.AnnualRevenue = AnnualRevenue;
        }
        @AuraEnabled public string segmentation{get;set;}
        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}
        @AuraEnabled public double AnnualRevenue{get;set;}
    }*/

    public class NewSalesSegmentation{
        public NewSalesSegmentation(){
            this.AprVal=MayVal=JunVal=JulVal=AugVal=SepVal=OctVal=NovVal=DecVal=JanVal=FebVal=MarVal=AnnualVal=0;
        }

        @AuraEnabled public string segmentation;
        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}
        @AuraEnabled public double AnnualVal{get;set;}
        //@AuraEnabled public double ActiveCust{get;set;}
    }

    public class ActiveTargetCampaign{
        public ActiveTargetCampaign(){
            this.TargetCampaign=NotTargetCampaign= 0;
            
        }
        @AuraEnabled public string CampaignName{get;set;}
        @AuraEnabled public double TargetCampaign{get;set;}
        @AuraEnabled public double NotTargetCampaign{get;set;}
    }

    public class StockRx{

        @AuraEnabled public string Stock_or_Rx{get;set;}

        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}

        @AuraEnabled public double AprVol{get;set;}
        @AuraEnabled public double MayVol{get;set;}
        @AuraEnabled public double JunVol{get;set;}
        @AuraEnabled public double JulVol{get;set;}
        @AuraEnabled public double AugVol{get;set;}
        @AuraEnabled public double SepVol{get;set;}
        @AuraEnabled public double OctVol{get;set;}
        @AuraEnabled public double NovVol{get;set;}
        @AuraEnabled public double DecVol{get;set;}
        @AuraEnabled public double JanVol{get;set;}
        @AuraEnabled public double FebVol{get;set;}
        @AuraEnabled public double MarVol{get;set;}

        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}

        @AuraEnabled public double AprVolLY{get;set;}
        @AuraEnabled public double MayVolLY{get;set;}
        @AuraEnabled public double JunVolLY{get;set;}
        @AuraEnabled public double JulVolLY{get;set;}
        @AuraEnabled public double AugVolLY{get;set;}
        @AuraEnabled public double SepVolLY{get;set;}
        @AuraEnabled public double OctVolLY{get;set;}
        @AuraEnabled public double NovVolLY{get;set;}
        @AuraEnabled public double DecVolLY{get;set;}
        @AuraEnabled public double JanVolLY{get;set;}
        @AuraEnabled public double FebVolLY{get;set;}
        @AuraEnabled public double MarVolLY{get;set;}

        @AuraEnabled public double ValLastFY{get;set;}              //values last FY          
        @AuraEnabled public double ValLast12MthRolling{get;set;}    //values last 12 months rolling
        
        @AuraEnabled public double VolLastFY{get;set;}              //volumn last FY
        @AuraEnabled public double VolLast12MthRolling{get;set;}    //volumn last 12 months rolling
        
        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public string PrevFY{get;set;}
        @AuraEnabled public double ConversionRate{get;set;}
        
    }

    public class LensDesign{
        @AuraEnabled public String GenericDesign{get;set;}
        @AuraEnabled public double AprVal{get;set;}
        @AuraEnabled public double MayVal{get;set;}
        @AuraEnabled public double JunVal{get;set;}
        @AuraEnabled public double JulVal{get;set;}
        @AuraEnabled public double AugVal{get;set;}
        @AuraEnabled public double SepVal{get;set;}
        @AuraEnabled public double OctVal{get;set;}
        @AuraEnabled public double NovVal{get;set;}
        @AuraEnabled public double DecVal{get;set;}
        @AuraEnabled public double JanVal{get;set;}
        @AuraEnabled public double FebVal{get;set;}
        @AuraEnabled public double MarVal{get;set;}

        @AuraEnabled public double AprVol{get;set;}
        @AuraEnabled public double MayVol{get;set;}
        @AuraEnabled public double JunVol{get;set;}
        @AuraEnabled public double JulVol{get;set;}
        @AuraEnabled public double AugVol{get;set;}
        @AuraEnabled public double SepVol{get;set;}
        @AuraEnabled public double OctVol{get;set;}
        @AuraEnabled public double NovVol{get;set;}
        @AuraEnabled public double DecVol{get;set;}
        @AuraEnabled public double JanVol{get;set;}
        @AuraEnabled public double FebVol{get;set;}
        @AuraEnabled public double MarVol{get;set;}

        @AuraEnabled public double AprValLY{get;set;}
        @AuraEnabled public double MayValLY{get;set;}
        @AuraEnabled public double JunValLY{get;set;}
        @AuraEnabled public double JulValLY{get;set;}
        @AuraEnabled public double AugValLY{get;set;}
        @AuraEnabled public double SepValLY{get;set;}
        @AuraEnabled public double OctValLY{get;set;}
        @AuraEnabled public double NovValLY{get;set;}
        @AuraEnabled public double DecValLY{get;set;}
        @AuraEnabled public double JanValLY{get;set;}
        @AuraEnabled public double FebValLY{get;set;}
        @AuraEnabled public double MarValLY{get;set;}

        @AuraEnabled public double AprVolLY{get;set;}
        @AuraEnabled public double MayVolLY{get;set;}
        @AuraEnabled public double JunVolLY{get;set;}
        @AuraEnabled public double JulVolLY{get;set;}
        @AuraEnabled public double AugVolLY{get;set;}
        @AuraEnabled public double SepVolLY{get;set;}
        @AuraEnabled public double OctVolLY{get;set;}
        @AuraEnabled public double NovVolLY{get;set;}
        @AuraEnabled public double DecVolLY{get;set;}
        @AuraEnabled public double JanVolLY{get;set;}
        @AuraEnabled public double FebVolLY{get;set;}
        @AuraEnabled public double MarVolLY{get;set;}

        @AuraEnabled public double LastFYVal{get;set;}
        @AuraEnabled public double LastFYVol{get;set;}
        @AuraEnabled public double Last12MthsVal{get;set;}
        @AuraEnabled public double Last12MthsVol{get;set;}

        @AuraEnabled public string PrevFY{get;set;}
        @AuraEnabled public string CurrFY{get;set;}
        @AuraEnabled public double getConversionrate{get;set;}

    }

    //public static List<QvData> dataList{get;set;}       //get data for QV_Sales__c current year
    //public static List<QvData> dataListLY{get;set;}     //get data for QV_Sales__c last fiscal year
    //public static List<BudgetData> dataBudgetList{get;set;}
    public static List<VisitData> dataVisitPerDayAprList{get;set;}
    public static List<VisitData> dataVisitPerDayMayList{get;set;}
    public static List<VisitData> dataVisitPerDayJunList{get;set;}
    public static List<VisitData> dataVisitPerDayJulList{get;set;}
    public static List<VisitData> dataVisitPerDayAugList{get;set;}
    public static List<VisitData> dataVisitPerDaySepList{get;set;}
    public static List<VisitData> dataVisitPerDayOctList{get;set;}
    public static List<VisitData> dataVisitPerDayNovList{get;set;}
    public static List<VisitData> dataVisitPerDayDecList{get;set;}
    public static List<VisitData> dataVisitPerDayJanList{get;set;}
    public static List<VisitData> dataVisitPerDayFebList{get;set;}
    public static List<VisitData> dataVisitPerDayMarList{get;set;}
    public static List<LevelInterested> dataLevelInterested{get;set;}
    public static List<ActiveTargetCampaign> dataTargetCampaign{get;set;}
    //public static List<TopCustomer> dataTopCustomer{get;set;}
    public static List<TopTenCustomer> dataTopTenCustomer{get;set;}
    //public static List<SalesSegmentation> dataSegmentation{get;set;}
    //public static List<QvData> dataListGenDesign{get;set;}

    private static Double conversionRate{get;set;}
    private static Double originalConversionRate{get;set;}
    private static Double userConversionRate{get;set;}
    private static Double LastmonthQuotaCY{get;set;}
    private static Double conversionRateUSD{get;set;}

    public map<Id, User> userList;
    public map<Id, Budget_by_ASM__c> budgetList;

    //public static AggregateResult[] userQVSales;
    //public static AggregateResult[] userQVSalesLY;
    public static AggregateResult[] userBudget;
    public static AggregateResult[] userVisitPerDayApr;
    public static AggregateResult[] userVisitPerDayMay;
    public static AggregateResult[] userVisitPerDayJun;
    public static AggregateResult[] userVisitPerDayJul;
    public static AggregateResult[] userVisitPerDayAug;
    public static AggregateResult[] userVisitPerDaySep;
    public static AggregateResult[] userVisitPerDayOct;
    public static AggregateResult[] userVisitPerDayNov;
    public static AggregateResult[] userVisitPerDayDec;
    public static AggregateResult[] userVisitPerDayJan;
    public static AggregateResult[] userVisitPerDayFeb;
    public static AggregateResult[] userVisitPerDayMar;

    public static AggregateResult[] AprTotalsVisit;
    public static AggregateResult[] MayTotalsVisit;
    public static AggregateResult[] JunTotalsVisit;
    public static AggregateResult[] JulTotalsVisit;
    public static AggregateResult[] AugTotalsVisit;
    public static AggregateResult[] SepTotalsVisit;
    public static AggregateResult[] OctTotalsVisit;
    public static AggregateResult[] NovTotalsVisit;
    public static AggregateResult[] DecTotalsVisit;
    public static AggregateResult[] JanTotalsVisit;
    public static AggregateResult[] FebTotalsVisit;
    public static AggregateResult[] MarTotalsVisit;

    public static AggregateResult[] AprTotalsVisitLY;
    public static AggregateResult[] MayTotalsVisitLY;
    public static AggregateResult[] JunTotalsVisitLY;
    public static AggregateResult[] JulTotalsVisitLY;
    public static AggregateResult[] AugTotalsVisitLY;
    public static AggregateResult[] SepTotalsVisitLY;
    public static AggregateResult[] OctTotalsVisitLY;
    public static AggregateResult[] NovTotalsVisitLY;
    public static AggregateResult[] DecTotalsVisitLY;
    public static AggregateResult[] JanTotalsVisitLY;
    public static AggregateResult[] FebTotalsVisitLY;
    public static AggregateResult[] MarTotalsVisitLY;

    public static AggregateResult[] AprVisited;
    public static AggregateResult[] MayVisited;
    public static AggregateResult[] JunVisited;
    public static AggregateResult[] JulVisited;
    public static AggregateResult[] AugVisited;
    public static AggregateResult[] SepVisited;
    public static AggregateResult[] OctVisited;
    public static AggregateResult[] NovVisited;
    public static AggregateResult[] DecVisited;
    public static AggregateResult[] JanVisited;
    public static AggregateResult[] FebVisited;
    public static AggregateResult[] MarVisited;

    public static AggregateResult[] AprVisitedLY;
    public static AggregateResult[] MayVisitedLY;
    public static AggregateResult[] JunVisitedLY;
    public static AggregateResult[] JulVisitedLY;
    public static AggregateResult[] AugVisitedLY;
    public static AggregateResult[] SepVisitedLY;
    public static AggregateResult[] OctVisitedLY;
    public static AggregateResult[] NovVisitedLY;
    public static AggregateResult[] DecVisitedLY;
    public static AggregateResult[] JanVisitedLY;
    public static AggregateResult[] FebVisitedLY;
    public static AggregateResult[] MarVisitedLY;

    public static AggregateResult[] AprActiveSales;
    public static AggregateResult[] MayActiveSales;
    public static AggregateResult[] JunActiveSales;
    public static AggregateResult[] JulActiveSales;
    public static AggregateResult[] AugActiveSales;
    public static AggregateResult[] SepActiveSales;
    public static AggregateResult[] OctActiveSales;
    public static AggregateResult[] NovActiveSales;
    public static AggregateResult[] DecActiveSales;
    public static AggregateResult[] JanActiveSales;
    public static AggregateResult[] FebActiveSales;
    public static AggregateResult[] MarActiveSales;

    public static AggregateResult[] AprActiveSalesLY;
    public static AggregateResult[] MayActiveSalesLY;
    public static AggregateResult[] JunActiveSalesLY;
    public static AggregateResult[] JulActiveSalesLY;
    public static AggregateResult[] AugActiveSalesLY;
    public static AggregateResult[] SepActiveSalesLY;
    public static AggregateResult[] OctActiveSalesLY;
    public static AggregateResult[] NovActiveSalesLY;
    public static AggregateResult[] DecActiveSalesLY;
    public static AggregateResult[] JanActiveSalesLY;
    public static AggregateResult[] FebActiveSalesLY;
    public static AggregateResult[] MarActiveSalesLY;

    public static AggregateResult[] AprVisitsA1;
    public static AggregateResult[] MayVisitsA1;
    public static AggregateResult[] JunVisitsA1;
    public static AggregateResult[] JulVisitsA1;
    public static AggregateResult[] AugVisitsA1;
    public static AggregateResult[] SepVisitsA1;
    public static AggregateResult[] OctVisitsA1;
    public static AggregateResult[] NOvVisitsA1;
    public static AggregateResult[] DecVisitsA1;
    public static AggregateResult[] JanVisitsA1;
    public static AggregateResult[] FebVisitsA1;
    public static AggregateResult[] MarVisitsA1;

    public static AggregateResult[] AprVisitsA2;
    public static AggregateResult[] MayVisitsA2;
    public static AggregateResult[] JunVisitsA2;
    public static AggregateResult[] JulVisitsA2;
    public static AggregateResult[] AugVisitsA2;
    public static AggregateResult[] SepVisitsA2;
    public static AggregateResult[] OctVisitsA2;
    public static AggregateResult[] NOvVisitsA2;
    public static AggregateResult[] DecVisitsA2;
    public static AggregateResult[] JanVisitsA2;
    public static AggregateResult[] FebVisitsA2;
    public static AggregateResult[] MarVisitsA2;

    public static AggregateResult[] AprVisitsA3;
    public static AggregateResult[] MayVisitsA3;
    public static AggregateResult[] JunVisitsA3;
    public static AggregateResult[] JulVisitsA3;
    public static AggregateResult[] AugVisitsA3;
    public static AggregateResult[] SepVisitsA3;
    public static AggregateResult[] OctVisitsA3;
    public static AggregateResult[] NOvVisitsA3;
    public static AggregateResult[] DecVisitsA3;
    public static AggregateResult[] JanVisitsA3;
    public static AggregateResult[] FebVisitsA3;
    public static AggregateResult[] MarVisitsA3;

    public static AggregateResult[] AprVisitsB1;
    public static AggregateResult[] MayVisitsB1;
    public static AggregateResult[] JunVisitsB1;
    public static AggregateResult[] JulVisitsB1;
    public static AggregateResult[] AugVisitsB1;
    public static AggregateResult[] SepVisitsB1;
    public static AggregateResult[] OctVisitsB1;
    public static AggregateResult[] NOvVisitsB1;
    public static AggregateResult[] DecVisitsB1;
    public static AggregateResult[] JanVisitsB1;
    public static AggregateResult[] FebVisitsB1;
    public static AggregateResult[] MarVisitsB1;

    public static AggregateResult[] AprVisitsB2;
    public static AggregateResult[] MayVisitsB2;
    public static AggregateResult[] JunVisitsB2;
    public static AggregateResult[] JulVisitsB2;
    public static AggregateResult[] AugVisitsB2;
    public static AggregateResult[] SepVisitsB2;
    public static AggregateResult[] OctVisitsB2;
    public static AggregateResult[] NOvVisitsB2;
    public static AggregateResult[] DecVisitsB2;
    public static AggregateResult[] JanVisitsB2;
    public static AggregateResult[] FebVisitsB2;
    public static AggregateResult[] MarVisitsB2;

    public static AggregateResult[] AprVisitsB3;
    public static AggregateResult[] MayVisitsB3;
    public static AggregateResult[] JunVisitsB3;
    public static AggregateResult[] JulVisitsB3;
    public static AggregateResult[] AugVisitsB3;
    public static AggregateResult[] SepVisitsB3;
    public static AggregateResult[] OctVisitsB3;
    public static AggregateResult[] NOvVisitsB3;
    public static AggregateResult[] DecVisitsB3;
    public static AggregateResult[] JanVisitsB3;
    public static AggregateResult[] FebVisitsB3;
    public static AggregateResult[] MarVisitsB3;

    public static AggregateResult[] AprVisitsC1;
    public static AggregateResult[] MayVisitsC1;
    public static AggregateResult[] JunVisitsC1;
    public static AggregateResult[] JulVisitsC1;
    public static AggregateResult[] AugVisitsC1;
    public static AggregateResult[] SepVisitsC1;
    public static AggregateResult[] OctVisitsC1;
    public static AggregateResult[] NOvVisitsC1;
    public static AggregateResult[] DecVisitsC1;
    public static AggregateResult[] JanVisitsC1;
    public static AggregateResult[] FebVisitsC1;
    public static AggregateResult[] MarVisitsC1;

    public static AggregateResult[] AprVisitsC2;
    public static AggregateResult[] MayVisitsC2;
    public static AggregateResult[] JunVisitsC2;
    public static AggregateResult[] JulVisitsC2;
    public static AggregateResult[] AugVisitsC2;
    public static AggregateResult[] SepVisitsC2;
    public static AggregateResult[] OctVisitsC2;
    public static AggregateResult[] NOvVisitsC2;
    public static AggregateResult[] DecVisitsC2;
    public static AggregateResult[] JanVisitsC2;
    public static AggregateResult[] FebVisitsC2;
    public static AggregateResult[] MarVisitsC2;

    public static AggregateResult[] AprVisitsC3;
    public static AggregateResult[] MayVisitsC3;
    public static AggregateResult[] JunVisitsC3;
    public static AggregateResult[] JulVisitsC3;
    public static AggregateResult[] AugVisitsC3;
    public static AggregateResult[] SepVisitsC3;
    public static AggregateResult[] OctVisitsC3;
    public static AggregateResult[] NOvVisitsC3;
    public static AggregateResult[] DecVisitsC3;
    public static AggregateResult[] JanVisitsC3;
    public static AggregateResult[] FebVisitsC3;
    public static AggregateResult[] MarVisitsC3;
    public static AggregateResult[] QVActiveSales;
    public static AggregateResult[] QVActiveSalesLY;
    public static AggregateResult[] QVActiveSalesN2;
    public static AggregateResult[] QVUserSalesFiguredCY;
    public static AggregateResult[] QVUserSalesFiguredLY;

    @AuraEnabled
    public static FisCalYear getFiscalYear(){
        try {
            Integer year = date.today().year();
            Integer month = date.today().month();
            Id RunningUser = UserInfo.getUserId();

            String userCompany = [SELECT CompanyName FROM User WHERE Id=:RunningUser].CompanyName;
            
            if((month < 5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            FisCalYear fiscal = new FisCalYear();
            fiscal.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            fiscal.LastFY = 'FY-'+String.valueOf(year-1).substring(2);

            System.debug('XXX Current Fiscal Year is '+fiscal.CurrFY+' Last Fiscal Year is '+fiscal.LastFY);

            return fiscal;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Salesfigure getUserSalesfigured(Id recordId){
        try {
            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            String userCompany = [SELECT CompanyName FROM User WHERE Id=:recordId].CompanyName;
            System.debug('User Company Name is '+userCompany);

            if((month < 5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            originalConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            userConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            //if(userCurrency != 'EUR'){conversionRate=1;}

            Salesfigure sales = new Salesfigure();
            sales.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            sales.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
            sales.getConversionRate = conversionRate;
            System.debug('Current Fiscal Year : '+sales.CurrFY+' Last Fical Year : '+sales.PrevFY+' Conversion Rate : '+sales.getConversionRate);

            sales.AprVal = 0;
            sales.MayVal = 0;
            sales.JunVal = 0;
            sales.JulVal = 0;
            sales.AugVal = 0;
            sales.SepVal = 0;
            sales.OctVal = 0;
            sales.NovVal = 0;
            sales.DecVal = 0;
            sales.JanVal = 0;
            sales.FebVal = 0;
            sales.MarVal = 0;
            
            sales.AprVol = 0;
            sales.MayVol = 0;
            sales.JunVol = 0;
            sales.JulVol = 0;
            sales.AugVol = 0;
            sales.SepVol = 0;
            sales.OctVol = 0;
            sales.NovVol = 0;
            sales.DecVol = 0;
            sales.JanVol = 0;
            sales.FebVol = 0;
            sales.MarVol = 0;
            
            QVUserSalesFiguredCY = [SELECT sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september,
                                    sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february,
                                    sum(March__c) march, sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty, sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                    sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty, sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                    sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty, sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty
                                    FROM QV_Sales__c WHERE Account__r.OwnerId=:recordId
                                    AND FY__c =: sales.CurrFY];

            for(AggregateResult qcy:QVUserSalesFiguredCY)
            {
                sales.AprVal = sales.AprVal+double.valueOf(qcy.get('april'))*sales.getConversionRate;
                sales.MayVal = sales.MayVal+double.valueOf(qcy.get('may'))*sales.getConversionRate;
                sales.JunVal = sales.JunVal+double.valueOf(qcy.get('june'))*sales.getConversionRate;
                sales.JulVal = sales.JulVal+double.valueOf(qcy.get('july'))*sales.getConversionRate;
                sales.AugVal = sales.AugVal+double.valueOf(qcy.get('august'))*sales.getConversionRate;
                sales.SepVal = sales.SepVal+double.valueOf(qcy.get('september'))*sales.getConversionRate;
                sales.OctVal = sales.OctVal+double.valueOf(qcy.get('october'))*sales.getConversionRate;
                sales.NovVal = sales.NovVal+double.valueOf(qcy.get('november'))*sales.getConversionRate;
                sales.DecVal = sales.DecVal+double.valueOf(qcy.get('december'))*sales.getConversionRate;
                sales.JanVal = sales.JanVal+double.valueOf(qcy.get('january'))*sales.getConversionRate;
                sales.FebVal = sales.FebVal+double.valueOf(qcy.get('february'))*sales.getConversionRate;
                sales.MarVal = sales.MarVal+double.valueOf(qcy.get('march'))*sales.getConversionRate;

                //sales.TotalVal = sales.TotalVal+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                sales.AprVol = sales.AprVol+double.valueOf(qcy.get('apr_qty'));
                sales.MayVol = sales.MayVol+double.valueOf(qcy.get('may_qty'));
                sales.JunVol = sales.JunVol+double.valueOf(qcy.get('jun_qty'));
                sales.JulVol = sales.JulVol+double.valueOf(qcy.get('jul_qty'));
                sales.AugVol = sales.AugVol+double.valueOf(qcy.get('aug_qty'));
                sales.SepVol = sales.SepVol+double.valueOf(qcy.get('sep_qty'));
                sales.OctVol = sales.OctVol+double.valueOf(qcy.get('oct_qty'));
                sales.NovVol = sales.NovVol+double.valueOf(qcy.get('nov_qty'));
                sales.DecVol = sales.DecVol+double.valueOf(qcy.get('dec_qty'));
                sales.JanVol = sales.JanVol+double.valueOf(qcy.get('jan_qty'));
                sales.FebVol = sales.FebVol+double.valueOf(qcy.get('feb_qty'));
                sales.MarVol = sales.MarVol+double.valueOf(qcy.get('mar_qty'));
                //sales.TotalVol = sales.TotalVol+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));
            }

            sales.AprValLY = 0;
            sales.MayValLY = 0;
            sales.JunValLY = 0;
            sales.JulValLY = 0;
            sales.AugValLY = 0;
            sales.SepValLY = 0;
            sales.OctValLY = 0;
            sales.NovValLY = 0;
            sales.DecValLY = 0;
            sales.JanValLY = 0;
            sales.FebValLY = 0;
            sales.MarValLY = 0;

            sales.AprVolLY = 0;
            sales.MayVolLY = 0;
            sales.JunVolLY = 0;
            sales.JulVolLY = 0;
            sales.AugVolLY = 0;
            sales.SepVolLY = 0;
            sales.OctVolLY = 0;
            sales.NovVolLY = 0;
            sales.DecVolLY = 0;
            sales.JanVolLY = 0;
            sales.FebVolLY = 0;
            sales.MarVolLY = 0;

            QVUserSalesFiguredLY = [SELECT sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september,
                                    sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february,
                                    sum(March__c) march, sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty, sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                    sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty, sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                    sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty, sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty
                                    FROM QV_Sales__c WHERE Account__r.OwnerId=:recordId
                                    AND FY__c =: sales.PrevFY];
            
            for(AggregateResult qly:QVUserSalesFiguredLY)
            {
                sales.AprValLY = sales.AprValLY+double.valueOf(qly.get('april'))*sales.getConversionRate;
                sales.MayValLY = sales.MayValLY+double.valueOf(qly.get('may'))*sales.getConversionRate;
                sales.JunValLY = sales.JunValLY+double.valueOf(qly.get('june'))*sales.getConversionRate;
                sales.JulValLY = sales.JulValLY+double.valueOf(qly.get('july'))*sales.getConversionRate;
                sales.AugValLY = sales.AugValLY+double.valueOf(qly.get('august'))*sales.getConversionRate;
                sales.SepValLY = sales.SepValLY+double.valueOf(qly.get('september'))*sales.getConversionRate;
                sales.OctValLY = sales.OctValLY+double.valueOf(qly.get('october'))*sales.getConversionRate;
                sales.NovValLY = sales.NovValLY+double.valueOf(qly.get('november'))*sales.getConversionRate;
                sales.DecValLY = sales.DecValLY+double.valueOf(qly.get('december'))*sales.getConversionRate;
                sales.JanValLY = sales.JanValLY+double.valueOf(qly.get('january'))*sales.getConversionRate;
                sales.FebValLY = sales.FebValLY+double.valueOf(qly.get('february'))*sales.getConversionRate;
                sales.MarValLY = sales.MarValLY+double.valueOf(qly.get('march'))*sales.getConversionRate;
                //sales.TotalValLY = sales.TotalValLY+(double.valueOf(qly.get('April__c'))+double.valueOf(qly.get('May__c'))+double.valueOf(qly.get('June__c'))+double.valueOf(qly.get('July__c'))+double.valueOf(qly.get('August__c'))+double.valueOf(qly.get('September__c'))+double.valueOf(qly.get('October__c'))+double.valueOf(qly.get('November__c'))+double.valueOf(qly.get('December__c'))+double.valueOf(qly.get('January__c'))+double.valueOf(qly.get('February__c'))+double.valueOf(qly.get('March__c')))*conversionRate;

                sales.AprVolLY = sales.AprVolLY+double.valueOf(qly.get('apr_qty'));
                sales.MayVolLY = sales.MayVolLY+double.valueOf(qly.get('may_qty'));
                sales.JunVolLY = sales.JunVolLY+double.valueOf(qly.get('jun_qty'));
                sales.JulVolLY = sales.JulVolLY+double.valueOf(qly.get('jul_qty'));
                sales.AugVolLY = sales.AugVolLY+double.valueOf(qly.get('aug_qty'));
                sales.SepVolLY = sales.SepVolLY+double.valueOf(qly.get('sep_qty'));
                sales.OctVolLY = sales.OctVolLY+double.valueOf(qly.get('oct_qty'));
                sales.NovVolLY = sales.NovVolLY+double.valueOf(qly.get('nov_qty'));
                sales.DecVolLY = sales.DecVolLY+double.valueOf(qly.get('dec_qty'));
                sales.JanVolLY = sales.JanVolLY+double.valueOf(qly.get('jan_qty'));
                sales.FebVolLY = sales.FebVolLY+double.valueOf(qly.get('feb_qty'));
                sales.MarVolLY = sales.MarVolLY+double.valueOf(qly.get('mar_qty'));

                //sales.TotalVolLY = sales.TotalVolLY+(double.valueOf(qly.get('April_qty__c'))+double.valueOf(qly.get('May_qty__c'))+double.valueOf(qly.get('June_qty__c'))+double.valueOf(qly.get('July_qty__c'))+double.valueOf(qly.get('August_qty__c'))+double.valueOf(qly.get('September_qty__c'))+double.valueOf(qly.get('October_qty__c'))+double.valueOf(qly.get('November_qty__c'))+double.valueOf(qly.get('December_qty__c'))+double.valueOf(qly.get('January_qty__c'))+double.valueOf(qly.get('February_qty__c'))+double.valueOf(qly.get('March_qty__c')));
            }
            /*
            sales.AprASP = (sales.AprVol==0) ? sales.AprASP = sales.AprVal/1 : sales.AprVal/sales.AprVol;
            sales.MayASP = (sales.MayVol==0) ? sales.MayASP = sales.MayVal/1 : sales.MayVal/sales.MayVol;
            sales.JunASP = (sales.JunVol==0) ? sales.JunASP = sales.JunVal/1 : sales.JunVal/sales.JunVol;
            sales.JulASP = (sales.JulVol==0) ? sales.JulASP = sales.JulVal/1 : sales.JulVal/sales.JulVol;
            sales.AugASP = (sales.AugVol==0) ? sales.AugASP = sales.AugVal/1 : sales.AugVal/sales.AugVol;
            sales.SepASP = (sales.SepVol==0) ? sales.SepASP = sales.SepVal/1 : sales.SepVal/sales.SepVol;
            sales.OctASP = (sales.OctVol==0) ? sales.OctASP = sales.OctVal/1 : sales.OctVal/sales.OctVol;
            sales.NovASP = (sales.NovVol==0) ? sales.NovASP = sales.NovVal/1 : sales.NovVal/sales.NovVol;
            sales.DecASP = (sales.DecVol==0) ? sales.DecASP = sales.DecVal/1 : sales.DecVal/sales.DecVol;
            sales.JanASP = (sales.JanVol==0) ? sales.JanASP = sales.JanVal/1 : sales.JanVal/sales.JanVol;
            sales.FebASP = (sales.FebVol==0) ? sales.FebASP = sales.FebVal/1 : sales.FebVal/sales.FebVol;
            sales.MarASP = (sales.MarVol==0) ? sales.MarASP = sales.MarVal/1 : sales.MarVal/sales.MarVol;
            sales.TotalASP = (sales.TotalVol==0) ? sales.TotalASP = sales.TotalVal/1 : sales.TotalVal/sales.TotalVol;

            sales.AprASPLY = (sales.AprVolLY==0) ? sales.AprASPLY = sales.AprValLY/1 : sales.AprValLY/sales.AprVolLY;
            sales.MayASPLY = (sales.MayVolLY==0) ? sales.MayASPLY = sales.MayValLY/1 : sales.MayValLY/sales.MayVolLY;
            sales.JunASPLY = (sales.JunVolLY==0) ? sales.JunASPLY = sales.JunValLY/1 : sales.JunValLY/sales.JunVolLY;
            sales.JulASPLY = (sales.JulVolLY==0) ? sales.JulASPLY = sales.JulValLY/1 : sales.JulValLY/sales.JulVolLY;
            sales.AugASPLY = (sales.AugVolLY==0) ? sales.AugASPLY = sales.AugValLY/1 : sales.AugValLY/sales.AugVolLY;
            sales.SepASPLY = (sales.SepVolLY==0) ? sales.SepASPLY = sales.SepValLY/1 : sales.SepValLY/sales.SepVolLY;
            sales.OctASPLY = (sales.OctVolLY==0) ? sales.OctASPLY = sales.OctValLY/1 : sales.OctValLY/sales.OctVolLY;
            sales.NovASPLY = (sales.NovVolLY==0) ? sales.NovASPLY = sales.NovValLY/1 : sales.NovValLY/sales.NovVolLY;
            sales.DecASPLY = (sales.DecVolLY==0) ? sales.DecASPLY = sales.DecValLY/1 : sales.DecValLY/sales.DecVolLY;
            sales.JanASPLY = (sales.JanVolLY==0) ? sales.JanASPLY = sales.JanValLY/1 : sales.JanValLY/sales.JanVolLY;
            sales.FebASPLY = (sales.FebVolLY==0) ? sales.FebASPLY = sales.FebValLY/1 : sales.FebValLY/sales.FebVolLY;
            sales.MarASPLY = (sales.MarVolLY==0) ? sales.MarASPLY = sales.MarValLY/1 : sales.MarValLY/sales.MarVolLY;
            sales.TotalASPLY = (sales.TotalVolLY==0) ? sales.TotalASPLY = sales.TotalValLY/1 : sales.TotalValLY/sales.TotalVolLY;
            */
            System.debug('XXX Get Sales Figures data == > '+sales);
            return sales;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<StockRx> getRxStockbyOwnerId(Id recordId){
        try {
            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            String userCompany = [SELECT CompanyName FROM User WHERE Id=:recordId].CompanyName;
            if((month < 5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }
            conversionRate = [SELECT conversionrate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionrate;
            StockRx sales = new StockRx();
            sales.CurrFY = 'FY-'+string.valueOf(year).substring(2);
            sales.PrevFY = 'FY-'+string.valueOf(year-1).substring(2);
            sales.ConversionRate = conversionRate;
            System.debug('XXX Get Conversion Rate : '+sales.ConversionRate);
            System.debug('XXX Get Current FY : '+sales.CurrFY+' Last FY : '+sales.PrevFY);

            List<StockRx> dataList = new List<StockRx>();
            Map<String, StockRx> dataMap = new Map<String, StockRx>();

            List<AggregateResult> LastFY = [select rx_or_stock__c, sum(april__c) april, 
                                            sum(may__c) may, sum(june__c) june, sum(july__c) july, 
                                            sum(august__c) august, sum(september__c) september, 
                                            sum(october__c) october, sum(november__c) november, 
                                            sum(december__c) december, sum(january__c) january, 
                                            sum(february__c) february, sum(march__c) march,
                                            sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty,
                                            sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                            sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                            sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                            sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty,
                                            sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty 
                                            from qv_sales__c 
                                            where account__r.ownerid=:recordId 
                                            and fy__c=:sales.PrevFY 
                                            and rx_or_stock__c in ('ST','RX', 'Stock', 'RXs', 'STOCK', 'Stocks') 
                                            group by rx_or_stock__c order by rx_or_stock__c desc];
            for(AggregateResult ar:LastFY){
                String Stock_or_Rx = (String)ar.get('rx_or_stock__c');
                if(dataMap.get(Stock_or_Rx)==null){
                    dataMap.put(Stock_or_Rx, new StockRx());
                    dataMap.get(Stock_or_Rx).Stock_or_Rx = (String)ar.get('rx_or_stock__c');
                }
                dataMap.get(Stock_or_Rx).AprValLY = (Double)ar.get('april')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).MayValLY = (Double)ar.get('may')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JunValLY = (Double)ar.get('june')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JulValLY = (Double)ar.get('july')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).AugValLY = (Double)ar.get('august')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).SepValLY = (Double)ar.get('september')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).OctValLY = (Double)ar.get('october')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).NovValLY = (Double)ar.get('november')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).DecValLY = (Double)ar.get('december')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JanValLY = (Double)ar.get('january')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).FebValLY = (Double)ar.get('february')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).MarValLY = (Double)ar.get('march')*sales.ConversionRate;

                dataMap.get(Stock_or_Rx).AprVolLY = (Double)ar.get('apr_qty');
                dataMap.get(Stock_or_Rx).MayVolLY = (Double)ar.get('may_qty');
                dataMap.get(Stock_or_Rx).JunVolLY = (Double)ar.get('jun_qty');
                dataMap.get(Stock_or_Rx).JulVolLY = (Double)ar.get('jul_qty');
                dataMap.get(Stock_or_Rx).AugVolLY = (Double)ar.get('aug_qty');
                dataMap.get(Stock_or_Rx).SepVolLY = (Double)ar.get('sep_qty');
                dataMap.get(Stock_or_Rx).OctVolLY = (Double)ar.get('oct_qty');
                dataMap.get(Stock_or_Rx).NovVolLY = (Double)ar.get('nov_qty');
                dataMap.get(Stock_or_Rx).DecVolLY = (Double)ar.get('dec_qty');
                dataMap.get(Stock_or_Rx).JanVolLY = (Double)ar.get('jan_qty');
                dataMap.get(Stock_or_Rx).FebVolLY = (Double)ar.get('feb_qty');
                dataMap.get(Stock_or_Rx).MarVolLY = (Double)ar.get('mar_qty');
            }

            List<AggregateResult> CurrFY = [select rx_or_stock__c, sum(april__c) april, 
                                            sum(may__c) may, sum(june__c) june, sum(july__c) july, 
                                            sum(august__c) august, sum(september__c) september, 
                                            sum(october__c) october, sum(november__c) november, 
                                            sum(december__c) december, sum(january__c) january, 
                                            sum(february__c) february, sum(march__c) march,
                                            sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty,
                                            sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                            sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                            sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                            sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty,
                                            sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty 
                                            from qv_sales__c 
                                            where account__r.ownerid=:recordId 
                                            and fy__c=:sales.CurrFY 
                                            and rx_or_stock__c in ('ST','RX', 'Stock', 'RXs', 'STOCK', 'Stocks') 
                                            group by rx_or_stock__c order by rx_or_stock__c desc];
            for(AggregateResult ar:CurrFY){
                String Stock_or_Rx = (String)ar.get('rx_or_stock__c');
                if(dataMap.get(Stock_or_Rx).Stock_or_Rx==null){
                    dataMap.put(Stock_or_Rx, new StockRx());
                    dataMap.get(Stock_or_Rx).Stock_or_Rx = (String)ar.get('rx_or_stock__c');
                }
                dataMap.get(Stock_or_Rx).AprVal = (Double)ar.get('april')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).MayVal = (Double)ar.get('may')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JunVal = (Double)ar.get('june')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JulVal = (Double)ar.get('july')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).AugVal = (Double)ar.get('august')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).SepVal = (Double)ar.get('september')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).OctVal = (Double)ar.get('october')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).NovVal = (Double)ar.get('november')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).DecVal = (Double)ar.get('december')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).JanVal = (Double)ar.get('january')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).FebVal = (Double)ar.get('february')*sales.ConversionRate;
                dataMap.get(Stock_or_Rx).MarVal = (Double)ar.get('march')*sales.ConversionRate;

                dataMap.get(Stock_or_Rx).AprVol = (Double)ar.get('apr_qty');
                dataMap.get(Stock_or_Rx).MayVol = (Double)ar.get('may_qty');
                dataMap.get(Stock_or_Rx).JunVol = (Double)ar.get('jun_qty');
                dataMap.get(Stock_or_Rx).JulVol = (Double)ar.get('jul_qty');
                dataMap.get(Stock_or_Rx).AugVol = (Double)ar.get('aug_qty');
                dataMap.get(Stock_or_Rx).SepVol = (Double)ar.get('sep_qty');
                dataMap.get(Stock_or_Rx).OctVol = (Double)ar.get('oct_qty');
                dataMap.get(Stock_or_Rx).NovVol = (Double)ar.get('nov_qty');
                dataMap.get(Stock_or_Rx).DecVol = (Double)ar.get('dec_qty');
                dataMap.get(Stock_or_Rx).JanVol = (Double)ar.get('jan_qty');
                dataMap.get(Stock_or_Rx).FebVol = (Double)ar.get('feb_qty');
                dataMap.get(Stock_or_Rx).MarVol = (Double)ar.get('mar_qty');
            }

            for(StockRx s : dataMap.values()){
                s.ValLastFY = s.AprValLY+s.MayValLY+s.JunValLY+s.JulValLY+s.AugValLY+s.SepValLY+s.OctValLY+s.NovValLY+s.DecValLY+s.JanValLY+s.FebValLY+s.MarValLY;
                s.VolLastFY = s.AprVolLY+s.MayVolLY+s.JunVolLY+s.JulVolLY+s.AugVolLY+s.SepVolLY+s.OctVolLY+s.NovVolLY+s.DecVolLY+s.JanVolLY+s.FebVolLY+s.MarVolLY;
                s.ValLast12MthRolling = getLastRollingValStockRx(s, month);
                s.VolLast12MthRolling = getLastRollingVolStockRx(s, month);
                dataList.add(s);
            }

            System.debug('XXX Get Stock/Rx dataList == > '+dataList.size()+' record(s) : '+dataList);
            return dataList;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static double getLastRollingValStockRx(StockRx a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY;}
                when 2 {result = a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY;}
                when 3 {result = a.FebVal+a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY;}
                when 4 {result = a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY+a.AprValLY;}
                when 5 {result = a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY;}
                when 6 {result = a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY;}
                when 7 {result = a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY;}
                when 8 {result = a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY;}
                when 9 {result = a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY;}
                when 10 {result = a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY;}
                when 11 {result = a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY;}
                when 12 {result = a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY;}
                when else{result = 0;}
            }
            
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    public static double getLastRollingVolStockRx(StockRx a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY;}
                when 2 {result = a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY;}
                when 3 {result = a.FebVol+a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY;}
                when 4 {result = a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY+a.AprVolLY;}
                when 5 {result = a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY;}
                when 6 {result = a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY;}
                when 7 {result = a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY;}
                when 8 {result = a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY;}
                when 9 {result = a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY;}
                when 10 {result = a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY;}
                when 11 {result = a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY;}
                when 12 {result = a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY;}
                when else {result = 0;}
            }
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    @AuraEnabled
    public static List<LensDesign> getLensDesignByOwner(Id recordId){
        try {
            Integer month = date.today().month();
            Integer year = date.today().year();
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            String userCompany = [SELECT companyName FROM User WHERE Id=:recordId].CompanyName;

            if((month < 5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            LensDesign sales = new LensDesign();
            sales.PrevFY = 'FY-'+string.valueOf(year-1).substring(2);
            sales.CurrFY = 'FY-'+string.valueOf(year).substring(2);
            sales.getConversionRate = conversionRate;

            System.debug('XXX Get Conversion Rate : '+sales.getConversionRate);
            System.debug('XXX Get Prev Year | Current Year : '+sales.PrevFY+' | '+sales.CurrFY);

            List<LensDesign> dataList = new List<LensDesign>();
            Map<String, LensDesign> dataMap = new Map<String, LensDesign>();
            
            List<AggregateResult> LastFY = [select generic_design__c, sum(april__c) april, 
                                                sum(may__c) may, sum(june__c) june, sum(july__c) july, 
                                                sum(august__c) august, sum(september__c) september, 
                                                sum(october__c) october, sum(november__c) november, 
                                                sum(december__c) december, sum(january__c) january, 
                                                sum(february__c) february, sum(march__c) march,
                                                sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty,
                                                sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                                sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                                sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                                sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty,
                                                sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c=:sales.PrevFY 
                                                and generic_design__c in ('SV','PAL','BF') 
                                                group by generic_design__c 
                                                order by generic_design__c desc];
        for(AggregateResult ar : LastFY){
            String GenericDesign = (String)ar.get('generic_design__c');
            if(dataMap.get(GenericDesign)==null){
                dataMap.put(GenericDesign, new LensDesign());
                dataMap.get(GenericDesign).GenericDesign = (String)ar.get('generic_design__c');
            }
            dataMap.get(GenericDesign).AprValLY = (Double)ar.get('april')*sales.getConversionRate;
            dataMap.get(GenericDesign).MayValLY = (Double)ar.get('may')*sales.getConversionRate;
            dataMap.get(GenericDesign).JunValLY = (Double)ar.get('june')*sales.getConversionRate;
            dataMap.get(GenericDesign).JulValLY = (Double)ar.get('july')*sales.getConversionRate;
            dataMap.get(GenericDesign).AugValLY = (Double)ar.get('august')*sales.getConversionRate;
            dataMap.get(GenericDesign).SepValLY = (Double)ar.get('september')*sales.getConversionRate;
            dataMap.get(GenericDesign).OctValLY = (Double)ar.get('october')*sales.getConversionRate;
            dataMap.get(GenericDesign).NovValLY = (Double)ar.get('november')*sales.getConversionRate;
            dataMap.get(GenericDesign).DecValLY = (Double)ar.get('december')*sales.getConversionRate;
            dataMap.get(GenericDesign).JanValLY = (Double)ar.get('january')*sales.getConversionRate;
            dataMap.get(GenericDesign).FebValLY = (Double)ar.get('february')*sales.getConversionRate;
            dataMap.get(GenericDesign).MarValLY = (Double)ar.get('march')*sales.getConversionRate;

            dataMap.get(GenericDesign).AprVolLY = (Double)ar.get('apr_qty');
            dataMap.get(GenericDesign).MayVolLY = (Double)ar.get('may_qty');
            dataMap.get(GenericDesign).JunVolLY = (Double)ar.get('jun_qty');
            dataMap.get(GenericDesign).JulVolLY = (Double)ar.get('jul_qty');
            dataMap.get(GenericDesign).AugVolLY = (Double)ar.get('aug_qty');
            dataMap.get(GenericDesign).SepVolLY = (Double)ar.get('sep_qty');
            dataMap.get(GenericDesign).OctVolLY = (Double)ar.get('oct_qty');
            dataMap.get(GenericDesign).NovVolLY = (Double)ar.get('nov_qty');
            dataMap.get(GenericDesign).DecVolLY = (Double)ar.get('dec_qty');
            dataMap.get(GenericDesign).JanVolLY = (Double)ar.get('jan_qty');
            dataMap.get(GenericDesign).FebVolLY = (Double)ar.get('feb_qty');
            dataMap.get(GenericDesign).MarVolLY = (Double)ar.get('mar_qty');

        }

        List<AggregateResult> CurrentFY = [select generic_design__c, sum(april__c) april, 
                                            sum(may__c) may, sum(june__c) june, sum(july__c) july, 
                                            sum(august__c) august, sum(september__c) september, 
                                            sum(october__c) october, sum(november__c) november, 
                                            sum(december__c) december, sum(january__c) january, 
                                            sum(february__c) february, sum(march__c) march,
                                            sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty,
                                            sum(June_qty__c) jun_qty, sum(July_qty__c) jul_qty,
                                            sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                            sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty,
                                            sum(December_qty__c) dec_qty, sum(January_qty__c) jan_qty,
                                            sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty 
                                            from qv_sales__c 
                                            where account__r.ownerid=:recordId
                                            and fy__c=:sales.CurrFY 
                                            and generic_design__c in ('SV','PAL','BF') 
                                            group by generic_design__c 
                                            order by generic_design__c desc];
        
            for(AggregateResult ar:CurrentFY){
                String GenericDesign = (String)ar.get('generic_design__c');
                if(dataMap.get(GenericDesign)==null){
                    dataMap.put(GenericDesign, new LensDesign());
                    dataMap.get(GenericDesign).GenericDesign = (String)ar.get('generic_design__c');
                }

                dataMap.get(GenericDesign).AprVal = (Double)ar.get('april')*sales.getConversionRate;
                dataMap.get(GenericDesign).MayVal = (Double)ar.get('may')*sales.getConversionRate;
                dataMap.get(GenericDesign).JunVal = (Double)ar.get('june')*sales.getConversionRate;
                dataMap.get(GenericDesign).JulVal = (Double)ar.get('july')*sales.getConversionRate;
                dataMap.get(GenericDesign).AugVal = (Double)ar.get('august')*sales.getConversionRate;
                dataMap.get(GenericDesign).SepVal = (Double)ar.get('september')*sales.getConversionRate;
                dataMap.get(GenericDesign).OctVal = (Double)ar.get('october')*sales.getConversionRate;
                dataMap.get(GenericDesign).NovVal = (Double)ar.get('november')*sales.getConversionRate;
                dataMap.get(GenericDesign).DecVal = (Double)ar.get('december')*sales.getConversionRate;
                dataMap.get(GenericDesign).JanVal = (Double)ar.get('january')*sales.getConversionRate;
                dataMap.get(GenericDesign).FebVal = (Double)ar.get('february')*sales.getConversionRate;
                dataMap.get(GenericDesign).MarVal = (Double)ar.get('march')*sales.getConversionRate;

                dataMap.get(GenericDesign).AprVol = (Double)ar.get('apr_qty');
                dataMap.get(GenericDesign).MayVol = (Double)ar.get('may_qty');
                dataMap.get(GenericDesign).JunVol = (Double)ar.get('jun_qty');
                dataMap.get(GenericDesign).JulVol = (Double)ar.get('jul_qty');
                dataMap.get(GenericDesign).AugVol = (Double)ar.get('aug_qty');
                dataMap.get(GenericDesign).SepVol = (Double)ar.get('sep_qty');
                dataMap.get(GenericDesign).OctVol = (Double)ar.get('oct_qty');
                dataMap.get(GenericDesign).NovVol = (Double)ar.get('nov_qty');
                dataMap.get(GenericDesign).DecVol = (Double)ar.get('dec_qty');
                dataMap.get(GenericDesign).JanVol = (Double)ar.get('jan_qty');
                dataMap.get(GenericDesign).FebVol = (Double)ar.get('feb_qty');
                dataMap.get(GenericDesign).MarVol = (Double)ar.get('mar_qty');
            }

            for(LensDesign a : dataMap.values()){
                a.LastFYVal = a.AprValLY+a.MayValLY+a.JunValLY+a.JulValLY+a.AugValLY+a.SepValLY+a.OctValLY+a.NovValLY+a.DecValLY+a.JanValLY+a.FebValLY+a.MarValLY;
                a.LastFYVol = a.AprVolLY+a.MayVolLY+a.JunVolLY+a.JulVolLY+a.AugVolLY+a.SepVolLY+a.OctVolLY+a.NovVolLY+a.DecVolLY+a.JanVolLY+a.FebVolLY+a.MarVolLY;
                a.Last12MthsVal = getLastRollingValGenDesign(a, month);
                a.Last12MthsVol = getLastRollingVolGenDesign(a, month);
                
                dataList.add(a);
            }
            System.debug('XXX Get Data == > record(s) : '+dataList.size()+' : '+dataList);
            return dataList;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static double getLastRollingValGenDesign(LensDesign a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY;}
                when 2 {result = a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY;}
                when 3 {result = a.FebVal+a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY;}
                when 4 {result = a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY+a.AprValLY;}
                when 5 {result = a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY;}
                when 6 {result = a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY;}
                when 7 {result = a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY;}
                when 8 {result = a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY;}
                when 9 {result = a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY;}
                when 10 {result = a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY;}
                when 11 {result = a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY;}
                when 12 {result = a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY;}
                when else{result = 0;}
            }
            
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    public static double getLastRollingVolGenDesign(LensDesign a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY;}
                when 2 {result = a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY;}
                when 3 {result = a.FebVol+a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY;}
                when 4 {result = a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY+a.AprVolLY;}
                when 5 {result = a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY;}
                when 6 {result = a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY;}
                when 7 {result = a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY;}
                when 8 {result = a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY;}
                when 9 {result = a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY;}
                when 10 {result = a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY;}
                when 11 {result = a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY;}
                when 12 {result = a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY;}
                when else {result = 0;}
            }
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    @AuraEnabled
    public static UserQVSalesByTargetList getUserQVSalesByTargetList(Id recordId){
        try {
            
            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            String userCompany = [select CompanyName from User where Id=:recordId].CompanyName;

            if((month < 5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            originalConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            userConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            //if(userCurrency != 'EUR'){conversionRate=1;}

            UserQVSalesByTargetList sales = new UserQVSalesByTargetList();

            sales.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            sales.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
            sales.N2FY = 'FY-'+String.valueOf(year-2).substring(2);

            System.debug('Current Fiscal Year : '+sales.CurrFY+' Last Fiscal Year : '+sales.PrevFY+' Last N2 FY : '+sales.N2FY);

            sales.AprVal = 0;
            sales.MayVal = 0;
            sales.JunVal = 0;
            sales.JulVal = 0;
            sales.AugVal = 0;
            sales.SepVal = 0;
            sales.OctVal = 0;
            sales.NovVal = 0;
            sales.DecVal = 0;
            sales.JanVal = 0;
            sales.FebVal = 0;
            sales.MarVal = 0;

            sales.AprVol = 0;
            sales.MayVol = 0;
            sales.JunVol = 0;
            sales.JulVol = 0;
            sales.AugVol = 0;
            sales.SepVol = 0;
            sales.OctVol = 0;
            sales.NovVol = 0;
            sales.DecVol = 0;
            sales.JanVol = 0;
            sales.FebVol = 0;
            sales.MarVol = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE Account__r.OwnerId=:recordId AND 
                                    Account__r.Target_List__c=true AND FY__c=:sales.CurrFY])
            {
                sales.AprVal = sales.AprVal+double.valueOf(qcy.get('April__c'))*conversionRate;
                sales.MayVal = sales.MayVal+double.valueOf(qcy.get('May__c'))*conversionRate;
                sales.JunVal = sales.JunVal+double.valueOf(qcy.get('June__c'))*conversionRate;
                sales.JulVal = sales.JulVal+double.valueOf(qcy.get('July__c'))*conversionRate;
                sales.AugVal = sales.AugVal+double.valueOf(qcy.get('August__c'))*conversionRate;
                sales.SepVal = sales.SepVal+double.valueOf(qcy.get('September__c'))*conversionRate;
                sales.OctVal = sales.OctVal+double.valueOf(qcy.get('October__c'))*conversionRate;
                sales.NovVal = sales.NovVal+double.valueOf(qcy.get('November__c'))*conversionRate;
                sales.DecVal = sales.DecVal+double.valueOf(qcy.get('December__c'))*conversionRate;
                sales.JanVal = sales.JanVal+double.valueOf(qcy.get('January__c'))*conversionRate;
                sales.FebVal = sales.FebVal+double.valueOf(qcy.get('February__c'))*conversionRate;
                sales.MarVal = sales.MarVal+double.valueOf(qcy.get('March__c'))*conversionRate;

                sales.AprVol = sales.AprVol+double.valueOf(qcy.get('April_qty__c'));
                sales.MayVol = sales.MayVol+double.valueOf(qcy.get('May_qty__c'));
                sales.JunVol = sales.JunVol+double.valueOf(qcy.get('June_qty__c'));
                sales.JulVol = sales.JulVol+double.valueOf(qcy.get('July_qty__c'));
                sales.AugVol = sales.AugVol+double.valueOf(qcy.get('August_qty__c'));
                sales.SepVol = sales.SepVol+double.valueOf(qcy.get('September_qty__c'));
                sales.OctVol = sales.OctVol+double.valueOf(qcy.get('October_qty__c'));
                sales.NovVol = sales.NovVol+double.valueOf(qcy.get('November_qty__c'));
                sales.DecVol = sales.DecVol+double.valueOf(qcy.get('December_qty__c'));
                sales.JanVol = sales.JanVol+double.valueOf(qcy.get('January_qty__c'));
                sales.FebVol = sales.FebVol+double.valueOf(qcy.get('February_qty__c'));
                sales.MarVol = sales.MarVol+double.valueOf(qcy.get('March_qty__c'));

            }

            sales.AprValLY = 0;
            sales.MayValLY = 0;
            sales.JunValLY = 0;
            sales.JulValLY = 0;
            sales.AugValLY = 0;
            sales.SepValLY = 0;
            sales.OctValLY = 0;
            sales.NovValLY = 0;
            sales.DecValLY = 0;
            sales.JanValLY = 0;
            sales.FebValLY = 0;
            sales.MarValLY = 0;
            
            sales.AprVolLY = 0;
            sales.MayVolLY = 0;
            sales.JunVolLY = 0;
            sales.JulVolLY = 0;
            sales.AugVolLY = 0;
            sales.SepVolLY = 0;
            sales.OctVolLY = 0;
            sales.NovVolLY = 0;
            sales.DecVolLY = 0;
            sales.JanVolLY = 0;
            sales.FebVolLY = 0;
            sales.MarVolLY = 0;

            for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE Account__r.OwnerId=:recordId AND 
                                    Account__r.Target_List__c=true AND FY__c=:sales.PrevFY])
            {
                sales.AprValLY = sales.AprValLY+double.valueOf(qly.get('April__c'))*conversionRate;
                sales.MayValLY = sales.MayValLY+double.valueOf(qly.get('May__c'))*conversionRate;
                sales.JunValLY = sales.JunValLY+double.valueOf(qly.get('June__c'))*conversionRate;
                sales.JulValLY = sales.JulValLY+double.valueOf(qly.get('July__c'))*conversionRate;
                sales.AugValLY = sales.AugValLY+double.valueOf(qly.get('August__c'))*conversionRate;
                sales.SepValLY = sales.SepValLY+double.valueOf(qly.get('September__c'))*conversionRate;
                sales.OctValLY = sales.OctValLY+double.valueOf(qly.get('October__c'))*conversionRate;
                sales.NovValLY = sales.NovValLY+double.valueOf(qly.get('November__c'))*conversionRate;
                sales.DecValLY = sales.DecValLY+double.valueOf(qly.get('December__c'))*conversionRate;
                sales.JanValLY = sales.JanValLY+double.valueOf(qly.get('January__c'))*conversionRate;
                sales.FebValLY = sales.FebValLY+double.valueOf(qly.get('February__c'))*conversionRate;
                sales.MarValLY = sales.MarValLY+double.valueOf(qly.get('March__c'))*conversionRate;

                sales.AprVolLY = sales.AprVolLY+double.valueOf(qly.get('April_qty__c'));
                sales.MayVolLY = sales.MayVolLY+double.valueOf(qly.get('May_qty__c'));
                sales.JunVolLY = sales.JunVolLY+double.valueOf(qly.get('June_qty__c'));
                sales.JulVolLY = sales.JulVolLY+double.valueOf(qly.get('July_qty__c'));
                sales.AugVolLY = sales.AugVolLY+double.valueOf(qly.get('August_qty__c'));
                sales.SepVolLY = sales.SepVolLY+double.valueOf(qly.get('September_qty__c'));
                sales.OctVolLY = sales.OctVolLY+double.valueOf(qly.get('October_qty__c'));
                sales.NovVolLY = sales.NovVolLY+double.valueOf(qly.get('November_qty__c'));
                sales.DecVolLY = sales.DecVolLY+double.valueOf(qly.get('December_qty__c'));
                sales.JanVolLY = sales.JanVolLY+double.valueOf(qly.get('January_qty__c'));
                sales.FebVolLY = sales.FebVolLY+double.valueOf(qly.get('February_qty__c'));
                sales.MarVolLY = sales.MarVolLY+double.valueOf(qly.get('March_qty__c'));

            }

            sales.MarValLYN2 = 0;
            sales.MarVolLYN2 = 0;

            for(QV_Sales__c qn2 : [SELECT March__c, March_qty__c FROM QV_Sales__c
                                    WHERE Account__r.OwnerId=:recordId AND Account__r.Target_List__c=true
                                    AND FY__c=:sales.N2FY])
            {
                sales.MarValLYN2 = sales.MarValLYN2+double.valueOf(qn2.get('March__c'))*conversionRate;
                sales.MarVolLYN2 = sales.MarVolLYN2+double.valueOf(qn2.get('March_qty__c'));
            }

            sales.LastMonthLabel = sales.CurrFY+' '+getLastMthLabel(month);
            System.debug('XXX Get Last Month by Target List == >'+sales.LastMonthLabel);

            sales.LastMonthLabelLY = sales.PrevFY+' '+getLastMthLabel(month);
            System.debug('XXX Get Last Month by Target List LFY == > '+sales.LastMonthLabelLY);

            sales.LastMonthVal = getLastMonthValByTargetList(sales, month);
            System.debug('XXX Get Last Month Sales FY by Target List == > '+sales.LastMonthVal);

            sales.LastMonthVol = getLastMonthVolByTargetList(sales, month);
            System.debug('XXX Get Last Month Volumn FY by Target List == >'+sales.LastMonthVol);

            sales.LastMonthValLY = getLastMonthValByTargetListLY(sales, month);
            System.debug('XXX Get Last Month Sales LFY by target list == >'+sales.LastMonthValLY);

            sales.LastMonthVolLY = getLastMonthVolByTargetListLY(sales, month);
            System.debug('XXX Get Last Month Volumn LFY by target list == >'+sales.LastMonthVolLY);

            System.debug('XXX Get data for Sales FY VS Sales LFY by target customer == >'+sales);
            return sales;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**========= Start Class for Active Door More Than $1 USD ==========*****/
    @AuraEnabled
    public static ActiveDoorSales getActiveDoorSales(Id recordId){
        try {
            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = UserInfo.getDefaultCurrency();
            String OriginalUserCurrency = [select DefaultCurrencyIsoCode from User where Id=:recordId].DefaultCurrencyIsoCode;
            System.debug('XXX User Currency Type from User Record Id == >'+OriginalUserCurrency);
            //Get data for user currency type iso code from user recordId
            String userCompany = [select CompanyName from User where Id=:recordId].CompanyName;

            if((month < 5 && !Toolbox.isApac(userCompany)) || (month < 4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            originalConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            userConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:OriginalUserCurrency].conversionRate;
            System.debug('XXX Get user conversion rate == > '+userConversionRate+' from EUR to Locale Currency');
            conversionRateUSD = [SELECT conversionRate FROM CurrencyType WHERE IsoCode='USD'].conversionRate;
            System.debug('XXX USD Currency Rate == > '+conversionRateUSD);

            //if(userCurrency!='EUR'){conversionRate=1;}

            Double convertToUSD = userConversionRate*conversionRateUSD;
            System.debug('XXX User Conversion Rate '+OriginalUserCurrency+' to USD Currency == >'+convertToUSD);

            Double SegmentValue = 1.0;  //value for USD Active account and value criteria upon in locale currency
            
            Double ActiveSegment = convertToUSD*SegmentValue;
            System.debug('XXX Get convert from '+OriginalUserCurrency+' to active segment == >'+ActiveSegment);

            ActiveDoorSales active = new ActiveDoorSales();
            active.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            active.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
            active.NextFY = 'FY-'+String.valueOf(year+1).substring(2);

            active.AprActiveSales = 0;
            AprActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) AprCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(April__c) >:ActiveSegment];
            
            for(AggregateResult ar:AprActiveSales){
                active.AprActiveSales = active.AprActiveSales+double.valueOf(ar.get('AprCNT'));
                System.debug('Get active account Apr : more than $1 == >'+active.AprActiveSales);
            }

            active.MayActiveSales = 0;
            MayActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) MayCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(May__c) >:ActiveSegment];
            
            for(AggregateResult ar:MayActiveSales){
                active.MayActiveSales = active.MayActiveSales+double.valueOf(ar.get('MayCNT'));
                System.debug('Get active account May : more than $1 == > '+active.MayActiveSales);
            }

            active.JunActiveSales = 0;
            JunActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JunCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(June__c) >:ActiveSegment];
            for(AggregateResult ar:JunActiveSales){
                active.JunActiveSales = active.JunActiveSales+double.valueOf(ar.get('JunCNT'));
                System.debug('Get active account June : more than $1 == > '+active.JunActiveSales);
            }

            active.JulActiveSales = 0;
            JulActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JulCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(July__c) >:ActiveSegment];
            for(AggregateResult ar:JulActiveSales){
                active.JulActiveSales = active.JulActiveSales+double.valueOf(ar.get('JulCNT'));
                System.debug('Get active account July : more than $1 == > '+active.JulActiveSales);
            }

            active.AugActiveSales = 0;
            AugActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) AugCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(August__c) >:ActiveSegment];
            for(AggregateResult ar:AugActiveSales){
                active.AugActiveSales = active.AugActiveSales+double.valueOf(ar.get('AugCNT'));
                System.debug('Get active account August : more than $1 == > '+active.AugActiveSales);
            }

            active.SepActiveSales = 0;
            SepActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) SepCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(September__c) >:ActiveSegment];
            for(AggregateResult ar:SepActiveSales){
                active.SepActiveSales = active.SepActiveSales+double.valueOf(ar.get('SepCNT'));
                System.debug('Get active account September : more than $1 == > '+active.SepActiveSales);
            }

            active.OctActiveSales = 0;
            OctActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) OctCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(October__c) >:ActiveSegment];
            for(AggregateResult ar:OctActiveSales){
                active.OctActiveSales = active.OctActiveSales+double.valueOf(ar.get('OctCNT'));
                System.debug('Get active account October : more than $1 == > '+active.OctActiveSales);

            }

            active.NovActiveSales = 0;
            NovActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) NovCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(November__c) >:ActiveSegment];
            for(AggregateResult ar:NovActiveSales){
                active.NovActiveSales = active.NovActiveSales+double.valueOf(ar.get('NovCNT'));
                System.debug('Get active account November : more than $1 == > '+active.NovActiveSales);
            }

            active.DecActiveSales = 0;
            DecActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) DecCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(December__c) >:ActiveSegment];
            for(AggregateResult ar:DecActiveSales){
                active.DecActiveSales = active.DecActiveSales+double.valueOf(ar.get('DecCNT'));
                System.debug('Get active account December : more than $1 == > '+active.DecActiveSales);
            }

            active.JanActiveSales = 0;
            JanActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JanCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(January__c) >:ActiveSegment];
            for(AggregateResult ar:JanActiveSales){
                active.JanActiveSales = active.JanActiveSales+double.valueOf(ar.get('JanCNT'));
                System.debug('Get active account January : more than $1 == >'+active.JanActiveSales);
            }

            active.FebActiveSales = 0;
            FebActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JanCNT
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(February__c) >:ActiveSegment];
            for(AggregateResult ar:FebActiveSales){
                active.FebActiveSales = active.FebActiveSales+double.valueOf(ar.get('JanCNT'));
                System.debug('Get active account February : more than $1 == > '+active.FebActiveSales);
            }

            active.MarActiveSales = 0;
            MarActiveSales = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) MarCNT 
                                FROM qv_sales__c WHERE fy__c=:active.CurrFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(March__c) >:ActiveSegment];
            for(AggregateResult ar:MarActiveSales){
                active.MarActiveSales = active.MarActiveSales+double.valueOf(ar.get('MarCNT'));
                System.debug('Get active account March : more than $! == > '+active.MarActiveSales);
            }
            /**ACTIVE SALES LAST FISCAL YEAR **************** */

            active.AprActiveSalesLY = 0;
            AprActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) AprCNTLY
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(April__c) >:ActiveSegment];
            for(AggregateResult ar:AprActiveSalesLY){
                active.AprActiveSalesLY = active.AprActiveSalesLY+double.valueOf(ar.get('AprCNTLY'));
                System.debug('Get active account April : more than $1 Last FY == > '+active.AprActiveSalesLY);
            }

            active.MayActiveSalesLY = 0;
            MayActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) MayCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(May__c) >:ActiveSegment];
            for(AggregateResult ar:MayActiveSalesLY){
                active.MayActiveSalesLY = active.MayActiveSalesLY + double.valueOf(ar.get('MayCNTLY'));
                System.debug('Get active account May : more than $1 Last FY == > '+active.MayActiveSalesLY);
            }

            active.JunActiveSalesLY = 0;
            JunActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JunCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(June__c) >:ActiveSegment];
            for(AggregateResult ar:JunActiveSalesLY){
                active.JunActiveSalesLY = active.JunActiveSalesLY + double.valueOf(ar.get('JunCNTLY'));
                System.debug('Get active account June : more than $1 Last FY == > '+active.JunActiveSalesLY);
            }

            active.JulActiveSalesLY = 0;
            JulActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JunCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(July__c) >:ActiveSegment];
            for(AggregateResult ar:JulActiveSalesLY){
                active.JulActiveSalesLY = active.JulActiveSalesLY + double.valueOf(ar.get('JunCNTLY'));
                System.debug('Get active account July : more than $1 Last FY == >'+active.JulActiveSalesLY);
            }

            active.AugActiveSalesLY = 0;
            AugActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) AugCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(August__c) >:ActiveSegment];
            for(AggregateResult ar:AugActiveSalesLY){
                active.AugActiveSalesLY = active.AugActiveSalesLY + double.valueOf(ar.get('AugCNTLY'));
                System.debug('Get active account August : more than $1 Last FY == >'+active.AugActiveSalesLY);
                
            }
            active.SepActiveSalesLY = 0;
            SepActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) SepCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(September__c) >:ActiveSegment];
            for(AggregateResult ar:SepActiveSalesLY){
                active.SepActiveSalesLY = active.SepActiveSalesLY + double.valueOf(ar.get('SepCNTLY'));
                System.debug('Get active account September : more than $1 Last FY == >'+active.SepActiveSalesLY);
            }

            active.OctActiveSalesLY = 0;
            OctActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) OctCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(October__c) >:ActiveSegment];
            for(AggregateResult ar:OctActiveSalesLY){
                active.OctActiveSalesLY = active.OctActiveSalesLY + double.valueOf(ar.get('OctCNTLY'));
                System.debug('Get active account October : more than $1 Last FY == >'+active.OctActiveSalesLY);
            }

            active.NovActiveSalesLY = 0;
            NovActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) NovCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(November__c) >:ActiveSegment];
            for(AggregateResult ar:NovActiveSalesLY){
                active.NovActiveSalesLY = active.NovActiveSalesLY + double.valueOf(ar.get('NovCNTLY'));
                System.debug('Get active account November : more than $1 Last FY == >'+active.NovActiveSalesLY);
            }

            active.DecActiveSalesLY = 0;
            DecActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) DecCNTLY  
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(December__c) >:ActiveSegment];
            for(AggregateResult ar:DecActiveSalesLY){
                active.DecActiveSalesLY = active.DecActiveSalesLY + double.valueOf(ar.get('DecCNTLY'));
                System.debug('Get active account December : more than $1 Last FY == >'+active.DecActiveSalesLY);
            }

            active.JanActiveSalesLY = 0;
            JanActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) JanCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(January__c) >:ActiveSegment];
            for(AggregateResult ar:JanActiveSalesLY){
                active.JanActiveSalesLY = active.JanActiveSalesLY+double.valueOf(ar.get('JanCNTLY'));
                System.debug('Get active account January : more than $1 Last FY == >'+active.JanActiveSalesLY);
            }

            active.FebActiveSalesLY = 0;
            FebActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) FebCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(February__c) >:ActiveSegment];
            for(AggregateResult ar:FebActiveSalesLY){
                active.FebActiveSalesLY = active.FebActiveSalesLY + double.valueOf(ar.get('FebCNTLY'));
                System.debug('Get active account February : more than $1 Last FY == >'+active.FebActiveSalesLY);
            }

            active.MarActiveSalesLY = 0;
            MarActiveSalesLY = [SELECT account__r.ownerId, COUNT_DISTINCT(hoya_account_id__c) MarCNTLY 
                                FROM qv_sales__c WHERE fy__c=:active.PrevFY 
                                AND account__r.ownerId=:recordId 
                                GROUP BY account__r.ownerid HAVING SUM(March__c) >:ActiveSegment];
            for(AggregateResult ar:MarActiveSalesLY){
                active.MarActiveSalesLY = active.MarActiveSalesLY + double.valueOf(ar.get('MarCNTLY'));
                System.debug('Get active account March : more than $1 Last FY == >'+active.MarActiveSalesLY);
            }

            active.Last2MthLabel = getLast2MthLabel(month);
            active.Last1MthLabel = getLast1MthLabel(month);
            active.LastMthLabel = getLastMthLabel(month);
            active.Last2MthActiveSales = getLast2MthAcitveSales(active, month);
            active.Last1MthActiveSales = getLast1MthActiveSales(active, month);
            active.LastMthActiveSales = getLastMthActiveSales(active, month);

            System.debug('XXX Get data for active sales == >'+active);
            return active;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
    @AuraEnabled
    public static GenDesignOthsSales getGensDesignOthsSales(Id recordId){
        try {
            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = UserInfo.getDefaultCurrency();
            String userCompany = [select CompanyName from User where Id=:recordId].CompanyName;
            System.debug('XXX User CompanyName is '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            } 
            GenDesignOthsSales genOth = new GenDesignOthsSales();
            genOth.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            genOth.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
            System.debug('XXX Current Fiscal Year = '+genOth.CurrFY+' Previous FY is '+genOth.PrevFY);

            originalConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            conversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            userConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            System.debug('XXX conversionRate = '+conversionRate+' originalConversionRate = '+originalConversionRate+' UserConversionRate = '+userConversionRate);

            if(userCurrency!='EUR'){userConversionRate=1;conversionRate=1;}

            System.debug('XXX AFTER Conversion Rate : '+userConversionRate+' && Conversion Rate ==> '+conversionRate);

            genOth.AprOthsSales = 0;
            genOth.MayOthsSales = 0;
            genOth.JunOthsSales = 0;
            genOth.JulOthsSales = 0;
            genOth.AugOthsSales = 0;
            genOth.SepOthsSales = 0;
            genOth.OctOthsSales = 0;
            genOth.NovOthsSales = 0;
            genOth.DecOthsSales = 0;
            genOth.JanOthsSales = 0;
            genOth.FebOthsSales = 0;
            genOth.MarOthsSales = 0;
            genOth.TotalOthsSales = 0;

            genOth.AprOthsQty = 0;
            genOth.MayOthsQty = 0;
            genOth.JunOthsQty = 0;
            genOth.JulOthsQty = 0;
            genOth.AugOthsQty = 0;
            genOth.SepOthsQty = 0;
            genOth.OctOthsQty = 0;
            genOth.NovOthsQty = 0;
            genOth.DecOthsQty = 0;
            genOth.JanOthsQty = 0;
            genOth.FebOthsQty = 0;
            genOth.MarOthsQty = 0;
            genOth.TotalOthsQty = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, 
                                    September__c, October__c, November__c, December__c,
                                    January__c, February__c, March__c, April_qty__c,
                                    May_qty__c, June_qty__c, July_qty__c, August_qty__c,
                                    September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c,
                                    March_qty__c FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId)
                                    AND (FY__c=:genOth.CurrFY) AND (Generic_Design__c NOT IN ('SV','BF','PAL'))])
            {
                genOth.AprOthsSales = genOth.AprOthsSales+double.valueOf(qcy.get('April__c'))*conversionRate;
                genOth.MayOthsSales = genOth.MayOthsSales+double.valueOf(qcy.get('May__c'))*conversionRate;
                genOth.JunOthsSales = genOth.JunOthsSales+double.valueOf(qcy.get('June__c'))*conversionRate;
                genOth.JulOthsSales = genOth.JulOthsSales+double.valueOf(qcy.get('July__c'))*conversionRate;
                genOth.AugOthsSales = genOth.AugOthsSales+double.valueOf(qcy.get('August__c'))*conversionRate;
                genOth.SepOthsSales = genOth.SepOthsSales+double.valueOf(qcy.get('September__c'))*conversionRate;
                genOth.OctOthsSales = genOth.OctOthsSales+double.valueOf(qcy.get('October__c'))*conversionRate;
                genOth.NovOthsSales = genOth.NovOthsSales+double.valueOf(qcy.get('November__c'))*conversionRate;
                genOth.DecOthsSales = genOth.DecOthsSales+double.valueOf(qcy.get('December__c'))*conversionRate;
                genOth.JanOthsSales = genOth.JanOthsSales+double.valueOf(qcy.get('January__c'))*conversionRate;
                genOth.FebOthsSales = genOth.FebOthsSales+double.valueOf(qcy.get('February__c'))*conversionRate;
                genOth.MarOthsSales = genOth.MarOthsSales+double.valueOf(qcy.get('March__c'))*conversionRate;
                genOth.TotalOthsSales = genOth.AprOthsSales+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                genOth.AprOthsQty = genOth.AprOthsQty+double.valueOf(qcy.get('April_qty__c'));
                genOth.MayOthsQty = genOth.MayOthsQty+double.valueOf(qcy.get('May_qty__c'));
                genOth.JunOthsQty = genOth.JunOthsQty+double.valueOf(qcy.get('June_qty__c'));
                genOth.JulOthsQty = genOth.JulOthsQty+double.valueOf(qcy.get('July_qty__c'));
                genOth.AugOthsQty = genOth.AugOthsQty+double.valueOf(qcy.get('August_qty__c'));
                genOth.SepOthsQty = genOth.SepOthsQty+double.valueOf(qcy.get('September_qty__c'));
                genOth.OctOthsQty = genOth.OctOthsQty+double.valueOf(qcy.get('October_qty__c'));
                genOth.NovOthsQty = genOth.NovOthsQty+double.valueOf(qcy.get('November_qty__c'));
                genOth.DecOthsQty = genOth.DecOthsQty+double.valueOf(qcy.get('December_qty__c'));
                genOth.JanOthsQty = genOth.JanOthsQty+double.valueOf(qcy.get('January_qty__c'));
                genOth.FebOthsQty = genOth.FebOthsQty+double.valueOf(qcy.get('February_qty__c'));
                genOth.MarOthsQty = genOth.MarOthsQty+double.valueOf(qcy.get('March_qty__c'));
                genOth.TotalOthsQty = genOth.TotalOthsQty+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));

            }

            genOth.AprOthsSalesLY = 0;
            genOth.MayOthsSalesLY = 0;
            genOth.JunOthsSalesLY = 0;
            genOth.JulOthsSalesLY = 0;
            genOth.AugOthsSalesLY = 0;
            genOth.SepOthsSalesLY = 0;
            genOth.OctOthsSalesLY = 0;
            genOth.NovOthsSalesLY = 0;
            genOth.DecOthsSalesLY = 0;
            genOth.JanOthsSalesLY = 0;
            genOth.FebOthsSalesLY = 0;
            genOth.MarOthsSalesLY = 0;
            genOth.TotalOthsSalesLY = 0;

            genOth.AprOthsQtyLY = 0;
            genOth.MayOthsQtyLY = 0;
            genOth.JunOthsQtyLY = 0;
            genOth.JulOthsQtyLY = 0;
            genOth.AugOthsQtyLY = 0;
            genOth.SepOthsQtyLY = 0;
            genOth.OctOthsQtyLY = 0;
            genOth.NovOthsQtyLY = 0;
            genOth.DecOthsQtyLY = 0;
            genOth.JanOthsQtyLY = 0;
            genOth.FebOthsQtyLY = 0;
            genOth.MarOthsQtyLY = 0;
            genOth.TotalOthsQtyLY = 0;

            for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, 
                                    September__c, October__c, November__c, December__c,
                                    January__c, February__c, March__c, April_qty__c,
                                    May_qty__c, June_qty__c, July_qty__c, August_qty__c,
                                    September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c,
                                    March_qty__c FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId)
                                    AND (FY__c=:genOth.PrevFY) AND (Generic_Design__c NOT IN ('SV','BF','PAL'))])
            {
                genOth.AprOthsSalesLY = genOth.AprOthsSalesLY+double.valueOf(qly.get('April__c'))*conversionRate;
                genOth.MayOthsSalesLY = genOth.MayOthsSalesLY+double.valueOf(qly.get('May__c'))*conversionRate;
                genOth.JunOthsSalesLY = genOth.JunOthsSalesLY+double.valueOf(qly.get('June__c'))*conversionRate;
                genOth.JulOthsSalesLY = genOth.JulOthsSalesLY+double.valueOf(qly.get('July__c'))*conversionRate;
                genOth.AugOthsSalesLY = genOth.AugOthsSalesLY+double.valueOf(qly.get('August__c'))*conversionRate;
                genOth.SepOthsSalesLY = genOth.SepOthsSalesLY+double.valueOf(qly.get('September__c'))*conversionRate;
                genOth.OctOthsSalesLY = genOth.OctOthsSalesLY+double.valueOf(qly.get('October__c'))*conversionRate;
                genOth.NovOthsSalesLY = genOth.NovOthsSalesLY+double.valueOf(qly.get('November__c'))*conversionRate;
                genOth.DecOthsSalesLY = genOth.DecOthsSalesLY+double.valueOf(qly.get('December__c'))*conversionRate;
                genOth.JanOthsSalesLY = genOth.JanOthsSalesLY+double.valueOf(qly.get('January__c'))*conversionRate;
                genOth.FebOthsSalesLY = genOth.FebOthsSalesLY+double.valueOf(qly.get('February__c'))*conversionRate;
                genOth.MarOthsSalesLY = genOth.MarOthsSalesLY+double.valueOf(qly.get('March__c'))*conversionRate;
                genOth.TotalOthsSalesLY = genOth.TotalOthsSalesLY+(double.valueOf(qly.get('April__c'))+double.valueOf(qly.get('May__c'))+double.valueOf(qly.get('June__c'))+double.valueOf(qly.get('July__c'))+double.valueOf(qly.get('August__c'))+double.valueOf(qly.get('September__c'))+double.valueOf(qly.get('October__c'))+double.valueOf(qly.get('November__c'))+double.valueOf(qly.get('December__c'))+double.valueOf(qly.get('January__c'))+double.valueOf(qly.get('February__c'))+double.valueOf(qly.get('March__c')))*conversionRate;

                genOth.AprOthsQtyLY = genOth.AprOthsQtyLY+double.valueOf(qly.get('April_qty__c'));
                genOth.MayOthsQtyLY = genOth.MayOthsQtyLY+double.valueOf(qly.get('May_qty__c'));
                genOth.JunOthsQtyLY = genOth.JunOthsQtyLY+double.valueOf(qly.get('June_qty__c'));
                genOth.JulOthsQtyLY = genOth.JulOthsQtyLY+double.valueOf(qly.get('July_qty__c'));
                genOth.AugOthsQtyLY = genOth.AugOthsQtyLY+double.valueOf(qly.get('August_qty__c'));
                genOth.SepOthsQtyLY = genOth.SepOthsQtyLY+double.valueOf(qly.get('September_qty__c'));
                genOth.OctOthsQtyLY = genOth.OctOthsQtyLY+double.valueOf(qly.get('October_qty__c'));
                genOth.NovOthsQtyLY = genOth.NovOthsQtyLY+double.valueOf(qly.get('November_qty__c'));
                genOth.DecOthsQtyLY = genOth.DecOthsQtyLY+double.valueOf(qly.get('December_qty__c'));
                genOth.JanOthsQtyLY = genOth.JanOthsQtyLY+double.valueOf(qly.get('January_qty__c'));
                genOth.FebOthsQtyLY = genOth.FebOthsQtyLY+double.valueOf(qly.get('February_qty__c'));
                genOth.MarOthsQtyLY = genOth.MarOthsQtyLY+double.valueOf(qly.get('March_qty__c'));
                genOth.TotalOthsQtyLY = genOth.TotalOthsQtyLY+(double.valueOf(qly.get('April_qty__c'))+double.valueOf(qly.get('May_qty__c'))+double.valueOf(qly.get('June_qty__c'))+double.valueOf(qly.get('July_qty__c'))+double.valueOf(qly.get('August_qty__c'))+double.valueOf(qly.get('September_qty__c'))+double.valueOf(qly.get('October_qty__c'))+double.valueOf(qly.get('November_qty__c'))+double.valueOf(qly.get('December_qty__c'))+double.valueOf(qly.get('January_qty__c'))+double.valueOf(qly.get('February_qty__c'))+double.valueOf(qly.get('March_qty__c')));

            }
            System.debug('XXX Get Sales/Qty data Gen-Others Sales == > '+genOth);
            return genOth;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    */
    /*
    @AuraEnabled
    public static GenericDesignSales getGenericDesignSales(Id recordId, String GenericDesign){
        try {

            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = UserInfo.getDefaultCurrency();
            String userCompany = [select CompanyName from User where Id=:recordId].CompanyName;
            System.debug('XXX User Company Name is '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;

            } 

            GenericDesignSales genSales = new GenericDesignSales();

            genSales.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            genSales.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);
            System.debug('XXX Current Fiscal Year : '+genSales.CurrFY+' & Last Fiscal Year : '+genSales.PrevFY);

            originalConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            conversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            userConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            System.debug('XXX conversionRate = '+conversionRate+' originalConversionRate = '+originalConversionRate+' UserConversionRate = '+userConversionRate);

            if(userCurrency!='EUR'){userConversionRate=1;conversionRate=1;}

            System.debug('XXX AFTER Conversion Rate : '+userConversionRate+' && Conversion Rate ==> '+conversionRate);

            genSales.AprSVSales = 0;
            genSales.MaySVSales = 0;
            genSales.JunSVSales = 0;
            genSales.JulSVSales = 0;
            genSales.AugSVSales = 0;
            genSales.SepSVSales = 0;
            genSales.OctSVSales = 0;
            genSales.NovSVSales = 0;
            genSales.DecSVSales = 0;
            genSales.JanSVSales = 0;
            genSales.FebSVSales = 0;
            genSales.MarSVSales = 0;
            genSales.TotalSVSales = 0;

            genSales.AprSVQty = 0;
            genSales.MaySVQty = 0;
            genSales.JunSVQty = 0;
            genSales.JulSVQty = 0;
            genSales.AugSVQty = 0;
            genSales.SepSVQty = 0;
            genSales.OctSVQty = 0;
            genSales.NovSVQty = 0;
            genSales.DecSVQty = 0;
            genSales.JanSVQty = 0;
            genSales.FebSVQty = 0;
            genSales.MarSVQty = 0;
            genSales.TotalSVQty = 0;
            
            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                , October__c, November__c, December__c, January__c, February__c, March__c
                                , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                FROM QV_Sales__c
                                WHERE (Account__r.OwnerId=:recordId) and (FY__c=:genSales.CurrFY)
                                AND (Generic_Design__c=:GenericDesign)])
            {
                genSales.AprSVSales = genSales.AprSVSales+double.valueOf(qcy.get('April__c'))*conversionRate;
                genSales.MaySVSales = genSales.MaySVSales+double.valueOf(qcy.get('May__c'))*conversionRate;
                genSales.JunSVSales = genSales.JunSVSales+double.valueOf(qcy.get('June__c'))*conversionRate;
                genSales.JulSVSales = genSales.JulSVSales+double.valueOf(qcy.get('July__c'))*conversionRate;
                genSales.AugSVSales = genSales.AugSVSales+double.valueOf(qcy.get('August__c'))*conversionRate;
                genSales.SepSVSales = genSales.SepSVSales+double.valueOf(qcy.get('September__c'))*conversionRate;
                genSales.OctSVSales = genSales.OctSVSales+double.valueOf(qcy.get('October__c'))*conversionRate;
                genSales.NovSVSales = genSales.NovSVSales+double.valueOf(qcy.get('November__c'))*conversionRate;
                genSales.DecSVSales = genSales.DecSVSales+double.valueOf(qcy.get('December__c'))*conversionRate;
                genSales.JanSVSales = genSales.JanSVSales+double.valueOf(qcy.get('January__c'))*conversionRate;
                genSales.FebSVSales = genSales.FebSVSales+double.valueOf(qcy.get('February__c'))*conversionRate;
                genSales.MarSVSales = genSales.MarSVSales+double.valueOf(qcy.get('March__c'))*conversionRate;
                genSales.TotalSVSales = genSales.TotalSVSales+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                genSales.AprSVQty = genSales.AprSVQty+double.valueOf(qcy.get('April_qty__c'));
                genSales.MaySVQty = genSales.MaySVQty+double.valueOf(qcy.get('May_qty__c'));
                genSales.JunSVQty = genSales.JunSVQty+double.valueOf(qcy.get('June_qty__c'));
                genSales.JulSVQty = genSales.JulSVQty+double.valueOf(qcy.get('July_qty__c'));
                genSales.AugSVQty = genSales.AugSVQty+double.valueOf(qcy.get('August_qty__c'));
                genSales.SepSVQty = genSales.SepSVQty+double.valueOf(qcy.get('September_qty__c'));
                genSales.OctSVQty = genSales.OctSVQty+double.valueOf(qcy.get('October_qty__c'));
                genSales.NovSVQty = genSales.NovSVQty+double.valueOf(qcy.get('November_qty__c'));
                genSales.DecSVQty = genSales.DecSVQty+double.valueOf(qcy.get('December_qty__c'));
                genSales.JanSVQty = genSales.JanSVQty+double.valueOf(qcy.get('January_qty__c'));
                genSales.FebSVQty = genSales.FebSVQty+double.valueOf(qcy.get('February_qty__c'));
                genSales.MarSVQty = genSales.MarSVQty+double.valueOf(qcy.get('March_qty__c'));
                genSales.TotalSVQty = genSales.TotalSVQty+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));
            }

            genSales.AprSVSalesLY = 0;
            genSales.MaySVSalesLY = 0;
            genSales.JunSVSalesLY = 0;
            genSales.JulSVSalesLY = 0;
            genSales.AugSVSalesLY = 0;
            genSales.SepSVSalesLY = 0;
            genSales.OctSVSalesLY = 0;
            genSales.NovSVSalesLY = 0;
            genSales.DecSVSalesLY = 0;
            genSales.JanSVSalesLY = 0;
            genSales.FebSVSalesLY = 0;
            genSales.MarSVSalesLY = 0;
            genSales.TotalSVSalesLY = 0;

            genSales.AprSVQtyLY = 0;
            genSales.MaySVQtyLY = 0;
            genSales.JunSVQtyLY = 0;
            genSales.JulSVQtyLY = 0;
            genSales.AugSVQtyLY = 0;
            genSales.SepSVQtyLY = 0;
            genSales.OctSVQtyLY = 0;
            genSales.NovSVQtyLY = 0;
            genSales.DecSVQtyLY = 0;
            genSales.JanSVQtyLY = 0;
            genSales.FebSVQtyLY = 0;
            genSales.MarSVQtyLY = 0;
            genSales.TotalSVQtyLY = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                    , October__c, November__c, December__c, January__c, February__c, March__c
                                    , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                    , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                FROM QV_Sales__c
                                WHERE (Account__r.OwnerId=:recordId) and (FY__c=:genSales.PrevFY)
                                AND (Generic_Design__c=:GenericDesign)])
            {
                genSales.AprSVSalesLY = genSales.AprSVSalesLY+double.valueOf(qcy.get('April__c'))*conversionRate;
                genSales.MaySVSalesLY = genSales.MaySVSalesLY+double.valueOf(qcy.get('May__c'))*conversionRate;
                genSales.JunSVSalesLY = genSales.JunSVSalesLY+double.valueOf(qcy.get('June__c'))*conversionRate;
                genSales.JulSVSalesLY = genSales.JulSVSalesLY+double.valueOf(qcy.get('July__c'))*conversionRate;
                genSales.AugSVSalesLY = genSales.AugSVSalesLY+double.valueOf(qcy.get('August__c'))*conversionRate;
                genSales.SepSVSalesLY = genSales.SepSVSalesLY+double.valueOf(qcy.get('September__c'))*conversionRate;
                genSales.OctSVSalesLY = genSales.OctSVSalesLY+double.valueOf(qcy.get('October__c'))*conversionRate;
                genSales.NovSVSalesLY = genSales.NovSVSalesLY+double.valueOf(qcy.get('November__c'))*conversionRate;
                genSales.DecSVSalesLY = genSales.DecSVSalesLY+double.valueOf(qcy.get('December__c'))*conversionRate;
                genSales.JanSVSalesLY = genSales.JanSVSalesLY+double.valueOf(qcy.get('January__c'))*conversionRate;
                genSales.FebSVSalesLY = genSales.FebSVSalesLY+double.valueOf(qcy.get('February__c'))*conversionRate;
                genSales.MarSVSalesLY = genSales.MarSVSalesLY+double.valueOf(qcy.get('March__c'))*conversionRate;
                genSales.TotalSVSalesLY = genSales.TotalSVSalesLY+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                genSales.AprSVQtyLY = genSales.AprSVQtyLY+double.valueOf(qcy.get('April_qty__c'));
                genSales.MaySVQtyLY = genSales.MaySVQtyLY+double.valueOf(qcy.get('May_qty__c'));
                genSales.JunSVQtyLY = genSales.JunSVQtyLY+double.valueOf(qcy.get('June_qty__c'));
                genSales.JulSVQtyLY = genSales.JulSVQtyLY+double.valueOf(qcy.get('July_qty__c'));
                genSales.AugSVQtyLY = genSales.AugSVQtyLY+double.valueOf(qcy.get('August_qty__c'));
                genSales.SepSVQtyLY = genSales.SepSVQtyLY+double.valueOf(qcy.get('September_qty__c'));
                genSales.OctSVQtyLY = genSales.OctSVQtyLY+double.valueOf(qcy.get('October_qty__c'));
                genSales.NovSVQtyLY = genSales.NovSVQtyLY+double.valueOf(qcy.get('November_qty__c'));
                genSales.DecSVQtyLY = genSales.DecSVQtyLY+double.valueOf(qcy.get('December_qty__c'));
                genSales.JanSVQtyLY = genSales.JanSVQtyLY+double.valueOf(qcy.get('January_qty__c'));
                genSales.FebSVQtyLY = genSales.FebSVQtyLY+double.valueOf(qcy.get('February_qty__c'));
                genSales.MarSVQtyLY = genSales.MarSVQtyLY+double.valueOf(qcy.get('March_qty__c'));
                genSales.TotalSVQtyLY = genSales.TotalSVQtyLY+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));
            }

            System.debug('XXX Get Data For SV/PAL/BF ==> '+genSales);
            return genSales;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    */
    /*
    @AuraEnabled
    public static RxStockSale getRxStockSales(Id recordId){
        try {

            Integer year = date.today().year();
            Integer month = date.today().month();
            String userCurrency = UserInfo.getDefaultCurrency();
            String userCompany = [select companyName from User where Id=:recordId].companyName;
            System.debug('User Company Name is '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            RxStockSale rxst = new RxStockSale();

            rxst.CurrFY = 'FY-'+String.valueOf(year).substring(2);
            rxst.PrevFY = 'FY-'+String.valueOf(year-1).substring(2);

            System.debug('Current FY '+rxst.CurrFY+' Last Fiscal Year '+rxst.PrevFY);

            originalConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            conversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            userConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
            System.debug('XXX conversionRate = '+conversionRate+' originalConversionRate = '+originalConversionRate+' UserConversionRate = '+userConversionRate);

            //if(conversionRate==userConversionRate){userConversionRate=1;}
            if(userCurrency!='EUR'){userConversionRate=1;conversionRate=1;}

            rxst.AprRxSales = 0;
            rxst.MayRxSales = 0;
            rxst.JunRxSales = 0;
            rxst.JulRxSales = 0;
            rxst.AugRxSales = 0;
            rxst.SepRxSales = 0;
            rxst.OctRxSales = 0;
            rxst.NovRxSales = 0;
            rxst.DecRxSales = 0;
            rxst.JanRxSales = 0;
            rxst.FebRxSales = 0;
            rxst.MarRxSales = 0;
            rxst.TotalRxSales = 0;

            rxst.AprRxSalesLY = 0;
            rxst.MayRxSalesLY = 0;
            rxst.JunRxSalesLY = 0;
            rxst.JulRxSalesLY = 0;
            rxst.AugRxSalesLY = 0;
            rxst.SepRxSalesLY = 0;
            rxst.OctRxSalesLY = 0;
            rxst.NovRxSalesLY = 0;
            rxst.DecRxSalesLY = 0;
            rxst.JanRxSalesLY = 0;
            rxst.FebRxSalesLY = 0;
            rxst.MarRxSalesLY = 0;
            rxst.TotalRxSalesLY = 0;

            rxst.AprRxQty = 0;
            rxst.MayRxQty = 0;
            rxst.JunRxQty = 0;
            rxst.JulRxQty = 0;
            rxst.AugRxQty = 0;
            rxst.SepRxQty = 0;
            rxst.OctRxQty = 0;
            rxst.NovRxQty = 0;
            rxst.DecRxQty = 0;
            rxst.JanRxQty = 0;
            rxst.FebRxQty = 0;
            rxst.MarRxQty = 0;
            rxst.TotalRxQty = 0;

            rxst.AprRxQtyLY = 0;
            rxst.MayRxQtyLY = 0;
            rxst.JunRxQtyLY = 0;
            rxst.JulRxQtyLY = 0;
            rxst.AugRxQtyLY = 0;
            rxst.SepRxQtyLY = 0;
            rxst.OctRxQtyLY = 0;
            rxst.NovRxQtyLY = 0;
            rxst.DecRxQtyLY = 0;
            rxst.JanRxQtyLY = 0;
            rxst.FebRxQtyLY = 0;
            rxst.MarRxQtyLY = 0;
            rxst.TotalRxQtyLY = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c IN('RX', 'RXs', 'Rxs')) AND (FY__c=:rxst.CurrFY)])
            {
                rxst.AprRxSales = rxst.AprRxSales+double.valueOf(qcy.get('April__c'))*conversionRate;
                rxst.MayRxSales = rxst.MayRxSales+double.valueOf(qcy.get('May__c'))*conversionRate;
                rxst.JunRxSales = rxst.JunRxSales+double.valueOf(qcy.get('June__c'))*conversionRate;
                rxst.JulRxSales = rxst.JulRxSales+double.valueOf(qcy.get('July__c'))*conversionRate;
                rxst.AugRxSales = rxst.AugRxSales+double.valueOf(qcy.get('August__c'))*conversionRate;
                rxst.SepRxSales = rxst.SepRxSales+double.valueOf(qcy.get('September__c'))*conversionRate;
                rxst.OctRxSales = rxst.OctRxSales+double.valueOf(qcy.get('October__c'))*conversionRate;
                rxst.NovRxSales = rxst.NovRxSales+double.valueOf(qcy.get('November__c'))*conversionRate;
                rxst.DecRxSales = rxst.DecRxSales+double.valueOf(qcy.get('December__c'))*conversionRate;
                rxst.JanRxSales = rxst.JanRxSales+double.valueOf(qcy.get('January__c'))*conversionRate;
                rxst.FebRxSales = rxst.FebRxSales+double.valueOf(qcy.get('February__c'))*conversionRate;
                rxst.MarRxSales = rxst.MarRxSales+double.valueOf(qcy.get('March__c'))*conversionRate;
                rxst.TotalRxSales = rxst.TotalRxSales+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                rxst.AprRxQty = rxst.AprRxQty+double.valueOf(qcy.get('April_qty__c'));
                rxst.MayRxQty = rxst.AprRxQty+double.valueOf(qcy.get('May_qty__c'));
                rxst.JunRxQty = rxst.AprRxQty+double.valueOf(qcy.get('June_qty__c'));
                rxst.JulRxQty = rxst.AprRxQty+double.valueOf(qcy.get('July_qty__c'));
                rxst.AugRxQty = rxst.AprRxQty+double.valueOf(qcy.get('August_qty__c'));
                rxst.SepRxQty = rxst.AprRxQty+double.valueOf(qcy.get('September_qty__c'));
                rxst.OctRxQty = rxst.AprRxQty+double.valueOf(qcy.get('October_qty__c'));
                rxst.NovRxQty = rxst.AprRxQty+double.valueOf(qcy.get('November_qty__c'));
                rxst.DecRxQty = rxst.AprRxQty+double.valueOf(qcy.get('December_qty__c'));
                rxst.JanRxQty = rxst.AprRxQty+double.valueOf(qcy.get('January_qty__c'));
                rxst.FebRxQty = rxst.AprRxQty+double.valueOf(qcy.get('February_qty__c'));
                rxst.MarRxQty = rxst.AprRxQty+double.valueOf(qcy.get('March_qty__c'));
                rxst.TotalRxQty = rxst.TotalRxQty+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));

            }

            for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c IN('RX', 'RXs', 'Rxs')) AND (FY__c=:rxst.PrevFY)])
            {
                rxst.AprRxSalesLY = rxst.AprRxSalesLY+double.valueOf(qly.get('April__c'))*conversionRate;
                rxst.MayRxSalesLY = rxst.MayRxSalesLY+double.valueOf(qly.get('May__c'))*conversionRate;
                rxst.JunRxSalesLY = rxst.JunRxSalesLY+double.valueOf(qly.get('June__c'))*conversionRate;
                rxst.JulRxSalesLY = rxst.JulRxSalesLY+double.valueOf(qly.get('July__c'))*conversionRate;
                rxst.AugRxSalesLY = rxst.AugRxSalesLY+double.valueOf(qly.get('August__c'))*conversionRate;
                rxst.SepRxSalesLY = rxst.SepRxSalesLY+double.valueOf(qly.get('September__c'))*conversionRate;
                rxst.OctRxSalesLY = rxst.OctRxSalesLY+double.valueOf(qly.get('October__c'))*conversionRate;
                rxst.NovRxSalesLY = rxst.NovRxSalesLY+double.valueOf(qly.get('November__c'))*conversionRate;
                rxst.DecRxSalesLY = rxst.DecRxSalesLY+double.valueOf(qly.get('December__c'))*conversionRate;
                rxst.JanRxSalesLY = rxst.JanRxSalesLY+double.valueOf(qly.get('January__c'))*conversionRate;
                rxst.FebRxSalesLY = rxst.FebRxSalesLY+double.valueOf(qly.get('February__c'))*conversionRate;
                rxst.MarRxSalesLY = rxst.MarRxSalesLY+double.valueOf(qly.get('March__c'))*conversionRate;
                rxst.TotalRxSalesLY = rxst.TotalRxSalesLY+(double.valueOf(qly.get('April__c'))+double.valueOf(qly.get('May__c'))+double.valueOf(qly.get('June__c'))+double.valueOf(qly.get('July__c'))+double.valueOf(qly.get('August__c'))+double.valueOf(qly.get('September__c'))+double.valueOf(qly.get('October__c'))+double.valueOf(qly.get('November__c'))+double.valueOf(qly.get('December__c'))+double.valueOf(qly.get('January__c'))+double.valueOf(qly.get('February__c'))+double.valueOf(qly.get('March__c')))*conversionRate;

                rxst.AprRxQtyLY = rxst.AprRxQtyLY+double.valueOf(qly.get('April_qty__c'));
                rxst.MayRxQtyLY = rxst.MayRxQtyLY+double.valueOf(qly.get('May_qty__c'));
                rxst.JunRxQtyLY = rxst.JunRxQtyLY+double.valueOf(qly.get('June_qty__c'));
                rxst.JulRxQtyLY = rxst.JulRxQtyLY+double.valueOf(qly.get('July_qty__c'));
                rxst.AugRxQtyLY = rxst.AugRxQtyLY+double.valueOf(qly.get('August_qty__c'));
                rxst.SepRxQtyLY = rxst.SepRxQtyLY+double.valueOf(qly.get('September_qty__c'));
                rxst.OctRxQtyLY = rxst.OctRxQtyLY+double.valueOf(qly.get('October_qty__c'));
                rxst.NovRxQtyLY = rxst.NovRxQtyLY+double.valueOf(qly.get('November_qty__c'));
                rxst.DecRxQtyLY = rxst.DecRxQtyLY+double.valueOf(qly.get('December_qty__c'));
                rxst.JanRxQtyLY = rxst.JanRxQtyLY+double.valueOf(qly.get('January_qty__c'));
                rxst.FebRxQtyLY = rxst.FebRxQtyLY+double.valueOf(qly.get('February_qty__c'));
                rxst.MarRxQtyLY = rxst.MarRxQtyLY+double.valueOf(qly.get('March_qty__c'));
                rxst.TotalRxQtyLY = rxst.TotalRxQtyLY+(double.valueOf(qly.get('April_qty__c'))+double.valueOf(qly.get('May_qty__c'))+double.valueOf(qly.get('June_qty__c'))+double.valueOf(qly.get('July_qty__c'))+double.valueOf(qly.get('August_qty__c'))+double.valueOf(qly.get('September_qty__c'))+double.valueOf(qly.get('October_qty__c'))+double.valueOf(qly.get('November_qty__c'))+double.valueOf(qly.get('December_qty__c'))+double.valueOf(qly.get('January_qty__c'))+double.valueOf(qly.get('February_qty__c'))+double.valueOf(qly.get('March_qty__c')));

            }

            rxst.AprStSales = 0;
            rxst.MayStSales = 0;
            rxst.JunStSales = 0;
            rxst.JulStSales = 0;
            rxst.AugStSales = 0;
            rxst.SepStSales = 0;
            rxst.OctStSales = 0;
            rxst.NovStSales = 0;
            rxst.DecStSales = 0;
            rxst.JanStSales = 0;
            rxst.FebStSales = 0;
            rxst.MarStSales = 0;
            rxst.TotalStSales = 0;

            rxst.AprStQty = 0;
            rxst.MayStQty = 0;
            rxst.JunStQty = 0;
            rxst.JulStQty = 0;
            rxst.AugStQty = 0;
            rxst.SepStQty = 0;
            rxst.OctStQty = 0;
            rxst.NovStQty = 0;
            rxst.DecStQty = 0;
            rxst.JanStQty = 0;
            rxst.FebStQty = 0;
            rxst.MarStQty = 0;
            rxst.TotalStQty = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c IN('ST','Stocks','STOCK','STOCKS')) AND (FY__c=:rxst.CurrFY)])
            {
                rxst.AprStSales = rxst.AprStSales+double.valueOf(qcy.get('April__c'))*conversionRate;
                rxst.MayStSales = rxst.MayStSales+double.valueOf(qcy.get('May__c'))*conversionRate;
                rxst.JunStSales = rxst.JunStSales+double.valueOf(qcy.get('June__c'))*conversionRate;
                rxst.JulStSales = rxst.JulStSales+double.valueOf(qcy.get('July__c'))*conversionRate;
                rxst.AugStSales = rxst.AugStSales+double.valueOf(qcy.get('August__c'))*conversionRate;
                rxst.SepStSales = rxst.SepStSales+double.valueOf(qcy.get('September__c'))*conversionRate;
                rxst.OctStSales = rxst.OctStSales+double.valueOf(qcy.get('October__c'))*conversionRate;
                rxst.NovStSales = rxst.NovStSales+double.valueOf(qcy.get('November__c'))*conversionRate;
                rxst.DecStSales = rxst.DecStSales+double.valueOf(qcy.get('December__c'))*conversionRate;
                rxst.JanStSales = rxst.JanStSales+double.valueOf(qcy.get('January__c'))*conversionRate;
                rxst.FebStSales = rxst.FebStSales+double.valueOf(qcy.get('February__c'))*conversionRate;
                rxst.MarStSales = rxst.MarStSales+double.valueOf(qcy.get('March__c'))*conversionRate;
                rxst.TotalStSales = rxst.TotalStSales+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                rxst.AprStQty = rxst.AprStQty+double.valueOf(qcy.get('April_qty__c'));
                rxst.MayStQty = rxst.MayStQty+double.valueOf(qcy.get('May_qty__c'));
                rxst.JunStQty = rxst.JunStQty+double.valueOf(qcy.get('June_qty__c'));
                rxst.JulStQty = rxst.JulStQty+double.valueOf(qcy.get('July_qty__c'));
                rxst.AugStQty = rxst.AugStQty+double.valueOf(qcy.get('August_qty__c'));
                rxst.SepStQty = rxst.SepStQty+double.valueOf(qcy.get('September_qty__c'));
                rxst.OctStQty = rxst.OctStQty+double.valueOf(qcy.get('October_qty__c'));
                rxst.NovStQty = rxst.NovStQty+double.valueOf(qcy.get('November_qty__c'));
                rxst.DecStQty = rxst.DecStQty+double.valueOf(qcy.get('December_qty__c'));
                rxst.JanStQty = rxst.JanStQty+double.valueOf(qcy.get('January_qty__c'));
                rxst.FebStQty = rxst.FebStQty+double.valueOf(qcy.get('February_qty__c'));
                rxst.MarStQty = rxst.MarStQty+double.valueOf(qcy.get('March_qty__c'));
                rxst.TotalStQty = rxst.TotalStQty+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));
            }


            rxst.AprStSalesLY = 0;
            rxst.MayStSalesLY = 0;
            rxst.JunStSalesLY = 0;
            rxst.JulStSalesLY = 0;
            rxst.AugStSalesLY = 0;
            rxst.SepStSalesLY = 0;
            rxst.OctStSalesLY = 0;
            rxst.NovStSalesLY = 0;
            rxst.DecStSalesLY = 0;
            rxst.JanStSalesLY = 0;
            rxst.FebStSalesLY = 0;
            rxst.MarStSalesLY = 0;
            rxst.TotalStSalesLY = 0;

            rxst.AprStQtyLY = 0;
            rxst.MayStQtyLY = 0;
            rxst.JunStQtyLY = 0;
            rxst.JulStQtyLY = 0;
            rxst.AugStQtyLY = 0;
            rxst.SepStQtyLY = 0;
            rxst.OctStQtyLY = 0;
            rxst.NovStQtyLY = 0;
            rxst.DecStQtyLY = 0;
            rxst.JanStQtyLY = 0;
            rxst.FebStQtyLY = 0;
            rxst.MarStQtyLY = 0;
            rxst.TotalStQtyLY = 0;

            for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c IN('ST','Stocks','STOCK','STOCKS')) AND (FY__c=:rxst.PrevFY)])
            {
                rxst.AprStSalesLY = rxst.AprStSalesLY+double.valueOf(qly.get('April__c'))*conversionRate;
                rxst.MayStSalesLY = rxst.MayStSalesLY+double.valueOf(qly.get('May__c'))*conversionRate;
                rxst.JunStSalesLY = rxst.JunStSalesLY+double.valueOf(qly.get('June__c'))*conversionRate;
                rxst.JulStSalesLY = rxst.JulStSalesLY+double.valueOf(qly.get('July__c'))*conversionRate;
                rxst.AugStSalesLY = rxst.AugStSalesLY+double.valueOf(qly.get('August__c'))*conversionRate;
                rxst.SepStSalesLY = rxst.SepStSalesLY+double.valueOf(qly.get('September__c'))*conversionRate;
                rxst.OctStSalesLY = rxst.OctStSalesLY+double.valueOf(qly.get('October__c'))*conversionRate;
                rxst.NovStSalesLY = rxst.NovStSalesLY+double.valueOf(qly.get('November__c'))*conversionRate;
                rxst.DecStSalesLY = rxst.DecStSalesLY+double.valueOf(qly.get('December__c'))*conversionRate;
                rxst.JanStSalesLY = rxst.JanStSalesLY+double.valueOf(qly.get('January__c'))*conversionRate;
                rxst.FebStSalesLY = rxst.FebStSalesLY+double.valueOf(qly.get('February__c'))*conversionRate;
                rxst.MarStSalesLY = rxst.MarStSalesLY+double.valueOf(qly.get('March__c'))*conversionRate;
                rxst.TotalStSalesLY = rxst.TotalStSalesLY+(double.valueOf(qly.get('April__c'))+double.valueOf(qly.get('May__c'))+double.valueOf(qly.get('June__c'))+double.valueOf(qly.get('July__c'))+double.valueOf(qly.get('August__c'))+double.valueOf(qly.get('September__c'))+double.valueOf(qly.get('October__c'))+double.valueOf(qly.get('November__c'))+double.valueOf(qly.get('December__c'))+double.valueOf(qly.get('January__c'))+double.valueOf(qly.get('February__c'))+double.valueOf(qly.get('March__c')))*conversionRate;

                rxst.AprStQtyLY = rxst.AprStQtyLY+double.valueOf(qly.get('April_qty__c'));
                rxst.MayStQtyLY = rxst.MayStQtyLY+double.valueOf(qly.get('May_qty__c'));
                rxst.JunStQtyLY = rxst.JunStQtyLY+double.valueOf(qly.get('June_qty__c'));
                rxst.JulStQtyLY = rxst.JulStQtyLY+double.valueOf(qly.get('July_qty__c'));
                rxst.AugStQtyLY = rxst.AugStQtyLY+double.valueOf(qly.get('August_qty__c'));
                rxst.SepStQtyLY = rxst.SepStQtyLY+double.valueOf(qly.get('September_qty__c'));
                rxst.OctStQtyLY = rxst.OctStQtyLY+double.valueOf(qly.get('October_qty__c'));
                rxst.NovStQtyLY = rxst.NovStQtyLY+double.valueOf(qly.get('November_qty__c'));
                rxst.DecStQtyLY = rxst.DecStQtyLY+double.valueOf(qly.get('December_qty__c'));
                rxst.JanStQtyLY = rxst.JanStQtyLY+double.valueOf(qly.get('January_qty__c'));
                rxst.FebStQtyLY = rxst.FebStQtyLY+double.valueOf(qly.get('February_qty__c'));
                rxst.MarStQtyLY = rxst.MarStQtyLY+double.valueOf(qly.get('March_qty__c'));

            }

            rxst.AprOthSales = 0;
            rxst.MayOthSales = 0;
            rxst.JunOthSales = 0;
            rxst.JulOthSales = 0;
            rxst.AugOthSales = 0;
            rxst.SepOthSales = 0;
            rxst.OctOthSales = 0;
            rxst.NovOthSales = 0;
            rxst.DecOthSales = 0;
            rxst.JanOthSales = 0;
            rxst.FebOthSales = 0;
            rxst.MarOthSales = 0;
            rxst.TotalOthSales = 0;

            rxst.AprOthQty = 0;
            rxst.MayOthQty = 0;
            rxst.JunOthQty = 0;
            rxst.JulOthQty = 0;
            rxst.AugOthQty = 0;
            rxst.SepOthQty = 0;
            rxst.OctOthQty = 0;
            rxst.NovOthQty = 0;
            rxst.DecOthQty = 0;
            rxst.JanOthQty = 0;
            rxst.FebOthQty = 0;
            rxst.MarOthQty = 0;
            rxst.TotalOthQty = 0;

            for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c NOT IN ('ST','Stocks','STOCK','STOCKS','RX','RXs','Rxs')) AND (FY__c=:rxst.CurrFY)])
            {
                rxst.AprOthSales = rxst.AprOthSales+double.valueOf(qcy.get('April__c'))*conversionRate;
                rxst.MayOthSales = rxst.MayOthSales+double.valueOf(qcy.get('May__c'))*conversionRate;
                rxst.JunOthSales = rxst.JunOthSales+double.valueOf(qcy.get('June__c'))*conversionRate;
                rxst.JulOthSales = rxst.JulOthSales+double.valueOf(qcy.get('July__c'))*conversionRate;
                rxst.AugOthSales = rxst.AugOthSales+double.valueOf(qcy.get('August__c'))*conversionRate;
                rxst.SepOthSales = rxst.SepOthSales+double.valueOf(qcy.get('September__c'))*conversionRate;
                rxst.OctOthSales = rxst.OctOthSales+double.valueOf(qcy.get('October__c'))*conversionRate;
                rxst.NovOthSales = rxst.NovOthSales+double.valueOf(qcy.get('November__c'))*conversionRate;
                rxst.DecOthSales = rxst.DecOthSales+double.valueOf(qcy.get('December__c'))*conversionRate;
                rxst.JanOthSales = rxst.JanOthSales+double.valueOf(qcy.get('January__c'))*conversionRate;
                rxst.FebOthSales = rxst.FebOthSales+double.valueOf(qcy.get('February__c'))*conversionRate;
                rxst.MarOthSales = rxst.MarOthSales+double.valueOf(qcy.get('March__c'))*conversionRate;
                rxst.TotalOthSales = rxst.TotalOthSales+(double.valueOf(qcy.get('April__c'))+double.valueOf(qcy.get('May__c'))+double.valueOf(qcy.get('June__c'))+double.valueOf(qcy.get('July__c'))+double.valueOf(qcy.get('August__c'))+double.valueOf(qcy.get('September__c'))+double.valueOf(qcy.get('October__c'))+double.valueOf(qcy.get('November__c'))+double.valueOf(qcy.get('December__c'))+double.valueOf(qcy.get('January__c'))+double.valueOf(qcy.get('February__c'))+double.valueOf(qcy.get('March__c')))*conversionRate;

                rxst.AprOthQty = rxst.AprOthQty+double.valueOf(qcy.get('April_qty__c'));
                rxst.MayOthQty = rxst.MayOthQty+double.valueOf(qcy.get('May_qty__c'));
                rxst.JunOthQty = rxst.JunOthQty+double.valueOf(qcy.get('June_qty__c'));
                rxst.JulOthQty = rxst.JulOthQty+double.valueOf(qcy.get('July_qty__c'));
                rxst.AugOthQty = rxst.AugOthQty+double.valueOf(qcy.get('August_qty__c'));
                rxst.SepOthQty = rxst.SepOthQty+double.valueOf(qcy.get('September_qty__c'));
                rxst.OctOthQty = rxst.OctOthQty+double.valueOf(qcy.get('October_qty__c'));
                rxst.NovOthQty = rxst.NovOthQty+double.valueOf(qcy.get('November_qty__c'));
                rxst.DecOthQty = rxst.DecOthQty+double.valueOf(qcy.get('December_qty__c'));
                rxst.JanOthQty = rxst.JanOthQty+double.valueOf(qcy.get('January_qty__c'));
                rxst.FebOthQty = rxst.FebOthQty+double.valueOf(qcy.get('February_qty__c'));
                rxst.MarOthQty = rxst.MarOthQty+double.valueOf(qcy.get('March_qty__c'));
                rxst.TotalOthQty = rxst.TotalOthQty+(double.valueOf(qcy.get('April_qty__c'))+double.valueOf(qcy.get('May_qty__c'))+double.valueOf(qcy.get('June_qty__c'))+double.valueOf(qcy.get('July_qty__c'))+double.valueOf(qcy.get('August_qty__c'))+double.valueOf(qcy.get('September_qty__c'))+double.valueOf(qcy.get('October_qty__c'))+double.valueOf(qcy.get('November_qty__c'))+double.valueOf(qcy.get('December_qty__c'))+double.valueOf(qcy.get('January_qty__c'))+double.valueOf(qcy.get('February_qty__c'))+double.valueOf(qcy.get('March_qty__c')));
            }

            rxst.AprOthSalesLY = 0;
            rxst.MayOthSalesLY = 0;
            rxst.JunOthSalesLY = 0;
            rxst.JulOthSalesLY = 0;
            rxst.AugOthSalesLY = 0;
            rxst.SepOthSalesLY = 0;
            rxst.OctOthSalesLY = 0;
            rxst.NovOthSalesLY = 0;
            rxst.DecOthSalesLY = 0;
            rxst.JanOthSalesLY = 0;
            rxst.FebOthSalesLY = 0;
            rxst.MarOthSalesLY = 0;
            rxst.TotalOthSalesLY = 0;

            rxst.AprOthQtyLY = 0;
            rxst.MayOthQtyLY = 0;
            rxst.JunOthQtyLY = 0;
            rxst.JulOthQtyLY = 0;
            rxst.AugOthQtyLY = 0;
            rxst.SepOthQtyLY = 0;
            rxst.OctOthQtyLY = 0;
            rxst.NovOthQtyLY = 0;
            rxst.DecOthQtyLY = 0;
            rxst.JanOthQtyLY = 0;
            rxst.FebOthQtyLY = 0;
            rxst.MarOthQtyLY = 0;
            rxst.TotalOthQtyLY = 0;

            for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c,
                                    October__c, November__c, December__c, January__c, February__c,
                                    March__c, April_qty__c, May_qty__c, June_qty__c, July_qty__c,
                                    August_qty__c, September_qty__c, October_qty__c, November_qty__c,
                                    December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c WHERE (Account__r.OwnerId=:recordId) 
                                    AND (RX_or_Stock__c NOT IN ('ST','Stocks','STOCK','STOCKS','RX','RXs','Rxs')) AND (FY__c=:rxst.PrevFY)])
            {
                rxst.AprOthSalesLY = rxst.AprOthSalesLY+double.valueOf(qly.get('April__c'))*conversionRate;
                rxst.MayOthSalesLY = rxst.MayOthSalesLY+double.valueOf(qly.get('May__c'))*conversionRate;
                rxst.JunOthSalesLY = rxst.JunOthSalesLY+double.valueOf(qly.get('June__c'))*conversionRate;
                rxst.JulOthSalesLY = rxst.JulOthSalesLY+double.valueOf(qly.get('July__c'))*conversionRate;
                rxst.AugOthSalesLY = rxst.AugOthSalesLY+double.valueOf(qly.get('August__c'))*conversionRate;
                rxst.SepOthSalesLY = rxst.SepOthSalesLY+double.valueOf(qly.get('September__c'))*conversionRate;
                rxst.OctOthSalesLY = rxst.OctOthSalesLY+double.valueOf(qly.get('October__c'))*conversionRate;
                rxst.NovOthSalesLY = rxst.NovOthSalesLY+double.valueOf(qly.get('November__c'))*conversionRate;
                rxst.DecOthSalesLY = rxst.DecOthSalesLY+double.valueOf(qly.get('December__c'))*conversionRate;
                rxst.JanOthSalesLY = rxst.JanOthSalesLY+double.valueOf(qly.get('January__c'))*conversionRate;
                rxst.FebOthSalesLY = rxst.FebOthSalesLY+double.valueOf(qly.get('February__c'))*conversionRate;
                rxst.MarOthSalesLY = rxst.MarOthSalesLY+double.valueOf(qly.get('March__c'))*conversionRate;
                rxst.TotalOthSalesLY = rxst.TotalOthSalesLY+(double.valueOf(qly.get('April__c'))+double.valueOf(qly.get('May__c'))+double.valueOf(qly.get('June__c'))+double.valueOf(qly.get('July__c'))+double.valueOf(qly.get('August__c'))+double.valueOf(qly.get('September__c'))+double.valueOf(qly.get('October__c'))+double.valueOf(qly.get('November__c'))+double.valueOf(qly.get('December__c'))+double.valueOf(qly.get('January__c'))+double.valueOf(qly.get('February__c'))+double.valueOf(qly.get('March__c')))*conversionRate;

                rxst.AprOthQtyLY = rxst.AprOthQtyLY+double.valueOf(qly.get('April_qty__c'));
                rxst.MayOthQtyLY = rxst.MayOthQtyLY+double.valueOf(qly.get('May_qty__c'));
                rxst.JunOthQtyLY = rxst.JunOthQtyLY+double.valueOf(qly.get('June_qty__c'));
                rxst.JulOthQtyLY = rxst.JulOthQtyLY+double.valueOf(qly.get('July_qty__c'));
                rxst.AugOthQtyLY = rxst.AugOthQtyLY+double.valueOf(qly.get('August_qty__c'));
                rxst.SepOthQtyLY = rxst.SepOthQtyLY+double.valueOf(qly.get('September_qty__c'));
                rxst.OctOthQtyLY = rxst.OctOthQtyLY+double.valueOf(qly.get('October_qty__c'));
                rxst.NovOthQtyLY = rxst.NovOthQtyLY+double.valueOf(qly.get('November_qty__c'));
                rxst.DecOthQtyLY = rxst.DecOthQtyLY+double.valueOf(qly.get('December_qty__c'));
                rxst.JanOthQtyLY = rxst.JanOthQtyLY+double.valueOf(qly.get('January_qty__c'));
                rxst.FebOthQtyLY = rxst.FebOthQtyLY+double.valueOf(qly.get('February_qty__c'));
                rxst.MarOthQtyLY = rxst.MarOthQtyLY+double.valueOf(qly.get('March_qty__c'));
                rxst.TotalOthQtyLY = rxst.TotalOthQtyLY+(double.valueOf(qly.get('April_qty__c'))+double.valueOf(qly.get('May_qty__c'))+double.valueOf(qly.get('June_qty__c'))+double.valueOf(qly.get('July_qty__c'))+double.valueOf(qly.get('August_qty__c'))+double.valueOf(qly.get('September_qty__c'))+double.valueOf(qly.get('October_qty__c'))+double.valueOf(qly.get('November_qty__c'))+double.valueOf(qly.get('December_qty__c'))+double.valueOf(qly.get('January_qty__c'))+double.valueOf(qly.get('February_qty__c'))+double.valueOf(qly.get('March_qty__c')));
            }
            
            System.debug('XXX data Sales Rx : '+rxst);
            return rxst;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    public static string getLast2MthLabel(Integer month){
        String result = '';
        try{
            switch on month{
                when 1 {result = 'Oct';}
                when 2 {result = 'Nov';}
                when 3 {result = 'Dec';}
                when 4 {result = 'Jan';}
                when 5 {result = 'Feb';}
                when 6 {result = 'Mar';}
                when 7 {result = 'Apr';}
                when 8 {result = 'May';}
                when 9 {result = 'Jun';}
                when 10 {result = 'Jul';}
                when 11 {result = 'Aug';}
                when 12 {result = 'Sep';}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static string getLast1MthLabel(Integer month){
        String result = '';
        try{
            switch on month{
                when 1 {result = 'Nov';}
                when 2 {result = 'Dec';}
                when 3 {result = 'Jan';}
                when 4 {result = 'Feb';}
                when 5 {result = 'Mar';}
                when 6 {result = 'Apr';}
                when 7 {result = 'May';}
                when 8 {result = 'Jun';}
                when 9 {result = 'Jul';}
                when 10 {result = 'Aug';}
                when 11 {result = 'Sep';}
                when 12 {result = 'Oct';}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static string getLastMthLabel(Integer month){
        String result = '';
        try{
            switch on month{
                when 1 {result = 'Dec';}
                when 2 {result = 'Jan';}
                when 3 {result = 'Feb';}
                when 4 {result = 'Mar';}
                when 5 {result = 'Apr';}
                when 6 {result = 'May';}
                when 7 {result = 'Jun';}
                when 8 {result = 'Jul';}
                when 9 {result = 'Aug';}
                when 10 {result = 'Sep';}
                when 11 {result = 'Oct';}
                when 12 {result = 'Nov';}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLast2MthVisited(TotalVisited t, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = t.OctVisited;}
                when 2 {result = t.NovVisited;}
                when 3 {result = t.DecVisited;}
                when 4 {result = t.JanVisitedLY;}
                when 5 {result = t.FebVisitedLY;}
                when 6 {result = t.MarVisitedLY;}
                when 7 {result = t.AprVisited;}
                when 8 {result = t.MayVisited;}
                when 9 {result = t.JunVisited;}
                when 10 {result = t.JulVisited;}
                when 11 {result = t.AugVisited;}
                when 12 {result = t.SepVisited;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLast1MthVisited(TotalVisited t, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = t.NovVisited;}
                when 2 {result = t.DecVisited;}
                when 3 {result = t.JanVisited;}
                when 4 {result = t.FebVisitedLY;}
                when 5 {result = t.MarVisitedLY;}
                when 6 {result = t.AprVisited;}
                when 7 {result = t.MayVisited;}
                when 8 {result = t.JunVisited;}
                when 9 {result = t.JulVisited;}
                when 10 {result = t.AugVisited;}
                when 11 {result = t.SepVisited;}
                when 12 {result = t.OctVisited;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMthVisited(TotalVisited t, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = t.DecVisited;}
                when 2 {result = t.JanVisited;}
                when 3 {result = t.FebVisited;}
                when 4 {result = t.MarVisitedLY;}
                when 5 {result = t.AprVisited;}
                when 6 {result = t.MayVisited;}
                when 7 {result = t.JunVisited;}
                when 8 {result = t.JulVisited;}
                when 9 {result = t.AugVisited;}
                when 10 {result = t.SepVisited;}
                when 11 {result = t.OctVisited;}
                when 12 {result = t.NovVisited;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLast2MthAcitveSales(ActiveDoorSales a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.OctActiveSales;}
                when 2 {result = a.NovActiveSales;}
                when 3 {result = a.DecActiveSales;}
                when 4 {result = a.JanActiveSalesLY;}
                when 5 {result = a.FebActiveSalesLY;}
                when 6 {result = a.MarActiveSalesLY;}
                when 7 {result = a.AprActiveSales;}
                when 8 {result = a.MayActiveSales;}
                when 9 {result = a.JunActiveSales;}
                when 10 {result = a.JulActiveSales;}
                when 11 {result = a.AugActiveSales;}
                when 12 {result = a.SepActiveSales;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLast1MthActiveSales(ActiveDoorSales a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.NovActiveSales;}
                when 2 {result = a.DecActiveSales;}
                when 3 {result = a.JanActiveSales;}
                when 4 {result = a.FebActiveSalesLY;}
                when 5 {result = a.MarActiveSalesLY;}
                when 6 {result = a.AprActiveSales;}
                when 7 {result = a.MayActiveSales;}
                when 8 {result = a.JunActiveSales;}
                when 9 {result = a.JulActiveSales;}
                when 10 {result = a.AugActiveSales;}
                when 11 {result = a.SepActiveSales;}
                when 12 {result = a.OctActiveSales;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMthActiveSales(ActiveDoorSales a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecActiveSales;}
                when 2 {result = a.JanActiveSales;}
                when 3 {result = a.FebActiveSales;}
                when 4 {result = a.MarActiveSalesLY;}
                when 5 {result = a.AprActiveSales;}
                when 6 {result = a.MayActiveSales;}
                when 7 {result = a.JunActiveSales;}
                when 8 {result = a.JulActiveSales;}
                when 9 {result = a.AugActiveSales;}
                when 10 {result = a.SepActiveSales;}
                when 11 {result = a.OctActiveSales;}
                when 12 {result = a.NovActiveSales;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMonthValByTargetList(UserQVSalesByTargetList u, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = u.DecVal;}
                when 2 {result = u.JanVal;}
                when 3 {result = u.FebVal;}
                when 4 {result = u.MarValLY;}
                when 5 {result = u.AprVal;}
                when 6 {result = u.MayVal;}
                when 7 {result = u.JunVal;}
                when 8 {result = u.JulVal;}
                when 9 {result = u.AugVal;}
                when 10 {result = u.SepVal;}
                when 11 {result = u.OctVal;}
                when 12 {result = u.NovVal;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMonthVolByTargetList(UserQVSalesByTargetList u, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = u.DecVol;}
                when 2 {result = u.JanVol;}
                when 3 {result = u.FebVol;}
                when 4 {result = u.MarVolLY;}
                when 5 {result = u.AprVol;}
                when 6 {result = u.MayVol;}
                when 7 {result = u.JunVol;}
                when 8 {result = u.JulVol;}
                when 9 {result = u.AugVol;}
                when 10 {result = u.SepVol;}
                when 11 {result = u.OctVol;}
                when 12 {result = u.NovVol;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMonthValByTargetListLY(UserQVSalesByTargetList u, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = u.DecValLY;}
                when 2 {result = u.JanValLY;}
                when 3 {result = u.FebValLY;}
                when 4 {result = u.MarValLYN2;}
                when 5 {result = u.AprValLY;}
                when 6 {result = u.MayValLY;}
                when 7 {result = u.JunValLY;}
                when 8 {result = u.JulValLY;}
                when 9 {result = u.AugValLY;}
                when 10 {result = u.SepValLY;}
                when 11 {result = u.OctValLY;}
                when 12 {result = u.NovValLY;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }

    public static double getLastMonthVolByTargetListLY(UserQVSalesByTargetList u, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = u.DecVolLY;}
                when 2 {result = u.JanVolLY;}
                when 3 {result = u.FebVolLY;}
                when 4 {result = u.MarVolLYN2;}
                when 5 {result = u.AprVolLY;}
                when 6 {result = u.MayVolLY;}
                when 7 {result = u.JunVolLY;}
                when 8 {result = u.JulVolLY;}
                when 9 {result = u.AugVolLY;}
                when 10 {result = u.SepVolLY;}
                when 11 {result = u.OctVolLY;}
                when 12 {result = u.NovVolLY;}
            }
        }catch(System.Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred : '+e.getMessage());
        }
        return result;
    }
    /*
    @AuraEnabled
    public static TotalVisitsBySegmA initSegmA(Id recordId){
        try {
            System.debug('XXX Start debuging for recordId : '+recordId);
            Integer year = Date.today().year();
            TotalVisitsBySegmA segA = new TotalVisitsBySegmA();
            segA.CurrYear = Integer.valueOf(year);
            segA.PrevYear = Integer.valueOf(year-1);
            segA.NextYear = Integer.valueOf(year+1);
            System.debug('XXX This year is '+segA.CurrYear+' Last Year is '+segA.PrevYear+' Next Year is '+segA.NextYear);

            
            segA.AprVisitsA1 = 0;
            AprVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (4)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AprVisitsA1){
                segA.AprVisitsA1 = segA.AprVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr visits segment A1 '+segA.AprVisitsA1);
            }

            segA.MayVisitsA1 = 0;
            MayVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (5)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:MayVisitsA1){
                segA.MayVisitsA1 = segA.MayVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX May visits segment A1 '+segA.MayVisitsA1);
            }

            segA.JunVisitsA1 = 0;
            JunVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (6)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JunVisitsA1){
                segA.JunVisitsA1 = segA.JunVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun visits segment A1 '+segA.JunVisitsA1);
            }

            segA.JulVisitsA1 = 0;
            JulVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (7)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JulVisitsA1){
                segA.JulVisitsA1 = segA.JulVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul visits segment A1 '+segA.JulVisitsA1);
            }

            segA.AugVisitsA1 = 0;
            AugVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (8)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AugVisitsA1){
                segA.AugVisitsA1 = segA.AugVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug visits segment A1 '+segA.AugVisitsA1);
            }

            segA.SepVisitsA1 = 0;
            SepVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (9)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:SepVisitsA1){
                segA.SepVisitsA1 = segA.SepVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep visits segment A1 '+segA.SepVisitsA1);
            }

            segA.OctVisitsA1 = 0;
            OctVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (10)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:OctVisitsA1){
                segA.OctVisitsA1 = segA.OctVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct visits segment A1 '+segA.OctVisitsA1);
            }

            segA.NovVisitsA1 = 0;
            NovVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (11)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:NovVisitsA1){
                segA.NovVisitsA1 = segA.NovVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov visits segment A1 '+segA.NovVisitsA1);
            }

            segA.DecVisitsA1 = 0;
            DecVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (12)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:DecVisitsA1){
                segA.DecVisitsA1 = segA.DecVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec visits segment A1 '+segA.DecVisitsA1);
            }

            segA.JanVisitsA1 = 0;
            JanVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (1)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:JanVisitsA1){
                segA.JanVisitsA1 = segA.JanVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan visits segment A1 '+segA.JanVisitsA1);
            }

            segA.FebVisitsA1 = 0;
            FebVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (2)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:FebVisitsA1){
                segA.FebVisitsA1 = segA.FebVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb visits segment A1 '+segA.FebVisitsA1);
            }

            segA.MarVisitsA1 = 0;
            MarVisitsA1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId 
                                and account__r.Segmentation_Box__c='A1' and CALENDAR_MONTH(Start_Time__c) in (3)
                                and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:MarVisitsA1){
                segA.MarVisitsA1 = segA.MarVisitsA1+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar visits segment A1 '+segA.MarVisitsA1);
            }
            
            segA.AprVisitsA2 = 0;
            AprVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AprVisitsA2){
                segA.AprVisitsA2 = segA.AprVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment A2 '+segA.AprVisitsA2);
            }

            segA.MayVisitsA2 = 0;
            MayVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:MayVisitsA2){
                segA.MayVisitsA2 = segA.MayVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment A2 '+segA.MayVisitsA2);
            }

            segA.JunVisitsA2 = 0;
            JunVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JunVisitsA2){
                segA.JunVisitsA2 = segA.JunVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment A2 '+segA.JunVisitsA2);
            }

            segA.JulVisitsA2 = 0;
            JulVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JulVisitsA2){
                segA.JulVisitsA2 = segA.JulVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment A2 '+segA.JulVisitsA2);
            }

            segA.AugVisitsA2 = 0;
            AugVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AugVisitsA2){
                segA.AugVisitsA2 = segA.AugVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment A2 '+segA.AugVisitsA2);
            }

            segA.SepVisitsA2 = 0;
            SepVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:SepVisitsA2){
                segA.SepVisitsA2 = segA.SepVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment A2 '+segA.SepVisitsA2);
            }

            segA.OctVisitsA2 = 0;
            OctVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:OctVisitsA2){
                segA.OctVisitsA2 = segA.OctVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment A2 '+segA.OctVisitsA2);
            }

            segA.NovVisitsA2 = 0;
            NovVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:NovVisitsA2){
                segA.NovVisitsA2 = segA.NovVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment A2 '+segA.NovVisitsA2);
            }

            segA.DecVisitsA2 = 0;
            DecVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:DecVisitsA2){
                segA.DecVisitsA2 = segA.DecVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment A2 '+segA.DecVisitsA2);
            }

            segA.JanVisitsA2 = 0;
            JanVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:JanVisitsA2){
                segA.JanVisitsA2 = segA.JanVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment A2 '+segA.JanVisitsA2);
            }

            segA.FebVisitsA2 = 0;
            FebVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:FebVisitsA2){
                segA.FebVisitsA2 = segA.FebVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment A2 '+segA.FebVisitsA2);
            }

            segA.MarVisitsA2 = 0;
            MarVisitsA2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A2' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:MarVisitsA2){
                segA.MarVisitsA2 = segA.MarVisitsA2+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment A2 '+segA.MarVisitsA2);
            }

            segA.AprVisitsA3 = 0;
            AprVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AprVisitsA3){
                segA.AprVisitsA3 = segA.AprVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment A3 '+segA.AprVisitsA3);
            }

            segA.MayVisitsA3 = 0;
            MayVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_YEAR(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:MayVisitsA3){
                segA.MayVisitsA3 = segA.MayVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment A3 '+segA.MayVisitsA3);
            }

            segA.JunVisitsA3 = 0;
            JunVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JunVisitsA3){
                segA.JunVisitsA3 = segA.JunVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment A3 '+segA.JunVisitsA3);
            }

            segA.JulVisitsA3 = 0;
            JulVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:JulVisitsA3){
                segA.JulVisitsA3 = segA.JulVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment A3 '+segA.JulVisitsA3);
            }

            segA.AugVisitsA3 = 0;
            AugVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:AugVisitsA3){
                segA.AugVisitsA3 = segA.AugVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment A3 '+segA.AugVisitsA3);
            }

            segA.SepVisitsA3 = 0;
            SepVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:SepVisitsA3){
                segA.SepVisitsA3 = segA.SepVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment A3 '+segA.SepVisitsA3);
            }

            segA.OctVisitsA3 = 0;
            OctVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:OctVisitsA3){
                segA.OctVisitsA3 = segA.OctVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment A3 '+segA.OctVisitsA3);
            }

            segA.NovVisitsA3 = 0;
            NovVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:NovVisitsA3){
                segA.NovVisitsA3 = segA.NovVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment A3 '+segA.NovVisitsA3);
            }

            segA.DecVisitsA3 = 0;
            DecVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:DecVisitsA3){
                segA.DecVisitsA3 = segA.DecVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment A3 '+segA.DecVisitsA3);
            }

            segA.JanVisitsA3 = 0;
            JanVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:JanVisitsA3){
                segA.JanVisitsA3 = segA.JanVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment A3 '+segA.JanVisitsA3);
            }

            segA.FebVisitsA3 = 0;
            FebVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.NextYear)];
            for(AggregateResult ar:FebVisitsA3){
                segA.FebVisitsA3 = segA.FebVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment A3 '+segA.FebVisitsA3);
            }

            segA.MarVisitsA3 = 0;
            MarVisitsA3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='A3' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segA.CurrYear)];
            for(AggregateResult ar:MarVisitsA3){
                segA.MarVisitsA3 = segA.MarVisitsA3+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment A3 '+segA.MarVisitsA3);
            }

            return segA;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        
    }*/
    /** ============== END OF SEGMENTATION A : TOTOAL VISITS =========================== */
    /** ============== START OF TOTAL VISITS SEGMENTATION B ============================ */
    /*
    @AuraEnabled
    public static TotalVisitsBySegmB initSegmB(Id recordId){
        try {
                
            System.debug('XXX Start debuging for recordId : '+recordId);
            Integer year = Date.today().year();
            TotalVisitsBySegmB segB = new TotalVisitsBySegmB();
            segB.CurrYear = Integer.valueOf(year);
            segB.PrevYear = Integer.valueOf(year-1);
            segB.NextYear = Integer.valueOf(year+1);
            System.debug('XXX This year is '+segB.CurrYear+' Last Year is '+segB.PrevYear+' Next Year is '+segB.NextYear);
                
            segB.AprVisitsB1 = 0;
            AprVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AprVisitsB1){
                segB.AprVisitsB1 = segB.AprVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment B1 '+segB.AprVisitsB1);
            }

            segB.MayVisitsB1 = 0;
            MayVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:MayVisitsB1){
                segB.MayVisitsB1 = segB.MayVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment B1 '+segB.MayVisitsB1);
            }

            segB.JunVisitsB1 = 0;
            JunVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AprVisitsB1){
                segB.JunVisitsB1 = segB.JunVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment B1 '+segB.JunVisitsB1);
            }

            segB.JulVisitsB1 = 0;
            JulVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:JulVisitsB1){
                segB.JulVisitsB1 = segB.JulVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment B1 '+segB.JulVisitsB1);
            }

            segB.AugVisitsB1 = 0;
            AugVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AugVisitsB1){
                segB.AugVisitsB1 = segB.AugVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment B1 '+segB.AugVisitsB1);
            }

            segB.SepVisitsB1 = 0;
            SepVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:SepVisitsB1){
                segB.SepVisitsB1 = segB.SepVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment B1 '+segB.SepVisitsB1);
            }

            segB.OctVisitsB1 = 0;
            OctVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:OctVisitsB1){
                segB.OctVisitsB1 = segB.OctVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment B1 '+segB.OctVisitsB1);
            }

            segB.NovVisitsB1 = 0;
            NovVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:NovVisitsB1){
                segB.NovVisitsB1 = segB.NovVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment B1 '+segB.NovVisitsB1);
            }

            segB.DecVisitsB1 = 0;
            DecVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:DecVisitsB1){
                segB.DecVisitsB1 = segB.DecVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment B1 '+segB.DecVisitsB1);
            }

            segB.JanVisitsB1 = 0;
            JanVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:JanVisitsB1){
                segB.JanVisitsB1 = segB.JanVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment B1 '+segB.JanVisitsB1);
            }

            segB.FebVisitsB1 = 0;
            FebVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:FebVisitsB1){
                segB.FebVisitsB1 = segB.FebVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment B1 '+segB.FebVisitsB1);
            }

            segB.MarVisitsB1 = 0;
            MarVisitsB1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B1' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:MarVisitsB1){
                segB.MarVisitsB1 = segB.MarVisitsB1+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment B1 '+segB.MarVisitsB1);
            }

            segB.AprVisitsB2 = 0;
            AprVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AprVisitsB2){
                segB.AprVisitsB2 = segB.AprVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment B2 '+segB.AprVisitsB2);
            }

            segB.MayVisitsB2 = 0;
            MayVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:MayVisitsB2){
                segB.MayVisitsB2 = segB.MayVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment B2 '+segB.MayVisitsB2);
            }

            segB.JunVisitsB2 = 0;
            JunVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:JunVisitsB2){
                segB.JunVisitsB2 = segB.JunVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment B2 '+segB.JunVisitsB2);
            }

            segB.JulVisitsB2 = 0;
            JulVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:JulVisitsB2){
                segB.JulVisitsB2 = segB.JulVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment B2 '+segB.JulVisitsB2);
            }

            segB.AugVisitsB2 = 0;
            AugVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AugVisitsB2){
                segB.AugVisitsB2 = segB.AugVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment B2 '+segB.AugVisitsB2);
            }

            segB.SepVisitsB2 = 0;
            SepVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:SepVisitsB2){
                segB.SepVisitsB2 = segB.SepVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment B2 '+segB.SepVisitsB2);
            }

            segB.OctVisitsB2 = 0;
            OctVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:OctVisitsB2){
                segB.OctVisitsB2 = segB.OctVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment B2 '+segB.OctVisitsB2);
            }

            segB.NovVisitsB2 = 0;
            NovVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:NovVisitsB2){
                segB.NovVisitsB2 = segB.AprVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment B2 '+segB.NovVisitsB2);
            }

            segB.DecVisitsB2 = 0;
            DecVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:DecVisitsB2){
                segB.DecVisitsB2 = segB.DecVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment B2 '+segB.DecVisitsB2);
            }

            segB.JanVisitsB2 = 0;
            JanVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:JanVisitsB2){
                segB.JanVisitsB2 = segB.JanVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment B2 '+segB.JanVisitsB2);
            }

            segB.FebVisitsB2 = 0;
            FebVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:FebVisitsB2){
                segB.FebVisitsB2 = segB.FebVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment B2 '+segB.FebVisitsB2);
            }

            segB.MarVisitsB2 = 0;
            MarVisitsB2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B2' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:MarVisitsB2){
                segB.MarVisitsB2 = segB.MarVisitsB2+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment B2 '+segB.MarVisitsB2);
            }

            segB.AprVisitsB3 = 0;
            AprVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AprVisitsB3){
                segB.AprVisitsB3 = segB.AprVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment B3 '+segB.AprVisitsB3);
            }

            segB.MayVisitsB3 = 0;
            MayVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:MayVisitsB3){
                segB.MayVisitsB3 = segB.MayVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment B3 '+segB.MayVisitsB3);
            }
                
            segB.JunVisitsB3 = 0;
            JunVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:JunVisitsB3){
                segB.JunVisitsB3 = segB.JunVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment B3 '+segB.JunVisitsB3);
            }

            segB.JulVisitsB3 = 0;
            JulVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:JulVisitsB3){
                segB.JulVisitsB3 = segB.JulVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment B3 '+segB.JulVisitsB3);
            }

            segB.AugVisitsB3 = 0;
            AugVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:AugVisitsB3){
                segB.AugVisitsB3 = segB.AugVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment B3 '+segB.AugVisitsB3);
            }

            segB.SepVisitsB3 = 0;
            SepVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:SepVisitsB3){
                segB.SepVisitsB3 = segB.SepVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment B3 '+segB.SepVisitsB3);
            }

            segB.OctVisitsB3 = 0;
            OctVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:OctVisitsB3){
                segB.OctVisitsB3 = segB.OctVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment B3 '+segB.OctVisitsB3);
            }

            segB.NovVisitsB3 = 0;
            NovVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:SepVisitsB3){
                segB.NovVisitsB3 = segB.NovVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment B3 '+segB.NovVisitsB3);
            }

            segB.DecVisitsB3 = 0;
            DecVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.CurrYear)];
                
            for(AggregateResult ar:DecVisitsB3){
                segB.DecVisitsB3 = segB.DecVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment B3 '+segB.DecVisitsB3);
            }

            segB.JanVisitsB3 = 0;
            JanVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:JanVisitsB3){
                segB.JanVisitsB3 = segB.JanVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment B3 '+segB.JanVisitsB3);
            }

            segB.FebVisitsB3 = 0;
            FebVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:FebVisitsB3){
                segB.FebVisitsB3 = segB.FebVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment B3 '+segB.FebVisitsB3);
            }

            segB.MarVisitsB3 = 0;
            MarVisitsB3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='B3' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segB.NextYear)];
                
            for(AggregateResult ar:MarVisitsB3){
                segB.MarVisitsB3 = segB.MarVisitsB3+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment B3 '+segB.MarVisitsB3);
            }
                
            return segB;

        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    /** =============== END OF CLASS B ================ */
    /** =============== START PUBLIC CLASS FOR C =========== */
    /*
    @AuraEnabled
    public static TotalVisitsBySegmC initSegmC(Id recordId){
        try {
                 
            System.debug('XXX Start debuging for recordId : '+recordId);
            Integer year = Date.today().year();
            TotalVisitsBySegmC segC = new TotalVisitsBySegmC();
            segC.CurrYear = Integer.valueOf(year);
            segC.PrevYear = Integer.valueOf(year-1);
            segC.NextYear = Integer.valueOf(year+1);
            System.debug('XXX This year is '+segC.CurrYear+' Last Year is '+segC.PrevYear+' Next Year is '+segC.NextYear);
            
            segC.AprVisitsC1 = 0;
            AprVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AprVisitsC1){
                segC.AprVisitsC1 = segC.AprVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment C1 '+segC.AprVisitsC1);
            }

            segC.MayVisitsC1 = 0;
            MayVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:MayVisitsC1){
                segC.MayVisitsC1 = segC.MayVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment C1 '+segC.MayVisitsC1);
            }

            segC.JunVisitsC1 = 0;
            JunVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JunVisitsC1){
                segC.JunVisitsC1 = segC.JunVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment C1 '+segC.JunVisitsC1);
            }

            segC.JulVisitsC1 = 0;
            JulVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JulVisitsC1){
                segC.JulVisitsC1 = segC.JulVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment C1 '+segC.JulVisitsC1);
            }

            segC.AugVisitsC1 = 0;
            AugVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AugVisitsC1){
                segC.AugVisitsC1 = segC.AugVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment C1 '+segC.AugVisitsC1);
            }

            segC.SepVisitsC1 = 0;
            SepVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:SepVisitsC1){
                segC.SepVisitsC1 = segC.SepVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment C1 '+segC.SepVisitsC1);
            }

            segC.OctVisitsC1 = 0;
            OctVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:OctVisitsC1){
                segC.OctVisitsC1 = segC.OctVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment C1 '+segC.OctVisitsC1);
            }

            segC.NovVisitsC1 = 0;
            NovVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:NovVisitsC1){
                segC.NovVisitsC1 = segC.NovVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment C1 '+segC.NovVisitsC1);
            }

            segC.DecVisitsC1 = 0;
            DecVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:DecVisitsC1){
                segC.DecVisitsC1 = segC.DecVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment C1 '+segC.DecVisitsC1);
            }

            segC.JanVisitsC1 = 0;
            JanVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:JanVisitsC1){
                segC.JanVisitsC1 = segC.JanVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment C1 '+segC.JanVisitsC1);
            }

            segC.FebVisitsC1 = 0;
            FebVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:FebVisitsC1){
                segC.FebVisitsC1 = segC.FebVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment C1 '+segC.FebVisitsC1);
            }

            segC.MarVisitsC1 = 0;
            MarVisitsC1 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C1' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:MarVisitsC1){
                segC.MarVisitsC1 = segC.MarVisitsC1+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment C1 '+segC.MarVisitsC1);
            }

            segC.AprVisitsC2 = 0;
            AprVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AprVisitsC2){
                segC.AprVisitsC2 = segC.AprVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment C2 '+segC.AprVisitsC2);
            }

            segC.MayVisitsC2 = 0;
            MayVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:MayVisitsC2){
                segC.MayVisitsC2 = segC.MayVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment C2 '+segC.MayVisitsC2);
            }

            segC.JunVisitsC2 = 0;
            JunVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JunVisitsC2){
                segC.JunVisitsC2 = segC.JunVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment C2 '+segC.JunVisitsC2);
            }

            segC.JulVisitsC2 = 0;
            JulVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JulVisitsC2){
                segC.JulVisitsC2 = segC.JulVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment C2 '+segC.JulVisitsC2);
            }

            segC.AugVisitsC2 = 0;
            AugVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AugVisitsC2){
                segC.AugVisitsC2 = segC.AugVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment C2 '+segC.AugVisitsC2);
            }

            segC.SepVisitsC2 = 0;
            SepVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:SepVisitsC2){
                segC.SepVisitsC2 = segC.SepVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment C2 '+segC.SepVisitsC2);
            }

            segC.OctVisitsC2 = 0;
            OctVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:OctVisitsC2){
                segC.OctVisitsC2 = segC.OctVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment C2 '+segC.OctVisitsC2);
            }

            segC.NovVisitsC2 = 0;
            NovVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:NovVisitsC2){
                segC.NovVisitsC2 = segC.NovVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment C2 '+segC.NovVisitsC2);
            }

            segC.DecVisitsC2 = 0;
            DecVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:DecVisitsC2){
                segC.DecVisitsC2 = segC.DecVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment C2 '+segC.DecVisitsC2);
            }

            segC.JanVisitsC2 = 0;
            JanVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:JanVisitsC2){
                segC.JanVisitsC2 = segC.JanVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment C2 '+segC.JanVisitsC2);
            }

            segC.FebVisitsC2 = 0;
            FebVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:FebVisitsC2){
                segC.FebVisitsC2 = segC.FebVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment C2 '+segC.FebVisitsC2);
            }

            segC.MarVisitsC2 = 0;
            MarVisitsC2 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C2' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:MarVisitsC2){
                segC.MarVisitsC2 = segC.MarVisitsC2+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment C2 '+segC.MarVisitsC2);
            }

            segC.AprVisitsC3 = 0;
            AprVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (4)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AprVisitsC3){
                segC.AprVisitsC3 = segC.AprVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits segment C3 '+segC.AprVisitsC3);
            }

            segC.MayVisitsC3 = 0;
            MayVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (5)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:MayVisitsC3){
                segC.MayVisitsC3 = segC.MayVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits segment C3 '+segC.MayVisitsC3);
            }

            segC.JunVisitsC3 = 0;
            JunVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (6)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JunVisitsC3){
                segC.JunVisitsC3 = segC.JunVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits segment C3 '+segC.JunVisitsC3);
            }

            segC.JulVisitsC3 = 0;
            JulVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (7)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:JulVisitsC3){
                segC.JulVisitsC3 = segC.JulVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits segment C3 '+segC.JulVisitsC3);
            }

            segC.AugVisitsC3 = 0;
            AugVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (8)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:AugVisitsC3){
                segC.AugVisitsC3 = segC.AugVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits segment C3 '+segC.AugVisitsC3);
            }

            segC.SepVisitsC3 = 0;
            SepVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (9)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:SepVisitsC3){
                segC.SepVisitsC3 = segC.SepVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits segment C3 '+segC.SepVisitsC3);
            }

            segC.OctVisitsC3 = 0;
            OctVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (10)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:OctVisitsC3){
                segC.OctVisitsC3 = segC.OctVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits segment C3 '+segC.OctVisitsC3);
            }

            segC.NovVisitsC3 = 0;
            NovVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (11)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:NovVisitsC3){
                segC.NovVisitsC3 = segC.NovVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits segment C3 '+segC.NovVisitsC3);
            }

            segC.DecVisitsC3 = 0;
            DecVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (12)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.CurrYear)];
                
            for(AggregateResult ar:DecVisitsC3){
                segC.DecVisitsC3 = segC.DecVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits segment C3 '+segC.DecVisitsC3);
            }

            segC.JanVisitsC3 = 0;
            JanVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (1)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:JanVisitsC3){
                segC.JanVisitsC3 = segC.JanVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits segment C3 '+segC.JanVisitsC3);
            }

            segC.FebVisitsC3 = 0;
            FebVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (2)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:FebVisitsC3){
                segC.FebVisitsC3 = segC.FebVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits segment C3 '+segC.FebVisitsC3);
            }

            segC.MarVisitsC3 = 0;
            MarVisitsC3 = [select count(id) visits from visits__c where assigned_to__r.id=:recordId
                            and account__r.Segmentation_Box__c='C3' and CALENDAR_MONTH(Start_Time__c) in (3)
                            and CALENDAR_MONTH(Start_Time__c) in (:segC.NextYear)];
                
            for(AggregateResult ar:MarVisitsC3){
                segC.MarVisitsC3 = segC.MarVisitsC3+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits segment C3 '+segC.MarVisitsC3);
            }

            return segC;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    /** ============== END OF CLASS SEGMENTATION A B C CLASS OF SEGMENTATION ================== */
    /**=============== Start class for Completed Visits ======================================= */
    @AuraEnabled
    public static TotalVisited getTotalVisited(Id recordId){
        try {
            Integer year = Date.today().year();
            Integer month = Date.today().month();

            String userCompany = [select companyName from User where Id=:recordId].companyName;
            System.debug('XXX Get User Company Name == > '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            TotalVisited visited = new TotalVisited();
            visited.CurrFY = Integer.valueOf(year);
            visited.PrevFY = Integer.valueOf(year-1);
            visited.NextFY = Integer.valueOf(year+1);

            System.debug('XXX Get Integer of year for calendar month == > This year : '+visited.CurrFY+' Last Year : '+visited.PrevFY+' Next Year : '+visited.NextFY);
            visited.AprVisited = 0;
            AprVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (4) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];

            for(AggregateResult ar:AprVisited){
                visited.AprVisited = visited.AprVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited April == > '+visited.AprVisited);
            }

            visited.MayVisited = 0;
            MayVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (5) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:MayVisited){
                visited.MayVisited = visited.MayVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited May == > '+visited.MayVisited);
            }

            visited.JunVisited = 0;
            JunVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (6) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar : JunVisited){
                visited.JunVisited = visited.JunVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited June == > '+visited.JunVisited);
            }

            visited.JulVisited = 0;
            JulVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (7) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:JulVisited){
                visited.JulVisited = visited.JulVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited July == > '+visited.JulVisited);
            }

            visited.AugVisited = 0;
            AugVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (8) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:AugVisited){
                visited.AugVisited = visited.AugVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited August == > '+visited.AugVisited);
            }

            visited.SepVisited = 0;
            SepVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (9) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:SepVisited){
                visited.SepVisited = visited.SepVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited September == > '+visited.SepVisited);
            }

            visited.OctVisited = 0;
            OctVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (10) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:OctVisited){
                visited.OctVisited = visited.OctVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited October == >'+visited.OctVisited);
            }
            visited.NovVisited = 0;
            NovVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (11) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:NovVisited){
                visited.NovVisited = visited.NovVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited November == > '+visited.NovVisited);
            }
            visited.DecVisited = 0;
            DecVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (12) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:DecVisited){
                visited.DecVisited = visited.DecVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited December == >'+visited.DecVisited);
            }
            visited.JanVisited = 0;
            JanVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (1) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.NextFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:JanVisited){
                visited.JanVisited = visited.JanVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited January == > '+visited.JanVisited);
            }
            visited.FebVisited = 0;
            FebVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (2) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.NextFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:FebVisited){
                visited.FebVisited = visited.FebVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited February == > '+visited.FebVisited);
            }
            visited.MarVisited = 0;
            MarVisited = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (3) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.NextFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:MarVisited){
                visited.MarVisited = visited.MarVisited+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited March == > '+visited.MarVisited);
            }

            visited.AprVisitedLY = 0;
            AprVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (4) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:AprVisitedLY){
                visited.AprVisitedLY = visited.AprVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited April Last FY == > '+visited.AprVisitedLY);
            }

            visited.MayVisitedLY = 0;
            MayVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (5) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar : MayVisitedLY){
                visited.MayVisitedLY = visited.MayVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited May Last FY == > '+visited.MayVisitedLY);
            }

            visited.JunVisitedLY = 0;
            JunVisitedLY = [select count(id) visited from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (6) 
                                and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                                and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:JunVisitedLY){
                visited.JunVisitedLY = visited.JunVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited June Last FY == > '+visited.JunVisitedLY);
            }

            visited.JulVisitedLY = 0;
            JulVisitedLY = [select count(id) visited from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (7) 
                                and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                                and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar : JulVisitedLY){
                visited.JulVisitedLY = visited.JulVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited July Last FY == > '+visited.JulVisitedLY);
            }

            visited.AugVisitedLY = 0;
            AugVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (8) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:AugVisitedLY){
                visited.AugVisitedLY = visited.AugVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited August Last FY == > '+visited.AugVisitedLY);
            }

            visited.SepVisitedLY = 0;
            SepVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (9) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:SepVisitedLY){
                visited.SepVisitedLY = visited.SepVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited September Last FY == >'+visited.SepVisitedLY);
            }
            visited.OctVisitedLY = 0;
            OctVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (10) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:OctVisitedLY){
                visited.OctVisitedLY = visited.OctVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited October Last FY == >'+visited.OctVisitedLY);
            }

            visited.NovVisitedLY = 0;
            NovVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (11) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:NovVisitedLY){
                visited.NovVisitedLY = visited.NovVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited November Last FY == >'+visited.NovVisitedLY);
            }

            visited.DecVisitedLY = 0;
            DecVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (12) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.PrevFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:DecVisitedLY){
                visited.DecVisitedLY = visited.DecVisitedLY + double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited December Last FY == >'+visited.DecVisitedLY);
            }

            visited.JanVisitedLY = 0;
            JanVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (1) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:JanVisitedLY){
                visited.JanVisitedLY = visited.JanVisitedLY+double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited January Last FY == > '+visited.JanVisitedLY);
            }

            visited.FebVisitedLY = 0;
            FebVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (2) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:FebVisitedLY){
                visited.FebVisitedLY = visited.FebVisitedLY + double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited February Last FY == >'+visited.FebVisitedLY);
            }

            visited.MarVisitedLY = 0;
            MarVisitedLY = [select count(id) visited from visits__c 
                            where CALENDAR_MONTH(Start_time__c) in (3) 
                            and CALENDAR_YEAR(Start_time__c) in (:visited.CurrFY) 
                            and Assigned_to__c=:recordId and Visit_Status__c='Complete'];
            for(AggregateResult ar:MarVisitedLY){
                visited.MarVisitedLY = visited.MarVisitedLY + double.valueOf(ar.get('visited'));
                System.debug('XXX Get Complete Visited March Last FY == > '+visited.MarVisitedLY);
            }
            visited.Last2MthLabel = getLast2MthLabel(month);
            System.debug('XXX Get Last 3 Month Label == > '+visited.Last2MthLabel);

            visited.Last1MthLabel = getLast1MthLabel(month);
            System.debug('XXX Get Last 2 Month Label == > '+visited.Last1MthLabel);

            visited.LastMthLabel = getLastMthLabel(month);
            System.debug('XXX Get Last Month Label == > '+visited.LastMthLabel);

            visited.Last2MthVisited = getLast2MthVisited(visited, month);
            System.debug('XXX Get Last 3 Month Complete Visited == > '+visited.Last2MthVisited);

            visited.Last1MthVisited = getLast1MthVisited(visited, month);
            System.debug('XXX Get Last 2 Month Complete Visited == > '+visited.Last1MthVisited);

            visited.LastMthVisited = getLastMthVisited(visited, month);
            System.debug('XXX Get Last Month Complete Visited == > '+visited.LastMthVisited);

            System.debug('XXX Get all completed visited == > '+visited);
            return visited;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static TotalVisits initTotalVisits(Id recordId){
        try {
            System.debug('XXX Start Debug for record Id : '+recordId);
            Integer year = Date.today().year();
            Integer month = Date.today().month();

            String userCompany = [select companyName from User where Id=:recordId].companyName;
            System.debug('User Company Name is '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            TotalVisits visit = new TotalVisits();
            visit.CurrYear = Integer.valueOf(year);
            visit.NextYear = Integer.valueOf(year+1);
            visit.PrevYear = Integer.valueOf(year-1);
            System.debug('XXX This Fiscal Year is '+visit.CurrYear+' and Next Fiscal Year is '+visit.NextYear+' Last Fiscal Year is '+visit.PrevYear);
            //need to add visits status = Complete and visit type = visit for all of query component
            visit.AprTotalVisits = 0;
            AprTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (4) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : AprTotalsVisit){
                visit.AprTotalVisits = visit.AprTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits '+visit.AprTotalVisits);
            }

            visit.MayTotalVisits = 0;
            MayTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (5) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : MayTotalsVisit){
                visit.MayTotalVisits = visit.MayTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits '+visit.MayTotalVisits);
            }

            visit.JunTotalVisits = 0;
            JunTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (6) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : JunTotalsVisit){
                visit.JunTotalVisits = visit.JunTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits '+visit.JunTotalVisits);
            }
            
            visit.JulTotalVisits = 0;
            JulTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (7) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : JulTotalsVisit){
                visit.JulTotalVisits = visit.JulTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits '+visit.JulTotalVisits);
            }

            visit.AugTotalVisits = 0;
            AugTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (8) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : AugTotalsVisit){
                visit.AugTotalVisits = visit.AugTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits '+visit.AugTotalVisits);
            }

            visit.SepTotalVisits = 0;
            SepTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (9) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : SepTotalsVisit){
                visit.SepTotalVisits = visit.SepTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits '+visit.SepTotalVisits);
            }

            visit.OctTotalVisits = 0;
            OctTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (10) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : OctTotalsVisit){
                visit.OctTotalVisits = visit.OctTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits '+visit.OctTotalVisits);
            }

            visit.NovTotalVisits = 0;
            NovTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (11) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : NovTotalsVisit){
                visit.NovTotalVisits = visit.NovTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits '+visit.NovTotalVisits);
            }

            visit.DecTotalVisits = 0;
            DecTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (12) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.CurrYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : DecTotalsVisit){
                visit.DecTotalVisits = visit.DecTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits '+visit.DecTotalVisits);
            }

            visit.JanTotalVisits = 0;
            JanTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (1) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.NextYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : JanTotalsVisit){
                visit.JanTotalVisits = visit.JanTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits '+visit.JanTotalVisits);
            }

            visit.FebTotalVisits = 0;
            FebTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (2) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.NextYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : FebTotalsVisit){
                visit.FebTotalVisits = visit.FebTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits '+visit.FebTotalVisits);
            }

            visit.MarTotalVisits = 0;
            MarTotalsVisit = [select count(id) visits from visits__c 
                                where CALENDAR_MONTH(Start_time__c) in (3) 
                                and CALENDAR_YEAR(Start_time__c) in (:visit.NextYear) 
                                and assigned_to__r.Id =:recordId and Visit_Status__c='Complete'
                                and Visit_Type__c='Visit'];
            for(AggregateResult ar : MarTotalsVisit){
                visit.MarTotalVisits = visit.MarTotalVisits+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits '+visit.MarTotalVisits);
            }

            visit.AprTotalVisitsLY = 0;
            AprTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (4)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : AprTotalsVisitLY){
                visit.AprTotalVisitsLY = visit.AprTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Apr Visits Last Year '+visit.AprTotalVisitsLY);
            }

            visit.MayTotalVisitsLY = 0;
            MayTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (5)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : MayTotalsVisitLY){
                visit.MayTotalVisitsLY = visit.MayTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX May Visits Last Year '+visit.MayTotalVisitsLY);
            }

            visit.JunTotalVisitsLY = 0;
            JunTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (6)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : JunTotalsVisitLY){
                visit.JunTotalVisitsLY = visit.JunTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Jun Visits Last Year '+visit.JunTotalVisitsLY);
            }

            visit.JulTotalVisitsLY = 0;
            JulTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (7)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : JulTotalsVisitLY){
                visit.JulTotalVisitsLY = visit.JulTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Jul Visits Last Year '+visit.JulTotalVisitsLY);
            }

            visit.AugTotalVisitsLY = 0;
            AugTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (8)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : AugTotalsVisitLY){
                visit.AugTotalVisitsLY = visit.AugTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Aug Visits Last Year '+visit.AugTotalVisitsLY);
            }

            visit.SepTotalVisitsLY = 0;
            SepTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (9)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : SepTotalsVisitLY){
                visit.SepTotalVisitsLY = visit.SepTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Sep Visits Last Year '+visit.SepTotalVisitsLY);
            }

            visit.OctTotalVisitsLY = 0;
            OctTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (10)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : OctTotalsVisitLY){
                visit.OctTotalVisitsLY = visit.OctTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Oct Visits Last Year '+visit.OctTotalVisitsLY);
            }

            visit.NovTotalVisitsLY = 0;
            NovTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (11)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : NovTotalsVisitLY){
                visit.NovTotalVisitsLY = visit.NovTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Nov Visits Last Year '+visit.NovTotalVisitsLY);
            }
            
            visit.DecTotalVisitsLY = 0;
            DecTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (12)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.PrevYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : DecTotalsVisitLY){
                visit.DecTotalVisitsLY = visit.DecTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Dec Visits Last Year '+visit.DecTotalVisitsLY);
            }

            visit.JanTotalVisitsLY = 0;
            JanTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (1)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.CurrYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : JanTotalsVisitLY){
                visit.JanTotalVisitsLY = visit.JanTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Jan Visits Last Year '+visit.JanTotalVisitsLY);
            }

            visit.FebTotalVisitsLY = 0;
            FebTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (2)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.CurrYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : FebTotalsVisitLY){
                visit.FebTotalVisitsLY = visit.FebTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Feb Visits Last Year '+visit.FebTotalVisitsLY);
            }

            visit.MarTotalVisitsLY = 0;
            MarTotalsVisitLY = [select count(id) visits from visits__c 
                                    where CALENDAR_MONTH(Start_Time__c) in (3)
                                    and CALENDAR_YEAR(Start_Time__c) in (:visit.CurrYear)
                                    and assigned_to__r.Id=:recordId and Visit_Status__c='Complete'
                                    and Visit_Type__c='Visit'];
            for(AggregateResult ar : MarTotalsVisitLY){
                visit.MarTotalVisitsLY = visit.MarTotalVisitsLY+double.valueOf(ar.get('visits'));
                System.debug('XXX Mar Visits Last Year '+visit.MarTotalVisitsLY);
            }
            visit.TotalTotalVisits = double.valueOf(visit.AprTotalVisits)+double.valueOf(visit.MayTotalVisits)+double.valueOf(visit.JunTotalVisits)+double.valueOf(visit.JulTotalVisits)+double.valueOf(visit.AugTotalVisits)+double.valueOf(visit.SepTotalVisits)+double.valueOf(visit.OctTotalVisits)+double.valueOf(visit.NovTotalVisits)+double.valueOf(visit.DecTotalVisits)+double.valueOf(visit.JanTotalVisits)+double.valueOf(visit.FebTotalVisits)+double.valueOf(visit.MarTotalVisits);
            visit.TotalTotalVisitsLY = double.valueOf(visit.AprTotalVisitsLY)+double.valueOf(visit.MayTotalVisitsLY)+double.valueOf(visit.JunTotalVisitsLY)+double.valueOf(visit.JulTotalVisitsLY)+double.valueOf(visit.AugTotalVisitsLY)+double.valueOf(visit.SepTotalVisitsLY)+double.valueOf(visit.OctTotalVisitsLY)+double.valueOf(visit.NovTotalVisitsLY)+double.valueOf(visit.DecTotalVisitsLY)+double.valueOf(visit.JanTotalVisitsLY)+double.valueOf(visit.FebTotalVisitsLY)+double.valueOf(visit.MarTotalVisitsLY);
            System.debug('XXX Total Visit Current FY : '+visit.TotalTotalVisits+' Total Visit Last FY '+visit.TotalTotalVisitsLY);

            System.debug('XXX Get Visit Counting == >'+visit);
            return visit;
            /** ======== END OF CLASS FOR VISIT COUNTING IN MONTHLY TRENDS ============ */
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static AccountUser initUserSales(Id recordId){
        /*
        System.debug('User record Id is '+recordId);

        Map<Id, User> userList = new Map<Id, User>([SELECT Id, Name from User WHERE Id=:recordId]);
        System.debug('Map Id with user Id recordId is '+userList);

        AccountUser accountUser = new AccountUser();
        accountUser.budget = [SELECT Id, Name, LookupUser__c, CurrencyIsoCode, Quota1CY__c, Quota2CY__c, 
                                Quota3CY__c, Quota4CY__c, Quota5CY__c, Quota6CY__c, Quota7CY__c, Quota8CY__c, Quota9CY__c, 
                                Quota10CY__c, Quota11CY__c, Quota12CY__c, Quota_SumCY__c, Qu1LY__c, Qu2LY__c, Qu3LY__c,
                                Qu4LY__c, Qu5LY__c, Qu6LY__c, Qu7LY__c, Qu8LY__c, Qu9LY__c, Qu10LY__c, Qu11LY__c, Qu12LY__c,
                                Visit_KPI__r.Visits_completed__c, Visit_KPI__r.Individual_Days_in_Field__c
                                FROM Budget_by_ASM__c 
                            WHERE LookupUser__c=:recordId LIMIT 1];

        System.debug('Get data from Budget_by_asm__c with Id: '+accountUser.budget.Id+' Quota Apr '+accountUser.budget.Quota1CY__c+' and user Id (owner) is '+accountUser.budget.LookupUser__c);
        
        String userCurrency = UserInfo.getDefaultCurrency();
        String userCompany = [select Id, companyName from User where id=:UserInfo.getUserId()].companyName;
        originalConversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
        conversionRate = [select conversionrate from currencytype where isocode=:userCurrency].conversionRate;
        conversionRateUSD = [select conversionrate from currencytype where isocode='USD'].conversionrate;
        String budgetCurrency = [select currencyIsoCode from Budget_by_ASM__c where LookupUser__c=:recordId limit 1].currencyIsoCode;
        userConversionRate = [select conversionrate from currencytype where isocode=:budgetCurrency].conversionRate;
        
        String CompanyCurrency = [select Id, CurrencyIsoCode from User where Id=:UserInfo.getUserId()].CurrencyIsoCode;
        System.debug('CompanyCurrency Iso Code '+CompanyCurrency);

        if(conversionRate==userConversionRate){userConversionRate=1;}
        if(userCurrency!='EUR' && budgetCurrency!='EUR'){userConversionRate=1;conversionRate=1;}
        if(userCurrency == budgetCurrency){
            userConversionRate = 1;
            conversionRate = 1;
        }

        System.debug('Get Conversion Rate : '+conversionRate+' | Get User Conversion Rate : '+userConversionRate+' | Get User Currency : '+userCurrency+' | Get Original Conversion Rate : '+originalConversionRate+' | Get Budget Currency : '+budgetCurrency);
        
        Double conversionSeg1 = (originalConversionRate/conversionRateUSD)*0.1;
        System.debug('XXX Get Data for convert to USD 0.1 Value '+conversionSeg1+' : '+userCurrency);

        Double conversionSeg2 = (originalConversionRate/conversionRateUSD)*500;
        System.debug('XXX Get Data for convert to USD 500 Value '+conversionSeg2+' : '+userCurrency);
        
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        //Integer years = Date.today().year();

        //fiscal year is current year-1 from january to march, year from april to december
        if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
            year = year-1;
        }

        accountUser.CurrFY = 'FY-' + String.valueOf(year).substring(2);
        accountUser.PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        accountUser.CurFY = String.valueOf(year);
        accountUser.NextFY = String.valueOf(year+1);
        accountUser.CurrYear = Integer.valueOf(year);
        accountUser.LastYear = Integer.valueOf(year-1);
        accountUser.NextYear = Integer.valueOf(year+1);
        
        System.debug('Get data for Current Fiscal year '+accountUser.CurrFY+'/'+' last fiscal year: '+accountUser.PrevFY);
        System.debug('Get data for Current Fiscal Year / For Visit KPI '+accountUser.CurFY);
        */
        /**===================================================== */
        String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId LIMIT 1].DefaultCurrencyIsoCode;
        conversionRate = [SELECT conversionRate FROM CurrencyType WHERE isocode=:userCurrency LIMIT 1].conversionRate;

        AccountUser accountUser = new AccountUser();
        accountUser.getConversionRate = conversionRate;
        System.debug('XXX Get Conversion Rate from User Record ID : '+accountUser.getConversionRate);

        accountUser.QuoApr = 0;
        accountUser.QuoMay = 0;
        accountUser.QuoJun = 0;
        accountUser.QuoJul = 0;
        accountUser.QuoAug = 0;
        accountUser.QuoSep = 0;
        accountUser.QuoOct = 0;
        accountUser.QuoNov = 0;
        accountUser.QuoDec = 0;
        accountUser.QuoJan = 0;
        accountUser.QuoFeb = 0;
        accountUser.QuoMar = 0;

        accountUser.AprSales = 0;
        accountUser.MaySales = 0;
        accountUser.JunSales = 0;
        accountUser.JulSales = 0;
        accountUser.AugSales = 0;
        accountUser.SepSales = 0;
        accountUser.OctSales = 0;
        accountUser.NovSales = 0;
        accountUser.DecSales = 0;
        accountUser.JanSales = 0;
        accountUser.FebSales = 0;
        accountUser.MarSales = 0;

        accountUser.QuoAprLY = 0;
        accountUser.QuoMayLY = 0;
        accountUser.QuoJunLY = 0;
        accountUser.QuoJulLY = 0;
        accountUser.QuoAugLY = 0;
        accountUser.QuoSepLY = 0;
        accountUser.QuoOctLY = 0;
        accountUser.QuoNovLY = 0;
        accountUser.QuoDecLY = 0;
        accountUser.QuoJanLY = 0;
        accountUser.QuoFebLY = 0;
        accountUser.QuoMarLY = 0;

        accountUser.AprSalesLY = 0;
        accountUser.MaySalesLY = 0;
        accountUser.JunSalesLY = 0;
        accountUser.JulSalesLY = 0;
        accountUser.AugSalesLY = 0;
        accountUser.SepSalesLY = 0;
        accountUser.OctSalesLY = 0;
        accountUser.NovSalesLY = 0;
        accountUser.DecSalesLY = 0;
        accountUser.JanSalesLY = 0;
        accountUser.FebSalesLY = 0;
        accountUser.MarSalesLY = 0;

        accountUser.TotalBudget = 0;
        accountUser.TotalSales = 0;
        accountUser.QuoTotalLY = 0;
        accountUser.TotalSalesLY = 0;

        userBudget = [SELECT LookupUser__c, sum(LocalSales1CY__c) salesAprCY, sum(LocalSales2CY__c) salesMayCY, 
                            sum(LocalSales3CY__c) salesJunCY, sum(LocalSales4CY__c) salesJulCY,
                            sum(LocalSales5CY__c) salesAugCY, sum(LocalSales6CY__c) salesSepCY,
                            sum(LocalSales7CY__c) salesOctCY, sum(LocalSales8CY__c) salesNovCY,
                            sum(LocalSales9CY__c) salesDecCY, sum(LocalSales10CY__c) salesJanCY,
                            sum(LocalSales11CY__c) salesFebCY, sum(LocalSales12CY__c) salesMarCY,
                            sum(LocalSales1LY__c) salesAprLY, sum(LocalSales2LY__c) salesMayLY,
                            sum(LocalSales3LY__c) salesJunLY, sum(LocalSales4LY__c) salesJulLY,
                            sum(LocalSales5LY__c) salesAugLY, sum(LocalSales6LY__c) salesSepLY,
                            sum(LocalSales7LY__c) salesOctLY, sum(LocalSales8LY__c) salesNovLY,
                            sum(LocalSales9LY__c) salesDecLY, sum(LocalSales10LY__c) salesJanLY,
                            sum(LocalSales11LY__c) salesFebLY, sum(LocalSales12LY__c) salesMarLY,
                            sum(Quota1CY__c) quoAprCY, sum(Quota2CY__c) quoMayCY, sum(Quota3CY__c) quoJunCY,
                            sum(Quota4CY__c) quoJulCY, sum(Quota5CY__c) quoAugCY, sum(Quota6CY__c) quoSepCY,
                            sum(Quota7CY__c) quoOctCY, sum(Quota8CY__c) quoNovCY, sum(Quota9CY__c) quoDecCY,
                            sum(Quota10CY__c) quoJanCY, sum(Quota11CY__c) quoFebCY, sum(Quota12CY__c) quoMarCY,
                            sum(Qu1LY__c) quoAprLY, sum(Qu2LY__c) quoMayLY, sum(Qu3LY__c) quoJunLY,
                            sum(Qu4LY__c) quoJulLY, sum(Qu5LY__c) quoAugLY, sum(Qu6LY__c) quoSepLY,
                            sum(Qu7LY__c) quoOctLY, sum(Qu8LY__c) quoNovLY, sum(Qu9LY__c) quoDecLY,
                            sum(Qu10LY__c) quoJanLY, sum(Qu11LY__c) quoFebLY, sum(Qu12LY__c) QuoMarLY
                        FROM Budget_by_ASM__c WHERE LookupUser__c =: recordId GROUP BY LookupUser__c
                        ORDER BY LookupUser__c ASC];

        for(AggregateResult ar:userBudget){
            accountUser.QuoApr = accountUser.QuoApr+double.valueOf(ar.get('quoAprCY'))*accountUser.getConversionRate;
            accountUser.QuoMay = accountUser.QuoMay+double.valueOf(ar.get('quoMayCY'))*accountUser.getConversionRate;
            accountUser.QuoJun = accountUser.QuoJun+double.valueOf(ar.get('quoJunCY'))*accountUser.getConversionRate;
            accountUser.QuoJul = accountUser.QuoJul+double.valueOf(ar.get('quoJulCY'))*accountUser.getConversionRate;
            accountUser.QuoAug = accountUser.QuoAug+double.valueOf(ar.get('quoAugCY'))*accountUser.getConversionRate;
            accountUser.QuoSep = accountUser.QuoSep+double.valueOf(ar.get('quoSepCY'))*accountUser.getConversionRate;
            accountUser.QuoOct = accountUser.QuoOct+double.valueOf(ar.get('quoOctCY'))*accountUser.getConversionRate;
            accountUser.QuoNov = accountUser.QuoNov+double.valueOf(ar.get('quoNovCY'))*accountUser.getConversionRate;
            accountUser.QuoDec = accountUser.QuoDec+double.valueOf(ar.get('quoDecCY'))*accountUser.getConversionRate;
            accountUser.QuoJan = accountUser.QuoJan+double.valueOf(ar.get('quoJanCY'))*accountUser.getConversionRate;
            accountUser.QuoFeb = accountUser.QuoFeb+double.valueOf(ar.get('quoFebCY'))*accountUser.getConversionRate;
            accountUser.QuoMar = accountUser.QuoMar+double.valueOf(ar.get('quoMarCY'))*accountUser.getConversionRate;

            accountUser.QuoAprLY = accountUser.QuoAprLY+double.valueOf(ar.get('quoAprLY'))*accountUser.getConversionRate;
            accountUser.QuoMayLY = accountUser.QuoMayLY+double.valueOf(ar.get('quoMayLY'))*accountUser.getConversionRate;
            accountUser.QuoJunLY = accountUser.QuoJunLY+double.valueOf(ar.get('quoJunLY'))*accountUser.getConversionRate;
            accountUser.QuoJulLY = accountUser.QuoJulLY+double.valueOf(ar.get('quoJulLY'))*accountUser.getConversionRate;
            accountUser.QuoAugLY = accountUser.QuoAugLY+double.valueOf(ar.get('quoAugLY'))*accountUser.getConversionRate;
            accountUser.QuoSepLY = accountUser.QuoSepLY+double.valueOf(ar.get('quoSepLY'))*accountUser.getConversionRate;
            accountUser.QuoOctLY = accountUser.QuoOctLY+double.valueOf(ar.get('quoOctLY'))*accountUser.getConversionRate;
            accountUser.QuoNovLY = accountUser.QuoNovLY+double.valueOf(ar.get('quoNovLY'))*accountUser.getConversionRate;
            accountUser.QuoDecLY = accountUser.QuoDecLY+double.valueOf(ar.get('quoDecLY'))*accountUser.getConversionRate;
            accountUser.QuoJanLY = accountUser.QuoJanLY+double.valueOf(ar.get('quoJanLY'))*accountUser.getConversionRate;
            accountUser.QuoFebLY = accountUser.QuoFebLY+double.valueOf(ar.get('quoFebLY'))*accountUser.getConversionRate;
            accountUser.QuoMarLY = accountUser.QuoMarLY+double.valueOf(ar.get('quoMarLY'))*accountUser.getConversionRate;

            accountUser.AprSales = accountUser.AprSales+double.valueOf(ar.get('salesAprCY'))*accountUser.getConversionRate;
            accountUser.MaySales = accountUser.MaySales+double.valueOf(ar.get('salesMayCY'))*accountUser.getConversionRate;
            accountUser.JunSales = accountUser.JunSales+double.valueOf(ar.get('salesJunCY'))*accountUser.getConversionRate;
            accountUser.JulSales = accountUser.JulSales+double.valueOf(ar.get('salesJulCY'))*accountUser.getConversionRate;
            accountUser.AugSales = accountUser.AugSales+double.valueOf(ar.get('salesAugCY'))*accountUser.getConversionRate;
            accountUser.SepSales = accountUser.SepSales+double.valueOf(ar.get('salesSepCY'))*accountUser.getConversionRate;
            accountUser.OctSales = accountUser.OctSales+double.valueOf(ar.get('salesOctCY'))*accountUser.getConversionRate;
            accountUser.NovSales = accountUser.NovSales+double.valueOf(ar.get('salesNovCY'))*accountUser.getConversionRate;
            accountUser.DecSales = accountUser.DecSales+double.valueOf(ar.get('salesDecCY'))*accountUser.getConversionRate;
            accountUser.JanSales = accountUser.JanSales+double.valueOf(ar.get('salesJanCY'))*accountUser.getConversionRate;
            accountUser.FebSales = accountUser.FebSales+double.valueOf(ar.get('salesFebCY'))*accountUser.getConversionRate;
            accountUser.MarSales = accountUser.MarSales+double.valueOf(ar.get('salesMarCY'))*accountUser.getConversionRate;

            accountUser.AprSalesLY = accountUser.AprSalesLY+double.valueOf(ar.get('salesAprLY'))*accountUser.getConversionRate;
            accountUser.MaySalesLY = accountUser.MaySalesLY+double.valueOf(ar.get('salesMayLY'))*accountUser.getConversionRate;
            accountUser.JunSalesLY = accountUser.JunSalesLY+double.valueOf(ar.get('salesJunLY'))*accountUser.getConversionRate;
            accountUser.JulSalesLY = accountUser.JulSalesLY+double.valueOf(ar.get('salesJulLY'))*accountUser.getConversionRate;
            accountUser.AugSalesLY = accountUser.AugSalesLY+double.valueOf(ar.get('salesAugLY'))*accountUser.getConversionRate;
            accountUser.SepSalesLY = accountUser.SepSalesLY+double.valueOf(ar.get('salesSepLY'))*accountUser.getConversionRate;
            accountUser.OctSalesLY = accountUser.OctSalesLY+double.valueOf(ar.get('salesOctLY'))*accountUser.getConversionRate;
            accountUser.NovSalesLY = accountUser.NovSalesLY+double.valueOf(ar.get('salesNovLY'))*accountUser.getConversionRate;
            accountUser.DecSalesLY = accountUser.DecSalesLY+double.valueOf(ar.get('salesDecLY'))*accountUser.getConversionRate;
            accountUser.JanSalesLY = accountUser.JanSalesLY+double.valueOf(ar.get('salesJanLY'))*accountUser.getConversionRate;
            accountUser.FebSalesLY = accountUser.FebSalesLY+double.valueOf(ar.get('salesFebLY'))*accountUser.getConversionRate;
            accountUser.MarSalesLY = accountUser.MarSalesLY+double.valueOf(ar.get('salesMarLY'))*accountUser.getConversionRate;

            accountUser.TotalBudget = accountUser.QuoApr+accountUser.QuoMay+accountUser.QuoJun+accountUser.QuoJul+accountUser.QuoAug+accountUser.QuoSep+accountUser.QuoOct+accountUser.QuoNov+accountUser.QuoDec+accountUser.QuoJan+accountUser.QuoFeb+accountUser.QuoMar;
            accountUser.TotalSales = accountUser.AprSales+accountUser.MaySales+accountUser.JunSales+accountUser.JulSales+accountUser.AugSales+accountUser.SepSales+accountUser.OctSales+accountUser.NovSales+accountUser.DecSales+accountUser.JanSales+accountUser.FebSales+accountUser.MarSales;
            accountUser.QuoTotalLY = accountUser.QuoAprLY+accountUser.QuoMayLY+accountUser.QuoJunLY+accountUser.QuoJulLY+accountUser.QuoAugLY+accountUser.QuoSepLY+accountUser.QuoOctLY+accountUser.QuoNovLY+accountUser.QuoDecLY+accountUser.QuoJanLY+accountUser.QuoFebLY+accountUser.QuoMarLY;
            accountUser.TotalSalesLY = accountUser.AprSalesLY+accountUser.MaySalesLY+accountUser.JunSalesLY+accountUser.JulSalesLY+accountUser.AugSalesLY+accountUser.SepSalesLY+accountUser.OctSalesLY+accountUser.NovSaleslY+accountUser.DecSalesLY+accountUser.JanSaleslY+accountUser.FebSalesLY+accountUser.MarSalesLY;

        }
        /*=================================================================================
        accountUser.AprQty = 0;
        accountUser.MayQty = 0;
        accountUser.JunQty = 0;
        accountUser.JulQty = 0;
        accountUser.AugQty = 0;
        accountUser.SepQty = 0;
        accountUser.OctQty = 0;
        accountUser.NovQty = 0;
        accountUser.DecQty = 0;
        accountUser.JanQty = 0;
        accountUser.FebQty = 0;
        accountUser.MarQty = 0;
        accountUser.LastMonthQuota = 0;
        
        /*
        userQVSales = [SELECT generic_design__c, 
                            sum(annual_sales__c) annualSales, sum(annual_qty__c) annualQty,
                            sum(April__c) april, sum(May__c) may, sum(June__c) june, 
                            sum(July__c) july, sum(August__c) august, sum(September__c) september, 
                            sum(October__c) october, sum(November__c) november, 
                            sum(December__c) december, sum(January__c) january, 
                            sum(February__c) february, sum(March__c) march
                            /*
                            sum(April_qty__c) aprilQty, sum(May_qty__c) mayQty, sum(June_qty__c) junQty,
                            sum(July_qty__c) julQty, sum(August_qty__c) augQty, sum(September_qty__c) sepQty,
                            sum(October_qty__c) octQty, sum(November_qty__c) novQty, sum(December_qty__c) decQty,
                            sum(January_qty__c) janQty, sum(February_qty__c) febQty, sum(March_qty__c) marQty
                            FROM qv_sales__c WHERE account__r.ownerId =:recordId AND FY__c =:accountUser.CurrFY
                            GROUP BY generic_design__c ORDER BY generic_design__c asc];
        dataList = new List<QvData>();

        for(AggregateResult ar : userQVSales){
            QvData data = new QvData(String.valueOf(ar.get('generic_design__c')), double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
            dataList.add(data);
        }

        for(QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                , October__c, November__c, December__c, January__c, February__c, March__c
                                , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                FROM QV_Sales__c
                                WHERE (Account__r.OwnerId=:recordId) and (FY__c=:accountUser.CurrFY)])
        {
            accountUser.AprSales = accountUser.AprSales+double.valueOf(qcy.April__c) * conversionRate;
            accountUser.MaySales = accountUser.MaySales+double.valueOf(qcy.May__c) * conversionRate;
            accountUser.JunSales = accountUser.JunSales+double.valueOf(qcy.June__c) * conversionRate;
            accountUser.JulSales = accountUser.JulSales+double.valueOf(qcy.July__c) * conversionRate;
            accountUser.AugSales = accountUser.AugSales+double.valueOf(qcy.August__c) * conversionRate;
            accountUser.SepSales = accountUser.SepSales+double.valueOf(qcy.September__c) * conversionRate;
            accountUser.OctSales = accountUser.OctSales+double.valueOf(qcy.October__c) * conversionRate;
            accountUser.NovSales = accountUser.NovSales+double.valueOf(qcy.November__c) * conversionRate;
            accountUser.DecSales = accountUser.DecSales+double.valueOf(qcy.December__c) * conversionRate;
            accountUser.JanSales = accountUser.JanSales+double.valueOf(qcy.January__c) * conversionRate;
            accountUser.FebSales = accountUser.FebSales+double.valueOf(qcy.February__c) * conversionRate;
            accountUser.MarSales = accountUser.MarSales+double.valueOf(qcy.March__c) * conversionRate;
            
            accountUser.AprQty = accountUser.AprQty+double.valueOf(qcy.April_qty__c);
            accountUser.MayQty = accountUser.MayQty+double.valueOf(qcy.May_qty__c);
            accountUser.JunQty = accountUser.JunQty+double.valueOf(qcy.June_qty__c);
            accountUser.JulQty = accountUser.JulQty+double.valueOf(qcy.July_qty__c);
            accountUser.AugQty = accountUser.AugQty+double.valueOf(qcy.August_qty__c);
            accountUser.SepQty = accountUser.SepQty+double.valueOf(qcy.September_qty__c);
            accountUser.OctQty = accountUser.OctQty+double.valueOf(qcy.October_qty__c);
            accountUser.NovQty = accountUser.NovQty+double.valueOf(qcy.November_qty__c);
            accountUser.DecQty = accountUser.DecQty+double.valueOf(qcy.December_qty__c);
            accountUser.JanQty = accountUser.JanQty+double.valueOf(qcy.January_qty__c);
            accountUser.FebQty = accountUser.FebQty+double.valueOf(qcy.February_qty__c);
            accountUser.MarQty = accountUser.MarQty+double.valueOf(qcy.March_qty__c);
            

        }

        //calculate for QV_Sales__c Last Year
        accountUser.AprSalesLY = 0;
        accountUser.MaySalesLY = 0;
        accountUser.JunSalesLY = 0;
        accountUser.JulSalesLY = 0;
        accountUser.AugSalesLY = 0;
        accountUser.SepSalesLY = 0;
        accountUser.AugSalesLY = 0;
        accountUser.SepSalesLY = 0;
        accountUser.OctSalesLY = 0;
        accountUser.NovSalesLY = 0;
        accountUser.DecSalesLY = 0;
        accountUser.JanSalesLY = 0;
        accountUser.FebSalesLY = 0;
        accountUser.MarSalesLY = 0;
        /*
        accountUser.AprQtyLY = 0;
        accountUser.MayQtyLY = 0;
        accountUser.JunQtyLY = 0;
        accountUser.JulQtyLY = 0;
        accountUser.AugQtyLY = 0;
        accountUser.SepQtyLY = 0;
        accountUser.OctQtyLY = 0;
        accountUser.NovQtyLY = 0;
        accountUser.DecQtyLY = 0;
        accountUser.JanQtyLY = 0;
        accountUser.FebQtyLY = 0;
        accountUser.MarQtyLY = 0;
        
        userQVSalesLY = [SELECT generic_design__c, 
                            sum(annual_sales__c) annualSales, sum(annual_qty__c) annualQty,
                            sum(April__c) april, sum(May__c) may, sum(June__c) june, 
                            sum(July__c) july, sum(August__c) august, sum(September__c) september, 
                            sum(October__c) october, sum(November__c) november, 
                            sum(December__c) december, sum(January__c) january, 
                            sum(February__c) february, sum(March__c) march 
                            sum(April_qty__c) aprilQty, sum(May_qty__c) mayQty, sum(June_qty__c) juneQty,
                            sum(July_qty__c) julyQty, sum(August_qty__c) augustQty, sum(September_qty__c) septemberQty,
                            sum(October_qty__c) octoberQty, sum(November_qty__c) novemberQty, sum(December_qty__c) decemberQty,
                            sum(January_qty__c) januaryQty, sum(February_qty__c) februaryQty, sum(March_qty__c) marchQty
                        FROM qv_sales__c WHERE account__r.ownerId =:recordId AND FY__c =:accountUser.PrevFY
                        GROUP BY generic_design__c ORDER BY generic_design__c asc];
        dataListLY = new List<QvData>();
        for(AggregateResult ar:userQVSalesLY){
            QvData data = new QvData(String.valueOf(ar.get('generic_design__c')), Double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
            dataListLY.add(data);
        }

        for(QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                , October__c, November__c, December__c, January__c, February__c, March__c
                                , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                FROM QV_Sales__c
                                WHERE (Account__r.OwnerId=:recordId) and (FY__c=:accountUser.PrevFY)])
        {
            accountUser.AprSalesLY = accountUser.AprSalesLY+double.valueOf(qly.April__c) * conversionRate;
            accountUser.MaySalesLY = accountUser.MaySalesLY+double.valueOf(qly.May__c) * conversionRate;
            accountUser.JunSalesLY = accountUser.JunSalesLY+double.valueOf(qly.June__c) * conversionRate;
            accountUser.JulSalesLY = accountUser.JulSalesLY+double.valueOf(qly.July__c) * conversionRate;
            accountUser.AugSalesLY = accountUser.AugSalesLY+double.valueOf(qly.August__c) * conversionRate;
            accountUser.SepSalesLY = accountUser.SepSalesLY+double.valueOf(qly.September__c) * conversionRate;
            accountUser.OctSalesLY = accountUser.OctSalesLY+double.valueOf(qly.October__c) * conversionRate;
            accountUser.NovSalesLY = accountUser.NovSalesLY+double.valueOf(qly.November__c) * conversionRate;
            accountUser.DecSalesLY = accountUser.DecSalesLY+double.valueOf(qly.December__c) * conversionRate;
            accountUser.JanSalesLY = accountUser.JanSalesLY+double.valueOf(qly.January__c) * conversionRate;
            accountUser.FebSalesLY = accountUser.FebSalesLY+double.valueOf(qly.February__c) * conversionRate;
            accountUser.MarSalesLY = accountUser.MarSalesLY+double.valueOf(qly.March__c) * conversionRate;
            /*
            accountUser.AprQtyLY = accountUser.AprQtyLY+double.valueOf(qly.April_qty__c);
            accountUser.MayQtyLY = accountUser.MayQtyLY+double.valueOf(qly.May_qty__c);
            accountUser.JunQtyLY = accountUser.JunQtyLY+double.valueOf(qly.June_qty__c);
            accountUser.JulQtyLY = accountUser.JulQtyLY+double.valueOf(qly.July_qty__c);
            accountUser.AugQtyLY = accountUser.AugQtyLY+double.valueOf(qly.August_qty__c);
            accountUser.SepQtyLY = accountUser.SepQtyLY+double.valueOf(qly.September_qty__c);
            accountUser.OctQtyLY = accountUser.OctQtyLY+double.valueOf(qly.October_qty__c);
            accountUser.NovQtyLY = accountUser.NovQtyLY+double.valueOf(qly.November_qty__c);
            accountUser.DecQtyLY = accountUser.DecQtyLY+double.valueOf(qly.December_qty__c);
            accountUser.JanQtyLY = accountUser.JanQtyLY+double.valueOf(qly.January_qty__c);
            accountUser.FebQtyLY = accountUser.FebQtyLY+double.valueOf(qly.February_qty__c);
            accountUser.MarQtyLY = accountUser.MarQtyLY+double.valueOf(qly.March_qty__c);
            
        }

        //for user budget list
        accountUser.QuoApr = 0;
        accountUser.QuoMay = 0;
        accountUser.QuoJun = 0;
        accountUser.QuoJul = 0;
        accountUser.QuoAug = 0;
        accountUser.QuoSep = 0;
        accountUser.QuoOct = 0;
        accountUser.QuoNov = 0;
        accountUser.QuoDec = 0;
        accountUser.QuoJan = 0;
        accountUser.QuoFeb = 0;
        accountUser.QuoMar = 0;

        userBudget = [select Name, LookupUser__c, CurrencyIsoCode, sum(Quota1CY__c) aprQuo, 
                        sum(Quota2CY__c) mayQuo, sum(Quota3CY__c) junQuo, 
                        sum(Quota4CY__c) julQuo, sum(Quota5CY__c) augQuo, 
                        sum(Quota6CY__c) sepQuo, sum(Quota7CY__c) octQuo, 
                        sum(Quota8CY__c) novQuo, sum(Quota9CY__c) decQuo, 
                        sum(Quota10CY__c) janQuo, sum(Quota11CY__c) febQuo, 
                        sum(Quota12CY__c) marQuo FROM Budget_by_ASM__c WHERE LookupUser__c=:recordId
                        group by name, lookupuser__c, currencyisocode order by name asc];
        dataBudgetList = new List<BudgetData>();
        for(AggregateResult ar:userBudget){
            BudgetData data = new BudgetData(String.valueOf(ar.get('Name')), String.valueOf(ar.get('LookupUser__c')));
            dataBudgetList.add(data);
        }

        for(Budget_by_ASM__c bcy : [select Name, LookupUser__c, CurrencyIsoCode, Quota1CY__c, Quota2CY__c, 
                                    Quota3CY__c, Quota4CY__c, Quota5CY__c, Quota6CY__c, Quota7CY__c, Quota8CY__c, Quota9CY__c, 
                                    Quota10CY__c, Quota11CY__c, Quota12CY__c from Budget_by_ASM__c
                                    where LookupUser__c=:recordId])
        {
            accountUser.QuoApr = accountUser.QuoApr+double.valueOf(bcy.Quota1CY__c) * conversionRate;
            accountUser.QuoMay = accountUser.QuoMay+double.valueOf(bcy.Quota2CY__c) * conversionRate;
            accountUser.QuoJun = accountUser.QuoJun+double.valueOf(bcy.Quota3CY__c) * conversionRate;
            accountUser.QuoJul = accountUser.QuoJul+double.valueOf(bcy.Quota4CY__c) * conversionRate;
            accountUser.QuoAug = accountUser.QuoAug+double.valueOf(bcy.Quota5CY__c) * conversionRate;
            accountUser.QuoSep = accountUser.QuoSep+double.valueOf(bcy.Quota6CY__c) * conversionRate;
            accountUser.QuoOct = accountUser.QuoOct+double.valueOf(bcy.Quota7CY__c) * conversionRate;
            accountUser.QuoNov = accountUser.QuoNov+double.valueOf(bcy.Quota8CY__c) * conversionRate;
            accountUser.QuoDec = accountUser.QuoDec+double.valueOf(bcy.Quota9CY__c) * conversionRate;
            accountUser.QuoJan = accountUser.QuoJan+double.valueOf(bcy.Quota10CY__c) * conversionRate;
            accountUser.QuoFeb = accountUser.QuoFeb+double.valueOf(bcy.Quota11CY__c) * conversionRate;
            accountUser.QuoMar = accountUser.QuoMar+double.valueOf(bcy.Quota12CY__c) * conversionRate;
        }
        //Active account > USD 0.1*/
        
        //visit per day Apr
        accountUser.VisitPerDayApr = 0;
        accountUser.Ind_Day_in_field_Apr = 0;

        userVisitPerDayApr = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Arp
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='4') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayAprList = new List<VisitData>();
        for(AggregateResult ar:userVisitPerDayApr){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            System.debug('XXX Get Data Visit Per Day Apr == >'+data);
            dataVisitPerDayAprList.add(data);

        }

        for(Visit_KPI__c vApr : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='4') 
                                AND (Area_Sales_Manager__c =:recordId)
                                ORDER BY name ASC])
        {
            accountUser.VisitPerDayApr = accountUser.VisitPerDayApr+double.valueOf(vApr.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Apr = accountUser.Ind_Day_in_field_Apr+double.valueOf(vApr.Days_in_Field_feasible__c);
        }

        //visit per day May
        accountUser.VisitPerDayMay = 0;
        accountUser.Ind_Day_in_field_May = 0;

        userVisitPerDayMay = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_May
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='5') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayMayList = new List<VisitData>();
        for(AggregateResult ar:userVisitPerDayMay){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayMayList.add(data);
        }
        for(Visit_KPI__c vMay : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='5') 
                                AND (Area_Sales_Manager__c =:recordId)
                                ORDER BY name ASC])
        {
            accountUser.VisitPerDayMay = accountUser.VisitPerDayMay+double.valueOf(vMay.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_May = accountUser.Ind_Day_in_field_May+double.valueOf(vMay.Days_in_Field_feasible__c);
        }

        //visit per day June
        accountUser.VisitPerDayJun = 0;
        accountUser.Ind_Day_in_field_Jun= 0;

        userVisitPerDayJun = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Jun
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='6') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayJunList = new List<VisitData>();
        for(AggregateResult ar:userVisitPerDayJun){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayJunList.add(data);
        }
        
        for(Visit_KPI__c vJun : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='6') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayJun = accountUser.VisitPerDayJun+double.valueOf(vJun.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Jun = accountUser.Ind_Day_in_field_Jun+double.valueOf(vJun.Days_in_Field_feasible__c);
        }

        //visit per day July
        accountUser.VisitPerDayJul = 0;
        accountUser.Ind_Day_in_field_Jul = 0;
        userVisitPerDayJul = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Jul
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='7') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayJulList = new List<VisitData>();
        for(AggregateResult ar : userVisitPerDayJul){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayJulList.add(data);
        }

        for(Visit_KPI__c vJul : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='7') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayJul = accountUser.VisitPerDayJul+double.valueOf(vJul.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Jul = accountUser.Ind_Day_in_field_Jul+double.valueOf(vJul.Days_in_Field_feasible__c);
        }
        //visit per day Aug
        accountUser.VisitPerDayAug = 0;
        accountUser.Ind_Day_in_field_Aug = 0;
        userVisitPerDayAug = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Aug
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='8') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayAugList = new List<VisitData>();
        for(AggregateResult ar : userVisitPerDayAug){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayAugList.add(data);
        }
        for(Visit_KPI__c vAug : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='8') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayAug = accountUser.VisitPerDayAug+double.valueOf(vAug.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Aug = accountUser.Ind_Day_in_field_Aug+double.valueOf(vAug.Days_in_Field_feasible__c);
        }

        //visit per day Sep
        accountUser.VisitPerDaySep = 0;
        accountUser.Ind_Day_in_field_Sep = 0;
        userVisitPerDaySep = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Sep
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='9') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDaySepList = new List<VisitData>();
        for(AggregateResult ar : userVisitPerDaySep){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDaySepList.add(data);
        }

        for(Visit_KPI__c vSep : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='9') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDaySep = accountUser.VisitPerDaySep+double.valueOf(vSep.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Sep = accountUser.Ind_Day_in_field_Sep+double.valueOf(vSep.Days_in_Field_feasible__c);
        }
        //visit per day Oct
        accountUser.VisitPerDayOct = 0;
        accountUser.Ind_Day_in_field_Oct = 0;
        userVisitPerDayOct = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Oct
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='10') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        dataVisitPerDayOctList = new List<VisitData>();
        for(AggregateResult ar : userVisitPerDayOct){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayOctList.add(data);
        }

        for(Visit_KPI__c vOct : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='10') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayOct = accountUser.VisitPerDayOct+double.valueOf(vOct.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Oct = accountUser.Ind_Day_in_field_Oct + double.valueOf(vOct.Days_in_Field_feasible__c);
        }

        //visit per day Nov
        accountUser.VisitPerDayNov = 0;
        accountUser.Ind_Day_in_field_Nov = 0;
        userVisitPerDayNov = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Nov
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='11') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        for(AggregateResult ar : userVisitPerDayNov){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayNovList.add(data);
        }

        for(Visit_KPI__c vNov : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='11') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayNov = accountUser.VisitPerDayNov+double.valueOf(vNov.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Nov = accountUser.Ind_Day_in_field_Nov+double.valueOf(vNov.Days_in_Field_feasible__c);
        }

        //visit per day Dec
        accountUser.VisitPerDayDec = 0;
        accountUser.Ind_Day_in_field_Dec = 0;
        userVisitPerDayDec = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Dec
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='12') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        for(AggregateResult ar : userVisitPerDayDec){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayDecList.add(data);
        }
        for(Visit_KPI__c vDec : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.CurFY) AND (month_text__c='12') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayDec = accountUser.VisitPerDayDec+double.valueOf(vDec.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Dec = accountUser.Ind_Day_in_field_Dec + double.valueOf(vDec.Days_in_Field_feasible__c);
        }
        //visit per day Jan
        accountUser.VisitPerDayJan = 0;
        accountUser.Ind_Day_in_field_Jan=0;
        userVisitPerDayJan = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Jan
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='1') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        
        for(AggregateResult ar : userVisitPerDayJan){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayJanList.add(data);
        }

        for(Visit_KPI__c vJan : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c 
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='1') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayJan = accountUser.VisitPerDayJan+double.valueOf(vJan.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Jan = accountUser.Ind_Day_in_field_Jan+double.valueOf(vJan.Days_in_Field_feasible__c);
        }
        //visit per day Feb
        accountUser.VisitPerDayFeb = 0;
        accountUser.Ind_Day_in_field_Feb=0;
        userVisitPerDayFeb = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) In_Day_Feb
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='2') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        for(AggregateResult ar : userVisitPerDayFeb){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            dataVisitPerDayFebList.add(data);
        }
        for(Visit_KPI__c vFeb : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='2') 
                                AND (Area_Sales_Manager__c =:recordId)
                                ORDER BY name ASC])
        {
            accountUser.VisitPerDayFeb = accountUser.VisitPerDayFeb+double.valueOf(vFeb.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Feb = accountUser.Ind_Day_in_field_Feb + double.valueOf(vFeb.Days_in_Field_feasible__c);
        }

        //visit per day Mar
        accountUser.VisitPerDayMar = 0;
        accountUser.Ind_Day_in_field_Mar=0;
        userVisitPerDayMar = [SELECT Id, Name, SUM(Visits_per_Day__c) Visit_Per_Day, SUM(Days_in_Field_feasible__c) Ind_Day_Mar
                                FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='3') 
                                AND (Area_Sales_Manager__c =:recordId) 
                                GROUP BY Id, Name ORDER BY name ASC];
        for(AggregateResult ar : userVisitPerDayMar){
            VisitData data = new VisitData(String.valueOf(ar.get('Id')), String.valueOf(ar.get('Name')));
            System.debug('Get Visit Data Per Day Mar == >'+data);
            dataVisitPerDayMarList.add(data);
        }
        for(Visit_KPI__c vMar : [SELECT Id, Name, Visits_per_Day__c, Days_in_Field_feasible__c
                                    FROM Visit_KPI__c WHERE (Year_text__c=:accountUser.NextFY) AND (month_text__c='3') 
                                    AND (Area_Sales_Manager__c =:recordId)
                                    ORDER BY name ASC])
        {
            accountUser.VisitPerDayMar = accountUser.VisitPerDayMar+double.valueOf(vMar.Visits_per_Day__c);
            accountUser.Ind_Day_in_field_Mar = accountUser.Ind_Day_in_field_Mar+double.valueOf(vMar.Days_in_Field_feasible__c);
        }

        accountUser.VisitPerDayTotal = accountUser.VisitPerDayApr+accountUser.VisitPerDayMay+accountUser.VisitPerDayJun+accountUser.VisitPerDayJul+accountUser.VisitPerDayAug+accountUser.VisitPerDaySep+accountUser.VisitPerDayOct+accountUser.VisitPerDayNov+accountUser.VisitPerDayDec+accountUser.VisitPerDayJan+accountUser.VisitPerDayFeb+accountUser.VisitPerDayMar;
        accountUser.Ind_Day_in_field_Total = accountUser.Ind_Day_in_field_Apr+accountUser.Ind_Day_in_field_May+accountUser.Ind_Day_in_field_Jun+accountUser.Ind_Day_in_field_Jul+accountUser.Ind_Day_in_field_Aug+accountUser.Ind_Day_in_field_Sep+accountUser.Ind_Day_in_field_Oct+accountUser.Ind_Day_in_field_Nov+accountUser.Ind_Day_in_field_Dec+accountUser.Ind_Day_in_field_Jan+accountUser.Ind_Day_in_field_Feb+accountUser.Ind_Day_in_field_Mar;
        System.debug('XXX Get Data Visit Per Day Total == > '+accountUser.VisitPerDayTotal+' | Get Individual Day In Field == >'+accountUser.Ind_Day_in_field_Total);

        //accountUser.LastMonthQuota = getUserBudgetLastMonth(accountUser, month);
        //accountUser.TotalSales = accountUser.AprSales+accountUser.MaySales+accountUser.JunSales+accountUser.JulSales+accountUser.AugSales+accountUser.SepSales+accountUser.OctSales+accountUser.NovSales+accountUser.DecSales+accountUser.JanSales+accountUser.FebSales+accountUser.MarSales;
        //accountUser.TotalSalesLY = accountUser.AprSalesLY+accountUser.MaySalesLY+accountUser.JunSalesLY+accountUser.JulSalesLY+accountUser.AugSalesLY+accountUser.SepSalesLY+accountUser.OctSalesLY+accountUser.NovSalesLY+accountUser.DecSalesLY+accountUser.JanSalesLY+accountUser.FebSalesLY+accountUser.MarSalesLY;
        //accountUser.TotalQty = accountUser.AprQty+accountUser.MayQty+accountUser.JunQty+accountUser.JulQty+accountUser.AugQty+accountUser.SepQty+accountUser.OctQty+accountUser.NovQty+accountUser.DecQty+accountUser.JanQty+accountUser.FebQty+accountUser.MarQty;
        //accountUser.TotalQtyLY = accountUser.AprQtyLY+accountUser.MayQtyLY+accountUser.JunQtyLY+accountUser.JulQtyLY+accountUser.AugQtyLY+accountUser.SepQtyLY+accountUser.OctQtyLY+accountUser.NovQtyLY+accountUser.DecQtyLY+accountUser.JanQtyLY+accountUser.FebQtyLY+accountUser.MarQtyLY;
        //accountUser.TotalBudget = accountUser.QuoApr+accountUser.QuoMay+accountUser.QuoJun+accountUser.QuoJul+accountUser.QuoAug+accountUser.QuoSep+accountUser.QuoOct+accountUser.QuoNov+accountUser.QuoDec+accountUser.QuoJan+accountUser.QuoFeb+accountUser.QuoMar;
                
        //System.debug('Get record accountUser = '+accountUser.size());
        System.debug('XXX Get Account User Sales Figured == >'+accountUser);
        return accountUser;
    }

    /*
        ***********************************************************************************
        This method to use for render visited geocode lattitude/longitude in lightning map
        @Author : Surawat Sakulmontreechai
        @Email : surawat.sakulmontreechai@hoya.com
        @Version : 1.00
        since : api force.com v.49.0
        created : 2022-05-12
        return Visit_Task_APAC__c
        ***********************************************************************************
    */
    @AuraEnabled
    public static List<Visits__c> getVisitDataList(Id recordId, Date datetime1, String VisitStatus){
        try {
            Double startDay = 7;

            if(datetime1 == null){datetime1 = System.today()-(Integer.valueOf(startDay));}

            if(VisitStatus == null || VisitStatus=='' || String.isEmpty(VisitStatus)){VisitStatus = 'Complete';}

            System.debug('XXX Getting data for Start Date : '+datetime1);
            System.debug('XXX Get data for Visit Status : '+VisitStatus);
            /*
            List<Visit_Task_APAC__c> visitTask = [SELECT Account__c,Checked_Location_Time__c,CurrencyIsoCode,
                                                    Description__c,Id, Name, Account__r.Name, Account__r.Hoya_Account_Id__c, Account__r.sf_latitude__c, Account__r.sf_longitude__c,
                                                    OwnerId,Start_Location_Lattitude__c,Start_Location_Longitude__c,
                                                    Visit_Start_Type__c,Visit__c, Visit_Notes__c, Visit_Reason__c, Visit_Reason_Global__c, Owner.Name, Shop_Street__c,
                                                    Shop_City__c, Shop_Country__c, Shop_State__c, Shop_Postal_Code__c, Shop_Phone__c, Visited_Date_Behind__c,
                                                    Account__r.OwnerId, Account__r.Owner.Name, Account__r.ShippingStreet, Account__r.ShippingCity, Visit__r.Start_Date_Time__c,
                                                    Account__r.ShippingState, Account__r.ShippingCountry, Account__r.ShippingPostalcode, Account__r.First_Competitor_global_name__c,
                                                    Visit__r.Start_Time__c, Visit__r.End_Time__c, Visit__r.End_Date_Time__c, Visit_Type__c, Visit_Status__c, Call_to_action_notes__c, Visit__r.Segmentation_Box__c
                                                    FROM Visit_Task_APAC__c
                                                    WHERE (OwnerId=:recordId) AND (Check_Location_Time_Date__c=:datetime1) AND (Visit_Status__c=:VisitStatus)
                                                    AND (Visit_Start_Type__c IN ('SHOP', 'START')) AND (Visit_Type__c = 'Visit') 
                                                    ORDER BY Visit__r.Start_Time__c DESC LIMIT 100];
            */
            List<Visits__c> visitTask = [SELECT Id, Account__r.Name, Assigned_to__c, Account__r.Hoya_Account_ID__c, Assigned_to__r.Name, 
                                            Start_Date_Time__c, End_Date_Time__c, Start_Day__c, Account__r.sf_latitude__c, Account__r.sf_longitude__c,
                                            Account__r.Shop_Street__c, Account__r.Shop_City__c, Account__r.Shop_State__c, Account__r.Shop_Country__c,
                                            Account__r.Shop_Postal_Code__c, Account__r.ShippingStreet, Account__r.ShippingCity, Account__r.ShippingState,
                                            Account__r.ShippingPostalcode, Visit_Reason_APAC__c, Visit_Type__c, Visit_Status__c, Call_To_Action_Notes__c, 
                                            Visited_Date_Behind__c, Account__r.Segmentation_Box__c, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Country__c,
                                            Shop_Postal_Code__c, Shop_Latitude__c, Shop_Longitude__c   
                                            FROM Visits__c WHERE (Assigned_to__c =:recordId) AND (Start_Day__c=:datetime1) AND (Visit_Status__c=:VisitStatus)
                                            AND (Visit_Type__c = 'Visit') ORDER BY Start_Time__c DESC LIMIT 100];

            System.debug('XXX Get Visits__c Object for Map == > '+visitTask.size()+' record(s) ==> '+visitTask);
            return visitTask;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    @AuraEnabled
    public static List<Visit_Task_APAC__c> getVisitDataList(Id recordId, DateTime datetime1, DateTime datetime2){
        try {
            
            Double startDay = 8;
            Double endDay = 0;

            if(datetime1==null){
                datetime1 = DateTime.now().addDays(-Integer.valueOf(startDay));
            }

            if(datetime2==null){
                datetime2 = DateTime.now().addDays(+Integer.valueOf(endDay));
            }

            System.debug('Start Date is '+datetime1+' End Date is '+datetime2);

            List<Visit_Task_APAC__c> visitTask = [SELECT Account__c,Checked_Location_Time__c,CurrencyIsoCode,
                                                    Description__c,Id, Name, Account__r.Name, Account__r.Hoya_Account_Id__c, Account__r.sf_latitude__c, Account__r.sf_longitude__c,
                                                    OwnerId,Start_Location_Lattitude__c,Start_Location_Longitude__c,
                                                    Visit_Start_Type__c,Visit__c, Visit_Notes__c, Visit_Reason__c, Visit_Reason_Global__c, Owner.Name, Shop_Street__c,
                                                    Shop_City__c, Shop_Country__c, Shop_State__c, Shop_Postal_Code__c, Shop_Phone__c, Visited_Date_Behind__c,
                                                    Account__r.OwnerId, Account__r.Owner.Name, Account__r.ShippingStreet, Account__r.ShippingCity, Visit__r.Start_Date_Time__c,
                                                    Account__r.ShippingState, Account__r.ShippingCountry, Account__r.ShippingPostalcode, Account__r.First_Competitor_global_name__c,
                                                    Visit__r.Start_Time__c, Visit__r.End_Time__c, Visit__r.End_Date_Time__c, Visit_Type__c, Visit_Status__c, Call_to_action_notes__c, Visit__r.Segmentation_Box__c
                                                    FROM Visit_Task_APAC__c
                                                    WHERE (OwnerId=:recordId) AND (Checked_Location_Time__c>:datetime1) AND (Checked_Location_Time__c<:datetime2)
                                                    ORDER BY Visit__r.Start_Time__c DESC LIMIT 100];
            
            System.debug('XXX Gete Data Visit Task for Map == >'+visitTask.size()+' record(s) and Data == >'+visitTask);
            return visitTask;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    
    @AuraEnabled
    public static List<User> getCompanayName(Id recordId){
        List<User> companyName = [select Id, Name, CompanyName from User where Id=:recordId];
        return companyName;
    }

    @AuraEnabled
    public static List<Account> getAccounts(Id recordId){

        String username = [select Id, Name from User where Id=:recordId].Name;
        System.debug('Get user name : '+username);
        List<Account> acc = [select Id, Name, Owner.Name from Account where Owner.Name=:username];
        System.debug('Account list size '+acc.size());

        return acc;

    }
    /*
        ==================================================================
        **Get Visit List from User (Assigned sales reps) in Last 7 days**
        @Author : Surawat Sakulmontreechai
        @Email : surawat.sakulmontreechai@hoya.com
        @version : 1.0
        since : api version 49.0 force.com
        created date : 2022-05-20
        return Visits__c
        ===================================================================
    */
   
    @AuraEnabled
    public static Map<String, Object> getOpportunityDataColumn(String sObjectName, List<String> sObjectFieldsNames, Id recordId, String AndWhere, String OwnerWhere, String OrderedBy) {
        try{
            Map<String, Schema.SObjectField> m = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();
            for ( String fieldName: sObjectFieldsNames ) {
                Schema.DescribeFieldResult dfr = m.get( fieldName ).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => dfr.getLabel(),
                    'fieldName' => dfr.getName(),
                    'type' => String.valueOf( dfr.getType() ).toLowerCase(),
                    'sortable'=>true
                };
                columns.add( column );
            }
            String query = 'SELECT ' + String.join( sObjectFieldsNames, ', ') + ' FROM ' +sObjectName+ OwnerWhere + '\''+recordId+'\''
                            +AndWhere+OrderedBy;//' ORDER BY CreatedDate DESC LIMIT 100';
            System.debug('Query : '+query);

            List<SObject> records = Database.query( query );
            Map<String, Object> dataVisit = new Map<String, Object>{
                'columns' => columns,
                'data' => records

            };
            System.debug('XXX Get Data for Opportunity == >'+dataVisit);
            return dataVisit;
            /*
            return new Map<String, Object>{
                'columns' => columns,
                'data' => records
            };
            */
        } 
        catch(Exception ex) {
            LogException.log(ex);            
            return new MAP<string,object>{'Exception'=>ex.getMessage()};
        }
    }

    @AuraEnabled
    public static Map<String, Object> getColumnsAndData(String sObjectName, List<String> sObjectFieldsNames, Id recordId, String LastVisitDay, String VisitStatus) {
        try{
            Map<String, Schema.SObjectField> m = Schema.describeSObjects(sObjectName.split(','))[0].fields.getMap();
            List<Object> columns = new List<Object>();
            for ( String fieldName: sObjectFieldsNames ) {
                Schema.DescribeFieldResult dfr = m.get( fieldName ).getDescribe();
                Map<String, Object> column = new Map<String, Object>{
                    'label' => dfr.getLabel(),
                    'fieldName' => dfr.getName(),
                    'type' => String.valueOf( dfr.getType() ).toLowerCase(),
                    'sortable'=>true
                };
                columns.add( column );
            }
            String query = 'SELECT ' + String.join( sObjectFieldsNames, ', ') + ' FROM ' +sObjectName+' WHERE Assigned_to__c=\''+recordId+'\''
                            +' AND Start_Time__c ='+LastVisitDay+' AND Visit_Status__c=\''+VisitStatus+'\''+' ORDER BY Start_Day__c DESC LIMIT 100';
            System.debug('Query : '+query);

            List<SObject> records = Database.query( query );
            Map<String, Object> dataVisit = new Map<String, Object>{
                'columns' => columns,
                'data' => records

            };
            System.debug('XXX Get Data for Visit == >'+dataVisit);
            return dataVisit;
            /*
            return new Map<String, Object>{
                'columns' => columns,
                'data' => records
            };
            */
        } 
        catch(Exception ex) {
            LogException.log(ex);            
            return new MAP<string,object>{'Exception'=>ex.getMessage()};
        }
    }
    /* ============== Wrapper Class for AggregateResult ================== */

    public class DataSet{
        public Dataset(String label, Double Qty){
            this.label = label;
            this.Qty = Qty;

        }
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public Double Qty{get;set;}
    }
    
    public class VisitDataSet{
        public VisitDataSet(Double Qty){
            this.Qty = Qty;
        }
        @AuraEnabled public Double Qty{get;set;}
    }

    public class DataSetCampaignName{
        public DataSetCampaignName(String label){
            this.label = label;
        }
        @AuraEnabled public string label{get;set;}
    }

    /* Get datalist from aggregateresult counting and grouping for visit asigned to */
    /*
    public static Double getUserBudgetLastMonth(AccountUser a, Integer month){
        Double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecSales/a.budget.Quota9CY__c;}
                when 2 {result = a.JanSales/a.budget.Quota10CY__c;}
                when 3 {result = a.FebSales/a.budget.Quota11CY__c;}
                when 4 {result = a.MarSalesLY/a.budget.Qu12LY__c;}
                when 5 {result = a.AprSales/a.budget.Quota1CY__c;}
                when 6 {result = a.MaySales/a.budget.Quota2CY__c;}
                when 7 {result = a.JunSales/a.budget.Quota3CY__c;}
                when 8 {result = a.JulSales/a.budget.Quota4CY__c;}
                when 9 {result = a.AugSales/a.budget.Quota5CY__c;}
                when 10 {result = a.SepSales/a.budget.Quota6CY__c;}
                when 11 {result = a.OctSales/a.budget.Quota7CY__c;}
                when 12 {result = a.NovSales/a.budget.Quota8CY__c;}
                when else{result = 0;}
            }
        }catch(Exception e){
            System.debug('XXX error on budget access');
        }
        return result;
    }*/

    //public Double getLastMonthQuota(){return Last3MonthQuota;}

    @AuraEnabled
    public static List<ActiveTargetCampaign> getActiveTargetCampaign(Id recordId){
        try {

            Map<String, ActiveTargetCampaign> dataMap = new Map<String, ActiveTargetCampaign>();
            List<AggregateResult> lstTargetCampaign = [SELECT central_campaign__r.name campaignname, count_distinct(account_name__c) cntAcc
                                        FROM Account_Campaing_Member__c 
                                        WHERE (campaign_active__c=true)
                                        AND (Target__c=true) 
                                        AND (account_name__r.ownerid=:recordId) 
                                        GROUP BY central_campaign__r.name
                                        ORDER BY central_campaign__r.name asc];

            List<AggregateResult> lstNotTargetCampaign = [SELECT central_campaign__r.name campaignname, count_distinct(account_name__c) cntAcc
                                                            FROM Account_Campaing_Member__c 
                                                            WHERE (campaign_active__c=true)
                                                            AND (Target__c=false) 
                                                            AND (account_name__r.ownerid=:recordId) 
                                                            GROUP BY central_campaign__r.name
                                                            ORDER BY central_campaign__r.name asc];
            
            for(AggregateResult ar : lstTargetCampaign){
                String CampaignName = (String)ar.get('campaignname');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new ActiveTargetCampaign());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('campaignname');
                    //dataMap.get(OwnerId).CampaignName = (String)ar.get('campaignname');
                }
                dataMap.get(CampaignName).TargetCampaign = (Double)ar.get('cntAcc');
            }

            for(AggregateResult ar : lstNotTargetCampaign){
                String CampaignName = (String)ar.get('campaignname');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new ActiveTargetCampaign());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('campaignname');
                }
                dataMap.get(CampaignName).TargetCampaign = (Double)ar.get('cntAcc');
            }

            dataTargetCampaign = dataMap.values();
            List<ActiveTargetCampaign> datalist = new List<ActiveTargetCampaign>();

            for(ActiveTargetCampaign data : dataTargetCampaign){
                datalist.add(data);
            }

            System.debug('Data List == > '+datalist);

            System.debug('XXX Get Active Target Campaign == > Size : '+dataTargetCampaign.size()+'=='+dataTargetCampaign);
            return dataTargetCampaign;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
    @AuraEnabled
    public static List<TopCustomer> getTopCustomerByOwner(Id recordId){
        try {

            Integer month = Date.today().month();
            Integer year = Date.today().year();
            String userCompany = [SELECT CompanyName FROM User WHERE Id=:recordId].CompanyName;
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            String CurrFY = 'FY-'+String.valueOf(year).substring(2);
            String PrevFY = 'FY-'+String.valueOf(year-1).substring(2);

            System.debug('XXX Last FY : '+PrevFY+' Current FY : '+CurrFY);

            originalConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            System.debug('Conversion Rate == >'+conversionRate);
            userConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            //if(userCurrency != 'EUR'){conversionRate=1;}

            List<TopCustomer> datalist = new List<TopCustomer>();
            Map<String, TopCustomer> dataMap = new Map<String, TopCustomer>();

            List<AggregateResult> LastFY = [select account__r.hoya_account_id__c AccountId,
                                            sum(april__c) april, sum(may__c) may, 
                                            sum(june__c) june, sum(july__c) july, 
                                            sum(august__c) august, sum(september__c) september, 
                                            sum(october__c) october, sum(november__c) november, 
                                            sum(december__c) december, sum(january__c) january, 
                                            sum(february__c) february, sum(march__c) march, 
                                            sum(Annual_Sales__c) annual from qv_sales__c 
                                            where fy__c =: PrevFY and 
                                            account__r.ownerid =:recordId 
                                            group by account__r.hoya_account_id__c
                                            order by sum(annual_sales__c) desc limit 10];
        
            List<AggregateResult> CurrentFY = [select account__r.hoya_account_id__c AccountId,
                                                sum(april__c) april, sum(may__c) may, 
                                                sum(june__c) june, sum(july__c) july, 
                                                sum(august__c) august, sum(september__c) september, 
                                                sum(october__c) october, sum(november__c) november, 
                                                sum(december__c) december, sum(january__c) january, 
                                                sum(february__c) february, sum(march__c) march, 
                                                sum(Annual_Sales__c) annual from qv_sales__c 
                                                where fy__c =: CurrFY and 
                                                account__r.ownerid =:recordId 
                                                group by account__r.hoya_account_id__c
                                                order by sum(annual_sales__c) desc limit 10];
        for(AggregateResult ar:LastFY){
            String AccountId = (String)ar.get('AccountId');
            if(dataMap.get(AccountId)==null){
                dataMap.put(AccountId, new TopCustomer());
                dataMap.get(AccountId).AccountId = (String)ar.get('AccountId');
            }
            dataMap.get(AccountId).AprValLY = (Double)ar.get('april')*conversionRate;
            dataMap.get(AccountId).MayValLY = (Double)ar.get('may')*conversionRate;
            dataMap.get(AccountId).JunValLY = (Double)ar.get('june')*conversionRate;
            dataMap.get(AccountId).JulValLY = (Double)ar.get('july')*conversionRate;
            dataMap.get(AccountId).AugValLY = (Double)ar.get('august')*conversionRate;
            dataMap.get(AccountId).SepValLY = (Double)ar.get('september')*conversionRate;
            dataMap.get(AccountId).OctValLY = (Double)ar.get('october')*conversionRate;
            dataMap.get(AccountId).NovValLY = (Double)ar.get('november')*conversionRate;
            dataMap.get(AccountId).DecValLY = (Double)ar.get('december')*conversionRate;
            dataMap.get(AccountId).JanValLY = (Double)ar.get('january')*conversionRate;
            dataMap.get(AccountId).FebValLY = (Double)ar.get('february')*conversionRate;
            dataMap.get(AccountId).MarValLY = (Double)ar.get('march')*conversionRate;
            dataMap.get(AccountId).AnnualLY = (Double)ar.get('annual')*conversionRate;
        }

        for(AggregateResult ar:CurrentFY){
            String AccountId = (String)ar.get('AccountId');
            If(dataMap.get(AccountId)==null){
                dataMap.put(AccountId, new TopCustomer());
                dataMap.get(AccountId).AccountId = (String)ar.get('AccountId');
            }
            dataMap.get(AccountId).AprVal = (Double)ar.get('april')*conversionRate;
            dataMap.get(AccountId).MayVal = (Double)ar.get('may')*conversionRate;
            dataMap.get(AccountId).JunVal = (Double)ar.get('june')*conversionRate;
            dataMap.get(AccountId).JulVal = (Double)ar.get('july')*conversionRate;
            dataMap.get(AccountId).AugVal = (Double)ar.get('august')*conversionRate;
            dataMap.get(AccountId).SepVal = (Double)ar.get('september')*conversionRate;
            dataMap.get(AccountId).OctVal = (Double)ar.get('october')*conversionRate;
            dataMap.get(AccountId).NovVal = (Double)ar.get('november')*conversionRate;
            dataMap.get(AccountId).DecVal = (Double)ar.get('december')*conversionRate;
            dataMap.get(AccountId).JanVal = (Double)ar.get('january')*conversionRate;
            dataMap.get(AccountId).FebVal = (Double)ar.get('february')*conversionRate;
            dataMap.get(AccountId).MarVal = (Double)ar.get('march')*conversionRate;
            dataMap.get(AccountId).Annual = (Double)ar.get('annual')*conversionRate;
        }
            dataTopCustomer = dataMap.values();
            System.debug('XXX '+dataTopCustomer);
            return dataTopCustomer;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static List<TopTenCustomer> getTopTenCustomer(Id recordId){
        try {
            Integer month = Date.today().month();
            Integer year = Date.today().year();
            String userCompany = [SELECT CompanyName FROM User WHERE Id=:recordId].CompanyName;
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            String CurrFY = 'FY-'+String.valueOf(year).substring(2);
            String PrevFY = 'FY-'+String.valueOf(year-1).substring(2);

            System.debug('XXX Last FY : '+PrevFY+' Current FY : '+CurrFY);

            originalConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            System.debug('Conversion Rate == >'+conversionRate);
            userConversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;

            List<TopTenCustomer> dataList = new List<TopTenCustomer>();
            Map<String, TopTenCustomer> dataMap = new Map<String, TopTenCustomer>();

            List<AggregateResult> LastFY = [select account__c, account__r.name account_name,
                                            sum(April__c) april, sum(may__c) may, sum(june__c) june, sum(july__c) july,
                                            sum(august__c) august, sum(september__c) september, sum(october__c) october,
                                            sum(november__c) november, sum(december__c) december, sum(january__c) january,
                                            sum(february__c) february, sum(march__c) march, sum(annual_sales__c) annual,
                                            sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty, sum(June_qty__c) jun_qty,
                                            sum(July_qty__c) jul_qty, sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                            sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty, sum(December_qty__c) dec_qty,
                                            sum(January_qty__c) jan_qty, sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty,
                                            sum(annual_qty__c) annual_qty
                                            from QV_Sales__c where (FY__c=:PrevFY) and (account__r.OwnerId=:recordId)
                                            group by account__c, account__r.name
                                            order by sum(annual_sales__c) desc limit 10];

            List<AggregateResult> CurrentFY = [select account__c, account__r.name account_name,
                                            sum(April__c) april, sum(may__c) may, sum(june__c) june, sum(july__c) july,
                                            sum(august__c) august, sum(september__c) september, sum(october__c) october,
                                            sum(november__c) november, sum(december__c) december, sum(january__c) january,
                                            sum(february__c) february, sum(march__c) march, sum(annual_sales__c) annual,
                                            sum(April_qty__c) apr_qty, sum(May_qty__c) may_qty, sum(June_qty__c) jun_qty,
                                            sum(July_qty__c) jul_qty, sum(August_qty__c) aug_qty, sum(September_qty__c) sep_qty,
                                            sum(October_qty__c) oct_qty, sum(November_qty__c) nov_qty, sum(December_qty__c) dec_qty,
                                            sum(January_qty__c) jan_qty, sum(February_qty__c) feb_qty, sum(March_qty__c) mar_qty,
                                            sum(annual_qty__c) annual_qty
                                            from QV_Sales__c where (FY__c=:CurrFY) and (account__r.OwnerId=:recordId)
                                            group by account__c, account__r.name
                                            order by sum(annual_sales__c) desc limit 10];
            for(AggregateResult ar:LastFY){
                String AccountId = (String)ar.get('account__c');
                if(dataMap.get(AccountId)==null){
                    dataMap.put(AccountId, new TopTenCustomer());
                    dataMap.get(AccountId).AccountId = (String)ar.get('account__c');
                    dataMap.get(AccountId).AccountName = (String)ar.get('account_name');
                }
                dataMap.get(AccountId).AprValLY = (Double)ar.get('april')*conversionRate;
                dataMap.get(AccountId).MayValLY = (Double)ar.get('may')*conversionRate;
                dataMap.get(AccountId).JunValLY = (Double)ar.get('june')*conversionRate;
                dataMap.get(AccountId).JulValLY = (Double)ar.get('july')*conversionRate;
                dataMap.get(AccountId).AugValLY = (Double)ar.get('august')*conversionRate;
                dataMap.get(AccountId).SepValLY = (Double)ar.get('september')*conversionRate;
                dataMap.get(AccountId).OctValLY = (Double)ar.get('october')*conversionRate;
                dataMap.get(AccountId).NovValLY = (Double)ar.get('november')*conversionRate;
                dataMap.get(AccountId).DecValLY = (Double)ar.get('december')*conversionRate;
                dataMap.get(AccountId).JanValLY = (Double)ar.get('january')*conversionRate;
                dataMap.get(AccountId).FebValLY = (Double)ar.get('february')*conversionRate;
                dataMap.get(AccountId).MarValLY = (Double)ar.get('march')*conversionRate;
                dataMap.get(AccountId).AnnualValLY = (Double)ar.get('annual')*conversionRate;
                dataMap.get(AccountId).AprVolLY = (Double)ar.get('apr_qty');
                dataMap.get(AccountId).MayVolLY = (Double)ar.get('may_qty');
                dataMap.get(AccountId).JunVolLY = (Double)ar.get('jun_qty');
                dataMap.get(AccountId).JulVolLY = (Double)ar.get('jul_qty');
                dataMap.get(AccountId).AugVolLY = (Double)ar.get('aug_qty');
                dataMap.get(AccountId).SepVolLY = (Double)ar.get('sep_qty');
                dataMap.get(AccountId).OctVolLY = (Double)ar.get('oct_qty');
                dataMap.get(AccountId).NovVolLY = (Double)ar.get('nov_qty');
                dataMap.get(AccountId).DecVolLY = (Double)ar.get('dec_qty');
                dataMap.get(AccountId).JanVolLY = (Double)ar.get('jan_qty');
                dataMap.get(AccountId).FebVolLY = (Double)ar.get('feb_qty');
                dataMap.get(AccountId).MarVolLY = (Double)ar.get('mar_qty');
                dataMap.get(AccountId).AnnualVolLY = (Double)ar.get('annual_qty');
            }

            for(AggregateResult ar:CurrentFY){
                String AccountId = (String)ar.get('account__c');
                if(dataMap.get(AccountId)==null){
                    dataMap.put(AccountId, new TopTenCustomer());
                    dataMap.get(AccountId).AccountId = (String)ar.get('account__c');
                    dataMap.get(AccountId).AccountName = (String)ar.get('account_name');
                }
                dataMap.get(AccountId).AprVal = (Double)ar.get('april')*conversionRate;
                dataMap.get(AccountId).MayVal = (Double)ar.get('may')*conversionRate;
                dataMap.get(AccountId).JunVal = (Double)ar.get('june')*conversionRate;
                dataMap.get(AccountId).JulVal = (Double)ar.get('july')*conversionRate;
                dataMap.get(AccountId).AugVal = (Double)ar.get('august')*conversionRate;
                dataMap.get(AccountId).SepVal = (Double)ar.get('september')*conversionRate;
                dataMap.get(AccountId).OctVal = (Double)ar.get('october')*conversionRate;
                dataMap.get(AccountId).NovVal = (Double)ar.get('november')*conversionRate;
                dataMap.get(AccountId).DecVal = (Double)ar.get('december')*conversionRate;
                dataMap.get(AccountId).JanVal = (Double)ar.get('january')*conversionRate;
                dataMap.get(AccountId).FebVal = (Double)ar.get('february')*conversionRate;
                dataMap.get(AccountId).MarVal = (Double)ar.get('march')*conversionRate;
                dataMap.get(AccountId).AnnualVal = (Double)ar.get('annual')*conversionRate;
                dataMap.get(AccountId).AprVol = (Double)ar.get('apr_qty');
                dataMap.get(AccountId).MayVol = (Double)ar.get('may_qty');
                dataMap.get(AccountId).JunVol = (Double)ar.get('jun_qty');
                dataMap.get(AccountId).JulVol = (Double)ar.get('jul_qty');
                dataMap.get(AccountId).AugVol = (Double)ar.get('aug_qty');
                dataMap.get(AccountId).SepVol = (Double)ar.get('sep_qty');
                dataMap.get(AccountId).OctVol = (Double)ar.get('oct_qty');
                dataMap.get(AccountId).NovVol = (Double)ar.get('nov_qty');
                dataMap.get(AccountId).DecVol = (Double)ar.get('dec_qty');
                dataMap.get(AccountId).JanVol = (Double)ar.get('jan_qty');
                dataMap.get(AccountId).FebVol = (Double)ar.get('feb_qty');
                dataMap.get(AccountId).MarVol = (Double)ar.get('mar_qty');
                dataMap.get(AccountId).AnnualVol = (Double)ar.get('annual_qty');
            }
            //dataTopTenCustomer = dataMap.values();
            for(TopTenCustomer d: dataMap.values()){
                d.RollingVal = getLastRollingVal(d, month);
                d.RollingVol = getLastRollingVol(d, month);
                System.debug('XXX Get last rolling values :'+' Cust.Name:'+d.AccountName+' : Values : '+d.RollingVal+' Volumne : '+d.RollingVol);
                dataList.add(d);
            }
            System.debug('XXX Get Top Ten Customer by OwnerId == > '+dataList);
            return dataList;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    public static double getLastRollingVal(TopTenCustomer a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY;}
                when 2 {result = a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY;}
                when 3 {result = a.FebVal+a.JanVal+a.DecVal+a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY;}
                when 4 {result = a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY+a.AprValLY;}
                when 5 {result = a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY+a.MayValLY;}
                when 6 {result = a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY+a.JunValLY;}
                when 7 {result = a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY+a.JulValLY;}
                when 8 {result = a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY+a.AugValLY;}
                when 9 {result = a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY+a.SepValLY;}
                when 10 {result = a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY+a.OctValLY;}
                when 11 {result = a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY+a.NovValLY;}
                when 12 {result = a.NovVal+a.OctVal+a.SepVal+a.AugVal+a.JulVal+a.JunVal+a.MayVal+a.AprVal+a.MarValLY+a.FebValLY+a.JanValLY+a.DecValLY;}
                when else{result = 0;}
            }
            
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    public static double getLastRollingVol(TopTenCustomer a, Integer month){
        double result = 0;
        try{
            switch on month{
                when 1 {result = a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY;}
                when 2 {result = a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY;}
                when 3 {result = a.FebVol+a.JanVol+a.DecVol+a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY;}
                when 4 {result = a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY+a.AprVolLY;}
                when 5 {result = a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY+a.MayVolLY;}
                when 6 {result = a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY+a.JunVolLY;}
                when 7 {result = a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY+a.JulVolLY;}
                when 8 {result = a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY+a.AugVolLY;}
                when 9 {result = a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY+a.SepVolLY;}
                when 10 {result = a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY+a.OctVolLY;}
                when 11 {result = a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY+a.NovVolLY;}
                when 12 {result = a.NovVol+a.OctVol+a.SepVol+a.AugVol+a.JulVol+a.JunVol+a.MayVol+a.AprVol+a.MarVolLY+a.FebVolLY+a.JanVolLY+a.DecVolLY;}
                when else {result = 0;}
            }
        }catch(Exception e){
            LogException.log(e);
            System.debug('XXX An error was occurred');
        }
        return result;
    }

    @AuraEnabled
    public static List<NewSalesSegmentation> getNewSegmentation(Id recordId){
        try {
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            System.debug('Original User Currency ISO Code == >'+userCurrency);

            //Double USDConversionRate = [select conversionRate from CurrencyType WHERE IsoCode='USD'].conversionRate;
            //System.debug('USD Conversion Rate == > '+USDConversionRate);

            Double userConversionRate = [select conversionRate from CurrencyType where IsoCode=:userCurrency].conversionRate;
            //Double Seg = USDConversionRate * UserConversionRate;
            //System.debug('Conversion Rate to USD : '+seg);

            List<NewSalesSegmentation> dataList = new List<NewSalesSegmentation>();
            Map<String, NewSalesSegmentation> dataMap = new Map<String, NewSalesSegmentation>();

            List<AggregateResult> LastFY = [select standard_segmentation__c segment, 
                                            sum(Actuals_April_Last_Year__c) april, 
                                            sum(Actuals_May_Last_Year__c) may, 
                                            sum(Actuals_June_Last_Year__c) june, 
                                            sum(Actuals_July_Last_Year__c) july, 
                                            sum(Actuals_August_Last_Year__c) august, 
                                            sum(Actuals_September_Last_Year__c) september, 
                                            sum(Actuals_October_Last_Year__c) october, 
                                            sum(Actuals_November_Last_Year__c) november, 
                                            sum(Actuals_December_Last_Year__c) december, sum(Actuals_January_Last_Year__c) january, 
                                            sum(Actuals_February_Last_Year__c) february, sum(Actuals_March_Last_Year__c) march, 
                                            sum(annualrevenue) annual from account where ownerid =: recordId 
                                            group by standard_segmentation__c order by standard_segmentation__c asc];
            /*                               
            List<AggregateResult> ActiveCust = [select standard_segmentation__c segment, count_distinct(hoya_account_id__c) accountid from account 
                                                where ownerid=:recordId 
                                                group by standard_segmentation__c 
                                                order by standard_segmentation__c asc];
            */
            for(AggregateResult ar:LastFY){
                String segmentation = (String)ar.get('segment');
                if(dataMap.get(segmentation)==null){
                    dataMap.put(segmentation, new NewSalesSegmentation());
                    dataMap.get(segmentation).segmentation = (String)ar.get('segment');
                }
                dataMap.get(segmentation).AprVal = (Double)ar.get('april');
                dataMap.get(segmentation).MayVal = (Double)ar.get('may');
                dataMap.get(segmentation).JunVal = (Double)ar.get('june');
                dataMap.get(segmentation).JulVal = (Double)ar.get('july');
                dataMap.get(segmentation).AugVal = (Double)ar.get('august');
                dataMap.get(segmentation).SepVal = (Double)ar.get('september');
                dataMap.get(segmentation).OctVal = (Double)ar.get('october');
                dataMap.get(segmentation).NovVal = (Double)ar.get('november');
                dataMap.get(segmentation).DecVal = (Double)ar.get('december');
                dataMap.get(segmentation).JanVal = (Double)ar.get('january');
                dataMap.get(segmentation).FebVal = (Double)ar.get('february');
                dataMap.get(segmentation).MarVal = (Double)ar.get('march');
                dataMap.get(segmentation).AnnualVal = (Double)ar.get('annual');
            }
            /*
            for(AggregateResult ar:ActiveCust){
                String segmentation = (String)ar.get('segment');
                if(dataMap.get(segmentation)==null){
                    dataMap.put(segmentation, new NewSalesSegmentation());
                    dataMap.get(segmentation).segmentation = (String)ar.get('segment');
                }
                dataMap.get(segmentation).ActiveCust = (Double)ar.get('accountid');
            }
            */
            for(NewSalesSegmentation n : dataMap.values()){
                dataList.add(n);
            }
            System.debug('XXX Get New Segmentation and Active Cust == >'+dataList);
            return dataList;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<NewSalesSegmentation> getNewSubArea(Id recordId){
        try {
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            System.debug('Original User Currency ISO Code == >'+userCurrency);

            //Double USDConversionRate = [select conversionRate from CurrencyType WHERE IsoCode='USD'].conversionRate;
            //System.debug('USD Conversion Rate == > '+USDConversionRate);

            Double userConversionRate = [select conversionRate from CurrencyType where IsoCode=:userCurrency].conversionRate;
            //Double Seg = USDConversionRate * UserConversionRate;
            //System.debug('Conversion Rate to USD : '+seg);

            List<NewSalesSegmentation> dataList = new List<NewSalesSegmentation>();
            Map<String, NewSalesSegmentation> dataMap = new Map<String, NewSalesSegmentation>();

            List<AggregateResult> LastFY = [select zonal__c zone, 
                                            sum(Actuals_April_Last_Year__c) april, 
                                            sum(Actuals_May_Last_Year__c) may, 
                                            sum(Actuals_June_Last_Year__c) june, 
                                            sum(Actuals_July_Last_Year__c) july, 
                                            sum(Actuals_August_Last_Year__c) august, 
                                            sum(Actuals_September_Last_Year__c) september, 
                                            sum(Actuals_October_Last_Year__c) october, 
                                            sum(Actuals_November_Last_Year__c) november, 
                                            sum(Actuals_December_Last_Year__c) december, sum(Actuals_January_Last_Year__c) january, 
                                            sum(Actuals_February_Last_Year__c) february, sum(Actuals_March_Last_Year__c) march, 
                                            sum(annualrevenue) annual from account where ownerid =: recordId 
                                            group by zonal__c order by zonal__c asc];
            /*                               
            List<AggregateResult> ActiveCust = [select zonal__c zone, count_distinct(hoya_account_id__c) accountid from account 
                                                where ownerid=:recordId 
                                                group by zonal__c 
                                                order by zonal__c asc];
            */
            for(AggregateResult ar:LastFY){
                String segmentation = (String)ar.get('zone');
                if(dataMap.get(segmentation)==null){
                    dataMap.put(segmentation, new NewSalesSegmentation());
                    dataMap.get(segmentation).segmentation = (String)ar.get('zone');
                }
                dataMap.get(segmentation).AprVal = (Double)ar.get('april');
                dataMap.get(segmentation).MayVal = (Double)ar.get('may');
                dataMap.get(segmentation).JunVal = (Double)ar.get('june');
                dataMap.get(segmentation).JulVal = (Double)ar.get('july');
                dataMap.get(segmentation).AugVal = (Double)ar.get('august');
                dataMap.get(segmentation).SepVal = (Double)ar.get('september');
                dataMap.get(segmentation).OctVal = (Double)ar.get('october');
                dataMap.get(segmentation).NovVal = (Double)ar.get('november');
                dataMap.get(segmentation).DecVal = (Double)ar.get('december');
                dataMap.get(segmentation).JanVal = (Double)ar.get('january');
                dataMap.get(segmentation).FebVal = (Double)ar.get('february');
                dataMap.get(segmentation).MarVal = (Double)ar.get('march');
                dataMap.get(segmentation).AnnualVal = (Double)ar.get('annual');
            }
            /*
            for(AggregateResult ar:ActiveCust){
                String segmentation = (String)ar.get('zone');
                if(dataMap.get(segmentation)==null){
                    dataMap.put(segmentation, new NewSalesSegmentation());
                    dataMap.get(segmentation).segmentation = (String)ar.get('zone');

                }
                dataMap.get(segmentation).ActiveCust = (Double)ar.get('accountid');
            }
            */
            for(NewSalesSegmentation n : dataMap.values()){
                dataList.add(n);

            }
            System.debug('XXX Get Sales figure by Sub-area : '+dataList);
            return dataList;
            
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
    @AuraEnabled
    public static List<SalesSegmentation> getDataSegmentationOwnerId(Id recordId){
        try {

            List<AggregateResult> lstAgg = [select standard_segmentation__c segment, 
                                            sum(Actuals_April_Last_Year__c) april, 
                                            sum(Actuals_May_Last_Year__c) may, 
                                            sum(Actuals_June_Last_Year__c) june, 
                                            sum(Actuals_July_Last_Year__c) july, 
                                            sum(Actuals_August_Last_Year__c) august, 
                                            sum(Actuals_September_Last_Year__c) september, 
                                            sum(Actuals_October_Last_Year__c) october, 
                                            sum(Actuals_November_Last_Year__c) november, 
                                            sum(Actuals_December_Last_Year__c) december, sum(Actuals_January_Last_Year__c) january, 
                                            sum(Actuals_February_Last_Year__c) february, sum(Actuals_March_Last_Year__c) march, 
                                            sum(annualrevenue) annual from account where ownerid =: recordId 
                                            group by standard_segmentation__c order by standard_segmentation__c asc];
            List<SalesSegmentation> dataset = new List<SalesSegmentation>();
            for(AggregateResult ar:lstAgg){
                String segmentation = (String)ar.get('segment');
                Double AprValLY = (Double)ar.get('april');
                Double MayValLY = (Double)ar.get('may');
                Double JunValLY = (Double)ar.get('june');
                Double JulValLY = (Double)ar.get('july');
                Double AugValLY = (Double)ar.get('august');
                Double SepValLY = (Double)ar.get('september');
                Double OctValLY = (Double)ar.get('october');
                Double NovValLY = (Double)ar.get('november');
                Double DecValLY = (Double)ar.get('december');
                Double JanValLY = (Double)ar.get('january');
                Double FebValLY = (Double)ar.get('february');
                Double MarValLY = (Double)ar.get('march');
                Double AnnualRevenue = (Double)ar.get('annual');
                
                dataset.add(new SalesSegmentation(segmentation, AprValLY, MayValLY, JunValLY, JulValLY, AugValLY, SepValLY, OctValLY, NovValLY, DecValLY, JanValLY, FebValLY, MarValLY, AnnualRevenue));
            }
            System.debug('XXX Get Data == >'+dataset);
            return dataset;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    /*
    @AuraEnabled
    public static List<SalesSegmentation> getSubAreaSalesByOwnerId(Id recordId){
        try {
            List<AggregateResult> result = [select zonal__c sub_area, 
                                            sum(Actuals_April_Last_Year__c) april, 
                                            sum(Actuals_May_Last_Year__c) may, 
                                            sum(Actuals_June_Last_Year__c) june, 
                                            sum(Actuals_July_Last_Year__c) july, 
                                            sum(Actuals_August_Last_Year__c) august, 
                                            sum(Actuals_September_Last_Year__c) september, 
                                            sum(Actuals_October_Last_Year__c) october, 
                                            sum(Actuals_November_Last_Year__c) november, 
                                            sum(Actuals_December_Last_Year__c) december, sum(Actuals_January_Last_Year__c) january, 
                                            sum(Actuals_February_Last_Year__c) february, sum(Actuals_March_Last_Year__c) march, 
                                            sum(annualrevenue) annual from account where ownerid =:recordId
                                            group by zonal__c order by zonal__c asc];
            List<SalesSegmentation> dataset = new List<SalesSegmentation>();
            for(AggregateResult ar:result){
                String SubArea = (String)ar.get('sub_area');
                Double AprValLY = (Double)ar.get('april');
                Double MayValLY = (Double)ar.get('may');
                Double JunValLY = (Double)ar.get('june');
                Double JulValLY = (Double)ar.get('july');
                Double AugValLY = (Double)ar.get('august');
                Double SepValLY = (Double)ar.get('september');
                Double OctValLY = (Double)ar.get('october');
                Double NovValLY = (Double)ar.get('november');
                Double DecValLY = (Double)ar.get('december');
                Double JanValLY = (Double)ar.get('january');
                Double FebValLY = (Double)ar.get('february');
                Double MarValLY = (Double)ar.get('march');
                Double AnnualRevenue = (Double)ar.get('annual');

                dataset.add(new SalesSegmentation(SubArea, AprValLY, MayValLY, JunValLY, JulValLY, AugValLY, SepValLY, OctValLY, NovValLY, DecValLY, JanValLY, FebValLY, MarValLY, AnnualRevenue));
            }
            System.debug('XXX Get data subare by owner id : '+dataset);
            return dataset;
            
        }catch(Exception e){
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static List<LevelInterested> getCampaignLevelInterested(Id recordId){
        try {

            List<LevelInterested> datalist = new List<LevelInterested>();
            Map<String, LevelInterested> dataMap = new Map<String, LevelInterested>();

            List<AggregateResult> listNotInterested = [SELECT central_campaign__r.name CampaignName, COUNT_DISTINCT(account_name__c) lstNotInterested
                                                    FROM Account_Campaing_Member__c 
                                                    WHERE (account_name__r.ownerid=:recordId) 
                                                    AND (level_interest__c = 'Not interested') 
                                                    AND (campaign_active__c = true)
                                                    GROUP BY central_campaign__r.name, level_interest__c 
                                                    ORDER BY central_campaign__r.name asc];
            
            List<AggregateResult> listPartialInterested = [SELECT central_campaign__r.name CampaignName, COUNT_DISTINCT(account_name__c) lstPartialInterested
                                                    FROM Account_Campaing_Member__c 
                                                    WHERE (account_name__r.ownerid=:recordId) 
                                                    AND (level_interest__c = 'Partially interested') 
                                                    AND (campaign_active__c = true) 
                                                    GROUP BY central_campaign__r.name, level_interest__c 
                                                    ORDER BY central_campaign__r.name asc];
            
            List<AggregateResult> listInterested = [SELECT central_campaign__r.name CampaignName, COUNT_DISTINCT(account_name__c) lstInterested
                                                    FROM Account_Campaing_Member__c 
                                                    WHERE (account_name__r.ownerid=:recordId) 
                                                    AND (level_interest__c = 'Interested') 
                                                    AND (campaign_active__c = true) 
                                                    GROUP BY central_campaign__r.name, level_interest__c 
                                                    ORDER BY central_campaign__r.name asc];
            
            List<AggregateResult> listVeryInterested = [SELECT central_campaign__r.name CampaignName, COUNT_DISTINCT(account_name__c) lstVeryInterested
                                                        FROM Account_Campaing_Member__c 
                                                        WHERE (account_name__r.ownerid=:recordId) 
                                                        AND (level_interest__c = 'Very Interested') 
                                                        AND (campaign_active__c = true) 
                                                        GROUP BY central_campaign__r.name, level_interest__c 
                                                        ORDER BY central_campaign__r.name asc];
            
            for(AggregateResult ar:listNotInterested){
                String CampaignName = (String)ar.get('CampaignName');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new LevelInterested());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('CampaignName');
                }
                dataMap.get(CampaignName).InterestedLevel1 = (Double)ar.get('lstNotInterested');
            }

            for(AggregateResult ar:listPartialInterested){
                String CampaignName = (String)ar.get('CampaignName');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new LevelInterested());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('CampaignName');
                }
                dataMap.get(CampaignName).InterestedLevel2 = (Double)ar.get('lstPartialInterested');
            }

            for(AggregateResult ar:listInterested){
                String CampaignName = (String)ar.get('CampaignName');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new LevelInterested());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('CampaignName');
                }
                dataMap.get(CampaignName).InterestedLevel3 = (Double)ar.get('lstInterested');
            }

            for(AggregateResult ar:listVeryInterested){
                String CampaignName = (String)ar.get('CampaignName');
                if(dataMap.get(CampaignName)==null){
                    dataMap.put(CampaignName, new LevelInterested());
                    dataMap.get(CampaignName).CampaignName = (String)ar.get('CampaignName');
                }
                dataMap.get(CampaignName).InterestedLevel4 = (Double)ar.get('lstVeryInterested');
            }

            dataLevelInterested = dataMap.values();
            System.debug('XXX Get data == > '+dataLevelInterested);
            return dataLevelInterested;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<VisitDataSet> getAccountActiveCounting(Id recordId, String yeartext, String monthtext, Decimal SegmentValue){
        try{

            Integer month = Date.today().month();
            Integer year = Date.today().year();
            String userCompany = [select companyName from User where Id=:recordId].companyName;
            System.debug('User Company Name is '+userCompany);

            if((month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }

            String userCurrency = [select Id, CurrencyIsoCode from User where Id=:recordId].CurrencyIsoCode;
            Double userConversionRate = [select ConversionRate from CurrencyType where IsoCode=:userCurrency].ConversionRate;
            Double USDConversionRate = [select ConversionRate from CurrencyType where IsoCode = 'USD'].ConversionRate;
            Double convertToUSD = userConversionRate/USDConversionRate;
            Double SegmentData = convertToUSD*SegmentValue;
            System.debug('Get User Conversion Rate '+userConversionRate+' | '+userCurrency);
            System.debug('Convert to USD Dollar '+convertToUSD+' Segmentation Value after convert '+'from USD '+SegmentValue+' = '+SegmentData+' '+userCurrency);

            String FY = '';
            if(yeartext == 'CY'){
                FY = 'FY-' + String.valueOf(year).substring(2);
            }else if(yeartext == 'LY'){
                FY = 'FY-' + String.valueOf(year-1).substring(2);
            }else{
                FY = 'FY-' + String.valueOf(year).substring(2);
            }
            System.debug('Fiscal year is '+FY);

            List<AggregateResult> AprResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and april__c >:SegmentData];
            
            List<AggregateResult> MayResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and may__c >:SegmentData];
                                                                                    
            List<AggregateResult> JunResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and june__c >:SegmentData];

            List<AggregateResult> JulResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and july__c >:SegmentData];

            List<AggregateResult> AugResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and august__c >:SegmentData];
                                                
            List<AggregateResult> SepResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and September__c >:SegmentData];
            List<AggregateResult> OctResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c 
                                                where account__r.ownerid=:recordId
                                                and fy__c =:FY and October__c >:SegmentData];
            List<AggregateResult> NovResult = [select count_distinct(hoya_account_id__c) activeCust
                                                from qv_sales__c where account__r.ownerid =: recordId
                                                and fy__c=:FY and november__c >:SegmentData];
            List<AggregateResult> DecResult = [select count_distinct(hoya_account_id__c) activeCust
                                                from qv_sales__c where account__r.ownerId=:recordId
                                                and fy__c=:FY and december__c >:SegmentData];
            List<AggregateResult> JanResult = [select count_distinct(hoya_account_id__c) activeCust
                                                from qv_sales__c where account__r.ownerId =: recordId
                                                and fy__c =:FY and january__c >:SegmentData];
            List<AggregateResult> FebResult = [select count_distinct(hoya_account_id__c) activeCust
                                                from qv_sales__c where account__r.ownerId=:recordId
                                                and fy__c=:FY and february__c >: SegmentData];
            List<AggregateResult> MarResult = [select count_distinct(hoya_account_id__c) activeCust 
                                                from qv_sales__c where account__r.ownerId=:recordId
                                                and fy__c =: FY and march__c >: SegmentData];
            List<AggregateResult> AnnualResult = [select count_distinct(hoya_account_id__c) activeCust
                                                    from QV_Sales__c where account__r.ownerid=:recordId
                                                    and fy__c =: FY and annual_sales__c >: SegmentData];
            
            List<VisitDataSet> dataset = new List<VisitDataSet>();

            if(monthtext == 'APR'){
                for(AggregateResult ar : AprResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if (monthtext == 'MAY'){
                for(AggregateResult ar : MayResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if (monthtext == 'JUN'){
                for(AggregateResult ar : JunResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'JUL'){
                for(AggregateResult ar : JulResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'AUG'){
                for(AggregateResult ar : AugResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'SEP'){
                for(AggregateResult ar : SepResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'OCT'){
                for(AggregateResult ar : OctResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'NOV'){
                for(AggregateResult ar : NovResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'DEC'){
                for(AggregateResult ar : DecResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'JAN'){
                for(AggregateResult ar : JanResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'FEB'){
                for(AggregateResult ar : FebResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'MAR'){
                for(AggregateResult ar : MarResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }else if(monthtext == 'ANNUAL'){
                for(AggregateResult ar : AnnualResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }
            else{
                for(AggregateResult ar : AprResult){
                    Double counting = (Double)ar.get('activeCust');
                    dataset.add(new VisitDataSet(counting));
                }
            }
            System.debug('Get Active Account :  '+dataset);
            return dataset;
            
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**========= Get campaign acc.member that not present and active campaign ============= */
    @AuraEnabled
    public static List<DataSet> getCampaignNotPresented(Id recordId){
        try {
            List<AggregateResult> result = [SELECT Central_Campaign__r.Name CampName, 
                                            COUNT_DISTINCT(Account_Name__c) CntActive
                                            FROM Account_Campaing_Member__c 
                                            WHERE (Campaign_Presented__c = false) AND (campaign_active__c = true)
                                            AND (account_name__r.ownerid =: recordId)
                                            GROUP BY central_campaign__r.name 
                                            ORDER BY central_campaign__r.name asc];
            List<DataSet> data = new List<DataSet>();
            for(AggregateResult ar:result){
                String CampaignName = (String)ar.get('CampName');
                Double ActiveCamp = (Double)ar.get('CntActive');
                data.add(new DataSet(CampaignName, ActiveCamp));
            }
            System.debug('XXX Get Data for Campaign not presented : ==> '+data);
            return data;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**========= Get Data for Active Acc. Campaign Member => just only Active Campaign ======== */
    @AuraEnabled
    public static List<DataSet> getActiveAccCampaign(Id recordId){
        try {
            List<AggregateResult> result = [SELECT Central_Campaign__r.name Camp_Name, 
                                            COUNT_DISTINCT(Account_Name__c) CntActive
                                            FROM Account_Campaing_Member__c 
                                            WHERE Central_Campaign__r.isactive=true 
                                            AND account_name__r.ownerid=:recordId 
                                            GROUP BY central_campaign__r.name, account_name__r.ownerid 
                                            ORDER BY central_campaign__r.name ASC LIMIT 1000];
            List<DataSet> data = new List<DataSet>();
            for(AggregateResult ar:result){
                String CampName = (String)ar.get('Camp_Name');
                Double ActiveCamp = (Double)ar.get('CntActive');
                data.add(new DataSet(CampName, ActiveCamp));
            }
            System.debug('XXX Get dataset for Active Acc.Campaign Member == >'+data);
            return data;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**Get Data for Visits == > list by segmentation completed visits last 30 days */
    /*
    @AuraEnabled
    public static List<DataSet> getCompletedVisitsBySegmentation(Id recordId){
        try {
            List<AggregateResult> result = [SELECT Account__r.Standard_Segmentation__c Segmentation, 
                                            COUNT(Id) visits FROM Visits__c WHERE (Assigned_to__c =:recordId)  
                                            AND (Start_Time__c=LAST_N_DAYS:30) AND (Visit_Status__c = 'Complete') 
                                            GROUP BY Account__r.Standard_Segmentation__c 
                                            ORDER BY Account__r.Standard_Segmentation__c ASC];
            List<DataSet> dataset = new List<DataSet>();
            for(AggregateResult ar:result){
                String segment = (String)ar.get('Segmentation');
                Double visits = (Double)ar.get('visits');
                dataset.add(new DataSet(segment, visits));
            }
            System.debug('XXX Get Completed Visits in Last 30 days == >'+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    /**================= Get data for Opportunity by StageName created last 3 months =========== */
    @AuraEnabled
    public static List<DataSet> getOppStageByLast3Month(Id recordId){
        try {
            List<AggregateResult> result = [SELECT StageName, count(Id) oppCnt 
                                            FROM Opportunity 
                                            WHERE (CreatedDate = LAST_N_MONTHS:3) 
                                            AND (OwnerId=:recordId) 
                                            GROUP BY StageName ORDER BY StageName ASC];
            List<DataSet> dataset = new List<DataSet>();
            for(AggregateResult ar:result){
                String Stage_Name = (String)ar.get('StageName');
                Double oppCnt = (Double)ar.get('oppCnt');
                dataset.add(new DataSet(Stage_Name, oppCnt));
            }
            System.debug('XXX Get Data for Opportunity by stage created last 3 months : '+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**Get data for sub-area visits (completed) in last 30 days */
    /*
    @AuraEnabled
    public static List<DataSet> getCompletedVisitsBySubArea(Id recordId){
        try {
            List<AggregateResult> result = [SELECT Account__r.Zonal__c VisitZone, 
                                            COUNT(Id) visits from visits__c 
                                            WHERE assigned_to__c =: recordId 
                                            AND Visit_Status__c = 'Complete' 
                                            AND Start_time__c=LAST_N_DAYS:30 
                                            GROUP BY Account__r.Zonal__c 
                                            ORDER BY Account__r.Zonal__c ASC];
            List<DataSet> dataset = new List<DataSet>();
            for(AggregateResult ar:result){
                String subarea = (String)ar.get('VisitZone');
                Double visits = (Double)ar.get('visits');
                dataset.add(new DataSet(subarea, visits));
            }
            System.debug('XXX Get Data Sub-area visits complete in last 30 days : '+dataset);
            return dataset;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    //getdata for complete visit in zone management
    @AuraEnabled
    public static List<DataSet> getVisitZone(Id recordId){
        List<Id> userId = new List<Id>();

        for(User usr : [select Id, Name from User where Id=:recordId] ){
            userId.add(usr.Id);
            System.debug('Get data for getVisitZone Data for User Id : '+userId);
        }

        List<AggregateResult> result = [SELECT Account__r.Zonal__c Zonal, 
                                            COUNT(Id) visits FROM Visits__c WHERE (Assigned_to__c =:userId)  
                                            AND (Start_Time__c=LAST_N_DAYS:30) AND (Visit_Status__c = 'Complete') 
                                            GROUP BY account__r.Zonal__c ORDER BY account__r.zonal__c asc];
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar :result ){
            String zonal = (String)ar.get('Zonal');
            Double visits = (Double)ar.get('Visits');
            dataset.add(new DataSet(zonal, visits));
        }
        System.debug('Data set for get data for Zonal, complete visits'+dataset);
        return dataset;
    }

    //get dataset for visit planning in next 30 days, by segmentation
    @AuraEnabled
    public static List<DataSet> getPlannedVisit(Id recordId){
        List<Id> userId = new List<Id>();
        for(User usr : [select Id, Name from User where Id=:recordId]){
            userId.add(usr.Id);
        }
        System.debug('Get Planned Visit Data == > '+userId);

        List<AggregateResult> result = [SELECT account__r.Standard_Segmentation__c segment, 
                                    COUNT(Id) visits FROM Visits__c 
                                    WHERE start_time__c = NEXT_N_DAYS:30 
                                    AND visit_status__c = 'Planned' 
                                    AND assigned_to__c =:userId 
                                    GROUP BY account__r.Standard_Segmentation__c 
                                    ORDER BY account__r.Standard_Segmentation__c asc];
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar:result){
            String segment = (String)ar.get('segment');
            Double visits = (Double)ar.get('visits');
            dataset.add(new DataSet(segment, visits));
        }
        System.debug('Get data for Visit Planned by Segment '+dataset);
        return dataset;
    }

    @AuraEnabled
    public static List<Opportunity> getOpportunityInfo(Id recordId){
        try{
            List<RecordType> recordTypeIds = [select Id from RecordType where sObjectType='Opportunity' and developerName in ('Hunting_Opportunities')];
            System.debug('Record Type Id '+recordTypeIds.size());

            List<Opportunity> oppList = [SELECT Name, StageName, Account.Name, ExpectedRevenue, Amount, CloseDate, NextStep, 
                                            Days_Remain_To_Close__c, Days_in_the_current_Stage__c, Description, Account.Potential__c,
                                            Owner.Name, Probability, CurrencyIsoCode FROM Opportunity 
                                            WHERE OwnerId=:recordId AND RecordTypeId IN:recordTypeIds AND
                                            IsClosed = false 
                                            ORDER BY LastModifiedDate DESC LIMIT 1000];
            System.debug('Get data from opportunity : '+oppList.size());
            return oppList;

        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Account_Campaing_Member__c> getAccCampaignMember(Id recordId, String CampaignId){
        List<Id> usrId = new List<Id>();
        for(User usr : [select Id from User where Id=:recordId]){
            usrId.add(usr.Id);
        }
        System.debug('Get User Id for Account Campaign Member = '+usrId);
        List<Account_Campaing_Member__c> accCamMember1 = [select Id, Name, campaign_active__c, Campaign_Presented__c,
                            Date_of_presentation__c, Account_Name__r.Name, Campaign_Start_Date_t__c,
                            Campaign_End_Date_t__c, Other_information__c, Comments__c, Central_Campaign__r.Name,
                            Campaign_Interested__c from Account_Campaing_Member__c
                            where Account_Name__r.OwnerId=:usrId order by LastModifiedDate DESC limit 10];
        
        List<Account_Campaing_Member__c> accCamMember2 = [select Id, Name, campaign_active__c, Campaign_Presented__c,
                            Date_of_presentation__c, Account_Name__r.Name, Campaign_Start_Date_t__c,
                            Campaign_End_Date_t__c, Other_information__c, Comments__c, Central_Campaign__r.Name,
                            Campaign_Interested__c from Account_Campaing_Member__c where Account_Name__r.OwnerId=:usrId and Central_Campaign__c=:CampaignId
                            order by LastModifiedDate DESC limit 10];
        
        List<Account_Campaing_Member__c> CampaignList = new List<Account_Campaing_Member__c>();
        if(CampaignId == null || CampaignId==''){
            for(Account_Campaing_Member__c ac : accCamMember1){
                CampaignList.add(ac);
            }
        }else if(CampaignId != null || CampaignId != ''){
            for(Account_Campaing_Member__c ac : accCamMember2){
                CampaignList.add(ac);
            }
        }else{
            for(Account_Campaing_Member__c ac : accCamMember1){
                CampaignList.add(ac);
            }
        }
        System.debug('Get Record from Account Campaign Member: record(s) '+CampaignList.size()+' | '+CampaignList);
        return CampaignList;
    }

    @AuraEnabled
    public static List<DataSetCampaignName> getDataSetCampaignName(Id recordId){
        try {
            List<AggregateResult> result = [SELECT central_campaign__r.name CampaignName 
                                            FROM Account_Campaing_Member__c 
                                            WHERE Account_OwnerId__c=:recordId 
                                            GROUP BY central_campaign__r.name 
                                            ORDER BY central_campaign__r.name ASC];

            List<DataSetCampaignName> dataset = new List<DataSetCampaignName>();

            for(AggregateResult ar : result){
                String CampaignName = (String)ar.get('CampaignName');
                dataset.add(new DataSetCampaignName(CampaignName));
            }
            System.debug('XXX Get data for Central Campaign Name == > '+dataset);
            return dataset;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getDataSetStartDate(Id recordId, String LastVisitDay, String Visit_Status){
        try {
            
            Set<String> startDateset = new Set<String>();
            if(LastVisitDay == 'LAST_N_DAYS:7'){
                for(Visits__c v : [SELECT Start_Date_Text__c FROM Visits__c WHERE (Start_Day__c=LAST_N_DAYS:7) AND (Assigned_to__c=:recordId) AND (Visit_Status__c=:Visit_Status) ORDER BY Start_Day__c DESC LIMIT 100]){
                    startDateset.add(v.Start_Date_Text__c);

                }
            }else if(LastVisitDay == 'LAST_N_DAYS:30'){
                for(Visits__c v : [SELECT Start_Date_Text__c FROM Visits__c WHERE (Start_Day__c=LAST_N_DAYS:30) AND (Assigned_to__c=:recordId) AND (Visit_Status__c=:Visit_Status) ORDER BY Start_Day__c DESC LIMIT 100]){
                    startDateset.add(v.Start_Date_Text__c);

                }
            }else{
                for(Visits__c v : [SELECT Start_Date_Text__c FROM Visits__c WHERE (Start_Day__c=LAST_N_DAYS:7) AND (Assigned_to__c=:recordId) AND (Visit_Status__c=:Visit_Status) ORDER BY Start_Day__c DESC LIMIT 100]){
                    startDateset.add(v.Start_Date_Text__c);

                }
            }

            List<String> newList = new List<String>(startDateset);
            System.debug('XXX Get Data Visit : == >'+LastVisitDay);
            System.debug('XXX Visit Status : '+Visit_Status);
            System.debug('XXX Get Visit Start Date in Unique == > '+newList);
            return newList;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> GetPickListValuesForDesc(String sObjectName, String sFieldName){
        try {
            List<String> pickListValuesList = new List<String>();
            Schema.SObjectType convertToobj = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult res = convertToobj.getDescribe();
            Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(sFieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            for(Schema.PicklistEntry pickListval : ple){
                pickListValuesList.add(pickListval.getValue());
                System.debug('Get Picklist value : Label : '+pickListval.getLabel()+' - Value : '+pickListval.getValue());
            }
            return pickListValuesList;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getVisitPicklistValues(){
        try {
            List<String> Visit_Type_Picklist = APACUserPerformanceController.GetPickListValuesForDesc('Visits__c', 'Visit_Type__c');
            System.debug('XXX Get Visit Type Picklist '+Visit_Type_Picklist);
            return Visit_Type_Picklist;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getAccountCompetitorGlobalName(){
        try {
            List<String> Account_x1st_competitor_global_name = APACUserPerformanceController.GetPickListValuesForDesc('Account', 'First_Competitor_global_name__c');
            System.debug('XXX Get Account Competitor First Global Name '+Account_x1st_competitor_global_name);
            return Account_x1st_competitor_global_name;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static object getCampaignListByUser(Id recordId){
        try {
            System.debug('XXX Get Campaign Name by User : '+recordId);
            if(recordId==null){return null;}

            List<SelectOption> optionList = new List<SelectOption>();
            List<Account_Campaing_Member__c> memberList = [select central_campaign__c, central_campaign__r.name from Account_Campaing_Member__c 
                                                            where account_name__r.ownerid=:recordId and campaign_active__c = true 
                                                            order by central_campaign__r.name asc];
            if(memberList.size()>0 && memberList!=null){
                System.debug('XXX Get Campaign Name to Option == > '+memberList.size());
                for(Account_Campaing_Member__c member : memberList){
                    List<Campaign> tmpList = [select Id, Name from Campaign where Id=:member.central_campaign__c order by Name asc];
                    for(Campaign c : tmpList){
                        optionList.add(new SelectOption(c.Id, c.Name));
                        System.debug('XXX Campaign Name is '+c.Name);
                    }
                }
            }else{
                System.debug('XXX No campaign name return ');
                
            }
            return toOptionList(optionList, true);

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Option{
        @AuraEnabled public String value;
        @AuraEnabled public String label;

        public Option(String value, String label)
        {
            this.value = value;
            this.label = label;
        }
    }

    public static List<Option> toOptionList(List<SelectOption> selectOptions, Boolean addEmpty)
    {
        List<Option> optionList = new List<Option>();
        if(addEmpty)
        {
            optionList.add(new Option('', ''));
        }
        for (SelectOption option : selectOptions)
        {
            optionList.add(new Option(option.getValue(), option.getLabel()));
        }
        return optionList;
    }

    @AuraEnabled
    public static List<User_Comment__c> getUserCommentId(Id recordId){
        try {
            List<User_Comment__c> comment = [SELECT Id, Name, Comment_to_user__c, Comments__c, Send_Email__c,
                                                Topic_Sub_Subject__c, Topic_Subject__c, CreatedDate, Owner.Name FROM User_Comment__c
                                                WHERE Comment_to_user__c=:recordId ORDER BY CreatedDate DESC LIMIT 50];
            System.debug('XXX Get data for User Comment : '+comment.size()+' record(s).');
            return comment;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**====== Get data for user recordId conversion rate======= */
    @AuraEnabled
    public static double getUserIdConversionRate(Id recordId){
        try {
            String userCurrency = [SELECT DefaultCurrencyIsoCode FROM User WHERE Id=:recordId].DefaultCurrencyIsoCode;
            Double conversionRate = [SELECT conversionRate FROM CurrencyType WHERE IsoCode=:userCurrency].conversionRate;
            //if(userCurrency!='EUR'){conversionRate=1;}
            System.debug('XXX get userid conversion rate == > Currency Type : '+userCurrency+'==>'+conversionRate);
            return conversionRate;

        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**============= Get Visits Summary Roll-up Summary For Visits | Digital | Planned | Completed ======== */
    /*
    @AuraEnabled
    public static List<Account> getVisitsRollupSummary(Id recordId){
        try {
            List<Account> visit = [SELECT Id, Name, Digital_Visits_Planned__c, Digital_Visits_Complete__c, 
                                        Visit_Completed__c, Visits_Planed__c, Visits_Total__c FROM Account 
                                        WHERE OwnerId =: recordId 
                                        ORDER BY Visits_total__c DESC LIMIT 10];
            if(!visit.isEmpty()){
                System.debug('XXX Get Visit Roll-up Summary Account : '+visit.size()+' record(s) : '+visit);
                return visit;
            }else{
                return null;
            }
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}