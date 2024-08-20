@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

    @isTest
    static void testEnvironment() {
        String environment = 'main';
        String language = 'en-us';
        String brand = 'hoya';
        String response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        environment = 'build';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        environment = 'uat';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        language = 'it-it';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        language = null;
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        environment = 'build';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        environment = 'main';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
        environment = '';
        response = LightningLoginFormController.getPortalUrlsAndLabels(environment, language,brand);
        System.assertNotEquals(response, null);
    }

    @IsTest
    static void testLoginWithInvalidCredentials() {
        Map<String,Community_label_settings__mdt> mapCommunityLabel = LightningLoginFormController.mapCommunityLabel;
        System.assertEquals('Please use the address of the solution you are willing to access like hoyavisionhub.com instead of the address of this login page', LightningLoginFormController.login('testUser', 'fakepwd', '', 'en-us'));
        System.assertEquals('Please fill your credentials to login.', LightningLoginFormController.login('testUser', null, 'apex/WSFederation', 'en-us'));
        System.assertEquals('Utilizzare un Fornitore di Servizi per accedere.', LightningLoginFormController.login('testUser', null, '', 'it-it'));
        System.assertEquals('Inserisci le tue credenziali per accedere.', LightningLoginFormController.login('testUser', null, 'apex/WSFederation', 'it-it'));
        //System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login('testUser', 'fakepwd', 'apex/WSFederation', 'en'));
    }

    @IsTest
    static void LightningLoginFormControllerInstantiation() {
        LightningLoginFormController controller = new LightningLoginFormController();
        System.assertNotEquals(controller, null);
    }
    @IsTest
    static void testEventsToGA() {
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com',
            portal__c = 'frportal'
        );
        insert acc;
        Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact'

        );
        insert ct;
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Alias = 'mtst';
        u.Email = 'mtester@ItbTestcompany.com';
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.contactId = ct.Id;
        u.ProfileId = [select Id
                        from Profile
                        where Name = 'Customer Community Plus User + API'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        GARequestWrapper wrapper = new GARequestWrapper(ct, 'login', 'auportal');
        GARequestWrapper wrapperUsr = new GARequestWrapper(u, 'login', 'auportal');
        LightningLoginFormController.sendEventToGA('', 'www.abc.com', 'login', ct.Id);
        LightningLoginFormController.getSolutionFromURL('www.seikovisionpro.com');
        LightningLoginFormController.getSolutionFromURL('www.hoyavisionordercenter.com');
        LightningLoginFormController.getSolutionFromURL('www.hoyacontactlenses.com');
        LightningLoginFormController.getSolutionFromURL('0sp67000000s');
        LightningLoginFormController.getSolutionFromURL('www.hoyasmartselect.com');
        LightningLoginFormController.getSolutionFromURL('www.seikosmartselect.com');
        LightningLoginFormController.getSolutionFromURL('www.myaccount.seikovision.com');
        LightningLoginFormController.getSolutionFromURL('www.myaccount.hoyavision.com');
        LightningLoginFormController.getSolutionFromURL('www.customer.redhab.com');
        LightningLoginFormController.getSolutionFromURL('www.eservices.hoya.fr');
    }

}