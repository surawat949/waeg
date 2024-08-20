@isTest
public class WS_GetChildrenAccountIdList_Test {
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
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetChildrenAccountIdList';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;    
        Account account = [select id from Account where Hoya_Account_Id__c='123123' limit 1];

        // actual scenario
        JSONDeserializer deser = new JSONDeserializer();
        deser.accountId = account.Id;
		String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);
        WS_GetChildrenAccountIdList.getAccountList();
        
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);
        
        deser.accountId = '';
		myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);
        WS_GetChildrenAccountIdList.getAccountList();
        
        //constructor
        WS_GetChildrenAccountIdList gList = new WS_GetChildrenAccountIdList();
    }
    
    private class JSONDeserializer {
        String accountId {
            get;
            set;
        }
    }
}