//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Moodle native user data push client
//Moodle integration endpoint URL must be configured in custom settings on each SFDC environment
//all calls to Moodle are repeated three times in case of 500 http response family
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public with sharing class pss_Moodle_Client_native {
    public class MoodleUserId
    {
        public string userid {get; set{userid = value; }}           
    }
    
    public class MoodleResponse
    {
        public string userId {get; set;}
        public string username {get;  set{username = value; }}      
        public string code {get; set{code = value; }}
        public string message {get; set{message = value; }}
        public string debuginfo {get; set{debuginfo = value; }}        
        public string mexception {get; set{mexception = value; }} 
        public string status {get; set{status = value; }}           
        public boolean isError {get; set;}
        public string id {get; set{id = value; }} 
        public MoodleUserId data {get; set{data = value; }}   
        
        public MoodleResponse()
        {
            userId = '';
            username = '';
            code = '';
            status = '';
            message = '';
            isError = false;
            id = '';
            debuginfo='';
            mexception='';
        }
        
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Moodle integration endpoint URL configured in custom settings
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    public static Map<String, String> countriesMap;

    static String  moodleUrl = pss_moodle_settings__c.getInstance().LMS_URL__c;//user privileges

   // static String createUserMethod = '/auth/saml/webservice/user_add.json';//pss_moodle_settings__c.getInstance().pss_Create_User_Method__c;
    //static String updateUserMethod = '/auth/saml/webservice/user_mod.json';
    
    static String createUserMethod = '/local/plms_rest/user_add.json';
    static String updateUserMethod = '/local/plms_rest/user_mod.json';
    
    
    
    static String wstoken = pss_moodle_settings__c.getInstance().LMS_WebService_Token__c;//'df2f702f1c9b7bf5c83fabcfbbc92eea';

    static String requestUpdate = '&users[0][id]={17}';
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //moodle request format for the json body of the request
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    static String requestBodyFormat =
    //  '"Username": "{0}", "Title": "{1}", "AccountName": "{2}", "Phone": "{3}", "Email": "{4}", "MailingAddress": "{5}", "UserId": "{6}", "ContactId": "{7}", "IsPartner": "{8}"';
    'users[0][username]={0}'+
    '&users[0][firstname]={1}'+
    '&users[0][lastname]={2}'+
    '&users[0][email]={3}'+
    '&users[0][auth]=saml'+
    '&users[0][password]=1234Ttttt!'+   
    '&users[0][customfields][0][type]=salesforceid&users[0][customfields][0][value]={4}' +
    '&users[0][customfields][1][type]=contactid&users[0][customfields][1][value]={5}' +
    '&users[0][customfields][2][type]=accountid&users[0][customfields][2][value]={6}'+
    '&users[0][customfields][3][type]=ispartner&users[0][customfields][3][value]={7}'+
    '&users[0][customfields][4][type]=Phone&users[0][customfields][4][value]={8}'+
    '&users[0][customfields][5][type]=Title&users[0][customfields][5][value]={9}'+
    '&users[0][customfields][6][type]=CompanyName&users[0][customfields][6][value]={10}'+        
    '&users[0][customfields][7][type]=Address&users[0][customfields][7][value]={11}'+ 
    '&users[0][customfields][8][type]=State&users[0][customfields][8][value]={12}'+ 
    '&users[0][customfields][9][type]=ZipCode&users[0][customfields][9][value]={13}'+    
    '&users[0][customfields][10][type]=Salesforceaccountname&users[0][customfields][10][value]={14}'+             
    '&users[0][customfields][11][type]=syncedfrom&users[0][customfields][11][value]={15}'+                 
    '&users[0][city]={16}'+
    '&users[0][country]={17}'/*+
    '&users[0][phone1]={11}'+
    '&users[0][phone2]={12}'*/;
    static{
        countriesMap = new Map<String, String>();
        /*
        for(Country__c r : [Select r.ISO_Code__c, r.Name From Country__c r Limit 500 ]){
          countriesMap.put(r.Name,r.ISO_Code__c);
        }
        */
    }
    public pss_Moodle_Client_native ()
    {
        //System.debug(Logginglevel.DEBUG, String.format('url of the moodle environment: {0}', new String[] {pss_Moodle_Client_native.moodleUrl}));
        //System.debug(Logginglevel.DEBUG, String.format('request body format: {0}',  new List<String>{pss_Moodle_Client_native.requestBodyFormat}));
    }

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method used for sending existing user data to Moodle through the REST API interface
    //Request must be POST type, header Content-Type application/json   
    //PRECODITIONS:
    // New Salesforce user of type partner has been created and the data from the record needs to be pushed to Moodle for the update
    //POSTCONDITIONS
    // User has been updated on the Moodle side
    //RETURN
    // 200 - if all PRECONDITIONS are met and the operation was succesful
    // 400 - User is not of partner type    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    public MoodleResponse updateUserInMoodle(Contact newUser)
    {       
        System.debug(Logginglevel.DEBUG,'creating user in Moodle started for Contact with id:  '+newUser.Id);
                
        MoodleResponse mResponse = sendRequestToMoodle(getParameters(newUser,'edit'),updateUserMethod);
        if (mResponse==null)
        {
            mResponse=new MoodleResponse();
        }
        //if ((mResponse.mexception != null && mResponse.mexception != '')|| (mResponse.debuginfo != null && mResponse.debuginfo != '')||(mResponse.code != null && mResponse.code != '')|| (mResponse.message != null && mResponse.message != '') )
        if (mResponse.code!='1')
        {
            mResponse.isError=true;
        }
        else
        {mResponse.isError=false;}     
        mResponse.userId = newUser.Id;
        return mResponse;           
    }

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method used for sending new user data to Moodle through the REST API interface
    //Request must be POST type, header Content-Type application/json   
    //PRECODITIONS:
    // New Salesforce user of type partner has been created and the data from the record needs to be pushed to Moodle for the first time
    //POSTCONDITIONS
    // New user has been created on the Moodle side
    //RETURN
    // 200 - if all PRECONDITIONS are met and the operation was succesful
    // 400 - User is not of partner type    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    public MoodleResponse createUserInMoodle(Contact newUser)
    {       
        System.debug(Logginglevel.DEBUG,'creating Contact in Moodle started for Contact with id:  '+newUser.Id);
                
        MoodleResponse mResponse = sendRequestToMoodle(getParameters(newUser,'new'),createUserMethod);
        mResponse.userId = newUser.Id;
        //if ((mResponse.mexception != null && mResponse.mexception != '')||(mResponse.debuginfo != null && mResponse.debuginfo != '')||(mResponse.code != null && mResponse.code != '')|| (mResponse.message != null && mResponse.message != '') )
        if (mResponse.code!='1')
        {
            mResponse.isError=true;
        }  
        else
        {
            mResponse.isError=false;
            mResponse.id = mResponse.data.userid;
        }           
        return mResponse;           
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method sends a service request to moodle
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    private MoodleResponse sendRequestToMoodle(List<KeyValuePair> parameterList,string method)
    {       
        try
            {
                Http http = new Http();
                 if (Test.isRunningTest())
                {
                    String body='{"exception":"invalid_parameter_exception","code":"invalidparameter","message":"Invalid parameter value detected","debuginfo":"Username already exists: zoran.zunko@gmail.com"}';
                    return (pss_Moodle_Client_native.MoodleResponse)JSON.deserialize(body, pss_Moodle_Client_native.MoodleResponse.class);
                }
                else
                {
                    pssMoodle_API_Response apiResponse;
                    MoodleResponse mResponse = new MoodleResponse();
                    apiResponse = pssapi_Moodle_Proxy.call(moodleUrl + method, parameterList); 
                     if(apiResponse.error == null){
                        mResponse = (pss_Moodle_Client_native.MoodleResponse)JSON.deserialize(apiResponse.message.replace('[','').replace(']',''), pss_Moodle_Client_native.MoodleResponse.class);
                        //parseMoodleCourses(apiResponse.message);
                    }
                    else{
                        mResponse.message = apiResponse.error.mexception;
                    }
//                    HTTPResponse response = http.send(request);
                    System.debug(Logginglevel.Debug,mResponse);
                    System.debug('response.getBody:'+apiResponse.message);
                    /*
                    if(response.getStatusCode()==200)
                    {
                        return (pss_Moodle_Client_native.MoodleResponse)JSON.deserialize(response.getBody().replace('[','').replace(']',''), pss_Moodle_Client_native.MoodleResponse.class);
                    }
                    else
                    {
                        MoodleResponse mResponse = new MoodleResponse();
                        mResponse.message = response.getBody();
                        return mResponse;
                    }
                    */
                    return mResponse;
                }
            }
        catch(System.CalloutException calloutException)
            {
                System.debug(Logginglevel.Debug, calloutException.getMessage());
                MoodleResponse mResponse = new MoodleResponse();
                mResponse.message = calloutException.getMessage();
                return mResponse;
            }
        catch(System.Exception ex)
            {
                System.debug(Logginglevel.Debug, ex.getMessage());
                MoodleResponse mResponse = new MoodleResponse();
                mResponse.message = ex.getMessage();
                return mResponse;
            }
    }
    
    private List<KeyValuePair> getParameters(Contact newUser,string mode)
    {
        List<KeyValuePair> params = new List<KeyValuePair>();
        String street='';
        String city='';
        String state='';
        String postalCode='';                
        String country='US';
        String firstName=''; 
        String phone=''; 
        String mobile='';
        String title='';         
        String company='';         
        String moodleId='';  
        String contactId='';  
        String accountId='';
        String cohort1 = '';
        String cohort2 = '';
        String cohort3 = '';
        String cohort4 = '';
        String cohort5 = '';
        String cohort6 = '';
        String cohort7 = '';
        String cohort8 = '';
        String cohortbyprofile = '';
        String cohortbydate = '';
        String Language = '';
           
        /*
        if (newUser.pss_Account_Id__c!=null)
        {
            accountId = String.valueOf(newUser.pss_Account_Id__c);
        } 

        if (newUser.ContactId !=null)
        {
            contactId = String.valueOf(newUser.ContactId);
        }      
        if (newUser.CompanyName!=null)
        {
            company=newUser.CompanyName;
        }
        */ 
        
        
       
        System.debug('newUser.Account.Primary_Buying_Group__c' +newUser.Account.Primary_Buying_Group__r.Name);    
        if (newUser.Account.Primary_Buying_Group__c!=null)
        {
            cohort1 = String.valueOf(newUser.Account.Primary_Buying_Group__r.Name);
        }  
       
        
        
        
            
       /* if (newUser.LMS_Rol_Contact_2__c!=null)
        {
            cohort2 = String.valueOf(newUser.LMS_Rol_Contact_2__c);
        }      
        if (newUser.LMS_Rol_Contact_3__c!=null)
        {
            cohort3 = String.valueOf(newUser.LMS_Rol_Contact_3__c);
        }      
        if (newUser.LMS_Rol_Contact_4__c!=null)
        {
            cohort4 = String.valueOf(newUser.LMS_Rol_Contact_4__c);
        }      
        if (newUser.LMS_Rol_Contact_5__c!=null)
        {
            cohort5 = String.valueOf(newUser.LMS_Rol_Contact_5__c);
        }      
        if (newUser.LMS_Rol_Contact_6__c!=null)
        {
            cohort6 = String.valueOf(newUser.LMS_Rol_Contact_6__c);
        }      
        if (newUser.LMS_Rol_Contact_7__c!=null)
        {
            cohort7 = String.valueOf(newUser.LMS_Rol_Contact_7__c);
        }      
        if (newUser.LMS_Rol_Contact_8__c!=null)
        {
            cohort8 = String.valueOf(newUser.LMS_Rol_Contact_8__c);
        }
        if (newUser.LMS_Rol_by_Date__c!=null)
        {
            cohortbydate = String.valueOf(newUser.LMS_Rol_by_Date__c);
        }
        if (newUser.LMS_Rol_by_Profile__c!=null)
        {
            cohortbyprofile = String.valueOf(newUser.LMS_Rol_by_Profile__c);
        }          
        */                                 
        if (newUser.pss_moodle_user_id__c!=null)
        {
            moodleId = String.valueOf(newUser.pss_moodle_user_id__c);
        }      
        
        if (newUser.Phone!=null)
        {
            phone=newUser.Phone;
        }
        if (newUser.MobilePhone!=null)
        {
            mobile=newUser.MobilePhone;
        }
        if (newUser.Title!=null)
        {
            title=newUser.Title;
        }
        
        if (newUser.MailingStreet!=null)
        {
            street=newUser.MailingStreet;
        } 
        
        /*
        
        if (newUser.State!=null)
        {
            state=newUser.State;
        }        
        if (newUser.PostalCode!=null)
        {
            postalCode=newUser.PostalCode;
        }        
        */
        if (newUser.MailingCity!=null)
        {
            city=newUser.MailingCity;
        }        
        if (newUser.MailingCountry!=null)
        {
            //if (countriesMap.containsKey(newUser.Country))
            {
                country=newUser.MailingCountry;                
            }
        }
        
        if (newUser.FirstName!=null)
        {
            firstName=newUser.FirstName;
        }

        params.add(new KeyValuePair('ptoken',wstoken));        
        params.add(new KeyValuePair('username',newUser.username__c));
        params.add(new KeyValuePair('lang',newUser.Language_Pick__c));        
       // params.add(new KeyValuePair('username',newUser.email));
        params.add(new KeyValuePair('password','lms_pass'));        
        params.add(new KeyValuePair('firstname',firstName));        
        params.add(new KeyValuePair('lastname',newUser.LastName));        
        params.add(new KeyValuePair('email',newUser.email));                                
        params.add(new KeyValuePair('auth','manual'));        
        params.add(new KeyValuePair('city',city));        
        params.add(new KeyValuePair('country',country));        
        params.add(new KeyValuePair('phone',phone));              
        params.add(new KeyValuePair('phone2',mobile));                      
        params.add(new KeyValuePair('address',street));                              
        //params.add(new KeyValuePair('en',newUser.Id)); 
        //params.add(new KeyValuePair('theme',newUser.Id));                 
        params.add(new KeyValuePair('customfields[0][type]','salesforceid'));        
        params.add(new KeyValuePair('customfields[0][value]',newUser.Id));        
        params.add(new KeyValuePair('customfields[1][type]','contactid'));        
        params.add(new KeyValuePair('customfields[1][value]',contactId));        
        params.add(new KeyValuePair('customfields[2][type]','phone2'));        
        params.add(new KeyValuePair('customfields[2][value]',mobile));        
        params.add(new KeyValuePair('customfields[3][type]','ispartner'));        
        params.add(new KeyValuePair('customfields[3][value]',(contactId == '' ? '0': '1')));        
        params.add(new KeyValuePair('customfields[4][type]','Phone'));        
        params.add(new KeyValuePair('customfields[4][value]',phone));        
        params.add(new KeyValuePair('customfields[5][type]','Title'));        
        params.add(new KeyValuePair('customfields[5][value]',title));        
        params.add(new KeyValuePair('customfields[6][type]','CompanyName'));        
        params.add(new KeyValuePair('customfields[6][value]',company));        
        params.add(new KeyValuePair('customfields[7][type]',street));        
        params.add(new KeyValuePair('customfields[7][value]',street));        
        params.add(new KeyValuePair('customfields[8][type]','State'));        
        params.add(new KeyValuePair('customfields[8][value]',state));        
        params.add(new KeyValuePair('customfields[9][type]','ZipCode'));        
        params.add(new KeyValuePair('customfields[9][value]',postalcode));        
        params.add(new KeyValuePair('customfields[10][type]','Salesforceaccountname'));        
        params.add(new KeyValuePair('customfields[10][value]',''));        
        params.add(new KeyValuePair('customfields[11][type]','syncedfrom'));        
        params.add(new KeyValuePair('customfields[11][value]','Salesforce')); 
        
        params.add(new KeyValuePair('customfields[12][type]','cohort1'));        
        params.add(new KeyValuePair('customfields[12][value]',cohort1));        
        params.add(new KeyValuePair('customfields[13][type]','cohort2'));        
        params.add(new KeyValuePair('customfields[13][value]',cohort2));        
        params.add(new KeyValuePair('customfields[14][type]','cohort3'));        
        params.add(new KeyValuePair('customfields[14][value]',cohort3));        
        params.add(new KeyValuePair('customfields[15][type]','cohort4'));        
        params.add(new KeyValuePair('customfields[15][value]',cohort4));        
        params.add(new KeyValuePair('customfields[16][type]','cohort5'));        
        params.add(new KeyValuePair('customfields[16][value]',cohort5));        
        params.add(new KeyValuePair('customfields[17][type]','cohort6'));        
        params.add(new KeyValuePair('customfields[17][value]',cohort6));        
        params.add(new KeyValuePair('customfields[18][type]','cohort7'));        
        params.add(new KeyValuePair('customfields[18][value]',cohort7));        
        params.add(new KeyValuePair('customfields[19][type]','cohort8'));        
        params.add(new KeyValuePair('customfields[19][value]',cohort8));    
        params.add(new KeyValuePair('customfields[20][type]','cohortbydate'));        
        params.add(new KeyValuePair('customfields[20][value]',cohortbydate));    
        params.add(new KeyValuePair('customfields[21][type]','cohortbyprofile'));        
        params.add(new KeyValuePair('customfields[21][value]',cohortbyprofile));    


               
        if (mode=='edit')        
        {
            params.add(new KeyValuePair('userid',moodleId));
        }
        
        return params;
        
    }
    
}