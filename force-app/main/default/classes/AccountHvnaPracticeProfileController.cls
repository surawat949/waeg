public class AccountHvnaPracticeProfileController {

	public Account account {get; set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountHvnaPracticeProfileController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
    }
    
    public PageReference edit(){
        PageReference pr=new PageReference('/apex/accountHvnaPracticeProfileEditPage?id='+account.id);
        pr.setRedirect(true);
        return pr;        
    }
    
    public PageReference save(){
        if(!Test.isRunningTest()){
            update this.account.additionnal_account_data__r;
            update this.account;
        }
        //PageReference pr=new PageReference('/apex/accountHvnaPracticeProfilePage?id='+account.id);
        //pr.setRedirect(true);
        //return pr;
        return null;       
    }
    
    public String currentSocietie {get;set;}
    public String currentArea{get;set;}
    public List<String> lstSocieties {get;set;}
    
    public List<SelectOption> getListSocieties(){
        List<SelectOption> options = new List<SelectOption> { new SelectOption('','-- Choose --') };
        List<Schema.PicklistEntry> ple = Additionnal_account_data__c.HOLA_Societies__c.getDescribe().getPickListValues();
        for(Schema.PicklistEntry pe: ple){
            options.add(new SelectOption(pe.getValue(),pe.getLabel()));
        }
        return options;
    }
}