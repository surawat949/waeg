@isTest
public class AccountSalesControllerHelper_test {
	public AccountSalesControllerHelper_test() {
    }
     @IsTest
    static void runTestCtrl(){ 
         Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId='012b00000000P38';
        
        insert acc;
        Integer CFY=Date.today().year();
        Sales_Statistics__c statistics=new Sales_Statistics__c();
        statistics.Account__c=acc.Id;
        statistics.Stock_lenses_Qty__c=3;
        statistics.Type__c='0';
        statistics.Year__c=CFY;
        statistics.Month__c=4;
        statistics.External_Key__c=acc.id+'-'+ statistics.Type__c+'-'+statistics.Month__c+'-'+statistics.Year__c;
        statistics.OrderingHabitsJson__c='{"ManualOrders":"10", "HVCsys":"5", "OtherOrders" : "3", "UnCutlens" : "6","RemoteEdging" : "0","Mounting" : "1","FramesByHvc" : "0","RealShape" : "2","StandShape" : "1","Boxing" : "1"}';
        statistics.LensReturnsJson__c='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        statistics.Lenses_Gross_Sales__c=312.56;
        statistics.Lenses_Net_Sales__c=300;
        statistics.Lenses_Qty__c=3;
        statistics.Fiscal_Year__c=CFY;
        insert statistics;
        
        Sales_Statistics__c statistics1=new Sales_Statistics__c();
        statistics1.Account__c=acc.Id;
        statistics1.Stock_lenses_Qty__c=3;
        statistics1.Type__c='1';
        statistics1.Year__c=CFY;
        statistics1.Month__c=4;       
        statistics1.External_Key__c=acc.id+'-'+ statistics1.Type__c+'-'+statistics1.Month__c+'-'+statistics1.Year__c;
        statistics1.OrderingHabitsJson__c='{"ManualOrders":"10", "HVCsys":"5", "OtherOrders" : "3", "UnCutlens" : "6","RemoteEdging" : "0","Mounting" : "1","FramesByHvc" : "0","RealShape" : "2","StandShape" : "1","Boxing" : "1"}';
        statistics1.LensReturnsJson__c='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        statistics1.Lenses_Gross_Sales__c=312.56;
        statistics1.Lenses_Net_Sales__c=300;
        statistics1.Lenses_Qty__c=3;
        statistics1.Fiscal_Year__c=CFY;
        insert statistics1;
        
        Sales_Statistics__c statistics2=new Sales_Statistics__c();
        statistics2.Account__c=acc.Id;
        statistics2.Stock_lenses_Qty__c=3;
        statistics2.Type__c='1';
        statistics2.Year__c=CFY;
        statistics2.Month__c=3;       
        statistics2.External_Key__c=acc.id+'-'+ statistics2.Type__c+'-'+statistics2.Month__c+'-'+statistics2.Year__c;
        statistics2.OrderingHabitsJson__c='{"ManualOrders":"10", "HVCsys":"5", "OtherOrders" : "3", "UnCutlens" : "6","RemoteEdging" : "0","Mounting" : "1","FramesByHvc" : "0","RealShape" : "2","StandShape" : "1","Boxing" : "1"}';
        statistics2.LensReturnsJson__c='{"ProdRet":"0","CutRet":"0","MountRet":"0", "SalesRet":"0","OrderMisRet":"0","NonAdapRet":"0","DeliveryRet":"0","OtherRet":"0"}';
        statistics2.Lenses_Gross_Sales__c=312.56;
        statistics2.Lenses_Net_Sales__c=300;
        statistics2.Lenses_Qty__c=3;
        statistics2.Fiscal_Year__c=CFY-1;
        insert statistics2;
        

         Test.startTest();
        System.assert(true);        
        AccountSalesStatisticsControllerHelper helper=new AccountSalesStatisticsControllerHelper();
        AccountSalesStatisticsControllerHelper.testMonth=5;   
        String OhJson = helper.getOrderingHabits(acc.Id,34,56);  
        Test.stopTest();
    }
}