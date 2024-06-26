@isTest
public class VisitsPlannedAutomationBatchTest {

    @TestSetup
    static void makeData() {
        Id chainRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain').getRecordTypeId();
        Id independentsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
        List<Account> acctList = new List<Account>();
        Account hvnaAcc = new Account();
        hvnaAcc.Hoya_Account_ID__c = 'US1234512';
        hvnaAcc.CurrencyIsoCode = 'EUR';
        hvnaAcc.Name = 'HVNA Test';
        hvnaAcc.RecordTypeId = chainRecordTypeId;
        hvnaAcc.Agreed_Visits__c = null;
        hvnaAcc.Agreed_No_of_Digital_Visits__c = null;
        hvnaAcc.Requested_Direct_Visits__c = 0;
        hvnaAcc.Requested_Digital_Visits__c = 0;
        hvnaAcc.Strategic_Value_Net_Sales__c = 1;
        acctList.add(hvnaAcc);

        Account seiko = new Account();
        seiko.Hoya_Account_ID__c = 'SO1234512';
        seiko.CurrencyIsoCode = 'EUR';
        seiko.Name = 'SEIKO1 Test';
        seiko.RecordTypeId = independentsRecordTypeId;
        seiko.Agreed_Visits__c = null;
        seiko.Agreed_No_of_Digital_Visits__c = null;
        seiko.Requested_Direct_Visits__c = 0;
        seiko.Requested_Digital_Visits__c = 0;
        seiko.Strategic_Value_Net_Sales__c = 1;
        acctList.add(seiko);
        insert acctList;

        SFDC_V2_Configurations__c sobj = new SFDC_V2_Configurations__c(
            Type__c = 'Visit Planning Automation',
            Segmentation__c = 'UNCATEGORIZED',       
            Direct_Visits_Planned__c = 8, 
            Digital_Visits_Planned__c = 2 
        );
        insert sobj;
    }

    @isTest
    static void testVisitsPlannedAutomationBatch() {
        Test.startTest();
        // Start the batch job
        VisitsPlannedAutomationBatch batchJob = new VisitsPlannedAutomationBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
    }

    @isTest
    static void testVisitsPlannedAutomationBatchSchedulable() {
        Test.startTest();
        // Schedule the job
        String jobId = System.schedule('Test Schedule Job', '0 0 0 1 1 ?', new VisitsPlannedAutomationBatch());
        // Verify the scheduled job
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        Test.stopTest();
    }
}