@isTest
public class BatchCls_OpticianFinderEligibility_Test {
	@TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'SO0033TESTACC',
            Optician_Finder_Force_Activation__c = 'Force activation'
        );
        insert acc;
        
        Account acc2 = new Account(
            Name = 'Account 2',
            Hoya_account_Id__c = 'SO0033TESTACC2',
            Optician_Finder_Force_Activation__c = 'Force non-activation'
        );
        insert acc2;
        
        Account acc3 = new Account(
            Name = 'Account 3',
            //Optician_Finder_Force_Activation__c = 'Null',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Hoya_account_Id__c = 'SO0033TESTACC3',
            Turnover_Amount__c = 0
        );
        insert acc3;
        
        Last_Sales_Statistics__c stats =  new Last_Sales_Statistics__c();
        stats.Account__c = acc3.Id;
        stats.Lenses_Net_Sales_Last_3Mo_CFY__c = 0;
        insert stats;
        
        Account acc4 = new Account(
            Name = 'Account 4',
            //Optician_Finder_Force_Activation__c = 'Null',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Hoya_account_Id__c = 'SO0033TESTACC4'
        );
        insert acc4;
        
        Last_Sales_Statistics__c stats2 =  new Last_Sales_Statistics__c();
        stats2.Account__c = acc4.Id;
        stats2.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        insert stats2;
        
        Account acc5 = new Account(
            Name = 'Account 5',
            //Optician_Finder_Force_Activation__c = 'Null',
            Hoya_account_Id__c = 'SO0033TESTACC5',
            Optician_Finder_Channel_Decision__c = 'Non-activation'
        );
        insert acc5;
    }
    
    @isTest
    static void opticianBatch(){
        Test.startTest();
        // Database.executeBatch(new BatchCls_OpticianFinderEligibility());
        String sch = '0 0 * * * ?';//0 0 2 * * ?'; 
		system.schedule('Test Check', sch, new BatchCls_OpticianFinderEligibility());
        Test.stopTest();
    }
}