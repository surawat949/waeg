@isTest
public with sharing class WS_getAccountByPhone_test {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'FR012354',
            Billing_Email_address__c = 'account@email.com',
            shippingPostalCode='76530',
            CHINTERNATIONALGROUP__c = 44,
            phone='0102030405'
        );
        insert acc;
    }

    @isTest
    static void testWS(){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/getAccountsByPhone';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;

        JSONinParameter deser = new JSONinParameter();
        deser.customerPhone='0102030405';
        deser.inboundPhone='0232508787';
        String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);
        WS_getAccountsByPhone.getAccountsByPhone();

        system.debug('systemdebug_test---: '+response.statusCode);
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);
    }

    private class JSONinParameter{
        String inboundPhone {get;set;}
        String customerPhone {get;set;}
    }
}