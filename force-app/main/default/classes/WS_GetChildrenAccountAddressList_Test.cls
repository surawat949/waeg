@isTest
public with sharing class WS_GetChildrenAccountAddressList_Test {
    public WS_GetChildrenAccountAddressList_Test() {

    }
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
            Hoya_Account_ID__c = '123124',
            Billing_Email_address__c = 'account@email.com',
            ParentId = acc.Id
        );
        insert childAccount;
    }

    @isTest
    static void testWS() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetChildrenAccountAddressList';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GetChildrenAccountAddressList.getAccountList();
        //system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);
        
        Account account = [select id from Account where Hoya_Account_Id__c='123123' limit 1];

        // actual scenario
        JSONDeserializer deser = new JSONDeserializer();
        deser.accountId = account.Id;
		String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);
        WS_GetChildrenAccountAddressList.getAccountList();
        //System.debug('systemdebug_test---: '+response.statusCode);
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);
        
        // JSON conversion error
        request.requestBody = Blob.valueof('{accc:}');
        WS_GetChildrenAccountAddressList.getAccountList();
        
        //constructor
        WS_GetChildrenAccountAddressList gList = new WS_GetChildrenAccountAddressList();
    }
    
    private class JSONDeserializer {
        Id accountId {
            get;
            set;
        }
    }
}