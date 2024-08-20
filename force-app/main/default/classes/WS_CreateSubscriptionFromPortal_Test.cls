@isTest
public class WS_CreateSubscriptionFromPortal_Test {

    @isTest
    static void testSubMethod(){
        
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;
        
        SubRecord json1 = new SubRecord();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/CreateSubscriptionFromPortal';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        WS_CreateSubscriptionFromPortal.createSubscription();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);
        
        // Failure to Deserialize request
        
		json1.accountId = 'qwqwqw';
        json1.subscriptionType = 'qwwq';
        json1.operation = 'qwqw';
        json1.email = 'qwqw';
		String myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateSubscriptionFromPortal.createSubscription();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));
        
        // Missing attributes

        json1.accountId = null;
        myJSON = JSON.serialize(json1);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateSubscriptionFromPortal.createSubscription();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (AccountId, subscriptionType, email or Operation)', responseBody);
        
        // no record to deactivate
        json1.operation = 'DEACTIVATE';
        json1.accountId = acc.Id;
        json1.subscriptionType = 'Track and Trace';
        json1.email = 'abc@abc.com';
        myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);
        WS_CreateSubscriptionFromPortal.createSubscription();
        
        //activate new record
        json1.operation = 'ACTIVATE';
		myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);
        WS_CreateSubscriptionFromPortal.createSubscription();
        
        // deactivate existing record
        json1.operation = 'DEACTIVATE';
        myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);
        WS_CreateSubscriptionFromPortal.createSubscription();
        
        // activate existing record
        String CONTACT_SUBSCRIPTION_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact',
            RecordTypeId = CONTACT_SUBSCRIPTION_RT,
            Subscription_Type__c = 'Track and Trace'
        );
        insert ct;
        json1.operation = 'ACTIVATE';
        myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);
        WS_CreateSubscriptionFromPortal.createSubscription();
        
        // invalid operation
        json1.operation = 'OTHER';
        myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);
        WS_CreateSubscriptionFromPortal.createSubscription();
        
        //constructor
        WS_CreateSubscriptionFromPortal c =  new WS_CreateSubscriptionFromPortal();
        
    }
    private class SubRecord {
        string accountId {get; set;}
        string subscriptionType {get; set;}
        string operation {get;set;}
        String email {get;set;}
    }
}