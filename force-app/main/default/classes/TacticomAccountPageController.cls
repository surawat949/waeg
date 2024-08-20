public class TacticomAccountPageController {

	public Account account {get; set;}
    private ApexPages.StandardController sc;
    public String sofTacticom {get;set;}
    public String hlfrTacticom {get;set;}
    public Boolean isSeiko {get;set;}
    public String hoyaAccountNumber {get;set;}
    public String seikoAccountNumber {get;set;}

    //Constructor
    public TacticomAccountPageController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
        isSeiko=false;
        sofTacticom = 'not found';
        hlfrTacticom = 'not found';
        Account acc = [select Id, hoya_account_id__c, door__c, TACTICOM_HLFR__c, TACTICOM_SOF__c from Account where id=:this.account.id];
        if(acc.hoya_account_id__c.substring(0,2)=='SO'){
            isSeiko = true;
            seikoAccountNumber = acc.hoya_account_id__c;
        } else {
            hoyaAccountNumber = acc.hoya_account_id__c;
        }
        
        System.debug('** 1.tacticomAccountPage isSeiko=' + isSeiko + ', substr=' + acc.hoya_account_id__c.substring(0,1));
        
        if(acc.Door__c!=null){
            System.debug('** 2.tacticomAccountPage door found ' + acc.Door__c);
            if(isSeiko){
                //seiko side
                //get hoya linked account value
                sofTacticom = acc.TACTICOM_SOF__c;
                Id hlfrId = null;
                Integer nbHlfr = [select count() from Account where door__c=:acc.door__c and hoya_account_id__c like 'FR%' limit 1];
                if(nbHlfr>0){
                	Account hlfrAccount = [select id from Account where door__c=:acc.door__c and hoya_account_id__c like 'FR%' order by AnnualRevenue desc limit 1];
                    if(hlfrAccount!=null){
                        hlfrId=hlfrAccount.Id;
                    }
                }
                System.debug('** 3.hlfr id=' + hlfrId);
                if(hlfrId!=null){
                	hlfrTacticom = [select TACTICOM_HLFR__c from Account where id=:hlfrId].TACTICOM_HLFR__c;
                    hoyaAccountNumber = [select Hoya_account_id__c from Account where id=:hlfrId].Hoya_Account_Id__c;
                } else{
                    hlfrTacticom='no linked account';
                }
            } else {
                //hoya side
                //get seiko linked account value
                hlfrTacticom = acc.TACTICOM_HLFR__c;
                Id sofId = null;
                Integer nbSof = [select count() from Account where door__c=:acc.Door__c and hoya_account_id__c like 'SO33%' limit 1];
                if(nbSof>0) {
                	Account sofAccount = [select id from Account where door__c=:acc.Door__c and hoya_account_id__c like 'SO33%' order by AnnualRevenue desc limit 1];
                    if(sofAccount!=null){
                        sofId = sofAccount.Id;
                    }
                }
            	System.debug('** 3.sof id=' + sofId);
                if(sofId!=null){
                    sofTacticom = [select TACTICOM_SOF__c from Account where id=:sofId].TACTICOM_SOF__c;
                    seikoAccountNumber = [select Hoya_account_id__c from Account where id=:sofId].Hoya_Account_Id__c;
                } else {
                    sofTacticom = 'no linked account';
                }
            }
            System.debug('** 5.sof=' + sofTacticom + ' ; hlfrTacticom=' + hlfrTacticom);
        }
    }
    
    public PageReference edit(){
        PageReference pr=new PageReference('/apex/tacticomAccountPage?id='+account.id);
        pr.setRedirect(true);
        return pr;        
    }
    public PageReference save(){
        System.debug('** 1.tacticomAccountPage save account('+this.account+')');
        if(!Test.isRunningTest()){
        	update this.account;
        	System.debug('** 2.tacticomAccountPage save account done');
    	}
        return null;
    }
}