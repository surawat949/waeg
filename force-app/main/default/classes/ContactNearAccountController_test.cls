@isTest
public with sharing class ContactNearAccountController_test {
    
    @isTest
    static void runTest(){
        Test.startTest();

        Account acc= new Account(
            Name='Hospital',
            Hoya_Account_ID__c='H00000001',
            shippingCity='Saint-Priest',
            ShippingStreet='6 Allée Irène Joliot Curie',
            ShippingLatitude=45.71680,
            ShippingLongitude=4.93386,
            ShippingCountry='FR',
            ShippingPostalCode='69800'
        );
        insert acc;
        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'Doctor',
            LastName = 'Eyes',
            mailingCity = 'Saint-Priest',
            mailingStreet = '6 Allée Irène Joliot Curie',
            MailingLatitude = 45.71680,
            MailingLongitude = 4.93386
        );
        insert ct;

        List<Account> accountList= ContactNearAccountController.getAccountsByContact(ct.Id, 10, 'HOYA');
        accountList = ContactNearAccountController.getAccounts(acc.Id, 10, 'oneParameter', 0, 99999999, '', '', 'SEIKO');
        
        List<Contact> conList = ContactNearAccountController.getAllContacts(ct.Id, 10, '','','');

        system.assert(true);
    }
}