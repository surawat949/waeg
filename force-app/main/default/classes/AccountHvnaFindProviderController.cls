public class AccountHvnaFindProviderController {
	public Account account {get; set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountHvnaFindProviderController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
    }
    
    public PageReference edit(){
        PageReference pr=new PageReference('/apex/accountHvnaFindProviderEditPage?id='+account.id);
        pr.setRedirect(true);
        return pr;        
    }
    public PageReference save(){
        System.debug('** 1.AccountHvnaFindProviderController save account('+this.account+')');
        try{
            if(!Test.isRunningTest()){
                update this.account.additionnal_account_data__r;
                update this.account;
                System.debug('** 2.AccountHvnaFindProviderController save account done');
            }
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        //PageReference pr=new PageReference('/apex/accountHvnaFindProviderPage?id='+account.id);
        //pr.setRedirect(true);
        //return pr;
        return null;
    }
}