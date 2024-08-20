public class AccountHolkSpecificController {
	public Account account {get; set;}
    private ApexPages.StandardController sc;
    
    //Constructor
    public AccountHolkSpecificController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
        //test
    }
}