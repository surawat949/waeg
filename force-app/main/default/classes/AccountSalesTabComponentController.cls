public with sharing class AccountSalesTabComponentController {

    public class AccountSales {
        public AccountSales(){
            janQtyN2 = 0;
            febQtyN2 = 0;
            MarQty = 0;
            janSalesN2 =0;
            febSalesN2 = 0;
            marSalesN2 = 0;
        }
        @AuraEnabled public Account account{get;set;}
        @AuraEnabled public Seiko_Data__c seikoSales{get;set;}
        
        @AuraEnabled public Double AprSales{get;set;}
        @AuraEnabled public Double MaySales{get;set;}
        @AuraEnabled public Double JunSales{get;set;}
        @AuraEnabled public Double JulSales{get;set;}
        @AuraEnabled public Double AugSales{get;set;}
        @AuraEnabled public Double SepSales{get;set;}
        @AuraEnabled public Double OctSales{get;set;}
        @AuraEnabled public Double NovSales{get;set;}
        @AuraEnabled public Double DecSales{get;set;}
        @AuraEnabled public Double JanSales{get;set;}
        @AuraEnabled public Double FebSales{get;set;}
        @AuraEnabled public Double MarSales{get;set;}
        @AuraEnabled public Double TotalSales{get; set;}
        
        @AuraEnabled public Double AprQty{get;set;}
        @AuraEnabled public Double MayQty{get;set;}
        @AuraEnabled public Double JunQty{get;set;}
        @AuraEnabled public Double JulQty{get;set;}
        @AuraEnabled public Double AugQty{get;set;}
        @AuraEnabled public Double SepQty{get;set;}
        @AuraEnabled public Double OctQty{get;set;}
        @AuraEnabled public Double NovQty{get;set;}
        @AuraEnabled public Double DecQty{get;set;}
        @AuraEnabled public Double JanQty{get;set;}
        @AuraEnabled public Double FebQty{get;set;}
        @AuraEnabled public Double MarQty{get;set;}
        @AuraEnabled public Double TotalQty{get; set;}
        public String CurrFY{get;set;}

     
        @AuraEnabled public Double AprSalesLY{get; set;}
        @AuraEnabled public Double MaySalesLY{get; set;}
        @AuraEnabled public Double JunSalesLY{get; set;}
        @AuraEnabled public Double JulSalesLY{get; set;}
        @AuraEnabled public Double AugSalesLY{get; set;}
        @AuraEnabled public Double SepSalesLY{get; set;}
        @AuraEnabled public Double OctSalesLY{get; set;}
        @AuraEnabled public Double NovSalesLY{get; set;}
        @AuraEnabled public Double DecSalesLY{get; set;}
        @AuraEnabled public Double JanSalesLY{get; set;}
        @AuraEnabled public Double FebSalesLY{get; set;}
        @AuraEnabled public Double MarSalesLY{get; set;}
        @AuraEnabled public Double TotalSalesLY{get; set;}

        @AuraEnabled public Double AprQtyLY{get; set;}
        @AuraEnabled public Double MayQtyLY{get; set;}
        @AuraEnabled public Double JunQtyLY{get; set;}
        @AuraEnabled public Double JulQtyLY{get; set;}
        @AuraEnabled public Double AugQtyLY{get; set;}
        @AuraEnabled public Double SepQtyLY{get; set;}
        @AuraEnabled public Double OctQtyLY{get; set;}
        @AuraEnabled public Double NovQtyLY{get; set;}
        @AuraEnabled public Double DecQtyLY{get; set;}
        @AuraEnabled public Double JanQtyLY{get; set;}
        @AuraEnabled public Double FebQtyLY{get; set;}
        @AuraEnabled public Double MarQtyLY{get; set;}
        @AuraEnabled public Double TotalQtyLY{get; set;}
        
        @AuraEnabled public Double TotalVsForecast{get; set;}
        @AuraEnabled public Double AnnualQuantity{get;set;}
        @AuraEnabled public Double TotalQuantityTrend{get;set;}
        @AuraEnabled public Double TotalQuantityYTD_LFY{get;set;}
        @AuraEnabled public Double TotalQuantityYTD_VS_LFY{get;set;}
        @AuraEnabled public Double QuantityLast3Month{get;set;}
        @AuraEnabled public Double QuantityLast3MonthLY{get;set;}

        @AuraEnabled public Double TotalCalendarSalesLY{get; set;}
        @AuraEnabled public Double TotalCalendarSales{get; set;}
        @AuraEnabled public Double TotalCalendarQtyLY{get; set;}
        @AuraEnabled public Double TotalCalendarQty{get; set;}

        @AuraEnabled public Double janSalesN2{get;set;}
        @AuraEnabled public Double febSalesN2{get;set;}
        @AuraEnabled public Double marSalesN2{get;set;}
        @AuraEnabled public Double janQtyN2{get;set;}
        @AuraEnabled public Double febQtyN2{get;set;}
        @AuraEnabled public Double marQtyN2{get;set;}

        //calendar figures
        @AuraEnabled public Double TotalTurnoverYTD_LY{get;set;}
        @AuraEnabled public Double TotalVolumeYTD_LY{get;set;}
        @AuraEnabled public Double TotalTurnoverYTDvsLY{get;set;}
        @AuraEnabled public Double TotalVolumesYTDvsLY{get;set;}

        //Stock / Rx sales
         //For Stock and Rx Sales sales amount and quantity current fiscal year
         @AuraEnabled public Double AprRxSales{get; set;}
         @AuraEnabled public Double MayRxSales{get; set;}
         @AuraEnabled public Double JunRxSales{get; set;}
         @AuraEnabled public Double JulRxSales{get; set;}
         @AuraEnabled public Double AugRxSales{get; set;}
         @AuraEnabled public Double SepRxSales{get; set;}
         @AuraEnabled public Double OctRxSales{get; set;}
         @AuraEnabled public Double NovRxSales{get; set;}
         @AuraEnabled public Double DecRxSales{get; set;}
         @AuraEnabled public Double JanRxSales{get; set;}
         @AuraEnabled public Double FebRxSales{get; set;}
         @AuraEnabled public Double MarRxSales{get; set;}
 
         @AuraEnabled public Double AprRxQty{get;set;}
         @AuraEnabled public Double MayRxQty{get;set;}
         @AuraEnabled public Double JunRxQty{get;set;}
         @AuraEnabled public Double JulRxQty{get;set;}
         @AuraEnabled public Double AugRxQty{get;set;}
         @AuraEnabled public Double SepRxQty{get;set;}
         @AuraEnabled public Double OctRxQty{get;set;}
         @AuraEnabled public Double NovRxQty{get;set;}
         @AuraEnabled public Double DecRxQty{get;set;}
         @AuraEnabled public Double JanRxQty{get;set;}
         @AuraEnabled public Double FebrxQty{get;set;}
         @AuraEnabled public Double MarRxQty{get;set;}
 
         @AuraEnabled public Double Last_3_Month_RX{get;set;}
         @AuraEnabled public Double Last_3_Month_RXQty{get;set;}
         @AuraEnabled public Double Last_Month_RX{get;set;}
         @AuraEnabled public Double Last_Month_RXQty{get;set;}
         @AuraEnabled public Double TotalRxQty{get;set;}
         @AuraEnabled public Double TotalRxSales{get; set;}
 
         @AuraEnabled public Double AprRxSalesLY{get; set;}
         @AuraEnabled public Double MayRxSalesLY{get; set;}
         @AuraEnabled public Double JunRxSalesLY{get; set;}
         @AuraEnabled public Double JulRxSalesLY{get; set;}
         @AuraEnabled public Double AugRxSalesLY{get; set;}
         @AuraEnabled public Double SepRxSalesLY{get; set;}
         @AuraEnabled public Double OctRxSalesLY{get; set;}
         @AuraEnabled public Double NovRxSalesLY{get; set;}
         @AuraEnabled public Double DecRxSalesLY{get; set;}
         @AuraEnabled public Double JanRxSalesLY{get; set;}
         @AuraEnabled public Double FebRxSalesLY{get; set;}
         @AuraEnabled public Double MarRxSalesLY{get; set;}
 
         @AuraEnabled public Double AprRxQtyLY{get;set;}
         @AuraEnabled public Double MayRxQtyLY{get;set;}
         @AuraEnabled public Double JunRxQtyLY{get;set;}
         @AuraEnabled public Double JulRxQtyLY{get;set;}
         @AuraEnabled public Double AugRxQtyLY{get;set;}
         @AuraEnabled public Double SepRxQtyLY{get;set;}
         @AuraEnabled public Double OctRxQtyLY{get;set;}
         @AuraEnabled public Double NovRxQtyLY{get;set;}
         @AuraEnabled public Double DecRxQtyLY{get;set;}
         @AuraEnabled public Double JanRxQtyLY{get;set;}
         @AuraEnabled public Double FebRxQtyLY{get;set;}
         @AuraEnabled public Double MarRxQtyLY{get;set;}
 
         @AuraEnabled public Double Last_3_Month_RXLY{get; set;}
         @AuraEnabled public Double Last_Month_RXLY{get;set;}
         @AuraEnabled public Double Last_3_Month_RXQtyLY{get;set;}
         @AuraEnabled public Double Last_Month_RXQtyLY{get;set;}
         @AuraEnabled public Double TotalRxSalesLY{get; set;}
         @AuraEnabled public Double TotalRxQtyLY{get;set;}
 
         //For stock sales
         @AuraEnabled public Double AprStSales{get; set;}
         @AuraEnabled public Double MayStSales{get; set;}
         @AuraEnabled public Double JunStSales{get; set;}
         @AuraEnabled public Double JulStSales{get; set;}
         @AuraEnabled public Double AugStSales{get; set;}
         @AuraEnabled public Double SepStSales{get; set;}
         @AuraEnabled public Double OctStSales{get; set;}
         @AuraEnabled public Double NovStSales{get; set;}
         @AuraEnabled public Double DecStSales{get; set;}
         @AuraEnabled public Double JanStSales{get; set;}
         @AuraEnabled public Double FebStSales{get; set;}
         @AuraEnabled public Double MarStSales{get; set;}
 
         @AuraEnabled public Double AprStQty{get;set;}
         @AuraEnabled public Double MayStQty{get;set;}
         @AuraEnabled public Double JunStQty{get;set;}
         @AuraEnabled public Double JulStQty{get;set;}
         @AuraEnabled public Double AugStQty{get;set;}
         @AuraEnabled public Double SepStQty{get;set;}
         @AuraEnabled public Double OctStQty{get;set;}
         @AuraEnabled public Double NovStQty{get;set;}
         @AuraEnabled public Double DecStQty{get;set;}
         @AuraEnabled public Double JanStQty{get;set;}
         @AuraEnabled public Double FebStQty{get;set;}
         @AuraEnabled public Double MarStQty{get;set;}
 
         @AuraEnabled public Double Last_3_Month_ST{get; set;}
         @AuraEnabled public Double Last_3_Month_STQty{get;set;}
         @AuraEnabled public Double Last_Month_ST{get;set;}
         @AuraEnabled public Double Last_Month_STQty{get;set;}
         @AuraEnabled public Double TotalStSales{get; set;}
         @AuraEnabled public Double TotalStQty{get;set;}
 
         @AuraEnabled public Double AprStSalesLY{get;set;}
         @AuraEnabled public Double MayStSalesLY{get;set;}
         @AuraEnabled public Double JunStSalesLY{get;set;}
         @AuraEnabled public Double JulStSalesLY{get;set;}
         @AuraEnabled public Double AugStSalesLY{get;set;}
         @AuraEnabled public Double SepStSalesLY{get;set;}
         @AuraEnabled public Double OctStSalesLY{get;set;}
         @AuraEnabled public Double NovStSalesLY{get;set;}
         @AuraEnabled public Double DecStSalesLY{get;set;}
         @AuraEnabled public Double JanStSalesLY{get;set;}
         @AuraEnabled public Double FebStSalesLY{get;set;}
         @AuraEnabled public Double MarStSalesLY{get;set;}
 
         @AuraEnabled public Double AprStQtyLY{get;set;}
         @AuraEnabled public Double MayStQtyLY{get;set;}
         @AuraEnabled public Double JunStQtyLY{get;set;}
         @AuraEnabled public Double JulStQtyLY{get;set;}
         @AuraEnabled public Double AugStQtyLY{get;set;}
         @AuraEnabled public Double SepStQtyLY{get;set;}
         @AuraEnabled public Double OctStQtyLY{get;set;}
         @AuraEnabled public Double NovStQtyLY{get;set;}
         @AuraEnabled public Double DecStQtyLY{get;set;}
         @AuraEnabled public Double JanStQtyLY{get;set;}
         @AuraEnabled public Double FebStQtyLY{get;set;}
         @AuraEnabled public Double MarStQtyLY{get;set;}
 
 
         @AuraEnabled public Double Last_3_Month_STLY{get;set;}
         @AuraEnabled public Double Last_3_Month_STQtyLY{get;set;}
         @AuraEnabled public Double Last_Month_STLY{get;set;}
         @AuraEnabled public Double Last_Month_STQtyLY{get;set;}
         @AuraEnabled public Double TotalStSalesLY{get;set;}
         @AuraEnabled public Double TotalStQtyLY{get;set;}
        
        @AuraEnabled public QvRelatedAccountSales relatedSales{get;set;}

        public String PrevFY{get; set;}
        public String N2FY{get; set;}
        @AuraEnabled public String getCurrFY(){return CurrFY;}
    
        @AuraEnabled public String getPrevFY(){return PrevFY;}
        @AuraEnabled public String getN2_FY(){return N2FY;}
        
    }


    public class QvData{
        public QvData(String pdesign, Double pannualSales, Integer pAnnualQty){
            design=pdesign;
            annualSales=pannualSales;
            annualQty=pAnnualQty;
        }
        public String design{get; set;}
        public Double annualSales{get;set;}
        public Integer annualQty{get;set;}
    }
      /*
     * Current year variable
     */
    public static List<QvData> dataList{get;set;}
    
    /*
     * Last year variables
     */
    
    public static List<QvData> dataLYList{get;set;}
    //initial for category list
    public static List<QvData> dataRxList{get;set;}     //Current Year Rx List
    public static List<QvData> dataRxListLY{get;set;}   //Last year RX List

    public static List<QvData> dataStList{get;set;}     //Current Year Stock List
    public static List<QvData> dataStListLY{get;set;}   //Last Year Stock List
    
    private static Double conversionRate{get;set;}
    private static Double originalConversionRate{get;set;}
    private static Double AccountConversionRate{get;set;}
    private static Double AccConversionRateTest{get;set;}
    private static Double credits_CY{get; set;}
    private static Double credits_LY{get; set;}
    private static Double turnover_CY{get; set;}
    private static Double turnover_LY{get; set;}
    private static Double quantity_CY{get; set;}
    private static Double quantity_LY{get; set;}
    private static Double quantity_C_CY{get; set;}
    private static Double quantity_C_LY{get; set;}
    
    private static AggregateResult[] accountQVSales;
    private static AggregateResult[] accountQVSalesLY;

    //initialize for category in QV_Sales__c object
    private static AggregateResult[] accountRxQVSales;
    private static AggregateResult[] accountRxQVSalesLY;

    private static AggregateResult[] accountStQVSales;
    private static AggregateResult[] accountStQVSalesLY;
/*
    @AuraEnabled
    public static String getSeikoObjectType() {
        // Passing the sObject name in the method, it could be multiple objects too
        return ToolBox.getDescribedObjects( new List<String>{'Seiko_Data__c'} );    
    }
*/
    public AccountSalesTabComponentController() {

    }

    @AuraEnabled
    public static Seiko_data__c getSeikoData(Id recordId){
        Seiko_data__c seikoSales = null;
        try {
            
            System.debug('XXXX loading Seiko Sales data for account ' + recordId);
            seikoSales = [select id,Total_turnover__c,Total_turnover_last_year__c,Total_turnover_Trend__c
                                    ,SVS_Digital_communication_platform__c,SVS_Digital_com_platform_activation__c,SVS_FB_Page__c,SVS_Digital_com_Platform_radius__c,WS_error__c
                                    ,Segmentation__c, SVS_Total_Visits_achieved__c, SVS_recommended_number_of_visits__c, SVS_Number_of_digital_visits__c,SVS_Physical_Visit_Frequency__c,SVS_Digital_visit_frequency__c
                                    ,Remote_Edging__c,Glazing_Level__c,Account__r.Total_Loyalty_points__c
                                    from Seiko_Data__c where Account__c=:recordId
                                        ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return seikoSales;
    }

    @AuraEnabled
    public static string startEnroll(Id accountId){
        String error = 'ok';
        try{

            Seiko_data__c s = [select Id,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
            from Seiko_Data__c where Account__c=:accountId];

            error = ExternalWSCall.activateAccount(accountId, s.id);
        }catch (Exception e) {
            LogException.log(e);
            error = e.getMessage();
            return e.getMessage();
        }
        return error;
    }

    @AuraEnabled
    public static Date getLastTrainingDate(Id accountId, String training){
        System.debug('XXX Call AccountSalesTabComponentController.getLastTrainingDate('+accountId+','+training+')');
        try {
            List<ECP_Training__c> tList =[select id, Training__c, end__c from ECP_Training__c where Account__c=:accountId and training__c includes (:training) and Training_status__c='Completed' order by end__c desc];
            Date trainingDate =null;
            System.debug('XXX tList size = ' + tList.size());
            if(tList.size()>0 && tList[0].end__c!=null){
                trainingDate = date.newInstance(tList[0].end__c.year(), tList[0].end__c.month(), tList[0].end__c.day());
                System.debug('XXX Trainging date = ' + trainingDate);
            }
            return trainingDate;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Boolean isSocialMediaActive(Id accountId){
        try {
            Boolean active = false;
            Seiko_Data__c sd = [select id, SVS_Digital_communication_platform__c from Seiko_Data__c where Account__c=:accountId];
            if(sd!=null ){
                active = sd.SVS_Digital_communication_platform__c;
            }
            return active;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean isSeikoXtraNetNMU(Id accountId){
        try{
            Boolean active = false;
            Seiko_Data__c seiko = [select Id, SEIKO_Xtranet__c from Seiko_Data__c where Account__c=:accountId];
            if(seiko!=null){
                active = seiko.SEIKO_Xtranet__c;
            }
            return active;
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean SeikoXIpad(Id accountId){
        try{
            Boolean active = false;
            Seiko_Data__c seiko = [select Id, SEIKO_Vision_Xperience_iPAD__c from Seiko_Data__c where Account__c=:accountId];
            if(seiko!=null){
                active = seiko.SEIKO_Vision_Xperience_iPAD__c;
            }
            return active;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean isSeikoProActive(Id accountId){
        try {
            List<contact> cList = [select id, name, recordtype.name, portal_user_name__c from contact where accountid=:accountId and recordtype.name='Shop Owner' and portal_user_name__c!=null];
            return cList.size()>0;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Account getAccount(Id recordId){
        Account acc = null;
        try {
            acc = [select ID, Hoya_Account_ID__c,annualRevenue, currencyIsoCode,Brand__c, parentId,Potential__c
            , Last_3_Month_Total_sales_LY__c, Last_3_months_Avg_sales__c,Turnover_Amount__c
            , Seiko_objective_ECP_agr__c, Forecast_current_year__c, Actual_Sales_versus_Budget__c
            ,Last_3_Months_Total_Sales_VS_LY__c,Sales_Total_YTD_LY__c,Sales_CY_vs_LY_YTD__c,TACTICOM_SOF__c,TACTICOM_HLFR__c
            ,Remote_Edging__c,Glazing_Level__c
            from account where id=:recordId];
            return acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Account getDoorRelatedAccount(Id recordId){
        try {
            System.debug('XXXX Record ID' + recordID);
            Account acc = [select id, hoya_account_id__c, annualRevenue, Share_of_Wallet__c, Door__c,TACTICOM_SOF__c,TACTICOM_HLFR__c, Brand__c,Potential__c from Account where id=:recordId];
            String targetBrand = 'HOYA';
            if(acc.Brand__c=='HOYA'){
                targetBrand = 'SEIKO';
            }
            System.debug('XXXX targetBrand' + targetBrand);
            Account relatedAccount = null;
            if(acc.Door__c!=null){
                List<Account> relatedAccountList = [select id, hoya_account_id__c, annualRevenue, Share_of_Wallet__c, Door__c,TACTICOM_SOF__c,TACTICOM_HLFR__c,Potential__c,Brand__c from Account where door__c=:acc.Door__c and Brand__c=:targetBrand limit 1];
                
                System.debug('XXXX relatedAccountList' + relatedAccountList.size());
                if(relatedAccountList.size()>0){
                    relatedAccount = relatedAccountList.get(0);
                }
            }
            
            return relatedAccount;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static AccountSales initSales(Id recordId){
        System.Debug('XXXXX Call initSales('+recordId+')');
        AccountSales accountSales = new AccountSales();

        accountSales.account =  [select ID, Hoya_Account_ID__c,annualRevenue, currencyIsoCode,Brand__c, parentId
                , Last_3_Month_Total_sales_LY__c, Last_3_months_Avg_sales__c,Turnover_Amount__c
                , Seiko_objective_ECP_agr__c, Forecast_current_year__c, Actual_Sales_versus_Budget__c,
                Budget_March_Current_Year__c,Budget_February_Current_Year__c,Budget_January_Current_Year__c,Budget_December_Current_Year__c,Budget_November_Current_Year__c,Budget_October_Current_Year__c,Budget_September_Current_Year__c,Budget_August_Current_Year__c,Budget_July_Current_Year__c,Budget_June_Current_Year__c,Budget_May_Current_Year__c,Budget_April_Current_Year__c
                ,Last_3_Months_Total_Sales_VS_LY__c,Sales_Total_YTD_LY__c,Sales_CY_vs_LY_YTD__c,Total_Turnover_Trend__c, Sales_Total_Current_Year__c, Sales_Total_Last_Year__c
                from account where id=:recordId];

        if(accountSales.account.Brand__c=='Seiko'){
            System.debug('XXXX loading Seiko Sales data for account ' + accountSales.account.Hoya_Account_ID__c);
            accountSales.seikoSales = [select id,Total_turnover__c,Total_turnover_last_year__c,Total_turnover_Trend__c,SVS_Physical_Visit_Frequency__c from Seiko_Data__c where Account__c=:recordId];
        }
        //System.debug('Account annual revenue= ' + accountSales.account.annualRevenue);
        String userCurrency = UserInfo.getDefaultCurrency();
        String userCompany = [select companyName from User where id=: UserInfo.getUserId()].companyName;
        originalConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        String accountCurrency = [select currencyisocode from Account where id=:recordId].currencyIsoCode;
        AccountConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;
        AccConversionRateTest = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;

        if(conversionRate==AccountConversionRate){AccountConversionRate=1;}
        if(userCurrency!='EUR' && accountCurrency!='EUR'){AccountConversionRate=1;conversionRate=1;}
        if(userCurrency==accountCurrency)
        {
            AccountConversionRate=1;
            conversionRate=1;
        }
            
            /*
             * determine the current fiscal year
             */
            Integer year = Date.today().year();
            Integer month = Date.today().month();
            //fiscal year is current year-1 from january to march, year from april to december
            if( (month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                year = year-1;
            }
            accountSales.CurrFY = 'FY-' + String.valueOf(year).substring(2);
            accountSales.PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
            accountSales.N2FY = 'FY-' + String.valueOf(year-2).substring(2);
            //System.Debug('LAST YEAR/CURR YEAR=' + accountSales.PrevFY +'/'+accountSales.CurrFY);
            
            credits_CY = 0;
            credits_LY = 0;
            
            accountSales.AprSales = 0;
            accountSales.MaySales = 0;
            accountSales.JunSales = 0;
            accountSales.JulSales = 0;
            accountSales.AugSales = 0;
            accountSales.SepSales = 0;
            accountSales.OctSales = 0;
            accountSales.NovSales = 0;
            accountSales.DecSales = 0;
            accountSales.JanSales = 0;
            accountSales.FebSales = 0;
            accountSales.MarSales = 0;
            
            accountSales.AprQty = 0;
            accountSales.MayQty = 0;
            accountSales.JunQty = 0;
            accountSales.JulQty = 0;
            accountSales.AugQty = 0;
            accountSales.SepQty = 0;
            accountSales.OctQty = 0;
            accountSales.NovQty = 0;
            accountSales.DecQty = 0;
            accountSales.JanQty = 0;
            accountSales.FebQty = 0;
            accountSales.MarQty = 0;
            /*
             * compute current fiscal year data
             */
            accountQvSales =[SELECT Generic_Design__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty,FY__c
                , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty
            FROM QV_Sales__c
            where Account__c=:recordId and FY__c=:accountSales.CurrFY
            group by Generic_Design__c, FY__c];
            
                dataList=new List<QvData>();
                for(AggregateResult ar : accountQvSales) {
                    QvData data = new QvData(String.valueOf(ar.get('Generic_Design__c')), double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
                    dataList.add(data);
                }
                
            for( QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                          , October__c, November__c, December__c, January__c, February__c, March__c
                                          , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                          , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                          FROM QV_Sales__c
                                          where Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                                          and RX_or_Stock__c <> '""Other""' and RX_or_Stock__c <> 'CONSUMABLES' and RX_or_Stock__c <> 'LENS FITTING INCOME']){
                accountSales.AprSales = accountSales.AprSales + double.valueOf(qcy.April__c) * conversionRate;
                accountSales.MaySales = accountSales.MaySales + double.valueOf(qcy.May__c) * conversionRate;
                accountSales.JunSales = accountSales.JunSales + double.valueOf(qcy.June__c) * conversionRate;
                accountSales.JulSales = accountSales.JulSales + double.valueOf(qcy.July__c) * conversionRate;
                accountSales.AugSales = accountSales.AugSales + double.valueOf(qcy.August__c) * conversionRate;
                accountSales.SepSales = accountSales.SepSales + double.valueOf(qcy.September__c) * conversionRate;
                accountSales.OctSales = accountSales.OctSales + double.valueOf(qcy.October__c) * conversionRate;
                accountSales.NovSales = accountSales.NovSales + double.valueOf(qcy.November__c) * conversionRate;
                accountSales.DecSales = accountSales.DecSales + double.valueOf(qcy.December__c) * conversionRate;
                accountSales.JanSales = accountSales.JanSales + double.valueOf(qcy.January__c) * conversionRate;
                accountSales.FebSales = accountSales.FebSales + double.valueOf(qcy.February__c) * conversionRate;
                accountSales.MarSales = accountSales.MarSales + double.valueOf(qcy.March__c) * conversionRate;

                accountSales.AprQty = accountSales.AprQty + double.valueOf(qcy.April_qty__c) ;
                accountSales.MayQty = accountSales.MayQty + double.valueOf(qcy.May_qty__c) ;
                accountSales.JunQty = accountSales.JunQty + double.valueOf(qcy.June_qty__c) ;
                accountSales.JulQty = accountSales.JulQty + double.valueOf(qcy.July_qty__c) ;
                accountSales.AugQty = accountSales.AugQty + double.valueOf(qcy.August_qty__c) ;
                accountSales.SepQty = accountSales.SepQty + double.valueOf(qcy.September_qty__c) ;
                accountSales.OctQty = accountSales.OctQty + double.valueOf(qcy.October_qty__c) ;
                accountSales.NovQty = accountSales.NovQty + double.valueOf(qcy.November_qty__c) ;
                accountSales.DecQty = accountSales.DecQty + double.valueOf(qcy.December_qty__c) ;
                accountSales.JanQty = accountSales.JanQty + double.valueOf(qcy.January_qty__c) ;
                accountSales.FebQty = accountSales.FebQty + double.valueOf(qcy.February_qty__c) ;
                accountSales.MarQty = accountSales.MarQty + double.valueOf(qcy.March_qty__c) ;

            }
            if(userCompany=='HAPL' || Test.isRunningTest()){
                /* include frame for HAPL */
                for( QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                        , October__c, November__c, December__c, January__c, February__c, March__c
                                        FROM QV_Sales__c
                                        where Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c='FRAME'
                                       ]){
                accountSales.AprSales = accountSales.AprSales + double.valueOf(qcy.April__c) * conversionRate;
                accountSales.MaySales = accountSales.MaySales + double.valueOf(qcy.May__c) * conversionRate;
                accountSales.JunSales = accountSales.JunSales + double.valueOf(qcy.June__c) * conversionRate;
                accountSales.JulSales = accountSales.JulSales + double.valueOf(qcy.July__c) * conversionRate;
                accountSales.AugSales = accountSales.AugSales + double.valueOf(qcy.August__c) * conversionRate;
                accountSales.SepSales = accountSales.SepSales + double.valueOf(qcy.September__c) * conversionRate;
                accountSales.OctSales = accountSales.OctSales + double.valueOf(qcy.October__c) * conversionRate;
                accountSales.NovSales = accountSales.NovSales + double.valueOf(qcy.November__c) * conversionRate;
                accountSales.DecSales = accountSales.DecSales + double.valueOf(qcy.December__c) * conversionRate;
                accountSales.JanSales = accountSales.JanSales + double.valueOf(qcy.January__c) * conversionRate;
                accountSales.FebSales = accountSales.FebSales + double.valueOf(qcy.February__c) * conversionRate;
                accountSales.MarSales = accountSales.MarSales + double.valueOf(qcy.March__c) * conversionRate;
                                         }
            }
            /*
             * compute Last Fiscal year data
             */
            accountQvSalesLY =[SELECT Generic_Design__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty,FY__c
                , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty
            FROM QV_Sales__c
            where Account__c=:recordId and FY__c=:accountSales.PrevFY
            and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
            AND RX_or_Stock__c <> '""Other""' and RX_or_Stock__c <> 'CONSUMABLES' and RX_or_Stock__c <> 'LENS FITTING INCOME' group by Generic_Design__c, FY__c];
            
            accountSales.AprSalesLY = 0;
            accountSales.MaySalesLY = 0;
            accountSales.JunSalesLY = 0;
            accountSales.JulSalesLY = 0;
            accountSales.AugSalesLY = 0;
            accountSales.SepSalesLY = 0;
            accountSales.OctSalesLY = 0;
            accountSales.NovSalesLY = 0;
            accountSales.DecSalesLY = 0;
            accountSales.JanSalesLY = 0;
            accountSales.FebSalesLY = 0;
            accountSales.MarSalesLY = 0;
            
            accountSales.AprQtyLY = 0;
            accountSales.MayQtyLY = 0;
            accountSales.JunQtyLY = 0;
            accountSales.JulQtyLY = 0;
            accountSales.AugQtyLY = 0;
            accountSales.SepQtyLY = 0;
            accountSales.OctQtyLY = 0;
            accountSales.NovQtyLY = 0;
            accountSales.DecQtyLY = 0;
            accountSales.JanQtyLY = 0;
            accountSales.FebQtyLY = 0;
            accountSales.MarQtyLY = 0;
                
            dataLYList=new List<QvData>();
            for(AggregateResult ar : accountQvSalesLY) {
                QvData data = new QvData(String.valueOf(ar.get('Generic_Design__c')), double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
                dataLYList.add(data);
            }
            
             for( QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                     , December__c, January__c, February__c, March__c
                                    , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                    , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c
                                    FROM QV_Sales__c
                                    where Account__c=:recordId and FY__c=:accountSales.PrevFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                                    AND RX_or_Stock__c <> '""Other""' and RX_or_Stock__c <> 'CONSUMABLES' AND RX_or_Stock__c <> 'LENS FITTING INCOME']){
                accountSales.AprSalesLY = accountSales.AprSalesLY + double.valueOf(qly.April__c) * conversionRate;
                accountSales.MaySalesLY = accountSales.MaySalesLY + double.valueOf(qly.May__c) * conversionRate;
                accountSales.JunSalesLY = accountSales.JunSalesLY + double.valueOf(qly.June__c) * conversionRate;
                accountSales.JulSalesLY = accountSales.JulSalesLY + double.valueOf(qly.July__c) * conversionRate;
                accountSales.AugSalesLY = accountSales.AugSalesLY + double.valueOf(qly.August__c) * conversionRate;
                accountSales.SepSalesLY = accountSales.SepSalesLY + double.valueOf(qly.September__c) * conversionRate;
                accountSales.OctSalesLY = accountSales.OctSalesLY + double.valueOf(qly.October__c) * conversionRate;
                accountSales.NovSalesLY = accountSales.NovSalesLY + double.valueOf(qly.November__c) * conversionRate;
                accountSales.DecSalesLY = accountSales.DecSalesLY + double.valueOf(qly.December__c) * conversionRate;
                accountSales.JanSalesLY = accountSales.JanSalesLY + double.valueOf(qly.January__c) * conversionRate;
                accountSales.FebSalesLY = accountSales.FebSalesLY + double.valueOf(qly.February__c) * conversionRate;
                accountSales.MarSalesLY = accountSales.MarSalesLY+ double.valueOf(qly.March__c) * conversionRate;
                
                accountSales.AprQtyLY = accountSales.AprQtyLY + double.valueOf(qly.April_qty__c) ;
                accountSales.MayQtyLY = accountSales.MayQtyLY + double.valueOf(qly.May_qty__c) ;
                accountSales.JunQtyLY = accountSales.JunQtyLY + double.valueOf(qly.June_qty__c) ;
                accountSales.JulQtyLY = accountSales.JulQtyLY + double.valueOf(qly.July_qty__c) ;
                accountSales.AugQtyLY = accountSales.AugQtyLY + double.valueOf(qly.August_qty__c) ;
                accountSales.SepQtyLY = accountSales.SepQtyLY + double.valueOf(qly.September_qty__c) ;
                accountSales.OctQtyLY = accountSales.OctQtyLY + double.valueOf(qly.October_qty__c) ;
                accountSales.NovQtyLY = accountSales.NovQtyLY + double.valueOf(qly.November_qty__c) ;
                accountSales.DecQtyLY = accountSales.DecQtyLY + double.valueOf(qly.December_qty__c) ;
                accountSales.JanQtyLY = accountSales.JanQtyLY + double.valueOf(qly.January_qty__c) ;
                accountSales.FebQtyLY = accountSales.FebQtyLY + double.valueOf(qly.February_qty__c) ;
                accountSales.MarQtyLY = accountSales.MarQtyLY + double.valueOf(qly.March_qty__c) ;
            }
             if(userCompany=='HAPL' || Test.isRunningTest()){
                /* include frame for HAPL */
                 for( QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                           , December__c, January__c, February__c, March__c
                           FROM QV_Sales__c
                           where Account__c=:recordId and FY__c=:accountSales.PrevFY and RX_or_Stock__c='FRAME' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                           ]){
                accountSales.AprSalesLY = accountSales.AprSalesLY + double.valueOf(qly.April__c) * conversionRate;
                accountSales.MaySalesLY = accountSales.MaySalesLY + double.valueOf(qly.May__c) * conversionRate;
                accountSales.JunSalesLY = accountSales.JunSalesLY + double.valueOf(qly.June__c) * conversionRate;
                accountSales.JulSalesLY = accountSales.JulSalesLY + double.valueOf(qly.July__c) * conversionRate;
                accountSales.AugSalesLY = accountSales.AugSalesLY + double.valueOf(qly.August__c) * conversionRate;
                accountSales.SepSalesLY = accountSales.SepSalesLY + double.valueOf(qly.September__c) * conversionRate;
                accountSales.OctSalesLY = accountSales.OctSalesLY + double.valueOf(qly.October__c) * conversionRate;
                accountSales.NovSalesLY = accountSales.NovSalesLY + double.valueOf(qly.November__c) * conversionRate;
                accountSales.DecSalesLY = accountSales.DecSalesLY + double.valueOf(qly.December__c) * conversionRate;
                accountSales.JanSalesLY = accountSales.JanSalesLY + double.valueOf(qly.January__c) * conversionRate;
                accountSales.FebSalesLY = accountSales.FebSalesLY + double.valueOf(qly.February__c) * conversionRate;
                accountSales.MarSalesLY = accountSales.MarSalesLY+ double.valueOf(qly.March__c) * conversionRate;
                           }
             }
             //compute for current fiscal year for RX QV Sales
                accountSales.Last_3_Month_RX = 0;
                accountSales.Last_3_Month_RXQty = 0;

                accountRxQVSales = [SELECT rx_or_stock__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty, FY__c
                                    ,sum(Last_3_Months_Sales__c) last3month, sum(Last_3_Months_qty__c) last3monthqty
                                    ,sum(Last_Month_turnover__c) lastmonthsales, sum(Last_Month_Turnover_Qty__c) lastmonthqty
                                    FROM QV_Sales__c WHERE Account__c=:recordId and FY__c=:accountSales.CurrFY
                and RX_or_Stock__c='RX' group by rx_or_stock__c, FY__c];
             
                dataRxList = new List<QvData>();
                for(AggregateResult ar : accountRxQVSales){
                    QvData data = new QvData(String.valueOf(ar.get('rx_or_stock__c')), Double.valueOf(ar.get('annualSales')), Integer.valueof(ar.get('annualQty')));
                    dataRxList.add(data);
                }

                for(QV_Sales__c qRx : [SELECT Last_3_Months_Sales__c, Last_3_Months_qty__c
                                        , Last_Month_turnover__c, Last_Month_Turnover_Qty__c FROM QV_Sales__c
                                        WHERE Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c='RX'])
                {
                    accountSales.Last_3_Month_RX = accountSales.Last_3_Month_RX + double.valueOf(qRx.Last_3_Months_Sales__c)*conversionRate;
                    accountSales.Last_3_Month_RXQty = accountSales.Last_3_Month_RXQty + double.valueOf(qRx.Last_3_Months_qty__c);
                }

                //Compute for Rx sales last fiscal year

                 /*compute for current year Rx lenses */
            accountSales.AprRxSales = 0;
            accountSales.MayRxSales = 0;
            accountSales.JunRxSales = 0;
            accountSales.JulRxSales = 0;
            accountSales.AugRxSales = 0;
            accountSales.SepRxSales = 0;
            accountSales.OctRxSales = 0;
            accountSales.NovRxSales = 0;
            accountSales.DecRxSales = 0;
            accountSales.JanRxSales = 0;
            accountSales.FebRxSales = 0;
            accountSales.MarRxSales = 0;
            accountSales.Last_3_Month_RX = 0;
            accountSales.Last_Month_RX = 0;

            accountSales.AprRxQty = 0;
            accountSales.MayRxQty = 0;
            accountSales.JunRxQty = 0;
            accountSales.JulRxQty = 0;
            accountSales.AugRxQty = 0;
            accountSales.SepRxQty = 0;
            accountSales.OctRxQty = 0;
            accountSales.NovRxQty = 0;
            accountSales.DecRxQty = 0;
            accountSales.JanRxQty = 0;
            accountSales.FebrxQty = 0;
            accountSales.MarRxQty = 0;
            accountSales.Last_3_Month_RXQty = 0;
            accountSales.Last_Month_RXQty = 0;
            
            accountRxQVSales = [SELECT rx_or_stock__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty, FY__c
                                        , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                                        , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                                        , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                                        , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty, sum(Last_3_Months_Sales__c) last3month, sum(Last_3_Months_qty__c) last3monthqty
                                        , sum(Last_Month_turnover__c) lastmonthsales, sum(Last_Month_Turnover_Qty__c) lastmonthqty
                                    FROM QV_Sales__c
                                        where Account__c=:recordId and FY__c=:accountSales.CurrFY
                                        and RX_or_Stock__c='RX' group by rx_or_stock__c, FY__c];
            
            dataRxList = new List<QvData>();
            for(AggregateResult ar : accountRxQVSales){
                QvData data = new QvData(String.valueOf(ar.get('rx_or_stock__c')), Double.valueOf(ar.get('annualSales')), Integer.valueof(ar.get('annualQty')));
                dataRxList.add(data);
            }

            for(QV_Sales__c qRx : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                    , December__c, January__c, February__c, March__c
                                    , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                    , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c, Last_3_Months_Sales__c, Last_3_Months_qty__c
                                    , Last_Month_turnover__c, Last_Month_Turnover_Qty__c
                                FROM QV_Sales__c
                                where Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c='RX'])
            {
                accountSales.AprRxSales = accountSales.AprRxSales + double.valueOf(qRx.April__c)*conversionRate;
                accountSales.MayRxSales = accountSales.MayRxSales + double.valueOf(qRx.May__c)*conversionRate;
                accountSales.JunRxSales = accountSales.JunRxSales + double.valueOf(qRx.June__c)*conversionRate;
                accountSales.JulRxSales = accountSales.JulRxSales + double.valueOf(qRx.July__c)*conversionRate;
                accountSales.AugRxSales = accountSales.AugRxSales + double.valueOf(qRx.August__c)*conversionRate;
                accountSales.SepRxSales = accountSales.SepRxSales + double.valueOf(qRx.September__c)*conversionRate;
                accountSales.OctRxSales = accountSales.OctRxSales + double.valueOf(qRx.October__c)*conversionRate;
                accountSales.NovRxSales = accountSales.NovRxSales + double.valueOf(qRx.November__c)*conversionRate;
                accountSales.DecRxSales = accountSales.DecRxSales + double.valueOf(qRx.December__c)*conversionRate;
                accountSales.JanRxSales = accountSales.JanRxSales + double.valueOf(qRx.January__c)*conversionRate;
                accountSales.FebRxSales = accountSales.FebRxSales + double.valueOf(qRx.February__c)*conversionRate;
                accountSales.MarRxSales = accountSales.MarRxSales + double.valueOf(qRx.March__c)*conversionRate;
                accountSales.Last_3_Month_RX = accountSales.Last_3_Month_RX + double.valueOf(qRx.Last_3_Months_Sales__c)*conversionRate;
                accountSales.Last_Month_RX = accountSales.Last_Month_RX + double.valueOf(qRx.Last_Month_turnover__c)*conversionRate;

                accountSales.AprRxQty = accountSales.AprRxQty + double.valueOf(qRx.April_qty__c);
                accountSales.MayRxQty = accountSales.MayRxQty + double.valueOf(qRx.May_qty__c);
                accountSales.JunRxQty = accountSales.JunRxQty + double.valueOf(qRx.June_qty__c);
                accountSales.JulRxQty = accountSales.JulRxQty + double.valueOf(qRx.July_qty__c);
                accountSales.AugRxQty = accountSales.AugRxQty + double.valueOf(qRx.August_qty__c);
                accountSales.SepRxQty = accountSales.SepRxQty + double.valueOf(qRx.September_qty__c);
                accountSales.OctRxQty = accountSales.OctRxQty + double.valueOf(qRx.October_qty__c);
                accountSales.NovRxQty = accountSales.NovRxQty + double.valueOf(qRx.November_qty__c);
                accountSales.DecRxQty = accountSales.DecRxQty + double.valueOf(qRx.December_qty__c);
                accountSales.JanRxQty = accountSales.JanRxQty + double.valueOf(qRx.January_qty__c);
                accountSales.FebrxQty = accountSales.FebrxQty + double.valueOf(qRx.February_qty__c);
                accountSales.MarRxQty = accountSales.MarRxQty + double.valueOf(qRx.March_qty__c);
                accountSales.Last_3_Month_RXQty = accountSales.Last_3_Month_RXQty + double.valueOf(qRx.Last_3_Months_qty__c);
                accountSales.Last_Month_RXQty = accountSales.Last_Month_RXQty + double.valueof(qRx.Last_Month_Turnover_Qty__c);

            }

            /*Compute for Rx sales last year */

            accountSales.AprRxSalesLY = 0;
            accountSales.MayRxSalesLY = 0;
            accountSales.JunRxSalesLY = 0;
            accountSales.JulRxSalesLY = 0;
            accountSales.AugRxSalesLY = 0;
            accountSales.SepRxSalesLY = 0;
            accountSales.OctRxSalesLY = 0;
            accountSales.NovRxSalesLY = 0;
            accountSales.DecRxSalesLY = 0;
            accountSales.JanRxSalesLY = 0;
            accountSales.FebRxSalesLY = 0;
            accountSales.MarRxSalesLY = 0;
            accountSales.Last_3_Month_RXLY = 0;
            accountSales.Last_Month_RXLY = 0;

            accountSales.AprRxQtyLY = 0;
            accountSales.MayRxQtyLY = 0;
            accountSales.JunRxQtyLY = 0;
            accountSales.JulRxQtyLY = 0;
            accountSales.AugRxQtyLY = 0;
            accountSales.SepRxQtyLY = 0;
            accountSales.OctRxQtyLY = 0;
            accountSales.NovRxQtyLY = 0;
            accountSales.DecRxQtyLY = 0;
            accountSales.JanRxQtyLY = 0;
            accountSales.FebRxQtyLY = 0;
            accountSales.MarRxQtyLY = 0;
            accountSales.Last_3_Month_RXQtyLY = 0;
            accountSales.Last_Month_RXQtyLY = 0;
            
            accountRxQVSalesLY = [SELECT rx_or_stock__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty, FY__c
                                        , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                                        , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                                        , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                                        , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty, sum(Last_3_Months_Sales__c) last3month, sum(Last_3_Months_qty__c) last3monthqty
                                        , sum(Last_Month_turnover__c) lastmonth, sum(Last_Month_Turnover_Qty__c) lastmonthqty
                                    FROM QV_Sales__c
                                        where Account__c=:recordId and FY__c=:accountSales.PrevFY
                                        and RX_or_Stock__c='RX' group by rx_or_stock__c, FY__c];
            
            dataRxListLY = new List<QvData>();
            for(AggregateResult ar : accountRxQVSalesLY){
                QvData data = new QvData(String.valueOf(ar.get('rx_or_stock__c')), Double.valueOf(ar.get('annualSales')), Integer.valueof(ar.get('annualQty')));
                dataRxListLY.add(data);
            }

            for(QV_Sales__c qLRx : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                    , December__c, January__c, February__c, March__c
                                    , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                    , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c, Last_3_Months_Sales__c, Last_3_Months_qty__c
                                    , Last_Month_turnover__c, Last_Month_Turnover_Qty__c
                                FROM QV_Sales__c
                                where Account__c=:recordId and FY__c=:accountSales.PrevFY and RX_or_Stock__c='RX'])
            {
                accountSales.AprRxSalesLY = accountSales.AprRxSalesLY + double.valueOf(qLRx.April__c)*conversionRate;
                accountSales.MayRxSalesLY = accountSales.MayRxSalesLY + double.valueOf(qLRx.May__c)*conversionRate;
                accountSales.JunRxSalesLY = accountSales.JunRxSalesLY + double.valueOf(qLRx.June__c)*conversionRate;
                accountSales.JulRxSalesLY = accountSales.JulRxSalesLY + double.valueOf(qLRx.July__c)*conversionRate;
                accountSales.AugRxSalesLY = accountSales.AugRxSalesLY + double.valueOf(qLRx.August__c)*conversionRate;
                accountSales.SepRxSalesLY = accountSales.SepRxSalesLY + double.valueOf(qLRx.September__c)*conversionRate;
                accountSales.OctRxSalesLY = accountSales.OctRxSalesLY + double.valueOf(qLRx.October__c)*conversionRate;
                accountSales.NovRxSalesLY = accountSales.NovRxSalesLY + double.valueOf(qLRx.November__c)*conversionRate;
                accountSales.DecRxSalesLY = accountSales.DecRxSalesLY + double.valueOf(qLRx.December__c)*conversionRate;
                accountSales.JanRxSalesLY = accountSales.JanRxSalesLY + double.valueOf(qLRx.January__c)*conversionRate;
                accountSales.FebRxSalesLY = accountSales.FebRxSalesLY + double.valueOf(qLRx.February__c)*conversionRate;
                accountSales.MarRxSalesLY = accountSales.MarRxSalesLY + double.valueOf(qLRx.March__c)*conversionRate;
                accountSales.Last_3_Month_RXLY = accountSales.Last_3_Month_RXLY + double.valueOf(qLRx.Last_3_Months_Sales__c)*conversionRate;
                accountSales.Last_Month_RXLY = accountSales.Last_Month_RXLY + double.valueOf(qLRx.Last_Month_turnover__c)*conversionRate;

                accountSales.AprRxQtyLY = accountSales.AprRxQtyLY + double.valueOf(qLRx.April_qty__c);
                accountSales.MayRxQtyLY = accountSales.MayRxQtyLY + double.valueOf(qLRx.May_qty__c);
                accountSales.JunRxQtyLY = accountSales.JunRxQtyLY + double.valueOf(qLRx.June_qty__c);
                accountSales.JulRxQtyLY = accountSales.JulRxQtyLY + double.valueOf(qLRx.July_qty__c);
                accountSales.AugRxQtyLY = accountSales.AugRxQtyLY + double.valueOf(qLRx.August_qty__c);
                accountSales.SepRxQtyLY = accountSales.SepRxQtyLY + double.valueOf(qLRx.September_qty__c);
                accountSales.OctRxQtyLY = accountSales.OctRxQtyLY + double.valueOf(qLRx.October_qty__c);
                accountSales.NovRxQtyLY = accountSales.NovRxQtyLY + double.valueOf(qLRx.November_qty__c);
                accountSales.DecRxQtyLY = accountSales.DecRxQtyLY + double.valueOf(qLRx.December_qty__c);
                accountSales.JanRxQtyLY = accountSales.JanRxQtyLY + double.valueOf(qLRx.January_qty__c);
                accountSales.FebRxQtyLY = accountSales.FebRxQtyLY + double.valueOf(qLRx.February_qty__c);
                accountSales.MarRxQtyLY = accountSales.MarRxQtyLY + double.valueOf(qLRx.March_qty__c);
                accountSales.Last_3_Month_RXQtyLY = accountSales.Last_3_Month_RXQtyLY + double.valueOf(qLRx.Last_3_Months_qty__c);
                accountSales.Last_Month_RXQtyLY = accountSales.Last_Month_RXQtyLY + double.valueOf(qLRx.Last_Month_Turnover_Qty__c);

            }

             /*compute for Stock lens current fiscal year */
             accountSales.AprStSales = 0;
             accountSales.MayStSales = 0;
             accountSales.JunStSales = 0;
             accountSales.JulStSales = 0;
             accountSales.AugStSales = 0;
             accountSales.SepStSales = 0;
             accountSales.OctStSales = 0;
             accountSales.NovStSales = 0;
             accountSales.DecStSales = 0;
             accountSales.JanStSales = 0;
             accountSales.FebStSales = 0;
             accountSales.MarStSales = 0;
             accountSales.Last_3_Month_ST = 0;
             accountSales.Last_Month_ST = 0;
 
             accountSales.AprStQty = 0;
             accountSales.MayStQty = 0;
             accountSales.JunStQty = 0;
             accountSales.JulStQty = 0;
             accountSales.AugStQty = 0;
             accountSales.SepStQty = 0;
             accountSales.OctStQty = 0;
             accountSales.NovStQty = 0;
             accountSales.DecStQty = 0;
             accountSales.JanStQty = 0;
             accountSales.FebStQty = 0;
             accountSales.MarStQty = 0;
             accountSales.Last_3_Month_STQty = 0;
             accountSales.Last_Month_STQty = 0;
 
             accountStQVSales = [SELECT rx_or_stock__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty, FY__c
                                 , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                                 , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                                 , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                                 , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty, sum(Last_3_Months_Sales__c) last3month
                                 , sum(Last_Month_turnover__c) lastmonthsales, sum(Last_Month_Turnover_Qty__c) lastmonthqty
                                 FROM QV_Sales__c
                                 where Account__c=:recordId and FY__c=:accountSales.CurrFY
                                 and RX_or_Stock__c='ST' group by rx_or_stock__c, FY__c];
             
             dataStList = new List<QvData>();
 
             for(AggregateResult ar : accountStQVSales){
                 QvData data = new QvData(String.valueOf(ar.get('rx_or_stock__c')), Double.valueOf(ar.get('annualSales')), Integer.valueof(ar.get('annualQty')));
                 dataStList.add(data);
             }
 
             for(QV_Sales__c qSt : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                     , December__c, January__c, February__c, March__c
                                     , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                     , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c, Last_3_Months_Sales__c, Last_3_Months_qty__c
                                     , Last_Month_turnover__c, Last_Month_Turnover_Qty__c
                                 FROM QV_Sales__c
                                 where Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c='ST'])
             {
                 accountSales.AprStSales = accountSales.AprStSales + double.valueOf(qSt.April__c)*conversionRate;
                 accountSales.MarStSales = accountSales.MarStSales + double.valueOf(qSt.May__c)*conversionRate;
                 accountSales.JunStSales = accountSales.JunStSales + double.valueOf(qSt.June__c)*conversionRate;
                 accountSales.JulStSales = accountSales.JulStSales + double.valueOf(qSt.July__c)*conversionRate;
                 accountSales.AugStSales = accountSales.AugStSales + double.valueOf(qSt.August__c)*conversionRate;
                 accountSales.SepStSales = accountSales.SepStSales + double.valueOf(qSt.September__c)*conversionRate;
                 accountSales.OctStSales = accountSales.OctStSales + double.valueOf(qSt.October__c)*conversionRate;
                 accountSales.NovStSales = accountSales.NovStSales + double.valueOf(qSt.November__c)*conversionRate;
                 accountSales.DecStSales = accountSales.DecStSales + double.valueOf(qSt.December__c)*conversionRate;
                 accountSales.JanStSales = accountSales.JanStSales + double.valueOf(qSt.January__c)*conversionRate;
                 accountSales.FebStSales = accountSales.FebStSales + double.valueOf(qSt.February__c)*conversionRate;
                 accountSales.MarStSales = accountSales.MarStSales + double.valueOf(qSt.March__c)*conversionRate;
                 accountSales.Last_3_Month_ST = accountSales.Last_3_Month_ST + double.valueof(qSt.Last_3_Months_Sales__c)*conversionRate;
                 accountSales.Last_Month_ST = accountSales.Last_Month_ST + double.valueOf(qST.Last_Month_turnover__c)*conversionRate;
 
                 accountSales.AprStQty = accountSales.AprStQty + double.valueOf(qSt.April_qty__c);
                 accountSales.MayStQty = accountSales.MayStQty + double.valueOf(qSt.May_qty__c);
                 accountSales.JunStQty = accountSales.JunStQty + double.valueOf(qSt.June_qty__c);
                 accountSales.JulStQty = accountSales.JulStQty + double.valueOf(qSt.July_qty__c);
                 accountSales.AugStQty = accountSales.AugStQty + double.valueOf(qSt.August_qty__c);
                 accountSales.SepStQty = accountSales.SepStQty + double.valueOf(qSt.September_qty__c);
                 accountSales.OctStQty = accountSales.OctStQty + double.valueOf(qSt.October_qty__c);
                 accountSales.NovStQty = accountSales.NovStQty + double.valueOf(qSt.November_qty__c);
                 accountSales.DecStQty = accountSales.DecStQty + double.valueOf(qSt.December_qty__c);
                 accountSales.JanStQty = accountSales.JanStQty + double.valueOf(qSt.January_qty__c);
                 accountSales.FebStQty = accountSales.FebStQty + double.valueOf(qSt.February_qty__c);
                 accountSales.MarStQty = accountSales.MarStQty + double.valueOf(qSt.March_qty__c);
                 accountSales.Last_3_Month_STQty = accountSales.Last_3_Month_STQty + double.valueOf(qSt.Last_3_Months_qty__c);
                 accountSales.Last_Month_STQty = accountSales.Last_Month_STQty + double.valueOf(qSt.Last_Month_Turnover_Qty__c);
             }
 
             /*compute for stock lens sales last fiscal year */
 
             accountSales.AprStSalesLY = 0;
             accountSales.MayStSalesLY = 0;
             accountSales.JunStSalesLY = 0;
             accountSales.JulStSalesLY = 0;
             accountSales.AugStSalesLY = 0;
             accountSales.SepStSalesLY = 0;
             accountSales.OctStSalesLY = 0;
             accountSales.NovStSalesLY = 0;
             accountSales.DecStSalesLY = 0;
             accountSales.JanStSalesLY = 0;
             accountSales.FebStSalesLY = 0;
             accountSales.MarStSalesLY = 0;
             accountSales.Last_3_Month_STLY = 0;
             accountSales.Last_Month_STLY = 0;
             
             accountSales.AprStQtyLY = 0;
             accountSales.MayStQtyLY = 0;
             accountSales.JunStQtyLY = 0;
             accountSales.JulStQtyLY = 0;
             accountSales.AugStQtyLY = 0;
             accountSales.SepStQtyLY = 0;
             accountSales.OctStQtyLY = 0;
             accountSales.NovStQtyLY = 0;
             accountSales.DecStQtyLY = 0;
             accountSales.JanStQtyLY = 0;
             accountSales.FebStQtyLY = 0;
             accountSales.MarStQtyLY = 0;
             accountSales.Last_3_Month_STQtyLY = 0;
             accountSales.Last_Month_STQtyLY = 0;
 
             accountStQVSalesLY = [SELECT rx_or_stock__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty, FY__c
                                     , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
                                     , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
                                     , sum(April_qty__c) aprqty, sum(May_qty__c) mayqty, sum(June_qty__c) junqty, sum(July_qty__c) julqty, sum(August_qty__c) augqty, sum(September_qty__c) sepqty
                                     , sum(October_qty__c) octqty, sum(November_qty__c) novqty, sum(December_qty__c) decqty, sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty, sum(Last_3_Months_Sales__c) last3month
                                     , sum(Last_Month_turnover__c) lastmonthsales, sum(Last_Month_Turnover_Qty__c) lastmonthqty
                                 FROM QV_Sales__c
                                 where Account__c=:recordId and FY__c=:accountSales.PrevFY
                                 and RX_or_Stock__c='ST' group by rx_or_stock__c, FY__c];
             
             dataStListLY = new List<QvData>();
 
             for(AggregateResult ar : accountStQVSalesLY){
                 QvData data = new QvData(String.valueOf(ar.get('rx_or_stock__c')), Double.valueOf(ar.get('annualSales')), Integer.valueof(ar.get('annualQty')));
                 dataStListLY.add(data);
             }
 
             for(QV_Sales__c qLSt : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                     , December__c, January__c, February__c, March__c
                                     , April_qty__c, May_qty__c, June_qty__c, July_qty__c, August_qty__c, September_qty__c
                                     , October_qty__c, November_qty__c, December_qty__c, January_qty__c, February_qty__c, March_qty__c, Last_3_Months_Sales__c, Last_3_Months_qty__c
                                     , Last_Month_turnover__c, Last_Month_Turnover_Qty__c
                                 FROM QV_Sales__c
                                 where Account__c=:recordId and FY__c=:accountSales.PrevFY and RX_or_Stock__c='ST'])
             {
                 accountSales.AprStSalesLY = accountSales.AprStSalesLY + double.valueOf(qLSt.April__c)*conversionRate;
                 accountSales.MayStSalesLY = accountSales.MayStSalesLY + double.valueOf(qLSt.May__c)*conversionRate;
                 accountSales.JunStSalesLY = accountSales.JunStSalesLY + double.valueOf(qLSt.June__c)*conversionRate;
                 accountSales.JulStSalesLY = accountSales.JulStSalesLY + double.valueOf(qLSt.July__c)*conversionRate;
                 accountSales.AugStSalesLY = accountSales.AugStSalesLY + double.valueOf(qLSt.August__c)*conversionRate;
                 accountSales.SepStSalesLY = accountSales.SepStSalesLY + double.valueOf(qLSt.September__c)*conversionRate;
                 accountSales.OctStSalesLY = accountSales.OctStSalesLY + double.valueOf(qLSt.October__c)*conversionRate;
                 accountSales.NovStSalesLY = accountSales.NovStSalesLY + double.valueOf(qLSt.November__c)*conversionRate;
                 accountSales.DecStSalesLY = accountSales.DecStSalesLY + double.valueOf(qLSt.December__c)*conversionRate;
                 accountSales.JanStSalesLY = accountSales.JanStSalesLY + double.valueOf(qLSt.January__c)*conversionRate;
                 accountSales.FebStSalesLY = accountSales.FebStSalesLY + double.valueOf(qLSt.February__c)*conversionRate;
                 accountSales.MarStSalesLY = accountSales.MarStSalesLY + double.valueOf(qLSt.March__c)*conversionRate;
                 accountSales.Last_3_Month_STLY = accountSales.Last_3_Month_STLY + double.valueOf(qLSt.Last_3_Months_Sales__c)*conversionRate;
                 accountSales.Last_Month_STLY = accountSales.Last_Month_STLY + double.valueOf(qLSt.Last_Month_turnover__c)*conversionRate;
 
                 accountSales.AprStQtyLY = accountSales.AprStQtyLY + double.valueOf(qLSt.April_qty__c);
                 accountSales.MayStQtyLY = accountSales.MayStQtyLY + double.valueOf(qLSt.May_qty__c);
                 accountSales.JunStQtyLY = accountSales.JunStQtyLY + double.valueOf(qLSt.June_qty__c);
                 accountSales.JulStQtyLY = accountSales.JulStQtyLY + double.valueOf(qLSt.July_qty__c);
                 accountSales.AugStQtyLY = accountSales.AugStQtyLY + double.valueOf(qLSt.August_qty__c);
                 accountSales.SepStQtyLY = accountSales.SepStQtyLY + double.valueOf(qLSt.September_qty__c);
                 accountSales.AugStQtyLY = accountSales.AugStQtyLY + double.valueOf(qLSt.August_qty__c);
                 accountSales.SepStQtyLY = accountSales.SepStQtyLY + double.valueOf(qLSt.September_qty__c);
                 accountSales.OctStQtyLY = accountSales.OctStQtyLY + double.valueOf(qLSt.October_qty__c);
                 accountSales.NovStQtyLY = accountSales.NovStQtyLY + double.valueOf(qLSt.November_qty__c);
                 accountSales.DecStQtyLY = accountSales.DecStQtyLY + double.valueOf(qLSt.December_qty__c);
                 accountSales.JanStQtyLY = accountSales.JanStQtyLY + double.valueOf(qLSt.January_qty__c);
                 accountSales.FebStQtyLY = accountSales.FebStQtyLY + double.valueOf(qLSt.February_qty__c);
                 accountSales.MarStQtyLY = accountSales.MarStQtyLY + double.valueOf(qLSt.March_qty__c);
                 accountSales.Last_3_Month_STQtyLY = accountSales.Last_3_Month_STQtyLY + double.valueOf(qLSt.Last_3_Months_qty__c);
                 accountSales.Last_Month_STQtyLY = accountSales.Last_Month_STQtyLY + double.valueOf(qLSt.Last_Month_Turnover_Qty__c);
 
             }

             /* ===================================================== */
            
             /*
             * compute credits
             */
             if(originalConversionRate==null || originalConversionRate==0){originalConversionRate=1;}
            AggregateResult[] groupedResults = [SELECT sum(Annual_Sales__c) sumCY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.CurrFY and type__c='C'];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
                credits_CY = double.valueOf(groupedResults[0].get('sumCY'))* originalConversionRate;
            }
            
            groupedResults = [SELECT sum(Annual_Sales__c) sumLY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.PrevFY and type__c='C'];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
                credits_LY = double.valueOf(groupedResults[0].get('sumLY'))* originalConversionRate;
            }
            
            /*
             * compute turnover
             */
            turnover_CY = 0;
            groupedResults = [SELECT sum(Annual_Sales__c) sumCY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.CurrFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE' and RX_or_Stock__c <>'""Other""' and RX_or_Stock__c<>'CONSUMABLES' and RX_or_Stock__c<>'LENS FITTING INCOME'];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
                if(groupedResults[0].get('sumCY')!=null){turnover_CY = double.valueOf(groupedResults[0].get('sumCY'))* originalConversionRate;}
                groupedResults = [SELECT sum(Annual_Sales__c) sumLY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.PrevFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE' and RX_or_Stock__c<>'""Other""' and RX_or_Stock__c<>'CONSUMABLES' and RX_or_Stock__c<>'LENS FITTING INCOME'];
                turnover_LY = 0;
                if(groupedResults[0].get('sumLY')!=null){turnover_LY = double.valueOf(groupedResults[0].get('sumLY'))* originalConversionRate;}
            }
            
            /*
             * compute last 3 month FY N-2
             */             
            accountSales.janSalesN2 = 0;
            accountSales.febSalesN2 = 0;
            accountSales.marSalesN2 = 0;
            accountSales.janQtyN2 = 0;
            accountSales.febQtyN2 = 0;
            accountSales.marQtyN2 = 0;
            System.debug('compute last 3 month FY N-2');
            AggregateResult[] accountQvSales =[SELECT sum(January__c) jan, sum(February__c) feb, sum(March__c) mar
                , sum(January_qty__c) janqty, sum(February_qty__c) febqty, sum(March_qty__c) marqty
                FROM QV_Sales__c
                where Account__c=:AccountSales.account.Id and FY__c=:AccountSales.N2FY];
        
            for(AggregateResult ar : accountQvSales) {
                if(double.valueOf(ar.get('jan'))==null){accountSales.janSalesN2=0;}else{accountSales.janSalesN2=double.valueOf(ar.get('jan'))*conversionRate*AccConversionRateTest;}
                if(double.valueOf(ar.get('feb'))==null){accountSales.febSalesN2=0;}else{accountSales.febSalesN2=double.valueOf(ar.get('feb'))*conversionRate*AccConversionRateTest;}
                if(double.valueOf(ar.get('mar'))==null){accountSales.marSalesN2=0;}else{accountSales.marSalesN2=double.valueOf(ar.get('mar'))*conversionRate*AccConversionRateTest;}
                if(double.valueOf(ar.get('janqty'))==null){accountSales.janQtyN2=0;}else{accountSales.janQtyN2=double.valueOf(ar.get('janqty'));}
                if(double.valueOf(ar.get('febqty'))==null){accountSales.febQtyN2=0;}else{accountSales.febQtyN2=double.valueOf(ar.get('febqty'));}
                if(double.valueOf(ar.get('marqty'))==null){accountSales.marQtyN2=0;}else{accountSales.marQtyN2=double.valueOf(ar.get('marqty'));}
            }
            
            /*
             * compute quantity
             */  
            accountSales.TotalQty = 0;
            accountSales.TotalQtyLY = 0;       
            groupedResults = [SELECT sum(Annual_qty__c) sumCY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.CurrFY];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
                quantity_CY = double.valueOf(groupedResults[0].get('sumCY'));
                accountSales.TotalQty = quantity_CY;
            }
            groupedResults = [SELECT sum(Annual_qty__c) sumLY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.PrevFY];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
                quantity_LY = double.valueOf(groupedResults[0].get('sumLY'));
                accountSales.TotalQtyLY = quantity_LY;
            }
            

            groupedResults = [SELECT sum(Annual_qty__c) sumCY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.CurrFY and type__c='C'];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
                quantity_C_CY = double.valueOf(groupedResults[0].get('sumCY'));
            }
            
            groupedResults = [SELECT sum(Annual_qty__c) sumLY FROM QV_Sales__c where Account__c=:recordId and FY__c=:accountSales.PrevFY and type__c='C'];
            if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
                quantity_C_LY = double.valueOf(groupedResults[0].get('sumLY'));
            }

            //compute fiscal year total sales
            accountSales.TotalSales = accountSales.AprSales+accountSales.MaySales+accountSales.JunSales+accountSales.JulSales+accountSales.AugSales+accountSales.SepSales+accountSales.OctSales+accountSales.NovSales+accountSales.DecSales+accountSales.JanSales+accountSales.FebSales+accountSales.MarSales;
            accountSales.TotalSalesLY = accountSales.AprSalesLY+accountSales.MaySalesLY+accountSales.JunSalesLY+accountSales.JulSalesLY+accountSales.AugSalesLY+accountSales.SepSalesLY+accountSales.OctSalesLY+accountSales.NovSalesLY+accountSales.DecSalesLY+accountSales.JanSalesLY+accountSales.FebSalesLY+accountSales.MarSalesLY;

            //compute TotalQuantityTrend
            accountSales.TotalVsForecast = 0;
            accountSales.AnnualQuantity=getAnnualQuantity(accountSales, Month);
            accountSales.TotalQuantityTrend = 0;
            if(accountSales.TotalQtyLY!=null && accountSales.TotalQtyLY!=0){
                accountSales.TotalQuantityTrend = ((accountSales.AnnualQuantity-accountSales.TotalQtyLY)/accountSales.TotalQtyLY)*100;
            }
            //compute TotalQuantityYTD_VS_LFY
            accountSales.TotalQuantityYTD_LFY = getAnnualQuantityYTD_LFY(accountSales, month);
            accountSales.TotalQuantityYTD_VS_LFY = 0;
            if(accountSales.TotalQuantityYTD_LFY!=null && accountSales.TotalQuantityYTD_LFY!=0){
                accountSales.TotalQuantityYTD_VS_LFY = ((accountSales.TotalQty-accountSales.TotalQuantityYTD_LFY)/accountSales.TotalQuantityYTD_LFY)*100;
            }
            accountSales.QuantityLast3Month = getQuantityLast3Month(accountSales, month);
            accountSales.QuantityLast3MonthLY = getQuantityLast3MonthLY(accountSales, month);

            //compute calendar total sales
            Double N2sales = 0;
            N2sales = accountSales.janSalesN2 + accountSales.febSalesN2 + accountSales.marSalesN2;
            Double N2volume = 0;
            N2volume = accountSales.janQtyN2 + accountSales.febQtyN2 + accountSales.marQtyN2;

            accountSales.TotalCalendarSales = accountSales.JanSalesLY+accountSales.FebSalesLY+accountSales.MarSalesLY+accountSales.AprSales+accountSales.MaySales+accountSales.JunSales+accountSales.JulSales+accountSales.AugSales+accountSales.SepSales+accountSales.OctSales+accountSales.NovSales+accountSales.DecSales;
            accountSales.TotalCalendarQty = accountSales.JanQtyLY+accountSales.FebQtyLY+accountSales.MarQtyLY+accountSales.AprQty+accountSales.MayQty+accountSales.JunQty+accountSales.JulQty+accountSales.AugQty+accountSales.SepQty+accountSales.OctQty+accountSales.NovQty+accountSales.DecQty;
            accountSales.TotalCalendarQtyLY = N2volume+accountSales.AprQtyLY+accountSales.MayQtyLY+accountSales.JunQtyLY+accountSales.JulQtyLY+accountSales.AugQtyLY+accountSales.SepQtyLY+accountSales.OctQtyLY+accountSales.NovQtyLY+accountSales.DecQtyLY;
            accountSales.TotalCalendarSalesLY = N2sales+accountSales.AprSalesLY+accountSales.MaySalesLY+accountSales.JunSalesLY+accountSales.JulSalesLY+accountSales.AugSalesLY+accountSales.SepSalesLY+accountSales.OctSalesLY+accountSales.NovSalesLY+accountSales.DecSalesLY;
            accountSales.TotalTurnoverYTD_LY = getTotalTurnoverYTD_LY(accountSales, Month);
            accountSales.TotalVolumeYTD_LY = getTotalVolumesYTD_LY(accountSales, Month);
            accountSales.TotalTurnoverYTDvsLY = 0;
            accountSales.TotalVolumesYTDvsLY = 0;

            accountSales.TotalSales = accountSales.AprSales+accountSales.MaySales+accountSales.JunSales+accountSales.JulSales+accountSales.AugSales+accountSales.SepSales+accountSales.OctSales+accountSales.NovSales+accountSales.DecSales+accountSales.JanSales+accountSales.FebSales+accountSales.MarSales;
            accountSales.TotalSalesLY = accountSales.AprSalesLY+accountSales.MaySalesLY+accountSales.JunSalesLY+accountSales.JulSalesLY+accountSales.AugSalesLY+accountSales.SepSalesLY+accountSales.OctSalesLY+accountSales.NovSalesLY+accountSales.DecSalesLY+accountSales.JanSalesLY+accountSales.FebSalesLY+accountSales.MarSalesLY;
            accountSales.TotalRxSales = accountSales.AprRxSales+accountSales.MayRxSales+accountSales.JunRxSales+accountSales.JulRxSales+accountSales.AugRxSales+accountSales.SepRxSales+accountSales.OctRxSales+accountSales.NovRxSales+accountSales.DecRxSales+accountSales.JanRxSales+accountSales.FebRxSales+accountSales.MarRxSales;
            accountSales.TotalRxSalesLY = accountSales.AprRxSalesLY+accountSales.MayRxSalesLY+accountSales.JunRxSalesLY+accountSales.JulRxSalesLY+accountSales.AugRxSalesLY+accountSales.SepRxSalesLY+accountSales.OctRxSalesLY+accountSales.NovRxSalesLY+accountSales.DecRxSalesLY+accountSales.JanRxSalesLY+accountSales.FebRxSalesLY+accountSales.MarRxSalesLY;
            accountSales.TotalRxQty = accountSales.AprRxQty+accountSales.MayRxQty+accountSales.JunRxQty+accountSales.JulRxQty+accountSales.AugRxQty+accountSales.SepRxQty+accountSales.OctRxQty+accountSales.NovRxQty+accountSales.DecRxQty+accountSales.JanRxQty+accountSales.FebrxQty+accountSales.MarRxQty;
            accountSales.TotalRxQtyLY = accountSales.AprRxQtyLY+accountSales.MayRxQtyLY+accountSales.JunRxQtyLY+accountSales.JulRxQtyLY+accountSales.AugRxQtyLY+accountSales.SepRxQtyLY+accountSales.OctRxQtyLY+accountSales.NovRxQtyLY+accountSales.DecRxQtyLY+accountSales.JanRxQtyLY+accountSales.FebRxQtyLY+accountSales.MarRxQtyLY;
            accountSales.TotalStSales = accountSales.AprStSales+accountSales.MayStSales+accountSales.JunStSales+accountSales.JulStSales+accountSales.AugStSales+accountSales.SepStSales+accountSales.OctStSales+accountSales.NovStSales+accountSales.DecStSales+accountSales.JanStSales+accountSales.FebStSales+accountSales.MarStSales;
            accountSales.TotalStQty = accountSales.AprStQty+accountSales.MayStQty+accountSales.JunStQty+accountSales.JulStQty+accountSales.AugStQty+accountSales.SepStQty+accountSales.OctStQty+accountSales.NovStQty+accountSales.DecStQty+accountSales.JanStQty+accountSales.FebStQty+accountSales.MarStQty;
            accountSales.TotalStQtyLY = accountSales.AprStQtyLY+accountSales.MayStQtyLY+accountSales.JunStQtyLY+accountSales.JulStQtyLY+accountSales.AugStQtyLY+accountSales.SepStQtyLY+accountSales.OctStQtyLY+accountSales.NovStQtyLY+accountSales.DecStQtyLY+accountSales.JanStQtyLY+accountSales.FebStQtyLY+accountSales.MarStQtyLY;
            
            if(accountSales.TotalTurnoverYTD_LY!=0){accountSales.TotalTurnoverYTDvsLY = ((accountSales.TotalCalendarSales-accountSales.TotalTurnoverYTD_LY)/accountSales.TotalTurnoverYTD_LY)*100;}
            if(accountSales.TotalVolumeYTD_LY!=0){accountSales.TotalVolumesYTDvsLY = ((accountSales.TotalCalendarQty-accountSales.TotalVolumeYTD_LY)/accountSales.TotalVolumeYTD_LY)*100;}

            switch on month {
                when  1{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,12)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,12))*100;}
                when  2{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,1)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,1))*100;}
                when  3{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,2)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,2))*100;}
                when  4{accountSales.TotalVsForecast=0;}
                when  5{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,4)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,4))*100;}
                when  6{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,5)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,5))*100;}
                when  7{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,6)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,6))*100;}
                when  8{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,7)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,7))*100;}
                when  9{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,8)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,8))*100;}
                when  10{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,9)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,9))*100;}
                when  11{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,10)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,10))*100;}
                when  12{accountSales.TotalVsForecast=getFiscalBudgetOfMonth(accountSales.account,11)==0?0:(accountSales.TotalSales/getFiscalBudgetOfMonth(accountSales.account,11))*100;}
                when else {accountSales.TotalVsForecast=0;}
            }

        return accountSales;
    }

    @AuraEnabled
    public static List<QvRelatedAccountSales> getRelatedSalesList(Id recordId, Boolean currentFiscalyear){
            
        List<QvRelatedAccountSales> relatedDataList;
        QvRelatedAccountSales relatedTotalCFY;
        QvRelatedAccountSales relatedTotalQtyCFY;

        try {
             Account me = [select ID, Hoya_Account_ID__c, parentId from account where id=:recordId];
             String userCurrency = UserInfo.getDefaultCurrency();
             String userCompany = [select companyName from User where id=: UserInfo.getUserId()].companyName;
             originalConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
             conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
             String accountCurrency = [select currencyisocode from Account where id=:recordId].currencyIsoCode;
             AccountConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;
             AccConversionRateTest = [SELECT conversionRate FrOM currencytype WHERE isocode =: accountCurrency].conversionRate;
             if(conversionRate==AccountConversionRate){AccountConversionRate=1;}
             if(userCurrency!='EUR' && accountCurrency!='EUR'){AccountConversionRate=1;conversionRate=1;}
             if(userCurrency==accountCurrency)
             {
                 AccountConversionRate=1;
                 AccConversionRateTest=1;
                 conversionRate=1;
             }

             /* search related account sales */
             String title = 'Total CFY';
             if(!currentFiscalyear){title = 'Total LFY';}
             relatedTotalCFY = new QvRelatedAccountSales(title, 'sales', me.Id);
             relatedTotalQtyCFY = new QvRelatedAccountSales(title, 'volume', me.id);
             relatedDataList = new List<QvRelatedAccountSales>();
             Integer year = Date.today().year();
             Integer month = Date.today().month();
             //fiscal year is current year-1 from january to march, year from april to december
             if( (month<5 && !Toolbox.isApac(userCompany)) || (month<4 && Toolbox.isApac(userCompany))){
                 year = year-1;
             }
             String CurrFY = 'FY-' + String.valueOf(year).substring(2);
             String prevFY = 'FY-' + String.valueOf(year-1).substring(2);
             if(currentFiscalyear==false){
                 //want previous fiscal year
                CurrFY = 'FY-' + String.valueOf(year-1).substring(2);
                prevFY = 'FY-' + String.valueOf(year-2).substring(2);
             }

             String parentId =  [select parentId from account where id=:recordId].ParentId;
 

             /* current account */
             //System.debug('XXXX compute child data ');
             AggregateResult[] currQvSales =[SELECT Hoya_Account_id__c, sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
                     , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
                     , sum(January__c) january, sum(February__c) february, sum(March__c) march
                     , sum(April_qty__c) qtyApril, sum(May_qty__c) qtyMay, sum(June_qty__c) qtyJun, sum(July_qty__c) qtyJul, sum(August_qty__c) qtyAug, sum(September_qty__c) qtySep
                     , sum(October_qty__c) qtyOct, sum(November_qty__c) qtyNov, sum(December_qty__c) qtyDec, sum(January_qty__c) qtyJan, sum(February_qty__c) qtyFeb, sum(March_qty__c) qtyMar
                 FROM QV_Sales__c
                 where Account__c =:recordId and FY__c=:CurrFY
                 and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                 and RX_or_Stock__c <>'""Other""' and RX_or_Stock__c<>'CONSUMABLES' and RX_or_Stock__c<>'LENS FITTING INCOME' group by Hoya_Account_id__c order by Hoya_Account_id__c asc];
                 
             System.debug('XXXX compute current account data AggregateResult size =' + currQvSales.size());
             for(AggregateResult ar : currQvSales) {
                    String accountNumber = String.valueOf(ar.get('Hoya_Account_id__c'));
                    QvRelatedAccountSales data = new QvRelatedAccountSales(accountNumber, 'sales', recordId);
                     data.april=double.valueOf(ar.get('april'))*conversionRate*AccConversionRateTest     ; relatedTotalCFY.april=relatedTotalCFY.april+data.april;
                     data.may=double.valueOf(ar.get('may'))*conversionRate*AccConversionRateTest          ; relatedTotalCFY.may=relatedTotalCFY.may+data.may;
                     data.june=double.valueOf(ar.get('june'))*conversionRate*AccConversionRateTest        ; relatedTotalCFY.june=relatedTotalCFY.june+data.june;
                     data.july=double.valueOf(ar.get('july'))*conversionRate*AccConversionRateTest        ; relatedTotalCFY.july=relatedTotalCFY.july+data.july;
                     data.august=double.valueOf(ar.get('august'))*conversionRate*AccConversionRateTest    ; relatedTotalCFY.august=relatedTotalCFY.august+data.august;
                     data.september=double.valueOf(ar.get('september'))*conversionRate*AccConversionRateTest ; relatedTotalCFY.september=relatedTotalCFY.september+data.september;
                     data.october=double.valueOf(ar.get('october'))*conversionRate*AccConversionRateTest  ; relatedTotalCFY.october=relatedTotalCFY.october+data.october;
                     data.november=double.valueOf(ar.get('november'))*conversionRate*AccConversionRateTest; relatedTotalCFY.november=relatedTotalCFY.november+data.november;
                     data.december=double.valueOf(ar.get('december'))*conversionRate*AccConversionRateTest; relatedTotalCFY.december=relatedTotalCFY.december+data.december;
                     data.january=double.valueOf(ar.get('january'))*conversionRate*AccConversionRateTest  ; relatedTotalCFY.january=relatedTotalCFY.january+data.january;
                     data.february=double.valueOf(ar.get('february'))*conversionRate*AccConversionRateTest; relatedTotalCFY.february=relatedTotalCFY.february+data.february;
                     data.march=double.valueOf(ar.get('march'))*conversionRate*AccConversionRateTest     ; relatedTotalCFY.march=relatedTotalCFY.march+data.march;
                     data.salesYTD = getQvSalesYTD(data, month)                     ; relatedTotalCFY.salesYTD = getQvSalesYTD(relatedTotalCFY, month);
                     relatedDataList.add(data);
                     System.debug('[PARSE ACCOUNT] ' + data.hoya_account_id + ' - ' + data.type);

                     //qty
                     
                    QvRelatedAccountSales dataQty = new QvRelatedAccountSales(accountNumber, 'volume', recordId);
                    dataQty.april=double.valueOf(ar.get('qtyApril'))    ; relatedTotalQtyCFY.april=relatedTotalQtyCFY.april+dataQty.april;
                    dataQty.may=double.valueOf(ar.get('qtyMay'))        ; relatedTotalQtyCFY.may=relatedTotalQtyCFY.may+dataQty.may;
                    dataQty.june=double.valueOf(ar.get('qtyJun'))       ; relatedTotalQtyCFY.june=relatedTotalQtyCFY.june+dataQty.june;
                    dataQty.july=double.valueOf(ar.get('qtyJul'))       ; relatedTotalQtyCFY.july=relatedTotalQtyCFY.july+dataQty.july;
                    dataQty.august=double.valueOf(ar.get('qtyAug'))     ; relatedTotalQtyCFY.august=relatedTotalQtyCFY.august+dataQty.august;
                    dataQty.september=double.valueOf(ar.get('qtySep'))  ; relatedTotalQtyCFY.september =relatedTotalQtyCFY.september+dataQty.september;
                    dataQty.october=double.valueOf(ar.get('qtyOct'))    ; relatedTotalQtyCFY.october=relatedTotalQtyCFY.october+dataQty.october;
                    dataQty.november=double.valueOf(ar.get('qtyNov'))   ; relatedTotalQtyCFY.november=relatedTotalQtyCFY.november+dataQty.november;
                    dataQty.december=double.valueOf(ar.get('qtyDec'))   ; relatedTotalQtyCFY.december=relatedTotalQtyCFY.december+dataQty.december;
                    dataQty.january=double.valueOf(ar.get('qtyJan'))    ; relatedTotalQtyCFY.january=relatedTotalQtyCFY.january+dataQty.january;
                    dataQty.february=double.valueOf(ar.get('qtyFeb'))   ; relatedTotalQtyCFY.february=relatedTotalQtyCFY.february+dataQty.february;
                    dataQty.march=double.valueOf(ar.get('qtyMar'))      ; relatedTotalQtyCFY.march=relatedTotalQtyCFY.march+dataQty.march;
                    dataQty.salesYTD = getQvSalesYTD(dataQty, month)    ; relatedTotalQtyCFY.salesYTD = getQvSalesYTD(relatedTotalQtyCFY, month);
                    relatedDataList.add(dataQty);
             }

             /* Childrens of current account */
             //System.debug('XXXX compute child data ');
             AggregateResult[] relatedQvSales =[SELECT Account__c, Hoya_Account_id__c, sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
                     , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
                     , sum(January__c) january, sum(February__c) february, sum(March__c) march
                     , sum(April_qty__c) qtyApril, sum(May_qty__c) qtyMay, sum(June_qty__c) qtyJun, sum(July_qty__c) qtyJul, sum(August_qty__c) qtyAug, sum(September_qty__c) qtySep
                     , sum(October_qty__c) qtyOct, sum(November_qty__c) qtyNov, sum(December_qty__c) qtyDec, sum(January_qty__c) qtyJan, sum(February_qty__c) qtyFeb, sum(March_qty__c) qtyMar
                 FROM QV_Sales__c
                 where Account__c in (select id from account where parentid=:recordId) and FY__c=:CurrFY
                 and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                 and RX_or_Stock__c<> '""Other""' and RX_or_Stock__c<>'CONSUMABLES' and RX_or_Stock__c<>'LENS FITTING INCOME' group by Account__c, Hoya_Account_id__c order by Hoya_Account_id__c asc];
                 
             System.debug('XXXX compute child data AggregateResult size =' + relatedQvSales.size());
             for(AggregateResult ar : relatedQvSales) {
                    String accountNumber = String.valueOf(ar.get('Hoya_Account_id__c'));
                    QvRelatedAccountSales data = new QvRelatedAccountSales(accountNumber, 'sales', String.valueOf(ar.get('Account__c')));
                     data.april=double.valueOf(ar.get('april'))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.april=relatedTotalCFY.april+data.april;
                     data.may=double.valueOf(ar.get('may'))*conversionRate*AccConversionRateTest          ; relatedTotalCFY.may=relatedTotalCFY.may+data.may;
                     data.june=double.valueOf(ar.get('june'))*conversionRate*AccConversionRateTest        ; relatedTotalCFY.june=relatedTotalCFY.june+data.june;
                     data.july=double.valueOf(ar.get('july'))*conversionRate*AccConversionRateTest        ; relatedTotalCFY.july=relatedTotalCFY.july+data.july;
                     data.august=double.valueOf(ar.get('august'))*conversionRate*AccConversionRateTest    ; relatedTotalCFY.august=relatedTotalCFY.august+data.august;
                     data.september=double.valueOf(ar.get('september'))*conversionRate*AccConversionRateTest; relatedTotalCFY.september=relatedTotalCFY.september+data.september;
                     data.october=double.valueOf(ar.get('october'))*conversionRate*AccConversionRateTest  ; relatedTotalCFY.october=relatedTotalCFY.october+data.october;
                     data.november=double.valueOf(ar.get('november'))*conversionRate*AccConversionRateTest; relatedTotalCFY.november=relatedTotalCFY.november+data.november;
                     data.december=double.valueOf(ar.get('december'))*conversionRate*AccConversionRateTest; relatedTotalCFY.december=relatedTotalCFY.december+data.december;
                     data.january=double.valueOf(ar.get('january'))*conversionRate*AccConversionRateTest  ; relatedTotalCFY.january=relatedTotalCFY.january+data.january;
                     data.february=double.valueOf(ar.get('february'))*conversionRate*AccConversionRateTest; relatedTotalCFY.february=relatedTotalCFY.february+data.february;
                     data.march=double.valueOf(ar.get('march'))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.march=relatedTotalCFY.march+data.march;
                     data.salesYTD = getQvSalesYTD(data, month)                     ; relatedTotalCFY.salesYTD = getQvSalesYTD(relatedTotalCFY, month);
                     relatedDataList.add(data); 
                     
                     System.debug('[PARSE CHILD] ' + data.hoya_account_id + ' - ' + data.type);
                     //qty
                     
                     QvRelatedAccountSales dataQty = new QvRelatedAccountSales(accountNumber, 'volume', String.valueOf(ar.get('Account__c')));
                     dataQty.april=double.valueOf(ar.get('qtyApril')); relatedTotalQtyCFY.april=relatedTotalQtyCFY.april+dataQty.april;
                     dataQty.may=double.valueOf(ar.get('qtyMay')); relatedTotalQtyCFY.may=relatedTotalQtyCFY.may+dataQty.may;
                     dataQty.june=double.valueOf(ar.get('qtyJun')); relatedTotalQtyCFY.june=relatedTotalQtyCFY.june+dataQty.june;
                     dataQty.july=double.valueOf(ar.get('qtyJul')); relatedTotalQtyCFY.july=relatedTotalQtyCFY.july+dataQty.july;
                     dataQty.august=double.valueOf(ar.get('qtyAug')); relatedTotalQtyCFY.august=relatedTotalQtyCFY.august+dataQty.august;
                     dataQty.september=double.valueOf(ar.get('qtySep')); relatedTotalQtyCFY.september=relatedTotalQtyCFY.september+dataQty.september;
                     dataQty.october=double.valueOf(ar.get('qtyOct')); relatedTotalQtyCFY.october=relatedTotalQtyCFY.october+dataQty.october;
                     dataQty.november=double.valueOf(ar.get('qtyNov')); relatedTotalQtyCFY.november=relatedTotalQtyCFY.november+dataQty.november;
                     dataQty.december=double.valueOf(ar.get('qtyDec')); relatedTotalQtyCFY.december=relatedTotalQtyCFY.december+dataQty.december;
                     dataQty.january=double.valueOf(ar.get('qtyJan')); relatedTotalQtyCFY.january=relatedTotalQtyCFY.january+dataQty.january;
                     dataQty.february=double.valueOf(ar.get('qtyFeb')); relatedTotalQtyCFY.february=relatedTotalQtyCFY.february+dataQty.february;
                     dataQty.march=double.valueOf(ar.get('qtyMar')); relatedTotalQtyCFY.march=relatedTotalQtyCFY.march+dataQty.march;
                     dataQty.salesYTD = getQvSalesYTD(dataQty, month);relatedTotalQtyCFY.salesYTD = getQvSalesYTD(relatedTotalQtyCFY, month);
                     relatedDataList.add(dataQty);
             }
             /* Brothers of current account */
             if(parentId!=null){
                 System.debug('XXXX compute Brothers data ');
                List<Account> idList = [select id from account where parentid=:parentId or id=:parentId];
                Set<Id> ids = new Set<Id>(new Map<Id, Account>(idList).keySet());
                 AggregateResult[] relatedQvSales2 =[SELECT Account__c, Hoya_Account_id__c, sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
                         , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
                         , sum(January__c) january, sum(February__c) february, sum(March__c) march
                         , sum(April_qty__c) qtyApril, sum(May_qty__c) qtyMay, sum(June_qty__c) qtyJun, sum(July_qty__c) qtyJul, sum(August_qty__c) qtyAug, sum(September_qty__c) qtySep
                         , sum(October_qty__c) qtyOct, sum(November_qty__c) qtyNov, sum(December_qty__c) qtyDec, sum(January_qty__c) qtyJan, sum(February_qty__c) qtyFeb, sum(March_qty__c) qtyMar
                     FROM QV_Sales__c
                     where Account__c in :ids and Account__c!=:recordId and FY__c=:CurrFY
                     and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                     and RX_or_Stock__c<>'""Other""' and RX_or_Stock__c<>'CONSUMABLES' and RX_or_Stock__c<>'LENS FITTING INCOME' group by Account__c, Hoya_Account_id__c order by Hoya_Account_id__c asc];
                     System.debug('XXXX compute Brothers data AggregateResult size =' + relatedQvSales.size());
                 for(AggregateResult ar : relatedQvSales2) {
                        String accountNumber = String.valueOf(ar.get('Hoya_Account_id__c'));
                        QvRelatedAccountSales data = new QvRelatedAccountSales(accountNumber, 'sales', String.valueOf(ar.get('Account__c')));
                         data.april=double.valueOf(ar.get('april'))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.april=relatedTotalCFY.april+data.april;
                         data.may = (double.valueOf(ar.get('may')))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.may=relatedTotalCFY.may+data.may;
                         data.june=(double.valueOf(ar.get('june')))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.june=relatedTotalCFY.june+data.june;
                         data.july=(double.valueOf(ar.get('july')))*conversionRate*AccConversionRateTest      ; relatedTotalCFY.July=relatedTotalCFY.july+data.july;
                         data.august=(double.valueOf(ar.get('august')))*conversionRate*AccConversionRateTest  ; relatedTotalCFY.August=relatedTotalCFY.august+data.august;
                         data.september=(double.valueOf(ar.get('september')))*conversionRate*AccConversionRateTest; relatedTotalCFY.september=relatedTotalCFY.september+data.september;
                         data.october=(double.valueOf(ar.get('october')))*conversionRate*AccConversionRateTest; relatedTotalCFY.october=relatedTotalCFY.october+data.october;
                         data.november=(double.valueOf(ar.get('november')))*conversionRate*AccConversionRateTest; relatedTotalCFY.november=relatedTotalCFY.november+data.november;
                         data.december=(double.valueOf(ar.get('december')))*conversionRate*AccConversionRateTest; relatedTotalCFY.december=relatedTotalCFY.december+data.december;
                         data.january=(double.valueOf(ar.get('january')))*conversionRate*AccConversionRateTest; relatedTotalCFY.january=relatedTotalCFY.january+data.january;
                         data.february=(double.valueOf(ar.get('february')))*conversionRate*AccConversionRateTest; relatedTotalCFY.february=relatedTotalCFY.february+data.february;
                         data.march=(double.valueOf(ar.get('march')))*conversionRate*AccConversionRateTest    ; relatedTotalCFY.march=relatedTotalCFY.march+data.march;
                         data.salesYTD = getQvSalesYTD(data, month)                     ; relatedTotalCFY.salesYTD = getQvSalesYTD(relatedTotalCFY, month);
                         relatedDataList.add(data);
                         System.debug('[PARSE BROTHER] ' + data.hoya_account_id + ' - ' + data.type);
                         //qty
                         QvRelatedAccountSales dataQty = new QvRelatedAccountSales(accountNumber, 'volume', String.valueOf(ar.get('Account__c')));
                         dataQty.april=double.valueOf(ar.get('qtyApril')); relatedTotalQtyCFY.april=relatedTotalQtyCFY.april+dataQty.april;
                         dataQty.may=double.valueOf(ar.get('qtyMay')); relatedTotalQtyCFY.may=relatedTotalQtyCFY.may+dataQty.may;
                         dataQty.june=double.valueOf(ar.get('qtyJun')); relatedTotalQtyCFY.june=relatedTotalQtyCFY.june+dataQty.june;
                         dataQty.july=double.valueOf(ar.get('qtyJul')); relatedTotalQtyCFY.july=relatedTotalQtyCFY.july+dataQty.july;
                         dataQty.august=double.valueOf(ar.get('qtyAug')); relatedTotalQtyCFY.august=relatedTotalQtyCFY.august+dataQty.august;
                         dataQty.september=double.valueOf(ar.get('qtySep')); relatedTotalQtyCFY.september=relatedTotalQtyCFY.september+dataQty.september;
                         dataQty.october=double.valueOf(ar.get('qtyOct')); relatedTotalQtyCFY.october=relatedTotalQtyCFY.october+dataQty.october;
                         dataQty.november=double.valueOf(ar.get('qtyNov')); relatedTotalQtyCFY.november=relatedTotalQtyCFY.november+dataQty.november;
                         dataQty.december=double.valueOf(ar.get('qtyDec')); relatedTotalQtyCFY.december=relatedTotalQtyCFY.december+dataQty.december;
                         dataQty.january=double.valueOf(ar.get('qtyJan')); relatedTotalQtyCFY.january=relatedTotalQtyCFY.january+dataQty.january;
                         dataQty.february=double.valueOf(ar.get('qtyFeb')); relatedTotalQtyCFY.february=relatedTotalQtyCFY.february+dataQty.february;
                         dataQty.march=double.valueOf(ar.get('qtyMar')); relatedTotalQtyCFY.march=relatedTotalQtyCFY.march+dataQty.march;
                         dataQty.salesYTD = getQvSalesYTD(dataQty, month);relatedTotalQtyCFY.salesYTD = getQvSalesYTD(relatedTotalQtyCFY, month);
                         relatedDataList.add(dataQty);
                 }
             }
             relatedDataList.add(relatedTotalCFY);
             relatedDataList.add(relatedTotalQtyCFY);
 
             /* Childrens of current account */
             System.debug('XXXX compute child data ');
            List<Account> relatedId = [select id from account where parentid=:recordId];
            Set<Id> ids = new Set<Id>(new Map<Id, Account>(relatedId).keySet());
             AggregateResult[] relatedQvSalesLY =[SELECT sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
                     , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
                     , sum(January__c) january, sum(February__c) february, sum(March__c) march
                     , sum(April_qty__c) qtyApril, sum(May_qty__c) qtyMay, sum(June_qty__c) qtyJun, sum(July_qty__c) qtyJul, sum(August_qty__c) qtyAug, sum(September_qty__c) qtySep
                     , sum(October_qty__c) qtyOct, sum(November_qty__c) qtyNov, sum(December_qty__c) qtyDec, sum(January_qty__c) qtyJan, sum(February_qty__c) qtyFeb, sum(March_qty__c) qtyMar
                 FROM QV_Sales__c
                 where (Account__c in :ids or Account__c=:recordId or Account__c=:me.ParentId) and FY__c=:prevFY
                 and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                 and RX_or_Stock__c<>'""Other""' and RX_or_Stock__c<>'CONSUMABLES'and RX_or_Stock__c<>'LENS FITTING INCOME'];
                 
            /* System.debug('XXXX compute child data AggregateResult size =' + relatedQvSales.size());
            
             QvRelatedAccountSales totalLY= new QvRelatedAccountSales('Total LFY', 'sales', recordId);
             QvRelatedAccountSales totalQtyLY= new QvRelatedAccountSales('Total LFY', 'volume', recordId);
             for(AggregateResult ar : relatedQvSalesLY) {
                     totalLY.april=double.valueOf(ar.get('april'))*conversionRate; 
                     totalLY.may=double.valueOf(ar.get('may'))*conversionRate; 
                     totalLY.june=double.valueOf(ar.get('june'))*conversionRate;
                     totalLY.july=double.valueOf(ar.get('july'))*conversionRate;
                     totalLY.august=double.valueOf(ar.get('august'))*conversionRate;
                     totalLY.september=double.valueOf(ar.get('september'))*conversionRate; 
                     totalLY.october=double.valueOf(ar.get('october'))*conversionRate; 
                     totalLY.november=double.valueOf(ar.get('november'))*conversionRate; 
                     totalLY.december=double.valueOf(ar.get('december'))*conversionRate; 
                     totalLY.january=double.valueOf(ar.get('january'))*conversionRate; 
                     totalLY.february=double.valueOf(ar.get('february'))*conversionRate;
                     totalLY.march=double.valueOf(ar.get('march'))*conversionRate; 
                     relatedDataList.add(totalLY);
                     totalQtyLY.april=double.valueOf(ar.get('qtyApril')); 
                     totalQtyLY.may=double.valueOf(ar.get('qtyMay')); 
                     totalQtyLY.june=double.valueOf(ar.get('qtyJun'));
                     totalQtyLY.july=double.valueOf(ar.get('qtyJul'));
                     totalQtyLY.august=double.valueOf(ar.get('qtyAug'));
                     totalQtyLY.september=double.valueOf(ar.get('qtySep')); 
                     totalQtyLY.october=double.valueOf(ar.get('qtyOct')); 
                     totalQtyLY.november=double.valueOf(ar.get('qtyNov')); 
                     totalQtyLY.december=double.valueOf(ar.get('qtyDec')); 
                     totalQtyLY.january=double.valueOf(ar.get('qtyJan')); 
                     totalQtyLY.february=double.valueOf(ar.get('qtyFeb'));
                     totalQtyLY.march=double.valueOf(ar.get('qtyMar')); 
                     relatedDataList.add(totalQtyLY);
             }
             QvRelatedAccountSales totalCYvsLY = new QvRelatedAccountSales('CFY vs LFY', 'sales', recordId);
             totalCYvsLY.april=totalLY.april==0?0:(relatedTotalCFY.april-totalLY.april)*100/totalLY.april;
             totalCYvsLY.may=totalLY.may==0?0:(relatedTotalCFY.may-totalLY.may)*100/totalLY.may;
             totalCYvsLY.june=totalLY.june==0?0:(relatedTotalCFY.june-totalLY.june)*100/totalLY.june;
             totalCYvsLY.july=totalLY.july==0?0:(relatedTotalCFY.july-totalLY.july)*100/totalLY.july;
             totalCYvsLY.august=totalLY.august==0?0:(relatedTotalCFY.august-totalLY.august)*100/totalLY.august;
             totalCYvsLY.september=totalLY.september==0?0:(relatedTotalCFY.september-totalLY.september)*100/totalLY.september;
             totalCYvsLY.october=totalLY.october==0?0:(relatedTotalCFY.october-totalLY.october)*100/totalLY.october;
             totalCYvsLY.november=totalLY.november==0?0:(relatedTotalCFY.november-totalLY.november)*100/totalLY.november;
             totalCYvsLY.december=totalLY.december==0?0:(relatedTotalCFY.december-totalLY.december)*100/totalLY.december;
             totalCYvsLY.january=totalLY.january==0?0:(relatedTotalCFY.january-totalLY.january)*100/totalLY.january;
             totalCYvsLY.february=totalLY.february==0?0:(relatedTotalCFY.february-totalLY.february)*100/totalLY.february;
             totalCYvsLY.march=totalLY.march==0?0:(relatedTotalCFY.march-totalLY.march)*100/totalLY.march;
             relatedDataList.add(totalCYvsLY);

             QvRelatedAccountSales totalQty_CYvsLY = new QvRelatedAccountSales('CFY vs LFY', 'volume', recordId);
             totalQty_CYvsLY.april=totalQtyLY.april==0?0:(relatedTotalQtyCFY.april-totalQtyLY.april)*100/totalQtyLY.april;
             totalQty_CYvsLY.may=totalQtyLY.may==0?0:(relatedTotalQtyCFY.may-totalQtyLY.may)*100/totalQtyLY.may;
             totalQty_CYvsLY.june=totalQtyLY.june==0?0:(relatedTotalQtyCFY.june-totalQtyLY.june)*100/totalQtyLY.june;
             totalQty_CYvsLY.july=totalQtyLY.july==0?0:(relatedTotalQtyCFY.july-totalQtyLY.july)*100/totalQtyLY.july;
             totalQty_CYvsLY.august=totalQtyLY.august==0?0:(relatedTotalQtyCFY.august-totalQtyLY.august)*100/totalQtyLY.august;
             totalQty_CYvsLY.september=totalQtyLY.september==0?0:(relatedTotalQtyCFY.september-totalQtyLY.september)*100/totalQtyLY.september;
             totalQty_CYvsLY.october=totalQtyLY.october==0?0:(relatedTotalQtyCFY.october-totalQtyLY.october)*100/totalQtyLY.october;
             totalQty_CYvsLY.november=totalQtyLY.november==0?0:(relatedTotalQtyCFY.november-totalQtyLY.november)*100/totalQtyLY.november;
             totalQty_CYvsLY.december=totalQtyLY.december==0?0:(relatedTotalQtyCFY.december-totalQtyLY.december)*100/totalQtyLY.december;
             totalQty_CYvsLY.january=totalQtyLY.january==0?0:(relatedTotalQtyCFY.january-totalQtyLY.january)*100/totalQtyLY.january;
             totalQty_CYvsLY.february=totalQtyLY.february==0?0:(relatedTotalQtyCFY.february-totalQtyLY.february)*100/totalQtyLY.february;
             totalQty_CYvsLY.march=totalQtyLY.march==0?0:(relatedTotalQtyCFY.march-totalQtyLY.march)*100/totalQtyLY.march;
             relatedDataList.add(totalQty_CYvsLY);*/
             /* end related accounts */
 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return relatedDataList;
    }

    public static Double getQvSalesYTD(QvRelatedAccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.april+a.may+a.june+a.july+a.august+a.september+a.october+a.november+a.december;}
                when  2{result = a.april+a.may+a.june+a.july+a.august+a.september+a.october+a.november+a.december+a.january;}
                when  3{result = a.april+a.may+a.june+a.july+a.august+a.september+a.october+a.november+a.december+a.january+a.february;}
                when  4{result = 0;}
                when  5{result = a.april;}
                when  6{result = a.april+a.may;}
                when  7{result = a.april+a.may+a.june;}
                when  8{result = a.april+a.may+a.june+a.july;}
                when  9{result = a.april+a.may+a.june+a.july+a.august;}
                when  10{result = a.april+a.may+a.june+a.july+a.august+a.september;}
                when  11{result = a.april+a.may+a.june+a.july+a.august+a.september+a.october;}
                when  12{result = a.april+a.may+a.june+a.july+a.august+a.september+a.october+a.november;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on getQvSalesYTD');
        }
        return result;
    }

    public static Double getFiscalBudgetOfMonth(Account a, Integer Month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c+a.Budget_November_Current_Year__c+a.Budget_December_Current_Year__c+a.Budget_January_Current_Year__c;}
                when  2{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c+a.Budget_November_Current_Year__c+a.Budget_December_Current_Year__c+a.Budget_January_Current_Year__c+a.Budget_February_Current_Year__c;}
                when  3{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c+a.Budget_November_Current_Year__c+a.Budget_December_Current_Year__c+a.Budget_January_Current_Year__c+a.Budget_February_Current_Year__c+a.Budget_March_Current_Year__c;}
                when  4{result = a.Budget_April_Current_Year__c;}
                when  5{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c;}
                when  6{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c;}
                when  7{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c;}
                when  8{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c;}
                when  9{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c;}
                when  10{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c;}
                when  11{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c+a.Budget_November_Current_Year__c;}
                when  12{result = a.Budget_April_Current_Year__c+a.Budget_May_Current_Year__c+a.Budget_June_Current_Year__c+a.Budget_July_Current_Year__c+a.Budget_August_Current_Year__c+a.Budget_September_Current_Year__c+a.Budget_October_Current_Year__c+a.Budget_November_Current_Year__c+a.Budget_December_Current_Year__c;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access');
        }
        return result;
    }
    
    public static Double getAnnualQuantity(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty+a.OctQty+a.NovQty+a.DecQty;}
                when  2{result = a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty+a.OctQty+a.NovQty+a.DecQty+a.JanQty;}
                when  3{result = a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty+a.OctQty+a.NovQty+a.DecQty+a.JanQty+a.FebQty;}
                when  4{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY;}
                when  5{result = a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty;}
                when  6{result = a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty;}
                when  7{result = a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty;}
                when  8{result = a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty;}
                when  9{result = a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty;}
                when  10{result = a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty;}
                when  11{result = a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty+a.OctQty;}
                when  12{result = a.DecQtyLY+a.JanQtyLY+a.FebQtyLY+a.MarQtyLY+a.AprQty+a.MayQty+a.JunQty+a.JulQty+a.AugQty+a.SepQty+a.OctQty+a.NovQty;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access');
        }
        return result;
    }
    
    public static Double getAnnualQuantityYTD_LFY(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY;}
                when  2{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY;}
                when  3{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY+a.DecQtyLY+a.JanQtyLY+a.FebQtyLY;}
                when  4{result = 0;}
                when  5{result = a.AprQtyLY;}
                when  6{result = a.AprQtyLY+a.MayQtyLY;}
                when  7{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY;}
                when  8{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY;}
                when  9{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY;}
                when  10{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY;}
                when  11{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY;}
                when  12{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access');
        }
        return result;
    }


    public static Double getTotalTurnoverYTD_LY(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = 0;}
                when  2{result = a.janSalesN2;}
                when  3{result = a.janSalesN2+a.febSalesN2;}
                when  4{result = a.janSalesN2+a.febSalesN2+a.marSalesN2;}
                when  5{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY;}
                when  6{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY;}
                when  7{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY;}
                when  8{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY+a.JulSalesLY;}
                when  9{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY+a.JulSalesLY+a.AugSalesLY;}
                when  10{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY+a.JulSalesLY+a.AugSalesLY+a.SepSalesLY;}
                when  11{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY+a.JulSalesLY+a.AugSalesLY+a.SepSalesLY+a.OctSalesLY;}
                when  12{result = a.janSalesN2+a.febSalesN2+a.marSalesN2+a.AprSalesLY+a.MaySalesLY+a.JunSalesLY+a.JulSalesLY+a.AugSalesLY+a.SepSalesLY+a.OctSalesLY+a.NovSalesLY;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access(getTotalTurnoverYTD_LY)');
        }
        return result;
    }

    public static Double getTotalVolumesYTD_LY(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = 0;}
                when  2{result = a.janQtyN2;}
                when  3{result = a.janQtyN2+a.febQtyN2;}
                when  4{result = a.janQtyN2+a.febQtyN2+a.marQtyN2;}
                when  5{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY;}
                when  6{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY;}
                when  7{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY;}
                when  8{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY;}
                when  9{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY;}
                when  10{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY;}
                when  11{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY;}
                when  12{result = a.janQtyN2+a.febQtyN2+a.marQtyN2+a.AprQtyLY+a.MayQtyLY+a.JunQtyLY+a.JulQtyLY+a.AugQtyLY+a.SepQtyLY+a.OctQtyLY+a.NovQtyLY;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access(getTotalVolumesYTD_LY)');
        }
        return result;
    }
    public static Double getQuantityLast3Month(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.OctQty+a.NovQty+a.DecQty;}
                when  2{result = a.NovQty+a.DecQty+a.JanQty;}
                when  3{result = a.DecQty+a.JanQty+a.FebQty;}
                when  4{result = a.JanQtyLY+a.FebQtyLY+a.MarQtyLY;}
                when  5{result = a.FebQtyLY+a.MarQtyLY+a.AprQty;}
                when  6{result = a.MarQtyLY+a.AprQty+a.MayQty;}
                when  7{result = a.AprQty+a.MayQty+a.JunQty;}
                when  8{result = a.MayQty+a.JunQty+a.JulQty;}
                when  9{result = a.JunQty+a.JulQty+a.AugQty;}
                when  10{result = a.JulQty+a.AugQty+a.SepQty;}
                when  11{result = a.AugQty+a.SepQty+a.OctQty;}
                when  12{result = a.SepQty+a.OctQty+a.NovQty;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access');
        }
        return result;
    }

    
    public static Double getQuantityLast3MonthLY(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.OctQtyLY+a.NovQtyLY+a.DecQtyLY;}
                when  2{result = a.NovQtyLY+a.DecQtyLY+a.JanQtyLY;}
                when  3{result = a.DecQtyLY+a.JanQtyLY+a.FebQtyLY;}
                when  4{result = a.janQtyN2+a.febQtyN2+a.marQtyN2;}
                when  5{result = a.febQtyN2+a.marQtyN2+a.AprQtyLY;}
                when  6{result = a.marQtyN2+a.AprQtyLY+a.MayQtyLY;}
                when  7{result = a.AprQtyLY+a.MayQtyLY+a.JunQtyLY;}
                when  8{result = a.MayQtyLY+a.JunQtyLY+a.JulQtyLY;}
                when  9{result = a.JunQtyLY+a.JulQtyLY+a.AugQtyLY;}
                when  10{result = a.JulQtyLY+a.AugQtyLY+a.SepQtyLY;}
                when  11{result = a.AugQtyLY+a.SepQtyLY+a.OctQtyLY;}
                when  12{result = a.SepQtyLY+a.OctQtyLY+a.NovQtyLY;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            System.debug('XXX error on budget access');
        }
        return result;
    }

    @AuraEnabled
    public static String getLastMediaUsage(Id accountId, String tool){
        String result = 'No data';
        System.debug('XXX query on ' + accountId + ', tool =' + tool);
        try {
            List<New_Media_Usage__c> nmuList = [SELECT Id,Name,Quantity__c,Relates_to_Account_del__c,Tool__c,Transaction_date_field__c,Transaction_Date__c
                                            FROM New_Media_Usage__c
                                            WHERE Hoya_Account_ID__c =: accountId AND Tool__c =: tool ORDER BY Transaction_date_field__c DESC NULLS LAST LIMIT 1];
            System.debug('XXX nmuList size=' + nmuList.size());
            if(nmuList!=null && nmuList.size()>0){
                New_Media_Usage__c nmu = nmuList.get(0);
                result = nmu.Transaction_date_field__c.format() + ' (' + nmu.Quantity__c + ')';
                System.debug('XXX result = ' + result);
            }                                
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static List<AccountContactRelation> getContactList(Id accountId){
        try {

            List<RecordType> recordTypeIds = [select Id from RecordType where sObjectType='Contact' and developerName in ('Opthalmologist')];

            List<AccountContactRelation> contactList = [select id, Contact.Title, Roles, ContactId, contact.name, contact.Contact_Record_Type__c, isdirect
            ,Contact.Account.Name, Contact.Account.shippingCity, Contact.Account.ShippingPostalCode,Contact.Education__c, Contact.Salutation
            from AccountContactRelation where accountID =:accountId and Contact.RecordTypeId in :recordTypeIds];
        
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteRelationShip(Id recordId){
        try {
            AccountContactRelation record = [select id from AccountContactRelation where id=:recordId];
            delete record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AccountContactRelation> getAccountsLinkedToContact(Id accountId){
        try {
            //account id is Clinic
            // 1 list all contact ophta
            List<Id> contactIds = new List<Id>();
            for(Contact c : [select id from contact where AccountId=:accountId]){
                contactIds.add(c.Id);
            }
            //for each get accoult list linked by AccountContactRelation
            List<AccountContactRelation> acList = [select contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                from AccountContactRelation where contactId =:contactIds and isdirect=false and Account.RecordType.Name != 'Clinic' ];
            return acList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<AccountContactRelation> getAccountsLinkedToContactbyContactId(Id contactId){
        try {
            //contact id is Ophta
            //for each get accoult list linked by AccountContactRelation
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                from AccountContactRelation where contactId =:contactId and isdirect=false AND Account.RecordType.Name != 'Clinic' ];
            return acList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<AccountContactRelation> getRelatedClinicsByContactId(Id contactId){
        try {
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                from AccountContactRelation where contactId =:contactId and isdirect=false and Account.RecordType.Name='Clinic' ];
            return acList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void updateOpeningTimes(Id accountId, String jsonStr){
        try {
            Account a = new Account();
            a.Id = accountId;
            a.Opening_times__c = jsonStr;
            update a;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string getOpeningTimes(Id accountId){
        try {
            String openingTime = [select Id, opening_times__c from account where id=:accountId].Opening_times__c;
            return openingTime;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
/*
    public class LinkedAccount{
        public String contactName;
        public String contactId;
        public String accountName;
        public String accountId;
        public String accountBrand;
        public String street;
        public String postalCode;
        public String city;
        public String seikoNetwork;
        public LinkedAccount(){}
        public LinkedAccount(String contactName,String contactId,String accountName,String accountId,String accountBrand,String street,String postalCode,String city,String seikoNetwork){
            this.contactName = contactName;
            this.contactId = contactId;
            this.accountName = accountName;
            this.accountId = accountId;
            this.accountBrand = accountBrand;
            this.street = street;
            this.postalCode = postalCode;
            this.city = city;
            this.seikoNetwork = seikoNetwork;
        }
    }*/

    public Double getCredits_CY(){return credits_CY;}
    public Double getCredits_LY(){return credits_LY;}
    public Double getTurnover_CY(){return turnover_CY;}
    public Double getTurnover_LY(){return turnover_LY;}
    public Double getQuantity_CY(){return quantity_CY;}
    public Double getQuantity_LY(){return quantity_LY;}
    public Double getQuantity_C_CY(){return quantity_C_CY;}
    public Double getQuantity_C_LY(){return quantity_C_LY;}
    
    public Double getConversionRate(){return conversionRate;}
    public Double getOriginalConversionRate(){return originalConversionRate;}
    public Double getAccountConversionRate(){return AccountConversionRate;}

}