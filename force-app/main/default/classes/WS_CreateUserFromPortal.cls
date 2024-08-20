@RestResource(urlMapping = '/CreateUserFromPortal')
global with sharing class WS_CreateUserFromPortal {

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
        CustomUser usr;
        try {
            usr = (CustomUser) JSON.deserialize(userJson, CustomUser.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }

        if (String.isBlank(usr.contactId) || String.isBlank(usr.username) || String.isBlank(usr.password)) {
            res.responseBody = Blob.valueOf('Missing Fields (ContactId, Username or Password)');
            res.statusCode = 400;
            return;
        }
        System.debug('Before contact');
        Contact con;
        try {
            con = [SELECT Id, email, firstName, lastname, Account.Owner.UserRoleId FROM Contact WHERE Id = :usr.contactId];
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            System.debug('contact e' + JSON.serialize(e));
            LogException.log(e);
            return;
        }
        if (String.isBlank(con.Account.Owner.UserRoleId)) {
            res.responseBody = Blob.valueOf('Account Owner has no Role assigned and cannot create the user. Contact your salesforce administrator.');
            res.statusCode = 500;
            System.debug('Account Owner has no Role assigned and cannot create the user. Contact your salesforce administrator.');
            return;
        }
        System.debug('Before profile');
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
            return;
        }
		System.debug('Before user');
        // create portal user
        User newUser;
        Savepoint sp = Database.setSavepoint();
        try {
            string alias = '';
            string firstNameChar='';
            if(con.FirstName!=null && con.FirstName.length()>0){
                firstNameChar = con.FirstName.substring(0, 1);
            }
            if (con.LastName.length() >= 4) {
                alias = firstNameChar + con.LastName.substring(0, 4);
            } else {
                alias = firstNameChar + con.LastName;
            }
            string nick = usr.username;
            Community_Setting__mdt cs = [SELECT Value__c FROM Community_Setting__mdt WHERE QualifiedApiName = 'Username_Suffix' limit 1];
            String username = usr.username+cs.Value__c;
            integer existingUsers = database.countQuery('SELECT count() FROM User WHERE Username = :username OR FederationIdentifier = :username');
            if (existingUsers > 0) {
                res.responseBody = Blob.valueOf('A user with the specified username already exists in the system.');
                res.statusCode = 500;
                System.debug('A user with the specified username already exists in the system.');
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
                timezonesidkey = 'America/New_York',
                username = username,
                CommunityNickname = nick,
                ProfileId = profileId,
                IsActive = true,
                FederationIdentifier = username);

            newUser.setOptions(dmo);
            insert newUser;
            System.setPassword(newUser.Id, usr.password);
            removeRegistrationHash(con.Id);
            LightningLoginFormController.sendEventToGA(username, '', 'registration', '');
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            LogException.log(e);
            Database.rollback(sp);
            return;
        }
        res.responseBody = Blob.valueOf(JSON.serialize(newUser));
        res.statusCode = 200;
    }

    @future
    private static void removeRegistrationHash(Id contactId) {
        try {
            Contact c = [SELECT Id, Registration_Invitation_Hash__c FROM Contact WHERE Id = :contactId];
            c.Registration_Invitation_Hash__c = '';
            update c; 
        } catch (Exception e) {
            LogException.log(e);
        }
    }

    global class CustomUser {
        public Id contactId {get;set;}
        public String username {get;set;}
        public String password {get;set;}
    }

}