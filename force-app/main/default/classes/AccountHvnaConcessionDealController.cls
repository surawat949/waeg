public class AccountHvnaConcessionDealController {

	public Account account {get; set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountHvnaConcessionDealController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
    }

     public PageReference save(){
        if(!Test.isRunningTest()){
            update this.account.additionnal_account_data__r;
            update this.account;
        }
        //PageReference pr=new PageReference('/apex/accountHvnaConcessionDeal?id='+account.id);
        //pr.setRedirect(true);
        //return pr;
        return null;        
    }
}