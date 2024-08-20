@RestResource(urlMapping = '/CheckUsername')
global with sharing class WS_CheckUsername {

    @HttpPost
    global static void checkUsername() {
        RestResponse res = RestContext.response;
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        JSONDeserializer j;
        Community_Setting__mdt cs;
        try {
            j = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
            cs = [SELECT Value__c FROM Community_Setting__mdt WHERE QualifiedApiName = 'Username_Suffix' limit 1];
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            system.debug('res 2 - fail of json deserialize: '+res);
            return;
        }
        
        String username = j.username + cs.Value__c;
        integer count = database.countQuery('SELECT count() FROM User WHERE Username = :username');
        res.responseBody = Blob.valueOf(JSON.serialize(count));
        res.statusCode = 200;
    }

    private class JSONDeserializer {
        String username {
            get;
            set;
        }
    }

}