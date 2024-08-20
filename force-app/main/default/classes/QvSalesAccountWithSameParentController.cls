public class QvSalesAccountWithSameParentController{

    public class QvAccountData implements Comparable{
        public QvAccountData(String accountNumber){
            hoya_account_id = accountNumber;
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
        
        public String hoya_account_id{get; set;}
        public double april{get; set;}
        public double may{get; set;}
        public double june{get; set;}
        public double july{get; set;}
        public double august{get; set;}
        public double september{get; set;}
        public double october{get; set;}
        public double november{get; set;}
        public double december{get; set;}
        public double january{get; set;}
        public double february{get; set;}
        public double march{get; set;}
        
        //Last year variables
        public double aprilLY{get;set;}
        public double mayLY{get;set;}
        public double juneLY{get;set;}
        public double julyLY{get;set;}
        public double augustLY{get;set;}
        public double septemberLY{get;set;}
        public double octoberLY{get;set;}
        public double novemberLY{get;set;}
        public double decemberLY{get;set;}
        public double januaryLY{get;set;}
        public double feburaryLY{get;set;}
        public double marchLY{get;set;}
        
        public void setApril(double val){april=val;}
        public void setMay(double val){may=val;}
        public void setJune(double val){june=val;}
        public void setJuly(double val){july=val;}
        public void setAugust(double val){august=val;}
        public void setSeptember(double val){september=val;}
        public void setOctober(double val){october=val;}
        public void setNovember(double val){november=val;}
        public void setDecember(double val){december=val;}
        public void setJanuary(double val){january=val;}
        public void setFebruary(double val){february=val;}
        public void setMarch(double val){march=val;}
        
        //Last year variables
        public void setAprLY(double val){aprilLY=val;}
        public void setMayLY(double val){mayLY=val;}
        public void setJunLY(double val){juneLY=val;}
        public void setJulLY(double val){julyLY=val;}
        public void setAugLY(double val){augustLY=val;}
        public void setSepLY(double val){septemberLY=val;}
        public void setOctLY(double val){octoberLY=val;}
        public void setNovLY(double val){novemberLY=val;}
        public void setDecLY(double val){decemberLY=val;}
        public void setJanLY(double val){januaryLY=val;}
        public void setFebLY(double val){feburaryLY=val;}
        public void setMarLY(double val){marchLY=val;}
        
        public double getApril(){return april;}
        public double getMay(){return may;}
        public double getJune(){return june;}
        public double getJuly(){return july;}
        public double getAugust(){return august;}
        public double getSeptember(){return september;}
        public double getOctober(){return october;}
        public double getNovember(){return november;}
        public double getDecember(){return december;}
        public double getJanuary(){return january;}
        public double getFebruary(){return february;}
        public double getMarch(){return march;}
        public double getAnnual(){ return (april+may+june+july+august+september+october+november+december+january+february+march);}
        
        //Last years sales variables
        public double getAprilLY(){return aprilLY;}
        public double getMayLY(){return mayLY;}
        public double getJuneLY(){return juneLY;}
        public double getJulLY(){return julyLY;}
        public double getAugustLY(){return augustLY;}
        public double getSeptemberLY(){return septemberLY;}
        public double getOctoberLY(){return octoberLY;}
        public double getNovemberLY(){return novemberLY;}
        public double getDecemberLY(){return decemberLY;}
        public double getJanuaryLY(){return januaryLY;}
        public double getFebuaryLY(){return feburaryLY;}
        public double getMarchLY(){return marchLY;}
        
        //total sales amount summary last year
        public double getAnnualLY(){return(aprilLY+mayLY+juneLY+julyLY+augustLY+septemberLY+octoberLY+novemberLY+decemberLY+januaryLY+feburaryLY+marchLY);}

        //This section below for forecast (budget volume) Current Year only - SS
        
        public double budgetAprCY{get;set;}
        public double budgetMayCY{get;set;}
        public double budgetJunCY{get;set;}
        public double budgetJulCY{get;set;}
        public double budgetAugCY{get;set;}
        public double budgetSepCY{get;set;}
        public double budgetOctCY{get;set;}
        public double budgetNovCY{get;set;}
        public double budgetDecCY{get;set;}
        public double budgetJanCY{get;set;}
        public double budgetFebCY{get;set;}
        public double budgetMarCY{get;set;}
        
        public void setBudgetAprCY(double val){budgetAprCY=val;}
        public void setBudgetMayCY(double val){budgetMayCY=val;}
        public void setBudgetJunCY(double val){budgetJunCY=val;}
        public void setBudgetJulCY(double val){budgetJulCY=val;}
        public void setBudgetAugCY(double val){budgetAugCY=val;}
        public void setBudgetSepCY(double val){budgetSepCY=val;}
        public void setBudgetOctCY(double val){budgetOctCY=val;}
        public void setBudgetNovCY(double val){budgetNovCY=val;}
        public void setBudgetDecCY(double val){budgetDecCY=val;}
        public void setBudgetJanCY(double val){budgetJanCY=val;}
        public void setBudgetFebCY(double val){budgetFebCY=val;}
        public void setBudgetMarCY(double val){budgetMarCY=val;}

        public double getBudgetAprCY(){return budgetAprCY;}
        public double getBudgetMayCY(){return budgetMayCY;}
        public double getBudgetJunCY(){return budgetJunCY;}
        public double getBudgetJulCY(){return budgetJulCY;}
        public double getBudgetAugCY(){return budgetAugCY;}
        public double getBudgetSepCY(){return budgetSepCY;}
        public double getBudgetOctCY(){return budgetOctCY;}
        public double getBudgetNovCY(){return budgetNovCY;}
        public double getBudgetDecCY(){return budgetDecCY;}
        public double getBudgetJanCY(){return budgetJanCY;}
        public double getBudgetFebCY(){return budgetFebCY;}
        public double getBudgetMarCY(){return budgetMarCY;}

        public double getAnnualBudgetCY(){return(budgetAprCY+budgetMayCY+budgetJunCY+budgetJulCY+budgetAugCY+budgetSepCY+budgetOctCY+budgetNovCY+budgetDecCY+budgetJanCY+budgetFebCY+budgetMarCY);}
        
        public Integer compareTo(Object data){
            QvAccountData q = (QvAccountData)data;
            if(hoya_account_id > q.hoya_account_id) return 1;
            return 0;
        }
    }

    public List<QvAccountData> dataList{get;set;}
    public List<QvAccountData> dataLYList{get;set;}
    public List<QvAccountData> dataBudgetCYList{get;set;}

    private final Account acct;

    private final AggregateResult[] accountQVSales;
    private final AggregateResult[] accountQVSalesLY;
    private final AggregateResult[] budgetAnnualCY;

    private String CurrFY{get; set;}
    private String PrevFY{get; set;}

    public QvAccountData total{get; set;}
    public QvAccountData totalLY{get; set;}
    public QvAccountData totalBudgetCY{get;set;}
    
    private Double conversionRate{get;set;}
    private Double AccountConversionRate{get;set;}

    public QvSalesAccountWithSameParentController(ApexPages.StandardController stdController){
    
        this.acct = (Account)stdController.getRecord();
        /*
         * determine the current fiscal year
         */
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        //fiscal year is current year-1 from january to march, year from april to december
        if(month<4){
            year = year-1;
        }
        CurrFY = 'FY-' + String.valueOf(year).substring(2);
        PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        Account acc = [select Id, ParentID, owner.companyName, currencyisocode from Account where id=:this.acct.id];
        

        String userCurrency = UserInfo.getDefaultCurrency();
        String userCompany = [select companyName from User where id=: UserInfo.getUserId()].companyName;
        
        conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
        String accountCurrency = [select currencyisocode from Account where id=:this.acct.id].currencyIsoCode;
        AccountConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;
        //if(conversionRate==AccountConversionRate){AccountConversionRate=1;}
        //if(userCurrency!='EUR' && accountCurrency!='EUR'){AccountConversionRate=1;conversionRate=1;}
       /* if(userCurrency==accountCurrency)
        {
            AccountConversionRate=1;
            conversionRate=1;
        }*/


        String qId = acc.parentId;
        if(qId==null || qId==''){
            qId = acc.id;
        }
        
        dataList=new List<QvAccountData>();
        total = new QvAccountData('total');
        System.debug('XXX search id=' + qId + '/ parent id=' + acc.parentId);
        
        dataLYList=new List<QvAccountData>();
        total = new QvAccountData('totalLY');
        System.debug('XXX search id=' + qId + '/ parent id=' + acc.parentId);

        
        dataBudgetCYList = new List<QvAccountData>();
        total = new QvAccountData('totalBudgetCY');
        System.debug('XXX search id=' + qId + '/ parent id=' + acc.parentId);
        
        //Current Sales CY:
        //**********************************************************************************
        
        accountQvSales =[SELECT Hoya_Account_id__c, sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
             , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
             , sum(January__c) january, sum(February__c) february, sum(March__c) march
            FROM QV_Sales__c
            where Account__c in (select id from account where parentid=:qId) and FY__c=:CurrFY
            and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
            group by Hoya_Account_id__c order by Hoya_Account_id__c asc];
        for(AggregateResult ar : accountQvSales) {
             QvAccountData data = new QvAccountData(String.valueOf(ar.get('Hoya_Account_id__c')));
             data.setApril(double.valueOf(ar.get('april')));total.setApril(total.getApril()+double.valueOf(ar.get('april')));
             data.setMay(double.valueOf(ar.get('may')));total.setMay(total.getMay()+double.valueOf(ar.get('may')));
             data.setJune(double.valueOf(ar.get('june')));total.setJune(total.getJune()+double.valueOf(ar.get('june')));
             data.setJuly(double.valueOf(ar.get('july')));total.setJuly(total.getJuly()+double.valueOf(ar.get('july')));
             data.setAugust(double.valueOf(ar.get('august')));total.setAugust(total.getAugust()+double.valueOf(ar.get('august')));
             data.setSeptember(double.valueOf(ar.get('september')));total.setSeptember(total.getSeptember()+double.valueOf(ar.get('september')));
             data.setOctober(double.valueOf(ar.get('october')));total.setOctober(total.getOctober()+double.valueOf(ar.get('october')));
             data.setNovember(double.valueOf(ar.get('november')));total.setNovember(total.getNovember()+double.valueOf(ar.get('november')));
             data.setDecember(double.valueOf(ar.get('december')));total.setDecember(total.getDecember()+double.valueOf(ar.get('december')));
             data.setJanuary(double.valueOf(ar.get('january')));total.setJanuary(total.getJanuary()+double.valueOf(ar.get('january')));
             data.setFebruary(double.valueOf(ar.get('february')));total.setFebruary(total.getFebruary()+double.valueOf(ar.get('february')));
             data.setMarch(double.valueOf(ar.get('march')));total.setMarch(total.getMarch()+double.valueOf(ar.get('march')));
             dataList.add(data);
        }
        //*************************************************************
        //Last year sales LY:
        //*************************************************************
        accountQvSalesLY =[SELECT Hoya_Account_id__c, sum(Annual_Sales__c) annualSalesLY, sum(April__c) aprilLY, sum(May__c) mayLY, sum(June__c) juneLY
             , sum(July__c) julyLY, sum(August__c) augustLY, sum(September__c) septemberLY , sum(October__c) octoberLY, sum(November__c) novemberLY, sum(December__c) decemberLY
             , sum(January__c) januaryLY, sum(February__c) feburaryLY, sum(March__c) marchLY
            FROM QV_Sales__c
            where Account__c in (select id from account where parentid=:qId) and FY__c=:PrevFY
            and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
            group by Hoya_Account_id__c order by Hoya_Account_id__c asc];
        for(AggregateResult ar : accountQvSalesLY) {
             QvAccountData data = new QvAccountData(String.valueOf(ar.get('Hoya_Account_id__c')));
             data.setAprLY(double.valueOf(ar.get('aprilLY')));total.setAprLY(total.getAprilLY()+double.valueOf(ar.get('aprilLY')));
             data.setMayLY(double.valueOf(ar.get('mayLY')));total.setMayLY(total.getMayLY()+double.valueOf(ar.get('mayLY')));
             data.setJunLY(double.valueOf(ar.get('juneLY')));total.setJunLY(total.getJuneLY()+double.valueOf(ar.get('juneLY')));
             data.setJulLY(double.valueOf(ar.get('julyLY')));total.setJulLY(total.getJulLY()+double.valueOf(ar.get('julyLY')));
             data.setAugLY(double.valueOf(ar.get('augustLY')));total.setAugLY(total.getAugustLY()+double.valueOf(ar.get('augustLY')));
             data.setSepLY(double.valueOf(ar.get('septemberLY')));total.setSepLY(total.getSeptemberLY()+double.valueOf(ar.get('septemberLY')));
             data.setOctLY(double.valueOf(ar.get('octoberLY')));total.setOctLY(total.getOctoberLY()+double.valueOf(ar.get('octoberLY')));
             data.setNovLY(double.valueOf(ar.get('novemberLY')));total.setNovLY(total.getNovemberLY()+double.valueOf(ar.get('novemberLY')));
             data.setDecLY(double.valueOf(ar.get('decemberLY')));total.setDecLY(total.getDecemberLY()+double.valueOf(ar.get('decemberLY')));
             data.setJanLY(double.valueOf(ar.get('januaryLY')));total.setJanLY(total.getJanuaryLY()+double.valueOf(ar.get('januaryLY')));
             data.setFebLY(double.valueOf(ar.get('feburaryLY')));total.setFebLY(total.getFebuaryLY()+double.valueOf(ar.get('feburaryLY')));
             data.setMarLY(double.valueOf(ar.get('marchLY')));total.setMarLY(total.getMarchLY()+double.valueOf(ar.get('marchLY')));
             dataLYList.add(data);
        }
        
        //This is for Forecast (Budget per customer account)
        
        budgetAnnualCY = [SELECT Hoya_Account_ID__c, sum(Budget_April_Current_Year__c) budgetAprCY, sum(Budget_May_Current_Year__c) budgetMayCY, 
                                sum(Budget_June_Current_Year__c) budgetJunCY, sum(Budget_July_Current_Year__c) budgetJulCY, 
                                sum(Budget_August_Current_Year__c) budgetAugCY, sum(Budget_September_Current_Year__c) budgetSepCY, 
                                sum(Budget_October_Current_Year__c) budgetOctCY, sum(Budget_November_Current_Year__c) budgetNovCY, 
                                sum(Budget_December_Current_Year__c) budgetDecCY, sum(Budget_January_Current_Year__c) budgetJanCY,
                                sum(Budget_February_Current_Year__c) budgetFebCY, sum(Budget_March_Current_Year__c) budgetMarCY 
                            FROM Account 
                            WHERE ParentId=:qId GROUP BY Hoya_Account_ID__c ORDER BY Hoya_Account_ID__c asc];
        for(AggregateResult ar : budgetAnnualCY){
            
            QvAccountData data = new QvAccountData(String.valueOf(ar.get('Hoya_Account_ID__c')));
            data.setBudgetAprCY(double.valueOf(ar.get('budgetAprCY')));total.setBudgetAprCY(total.getBudgetAprCY()+double.valueOf(ar.get('budgetAprCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetMayCY')));total.setBudgetMayCY(total.getBudgetMayCY()+double.valueOf(ar.get('budgetMayCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetJunCY')));total.setBudgetJunCY(total.getBudgetJunCY()+double.valueOf(ar.get('budgetJunCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetJulCY')));total.setBudgetJulCY(total.getBudgetJulCY()+double.valueOf(ar.get('budgetJulCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetAugCY')));total.setBudgetAugCY(total.getBudgetAugCY()+double.valueOf(ar.get('budgetAugCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetSepCY')));total.setBudgetSepCY(total.getBudgetSepCY()+double.valueOf(ar.get('budgetSepCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetOctCY')));total.setBudgetOctCY(total.getBudgetOctCY()+double.valueOf(ar.get('budgetOctCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetNovCY')));total.setBudgetNovCY(total.getBudgetNovCY()+double.valueOf(ar.get('budgetNovCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetDecCY')));total.setBudgetDecCY(total.getBudgetDecCY()+double.valueOf(ar.get('budgetDecCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetJanCY')));total.setBudgetJanCY(total.getBudgetJanCY()+double.valueOf(ar.get('budgetJanCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetFebCY')));total.setBudgetFebCY(total.getBudgetFebCY()+double.valueOf(ar.get('budgetFebCY')));
            data.setBudgetMayCY(double.valueOf(ar.get('budgetMarCY')));total.setBudgetMarCY(total.getBudgetMarCY()+double.valueOf(ar.get('budgetMarCY')));
            
            dataBudgetCYList.add(data);
        }
        
        //**************************************************************
        //if((acc.parentId==null ) && (acc.owner.companyName=='HLHK'||acc.owner.companyName=='HOLK')){
        if(acc.parentId==null){
            //add top hiereachie level
            List<AggregateResult> qvCurrFy =  [SELECT Hoya_Account_id__c, sum(Annual_Sales__c) annualSales, sum(April__c) april, sum(May__c) may, sum(June__c) june
                , sum(July__c) july, sum(August__c) august, sum(September__c) september , sum(October__c) october, sum(November__c) november, sum(December__c) december
                , sum(January__c) january, sum(February__c) february, sum(March__c) march
                FROM QV_Sales__c
                where Account__c =:acc.Id and FY__c=:CurrFY
                and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                group by Hoya_Account_id__c order by Hoya_Account_id__c asc];
            for(AggregateResult ar : qvCurrFy) {
                    QvAccountData data = new QvAccountData(String.valueOf(ar.get('Hoya_Account_id__c')));
                    data.setApril(double.valueOf(ar.get('april')));total.setApril(total.getApril()+double.valueOf(ar.get('april')));
                    data.setMay(double.valueOf(ar.get('may')));total.setMay(total.getMay()+double.valueOf(ar.get('may')));
                    data.setJune(double.valueOf(ar.get('june')));total.setJune(total.getJune()+double.valueOf(ar.get('june')));
                    data.setJuly(double.valueOf(ar.get('july')));total.setJuly(total.getJuly()+double.valueOf(ar.get('july')));
                    data.setAugust(double.valueOf(ar.get('august')));total.setAugust(total.getAugust()+double.valueOf(ar.get('august')));
                    data.setSeptember(double.valueOf(ar.get('september')));total.setSeptember(total.getSeptember()+double.valueOf(ar.get('september')));
                    data.setOctober(double.valueOf(ar.get('october')));total.setOctober(total.getOctober()+double.valueOf(ar.get('october')));
                    data.setNovember(double.valueOf(ar.get('november')));total.setNovember(total.getNovember()+double.valueOf(ar.get('november')));
                    data.setDecember(double.valueOf(ar.get('december')));total.setDecember(total.getDecember()+double.valueOf(ar.get('december')));
                    data.setJanuary(double.valueOf(ar.get('january')));total.setJanuary(total.getJanuary()+double.valueOf(ar.get('january')));
                    data.setFebruary(double.valueOf(ar.get('february')));total.setFebruary(total.getFebruary()+double.valueOf(ar.get('february')));
                    data.setMarch(double.valueOf(ar.get('march')));total.setMarch(total.getMarch()+double.valueOf(ar.get('march')));
                    dataList.add(data);
                }
                //add the top hierarchy last year set to zero
            List<AggregateResult> qvLfy = [SELECT Hoya_Account_id__c, sum(Annual_Sales__c) annualSalesLY, sum(April__c) aprilLY, sum(May__c) mayLY, sum(June__c) juneLY
                    , sum(July__c) julyLY, sum(August__c) augustLY, sum(September__c) septemberLY , sum(October__c) octoberLY, sum(November__c) novemberLY, sum(December__c) decemberLY
                    , sum(January__c) januaryLY, sum(February__c) feburaryLY, sum(March__c) marchLY 
                    FROM QV_Sales__c
                    where Account__c =:acc.Id and FY__c=:PrevFY
                    and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                    group by Hoya_Account_id__c order by Hoya_Account_id__c asc];
            for(AggregateResult arLY : qvLfy){
                    QvAccountData dataLY = new QvAccountData(String.valueOf(arLY.get('Hoya_Account_id__c')));
                    dataLY.setAprLY(double.valueOf(arLY.get('aprilLY')));total.setAprLY(total.getAprilLY()+double.valueOf(arLY.get('aprilLY')));
                    dataLY.setMayLY(double.valueOf(arLY.get('mayLY')));total.setMayLY(total.getMayLY()+double.valueOf(arLY.get('mayLY')));
                    dataLY.setJunLY(double.valueOf(arLY.get('juneLY')));total.setJunLY(total.getJuneLY()+double.valueOf(arLY.get('juneLY')));
                    dataLY.setJulLY(double.valueOf(arLY.get('julyLY')));total.setJulLY(total.getJulLY()+double.valueOf(arLY.get('julyLY')));
                    dataLY.setAugLY(double.valueOf(arLY.get('augustLY')));total.setAugLY(total.getAugustLY()+double.valueOf(arLY.get('augustLY')));
                    dataLY.setSepLY(double.valueOf(arLY.get('septemberLY')));total.setSepLY(total.getSeptemberLY()+double.valueOf(arLY.get('septemberLY')));
                    dataLY.setOctLY(double.valueOf(arLY.get('octoberLY')));total.setOctLY(total.getOctoberLY()+double.valueOf(arLY.get('octoberLY')));
                    dataLY.setNovLY(double.valueOf(arLY.get('novemberLY')));total.setNovLY(total.getNovemberLY()+double.valueOf(arLY.get('novemberLY')));
                    dataLY.setDecLY(double.valueOf(arLY.get('decemberLY')));total.setDecLY(total.getDecemberLY()+double.valueOf(arLY.get('decemberLY')));
                    dataLY.setJanLY(double.valueOf(arLY.get('januaryLY')));total.setJanLY(total.getJanuaryLY()+double.valueOf(arLY.get('januaryLY')));
                    dataLY.setFebLY(double.valueOf(arLY.get('feburaryLY')));total.setFebLY(total.getFebuaryLY()+double.valueOf(arLY.get('feburaryLY')));
                    dataLY.setMarLY(double.valueOf(arLY.get('marchLY')));total.setMarLY(total.getMarchLY()+double.valueOf(arLY.get('marchLY')));
                    dataLYList.add(dataLY);
                }
                //add the loop for budget forecast account if parentid=:0 - SSU
            List<AggregateResult> budgetList = [SELECT Hoya_Account_ID__c, sum(Budget_April_Current_Year__c) budgetAprCY, 
                            sum(Budget_May_Current_Year__c) budgetMayCY, 
                            sum(Budget_June_Current_Year__c) budgetJunCY, 
                            sum(Budget_July_Current_Year__c) budgetJulCY, 
                            sum(Budget_August_Current_Year__c) budgetAugCY, 
                            sum(Budget_September_Current_Year__c) budgetSepCY, 
                            sum(Budget_October_Current_Year__c) budgetOctCY, 
                            sum(Budget_November_Current_Year__c) budgetNovCY, 
                            sum(Budget_December_Current_Year__c) budgetDecCY, 
                            sum(Budget_January_Current_Year__c) budgetJanCY,
                            sum(Budget_February_Current_Year__c) budgetFebCY, 
                            sum(Budget_March_Current_Year__c) budgetMarCY 
                    FROM Account 
                    WHERE Id =:acc.Id GROUP BY Hoya_Account_ID__c ORDER BY Hoya_Account_ID__c asc];
            for(AggregateResult arBud : budgetList){
                QvAccountData dataBudget = new QvAccountData(String.valueOf(arBud.get('Hoya_Account_ID__c')));
                if(arBud.get('budgetAprCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetAprCY')));total.setBudgetAprCY(total.getBudgetAprCY()+double.valueof(arBud.get('budgetAprCY')));}
                if(arBud.get('budgetMayCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetMayCY')));total.setBudgetMayCY(total.getBudgetMayCY()+double.valueof(arBud.get('budgetMayCY')));}
                if(arBud.get('budgetJunCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetJunCY')));total.setBudgetJunCY(total.getBudgetJunCY()+double.valueof(arBud.get('budgetJunCY')));}
                if(arBud.get('budgetJulCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetJulCY')));total.setBudgetJulCY(total.getBudgetJulCY()+double.valueof(arBud.get('budgetJulCY')));}
                if(arBud.get('budgetAugCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetAugCY')));total.setBudgetAugCY(total.getBudgetAugCY()+double.valueof(arBud.get('budgetAugCY')));}
                if(arBud.get('budgetSepCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetSepCY')));total.setBudgetSepCY(total.getBudgetSepCY()+double.valueof(arBud.get('budgetSepCY')));}
                if(arBud.get('budgetOctCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetOctCY')));total.setBudgetOctCY(total.getBudgetOctCY()+double.valueof(arBud.get('budgetOctCY')));}
                if(arBud.get('budgetNovCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetNovCY')));total.setBudgetNovCY(total.getBudgetNovCY()+double.valueof(arBud.get('budgetNovCY')));}
                if(arBud.get('budgetDecCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetDecCY')));total.setBudgetDecCY(total.getBudgetDecCY()+double.valueof(arBud.get('budgetDecCY')));}
                if(arBud.get('budgetJanCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetJanCY')));total.setBudgetJanCY(total.getBudgetJanCY()+double.valueof(arBud.get('budgetJanCY')));}
                if(arBud.get('budgetFebCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetFebCY')));total.setBudgetFebCY(total.getBudgetFebCY()+double.valueof(arBud.get('budgetFebCY')));}
                if(arBud.get('budgetMarCY')!=null){dataBudget.setBudgetAprCY(double.valueOf(arBud.get('budgetMarCY')));total.setBudgetMarCY(total.getBudgetMarCY()+double.valueof(arBud.get('budgetMarCY')));}

                dataBudgetCYList.add(dataBudget);

                }
       }
       dataList.sort();
    }
    
    public Double getAccountConversionRate(){return AccountConversionRate;}
    public Double getConversionRate(){return conversionRate;}

    public void methodForTest(){
        QvAccountData data = new QvAccountData('1234567890');
        data.setApril( 100);
        data.setMay( 100);
        data.setJune( 100);
        data.setJuly( 100);
        data.setAugust( 100);
        data.setSeptember( 100);
        data.setOctober( 100);
        data.setNovember( 100);
        data.setDecember( 100);
        data.setJanuary( 100);
        data.setFebruary( 100);
        data.setMarch( 100);
        data.setAprLY( 100);
        data.setMayLY( 100);
        data.setJunLY( 100);
        data.setJulLY( 100);
        data.setAugLY( 100);
        data.setSepLY( 100);
        data.setOctLY( 100);
        data.setNovLY( 100);
        data.setDecLY( 100);
        data.setJanLY( 100);
        data.setFebLY( 100);
        data.setMarLY( 100);
        data.getApril();
        data.getMay();
        data.getJune();
        data.getJuly();
        data.getAugust();
        data.getSeptember();
        data.getOctober();
        data.getNovember();
        data.getDecember();
        data.getJanuary();
        data.getFebruary();
        data.getMarch();
        data.getAnnual();
        data.getAprilLY();
        data.getMayLY();
        data.getJuneLY();
        data.getJulLY();
        data.getAugustLY();
        data.getSeptemberLY();
        data.getOctoberLY();
        data.getNovemberLY();
        data.getDecemberLY();
        data.getJanuaryLY();
        data.getFebuaryLY();
        data.getMarchLY();
        data.getAnnualLY();

        data.setBudgetAprCY( 100);
        data.setBudgetMayCY( 100);
        data.setBudgetJunCY( 100);
        data.setBudgetJulCY( 100);
        data.setBudgetAugCY( 100);
        data.setBudgetSepCY( 100);
        data.setBudgetOctCY( 100);
        data.setBudgetNovCY( 100);
        data.setBudgetDecCY( 100);
        data.setBudgetJanCY( 100);
        data.setBudgetFebCY( 100);
        data.setBudgetMarCY( 100);

        data.getBudgetAprCY();
        data.getBudgetMayCY();
        data.getBudgetJunCY();
        data.getBudgetJulCY();
        data.getBudgetAugCY();
        data.getBudgetSepCY();
        data.getBudgetOctCY();
        data.getBudgetNovCY();
        data.getBudgetDecCY();
        data.getBudgetJanCY();
        data.getBudgetFebCY();
        data.getBudgetMarCY();

        data.getAnnualBudgetCY();
    }
}