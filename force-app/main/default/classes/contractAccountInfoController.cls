public class contractAccountInfoController {
	public Contract contract {get; set;}
    public Account account {get;set;}
    private ApexPages.StandardController sc;

    //Constructor
    public contractAccountInfoController(ApexPages.StandardController stdController){
        this.sc = stdController;
        this.contract = (Contract)stdController.getRecord();
        //System.debug('Contract = ' + this.contract);
        Contract c = [select accountid from contract where id=:this.contract.id];
        //System.debug('Account = ' + c.accountId);
        this.account = [select annualRevenue, hoya_account_id__c, Share_of_Wallet__c, phone from account where id=:c.accountid];
       //System.debug('Contract.Account = ' + account);
    }
}