@isTest
public with sharing class WS_VerifyRegistrationToken_Test {
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
            LastName = 'Contact',
            Email = 'test@email.com'
        );
        insert ct;
    }

    @isTest
    static void testRegToken() {
        JSONDeserializer deser = new JSONDeserializer();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/VerifyToken';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;

        // No Body 400
        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Missing parameter
        deser.token = 'asdasxcxasdsa123123zx';
        String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueOf(myJSON);

        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (token or checkType)', responseBody);

        // Registration checkType, invalid token
        deser.checkType = 'Registration';
        myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueOf(myJSON);

        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('0', responseBody);

        // 200 OK with contact Id

        Contact c = [SELECT Id, Registration_Invitation_Hash__c FROM Contact LIMIT 1];
        deser.token = c.Registration_Invitation_Hash__c;
        myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueOf(myJSON);

        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals(c.Id, responseBody);
    }

    private class JSONDeserializer {
        String token {
            get;
            set;
        }

        String checkType {
            get;
            set;
        }
    }
}