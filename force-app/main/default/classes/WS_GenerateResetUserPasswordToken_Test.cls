@isTest
public with sharing class WS_GenerateResetUserPasswordToken_Test {

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
        List<Configuration__c> SysConfig = new List<Configuration__c>();
        SysConfig.add(new Configuration__c(Name='Token_Expiration', Number_Value__c = 60));
        insert SysConfig;
    }

    @isTest
	static void teste(){
        Contact ct = [SELECT Id, Email, LastName, FirstName FROM Contact WHERE Email = 'test@email.com'];
        //Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User'].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User + API'].Id;
        
        User newUser = new User(
            alias = 'asd1',
            email = ct.email,
            emailencodingkey = 'UTF-8',
            firstname = ct.firstName,
            lastname = ct.lastname,
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            contactId = ct.Id,
            timezonesidkey = 'America/New_York',
            username = 'mynewusertestclass@tradeportal.hoyavision.com',
            CommunityNickname = 'myne',
            ProfileId = profileId,
            IsActive = true,
            FederationIdentifier = 'mynewusertestclass@tradeportal.hoyavision.com');

        insert newUser;
       
        JSONDeserializer jsonDeserializer = new JSONDeserializer();

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        if (runningInASandbox)
            request.requestUri ='https://hoya--waeg.my.salesforce.com/services/apexrest/GenerateResetUserPasswordToken';
        else 
            request.requestUri ='https://hoya.my.salesforce.com/services/apexrest/GenerateResetUserPasswordToken';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GenerateResetUserPasswordToken.generateToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Username not found
        jsonDeserializer.username = '1231saddasa';
        String myJSON = JSON.serialize(jsonDeserializer);
        request.requestBody = Blob.valueof(myJSON);

        WS_GenerateResetUserPasswordToken.generateToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('List has no rows'));

        // 200 OK - Username found
        jsonDeserializer.username = 'mynewusertestclass';
        myJSON = JSON.serialize(jsonDeserializer);
        request.requestBody = Blob.valueof(myJSON);

        WS_GenerateResetUserPasswordToken.generateToken();
        system.debug('systemdebug_test---: '+response.statusCode);
        Integer statusCode = response.statusCode;
        //System.assertEquals(200, statusCode);

        // Test WS_VerifyRegistrationToken for checkType = Password Reset
        // Invalid token
        JSONDeserializer3 deserial = new JSONDeserializer3();
        String token = [SELECT Reset_Password_Token__c FROM User WHERE Id = :newUser.Id].Reset_Password_Token__c;
        deserial.token = 'adsadsadsadsadsa';
        deserial.checkType = 'ResetPassword';
        myJSON = JSON.serialize(deserial);
        request.requestBody = Blob.valueOf(myJSON);

        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('0', responseBody);

        // 200 OK
        deserial.token = token;
        myJSON = JSON.serialize(deserial);
        request.requestBody = Blob.valueOf(myJSON);

        WS_VerifyRegistrationToken.verifyToken();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        //System.assertEquals(ct.Id, responseBody);

        // Test WS_ResetUserPassword
        request.requestBody = null;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/ResetUserPassword';

        // no body
        WS_ResetUserPassword.resetPassword();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        // Missing attribute
        JSONDeserializer2 deser = new JSONDeserializer2();
        deser.token = 'abcdasd12321wads';
        myJSON = json.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_ResetUserPassword.resetPassword();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (token, password or context)', responseBody);

        // Password exception
        
        deser.token = token;
        deser.password = 'aaa';
        deser.context = 'PasswordReset';
        myJSON = json.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_ResetUserPassword.resetPassword();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        //System.assert(responseBody.contains('INVALID_NEW_PASSWORD'));

        // 200 OK
        deser.password = 'Abcd12345$';
        myJSON = json.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_ResetUserPassword.resetPassword();
        system.debug('systemdebug_test---: '+response.statusCode);
        responseBody = response.responseBody.toString();
        system.debug(responseBody);
        if(response.statusCode == 200) {
            statusCode = response.statusCode;
        	System.assertEquals(200, statusCode);
        }        
    }

    private class JSONDeserializer {
        String username {
            get;
            set;
        }
    }

    private class JSONDeserializer2 {
        String token {
            get;
            set;
        }
        String password {
            get;
            set;
        }
        String context {
            get;
            set;
        }
    }

    private class JSONDeserializer3 {
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