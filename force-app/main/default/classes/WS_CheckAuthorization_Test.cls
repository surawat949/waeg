@isTest
public with sharing class WS_CheckAuthorization_Test {
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    public WS_CheckAuthorization_Test() {

    }

    @isTest
    static void testSubMethod(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;
        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact'
        );
        insert ct;
        Authorization__c copyDuplicate = new Authorization__c(
            Copy_From__c = master.Id,
            claim_formatted__c = 'accesstoportal',
             Active_Authorization__c = true,
            recordTypeId = AUTHORIZATION_COPY_RT,
            Contact__c = ct.Id
        );
        insert copyDuplicate;


        AuthDetails json1 = new AuthDetails();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/CheckAuthorization';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        WS_CheckAuthorization.checkAuthorization();
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);
        
        
        json1.contactId = 'qwqwqw';
        json1.claimFormatted = 'qwwq';
		String myJSON = JSON.serialize(json1);
        request.requestBody = Blob.valueof(myJSON);

        WS_CheckAuthorization.checkAuthorization();
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));
        
        //missing fields
        json1.contactId = null;
        myJSON = JSON.serialize(json1);
		request.requestBody = Blob.valueof(myJSON);
        WS_CheckAuthorization.checkAuthorization();
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (ContactId or claimFormatted)', responseBody);
        
        //Success scenario
        json1.contactId = ct.Id;
        json1.claimFormatted = copyDuplicate.claim_formatted__c;
        myJSON = JSON.serialize(json1);
		request.requestBody = Blob.valueof(myJSON);
        WS_CheckAuthorization.checkAuthorization();
        responseBody = response.responseBody.toString();
        
        //does not exists scenario
        json1.contactId = ct.Id;
        json1.claimFormatted = 'abcpqe';
        myJSON = JSON.serialize(json1);
		request.requestBody = Blob.valueof(myJSON);
        WS_CheckAuthorization.checkAuthorization();
        responseBody = response.responseBody.toString();
        
        
    }

    private class AuthDetails {
        public String contactId {get;set;}
        public String claimFormatted {get;set;}
    }
}