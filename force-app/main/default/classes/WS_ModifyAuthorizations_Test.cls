@isTest
public with sharing class WS_ModifyAuthorizations_Test {
    
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    public WS_ModifyAuthorizations_Test() {

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
            claim_formatted__c = 'accessToPortal',
            active_authorization__c = true,
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;
        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact'
        );
        insert ct;

        ChangeRequest reqWrapper = new ChangeRequest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/ModifyAuthorizations';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        WS_ModifyAuthorizations.modifyAuthorizations();
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);
        
        // incorrect request body
        request.requestBody = Blob.valueof('{contact:}');
        WS_ModifyAuthorizations.modifyAuthorizations();
        responseBody = response.responseBody.toString();
        
        //missing fields
        reqWrapper.contactId = null;
        String myJSON = JSON.serialize(reqWrapper);
		request.requestBody = Blob.valueof(myJSON);
        WS_ModifyAuthorizations.modifyAuthorizations();
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (ContactId or AuthsMap)', responseBody);
        
        // actual success scenario
        reqWrapper.contactId = ct.Id;
        Map<String, Boolean> authsMap = new Map<String, Boolean>();
        authsMap.put('accessToPortal', true);
        reqWrapper.authsmap = authsMap.clone();
        myJSON = JSON.serialize(reqWrapper);
		request.requestBody = Blob.valueof(myJSON);
        WS_ModifyAuthorizations.modifyAuthorizations();
        
        //claim not found
        reqWrapper.contactId = ct.Id;
        authsMap.put('accessToPort', true);
        reqWrapper.authsmap = authsMap.clone();
        myJSON = JSON.serialize(reqWrapper);
		request.requestBody = Blob.valueof(myJSON);
        WS_ModifyAuthorizations.modifyAuthorizations();
    }

    public class ChangeRequest {
        public Id contactId {get;set;}
        Map<String, Boolean> authsMap {get;set;}
    }

}