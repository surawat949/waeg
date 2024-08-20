@IsTest
public with sharing class ContactsInAccountHierarchy_test {
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO012354',
            phone='0102030405'
        );
        insert acc;

        Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con1';
        con.AccountId = acc.Id;
        con.recordTypeId = CONTACT_OPTHO_RT;
        insert con;
    }

    @isTest
    static void testAllMethods() {
        Test.startTest();
        List<Account> accountList = [Select Id from Account];
        ContactsInAccountHierarchy.getAllContactsInHierarchy(accountList.get(0).Id);
        ContactsInAccountHierarchy.getRecordTypeIdOpthalmologist();
        Test.stopTest();
    }
}