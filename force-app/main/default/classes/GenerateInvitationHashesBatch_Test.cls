@isTest
public with sharing class GenerateInvitationHashesBatch_Test {
    
    @TestSetup
    static void makeData(){
        Account a = new Account(
            Name = 'Test Account',
            Hoya_Account_ID__c = 'DE123456'
        );
        insert a;

        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
        Contact c = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            RecordTypeId = recordTypeId,
            AccountId = a.Id
        );
        insert c;
    }

    @isTest
    static void testBatch() {
        Contact c = [SELECT Id, Registration_Invitation_Hash__c FROM Contact LIMIT 1];
        c.Registration_Invitation_Hash__c = null;
        update c;

        Test.startTest();
        GenerateInvitationHashesBatch hashBatch = new GenerateInvitationHashesBatch();
        Database.executeBatch(hashBatch);
        Test.stopTest();
        c = [SELECT Id, Registration_Invitation_Hash__c FROM Contact LIMIT 1];
        system.assertNotEquals(null, c.Registration_Invitation_Hash__c, 'Hash recreated using batch');
    }

}