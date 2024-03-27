global class ExternaWSIncentiveBatch implements Database.Batchable<Account> {
    
    private List<Account> myList;
    global ExternaWSIncentiveBatch(){
    }

    global Iterable<Account> start(Database.BatchableContext context){
        List<Account> accountList = [select id, hoya_account_id__c, name from account where hoya_account_id__c like 'UK%'];
        return accountList;
    }
    global void execute(Database.BatchableContext context, List<Account> accounts) {
        System.debug('ExternaWSIncentiveBatch value size = ' + accounts.size());
        
        ExternalIncentiveBatch updateJob = new ExternalIncentiveBatch(accounts);
        ID jobID = System.enqueueJob(updateJob);
    }

    global void finish(Database.BatchableContext context) {
    }
}