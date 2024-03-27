@isTest
public with sharing class AssignMastersToAllUsersBatch_Test {
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();

    @TestSetup
    static void makeData(){
        User u = [SELECT Id FROM User WHERE CompanyName IN ('HOLI', 'HOLA', 'HLCA', 'HVNA', 'VEUS') AND IsActive = true limit 1];

        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact',
            OwnerId = u.Id
        );
        insert ct;
        
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;

        Authorization__c master2 = new Authorization__c(
            Authorization_Name__c = 'Access to CMS',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master2;
    }

    @isTest
    static void testBatch() {
        List<Authorization__c> masters = [SELECT Id, Claim_Formatted__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_ORIGINAL_RT];
        AssignMastersToAllUsersBatch b = new AssignMastersToAllUsersBatch(masters);
		Database.executeBatch(b, 200);
    }
}