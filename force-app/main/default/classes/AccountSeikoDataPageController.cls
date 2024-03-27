public with sharing class AccountSeikoDataPageController {
    public Account account {get; set;}
    public Seiko_data__c data {get;set;}
    private ApexPages.StandardController sc;

    //Constructor
    public AccountSeikoDataPageController(ApexPages.StandardController stdController){
        this.account = (Account)stdController.getRecord();
        this.sc = stdController;

        this.data = [select Account__c,CurrencyIsoCode,EDI_orders_blocked__c,EDI_orders_total__c,Forecast_YTD__c
        ,Frames_Turnover_CY__c,Frames_Turnover_LY_YTD__c,Frames_Turnover_LY__c,Frame_Turnover_Trend__c,France_2nd_Lens_Pair_orders__c
        ,Glazing_Level__c,Hoya_Account_Id__c,Id,Local_initiative_1_activation__c,Local_initiative_1__c,Local_initiative_2_activation__c
        ,Local_initiative_2__c,Local_initiative_3_activation__c,Local_initiative_3__c,Local_initiative_4_activation__c,Local_initiative_4__c,Local_initiative_5_activation__c,Local_initiative_5__c,Local_initiative_6_activation__c,Local_initiative_6__c,Local_initiative_7_activation__c,Local_initiative_7__c,Local_initiative_8_activation__c,Local_initiative_8__c,Local_initiative_9_activation__c,Local_initiative_9__c,Local_initiative_10_activation__c,Local_initiative_10__c
        ,Name,Other_Turnover_CY__c,Other_Turnover_LY_YTD__c,Other_Turnover_LY__c,Other_Turnover_Trend__c,Pentax_Turnover_CY__c
        ,Pentax_Turnover_LY_YTD__c,Pentax_Turnover_LY__c,Pentax_Turnover_Trend__c,Remote_Edging__c,SEIKO_catalogues_training__c,SEIKO_Catalogues__c
        ,SEIKO_PAL_of_ALL_PAL_in__c,SEIKO_PAL_of_ALL_SEIKO_in__c,Seiko_Prime_CY__c,Seiko_Prime_LY__c,SEIKO_Products_1rst_training_date__c
        ,SEIKO_Products_1rst_training__c,Seiko_QTY_CY__c,Seiko_QTY_LY__c,SEIKO_QTY_of_All_QTY_in__c,Seiko_Qty_Trend__c,Seiko_RCC_CY__c,Seiko_RCC_LY__c
        ,SEIKO_SRB_CY__c,SEIKO_SRB_LY__c,SEIKO_SRC_CY__c,SEIKO_SRC_LY__c,SEIKO_Tracer_installation__c,SEIKO_Tracer__c,SEIKO_Track_Trace_activation__c
        ,SEIKO_Track_Trace__c,Seiko_Turnover_CY__c,Seiko_Turnover_LY_YTD__c,Seiko_Turnover_LY__c,Seiko_Turnover_trend__c,SEIKO_Vision_Simulator_training__c
        ,SEIKO_Vision_Simulator__c,SEIKO_Vision_Xperience_column_training__c,SEIKO_Vision_Xperience_column__c,SEIKO_Vision_Xperience_iPAD_training__c
        ,SEIKO_Vision_Xperience_iPAD__c,SEIKO_Xtranet_training__c,Seiko_Xtranet_last_usage__c,Starting_kit_setting_up__c,Starvision_Turnover_CY__c,Starvision_Turnover_LY_YTD__c
        ,Starvision_Turnover_LY__c,Starvision_Turnover_Trend__c,SVS_Communication_kit_setting_up__c,SVS_Communication_kit__c,SVS_Marketing_campaigns_activation__c
        ,SVS_Newsletters_activation__c,SVS_Newsletters__c,SVS_Pricelist_activation__c
        ,SVS_Pricelist__c,SVS_Sample_boxes_setting_up__c,SVS_Sample_boxes__c,SVS_Starting_kit__c
        ,SVS_Store_locator__c,Total_turnover_last_year__c,Total_turnover_Trend__c,Total_turnover__c,White_Label_Turnover_CY__c,White_Label_Turnover_LY_YTD__c,White_Label_Turnover_LY__c,White_label_Turnover_Trend__c
        ,SVS_Store_locator_activation__c,SVX_Column_Ending_Licence__c,SVX_iPad_Ending_Licence__c,SVS_Purchase_Registration_activation__c
        ,SVS_Purchase_Registration__c,SEIKO_Xchanger_training__c,SEIKO_Xchanger__c,MiyoSmart_training__c,Miyosmart__c, SVS_Marketing_campaigns__c
        ,Total_QTY_CY__c, Total_QTY_LY__c, SVS_FB_Page__c
        ,Seiko_track_trace_email_activation__c, Seiko_track_trace_daily_email__c
        ,Mon_AM_open__c, Mon_AM_close__c, Mon_PM_open__c, Mon_PM_close__c
        ,Tue_AM_open__c, Tue_AM_close__c, Tue_PM_open__c, Tue_PM_close__c
        ,Wed_AM_open__c, Wed_AM_close__c, Wed_PM_open__c, Wed_PM_close__c
        ,Thu_AM_open__c, Thu_AM_close__c, Thu_PM_open__c, Thu_PM_close__c
        ,Fri_AM_open__c, Fri_AM_close__c, Fri_PM_open__c, Fri_PM_close__c
        ,Sat_AM_open__c, Sat_AM_close__c, Sat_PM_open__c, Sat_PM_close__c
        ,Sun_AM_open__c, Sun_AM_close__c, Sun_PM_open__c, Sun_PM_close__c
        ,SVS_Digital_com_platform_activation__c,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
        ,Segmentation__c, SVS_Total_Visits_achieved__c, SVS_recommended_number_of_visits__c, SVS_Physical_Visit_Frequency__c, SVS_Number_of_digital_visits__c, SVS_Digital_visit_frequency__c
        ,lastmodifieddate, Seiko_Shop_in_Shop_installation__c, Seiko_Shop_in_Shop__c
        FROM Seiko_data__c where account__c =: account.Id];
    }
    
    public PageReference edit(){
        PageReference pr=new PageReference('/apex/accountSeikoDataEditEditPage?id='+account.id);
        pr.setRedirect(true);
        return pr;        
    }

    public PageReference save(){
        System.debug('** 1.AccountSeikoDataPageController save account('+this.account+')');
        try{
            if(!Test.isRunningTest()){
                update this.data;
                update this.account;
                System.debug('** 2.additionnal_account_data__r save account done');
            }
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }
}