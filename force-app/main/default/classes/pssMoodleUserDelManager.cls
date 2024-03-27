//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Moodle native user data push client
//Moodle integration endpoint URL must be configured in custom settings on each SFDC environment
//all calls to Moodle are repeated three times in case of 500 http response family
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public with sharing class pssMoodleUserDelManager {
    public class MoodleUserId
    {
        public string userid {get; set{userid = value; }}           
    }
    
     public class User_Del_Collection{
        public List<MoodleResponse> data;
        public boolean success {get; set;}        
        public string message {get; set;}         
        public boolean iserror {get; set;}
        public string code {get; set;}
        public User_Del_Collection(){
            data = new List<MoodleResponse>();
        }
    }
    
    public class MoodleResponse
    {
        public string userId {get; set;}
        public string result {get;  set;}
        
        public MoodleResponse()
        {
            userId = '';
            result = '';
        }
        
    }
    
    
    static String  moodleUrl = pss_moodle_settings__c.getInstance().LMS_URL__c;//user privileges

    static String deleteUserMethod = '/local/plms_rest/user_del.json';//pss_moodle_settings__c.getInstance().pss_Create_User_Method__c;
    static String suspendUserMethod = '/local/plms_rest/user_suspend.json';
    private final string TEXT_DATA = 'data';
    private final string TEXT_STATUS = 'status';
    
    static String wstoken = pss_moodle_settings__c.getInstance().LMS_WebService_Token__c;//'df2f702f1c9b7bf5c83fabcfbbc92eea';

    
    public pssMoodleUserDelManager ()
    {
        //System.debug(Logginglevel.DEBUG, String.format('url of the moodle environment: {0}', new String[] {pss_Moodle_Client_native.moodleUrl}));
        //System.debug(Logginglevel.DEBUG, String.format('request body format: {0}',  new List<String>{pss_Moodle_Client_native.requestBodyFormat}));
    }
    
    public User_Del_Collection DeleteUserInMoodle(List<pssLMS_Delete_User__c> users)
    {   
        string method='';        
        if (pss_moodle_settings__c.getInstance().LMS_Suspend_User__c)
        {
            method=suspendUserMethod;
        }
        else
        {
            method=deleteUserMethod;
        }
        User_Del_Collection mResponse = sendRequestToMoodle(getParameters(users),method);
        if (mResponse==null)
        {
            mResponse=new User_Del_Collection();
        }
        //if ((mResponse.mexception != null && mResponse.mexception != '')|| (mResponse.debuginfo != null && mResponse.debuginfo != '')||(mResponse.code != null && mResponse.code != '')|| (mResponse.message != null && mResponse.message != '') )
        if (mResponse.code!='1')
        {
            mResponse.isError=true;
        }
        else
        {mResponse.isError=false;}     

        return mResponse;           
    }

    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //Method sends a service request to moodle
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    private User_Del_Collection sendRequestToMoodle(List<KeyValuePair> parameterList,string method)
    {       
        try
            {
                Http http = new Http();
                pssMoodle_API_Response apiResponse;
                User_Del_Collection mResponse = new User_Del_Collection();
                 if (Test.isRunningTest())
                {
                    apiResponse = new pssMoodle_API_Response();
                    apiResponse.message = '{"data":{' +
                    '"1":{"id":"23","success":"ok","message":"Invalid parameter value detected","iserror":"null"}' +             
                    '},"code":1,"status":200}';
                                                           
                }
                else
                {
                    
                    apiResponse = pssapi_Moodle_Proxy.call(moodleUrl + method, parameterList); 
                 }
                     if(apiResponse.error == null){
                        //mResponse = (pssMoodleUserDelManager.User_Del_Collection)JSON.deserialize(apiResponse.message.replace('[','').replace(']',''), pss_Moodle_Client_native.MoodleResponse.class);
                        mResponse = parseMoodleResponse(apiResponse.message);
                    }
                    else{
                        mResponse.message = apiResponse.error.mexception;
                    }
//                    HTTPResponse response = http.send(request);
                    System.debug(Logginglevel.Debug,mResponse);
                    System.debug('response.getBody:'+apiResponse.message);
                                   
                return mResponse;
            }
        catch(System.CalloutException calloutException)
            {
                System.debug(Logginglevel.Debug, calloutException.getMessage());
                User_Del_Collection mResponse = new User_Del_Collection();
                mResponse.message = calloutException.getMessage();
                return mResponse;
            }
        catch(System.Exception ex)
            {
                System.debug(Logginglevel.Debug, ex.getMessage());
                User_Del_Collection mResponse = new User_Del_Collection();
                mResponse.message = ex.getMessage();
                return mResponse;
            }
    }
    
    private List<KeyValuePair> getParameters(List<pssLMS_Delete_User__c> newUsers)
    {
        List<KeyValuePair> params = new List<KeyValuePair>();
        String userIds='';
        Integer i=0;
        
        for(pssLMS_Delete_User__c u : newUsers)
        {
            if (i==0)
                userIds += u.LMS_User_Id__c;
            else
                userIds += ','+ u.LMS_User_Id__c;  
            i++;
        }
        
        params.add(new KeyValuePair('ptoken',wstoken));        
        params.add(new KeyValuePair('userid',userIds));
        return params;
        
    }
    
    private User_Del_Collection parseMoodleResponse(string moodleJSON){
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(moodleJSON);
        User_Del_Collection moodleCourses = new User_Del_Collection();
            
        while (parser.nextToken() != null) {                               
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                while (parser.nextToken() != null) {                        
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_DATA){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        while(parser.nextToken()!=null){                                
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                // Read entire object                            
                                MoodleResponse courseInfo = (MoodleResponse)parser.readValueAs(MoodleResponse.class);
                                system.debug(' Course Text: ' + courseInfo);
                                moodleCourses.data.add(courseInfo);
                                // Skip the child start array and start object markers.
                                parser.skipChildren();                                                                        
                            }                                
                            else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_STATUS ){
                                parser.nextToken();                                    
                                moodleCourses.success = (parser.getIntegerValue() == 200 ? true : false);  
                                System.Debug(' Status:' + moodleCourses.success);                     
                            }                                
                        }
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_STATUS ){
                        parser.nextToken();                                    
                        moodleCourses.success = (parser.getIntegerValue() == 200 ? true : false);  
                        System.Debug(' Status:' + moodleCourses.success);                     
                    }                        
                }
            }                
        }
        
        System.debug('Anuja moodleCourses :: '+moodleCourses);
        return moodleCourses;
    }
    
}