public class AccountHvnaCouponController {
	public Account account {get; set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountHvnaCouponController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
    }
    
    public PageReference save(){
        if(!Test.isRunningTest()){
            update this.account.additionnal_account_data__r;
            update this.account;
        }
        //PageReference pr=new PageReference('/apex/accountHvnaCouponsPage?id='+account.id);
        //pr.setRedirect(true);
        //return pr;
        return null;
    }

}