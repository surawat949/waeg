public class DoorSalesPerformanceEngine {
    
    private EntityModeEnum mode {get;set;}
    private List<String> hoyaAccountList{get;set;}
    
    public DoorSalesPerformanceEngine(EntityModeEnum mode, Id doorId){
        System.debug('XXX DoorPerf: doorId=' + doorId + ', mode' + mode);
        this.mode = mode;
        String likeText = 'HOYA%';
        if(mode==EntityModeEnum.SEIKO){likeText='Seiko%';}
        if(mode==EntityModeEnum.HOYASEIKO){likeText='% %';}
        List<Account> accList = [select id, hoya_account_id__c from account where door__c= :doorId and account.owner.division like :likeText ];
        System.debug('XXX DoorPerf: ' + accList.size() + ' accounts founds');

        hoyaAccountList = new List<String>();
        for(Account a:accList){
            hoyaAccountList.Add(a.hoya_account_id__c);
        }
    }
    
    
    public List<DoorSalesPerformance> getPerformance(){
        
        List<DoorSalesPerformance> result = new List<DoorSalesPerformance>();
        for(Account acc:[select id, Segmentation_Box__c, Actuals_April_Current_Year__c, Actuals_May_Current_Year__c, Actuals_June_Current_Year__c,
                Actuals_July_Current_Year__c, Actuals_August_Current_Year__c, Actuals_September_Current_Year__c, Actuals_October_Current_Year__c,
                Actuals_November_Current_Year__c, Actuals_December_Current_Year__c, Actuals_January_Current_Year__c, Actuals_February_Current_Year__c, Actuals_March_Current_Year__c,
                Hoya_Account_Id__c, owner.companyName, potential__c,Share_of_Wallet__c, annualRevenue
                from account where Hoya_Account_Id__c in :hoyaAccountList]){
            DoorSalesPerformance p = new DoorSalesPerformance();
            p.segmentationBox = acc.Segmentation_Box__c;
            p.hoyaAccountId = acc.Hoya_Account_Id__c;
            p.april = acc.Actuals_April_Current_Year__c;
            p.may = acc.Actuals_May_Current_Year__c;
            p.june = acc.Actuals_June_Current_Year__c;
            p.july = acc.Actuals_july_Current_Year__c;
            p.august = acc.Actuals_August_Current_Year__c;
            p.september = acc.Actuals_September_Current_Year__c;
            p.october = acc.Actuals_October_Current_Year__c;
            p.november = acc.Actuals_November_Current_Year__c;
            p.december = acc.Actuals_December_Current_Year__c;
            p.january = acc.Actuals_January_Current_Year__c;
            p.february = acc.Actuals_February_Current_Year__c;
            p.march = acc.Actuals_March_Current_Year__c;
            p.annual = acc.annualRevenue;
            p.companyName = acc.owner.companyName;
            p.potential = acc.potential__c;
            p.sow = acc.Share_of_Wallet__c;
            
            result.add(p);
        }
        return result;
    }
}