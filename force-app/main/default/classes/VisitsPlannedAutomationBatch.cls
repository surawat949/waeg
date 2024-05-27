/*
  @Author : Fazurulla Ganganapalli (Encora)
  @Date : 27/07/2024
  @Description : The VisitsPlannedAutomationBatch class automates the update of account records by querying accounts with null 
  Agreed Visits or Agreed No of Digital Visits, retrieving configuration data based on segmentation from SFDC_V2_Configurations__c, and updating the accounts with the corresponding planned visit values, then logs the completion of the batch job.
*/
global class VisitsPlannedAutomationBatch implements Database.Batchable<SObject>, Database.Stateful {

    //@Query to get all accounts
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Segmentation_Net__c, Agreed_Visits__c, Agreed_No_of_Digital_Visits__c,Shop_Country__c FROM Account
            WHERE (Agreed_Visits__c = null OR Agreed_No_of_Digital_Visits__c = null)
        ]);
    }

    //@Execute method to process each batch of accounts
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Map<String, SFDC_V2_Configurations__c> mapOfConfig = getConfigurations();
        // Update accounts with the corresponding configurations
        for (Account acc : scope) {
            if (mapOfConfig.containsKey(acc.Segmentation_Net__c) /*&& mapOfConfig.get(acc.Segmentation_Net__c).Shop_Country__c == acc.Shop_Country__c*/) {
                acc.Agreed_Visits__c= mapOfConfig.get(acc.Segmentation_Net__c).Direct_Visits_Planned__c;
                acc.Agreed_No_of_Digital_Visits__c = mapOfConfig.get(acc.Segmentation_Net__c).Digital_Visits_Planned__c;
            }
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }
    //@Query all configurations for Visit Planning Automation
    global Map<String, SFDC_V2_Configurations__c> getConfigurations(){
        Map<String, SFDC_V2_Configurations__c> mapOfConfig = new Map<String, SFDC_V2_Configurations__c>();        
        List<SFDC_V2_Configurations__c> configList = [
            SELECT Id, Type__c, Segmentation__c, Direct_Visits_Planned__c, Digital_Visits_Planned__c 
            FROM SFDC_V2_Configurations__c 
            WHERE Type__c = 'Visit Planning Automation'
        ];
         // Populate the map with segmentation as key
        for (SFDC_V2_Configurations__c config : configList) {
            mapOfConfig.put(config.Segmentation__c, config);
        }
        return mapOfConfig;
    }

    //@Finish method called after all batches are processed
    global void finish(Database.BatchableContext BC) {
        
    }
}