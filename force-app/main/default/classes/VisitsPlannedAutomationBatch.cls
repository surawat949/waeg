/*
  @Author : Fazurulla Ganganapalli (Encora)
  @Date : 27/07/2024
  @Description : The VisitsPlannedAutomationBatch class automates the update of account records by querying accounts with null 
  Agreed Visits or Agreed No of Digital Visits, retrieving configuration data based on segmentation from SFDC_V2_Configurations__c, 
  and updating the accounts with the corresponding planned visit values, then logs the completion of the batch job.
*/
global class VisitsPlannedAutomationBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    // Query to get all accounts
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> listOfRecordType = new list<String>{'Independents','Independent_Seiko','Buying_Group','Buying_Group_Seiko','HOLK_Account_Page_Layout'};
        return Database.getQueryLocator([
            SELECT Id, Segmentation_Net__c, Agreed_Visits__c, Agreed_No_of_Digital_Visits__c, 
                Requested_Digital_Visits__c, Requested_Direct_Visits__c FROM Account Where 
                RecordType.DeveloperName IN : listOfRecordType AND Account_Status__c != 'Closed'
    
        ]);
    }

    // Execute method to process each batch of accounts
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        Map<String, SFDC_V2_Configurations__c> configMap = getConfigurations();
        List<Account> acctListUpdate = new List<Account>();
        for (Account acc : scope) {
            Boolean shouldSkipDirectRecord = false;
            Boolean shouldSkipDigitalRecord = false;
            if (acc.Requested_Direct_Visits__c >= 0 ) {
                shouldSkipDirectRecord = true;
            }
            
            if(acc.Requested_Digital_Visits__c >= 0){
                shouldSkipDigitalRecord = true;
            }
            if (configMap.containsKey(acc.Segmentation_Net__c)) {
                SFDC_V2_Configurations__c config = configMap.get(acc.Segmentation_Net__c);
                if(!shouldSkipDirectRecord){
                    acc.Agreed_Visits__c = config.Direct_Visits_Planned__c;
                }
                if(!shouldSkipDigitalRecord){
                    acc.Agreed_No_of_Digital_Visits__c = config.Digital_Visits_Planned__c;
                }                
                acctListUpdate.add(acc);
            }
        }
        
        // Perform the update with partial success
        Database.SaveResult[] updateResults = Database.update(acctListUpdate, false);
        // Gather all errors into a list
        List<String> allErrors = new List<String>();
        for (Database.SaveResult result : updateResults) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    allErrors.add('Error updating Account ID ' + result.getId() + ': ' + error.getMessage());
                }
            }
        }
        if (!allErrors.isEmpty()) {
            // Log or handle the errors as needed
            LogException.log('VisitsPlannedAutomationBatch','execute','DMLException',JSON.SerializePretty(allErrors));
        }
        
    }

    // Query all configurations for Visit Planning Automation
    global Map<String, SFDC_V2_Configurations__c> getConfigurations() {
        Map<String, SFDC_V2_Configurations__c> configMap = new Map<String, SFDC_V2_Configurations__c>();
        List<SFDC_V2_Configurations__c> configList = [
            SELECT Id, Type__c, Segmentation__c, Direct_Visits_Planned__c, Digital_Visits_Planned__c 
            FROM SFDC_V2_Configurations__c 
            WHERE Type__c = 'Visit Planning Automation'
        ];
        
        for (SFDC_V2_Configurations__c config : configList) {
            configMap.put(config.Segmentation__c, config);
        }
        return configMap;
    }

    // Finish method called after all batches are processed
    global void finish(Database.BatchableContext bc) {
        // Optional: add code to log the completion of the batch job
    }
    
    // Schedulable method
    global void execute(SchedulableContext sc) {
        VisitsPlannedAutomationBatch batch = new VisitsPlannedAutomationBatch();
        Database.executeBatch(batch);
    }
}