public class QvQueryPageController {

    private final Account acct;
    
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
    private Double AprSales{get; set;}
    private Double MaySales{get; set;}
    private Double JunSales{get; set;}
    private Double JulSales{get; set;}
    private Double AugSales{get; set;}
    private Double SepSales{get; set;}
    private Double OctSales{get; set;}
    private Double NovSales{get; set;}
    private Double DecSales{get; set;}
    private Double JanSales{get; set;}
    private Double FebSales{get; set;}
    private Double MarSales{get; set;}
    private String CurrFY{get; set;}
    public List<QvData> dataList{get;set;}
    
    /*
     * Last year variables
     */
     
    private Double AprSalesLY{get; set;}
    private Double MaySalesLY{get; set;}
    private Double JunSalesLY{get; set;}
    private Double JulSalesLY{get; set;}
    private Double AugSalesLY{get; set;}
    private Double SepSalesLY{get; set;}
    private Double OctSalesLY{get; set;}
    private Double NovSalesLY{get; set;}
    private Double DecSalesLY{get; set;}
    private Double JanSalesLY{get; set;}
    private Double FebSalesLY{get; set;}
    private Double MarSalesLY{get; set;}
    private String PrevFY{get; set;}
    
    public List<QvData> dataLYList{get;set;}
    
    private Double conversionRate{get;set;}
    private Double originalConversionRate{get;set;}
    private Double AccountConversionRate{get;set;}
    private Double credits_CY{get; set;}
    private Double credits_LY{get; set;}
    private Double turnover_CY{get; set;}
    private Double turnover_LY{get; set;}
    private Double quantity_CY{get; set;}
    private Double quantity_LY{get; set;}
    private Double quantity_C_CY{get; set;}
    private Double quantity_C_LY{get; set;}
    
    private final AggregateResult[] accountQVSales;
    private final AggregateResult[] accountQVSalesLY;
    
    //Constructor
    public QvQueryPageController(ApexPages.StandardController stdController){
        this.acct = (Account)stdController.getRecord();
        
    String userCurrency = UserInfo.getDefaultCurrency();
    String userCompany = [select companyName from User where id=: UserInfo.getUserId()].companyName;
    originalConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
    conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: userCurrency].conversionRate;
    String accountCurrency = [select currencyisocode from Account where id=:this.acct.id].currencyIsoCode;
    AccountConversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: accountCurrency].conversionRate;
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
        if(month<4){
            year = year-1;
        }
        CurrFY = 'FY-' + String.valueOf(year).substring(2);
        PrevFY = 'FY-' + String.valueOf(year-1).substring(2);
        System.Debug('LAST YEAR/CURR YEAR=' + PrevFY +'/'+CurrFY);
        
        credits_CY = 0;
        credits_LY = 0;
        
        AprSales = 0;
        MaySales = 0;
        JunSales = 0;
        JulSales = 0;
        AugSales = 0;
        SepSales = 0;
        OctSales = 0;
        NovSales = 0;
        DecSales = 0;
        JanSales = 0;
        FebSales = 0;
        MarSales = 0;
        /*
         * compute current fiscal year data
         */
        accountQvSales =[SELECT Generic_Design__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty,FY__c
            , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
            , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
        FROM QV_Sales__c
        where Account__c=:this.acct.id and FY__c=:CurrFY
        group by Generic_Design__c, FY__c];
        
            dataList=new List<QvData>();
            for(AggregateResult ar : accountQvSales) {
                QvData data = new QvData(String.valueOf(ar.get('Generic_Design__c')), double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
                dataList.add(data);
            }
            
        for( QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                      , October__c, November__c, December__c, January__c, February__c, March__c
                                      FROM QV_Sales__c
                                      where Account__c=:this.acct.id and FY__c=:CurrFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                                                ]){
            AprSales = AprSales + double.valueOf(qcy.April__c) * conversionRate;
            MaySales = MaySales + double.valueOf(qcy.May__c) * conversionRate;
            JunSales = JunSales + double.valueOf(qcy.June__c) * conversionRate;
            JulSales = JulSales + double.valueOf(qcy.July__c) * conversionRate;
            AugSales = AugSales + double.valueOf(qcy.August__c) * conversionRate;
            SepSales = SepSales + double.valueOf(qcy.September__c) * conversionRate;
            OctSales = OctSales + double.valueOf(qcy.October__c) * conversionRate;
            NovSales = NovSales + double.valueOf(qcy.November__c) * conversionRate;
            DecSales = DecSales + double.valueOf(qcy.December__c) * conversionRate;
            JanSales = JanSales + double.valueOf(qcy.January__c) * conversionRate;
            FebSales = FebSales + double.valueOf(qcy.February__c) * conversionRate;
            MarSales = MarSales + double.valueOf(qcy.March__c) * conversionRate;
        }
        if(userCompany=='HAPL'){
            /* include frame for HAPL */
            for( QV_Sales__c qcy : [SELECT April__c, May__c, June__c, July__c, August__c, September__c
                                    , October__c, November__c, December__c, January__c, February__c, March__c
                                    FROM QV_Sales__c
                                    where Account__c=:this.acct.id and FY__c=:CurrFY and RX_or_Stock__c='FRAME'
                                   ]){AprSales = AprSales + double.valueOf(qcy.April__c) * conversionRate;
            MaySales = MaySales + double.valueOf(qcy.May__c) * conversionRate;
            JunSales = JunSales + double.valueOf(qcy.June__c) * conversionRate;
            JulSales = JulSales + double.valueOf(qcy.July__c) * conversionRate;
            AugSales = AugSales + double.valueOf(qcy.August__c) * conversionRate;
            SepSales = SepSales + double.valueOf(qcy.September__c) * conversionRate;
            OctSales = OctSales + double.valueOf(qcy.October__c) * conversionRate;
            NovSales = NovSales + double.valueOf(qcy.November__c) * conversionRate;
            DecSales = DecSales + double.valueOf(qcy.December__c) * conversionRate;
            JanSales = JanSales + double.valueOf(qcy.January__c) * conversionRate;
            FebSales = FebSales + double.valueOf(qcy.February__c) * conversionRate;
            MarSales = MarSales + double.valueOf(qcy.March__c) * conversionRate;
                                     }
        }
        /*
         * compute Last Fiscal year data
         */
        accountQvSalesLY =[SELECT Generic_Design__c, sum(Annual_Sales__c) annualSales, sum(Annual_qty__c) annualQty,FY__c
            , sum(April__c) april, sum(May__c) may, sum(June__c) june, sum(July__c) july, sum(August__c) august, sum(September__c) september
            , sum(October__c) october, sum(November__c) november, sum(December__c) december, sum(January__c) january, sum(February__c) february, sum(March__c) march
        FROM QV_Sales__c
        where Account__c=:this.acct.id and FY__c=:PrevFY
        and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
        group by Generic_Design__c, FY__c];
        
        AprSalesLY = 0;
        MaySalesLY = 0;
        JunSalesLY = 0;
        JulSalesLY = 0;
        AugSalesLY = 0;
        SepSalesLY = 0;
        OctSalesLY = 0;
        NovSalesLY = 0;
        DecSalesLY = 0;
        JanSalesLY = 0;
        FebSalesLY = 0;
        MarSalesLY = 0;
            
        dataLYList=new List<QvData>();
        for(AggregateResult ar : accountQvSalesLY) {
            QvData data = new QvData(String.valueOf(ar.get('Generic_Design__c')), double.valueOf(ar.get('annualSales')), Integer.valueOf(ar.get('annualQty')));
            dataLYList.add(data);
        }
        
         for( QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                                 , December__c, January__c, February__c, March__c
                                FROM QV_Sales__c
                                where Account__c=:this.acct.id and FY__c=:PrevFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                                ]){
            AprSalesLY = AprSalesLY + double.valueOf(qly.April__c) * conversionRate;
            MaySalesLY = MaySalesLY + double.valueOf(qly.May__c) * conversionRate;
            JunSalesLY = JunSalesLY + double.valueOf(qly.June__c) * conversionRate;
            JulSalesLY = JulSalesLY + double.valueOf(qly.July__c) * conversionRate;
            AugSalesLY = AugSalesLY + double.valueOf(qly.August__c) * conversionRate;
            SepSalesLY = SepSalesLY + double.valueOf(qly.September__c) * conversionRate;
            OctSalesLY = OctSalesLY + double.valueOf(qly.October__c) * conversionRate;
            NovSalesLY = NovSalesLY + double.valueOf(qly.November__c) * conversionRate;
            DecSalesLY = DecSalesLY + double.valueOf(qly.December__c) * conversionRate;
            JanSalesLY = JanSalesLY + double.valueOf(qly.January__c) * conversionRate;
            FebSalesLY = FebSalesLY + double.valueOf(qly.February__c) * conversionRate;
            MarSalesLY = MarSalesLY+ double.valueOf(qly.March__c) * conversionRate;
        }
         if(userCompany=='HAPL'){
            /* include frame for HAPL */
             for( QV_Sales__c qly : [SELECT April__c, May__c, June__c, July__c, August__c, September__c, October__c, November__c
                       , December__c, January__c, February__c, March__c
                       FROM QV_Sales__c
                       where Account__c=:this.acct.id and FY__c=:PrevFY and RX_or_Stock__c='FRAME' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'
                       ]){
            AprSalesLY = AprSalesLY + double.valueOf(qly.April__c) * conversionRate;
            MaySalesLY = MaySalesLY + double.valueOf(qly.May__c) * conversionRate;
            JunSalesLY = JunSalesLY + double.valueOf(qly.June__c) * conversionRate;
            JulSalesLY = JulSalesLY + double.valueOf(qly.July__c) * conversionRate;
            AugSalesLY = AugSalesLY + double.valueOf(qly.August__c) * conversionRate;
            SepSalesLY = SepSalesLY + double.valueOf(qly.September__c) * conversionRate;
            OctSalesLY = OctSalesLY + double.valueOf(qly.October__c) * conversionRate;
            NovSalesLY = NovSalesLY + double.valueOf(qly.November__c) * conversionRate;
            DecSalesLY = DecSalesLY + double.valueOf(qly.December__c) * conversionRate;
            JanSalesLY = JanSalesLY + double.valueOf(qly.January__c) * conversionRate;
            FebSalesLY = FebSalesLY + double.valueOf(qly.February__c) * conversionRate;
            MarSalesLY = MarSalesLY+ double.valueOf(qly.March__c) * conversionRate;
                       }
         }
        /*
         * compute credits
         */
         if(originalConversionRate==null || originalConversionRate==0){originalConversionRate=1;}
        AggregateResult[] groupedResults = [SELECT sum(Annual_Sales__c) sumCY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:CurrFY and type__c='C'];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
            credits_CY = double.valueOf(groupedResults[0].get('sumCY'))* originalConversionRate;
        }
        
        groupedResults = [SELECT sum(Annual_Sales__c) sumLY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:PrevFY and type__c='C'];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
            credits_LY = double.valueOf(groupedResults[0].get('sumLY'))* originalConversionRate;
        }
        
        /*
         * compute turnover
         */
        turnover_CY = 0;
        groupedResults = [SELECT sum(Annual_Sales__c) sumCY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:CurrFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
            if(groupedResults[0].get('sumCY')!=null){turnover_CY = double.valueOf(groupedResults[0].get('sumCY'))* originalConversionRate;}
            groupedResults = [SELECT sum(Annual_Sales__c) sumLY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:PrevFY and RX_or_Stock__c<>'FRAME' and RX_or_Stock__c<>'INSTRUMENT' and RX_or_Stock__c<>'OTHER' and RX_or_Stock__c<>'OTHERS' and RX_or_Stock__c<>'SERVICE' and RX_or_Stock__c<>'NON REVENUE'];
            turnover_LY = 0;
            if(groupedResults[0].get('sumLY')!=null){turnover_LY = double.valueOf(groupedResults[0].get('sumLY'))* originalConversionRate;}
        }
        
        /*
         * compute quantity
         */
         
        groupedResults = [SELECT sum(Annual_qty__c) sumCY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:CurrFY];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
            quantity_CY = double.valueOf(groupedResults[0].get('sumCY'));
        }
        groupedResults = [SELECT sum(Annual_qty__c) sumLY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:PrevFY];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
            quantity_LY = double.valueOf(groupedResults[0].get('sumLY'));
        }
        
        groupedResults = [SELECT sum(Annual_qty__c) sumCY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:CurrFY and type__c='C'];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumCY')!=null){
            quantity_C_CY = double.valueOf(groupedResults[0].get('sumCY'));
        }
        
        groupedResults = [SELECT sum(Annual_qty__c) sumLY FROM QV_Sales__c where Account__c=:this.acct.id and FY__c=:PrevFY and type__c='C'];
        if(groupedResults!=null && groupedResults.size()>0 && groupedResults[0].get('sumLY')!=null){
            quantity_C_LY = double.valueOf(groupedResults[0].get('sumLY'));
        }
    }
    
    public AggregateResult[] getQvSales(){
        return accountQVSales;
    }
    
    /*
     * Getter and setter
     *
     */
    public Double getAprSales(){return AprSales;}
    public Double getMaySales(){return MaySales;}
    public Double getJunSales(){return JunSales;}
    public Double getJulSales(){return JulSales;}
    public Double getAugSales(){return AugSales;}
    public Double getSepSales(){return SepSales;}
    public Double getOctSales(){return OctSales;}
    public Double getNovSales(){return NovSales;}
    public Double getDecSales(){return DecSales;}
    public Double getJanSales(){return JanSales;}
    public Double getFebSales(){return FebSales;}
    public Double getMarSales(){return MarSales;}
    public String getCurrFY(){return CurrFY;}
    
    
    public Double getAprSalesLY(){return AprSalesLY;}
    public Double getMaySalesLY(){return MaySalesLY;}
    public Double getJunSalesLY(){return JunSalesLY;}
    public Double getJulSalesLY(){return JulSalesLY;}
    public Double getAugSalesLY(){return AugSalesLY;}
    public Double getSepSalesLY(){return SepSalesLY;}
    public Double getOctSalesLY(){return OctSalesLY;}
    public Double getNovSalesLY(){return NovSalesLY;}
    public Double getDecSalesLY(){return DecSalesLY;}
    public Double getJanSalesLY(){return JanSalesLY;}
    public Double getFebSalesLY(){return FebSalesLY;}
    public Double getMarSalesLY(){return MarSalesLY;}
    public String getPrevFY(){return PrevFY;}
    
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