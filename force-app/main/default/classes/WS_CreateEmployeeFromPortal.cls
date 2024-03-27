@RestResource(urlMapping = '/CreateEmployeeFromPortal')
global with sharing class WS_CreateEmployeeFromPortal {

    @HttpPost
    global static void createUser() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        JSONDeserializer usr;
        try {
            usr = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
            system.debug('user: '+usr);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }

        if (String.isBlank(usr.accountId) || String.isBlank(usr.username) || String.isBlank(usr.email) || String.isBlank(usr.firstName) || String.isBlank(usr.lastName) || String.isBlank(usr.recordTypeName) ) {
            res.responseBody = Blob.valueOf('Missing Fields (AccountId, Username, Email, First Name, Last Name or RecordTypeName)');
            res.statusCode = 400;
            return;
        }
        if(usr.username.contains(' ')) {
            res.responseBody = Blob.valueOf('Username cannot contain white spaces.');
            res.statusCode = 400;
            return;
        }
        Account a;
        try {
            a = [SELECT Id, Portal__c, OwnerId, Owner.UserRoleId, language__c FROM Account WHERE Id = :usr.accountId];
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        if (String.isBlank(a.Owner.UserRoleId)) {
            res.responseBody = Blob.valueOf('Account Owner has no Role assigned and the user cannot be created. Contact your salesforce administrator.');
            res.statusCode = 500;
            return;
        }
        Contact con;
        Savepoint sp = Database.setSavepoint();
        try {
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(usr.recordTypeName).getRecordTypeId();

            String invitePortal = 'HOYA Learning Center';

            if(a.Portal__c != '' && a.Portal__c != null){
                invitePortal = 'HOYA Hub';
                if(a.Portal__c.contains('seiko')){
                    invitePortal = 'Seiko Pro';
                }
                if(a.Portal__c.contains('lms')){
                    invitePortal = 'HOYA Learning Center';
                }
                //CDU 05/07/2021: Contact lenses system invitation email
                if(a.Portal__c.contains('Contact Lenses')){//HOYA Contact Lenses
                    invitePortal = 'HOYA Contact Lenses';
                }
            }

            //CDU 19/10/2021 - 3rd party registration, appius now send system invitation email parameter. optionnal
            if(usr.systemInvitationEmail!=null && usr.systemInvitationEmail!=''){
                invitePortal = usr.systemInvitationEmail;
            }

            String language = a.language__c;
            if(usr.language!=null && usr.language!=''){
                language = usr.language;
            }
            if (String.isBlank(usr.contactId)) {
                con = new Contact(
                FirstName = usr.firstName,
                LastName = usr.lastName,
                Email = usr.Email,
                AccountId = usr.accountId,
                RecordTypeId = recordTypeId,
                Phone = usr.Phone,
                Salutation = usr.salutation,
                Title = usr.title,
                Created_on_portal__c = true,
                Invite_Portal_Email__c = invitePortal,
                Language_Pick__c = usr.language
                );
                
                if(!String.isBlank(usr.environment)) {
                    Set<String> environments = new Set<String> {'MAIN','BUILD','UAT'};
                    string environmentUpper = usr.environment.toUpperCase();
                    if (environments.contains(environmentUpper)) {
                        con.Test_Environment__c = environmentUpper;
                    }
                }
                insert con;
            } else {
                con = [Select Id, FirstName, LastName, Email, AccountId, Phone, Salutation, Title, Created_on_portal__c, Invite_Portal_Email__c, Language_Pick__c From Contact Where Id =: usr.contactId limit 1];
                if (con != null) {
                    con.Created_on_portal__c = true;
                    con.Invite_Portal_Email__c = invitePortal;
                    update con;
                }
            }
            
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            Database.rollback(sp);
            return;
        }

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;
        dmo.EmailHeader.triggerOtherEmail = false;
        dmo.EmailHeader.triggerAutoResponseEmail = false;
        Id profileId;
        try {
            //profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User'].Id;
            profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User + API'].Id;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            Database.rollback(sp);
            return;
        }

        // create portal user
        User newUser;
        try {
            string alias = '';
            if (con.LastName.length() >= 4) {
                alias = con.FirstName.substring(0, 1) + con.LastName.substring(0, 4);
            } else {
                alias = con.FirstName.substring(0, 1) + con.LastName;
            }
            string nick = usr.username;
            Community_Setting__mdt cs = [SELECT Value__c FROM Community_Setting__mdt WHERE QualifiedApiName = 'Username_Suffix' limit 1];
            String username = usr.username+cs.Value__c;
            integer existingUsers = database.countQuery('SELECT count() FROM User WHERE Username = :username OR FederationIdentifier = :username');
            if (existingUsers > 0) {
                res.responseBody = Blob.valueOf('A user with the specified username already exists in the system.');
                res.statusCode = 500;
                Database.rollback(sp);
                return;
            }
            newUser = new User(
                alias = alias,
                email = con.email,
                emailencodingkey = 'UTF-8',
                firstname = con.firstName,
                lastname = con.lastname,
                languagelocalekey = 'en_US',
                localesidkey = 'en_US',
                contactId = con.Id,
                Phone = con.Phone,
                timezonesidkey = 'America/New_York',
                username = username,
                CommunityNickname = nick,
                ProfileId = profileId,
                IsActive = true,
                FederationIdentifier = username
                );

            String getTime = string.valueOf(Datetime.Now().getTime()/1000); 
            Blob requestBlob = Blob.valueOf(newUser.username+getTime);
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            String hashString = EncodingUtil.convertToHex(hash);
            newUser.Reset_Password_Token__c = hashString;
            // minutes for 5 days : 5 X 24 X 60 = 7200
            newUser.Reset_Password_Token_Expiration__c = Datetime.Now().addMinutes(7200);

            newUser.setOptions(dmo);
            insert newUser;
            LightningLoginFormController.sendEventToGA(username, '', 'invitation', '');
        } catch (Exception e) {
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            return;
        }
        res.responseBody = Blob.valueOf(JSON.serialize(newUser));
        res.statusCode = 200;
        if (String.isBlank(usr.contactId)) {
                ContactTriggerHelper.assignAllPermissions(new Set<Id> { con.Id }, usr.permissions != null ? usr.permissions : new List<String>());    
                }         
    }

    private class JSONDeserializer {
        Id accountId {
            get;
            set;
        }
        Id contactId {
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
        String phone {
            get;
            set;
        }
        String recordTypeName {
            get;
            set;
        }
        String salutation {
            get; set;
        }
        String title {
            get; set;
        }

        String environment {
            get; set;
        }
        String systemInvitationEmail{get;set;}

        String language {get;set;}
        List<String> permissions {
            get; set;
        }

    }

}