@RestResource(urlMapping = '/GenerateResetToken')
global with sharing class WS_GenerateResetUserPasswordToken {

    @HttpPost
    global static void generateToken() {
        RestResponse res = RestContext.response;
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String stringJson = RestContext.request.requestBody.toString();
        JSONDeserializer d;
        try {
            d = (JSONDeserializer) JSON.deserialize(stringJson, JSONDeserializer.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        List<Community_Setting__mdt> cs = [SELECT Value__c FROM Community_Setting__mdt WHERE QualifiedApiName = 'Username_Suffix' limit 1];
        if (cs.isEmpty()) {
            res.responseBody = Blob.valueOf('Suffix username setting not found. Please contact your Salesforce administrator.');
            res.statusCode = 500;
            return;
        }
        String username = d.username+cs[0].Value__c;
        String inviteEmail = d.systemInvitationEmail;
        System.debug('### username, systemInvitationEmail=' + d.username +','+d.systemInvitationEmail);
        List<Configuration__c> SysConfig = [SELECT Id, Number_Value__c FROM Configuration__c WHERE Name = 'Token_Expiration' LIMIT 1];
        try {
            User usr = [SELECT Id, Reset_Password_Token__c, Reset_Password_Token_Expiration__c, ContactId FROM User WHERE Username = :username or communitynickname=:username ];
            System.debug('### USR = ?' + usr.Id);
            String getTime = string.valueOf(Datetime.Now().getTime()/1000); 
            Blob requestBlob = Blob.valueOf(usr.Id+getTime);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String hashString = EncodingUtil.convertToHex(hash);
            System.debug('### hashString = ' + hashString);
            usr.Reset_Password_Token__c = hashString;
            System.debug('### usr.Reset_Password_Token__c = ' + usr.Reset_Password_Token__c);
            usr.Reset_Password_Token_Expiration__c = Datetime.Now().addMinutes(Integer.valueOf(SysConfig[0].Number_Value__c));
            System.debug('XXX Update User ' + usr.Id);
            update usr;
            //CDU 19/10/2021 - 3rd party registration, appius now send system invitation email parameter. optionnal
            System.debug('### systemInvitationEmail=' + d.systemInvitationEmail);
            if(d.systemInvitationEmail!=null && d.systemInvitationEmail!=''){
                Contact c = [select id, FirstName, LastName,Invite_Portal_Email__c from Contact where id=:usr.ContactId];
                c.Invite_Portal_Email__c = d.systemInvitationEmail;
                System.debug('XXX Update User ' + c.Id);
                update c;
            }
            res.responseBody = Blob.valueOf('1');
            res.statusCode = 200;
            System.debug('### END - OK');
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
    }

    private class JSONDeserializer {
        String username {get;set;}
        String systemInvitationEmail {get;set;}
    }

}