@isTest
public with sharing class WS_GetContacts_Test {

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact'
        );
        insert ct;
    }

    @isTest
    static void testWS() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetContacts';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GetContacts.getContacts();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // bad accountId
        JSONDeserializer deser = new JSONDeserializer();
        deser.accountId  = 'asdsadsa';
		String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetContacts.getContacts();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));

        // missing field
        deser.accountId  = [SELECT Id FROM Account LIMIT 1].Id;
		myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetContacts.getContacts();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (accountId or getAll)', responseBody);

        // 200 OK
        deser.getAll = false;
        myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetContacts.getContacts();
        system.debug('systemdebug_test---: '+response.statusCode);
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);
    }
    
    private class JSONDeserializer {
        private String accountId {
            get; 
            set;
        }
        private boolean getAll {
            get;
            set;
        }
    }
}