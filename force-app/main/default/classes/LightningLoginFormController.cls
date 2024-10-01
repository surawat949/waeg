global class LightningLoginFormController {

    /*
    *   Properties 
    */
    public static Map<String,Community_label_settings__mdt> mapCommunityLabel {
        get{
            if(mapCommunityLabel == null)
                mapCommunityLabel = Utility.getCommunitiesLabel();
            return mapCommunityLabel;
        }
        set;
    }

    public static Map<String,Community_Setting__mdt> mapCommunitySettings {
        get{
            if(mapCommunitySettings == null)
                mapCommunitySettings = Utility.getCommunitiesSettings();
            return mapCommunitySettings;
        }
        set;
    }

    // properties to build urls
    public static String helpURL;
    public static String contactURL;
    public static String privacyPolicyURL;
    public static String termsConditionsURL;
    public static String noAccountURL;
    public static String recoveryUrl;

    public LightningLoginFormController() {}
 
    /*
    *    PUBLIC METHODS
    */
    // get portal url and label from custom setting community setting
    @AuraEnabled
    public static String getPortalUrlsAndLabels(String environment, String language, String brand) {
        //String response = getData(environment, language);
        system.debug('brand++ ' + brand);
        return getData(environment, language, brand);
    }

    // method for login method
    @AuraEnabled
    public static String login(String username, String password, String startUrl, String language) {
        system.debug('##LightningLoginFormController.login()');
        if (!startUrl.contains('apex/WSFederation') && !startUrl.contains('/idp/login') && !startUrl.contains('/idp/endpoint') && !startUrl.contains('/setup/secur/RemoteAccessAuthorizationPage') && !startUrl.contains('oauth')) {
            system.debug('##returning service provider error:' + language);
            return mapCommunityLabel.get(language).Label_Use_Service_Provider__c;
        
        }
        if (String.isBlank(username) || String.isBlank(password)) {
            System.debug('##returning login blank error');
            return mapCommunityLabel.get(language).Label_Fill_in_Credentials__c;
        }
        try {
            Community_Setting__mdt cs = [SELECT Value__c FROM Community_Setting__mdt WHERE QualifiedApiName = 'Username_Suffix' LIMIT 1];
            username += cs.Value__c;
            System.debug('Username:'+ username);
            
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            System.debug('Post Login redirect:'+ lgn);
            aura.redirect(lgn);
            LightningLoginFormController.sendEventToGA(username, startUrl, 'login', '');
            return null;
        } catch (Exception ex) {
            System.debug('Exception thrown '+ ex);
            String message = ex.getMessage();
            if (message.startsWith('Your login attempt has failed')) {
                if (mapCommunityLabel.get(language) != null && !String.isBlank(mapCommunityLabel.get(language).Label_Login_Failed__c)) {
                    return mapCommunityLabel.get(language).Label_Login_Failed__c;    
                } else {
                    return ex.getMessage();        
                }   
            }
            return ex.getMessage();
        }
    }

    @future(callout=true)
    public static void sendEventToGA(String username, String startURL, String eventType, String contactId) {
        String portal = getSolutionFromURL(startURL);
        GARequestWrapper wrapper = null;
        try {
            if (String.isNotBlank(username)) {
                User userRec = [Select id, contactId, contact.AccountId, contact.Account.Brand__c, contact.Account_Portal__c, contact.Hoya_Account_Id__c, contact.Account.shop_country__c, contact.Account.Language__c from user where username =:username limit 1];    
                wrapper =  new GARequestWrapper(userRec, eventType, portal);
            } else {
                Contact conRec = [Select Id, AccountId, Account.Brand__c, Account_Portal__c, Hoya_Account_Id__c, Account.shop_country__c, Account.Language__c from Contact where Id =:contactId limit 1];
                wrapper = new  GARequestWrapper(conRec, eventType, portal);
            } 

            String json = JSON.serialize(wrapper);
            System.debug('Debug+++'+ json);
            if (!Test.isRunningTest()) {
                Google_analytics_API__c customSetting = Google_analytics_API__c.getValues('GA4_Dev');
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setEndpoint('https://www.google-analytics.com/mp/collect?api_secret=' + customSetting.api_secret__c + '&measurement_id=' + customSetting.Measurement_Id__c);
                request.setBody(json);
                Http http = new Http();        
                HttpResponse response = http.send(request);
                
            }   
        } catch (Exception e) {
            LogException.log(e);
        }
    }

    
    public static String getSolutionFromURL(String startURL) {
        String portal = 'unidentified';      
        if (startURL.contains('seikovisionpro')) {
            portal = 'SEIKO Pro';    
        } else if (startURL.contains('hoyavisionordercenter')) {
            portal = 'HOYA Order center'; 
        } else if (startURL.contains('contactlenses')) {
            portal = 'HOYA Contact Lenses'; 
        } else if (startURL.contains('0sp67000000s')) {
            portal = 'HOYA Learning Center'; 
        } else if (startURL.contains('hoyasmartselect')) {
            portal = 'HOYA SMART Select'; 
        } else if (startURL.contains('seikosmartselect')) {
            portal = 'SEIKO SMART Select'; 
        } else if (startURL.contains('myaccount.seikovision')) {
            portal = 'SEIKO myAccount'; 
        } else if (startURL.contains('myaccount.hoyavision')) {
            portal = 'HOYA myAccount'; 
        } else if (startURL.contains('redhab')) {
            portal = 'SEIKO redhab'; 
        } else if (startURL.contains('eservices.hoya')) {
            portal = 'HOYA eservices'; 
        } else if (startURL.contains('hoyavisionhub') || startURL.contains('hoyaportal')) {
            portal = 'HOYA HUB'; 
        }
        return portal;
    }

    /*
    *    PRIVATE METHODS
    */
    // method to get data
    private static string getData(String environment, String language, String brand) {
        System.debug('Inside getData++');
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        List < Community_Setting__mdt > metadataTypes = [SELECT QualifiedApiName, Value__c FROM Community_Setting__mdt];
        PortalUrlsAndLabels urlsAndLabels = new PortalUrlsAndLabels();
        //mapCommunityLabel = getCommunitiesLabel();
        // language will be a parameter received in the url, for now it's being used here locally for dev purposes
        //String language = 'en';
        language = language == '' ? 'en-us' : language;

        // build URLs
        getURL(environment, brand);

        if(mapCommunityLabel.containskey(language)){
            urlsAndLabels.loginLabel = mapCommunityLabel.get(language).Label_login__c;
            urlsAndLabels.noAccountLabel = mapCommunityLabel.get(language).Label_No_Account__c;
            urlsAndLabels.passwordLabel = mapCommunityLabel.get(language).Label_password__c;
            urlsAndLabels.usernameLabel = mapCommunityLabel.get(language).Label_username__c;
            urlsAndLabels.recoveryLabel = mapCommunityLabel.get(language).Label_Forgot_Password__c;
            urlsAndLabels.contactLabel = mapCommunityLabel.get(language).Label_Contact__c;
            urlsAndLabels.helpLabel = mapCommunityLabel.get(language).Label_Help__c;
            urlsAndLabels.privacyLabel = mapCommunityLabel.get(language).Label_Privacy__c;
            urlsAndLabels.termsLabel = mapCommunityLabel.get(language).Label_Terms__c;
            urlsAndLabels.rememberLabel = mapCommunityLabel.get(language).Label_Remember_Me__c;
            urlsAndLabels.welcomeLabel = mapCommunityLabel.get(language).Label_Welcome__c;
            urlsAndLabels.descriptionLabel = mapCommunityLabel.get(language).Label_Description__c;
            urlsAndLabels.descriptionLabelFirst = mapCommunityLabel.get(language).Label_Description_1__c;
            // GENERIC LABELS
            urlsAndLabels.createAccountLabel = mapCommunityLabel.get(language).Label_Create_Account__c;
            urlsAndLabels.helpUrl = helpURL + language + mapCommunityLabel.get(language).Help_URL__c;
            urlsAndLabels.contactUrl = contactURL + language + mapCommunityLabel.get(language).Contact_Us_URL__c;
            urlsAndLabels.privacyURL = privacyPolicyURL + language + mapCommunityLabel.get(language).Privacy_URL__c;
            urlsAndLabels.termsURL = termsConditionsURL + language + mapCommunityLabel.get(language).Term_Of_Use_URL__c;
            urlsAndLabels.noAccountUrl = noAccountURL + language + mapCommunityLabel.get(language).No_Account_URL__c;
            urlsAndLabels.recoveryUrl = recoveryUrl + '?lang=' + language;
            
            // SEIKO LABELS
            urlsAndLabels.descriptionSeiko = mapCommunityLabel.get(language).Label_Seiko_Login__c;
        }else{
            urlsAndLabels.loginLabel = mapCommunityLabel.get('en-us').Label_login__c;
            urlsAndLabels.noAccountLabel = mapCommunityLabel.get('en-us').Label_No_Account__c;
            urlsAndLabels.passwordLabel = mapCommunityLabel.get('en-us').Label_password__c;
            urlsAndLabels.usernameLabel = mapCommunityLabel.get('en-us').Label_username__c;
            urlsAndLabels.recoveryLabel = mapCommunityLabel.get('en-us').Label_Forgot_Password__c;
            urlsAndLabels.contactLabel = mapCommunityLabel.get('en-us').Label_Contact__c;
            urlsAndLabels.helpLabel = mapCommunityLabel.get('en-us').Label_Help__c;
            urlsAndLabels.privacyLabel = mapCommunityLabel.get('en-us').Label_Privacy__c;
            urlsAndLabels.termsLabel = mapCommunityLabel.get('en-us').Label_Terms__c;
            urlsAndLabels.rememberLabel = mapCommunityLabel.get('en-us').Label_Remember_Me__c;
            urlsAndLabels.welcomeLabel = mapCommunityLabel.get('en-us').Label_Welcome__c;
            urlsAndLabels.descriptionLabel = mapCommunityLabel.get('en-us').Label_Description__c;
            urlsAndLabels.descriptionLabelFirst = mapCommunityLabel.get('en-us').Label_Description_1__c;
            // GENERIC LABELS
            urlsAndLabels.createAccountLabel = mapCommunityLabel.get('en-us').Label_Create_Account__c;
            urlsAndLabels.helpUrl = helpURL + language + mapCommunityLabel.get('en-us').Help_URL__c;
            urlsAndLabels.contactUrl = contactURL + language + mapCommunityLabel.get('en-us').Contact_Us_URL__c;
            urlsAndLabels.privacyURL = privacyPolicyURL + language + mapCommunityLabel.get('en-us').Privacy_URL__c;
            urlsAndLabels.termsURL = termsConditionsURL + language + mapCommunityLabel.get('en-us').Term_Of_Use_URL__c;
            urlsAndLabels.noAccountUrl = noAccountURL + language + mapCommunityLabel.get('en-us').No_Account_URL__c;
            urlsAndLabels.recoveryUrl = recoveryUrl + '?lang=' + language;
            
            // SEIKO LABELS
            urlsAndLabels.descriptionSeiko = mapCommunityLabel.get('en-us').Label_Seiko_Login__c;
        }
        
        String urlsJson = JSON.serialize(urlsAndLabels);
        return urlsJson;
    }

    // Method gets base URL based on current Environment and Brand
    private static void getURL(String environment, String brand){
        System.debug('Inside getURL++'+ environment);
        System.debug('Inside getURL++'+ brand);
        String recoverySeiko = mapCommunitySettings.get('Seiko_My_account').value__c;
        if(environment == 'build'){
            if (brand == 'seiko') {
                helpURL = contactUrl = noAccountURL = privacyPolicyURL = termsConditionsURL = mapCommunitySettings.get('Portal_PROD_SEIKO').value__c;
            } else {
                helpURL = contactUrl = noAccountURL = mapCommunitySettings.get('Portal_BUILD_INTE').value__c;
            }
            recoveryUrl = brand == 'hoya' ? mapCommunitySettings.get('Account_Recovery_BUILD').value__c : recoverySeiko.replace('{ENV}', environment) + 'accountrecovery';

        }else if(environment == 'main'){
            if (brand == 'seiko') {
                helpURL = contactUrl = noAccountURL = privacyPolicyURL = termsConditionsURL = mapCommunitySettings.get('Portal_PROD_SEIKO').value__c;
            } else {
                helpURL = contactUrl = noAccountURL = mapCommunitySettings.get('Portal_BUILD_MAIN').value__c;
            }   
            recoveryUrl = brand == 'hoya' ? mapCommunitySettings.get('Account_Recovery_MAIN').value__c : recoverySeiko.replace('{ENV}', environment) + 'accountrecovery';

        }else if(environment == 'uat'){
            if (brand == 'seiko') {
                helpURL = contactUrl = noAccountURL = privacyPolicyURL = termsConditionsURL = mapCommunitySettings.get('Portal_PROD_SEIKO').value__c;
            }
            else {
                helpURL = contactUrl = noAccountURL = mapCommunitySettings.get('Portal_UAT_PREP').value__c;
            }
            
            if (brand == 'Optic') {
                recoveryUrl = mapCommunitySettings.get('Account_Recovery_SafeVision_UAT').value__c;
            } else {
                recoveryUrl = brand == 'hoya' ? mapCommunitySettings.get('Account_Recovery_UAT').value__c : recoverySeiko.replace('{ENV}', environment) + 'accountrecovery';
            }
            

        }else{
            if (brand == 'seiko') {
                helpURL = contactUrl = noAccountURL = privacyPolicyURL = termsConditionsURL = mapCommunitySettings.get('Portal_PROD_SEIKO').value__c;
            } else {
                helpURL = contactUrl = noAccountURL = mapCommunitySettings.get('Portal_PROD').value__c;
            }
            recoveryUrl = brand == 'hoya' ? mapCommunitySettings.get('Account_Recovery_PROD').value__c : recoverySeiko.replace('{ENV}-', '') + 'accountrecovery';       
        }
    }

    /*
    *    WRAPPER
    */
    public class PortalUrlsAndLabels {
        @AuraEnabled
        public String recoveryUrl {get;private set;}
        @AuraEnabled
        public String noAccountUrl {get;private set;}
        @AuraEnabled
        public String recoveryLabel {get;private set;}
        @AuraEnabled
        public String noAccountLabel {get;private set;}
        @AuraEnabled
        public String loginLabel {get;private set;}
        @AuraEnabled
        public String usernameLabel {get;private set;}
        @AuraEnabled
        public String passwordLabel {get;private set;}
        @AuraEnabled
        public String helpUrl {get;private set;}
        @AuraEnabled
        public String helpLabel {get;private set;}
        @AuraEnabled
        public String contactUrl {get;private set;}
        @AuraEnabled
        public String contactLabel {get;private set;}
        
        @AuraEnabled
        public String privacyLabel {get;private set;}
        @AuraEnabled
        public String privacyURL {get;private set;}
        @AuraEnabled
        public String termsLabel {get;private set;}
        @AuraEnabled
        public String termsURL {get;private set;}

        @AuraEnabled
        public String rememberLabel {get;private set;}
        @AuraEnabled
        public String welcomeLabel {get;private set;}
        @AuraEnabled
        public String descriptionLabel {get;private set;}
        @AuraEnabled
        public String descriptionLabelFirst {get;private set;}
        @AuraEnabled
        public String createAccountLabel {get;private set;}
        @AuraEnabled
        public String descriptionSeiko {get;private set;}
        //BP
        @AuraEnabled
        public String instanceUrl {get;private set;}
    }
}