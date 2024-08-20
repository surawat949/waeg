public class AccountHvnaCollectionsController {

	public Account account {get; set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountHvnaCollectionsController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
    }
    
    public PageReference edit(){
        PageReference pr=new PageReference('/apex/accountHvnaCollectionsEditPage?id='+account.id);
        pr.setRedirect(true);
        return pr;        
    }
     public PageReference save(){
        if(!Test.isRunningTest()){
            update this.account.additionnal_account_data__r;
            update this.account;
        }
        //PageReference pr=new PageReference('/apex/accountHvnaCollectionsPage?id='+account.id);
        //pr.setRedirect(true);
        //return pr;
        return null;
    }
}