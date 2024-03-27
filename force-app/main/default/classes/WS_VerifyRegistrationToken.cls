@RestResource(urlMapping = '/VerifyToken')
global with sharing class WS_VerifyRegistrationToken {

    @HttpPost
    global static void verifyToken() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        JSONDeserializer j;
        List<Contact> contactList;
        List<User> userList;
        try {
            j = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
            if (String.isBlank(j.token) || String.isBlank(j.checkType)) {
                res.responseBody = Blob.valueOf('Missing Fields (token or checkType)');
                res.statusCode = 500;
                return;
            }
            if (j.checkType == 'Registration') {
                contactList = [SELECT Id FROM Contact WHERE Registration_Invitation_Hash__c = :j.token];
                if (!contactList.isEmpty()) {
                    res.responseBody = Blob.valueOf(contactList[0].Id);
                    res.statusCode = 200;
                    return;
                } else {
                    res.responseBody = Blob.valueOf('0');
                    res.statusCode = 200;
                    return;
                }
            }
            else if (j.checkType == 'ResetPassword') {
                userList = [SELECT Id, ContactId FROM User WHERE Reset_Password_Token__c = :j.token AND Reset_Password_Token_Expiration__c > :System.now()];
                if (!userList.isEmpty()) {
                    res.responseBody = Blob.valueOf(userList[0].ContactId);
                    res.statusCode = 200;
                    return;
                } else {
                    res.responseBody = Blob.valueOf('0');
                    res.statusCode = 200;
                    return;
                }
            }
            else {
                res.responseBody = Blob.valueOf('Invalid checkType value.');
                res.statusCode = 500;
                return;
            }
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
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