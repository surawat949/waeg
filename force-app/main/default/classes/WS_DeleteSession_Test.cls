@isTest
public class WS_DeleteSession_Test {

  @isTest
	static void teste(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'Existing',
            LastName = 'User',
            Email = 'existinguser@myemail.com'
        );
        insert con;

        //Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User'].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User + API'].Id;
        User newUser = new User(
            alias = 'asd1',
            email = con.email,
            emailencodingkey = 'UTF-8',
            firstname = con.firstName,
            lastname = con.lastname,
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            contactId = con.Id,
            timezonesidkey = 'America/New_York',
            username = 'mynewusertestclass@tradeportal.hoyavision.com',
            CommunityNickname = 'myne',
            ProfileId = profileId,
            IsActive = true,
            FederationIdentifier = 'mynewusertestclass@tradeportal.hoyavision.com');

        insert newUser;

        JSONDeserialized j = new JSONDeserialized();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/DeleteSession';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;

        // No Body 400
        WS_DeleteSession.deleteSession();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Error with deserialize
        Integer body = 123;
        String myJSON = JSON.serialize(body);
        request.requestBody = Blob.valueof(myJSON);

        WS_DeleteSession.deleteSession();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();    
        System.assert(responseBody.contains('Malformed'));

        j.contactId   = null;
        myJSON = JSON.serialize(j);
        request.requestBody = Blob.valueof(myJSON);

        WS_DeleteSession.deleteSession();
        system.debug('systemdebug_test---: '+response.responseBody.toString());

        j.contactId   = con.Id;
        myJSON = JSON.serialize(j);
        request.requestBody = Blob.valueof(myJSON);

        WS_DeleteSession.deleteSession();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
    }
    
    private class JSONDeserialized {
        string contactId {get; set;}
    }
}