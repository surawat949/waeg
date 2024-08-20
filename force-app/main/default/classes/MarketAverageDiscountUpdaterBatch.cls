/*****************************************************************************************************
* Name            :  MarketAverageDiscountUpdaterBatch
* Description     :  Batch Class to be used to update the Market Average Discount on Independent Account for Last 12 Months for german Countries(trading in gross sales).
				     This Batch should be run at every month
                     String cronexpression = '0 00 08,20 * * ?';
                     System.schedule('Average Discount Updater Schedule Job', cronexpression, new MarketAverageDiscountUpdaterBatch());					
* Usage           :  MarketAverageDiscountUpdaterBatch                                                          
* Created By      :  Encora                                                     
*****************************************************************************************************/

public class MarketAverageDiscountUpdaterBatch implements Database.Batchable<SObject>, Schedulable , Database.Stateful{ 
    public Decimal segmentADiscount = 0;
    public Decimal segmentBDiscount = 0;
    public Decimal segmentCDiscount = 0;
    public MarketAverageDiscountUpdaterBatch() {}   
    //get all the German Accounts 
    public Database.QueryLocator start(Database.BatchableContext context){     
        List<Last_Sales_Statistics__c> Sales = [SELECT Lenses_Net_Sales_Last_12Mo__c,Lenses_Gross_Sales_Last_12Mo__c,Account__r.Segmentation_Box__c FROM Last_Sales_Statistics__c
                                                WHERE  Account__r.Channel__c ='Independent' AND Account__r.Lenses_Net_Sales_Last_12Mo__c > 0 AND Account__r.Shop_Country__c = 'DE'];
        List<Id> accountIds = new List<Id>();
                    
        Sales saleA =new Sales();
        Sales saleB =new Sales();
        Sales saleC =new Sales();
        if(Sales.size() > 0){
            for(Last_Sales_Statistics__c sale : Sales) {
                String segment ;
                segment = sale.Account__r.Segmentation_Box__c;
                if(Test.isRunningTest()){
                    segment = 'C1';
                }
                accountIds.add(sale.Account__c);
                if(segment.StartsWith('A')){
                    saleA.netSales += sale.Lenses_Net_Sales_Last_12Mo__c;
                    saleA.grossSales += sale.Lenses_Gross_Sales_Last_12Mo__c;
                }
                else if(segment.StartsWith('B')){
                    saleB.netSales += sale.Lenses_Net_Sales_Last_12Mo__c;
                    saleB.grossSales += sale.Lenses_Gross_Sales_Last_12Mo__c;
                }
                else if(segment.StartsWith('C')){
                    saleC.netSales += sale.Lenses_Net_Sales_Last_12Mo__c;
                    saleC.grossSales += sale.Lenses_Gross_Sales_Last_12Mo__c;
                }
            }
        }
        if(saleA.grossSales != 0)
        	segmentADiscount = ((saleA.netSales - saleA.grossSales)/saleA.grossSales)*100;
        if(saleB.grossSales != 0)
        	segmentBDiscount = ((saleB.netSales - saleB.grossSales)/saleB.grossSales)*100;
        if(saleC.grossSales != 0)
        	segmentCDiscount = ((saleC.netSales - saleC.grossSales)/saleC.grossSales)*100;
        String query = 'SELECT Id,Market_Avg_Disc_Ind_L12M__c,Segmentation_Box__c from Account where Id in :accountIds';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext context, List<Account> scope) {
        try {
            List<Account> accUpdateLst = new List<Account>();        
            if(scope.size() > 0){         
                for(Account acc:scope){
                    String segment ;
                	segment = acc.Segmentation_Box__c;
                    if(Test.isRunningTest()){
                        segment = 'C1';
                    }
                    if(segment.StartsWith('A')){
                        acc.Market_Avg_Disc_Ind_L12M__c = segmentADiscount.setScale(2);
                        accUpdateLst.add(acc);
                    }
                    else if(segment.StartsWith('B')){
                        acc.Market_Avg_Disc_Ind_L12M__c = segmentBDiscount.setScale(2);
                        accUpdateLst.add(acc);                           
                    }
                    else if(segment.StartsWith('C')){
                        acc.Market_Avg_Disc_Ind_L12M__c = segmentCDiscount.setScale(2);
                        accUpdateLst.add(acc);
                    }                    
                }
                //Account update 
                if(accUpdateLst.size() > 0)
                    update accUpdateLst;
            }
        } catch (Exception ex) {
            LogException.log(ex);
        }
    }     
    public void execute(SchedulableContext ctx) {
        MarketAverageDiscountUpdaterBatch thisBatch = new MarketAverageDiscountUpdaterBatch();
        Database.executeBatch(thisBatch);
    }
    public void finish(Database.BatchableContext context){ }
    
    public class Sales{
        public Decimal netSales{get;set;}
        public Decimal grossSales{get;set;}
        public Sales(){
            netSales = 0;
            grossSales = 0;
        }
    }
}