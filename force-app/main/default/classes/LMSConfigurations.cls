public with sharing class LMSConfigurations {
    
    //Initialize variable to store Chatter Configuration object
    //public chatter_configuration__c  objC {get;set;}
    
    public enum JobRefreshUnit { SECONDS , MINS }
    Map<Id,cronjobdetail> cronJobDetails;
    public List<cronJobs> scheduledMoodleJobs {get;set;}
    public String abortJobs {get;set;}
    public String startedJobs {get;set;}
    
    public class SchedulableJobConfiguration{
        public string name {get;set;}
        public JobRefreshUnit refreshUnit {get; set;}
        public integer refreshInterval {get; set;}
        
        public SchedulableJobConfiguration(string jobName, JobRefreshUnit unit, integer interval){
            this.name = jobName;
            this.refreshUnit = unit;
            this.refreshInterval = interval;
        }
    }
    
     public class cronJobs{
        public String jobName {get;set;}
        public Boolean jobStatus {get;set;}
        public String jobId {get;set;}
        
        
        public cronJobs(String jobName, Boolean jobStatus ,String jobId ){
            this.jobName = jobName;
            this.jobStatus = jobStatus ;
            this.JobId = jobId;
        }
    }
    
    private List<SchedulableJobConfiguration> jobNames = new List<SchedulableJobConfiguration>();
    
    private void initializeJobNames(Set<String> abortJobsToStart){
        system.debug('jobNames:::'+jobNames);
        system.debug('JobRefreshUnit:::'+jobNames);
        system.debug('jobNames:::'+jobNames);
        integer userPeriod=500;
        integer coursePeriod=0;  
        integer courseCompletionPeriod=0;
        integer userEnrollmentPeriod=0;      
        jobNames.clear();
        if (settings.LMS_Client_Push_Period__c!=null)
        {
            userPeriod = settings.LMS_Client_Push_Period__c.intValue();
        }
        if (settings.Course_Refresh_Interval__c!=null)
        {
            coursePeriod=settings.Course_Refresh_Interval__c.intValue();
        }
        if(settings.Course_Enrollment_Refresh_Interval__c!=null){
            courseCompletionPeriod = settings.Course_Enrollment_Refresh_Interval__c.intValue();
        }
        /*
        if(settings.Push_Enrollment_Data_Interval__c!=null){
            userEnrollmentPeriod = settings.Push_Enrollment_Data_Interval__c.intValue();
        }
        */
        if(abortJobsToStart.contains('LMS User Sync Scheduler')){
            jobNames.add(new SchedulableJobConfiguration('LMS User Sync Scheduler', JobRefreshUnit.MINS, userPeriod));
        }
        if(abortJobsToStart.contains('LMS Course Sync Scheduler')){
            jobNames.add(new SchedulableJobConfiguration('LMS Course Sync Scheduler', JobRefreshUnit.MINS, coursePeriod));
        }
        if(abortJobsToStart.contains('LMS User Delete Sync Scheduler')){
            jobNames.add(new SchedulableJobConfiguration('LMS User Delete Sync Scheduler', JobRefreshUnit.MINS, userPeriod));
        }
        //if(abortJobsToStart.contains('LMS Course Completion Sync Scheduler')){
            //jobNames.add(new SchedulableJobConfiguration('LMS Course Completion Sync Scheduler', JobRefreshUnit.MINS, courseCompletionPeriod));
        //}
        
       /* if(abortJobsToStart == null){
            jobNames.add(new SchedulableJobConfiguration('LMS User Sync Scheduler', JobRefreshUnit.MINS, userPeriod));
            jobNames.add(new SchedulableJobConfiguration('LMS Course Sync Scheduler', JobRefreshUnit.MINS, coursePeriod));
            jobNames.add(new SchedulableJobConfiguration('LMS User Delete Sync Scheduler', JobRefreshUnit.MINS, userEnrollmentPeriod));
            jobNames.add(new SchedulableJobConfiguration('LMS Course Completion Sync Scheduler', JobRefreshUnit.MINS, courseCompletionPeriod));
        }*/
    }
    
    public PageReference getCancel() {
        PageReference homePage = new PageReference('/home/home.jsp');
        homePage.setRedirect(true);
        return homePage ;
    }


    public String getButtonLabel { get; set; }

    private pss_moodle_settings__c settings;

    public LMSConfigurations() { 
        getButtonLabel='Start Job';
        
        
        fetchCronJob();
        //Code ends for Chatter Configuration Object
    }
    

    public pss_moodle_settings__c getSettings() {
        return settings;
    }
    
    public PageReference save() {
    //anuja added this code to create remote site setting from code on create of configuratiion
    
    
       if (Schema.sObjectType.pss_moodle_settings__c.isUpdateable())
       { 
           if(settings.LMS_URL__c.substring(0,7) == 'https://'){
               settings.URL__c = settings.LMS_URL__c.substring(8,settings.LMS_URL__c.length());
           }
           if(settings.LMS_URL__c.substring(0,6) == 'http://'){
               settings.URL__c = settings.LMS_URL__c.substring(7,settings.LMS_URL__c.length());
           }    
           upsert settings;
       }
       PageReference homePage = new PageReference('/home/home.jsp');
       homePage.setRedirect(true);
       return homePage ;
    }
    
    public void fetchCronJob(){
    
        scheduledMoodleJobs = new List<cronJobs>();
        
        List<CronJobDetail> scheduledJobs = [SELECT Id, Name, JobType 
                                             FROM   CronJobDetail 
                                             WHERE  name Like 'LMS %' Limit 100];
         
        scheduledMoodleJobs.add(new cronJobs('LMS User Sync Scheduler', false , ''));
        scheduledMoodleJobs.add(new cronJobs('LMS Course Sync Scheduler' ,false ,''));
        scheduledMoodleJobs.add(new cronJobs('LMS User Delete Sync Scheduler',false ,''));
        //scheduledMoodleJobs.add(new cronJobs('LMS Course Completion Sync Scheduler',false ,''));
        
        for(CronJobDetail scheduledJob : scheduledJobs){
            if(scheduledJob.name.contains('LMS User Sync Scheduler')){
                scheduledMoodleJobs[0].jobStatus = true ;
                scheduledMoodleJobs[0].jobId = scheduledJob.id;
            }
            else if(scheduledJob.name.contains('LMS Course Sync Scheduler')){
                scheduledMoodleJobs[1].jobStatus = true ;
                scheduledMoodleJobs[1].jobId = scheduledJob.id;
            }                                      
            else if(scheduledJob.name.contains('LMS User Delete Sync Scheduler')){
                scheduledMoodleJobs[2].jobStatus = true ;
                scheduledMoodleJobs[2].jobId = scheduledJob.id;
            }
            /*else if(scheduledJob.name.contains('LMS Course Completion Sync Scheduler')){
                scheduledMoodleJobs[3].jobStatus = true ;
                scheduledMoodleJobs[3].jobId = scheduledJob.id;
            }*/
        }
    }
    
    public PageReference AbortStartedJobs(){
        Set<String> jobsToAbort = new Set<String>();
        for(String jobId : startedJobs.split(',')){
            jobsToAbort.add(jobId);
        }
        List<cronjobdetail> cronJobs = [SELECT Id FROM cronjobdetail WHERE id IN :jobsToAbort];
        List<CronTrigger> cron = [SELECT id FROM CronTrigger WHERE CronJobDetailId IN :cronJobs];
        
        for(CronTrigger cronJob : cron){
            system.abortJob(cronJob.id);
        } 
        return null;
    }
    
    public PageReference startAbortJobs(){
        Set<String> abort_Jobs_To_Start = new Set<String>();
        for(String job : abortJobs.split(',')){
            abort_Jobs_To_Start.add(job);
        }
        //system.assert(false,abortJobsToStart);
        cronJobDetails = new Map<Id,cronjobdetail>([select Id,name,jobtype from cronjobdetail where jobtype = '7']);
        system.debug('cronJobDetails:::'+ cronJobDetails);
        initializeJobNames(abort_Jobs_To_Start);
        if(getButtonLabel == 'Start Synchronization'){
            for(SchedulableJobConfiguration jobConfig : jobNames){
                system.debug('jobConfig.name::::'+jobConfig.name);
                //Schedule only if the job is not already 
                 if(isScheduledAlready(jobConfig) == false)
                 {
                    Schedulable schedulableObj = getJob(jobConfig);
                    system.debug('schedulableObj::::'+schedulableObj);
                    if(schedulableObj != null){                        
                            scheduleJob(schedulableObj, jobConfig);
                    }
                 }
            }
        }
        
        return null;
    }
    
    private boolean isScheduledAlready(SchedulableJobConfiguration jobConfig){
        if(cronJobDetails.size() > 0){
            for(cronjobdetail sfdcJob : cronJobDetails.values()){
                //Schedule only if the job is not already 
                system.debug('sfdcJob.name:::'+ sfdcJob.name + ' jobConfig.name:::'+jobConfig.name);
                if (sfdcJob.name.containsIgnoreCase(jobConfig.name))
                {
                    return true;
                }             
            }
        }
        return false;
    }
    
    private Schedulable getJob(SchedulableJobConfiguration jobConfig){
          Schedulable myJob;
          
          if(jobConfig.name == 'LMS User Sync Scheduler'){
              myJob = new pss_REST_Moodle_BatchScheduler();
          }
          else if(jobConfig.name == 'LMS Course Sync Scheduler'){
              myJob = new pssCourseSync_BatchScheduler();
          } 
          
          else if(jobConfig.name == 'LMS User Delete Sync Scheduler'){
              myJob = new pssUserDel_BatchScheduler();
          }
          /*
          else if(jobConfig.name == 'LMS Course Completion Sync Scheduler'){
              myJob = new CourseComplSync_BatchScheduler();
          }
           
          */        
          return myJob;          
    }
    
    private void scheduleJob(Schedulable moodleScheduler, SchedulableJobConfiguration job){
        if(moodleScheduler != null){
            if (job.refreshInterval==0)
                return;
            Datetime sysTime = System.now();
            if(job.refreshUnit == JobRefreshUnit.SECONDS){
                sysTime = sysTime.addSeconds(job.refreshInterval);
            }
            else if(job.refreshUnit == JobRefreshUnit.MINS){
                sysTime = sysTime.addMinutes(job.refreshInterval);
            }
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug(chron_exp);
            if (!Test.isRunningTest())
                System.schedule(Job.name + System.now(),chron_exp, moodleScheduler);
        }
    }
    public PageReference ResetLMS(){
        if (Schema.sObjectType.pss_Course_Enrollment__c.isQueryable() && Schema.sObjectType.pss_Course_Enrollment__c.isDeletable())
        { 
           List<pss_Course_Enrollment__c> lstEnrolls = [SELECT Id FROM pss_Course_Enrollment__c Limit 1000];
           Delete lstEnrolls ;
        }
        
        if (Schema.sObjectType.pss_Course__c.isQueryable() && Schema.sObjectType.pss_Course__c.isDeletable())
        { 
           List<pss_Course__c> lstCourses = [SELECT Id FROM pss_Course__c Limit 1000];
           Delete lstCourses;
        }
        /*
        if (Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isUpdateable())
        {
            List<User> lstUsers = [SELECT Id,pss_moodle_user_id__c,pss_Needs_Moodle_Update__c FROM User Where pss_moodle_user_id__c !=null Limit 1000];
            for(User u : lstUsers){
                if (Schema.sObjectType.User.fields.pss_moodle_user_id__c.isUpdateable())
                {
                    u.pss_moodle_user_id__c=null;
                }
                
                if (Schema.sObjectType.User.fields.pss_Needs_Moodle_Update__c.isUpdateable())
                {
                    u.pss_Needs_Moodle_Update__c=false;
                }
            } 
            update lstUsers;
        }
        */
        return null;
    }
   
    public void saveSetting()
    {
       settings = pss_moodle_settings__c.getOrgDefaults();       
       set<String> abortJob = new Set<String>();
       initializeJobNames(abortJob);
       /*if(settings.Id == null)
       {
          
       }*/
       //if (settings.Moodle_Job_ID__c==null || settings.Moodle_Job_ID__c=='')
       //if(settings.Jobs_Trigger_Status__c == false)
       {
           getButtonLabel='Start Synchronization';
       }
       /*else
       {
           getButtonLabel='Stop Jobs';
       } */
    }  
}