public class UserSalesPerformanceCtrl {
    @AuraEnabled(cacheable=true)
    public static Budget_by_ASM__c getBudget() {
        Budget_by_ASM__c budget = null;
        Integer nbRecord = [SELECT COUNT() FROM Budget_by_ASM__c WHERE Lookupuser__c = :UserInfo.getUserId()];

        if (nbRecord == 1) {
            budget = [SELECT 
                      LocalSales1CY__c, LocalSales2CY__c, LocalSales3CY__c, LocalSales4CY__c, LocalSales5CY__c, LocalSales6CY__c, LocalSales7CY__c, LocalSales8CY__c, LocalSales9CY__c, LocalSales10CY__c, LocalSales11CY__c, LocalSales12CY__c,Local_Sales_YTD__c,
                      LocalSales1LY__c, LocalSales2LY__c, LocalSales3LY__c, LocalSales4LY__c, LocalSales5LY__c, LocalSales6LY__c, LocalSales7LY__c, LocalSales8LY__c, LocalSales9LY__c, LocalSales10LY__c, LocalSales11LY__c, LocalSales12LY__c,
                      Sales_Apr_vsLY__c, Sales_May_vsLY__c, Sales_Jun_vsLY__c, Sales_Jul_vsLY__c, Sales_Aug_vsLY__c, Sales_Sep_vsLY__c, Sales_Oct_vsLY__c, Sales_Nov_vsLY__c, Sales_Dec_vsLY__c, 
                      Quota1CY__c, Quota2CY__c, Quota3CY__c, Quota4CY__c, Quota5CY__c, Quota6CY__c, Quota7CY__c, Quota8CY__c, Quota9CY__c, Quota10CY__c, Quota11CY__c, Quota12CY__c, Sales_Jan_vsLY__c, Sales_Feb_vsLY__c, Sales_Mar_vsLY__c, Sales_YTD_vsLY__c,
                      Quota_Ach_April__c, Quota_Ach_May__c, Quota_Ach_June__c, Quota_Ach_July__c, Quota_Ach_August__c, Quota_Ach_September__c, Quota_Ach_October__c, Quota_Ach_November__c, Quota_Ach_December__c, Quota_Ach_January__c, Quota_Ach_February__c, Quota_Ach_March__c,Quota_YTD__c,Quota_Ach_YTD__c,
                      Local_Sales_LY_YTD__c
                      FROM Budget_by_ASM__c
                      WHERE Lookupuser__c = :UserInfo.getUserId()];
        }
        return budget;
    }
}