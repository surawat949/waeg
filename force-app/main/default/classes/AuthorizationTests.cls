@isTest
private class AuthorizationTests {

    /*
    * Test scenarios:
    Duplicate check	Before insert - done
	
    Assign new masters to all users (deactivated)	After insert - done
    Copy all child authorizations when assigned to a user, when Copy Child Authorizations is selected	After insert - done

    Deactivate all child authorizations when authorization is set to inactive	After update - done
    Activate all child/parent authorizations that are linked to the contact when authorization is set to active	After update - done
	
    Show error to the user as authorizations can't be deleted, only deactivated.	Before delete - done
    */

    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    
    private static final String ACCTEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String ACCTEMPLATE_ORIGINAL_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();

    @TestSetup
    static void makeData(){

        User u = [SELECT Id FROM User WHERE CompanyName IN ('HOLI', 'HOLA', 'HLCA', 'HVNA', 'VEUS') AND IsActive = true limit 1];

        
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;
        
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;

        Authorization__c master2 = new Authorization__c(
            Authorization_Name__c = 'Access to CMS',
            claim_formatted__c = 'AccesstoCMS',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master2;

        Authorization__c masterChild = new Authorization__c(
            Authorization_Name__c = 'Access to Orders - READ',
            claim_formatted__c = 'AccesstoOrdersRead',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT,
            Parent_Authorization__c = master.Id
        );
        insert masterChild;

        Account_Template__c at = new Account_Template__c(
            Name = 'Shop Owner',
            RecordTypeId = ACCTEMPLATE_ORIGINAL_RT
        );
        insert at;

        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = at.Id,
            Authorization__c = master.Id
        );
        insert aLink;

        Account_Template__c atCopy = new Account_Template__c(
            Account__c = acc.Id,
            Master_Template__c = at.Id,
            Name = 'Test Acc Shop Owner',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        insert atCopy;

        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact',
            OwnerId = u.Id
        );
        insert ct;
        
    }
	
	@isTest static void checkDuplicates_test() {
		// dupcheck on master
        Authorization__c masterDuplicate = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        try {
            insert masterDuplicate;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('A Master Authorization with the provided name already exists.'));
        }

        Authorization__c master = [SELECT Id FROM Authorization__c WHERE Authorization_Name__c = 'Access to Portal' AND RecordType.DeveloperName = 'Original' limit 1];
        Contact c = [SELECT Id FROM Contact WHERE Name = 'John Contact' limit 1];
        Authorization__c copyDuplicate = new Authorization__c(
            Copy_From__c = master.Id,
            Contact__c = c.Id
        );
        try {
            insert copyDuplicate;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('This authorization is already associated with this user. Id:'));
        }

        Account_Template__c at = new Account_Template__c(
            Name = 'Shop Owner',
            RecordTypeId = ACCTEMPLATE_ORIGINAL_RT
        );
        try {
            insert at;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('An Account Template with the provided name already exists.'));
        }

        Account_Template__c atMaster = [SELECT Id FROM Account_Template__c WHERE Name = 'Shop Owner' limit 1];
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Acc' limit 1];
        Account_Template__c atCopy = new Account_Template__c(
            Master_Template__c = atMaster.Id,
            Account__c = acc.Id,
            Name = 'anything',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        try {
            insert atCopy;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('This Template is already associated with this account. Id:'));
        }

        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = atMaster.Id,
            Authorization__c = master.Id
        );
        try {
            insert aLink;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('An Authorization Link between these two entities already exists. Id:'));
        }
	}

    @isTest static void assignChildAuthToContactsOnCreation() {
        Account acc = [SELECT Id FROM Account limit 1];
        Contact ct = new Contact(

            AccountId = acc.Id,
            FirstName = 'James',
            LastName = 'Contact'
        );
        Test.startTest();
        insert ct;
        Test.stopTest();

        // verify that both parent and child master auths were assigned to the user, inactive.
        List<Authorization__c> contactAuths = [SELECT Id, Active_Authorization__c, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        //System.assertEquals(3, contactAuths.size());
        for (Authorization__c auth : contactAuths) {
            System.assertEquals(false, auth.Active_Authorization__c);
        }

        // verify if parent also gets activated after activating its child
        for (Authorization__c auth : contactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Orders - READ') {
                auth.Active_Authorization__c = true;
            }
        }
        update contactAuths;
        List<Authorization__c> contactAuthsUpdated = [SELECT Id, Active_Authorization__c, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        system.debug(contactAuthsUpdated);
        for (Authorization__c auth : contactAuthsUpdated) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to CMS') {
                System.assertEquals(false, auth.Active_Authorization__c);
            }
            else {
                System.assertEquals(true, auth.Active_Authorization__c);
            }
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Portal') {
                auth.Active_Authorization__c = false;
            }
        }
        // verify if child also gets deactivated after deactivating its parent
        update contactAuthsUpdated;

        for (Authorization__c auth : [SELECT Active_Authorization__c FROM Authorization__c WHERE Contact__c = :ct.Id]) {
            system.assertEquals(false, auth.Active_Authorization__c);
        }


        // check that authorizations cannot be deleted
        try {
            delete contactAuthsUpdated;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Authorizations cannot be deleted. Please deactivate the authorization.'));
        }
    }
	
    @isTest static void contactTests() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Acc' limit 1];
        Account_Template__c at = [SELECT Id FROM Account_Template__c WHERE Name = 'Test Acc Shop Owner' limit 1];
        Contact ct = new Contact(
            FirstName = 'AT',
            LastName = 'Test',
            AccountId = acc.Id,
            Account_Template__c = at.Id,
            Email = 'contact@email.com'
        );
        Test.startTest();
        insert ct;
        Test.stopTest();
        // verify that all 3 authorizations are assigned to the user, but only the one linked to the Account Template is Active.
        List<Authorization__c> contactAuths = [SELECT Id, Active_Authorization__c, Account_Template__r.Name, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        //system.assertEquals(3, contactAuths.size());
        for (Authorization__c auth : contactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Portal') {
                System.assertEquals(true, auth.Active_Authorization__c);
                System.assertEquals('Test Acc Shop Owner', auth.Account_Template__r.Name);
            }
            else {
                //System.assertEquals(false, auth.Active_Authorization__c);
                System.assertEquals(null, auth.Account_Template__r.Name);
            }
        }
        // verify that hashes were created 
        Contact cont = [SELECT Id, Account_Template__c, Registration_Invitation_Hash__c FROM Contact WHERE Id = :ct.Id];
        system.assert(!String.isBlank(cont.Registration_Invitation_Hash__c));

        // verify changes after account template is changed
        Account_Template__c newAt = new Account_Template__c(
            Name = 'CMS User',
            RecordTypeId = ACCTEMPLATE_ORIGINAL_RT
        );
        insert newAt;

        Authorization__c master = [SELECT Id FROM Authorization__c WHERE Authorization_Name__c = 'Access to CMS' limit 1];

        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = newAt.Id,
            Authorization__c = master.Id
        );
        insert aLink;

        Account_Template__c atCopy = new Account_Template__c(
            Account__c = acc.Id,
            Master_Template__c = newAt.Id,
            Name = 'Test Acc CMS User',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        insert atCopy;

        cont.Account_Template__c = atCopy.Id;
        update cont;

        List<Authorization__c> updContactAuths = [SELECT Id, Active_Authorization__c, Account_Template__r.Name, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        for (Authorization__c auth : updContactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to CMS') {
                System.assertEquals(true, auth.Active_Authorization__c);
                System.assertEquals('Test Acc CMS User', auth.Account_Template__r.Name);
            }
            else {
                System.assertEquals(false, auth.Active_Authorization__c);
                System.assertEquals(null, auth.Account_Template__r.Name);
            }
        }
    }

    @isTest static void accountTemplateTests() {
        Contact ct = [SELECT Id, Account_Template__c FROM Contact WHERE Name = 'John Contact' limit 1];
        Account_Template__c at = [SELECT Id, Active_Authorization_Template__c FROM Account_Template__c WHERE Name = 'Test Acc Shop Owner'];
        ct.Account_Template__c = at.Id;
        update ct;

        // verify that the contact has one auth active, supplied from the Account Template.
        List<Authorization__c> firstContactAuths = [SELECT Id, Active_Authorization__c, Account_Template__r.Name, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        for (Authorization__c auth : firstContactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Portal') {
                System.assertEquals(true, auth.Active_Authorization__c);
                System.assertEquals('Test Acc Shop Owner', auth.Account_Template__r.Name);
            }
            else {
               // System.assertEquals(false, auth.Active_Authorization__c);
                System.assertEquals(null, auth.Account_Template__r.Name);
            }
        }

        // verify that after changing the template to inactive, the auth provided from the template is now inactive
        at.Active_Authorization_Template__c = false;
        update at;
        List<Authorization__c> updatedContactAuths = [SELECT Id, Active_Authorization__c, Account_Template__r.Name, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        for (Authorization__c auth : updatedContactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Portal') {
                System.assertEquals(false, auth.Active_Authorization__c);
                System.assertEquals('Test Acc Shop Owner', auth.Account_Template__r.Name);
            }
        }

        // verify that after changing the template to active again, the auth provided from the template is now active
        at.Active_Authorization_Template__c = true;
        update at;
        List<Authorization__c> lastContactAuths = [SELECT Id, Active_Authorization__c, Account_Template__r.Name, Copy_From__r.Authorization_Name__c FROM Authorization__c WHERE Contact__c = :ct.Id];
        for (Authorization__c auth : lastContactAuths) {
            if (auth.Copy_From__r.Authorization_Name__c == 'Access to Portal') {
                System.assertEquals(true, auth.Active_Authorization__c);
                System.assertEquals('Test Acc Shop Owner', auth.Account_Template__r.Name);
            }
        }

        try {
            delete at;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('An Account Template with associated Contacts cannot be deleted.'));
        }

        Account_Template__c masterAT = [SELECT Id FROM Account_Template__c WHERE Name = 'Shop Owner'];
        try {
            delete masterAT;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('An instance of this Account Template has associated contacts. This Account Template cannot be deleted.'));
        }
    }

    @isTest static void deactivateOriginal() {
        Account acc = [SELECT Id FROM Account limit 1];
        Contact ct = new Contact(

            AccountId = acc.Id,
            FirstName = 'James',
            LastName = 'Contact'
        );
        Test.startTest();
        insert ct;
        Test.stopTest();
        Map<Id, Authorization__c> mastersMap = new Map<Id, Authorization__c>([SELECT Id, Active_Authorization__c FROM Authorization__c WHERE RecordTypeId = :AUTHORIZATION_ORIGINAL_RT]);
        system.debug(mastersMap);
        List<Authorization__c> copies = [SELECT Id, Active_Authorization__c FROM Authorization__c WHERE Active_Authorization__c = FALSE AND Copy_From__c IN :mastersMap.keySet()];
        system.debug('copies.size: '+copies.size());
        for (Authorization__c copy : copies) {
            copy.Active_Authorization__c = true;
        }
        update copies;

        DeactivateAuthorizationCopiesBatch b = new DeactivateAuthorizationCopiesBatch(mastersMap.keySet());
        Database.executeBatch(b);
        
    }

   

    @isTest static void WS_getAuthorizationsTests() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetAuthorizations';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GetAuthorizations.getAuthorizations();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);

        JSONDeserializer deser = new JSONDeserializer();
        deser.contactId  = 'asdsadsa';
		String myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetAuthorizations.getAuthorizations();
        system.debug('systemdebug_test---: '+response.responseBody.toString());
        responseBody = response.responseBody.toString();
        System.assert(responseBody.contains('bad id'));


        // 200 OK
        Contact ct = [SELECT Id, Deactivate__c FROM Contact WHERE Name = 'John Contact' LIMIT 1];
        deser.contactId  = ct.Id;
		myJSON = JSON.serialize(deser);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetAuthorizations.getAuthorizations();
        system.debug('systemdebug_test---: '+response.statusCode);
        Integer statusCode = response.statusCode;
        System.assertEquals(200, statusCode);

        // Deactivate and Activate Users
        ct.Deactivate__c = true;
        update ct;

        ct.Deactivate__c = false;
        update ct;
    }

    private class JSONDeserializer {
        string contactId {
            get;
            set;
        }
    }
}