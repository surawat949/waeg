public with sharing class SalesStatisticsController {
    public SalesStatisticsController() {

    }

    @AuraEnabled
    public static Account getAccount(Id recordId){
        Account acc = null;
        try {
            acc = [select ID, Hoya_Account_ID__c,annualRevenue, currencyIsoCode,Brand__c, parentId,Potential__c
            , Last_3_Month_Total_sales_LY__c, Last_3_months_Avg_sales__c,Turnover_Amount__c
            , Seiko_objective_ECP_agr__c, Forecast_current_year__c, Actual_Sales_versus_Budget__c
            ,Last_3_Months_Total_Sales_VS_LY__c,Sales_Total_YTD_LY__c,Sales_CY_vs_LY_YTD__c,TACTICOM_SOF__c,TACTICOM_HLFR__c
            ,Remote_Edging__c,Glazing_Level__c
            from account where id=:recordId];
            return acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}