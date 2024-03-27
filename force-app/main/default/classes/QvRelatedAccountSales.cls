public with sharing class QvRelatedAccountSales implements Comparable{
    public QvRelatedAccountSales(String accountNumber, String ptype, Id inId){
        //System.debug('YYYY QvAccountData hoya_account_id = ' + accountNumber);
        hoya_account_id = accountNumber;
        type= ptype;
        accountId=inId;
        april=0;
        may=0;
        june=0;
        july=0;
        august=0;
        september=0;
        october=0;
        november=0;
        december=0;
        january=0;
        february=0;
        march=0;
        
        //Last year sales variables
        aprilLY=0;
        mayLY=0;
        juneLY=0;
        julyLY=0;
        augustLY=0;
        septemberLY=0;
        octoberLY=0;
        novemberLY=0;
        decemberLY=0;
        januaryLY=0;
        feburaryLY=0;
        marchLY=0;

        //forecast budget by account number
        
        budgetAprCY = 0;
        budgetMayCY = 0;
        budgetJunCY = 0;
        budgetJulCY = 0;
        budgetAugCY = 0;
        budgetSepCY = 0;
        budgetOctCY = 0;
        budgetNovCY = 0;
        budgetDecCY = 0;
        budgetJanCY = 0;
        budgetFebCY = 0;
        budgetMarCY = 0;
        
    }
    
    @AuraEnabled public String hoya_account_id{get; set;}
    @AuraEnabled public double salesYTD{get; set;}
    @AuraEnabled public String accountId{get; set;}
    @AuraEnabled public String type{get; set;}
    @AuraEnabled  public double april{get; set;}
    @AuraEnabled  public double may{get; set;}
    @AuraEnabled  public double june{get; set;}
    @AuraEnabled  public double july{get; set;}
    @AuraEnabled  public double august{get; set;}
    @AuraEnabled  public double september{get; set;}
    @AuraEnabled  public double october{get; set;}
    @AuraEnabled  public double november{get; set;}
    @AuraEnabled  public double december{get; set;}
    @AuraEnabled  public double january{get; set;}
    @AuraEnabled  public double february{get; set;}
    @AuraEnabled  public double march{get; set;}
    @AuraEnabled  public double getAnnual(){return(april+may+june+july+august+september+october+november+december+january+february+march);}

    //Last year variables
    @AuraEnabled  public double aprilLY{get;set;}
    @AuraEnabled  public double mayLY{get;set;}
    @AuraEnabled  public double juneLY{get;set;}
    @AuraEnabled  public double julyLY{get;set;}
    @AuraEnabled  public double augustLY{get;set;}
    @AuraEnabled  public double septemberLY{get;set;}
    @AuraEnabled  public double octoberLY{get;set;}
    @AuraEnabled  public double novemberLY{get;set;}
    @AuraEnabled  public double decemberLY{get;set;}
    @AuraEnabled  public double januaryLY{get;set;}
    @AuraEnabled  public double feburaryLY{get;set;}
    @AuraEnabled  public double marchLY{get;set;}
 
    //total sales amount summary last year
    @AuraEnabled  public double getAnnualLY(){return(aprilLY+mayLY+juneLY+julyLY+augustLY+septemberLY+octoberLY+novemberLY+decemberLY+januaryLY+feburaryLY+marchLY);}

    //This section below for forecast (budget volume) Current Year only - SS
    
    @AuraEnabled  public double budgetAprCY{get;set;}
    @AuraEnabled  public double budgetMayCY{get;set;}
    @AuraEnabled  public double budgetJunCY{get;set;}
    @AuraEnabled  public double budgetJulCY{get;set;}
    @AuraEnabled  public double budgetAugCY{get;set;}
    @AuraEnabled  public double budgetSepCY{get;set;}
    @AuraEnabled  public double budgetOctCY{get;set;}
    @AuraEnabled  public double budgetNovCY{get;set;}
    @AuraEnabled  public double budgetDecCY{get;set;}
    @AuraEnabled  public double budgetJanCY{get;set;}
    @AuraEnabled  public double budgetFebCY{get;set;}
    @AuraEnabled  public double budgetMarCY{get;set;}

    @AuraEnabled  public double getAnnualBudgetCY(){return(budgetAprCY+budgetMayCY+budgetJunCY+budgetJulCY+budgetAugCY+budgetSepCY+budgetOctCY+budgetNovCY+budgetDecCY+budgetJanCY+budgetFebCY+budgetMarCY);}
    
    public Integer compareTo(Object data){
        QvRelatedAccountSales q = (QvRelatedAccountSales)data;
        if(hoya_account_id > q.hoya_account_id) return 1;
        return 0;
    }
}