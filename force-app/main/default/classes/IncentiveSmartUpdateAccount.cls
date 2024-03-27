public with sharing class IncentiveSmartUpdateAccount implements Queueable {
    private List<Account> accounts;
    
    public IncentiveSmartUpdateAccount(List<Account> records) {
        this.accounts = records;
    }
    public void execute(QueueableContext context) {
        for (Account account : accounts) {
          ExternalWSIncentiveSmartCall.synchronizeUser(account.Hoya_Account_Id__c);
        }
        update accounts;
    }
}