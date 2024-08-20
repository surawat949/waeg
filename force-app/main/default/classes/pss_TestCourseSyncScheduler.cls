@isTest
private class pss_TestCourseSyncScheduler{


    static testMethod void VerifyUserScheduleJob() {
        
        
        //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                Hoya_Account_ID__c = 'DE123456'
                
            );
            insert(portalAccount1);
    
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            insert(contact1);
            
            //Create contact
            Contact contact2 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                pss_moodle_user_id__c='23',
                pss_Needs_Moodle_Update__c=true,
                pss_Needs_Moodle_Insert__c =true,
                Email = System.now().millisecond() + 'test@test.com'
            );
            insert(contact2);
            //insert pss_Course_Enrollment__c
            List <pss_Course_Enrollment__c> enrolList = New List<pss_Course_Enrollment__c>();
            pss_Course_Enrollment__c penrol = new pss_Course_Enrollment__c(Name='enroll', Moodle_Unique_Key__c ='43');
            insert penrol;
            pss_Course_Enrollment__c penrol1 = new pss_Course_Enrollment__c(Name='enroll1', Moodle_Unique_Key__c ='44');
            insert penrol1;
            enrolList.add(penrol);
            enrolList.add(penrol1);
            
            pss_moodle_settings__c objCustomSetting= new pss_moodle_settings__c(
            PLMS_Enrollments__c = true,
            LMS_Client_Push_Period__c=100,LMS_URL__c='http://dev.paradisosolutions.com/moodle23',LMS_WebService_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea');
            Insert objCustomSetting;
            

        
        Test.StartTest();
        
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(150);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        pssCourseSync_BatchScheduler moodleScheduler = new pssCourseSync_BatchScheduler();
        String jobId = System.schedule('Moodle User Sync SchedulerTest' + System.now(),chron_exp, moodleScheduler);
        
        CronTrigger ct = fetchCronTrigger(jobId);
        
        System.assertEquals(chron_exp, ct.CronExpression, 'Did not get the same Cron Expression back');
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');

        Test.StopTest();
    }
    public static CronTrigger fetchCronTrigger(String jobId) {
        return [
            select CronExpression,
                TimesTriggered,
                NextFireTime
            from CronTrigger
            where Id = :jobId
        ];
    }
}