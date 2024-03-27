global class pssCourseSync_BatchScheduler implements Database.batchable<pssMoodleCourseSyncManager.CourseResponse>, Schedulable, Database.AllowsCallouts, Database.Stateful{
    /* Represents custome Course exception object */
    private class CourseException extends Exception{}
    
    List<pss_Course__c> courseList;
    //DBOperationStatusNotifier upsertStatusNotifier;
    
    global Iterable<pssMoodleCourseSyncManager.CourseResponse> start(Database.BatchableContext info){
        //Gets all the course by calling Moodle API.
        pssMoodleCourseSyncManager courseSyncMgr = new pssMoodleCourseSyncManager();        
        List<pssMoodleCourseSyncManager.CourseResponse> response;
        try{
            response = courseSyncMgr.getAll();
            // If respose.error contains something that signifies that API response failed with an error.
            /*
            if(string.isNotBlank(response.error)){
                throw new CourseException(response.error);
            }
            // If respose.courses contains non zero items then go to update with criterias.
            //if(response.courses.size() > 0){
                //MoodleCourseCriteriaSyncManager courseCriteriaSyncManager = new MoodleCourseCriteriaSyncManager();
                //courseCriteriaSyncManager.updateCriteriaInfo(response.courses);
            //}            
            courseList = response.courses;            
            */
        }
        catch(Exception exp){
            //EmailServer.sendEmail('Course LMS Error', 'Course Job Error Report', EmailServer.convertToMailMessage(exp));
            System.debug(Logginglevel.ERROR,'CourseSync_BatchScheduler - Start() method: ' + exp);
        }
        return response;
    }
    
    global void execute(SchedulableContext ctx) {        
        
        Database.executebatch(new pssCourseSync_BatchScheduler());
        // Reschedule the course sync batch with an interval of minutes specified in custom settings.
        Datetime sysTime = System.now(); 
        integer interval=5;
        if (Label.pssMoodle_Job_Interval != null)
        {
            interval=Integer.valueof(Label.pssMoodle_Job_Interval);
            sysTime = sysTime.addMinutes(interval);
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug(chron_exp);
            System.schedule('LMS Course Sync Scheduler' + System.now(),chron_exp, new pssCourseSync_BatchScheduler());
        }
        Id cronTrigId = ctx.getTriggerId();
        System.abortJob(cronTrigId);
        
   }
   
    global void execute(Database.BatchableContext info, List<pssMoodleCourseSyncManager.CourseResponse> scope){           
        try{
            if(scope != null && scope.size() > 0){
                List<pss_Course__c> courses = pssMoodleCourseSyncManager.transformToNativeCourse(scope[0].courses);
                Database.UpsertResult[] results = Database.upsert(courses, pss_Course__c.fields.Moodle_Course_Id__c, false);
                set<string> courseMIds = new set<string>();
                for(pss_Course__c a : courses) {                    
                     //courseMIds.add(a.Moodle_Course_Id__c);                                       
                    courseMIds.add(a.id);                                                            
                }
                system.debug('courseMIds::::::'+ courseMIds);
                List<pss_Course_Enrollment__c> dEnrolls = [Select Id,Name From pss_Course_Enrollment__c where not Course__c in :courseMIds];
                if (dEnrolls!=null && dEnrolls.size()>0)
                    delete dEnrolls;
                    
                List<pss_Course__c> dCourses = [Select Id,Name From pss_Course__c where Id not in : courseMIds];
                if (dCourses!=null && dCourses.size()>0)
                    delete dCourses;
                    
                system.debug('courseCGPR::::::'+ scope[0].coursesCompl);    
                List<pss_Course_Enrollment__c> courseCompl = pssMoodleCourseSyncManager.transformToNativeCourseCompl(scope[0].coursesCompl);
                system.debug('courseCG::::::'+ courseCompl);
                
                pss_Course_Enrollment__c[] acctsList = [SELECT Id, Moodle_Unique_Key__c FROM pss_Course_Enrollment__c];
                
                boolean flag;

                for (pss_Course_Enrollment__c a : acctsList) {
                    flag = false;   
                    for (pss_Course_Enrollment__c i : courseCompl) {
                        if(a.Moodle_Unique_Key__c == i.Moodle_Unique_Key__c){
                            flag = true;
                        }
                    }
                    if(flag == false){
                       // Database.delete(a, false);
                    }
                }

                
                boolean isDebugModeEnabled = pss_moodle_settings__c.getInstance().PLMS_Enrollments__c;

                Database.UpsertResult[] results1;
                Database.SaveResult[] results2;

                if(isDebugModeEnabled){
                    results1 = Database.upsert(courseCompl, pss_Course_Enrollment__c.fields.Moodle_Unique_Key__c, false);
                    
                 /*   for(Integer i=0;i<results1.size();i++)
                    {
                    if (results1.get(i).isSuccess()){
                        //updateResults.get(i).getId();
                    }
                    else if (!results1.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = results1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();                        
                        system.debug('failedDML'+failedDML);        
                    }
                    }*/
                }else{
                    results2 = Database.update(courseCompl, false);
                  /*  for(Integer i=0;i<results2.size();i++)
                    {
                    if (results2.get(i).isSuccess()){
                        //updateResults.get(i).getId();
                    }
                    else if (!results2.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = results2.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();                        
                        system.debug('failedDML'+failedDML);        
                    }
                    }*/
                }    


                /*
                upsertStatusNotifier = new DBOperationStatusNotifier(scope, new String[]{'Name','Moodle_Course_Id__c','Id'});
                Database.UpsertResult[] results = Database.upsert(scope, pss_Course__c.fields.Moodle_Course_Id__c, false);
                upsertStatusNotifier.processResults(results);
                pss_moodle_settings__c settings = pss_moodle_settings__c.getOrgDefaults();
                settings.Last_Course_Sync_Date__c=DateTime.Now();
                upsert settings;
                System.Debug(' Rows inserted:' + scope.size());
                */
            }
        }
        catch(DmlException exp){
            //EmailServer.sendEmail('Course Sync LMS Error', 'Course Job Error Report', EmailServer.convertToMailMessage(exp));
            System.debug(Logginglevel.ERROR,'CourseSync_BatchScheduler - Execute() method: ' + exp);
        }        
    }
    
    global void finish(Database.BatchableContext info){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        /*
        AsyncApexJob MoodleJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :info.getJobId()];
        System.debug(Logginglevel.INFO,'The batch Apex job processed ' + MoodleJob.TotalJobItems + ' batches with '+ MoodleJob.NumberOfErrors + ' failures.');
        if(courseList.size() > 0)
            sendResultEmail(MoodleJob);       
        */
    }
    
   /* private void sendResultEmail(AsyncApexJob job)
    {
        
        if(pss_moodle_settings__c.getInstance().Email_Report_From_Address__c != null)
        {               
            // Specify the text content of the email.
            string message = 'Course synchronization for job: ' + job.Id + ' is successful.';
            if(upsertStatusNotifier != null){                
                string mailMessage=upsertStatusNotifier.getMessage();
                if (mailMessage=='')
                {
                    return;
                }
                message += '\n' + upsertStatusNotifier.getMessage();
            }
            EmailServer.sendEmail('Course LMS synchronisation', 'Course synchronization report', message);
            
        }
        
    }*/
}