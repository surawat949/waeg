global class pssMoodleCourseSyncManager {

    global class pssCourseJobResult
    {
        public List<pss_Course__c> courses;                
        public List<pss_Course_Enrollment__c> coursesEnroll;                        
        public boolean success { get; set;} 
        public string error {get; set;}
        public pssCourseJobResult()
        {
            courses = new List<pss_Course__c>();           
            coursesEnroll= new List<pss_Course_Enrollment__c>();           
        }
    }

    /* Represents moodle API course response */
    global class CourseResponse{
        public Course_Info_Collection courses;                
        public Course_Compl_Info_Collection coursesCompl;                
        public CourseResponse(){
            courses = new Course_Info_Collection();           
            coursesCompl = new Course_Compl_Info_Collection();                       
        }
    }
    
    public class Course_Info_Collection{
        public List<Course_Info> data;
        public boolean success {get; set;}        
        public string error {get; set;} 
        public Course_Info_Collection(){
            data = new List<Course_Info>();
        }
    }
    
    public class Course_Compl_Info_Collection{
        public List<Course_Compl_Info> data;
        public boolean success {get; set;}        
        public string error {get; set;}         
        public Course_Compl_Info_Collection(){
            data = new List<Course_Compl_Info>();
        }
    }
    /* Holds ,moodle course object from API JSON response */    
    private class Course_Info{
        public string id { get; set;}
        public string category {get; set;}
        public string fullname {get; set;}
        public string shortname {get; set;}        
        public string summary {get; set;}
        public string idnumber {get; set;}
        public string startDate {get; set;} 
        public string endDate {get; set;} 
        public string timeCreated {get; set;}
        public string timeModified {get; set;}
        
        public Course_Info(){
        }
    }
    
    /* Holds moodle courses */
    
    /* Holds ,moodle course object from API JSON response */    
    private class Course_Compl_Info{
        public string iscompleted { get; set;}
        public string coursename {get; set;}
        public string courseid {get; set;}
        public string progress {get; set;}        
        public string score {get; set;}
        public string last_login {get; set;}
        public string completiondate {get; set;}
        public string userid {get; set;} 
        public string useremail {get; set;}
        public string course_lms_id {get; set;}        
                 
        
        public Course_Compl_Info(){
        }
    }
    
    /* Holds moodle courses */
    
    private List<Course_Info> moodleCourses {get; set;}
    //private final string ACTION_LISTCOURSES = Label.pssMoodle_WS_Endpoint + '?method=coursesall&format=json';
    //private final string ACTION_LISTCOURSES_COMPL = Label.pssMoodle_WS_Endpoint + '?method=courses_activities&format=json';
  
    private final string ACTION_LISTCOURSES = pss_moodle_settings__c.getInstance().LMS_URL__c + '/local/plms_rest/index.php?method=coursesall&format=json';
    private final string ACTION_LISTCOURSES_COMPL = pss_moodle_settings__c.getInstance().LMS_URL__c + '/local/plms_rest/index.php?method=courses_activities&format=json';
  
  
  //  private final string ACTION_LISTCOURSES = pss_moodle_settings__c.getInstance().LMS_URL__c + '/auth/saml/webservice/index.php?method=coursesall&format=json';
   // private final string ACTION_LISTCOURSES_COMPL = pss_moodle_settings__c.getInstance().LMS_URL__c + '/auth/saml/webservice/index.php?method=courses_activities&format=json';
  
  
  
    private final string TEXT_DATA = 'data';
    private final string TEXT_STATUS = 'status';
    //static String wstoken = Label.pssMoodle_User_Token ;// pss_moodle_settings__c.getInstance().LMS_WebService_Token__c;
    static String wstoken = pss_moodle_settings__c.getInstance().LMS_WebService_Token__c ;// pss_moodle_settings__c.getInstance().LMS_WebService_Token__c;
    static Map<string,Contact> mUser = new Map<string,Contact>();
    static Map<string,string> mCourses = new Map<string,string>();    
    
    public pssMoodleCourseSyncManager(){
        moodleCourses = new List<Course_Info>();
    }
    
    public List<CourseResponse> getAll(){
        List<CourseResponse> data = new List<CourseResponse>();
        CourseResponse res=new CourseResponse();
        res.courses = createResponse(getResponse());
        res.coursesCompl = createComplResponse(getCourseComplResponse());
        data.add(res);
        return data;
    }
    
    public Course_Info_Collection createResponse(pssMoodle_API_Response apiResponse){        

        Course_Info_Collection responseObj = new Course_Info_Collection();
        if(apiResponse.error == null){
            responseObj = parseMoodleCourses(apiResponse.message);
        }
        else{
            responseObj.error = apiResponse.error.mexception;
        }
        
        return responseObj;
    }
    
    
    /* Returns moodle API course response */
    public pssMoodle_API_Response getResponse(){
        pssMoodle_API_Response apiResponse;
        if(test.isRunningTest()){
            apiResponse = new pssMoodle_API_Response();
            apiResponse.message = '{"data":{' +
            '"1":{"id":"23","category":"1","fullname":"Moodle: Basis","shortname":"MB","idnumber": "","summary":"","startdate":"1379570400","enddate":"1379570400","timecreated":"1379539601","timemodified":"1379539601"}' +             
            '},"code":1,"status":200}';
        }
        else
        {
            List<KeyValuePair> parameterList = new List<KeyValuePair>();
            parameterList.add(new KeyValuePair('ptoken',wstoken));

            DateTime dt;
            /*
            if (pss_moodle_settings__c.getInstance().Last_Course_Sync_Date__c==null)
            {
                //dt=Datetime.newInstance(Date.today().year(),Date.today().month(),Date.today().day());
                dt = DateTime.Now()-3456;
            }
            else 
                dt=pss_moodle_settings__c.getInstance().Last_Course_Sync_Date__c;
            */
            //parameterList.add(new KeyValuePair('sdate',string.valueOf(dt.getTime()/1000)));
            apiResponse = pssapi_Moodle_Proxy.call(ACTION_LISTCOURSES, parameterList); 
        }
        return apiResponse;
    }
    
    /* Converts list of moodle specific course_info objects into list of SFDC native course objects. */
    public static List<pss_Course__c> transformToNativeCourse(Course_Info_Collection moodleCourses){
        List<pss_Course__c> courses = new List<pss_Course__c>();        
        if (moodleCourses.data!=null && moodleCourses.data.size()>0)
        {
            System.Debug(' moodle courses:' + moodleCourses.data);
            for(Course_Info cInfo : moodleCourses.data){
                pss_Course__c courseObj = transform(cInfo);
                if(courseObj != null)
                    courses.add(courseObj);
            }
        }
        return courses;
    }
    
    /* Converts moodle specific course_info object into SFDC native course object. */
    public static pss_Course__c transform(Course_Info cInfo){
        pss_Course__c courseObj;
        if(cInfo != null){
            courseObj = new pss_Course__c();            
            //courseObj.Course_Category__c = cInfo.category;
            courseObj.name = cInfo.fullname;
            courseObj.Moodle_Course_Id__c = cInfo.id;
            //courseObj.Course_Id__c = cInfo.id;            
            courseObj.Course_Label__c = cInfo.idnumber;
            //courseObj.Summary__c = cInfo.summary;
            
            /*
            DateTime startDateValue = convertToDateTime(cInfo.startDate);
            if(startDateValue != null)
                courseObj.Start_Date__c = startDateValue.Date();
            
            DateTime timeCreatedValue = convertToDateTime(cInfo.timeCreated);
            if(timeCreatedValue != null)
                courseObj.Time_Created__c = timeCreatedValue;
            
            DateTime timeModifiedValue = convertToDateTime(cInfo.timeModified);
            if(timeModifiedValue != null)
                courseObj.Time_Modified__c = timeModifiedValue;
            */
            
             if((cInfo.startdate != null) && (cInfo.startdate != '')){
                courseObj.plms_startdate__c = cInfo.startdate;
                
                //Anuja Added this code to correct the format of  start date
               Integer sdate = Integer.valueof(cInfo.startdate);
                System.debug(' startdate testing plms_startdate__c' +sdate );
                Long ll = sdate * 1000L;
                DateTime dd = DateTime.newInstance(ll);
                dd = dd.Date() +1 ;
                System.debug('added to date '  +dd);
               // dd= dd +1;
                System.debug('added to dd '  +dd);
                
                courseObj.Start_Date__c = dd + 1;
            
            }
            
        }
        return courseObj;
    }
    /*
    private DateTime convertToDateTime(string unixTimeStamp){
        if(string.isNotBlank(unixTimeStamp)){
            DateTime newDT = DateTime.newInstance(0);
            Integer secondsTillNow = integer.valueOf(unixTimeStamp);
            if(secondsTillNow != 0)
                return newDT.addSeconds(secondsTillNow);
        }
        return null;
    }
    */
    private Course_Info_Collection parseMoodleCourses(string moodleJSON){
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(moodleJSON);
        Course_Info_Collection moodleCourses = new Course_Info_Collection();
        while (parser.nextToken() != null) {                               
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                while (parser.nextToken() != null) {                        
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_DATA){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        while(parser.nextToken()!=null){                                
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                // Read entire object                            
                                Course_Info courseInfo = (Course_Info)parser.readValueAs(Course_Info.class);
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
        return moodleCourses;
    }
    
    
    public Course_Compl_Info_Collection createComplResponse(pssMoodle_API_Response apiResponse){        
        Course_Compl_Info_Collection responseObj = new Course_Compl_Info_Collection();
        
        if(apiResponse.error == null){
            responseObj = parseMoodleCoursesCompl(apiResponse.message);
        }
        else{
            responseObj.error = apiResponse.error.mexception;
        }
        
        return responseObj;
    }
    
    /* Returns moodle API course response */
    public pssMoodle_API_Response getCourseComplResponse(){
        pssMoodle_API_Response apiResponse;
        if(test.isRunningTest()){
            apiResponse = new pssMoodle_API_Response();
            apiResponse.message = '{"data":[{"iscompleted":false,"coursename":"Prueba Scorm","courseid":"pruebascorm","progress":"0","score":"0.00","last_login":"01/17/2015","userid":"23"},{"iscompleted":false,"coursename":"prueba2 Scorm","courseid":"23","progress":"0","score":"0.00","last_login":"01/17/2015","userid":"23"}],"code":1,"status":200}';
        }
        else
        {
            List<KeyValuePair> parameterList = new List<KeyValuePair>();
            parameterList.add(new KeyValuePair('ptoken',wstoken));

            DateTime dt;
            /*
            if (pss_moodle_settings__c.getInstance().Last_Course_Sync_Date__c==null)
            {
                //dt=Datetime.newInstance(Date.today().year(),Date.today().month(),Date.today().day());
                dt = DateTime.Now()-3456;
            }
            else 
                dt=pss_moodle_settings__c.getInstance().Last_Course_Sync_Date__c;
            */
            //parameterList.add(new KeyValuePair('sdate',string.valueOf(dt.getTime()/1000)));
            apiResponse = pssapi_Moodle_Proxy.call(ACTION_LISTCOURSES_COMPL , parameterList); 
        }
        return apiResponse;
    }
    private Course_Compl_Info_Collection parseMoodleCoursesCompl(string moodleJSON){
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(moodleJSON);
        Course_Compl_Info_Collection moodleCourses = new Course_Compl_Info_Collection();
        while (parser.nextToken() != null) {                               
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                while (parser.nextToken() != null) {                        
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_DATA){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        while(parser.nextToken()!=null){                                
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                // Read entire object                            
                                Course_Compl_Info courseInfo = (Course_Compl_Info)parser.readValueAs(Course_Compl_Info.class);
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
        return moodleCourses;
    }
    
    /* Converts list of moodle specific course_info objects into list of SFDC native course objects. */
    public static List<pss_Course_Enrollment__c> transformToNativeCourseCompl(Course_Compl_Info_Collection moodleCourses){
        List<pss_Course_Enrollment__c> courses = new List<pss_Course_Enrollment__c>();        
        if (moodleCourses.data!=null && moodleCourses.data.size()>0)
        {
            System.Debug(' moodle courses:' + moodleCourses.data);
            List<pss_Course__c> lCourses = [Select Id,Course_Label__c,Moodle_Course_Id__c From pss_Course__c];
            for(pss_Course__c c:lCourses)
            {
                if (!mCourses.containsKey(c.Moodle_Course_Id__c))
                    mCourses.put(c.Moodle_Course_Id__c,c.id);
            }
            
            Set<String> conEmail= new Set<String>();
            
            for(Course_Compl_Info cInfo : moodleCourses.data){
                if (cInfo.userid !=null && cInfo.userid !='')
                {
                    conEmail.add(cInfo.userid);
                }                
            }
            
            
            List<Contact> lUsers = [Select Id, Email,AccountId,pss_Moodle_User_ID__c From Contact Where pss_Moodle_User_ID__c in: conEmail];
            for(Contact u:lUsers)
            {
                if (!mUser.containsKey(u.pss_Moodle_User_ID__c))
                    mUser.put(u.pss_Moodle_User_ID__c,u);
            }
            
                
            for(Course_Compl_Info cInfo : moodleCourses.data){
                pss_Course_Enrollment__c courseObj = transformCompl(cInfo);
                system.debug('courseObj:::'+courseObj);
                if(courseObj != null)
                    courses.add(courseObj);
            }
        }
        return courses;
    }
    
    
    /* Converts moodle specific course_info object into SFDC native course object. */
    public static pss_Course_Enrollment__c transformCompl(Course_Compl_Info cInfo){
        pss_Course_Enrollment__c courseObj;
        
        
        if(cInfo != null){
            courseObj = new pss_Course_Enrollment__c();
            if (mUser.containsKey(cInfo.userid))
            {
                courseObj.Contact__c = mUser.get(cInfo.userid).id;    
                courseObj.Account__c = mUser.get(cInfo.userid).AccountId;    
            }
            else
            {
                return null;
            }
            if (mCourses.containsKey(cInfo.course_lms_id))
            {
                courseObj.Course__c = mCourses.get(cInfo.course_lms_id);    
            }            
            else
            {
                return null;
            }
                
            courseObj.Last_Login__c = cInfo.last_login;
            courseObj.Completion_Date__c = cInfo.completiondate;            
            //courseObj.Moodle_Enrollment_Id__c= cInfo.shortName;
            courseObj.Progress__c= cInfo.progress;
            courseObj.score__c= cInfo.score;            
            courseObj.Is_Completed__c = Boolean.valueOf(cInfo.iscompleted);
            courseObj.Moodle_Unique_Key__c= cInfo.userid + '_'+cInfo.courseid;
            
            /*
            DateTime startDateValue = convertToDateTime(cInfo.startDate);
            if(startDateValue != null)
                courseObj.Start_Date__c = startDateValue.Date();
            
            DateTime timeCreatedValue = convertToDateTime(cInfo.timeCreated);
            if(timeCreatedValue != null)
                courseObj.Time_Created__c = timeCreatedValue;
            
            DateTime timeModifiedValue = convertToDateTime(cInfo.timeModified);
            if(timeModifiedValue != null)
                courseObj.Time_Modified__c = timeModifiedValue;
            */
        }
        return courseObj;
    }
    
}