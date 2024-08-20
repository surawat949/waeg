public class AccountHvnaSalesPageController {
	public Account account {get; set;}
    public Double conversionRate{get;set;}
    private ApexPages.StandardController sc;
    
    //Constructor
    public AccountHvnaSalesPageController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;
        String userCurrency = UserInfo.getDefaultCurrency();
        String accountCurrency = this.account.CurrencyIsoCode;
        
    	conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        if(accountCurrency==userCurrency || (userCurrency=='USD' && accountCurrency=='CAD')){
            conversionRate=1;
        }
    }
    
    public Double getConversionRate(){return conversionRate;}
    
    public PageReference save(){
        if(!Test.isRunningTest()){
            update this.account.additionnal_account_data__r;
            update this.account;
        }
        this.account.additionnal_account_data__r = [select id, Master_Account__c,
        HOLA_GTQ1__c,HOLA_Wallet__c,HOLA_GTQ2__c,HOLA_CURR_FY_EST_NNN__c,HOLA_GTQ3__c,HOLA_SOW_Estimate__c,HOLA_GTQ4__c,HOLA_X9_BOX_BEG_YR__c,HOLA_RSM_Growth_Target__c,
HOLA_GHQ_9_BOX__c,HOLA_Target_Archieve__c,HOLA_GHQ_Account__c,HOLA_RSM_Target_Archive__c,HOLA_FY13_NNN__c,X80_Prob__c,HOLA_FY14_NNN__c,
HOLA_INDEX__c,HOLA_FY15_NNN__c,X100_SOW__c,HOLA_FY16_NNN__c,HOLA_FY17_NNN__c,HOLA_GT_CLASS__c,FY18_NNNN__c,Revenue_Growth_Objective_RGO__c,HOLA_GT_STATUS__c,Vector_SFDC__c,
HOLA_Forecast_APR_NNN__c,HOLA_Forecast_MAY_NNN__c,HOLA_Forecast_JUN_NNN__c,HOLA_Forecast_JUL_NNN__c,HOLA_Forecast_AUG_NNN__c,HOLA_Forecast_SEP_NNN__c,HOLA_Forecast_OCT_NNN__c,
HOLA_Forecast_NOV_NNN__c,HOLA_Forecast_DEC_NNN__c,HOLA_Forecast_JAN_NNN__c,HOLA_Forecast_FEB_NNN__c,HOLA_Forecast_MAR_NNN__c,HOLA_CURRENT_FORECAST_TOTAL__c,
GROWTH_APR__c,GROWTH_MAY__c,GROWTH_JUN__c,GROWTH_JUL__c,GROWTH_AUG__c,GROWTH_SEP__c,GROWTH_OCT__c,GROWTH_NOV__c,GROWTH_DEC__c,GROWTH_JAN__c,GROWTH_FEB__c,GROWTH_MAR__c,GROWTH_TOTAL__c,HOLA_PY_APR_NNN__c,
HOLA_PY_MAY_NNN__c,HOLA_PY_JUN_NNN__c,HOLA_PY_JUL_NNN__c,HOLA_PY_AUG_NNN__c,HOLA_PY_SEP_NNN__c,HOLA_PY_OCT_NNN__c,HOLA_PY_NOV_NNN__c,HOLA_PY_DEC_NNN__c,HOLA_PY_JAN_NNN__c,HOLA_PY_FEB_NNN__c,HOLA_PY_MAR_NNN__c,HOLA_PY_TOTAL__c,
HOLA_CY_APR_NNN__c,HOLA_CY_MAY_NNN__c,HOLA_CY_JUN_NNN__c,HOLA_CY_JUL_NNN__c,HOLA_CY_AUG_NNN__c,HOLA_CY_SEP_NNN__c,HOLA_CY_OCT_NNN__c,HOLA_CY_NOV_NNN__c,HOLA_CY_DEC_NNN__c,HOLA_CY_JAN_NNN__c,HOLA_CY_FEB_NNN__c,HOLA_CY_MAR_NNN__c,HOLA_CY_YTD_NNN__c,HOLA_VAR_TO_FORECAST_APR__c,
HOLA_VAR_TO_FORECAST_MAY__c,HOLA_VAR_TO_FORECAST_JUN__c,HOLA_VAR_TO_FORECAST_JUL__c,HOLA_VAR_TO_FORECAST_AUG__c,
HOLA_VAR_TO_FORECAST_SEP__c,HOLA_VAR_TO_FORECAST_OCT__c,HOLA_VAR_TO_FORECAST_NOV__c,HOLA_VAR_TO_FORECAST_DEC__c,HOLA_VAR_TO_FORECAST_JAN__c,HOLA_VAR_TO_FORECAST_FEB__c,HOLA_VAR_TO_FORECAST_MAR__c,HOLA_VAR_TO_FORECAST_YTD__c
         from Additionnal_account_data__c where Master_Account__c=:this.account.id];
        //PageReference pr=new PageReference('/apex/accountHvnaSalesPage?id='+account.id);
        //pr.setRedirect(true);
        return null;        
    }

}