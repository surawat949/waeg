@IsTest
public class V2LeadDetailControllerTest {
    @TestSetup
    static void setupData() {
        Id independentsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
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
        insert seiko;
        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Test Company',
            RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Lead').getRecordTypeId(),
            Submit_To__c = UserInfo.getUserId(),
            Contact_Role__c = 'Shop Owner',
            Status = 'Information Collection',
            Account_ID__c = seiko.Id
        );
        insert lead;
    }
    
    @IsTest
    static void testUpdateCompetitor() {
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        Test.startTest();
            V2LeadDetailController.UpdateCompetitor(lead.Id, 'Competitor A', 'Competitor B');
        Test.stopTest();        
    }
    
    @IsTest
    static void testChangeLeadStatus() {
        Lead lead = [SELECT Id, Company, Status FROM Lead LIMIT 1];        
        Test.startTest();
            Task taskRec = V2LeadDetailController.changeLeadStatus(lead.Id);
        Test.stopTest();
    }
    
    @IsTest
    static void testChangeLeadStatusToAccountCreated() {
        Lead lead = [SELECT Id, Status FROM Lead LIMIT 1];        
        Test.startTest();
            Task taskRec = V2LeadDetailController.changeLeadStatusToAccountCreated(lead.Id);
        Test.stopTest();
    }
    
    @IsTest
    static void testFetchRecords() {
        Lead currentLeadRec = [Select Id,Submit_To__c,Account_ID__c From Lead Limit 1];
        V2LeadDetailController.SearchWrapper wrapper = new V2LeadDetailController.SearchWrapper();
        wrapper.objectApiName = 'Account';
        wrapper.searchString = 'Test';
        wrapper.fieldApiName = 'Name';
        wrapper.selectedRecordId = null;
        wrapper.recordId = currentLeadRec.Id;
        Test.startTest();
            List<V2LeadDetailController.ResultWrapper> results = V2LeadDetailController.fetchRecords(wrapper);
        Test.stopTest();
    }
    
    @IsTest
    static void testConvertLead() {
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        Event eventRec = new Event();
        eventRec.WhoId = lead.Id; 
        eventRec.Type__c = 'Direct Visit'; 
        eventRec.StartDateTime = System.now();
        eventRec.EndDateTime = System.now() + 1;
        eventRec.IsAllDayEvent = true;
        eventRec.Description = 'Test record';
        eventRec.Status__c = 'Planned';  
        insert eventRec;
        Test.startTest();
            String accountId = V2LeadDetailController.convertLead(lead.Id);
        Test.stopTest();
    }
    
    @IsTest
    static void testRejectLeadCloseRelatedTasks() {
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        Test.startTest();
            V2LeadDetailController.RejectLeadCloseRelatedTasks(lead.Id);
        Test.stopTest();
    }
    @IsTest
    static void testGetReportEventsTest() {
        V2LeadDetailController.getDefaultRecordTypeForEvents('Lead_Visits');
    }
    @IsTest
    static void testGetReportEvents() {
        Lead lead = [SELECT Id FROM Lead LIMIT 1];
        Event eventRec = new Event();
        eventRec.WhoId = lead.Id; 
        eventRec.Type__c = 'Direct Visit'; 
        eventRec.StartDateTime = System.now();
        eventRec.EndDateTime = System.now() + 1;
        eventRec.IsAllDayEvent = true;
        eventRec.Description = 'Test record';
        eventRec.Status__c = 'Planned';  
        insert eventRec;
        Test.startTest();
            V2LeadDetailController.getReportEvents(lead.Id);
        Test.stopTest();
    }
}