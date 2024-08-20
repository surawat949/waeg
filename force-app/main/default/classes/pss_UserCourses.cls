public with sharing class pss_UserCourses {

     // Purpose: Custom Chatter profile page
    private ApexPages.StandardController c;
    // Getter methods you can call from your Visualforce page, e.g.{! viewingMyProfile }
    public User subjectUser { get; set; }
    public Date startdate { get; set; }
    public String filterbyname { get; set; }
       
  
   
    public boolean viewingMyProfile { get; set; } // Whether or not  I’m viewing my profile
    public String viewerID { get; set; } // UID string for the viewing    user
    public String subjectID { get; set; } // UID string for the subject 4 Customizing Chatter Profile Pages Options for Building a Profile Tab user (being viewed)    // Constructor method for the controller
    
    private Contact student;
    public list<WrapperCourse> getCourselist{
    get { if((tempCourselist == null) || (tempCourselist.isEmpty()))
                return courselist;
          else
                return tempCourselist;      
        } 
    
    set {courselist=value;}}
    private list<WrapperCourse> courselist;
    private list<WrapperCourse> tempCourselist;
    public static final String CHARSET = 'UTF-8';
    private final string TEXT_DATA = 'message';
    private final string TEXT_STATUS = 'status';
    //public static final String API_ENDPOINT = pss_moodle_settings__c.getInstance().LMS_URL__c + '/auth/saml/webservice/user_enrolment.json'; //'http://10.203.10.169/moodle/local/token/index.php?';
    public static final String API_ENDPOINT = pss_moodle_settings__c.getInstance().LMS_URL__c + '/local/plms_rest/user_enrolment.json'; //'http://10.203.10.169/moodle/local/token/index.php?';
    //local/plms_rest
    public static final String WS_TOKEN = pss_moodle_settings__c.getInstance().LMS_WebService_Token__c; 
    public String userId;
    list<pss_Course__c> courses = new list<pss_Course__c>();
    public String URL { get; set; }
    public static final String DIGEST_ALGO = 'hmacMD5';
    public static final String SALT = '7cd0742a-56fe-4561-88a1-17cc899c2de7';
    public List<string> alphabet{get;set;}
    public List<string> alphaletter{get;set;}
    
    public void refreshList() { 
    courselist = null;
    }
    
    public void fillUsers()
    {
    

         alphabet=new string[]{'All','a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };  
        //this.student= (User)stdController.getRecord();
        //system.debug(this.student.id);
        courses=database.query('Select id,name,Start_Date__c,Course_Label__c, plms_startdate__c, Account_Name__c from pss_Course__c limit 100');
        Map<Id, pss_Course__c> myCourseMap =  new Map<Id, pss_Course__c> ([Select Id,Start_Date__c, Name, plms_startdate__c, Account_Name__c From pss_Course__c WHERE ID in (SELECT Course__c FROM pss_Course_Enrollment__c Where Contact__c =:student.id)]) ;
        
        //system.debug(student.id);
        //system.debug(myCourseMap);
        getCourselist = new list<WrapperCourse>();
        for(pss_Course__c a : courses) {
            WrapperCourse aw = new WrapperCourse();
            aw.course= a;
            if (myCourseMap.containsKey(a.Id))
            {
                aw.isSelected = true;
            }
            //aw.accountname = getAccountName(a.Account_Name__c);
            system.debug(a);
            if(a.Start_Date__c != null)
            {
            DateTime dt = DateTime.now();
            dt = a.Start_Date__c;
            aw.formattedDate = dt.format('MM/dd/YYYY');
            }
            courselist.add(aw);
        }
        WrapperCourse all = new WrapperCourse();
        all.course = new pss_Course__c();
        all.course.Name = 'All';
        all.isSelected = false;
        all.formattedDate = '';
        
        courselist.add(all);
    }
 
 /*  private String getAccountName(String account){
   
        system.debug('AcountNameID:::'+account);   
         
        if((account == '') || (account == null)){
            return '';
        }else{
            Account getAccount;
            getAccount= [Select Name From Account WHERE ID =: account Limit 1] ;
            return getAccount.Name;
        }
        return '';
   } 
    */
    
    
    
    
      // runs the actual query
  public void runQuery() {

  }

  // runs the search with parameters passed via Javascript
    // the soql without the order and limit
  private String soql {get;set;}
  
  public PageReference runSearch() {

    String firstName = Apexpages.currentPage().getParameters().get('firstname');

    soql = 'select firstname from contact where account.name != null';
 
    // run the query again
    runQuery();

    return null;
  }

    
    public Pagereference enrollUser()
    {    
        String ids = '';
        system.debug(courselist);
        
        WrapperCourse all = courselist.get(courselist.size()-1);
        if ((all.isSelected == true) && (all.course.Name == 'All courses')){
                 for(WrapperCourse cw : courselist) {
                     cw.isSelected = true;
                 }
        }
        
        for(WrapperCourse cw : courselist) {
        
            if(cw.course.Name == 'All courses'){
                break;
            }
            
            if (cw.isSelected==true)
            {
                ids += cw.course.Course_Label__c + ',';
            }
        }
        if(ids.length() > 0) {
            ids = ids.substring(0, (ids.length() - 1));
        }
        
        Map<String, String> params = new Map<String, String>();
        Date today = Date.today();
        //params.put('timestamp', EncodingUtil.urlEncode(today.format(), CHARSET));
        String strTocken = WS_TOKEN;
        params.put('ptoken', EncodingUtil.urlEncode(strTocken, CHARSET));
        //params.put('token', EncodingUtil.urlEncode(SALT, CHARSET));
        params.put('users[0][username]', EncodingUtil.urlEncode(this.student.username__c, CHARSET)); //AccountName Username
         
        //params.put('password', EncodingUtil.urlEncode('', CHARSET));
        if (student.firstname!=null)
            params.put('users[0][firstname]', EncodingUtil.urlEncode(this.student.firstname, CHARSET));
        else
            params.put('users[0][firstname]', EncodingUtil.urlEncode('', CHARSET));
        params.put('users[0][lastname]', EncodingUtil.urlEncode(this.student.lastname, CHARSET));
        params.put('users[0][city]', EncodingUtil.urlEncode('', CHARSET)); 
        params.put('users[0][email]', EncodingUtil.urlEncode(student.email, CHARSET));
        params.put('users[0][idcourses]', EncodingUtil.urlEncode(ids, CHARSET));
        //Anuja added on 02/07/2017 /// 
        if (this.student.pss_Moodle_User_ID__c != null)
        {
            params.put('users[0][userid]', EncodingUtil.urlEncode(this.student.pss_Moodle_User_ID__c, CHARSET));
        }
        
        String postParams = '';
        Set<String> keySet = params.keySet();
        for(String key : keySet) {
            postParams += key + '=' + params.get(key) + '&';
        }
        postParams = postParams.substring(0, postParams.length() - 1);
        system.debug(postParams);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint(API_ENDPOINT + '?' + postParams);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setBody(postParams);
        HttpResponse res;
        if(!Test.isRunningTest()) {
            res = h.send(req);            
        } else {
            res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            //res.setBody('{"done":true,"message":"user update","iduser":"3","enrolmentid":"1,4","courseid":"pruebascorm,prueba2scorm","firstname":"Paradiso","lastname":"Solutions","email":"felipe@paradisosolutions.com","username":"felipe@paradisosolutions.com.desarrollo","city":""}');
            res.setBody('[{"done":true,"idcourses":"testCourse3","useremail":"test23@test.com","userid":"23","message":"user update"}]    ');
        }
            
        if (res.getStatusCode()==200)
        {
            string result = res.getBody();            
            system.debug('result::::'+result);
            User_Info u = parseMoodleUser(result);
            system.debug('User Info::::'+u);
            if (u!=null && u.done!='false')
            {
                processAPIResult(u);
            }
            else
            {
                if (u!=null && u.message !=null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, u.message));
                }
            }
            
        }
            
        
        
        //fillUsers();
       pageReference del = ApexPages.currentPage();
       //del.setRedirect(true);
       return del;
        //return ApexPages.currentPage();
    }

    public void CancelfilterResults()
    {    
    tempCourselist = null;
    }
    
    public void filterResults()
    {    
        
        //system.debug(courselist);
      if((startdate != null) | (filterbyname != '' )){
        
        system.debug('startdate:::'+startdate);
        system.debug('filterbyname:::'+filterbyname);

        if((startdate != null) && (filterbyname != '' )){
            String startday = String.valueOf(startdate.day());
            String startmonth = String.valueOf(startdate.month());
        
            if(startday.length()   == 1) startday = '0'+startday;
            if(startmonth.length() == 1) startmonth = '0'+startmonth;
           
            //String dateStr =  + '/' + startmonth + '/' + startdate.year();
            String dateStr = startmonth + '/' + startday + '/' + startdate.year();
            tempCourselist = new list<WrapperCourse>();
           
            for(WrapperCourse cw : courselist) {
            
            System.debug('dateStr::: ' +dateStr);
            System.debug('cw.formattedDate ::: ' +cw.formattedDate);
            
                if((cw.formattedDate == dateStr) && (cw.course.Name.indexOf(filterbyname) != -1))
                    tempCourselist.add(cw);
            }

            WrapperCourse all = new WrapperCourse();
            all.course = new pss_Course__c();
            all.course.Name = 'All';
            all.isSelected = false;
            all.formattedDate = '';
            tempCourselist.add(all);  
        }
          
        if((filterbyname == null)||(filterbyname == '')){
            system.debug('Searching only for Startdate');

            String startday = String.valueOf(startdate.day());
            String startmonth = String.valueOf(startdate.month());
        
            if(startday.length()   == 1) startday = '0'+startday;
            if(startmonth.length() == 1) startmonth = '0'+startmonth;
           
           // String dateStr = startday + '/' + startmonth + '/' + startdate.year();
            String dateStr = startmonth + '/' + startday + '/' + startdate.year();
            tempCourselist = new list<WrapperCourse>();

            for(WrapperCourse cw : courselist) {
            
            System.debug('dateStr::: ' +dateStr);
            System.debug('cw.formattedDate ::: ' +cw.formattedDate);
            
                if(cw.formattedDate == dateStr)
                    tempCourselist.add(cw);
            }

            WrapperCourse all = new WrapperCourse();
            all.course = new pss_Course__c();
            all.course.Name = 'All';
            all.isSelected = false;
            all.formattedDate = '';
            tempCourselist.add(all);
        }
        
        if((startdate == null) ){
                   
            tempCourselist = new list<WrapperCourse>();

            for(WrapperCourse cw : courselist) {
                if(cw.course.Name.indexOf(filterbyname) != -1)
                    tempCourselist.add(cw);
            }

            WrapperCourse all = new WrapperCourse();
            all.course = new pss_Course__c();
            all.course.Name = 'All';
            all.isSelected = false;
            all.formattedDate = '';
            tempCourselist.add(all);
        }

        
     }
   }
    

    
     
    private void processAPIResult(User_Info result)
    {
        if (String.isNotBlank(result.iduser))
        {
            List<pss_Course_Enrollment__c> cEnrolls = [Select Id,Course__c,Is_Completed__c,Last_Login__c,Moodle_Unique_Key__c,Progress__c,score__c From pss_Course_Enrollment__c where Contact__c=: student.id];
            
            //if (cEnrolls!=null && cEnrolls.size()>0)
            //    delete cEnrolls;
            Map<String,pss_Course_Enrollment__c> myEnrollMap = new Map<String,pss_Course_Enrollment__c>();
            for(pss_Course_Enrollment__c e : cEnrolls) {
                if (!myEnrollMap.containsKey(e.Moodle_Unique_Key__c))                {    
                     myEnrollMap.put(e.Moodle_Unique_Key__c,e);                   
                }
            }
            
    
            if (this.student.pss_Moodle_User_ID__c==null)
            {
                this.student.pss_Moodle_User_ID__c = result.iduser;
                update this.student;
            }
            
            if (String.isNotBlank(result.courseid))
            {    
                Map<String,String> myCourseMap = new Map<String,String>();
                List<pss_Course_Enrollment__c> enrolls= new List<pss_Course_Enrollment__c>();
                for(pss_Course__c a : courses) {
                    if (!myCourseMap.containsKey(a.Course_Label__c))
                    {    
                         myCourseMap.put(a.Course_Label__c,a.id);                   
                    }
                }
                List<String> parts = result.courseid.split(',');
                system.debug('parts:::::'+parts);
                Set<String> delCourses=new Set<String>();
                for(String cid : parts)
                {
                    if (myCourseMap.containsKey(cid))
                    {
                        delCourses.add(myCourseMap.get(cid));
                        if (!myEnrollMap.containsKey(myCourseMap.get(cid)))
                        {
                            enrolls.add(new pss_Course_Enrollment__c(Course__c=myCourseMap.get(cid), Contact__c=student.id,Moodle_Unique_Key__c=result.iduser+'_'+cid));
                        }
                    }
                }
                if (enrolls.size()>0)
                {
                    upsert enrolls Moodle_Unique_Key__c;
                }
                
                List<pss_Course_Enrollment__c> dEnrolls = [Select Id,Course__c,Is_Completed__c,Last_Login__c,Moodle_Unique_Key__c,Progress__c,score__c From pss_Course_Enrollment__c where Contact__c=: student.id and Course__c not in :delCourses];
                if (dEnrolls!=null && dEnrolls.size()>0)
                    delete dEnrolls;
            }
            else
            {
                List<pss_Course_Enrollment__c> dEnrolls = [Select Id,Course__c,Is_Completed__c,Last_Login__c,Moodle_Unique_Key__c,Progress__c,score__c From pss_Course_Enrollment__c where Contact__c=: student.id];
                if (dEnrolls!=null && dEnrolls.size()>0)
                    delete dEnrolls;
            }
        }
    
    }
    private User_Info parseMoodleUser(string moodleJSON){
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(moodleJSON);
        User_Info moodleUser = new User_Info();
        while (parser.nextToken() != null) {                               
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                while (parser.nextToken() != null) {                        
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'userid'){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        moodleUser.iduser=parser.getText();
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'done'){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        moodleUser.done=parser.getText();
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'message'){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        moodleUser.message=parser.getText();
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'enrolmentid'){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        moodleUser.enrolmentid=parser.getText();
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'idcourses'){
                        parser.nextToken();    //Skip the object index and move to object start                            
                        moodleUser.courseid=parser.getText();
                    }
                    else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == TEXT_STATUS ){
                        parser.nextToken();                                    
                        //moodleCourses.success = (parser.getIntegerValue() == 200 ? true : false);  
                        //System.Debug(' Status:' + moodleUser.success);                     
                    }                        
                }
            }                
        }
        return moodleUser;
    }
 
    /* Holds ,moodle course object from API JSON response */    
    private class User_Info{
        public string iduser { get; set;}
        public string enrolmentid {get; set;}
        public string courseid {get; set;}
        public string firstname {get; set;}        
        public string lastname {get; set;}
        public string email {get; set;}
        public string username {get; set;} 
        public string city {get; set;} 
        public string done {get; set;}        
        public string message {get; set;}        
        public User_Info(){
        }
    }

        
    public with sharing class WrapperCourse {
        public pss_Course__c course { get;set; }
        public Boolean  isSelected  { get;set; }
        public String  accountname  { get;set; }
        public String  formattedDate  { get;set; }
        
        public WrapperCourse () {
            //isSelected  = false;
        }
    }
    
    
    
    public pss_UserCourses(ApexPages.StandardController stdController) {
        c = stdController;
        //this.student = (Contact)c;
        subjectID= ApexPages.currentPage().getParameters().get('contactId');
        //system.debug('student::::'+this.student);
        /*
        subjectID = getTargetSFDCUID();        
        system.debug('subjectID:::::'+subjectID);
        // If we're operating inside a tab running inside of a        profile...
        if (subjectID != null) {
            // Inject the sfdc.userId URL parameter value into the id        param
            // so the std User controller loads the right User record
            ApexPages.currentPage().getParameters().put('id',subjectID);
        }
        else
        {
            subjectID=UserInfo.getUserId();
        }
        system.debug('subjectID1:::::'+subjectID);        
        // Load the User record for the user whose profile we’re    viewing
        this.subjectUser = (User)stdController.getRecord();
        Id viewer = Id.valueOf(UserInfo.getUserId());
        Id subject = Id.valueOf(subjectID);
        system.debug('subject:::::'+subject);
        viewingMyProfile = (viewer == subject);
        viewerID = UserInfo.getUserId();
        */

        ////this.student= [Select Id, Name,username,FirstName,LastName,email,pss_Moodle_User_ID__c From User WHERE ID =: subjectID Limit 1] ;
        this.student= [Select Id, username__c,Name,FirstName,LastName,email,pss_Moodle_User_ID__c From Contact WHERE ID =: subjectID Limit 1] ;
        system.debug('student:::::'+student);
        fillUsers();
        /*
        Datetime myDT = Datetime.now();
        String unixTime = ''+myDT.getTime()/1000;
        long timeStamp = System.currentTimeMillis()/1000;
        //string token = EncodingUtil.convertToHex(generateToken());
        String token =EncodingUtil.urlEncode(SALT, 'UTF-8');
        URL=Label.pssMoodle_SSO_URL +'?timestamp='+ timeStamp +'&name='+ EncodingUtil.urlEncode(student.name, CHARSET) +'&username='+ EncodingUtil.urlEncode(student.username, CHARSET) +'&email='+ EncodingUtil.urlEncode(student.email, CHARSET) +'&lastname='+ EncodingUtil.urlEncode(student.lastname, CHARSET) +'&city=&token=' + token;
        system.debug('URL:::::'+URL);
        */
    }
    /*
    private Blob generateToken(){
        Datetime myDT = Datetime.now();
        String unixTime = ''+myDT.getTime()/1000;
        long timeStamp = System.currentTimeMillis()/1000;
        Blob data = crypto.generateMac(DIGEST_ALGO, Blob.valueOf(SALT), Blob.valueOf(timeStamp + student.username + student.Email));
        return data;
    }


    // Fetches URL parameter passed into a profile tab indicating which user is being viewed
    private String getTargetSFDCUID() {
        return ApexPages.currentPage().getParameters().get('sfdc.userId');
    }
    */
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Course__c, Course__r.Name,Is_Completed__c,Last_Login__c,Progress__c,score__c FROM pss_Course_Enrollment__c Where Contact__c=: student.id]));
            }
            return setCon;
        }
        set;
    }
    public List<pss_Course_Enrollment__c> getCourses() {
        
        return (List<pss_Course_Enrollment__c>) setCon.getRecords();
        
    }
    
    
}