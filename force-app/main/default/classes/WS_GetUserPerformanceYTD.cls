/**
 * This web service is used to send the User Performance Report for HLBR Company
 * 
 */
@RestResource(urlMapping = '/GetUserPerformanceYTD')
global class WS_GetUserPerformanceYTD {
    global WS_GetUserPerformanceYTD() {

    }
    @HttpGet
    global static void getPerformanceYTDReport() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        List<Budget_by_ASM__c> budgetByAsmList = [SELECT Id,LookupUser__r.CompanyName,LookupUser__r.Manager.Name,LookupUser__r.Name,Data_last_Updated__c,Name,Quota_YTD__c,Local_Sales_YTD__c,Quota_Ach_YTD__c,Sales_YTD_vsLY__c,Months_in_the_Area__c,last_3_months_under_performance__c,
                                                 Months_with_Quota_ach_1H__c,Months_with_Quota_ach_2H__c,Q_A_12_LY__c,LookupUser__r.Sales_Role__c,Quota_Ach_April__c,Quota_Ach_May__c,Quota_Ach_June__c,
                                                 Quota_Ach_July__c,Quota_Ach_August__c,Quota_Ach_September__c,Quota_Ach_October__c,Quota_Ach_November__c,Quota_Ach_December__c,Quota_Ach_January__c,
                                                 Quota_Ach_February__c,Quota_Ach_March__c,LocalSales1LY__c,LocalSales2LY__c,LocalSales3LY__c,LocalSales4LY__c,LocalSales5LY__c,LocalSales6LY__c,LocalSales7LY__c,
                                                 LocalSales8LY__c,LocalSales9LY__c,LocalSales10LY__c,LocalSales11LY__c,LocalSales12LY__c,LocalSales1CY__c,LocalSales2CY__c,LocalSales3CY__c,
                                                 LocalSales4CY__c,LocalSales5CY__c,LocalSales6CY__c,LocalSales7CY__c,LocalSales8CY__c,LocalSales9CY__c,LocalSales10CY__c,LocalSales11CY__c,LocalSales12CY__c,
                                                 Quota1CY__c,Quota2CY__c,Quota3CY__c,Quota4CY__c,Quota5CY__c,Quota6CY__c,Quota7CY__c,Quota8CY__c,Quota9CY__c,Quota10CY__c,Quota11CY__c,Quota12CY__c 
                                                  FROM Budget_by_ASM__c
                                                 WHERE LookupUser__r.CompanyName = 'HLBR' AND LookupUser__r.IsActive = true AND LookupUser__r.Sales_Role__c IN ('AMS','AMV','ASM','KAM','NMM','NSM','RSM')
                                                 AND LookupUser__r.Name != 'Tatjana Mocenik'];
        List<BudgetASMWrapper> budgetASMWrapperList = new List<BudgetASMWrapper>();
        if(budgetByAsmList.size() > 0){
            for(Budget_by_ASM__c budget:budgetByAsmList){
                BudgetASMWrapper budgetRec = new BudgetASMWrapper();
                budgetRec.companyName = budget.LookupUser__r.CompanyName;
                budgetRec.managerName = budget.LookupUser__r.Manager.Name;
                budgetRec.fullName = budget.LookupUser__r.Name;
                budgetRec.userRole = budget.LookupUser__r.Sales_Role__c;
                budgetRec.budgetByASMName = budget.Name;
                budgetRec.quotaAchLastUpdated = budget.Data_last_Updated__c;                
                budgetRec.quotaYTD = budget.Quota_YTD__c;
                budgetRec.localSalesYTD = budget.Local_Sales_YTD__c;
                budgetRec.quotaAchYTDPerc = budget.Quota_Ach_YTD__c;
                budgetRec.salesYTDVsLY = budget.Sales_YTD_vsLY__c;
                budgetRec.monthsInTheTerritory = budget.Months_in_the_Area__c;
                budgetRec.last3MonthsUnderPerformance = budget.last_3_months_under_performance__c;
                budgetRec.monthsWithQuotaAch1H = budget.Months_with_Quota_ach_1H__c;
                budgetRec.monthsWithQuotaAch2H = budget.Months_with_Quota_ach_2H__c;
                budgetRec.quotaAchMarchLY = budget.Q_A_12_LY__c;
                budgetRec.quotaAchApril = budget.Quota_Ach_April__c;
                budgetRec.quotaAchMay = budget.Quota_Ach_May__c;
                budgetRec.quotaAchJune = budget.Quota_Ach_June__c;
                budgetRec.quotaAchJuly = budget.Quota_Ach_July__c;
                budgetRec.quotaAchAug = budget.Quota_Ach_August__c;
                budgetRec.quotaAchSept  = budget.Quota_Ach_September__c;
                budgetRec.quotaAchOct = budget.Quota_Ach_October__c;
                budgetRec.quotaAchNov = budget.Quota_Ach_November__c;
                budgetRec.quotaAchDec = budget.Quota_Ach_December__c;
                budgetRec.quotaAchJan = budget.Quota_Ach_January__c;
                budgetRec.quotaAchFeb = budget.Quota_Ach_February__c;
                budgetRec.quotaAchMar = budget.Quota_Ach_March__c;                
                budgetRec.localSalesAprilLY = budget.LocalSales1LY__c;
                budgetRec.localSalesMayLY = budget.LocalSales2LY__c;
                budgetRec.localSalesJuneLY = budget.LocalSales3LY__c;
                budgetRec.localSalesJulyLY = budget.LocalSales4LY__c;
                budgetRec.localSalesAugustLY = budget.LocalSales5LY__c;
                budgetRec.localSalesSeptLY = budget.LocalSales6LY__c;
                budgetRec.localSalesOctoberLY  = budget.LocalSales7LY__c;
                budgetRec.localSalesNovemberLY = budget.LocalSales8LY__c;
                budgetRec.localSalesDecemberLY = budget.LocalSales9LY__c;
                budgetRec.localSalesJanuaryLY = budget.LocalSales10LY__c;
                budgetRec.localSalesFebruaryLY = budget.LocalSales11LY__c;
                budgetRec.localSalesMarchLY = budget.LocalSales12LY__c;
                budgetRec.localSalesAprilCY = budget.LocalSales1CY__c;
                budgetRec.localSalesMayCY = budget.LocalSales2CY__c;
                budgetRec.localSalesJuneCY = budget.LocalSales3CY__c;
                budgetRec.localSalesJulyCY = budget.LocalSales4CY__c;
                budgetRec.localSalesAugustCY = budget.LocalSales5CY__c;
                budgetRec.localSalesSeptCY = budget.LocalSales6CY__c;
                budgetRec.localSalesOctoberCY = budget.LocalSales7CY__c;
                budgetRec.localSalesNovemberCY  = budget.LocalSales8CY__c;
                budgetRec.localSalesDecemberCY = budget.LocalSales9CY__c;
                budgetRec.localSalesJanuaryCY = budget.LocalSales10CY__c;
                budgetRec.localSalesFebruaryCY = budget.LocalSales11CY__c;
                budgetRec.localSalesMarchCY = budget.LocalSales12CY__c;
                budgetRec.quotaApril = budget.Quota1CY__c;
                budgetRec.quotaMay = budget.Quota2CY__c;
                budgetRec.quotaJune = budget.Quota3CY__c;
                budgetRec.quotaJuly = budget.Quota4CY__c;
                budgetRec.quotaAugust = budget.Quota5CY__c;
                budgetRec.quotaSeptember = budget.Quota6CY__c;
                budgetRec.quotaOctober = budget.Quota7CY__c;
                budgetRec.quotaNovember = budget.Quota8CY__c;
                budgetRec.quotaDecember = budget.Quota9CY__c;
                budgetRec.quotaJanuary = budget.Quota10CY__c;
                budgetRec.quotaFebruary = budget.Quota11CY__c;
                budgetRec.quotaMarch = budget.Quota12CY__c;
                budgetASMWrapperList.add(budgetRec);
            }
        }
        res.responseBody = Blob.valueOf(JSON.serialize(budgetASMWrapperList));
        res.statusCode = 200;
    }
    public class BudgetASMWrapper{
        public String companyName {get;set;}
        public String managerName {get;set;}
        public String fullName {get;set;}
        public String userRole {get;set;}
        public String budgetByASMName {get;set;}
        public String quotaAchLastUpdated {get;set;}
        public Decimal quotaYTD {get;set;}
        public Decimal localSalesYTD {get;set;}
        public Decimal quotaAchYTDPerc {get;set;}
        public Decimal salesYTDVsLY {get;set;}
        public Decimal monthsInTheTerritory {get;set;}
        public Decimal last3MonthsUnderPerformance {get;set;}
        public Decimal monthsWithQuotaAch1H {get;set;}
        public Decimal monthsWithQuotaAch2H {get;set;}
        public Decimal quotaAchMarchLY {get;set;}
        public Decimal quotaAchApril {get;set;}
        public Decimal quotaAchMay {get;set;}
        public Decimal quotaAchJune {get;set;}
        public Decimal quotaAchJuly {get;set;}
        public Decimal quotaAchAug {get;set;}
        public Decimal quotaAchSept {get;set;}
        public Decimal quotaAchOct {get;set;}
        public Decimal quotaAchNov {get;set;}
        public Decimal quotaAchDec {get;set;}
        public Decimal quotaAchJan {get;set;}
        public Decimal quotaAchFeb {get;set;}
        public Decimal quotaAchMar {get;set;}
        public Decimal localSalesAprilLY {get;set;}
        public Decimal localSalesMayLY {get;set;}
        public Decimal localSalesJuneLY {get;set;}
        public Decimal localSalesJulyLY {get;set;}
        public Decimal localSalesAugustLY {get;set;}
        public Decimal localSalesSeptLY {get;set;}
        public Decimal localSalesOctoberLY {get;set;}
        public Decimal localSalesNovemberLY {get;set;}
        public Decimal localSalesDecemberLY {get;set;}
        public Decimal localSalesJanuaryLY {get;set;}
        public Decimal localSalesFebruaryLY {get;set;}
        public Decimal localSalesMarchLY {get;set;}
        public Decimal localSalesAprilCY {get;set;}
        public Decimal localSalesMayCY {get;set;}
        public Decimal localSalesJuneCY {get;set;}
        public Decimal localSalesJulyCY {get;set;}
        public Decimal localSalesAugustCY {get;set;}
        public Decimal localSalesSeptCY {get;set;}
        public Decimal localSalesOctoberCY {get;set;}
        public Decimal localSalesNovemberCY {get;set;}
        public Decimal localSalesDecemberCY {get;set;}
        public Decimal localSalesJanuaryCY {get;set;}
        public Decimal localSalesFebruaryCY {get;set;}
        public Decimal localSalesMarchCY {get;set;}
        public Decimal quotaApril {get;set;}
        public Decimal quotaMay {get;set;}
        public Decimal quotaJune {get;set;}
        public Decimal quotaJuly {get;set;}
        public Decimal quotaAugust {get;set;}
        public Decimal quotaSeptember {get;set;}
        public Decimal quotaOctober {get;set;}
        public Decimal quotaNovember {get;set;}
        public Decimal quotaDecember {get;set;}
        public Decimal quotaJanuary {get;set;}
        public Decimal quotaFebruary {get;set;}
        public Decimal quotaMarch {get;set;}
    }
}