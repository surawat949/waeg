public class TabActivationPortalStoreFinderController {
    @AuraEnabled(cacheable=true)
    public static String getLastTrainingDate(Id accountId){
        String lastTrainingDate='';
        List<ECP_Training__c> TrainingLst=[SELECT start__c,Id,Account__c 
                                           FROM ECP_Training__c where Account__c=:accountId and Training__c includes ('SEIKO Store locator') AND Training_status__c ='Completed' order by start__c desc];
        if(TrainingLst.size() > 0){
            DateTime dT = TrainingLst[0].start__c;
            lastTrainingDate = dT.date().format();
        }  
        return lastTrainingDate;    
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getLastTotalMonthSale(Id accountId){
        Decimal lastSales;
        List<Last_Sales_Statistics__c> salesStatistics = [SELECT Lenses_Net_Sales_Last_3Mo_CFY__c,Id,Account__c 
                                                          FROM Last_Sales_Statistics__c where Account__c=:accountId];
            if(salesStatistics.size()>0){
             	lastSales = salesStatistics[0].Lenses_Net_Sales_Last_3Mo_CFY__c;  
            }
            return lastSales;    
    }

}