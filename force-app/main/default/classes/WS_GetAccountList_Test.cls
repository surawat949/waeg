@isTest
public with sharing class WS_GetAccountList_Test {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Account childAccount = new Account(
            Name = 'child Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com',
            ParentId = acc.Id
        );
        insert childAccount;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'ForTest'
        );
        insert ct;
    }
    @isTest
    static void testWS() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetAccountList';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GetContacts.getContacts();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        Contact contact = [select id,FirstName,LastName, AccountId from Contact where Lastname='ForTest' limit 1];

        JSONDeserializer deser = new JSONDeserializer();
        deser.contactId = contact.Id;
		String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);
        WS_GetAccountList.getAccountList();
        System.debug('systemdebug_test---: '+response.statusCode);
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);
    }
    
    private class JSONDeserializer {
        Id contactId {
            get;
            set;
        }
    }
}