@isTest
public with sharing class pss_TestConfigurations {

    static testMethod void testConfigurationPage() 
    {
        pss_moodle_settings__c c= new pss_moodle_settings__c()  ;
        c.LMS_Client_Push_Period__c=900;
        c.LMS_URL__c='http://develop.paradisosolutions.com/moodle23/';
        c.LMS_WEBSERVICE_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea';
        c.Course_Refresh_Interval__c=15;
        c.Course_Enrollment_Refresh_Interval__c=15;
                     
       insert c;
        
        LMSConfigurations config=new LMSConfigurations();
        config.saveSetting();
        config.getSettings();
        config.save();
        //config.fetchCronJob();
        config.abortJobs='LMS User Sync Scheduler,LMS Course Sync Scheduler,LMS User Enrollment Sync Scheduler,LMS Course Completion Sync Scheduler,LMS User Delete Sync Scheduler';
        config.startAbortJobs();
        config.fetchCronJob();
        config.startedJobs='LMS User Sync Scheduler,LMS Course Sync Scheduler,LMS User Enrollment Sync Scheduler,LMS Course Completion Sync Scheduler,LMS User Delete Sync Scheduler';
        config.AbortStartedJobs();
        config.ResetLMS();
        config.getCancel();        
    }
}