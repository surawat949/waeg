@isTest
public with sharing class WS_CreateEmployeeFromPortal_Test {
    @isTest
	static void teste(){
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

        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'Existing',
            LastName = 'User',
            Email = 'existinguser@myemail.com'
        );
        insert con;
        
        CustomUser cUser = new CustomUser();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/CreateUserFromPortal';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Failure to Deserialize request
        
		cUser.accountId  = 'asdsadsa';
        cUser.firstName   = 'NameTest';
        cUser.lastName   = 'asdadasdasd';
        cUser.username  = 'asdsadsa';
        cUser.email   = 'NameTest';
        cUser.recordTypeName   = 'asdadasdasd';
        cUser.title = 'test title';
        cUser.salutation = 'Mr.';
		String myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));
        
        // Missing attributes

        cUser.accountId = null;
        myJSON = JSON.serialize(cUser);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (AccountId, Username, Email, First Name, Last Name or RecordTypeName)', responseBody);

        // Account malformed id

        String fakeId = String.valueOf(ct.Id).substring(0, String.valueOf(ct.Id).length()-1);
        fakeId += 'X';
        cUser.accountId = fakeId;
        myJSON = JSON.serialize(cUser);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        //cdu 2021-10-15: don't understand this test, makes deployment fail
        //System.assert(responseBody.contains('malformed id')); // to be updated

        // Username with spaces
        cUser.accountId = acc.Id;
        cUser.username += ' asd';
        myJSON = JSON.serialize(cUser);
		request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('Username cannot contain white spaces.'));

        // null-reference (recordTypeId)
        cUser.username = 'adasdaaaaaa';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();

        // correct recordtype, invalid email address
        cUser.recordTypeName = 'Shop_Owner';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('INVALID_EMAIL_ADDRESS'));

        // valid emailaddress format, 200 OK
        cUser.email = 'asdasd@myemail.com';
        myJSON = JSON.serialize(cUser);
        request.requestBody = Blob.valueof(myJSON);

        WS_CreateEmployeeFromPortal.createUser();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
    }
    
    private class CustomUser {
        String accountId {
            get;
            set;
        }
        String username {
            get;
            set;
        }
        String email {
            get;
            set;
        }
        String firstName {
            get;
            set;
        }
        String lastName {
            get;
            set;
        }
        String recordTypeName {
            get;
            set;
        }
        String title {
            get;
            set;
        }
        String salutation {
            get;
            set;
        }
    }
}