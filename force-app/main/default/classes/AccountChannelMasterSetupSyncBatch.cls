public class AccountChannelMasterSetupSyncBatch implements Database.Batchable<SObject>, Schedulable {
    /*
    * This batch class synchronizes Channel Master Setup Config records with Account records 
    * to set the field Optician_Finder_Channel_Decision__c on Account 
    */
    
    public AccountChannelMasterSetupSyncBatch() {

    }
    public void execute(SchedulableContext ctx) {
        AccountChannelMasterSetupSyncBatch thisBatch = new AccountChannelMasterSetupSyncBatch();
        Database.executeBatch(thisBatch);
    }
    public Database.QueryLocator start(Database.BatchableContext context){ 
        return Database.getQueryLocator([SELECT Id, Hoya_Account_Id__c, Optician_Finder_Channel_Decision__c, Brand__c, Shop_Country__c, CHCUSTCLASSIFICATIONID__c, CHINTERNATIONALGROUP__c FROM Account]);
    }
    public void execute(Database.BatchableContext context, List<Account> lstAccounts){
        Map<String, Channel_Master_Setup_Config__c> mapConfig = new Map<String, Channel_Master_Setup_Config__c>();
        List<Account> accUpdateList = new List<Account>();
        try {
            List<Channel_Master_Setup_Config__c> configs = [Select Id, External_key__c, Account_Channel_decision__c FROM Channel_Master_Setup_Config__c];
            if (configs != null && !configs.isEmpty()) {
                for (Channel_Master_Setup_Config__c eachConfig : configs) {
                    mapConfig.put(eachConfig.External_key__c, eachConfig);
                }
            }
            if (!mapConfig.isEmpty()) {
                for (Account eachAcc : lstAccounts) {
                    String key;
                    if (eachAcc.CHINTERNATIONALGROUP__c != null) {
                        key = eachAcc.Brand__c + eachAcc.Shop_Country__c + eachAcc.CHCUSTCLASSIFICATIONID__c + eachAcc.CHINTERNATIONALGROUP__c.round(System.RoundingMode.DOWN);
                    } else {
                        key = eachAcc.Brand__c + eachAcc.Shop_Country__c + eachAcc.CHCUSTCLASSIFICATIONID__c;
                    }
                    
                    if (mapConfig.containsKey(key)) {
                        eachAcc.Optician_Finder_Channel_Decision__c = mapConfig.get(key).Account_Channel_decision__c;
                        accUpdateList.add(eachAcc);
                    }
                }
            }
            if (!accUpdateList.isEmpty()) {
                update accUpdateList;
            }
        } catch (Exception ex) {
            LogException.log(ex);
        }
    }
    public void finish(Database.BatchableContext context){ }
}