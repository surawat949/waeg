@RestResource(urlMapping = '/DeleteSession')
global with sharing class WS_DeleteSession {
    
    @HttpPost
    global static void deleteSession() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        CustomUser usr;
        try {
            usr = (CustomUser) JSON.deserialize(userJson, CustomUser.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }

        if (String.isBlank(usr.contactId)) {
            res.responseBody = Blob.valueOf('Missing Fields (contactId)');
            res.statusCode = 400;
            return;
        }

        try {
            User u = [SELECT Id FROM User WHERE ContactId = :usr.contactId];
            delete [select Id from AuthSession where UsersId = :u.Id];
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }
    }

    global class CustomUser {
        public Id contactId {
            get;
            set;
        }
    }
}