public class AccountLastSalesStatisticsBatchUpdater implements Database.batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        Integer CurrentFiscalyear = Date.today().year();
        Integer month = Date.today().month();
        if(month <= 4){               
            CurrentFiscalyear=CurrentFiscalyear-1;
        }
        // collect the batches of accs to be passed to execute 0010Q00001XkqheQAB
       return Database.getQueryLocator([SELECT Id from Account where Id='0010Q00001cI1dCQAS']);
	}    
    public void execute(Database.BatchableContext BC, List<Account> accsList) {
        AccountLastSalesUpdater helper=new AccountLastSalesUpdater();
        List<Last_Sales_Statistics__c> lastSalesStatisticsList=helper.getLastSalesObject(accsList[0]);
        system.debug(lastSalesStatisticsList.size());		
        try{
           if(lastSalesStatisticsList.size() > 0)
           Insert lastSalesStatisticsList;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    public void finish(Database.BatchableContext BC) {
    }

}