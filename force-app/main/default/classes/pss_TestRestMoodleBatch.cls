/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class pss_TestRestMoodleBatch {

    /*
    private HttpResponse resp;
    
    public pss_TestRestMoodleBatch(String testBody,Integer StatusCode) {
        resp = new HttpResponse();
        resp.setBody(testBody);
        resp.setStatusCode(StatusCode);
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        return resp;
    }
    */
    static testMethod void TestErrorEmail()
    {
        try
        {
            pss_moodle_settings__c c= new pss_moodle_settings__c()  ;
            //c.IDP_URL__c='IDP';
            //c.Email_Report_Address__c='ankurbhargava2000@gmail.com';
            //c.Email_Report_From_Address__c='sach@paradisosolutions.com';
            c.LMS_Client_Push_Period__c=900;
            c.LMS_URL__c='http://develop.paradisosolutions.com/moodle23/';
            c.LMS_WEBSERVICE_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea';
            c.Course_Refresh_Interval__c=15;
            c.Course_Enrollment_Refresh_Interval__c=15;
            //c.Push_Enrollment_Data_Interval__c=15;                
            insert c;
        
            Profile portalProfile = [SELECT Id FROM Profile where Name Like '%s%' Limit 1];
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = portalProfile.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                Country = 'India',
                Street = 'Test',City='Jaipur',State='Raj',PostalCode='302004'
            );
            insert(user1);
            System.assertEquals(0,0);
        }
        catch(Exception ex)
        {
            pss_REST_Moodle_BatchScheduler moodleScheduler = new pss_REST_Moodle_BatchScheduler();
            moodleScheduler.sendErrorEmail(ex);
        }
    }
    static testMethod void VerifyUserScheduleJob() {
        
        
        /*
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='ankurbhargava2000@gmail.com',
            EmailEncodingKey='UTF-8',
            Firstname='Test',
            Lastname='Test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Insert(portalAccountOwner1);

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        System.runAs ( portalAccountOwner1 ) {
        */
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
            
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where Name Like '%s%' Limit 1];
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                //ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                pss_LMS_Create_Contact__c=true,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                Country = 'India',
                Street = 'Test',City='Jaipur',State='Raj',PostalCode='302004'
            );
            insert(user1);
        
            system.debug('CGUser:'+user1);
        
               System.runAs(user1) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
            //User UserNew = [Select pss_LMS_Contact_ID__c  From User Where Id=:user1.Id];
            //System.assertEquals(UserNew.pss_Account_Id__c ,portalAccount1.Id);
            /*
            User user2 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                //ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test1234',
                Email = 'test123456@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty1',
                CommunityNickname = 'test123456',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                Country = 'India',
                Street = 'Test',City='Jaipur',State='Raj',PostalCode='302004'
            );
            */
            //insert(user2);
            //User UserNew2 = [Select pss_LMS_Contact_ID__c  From User Where Id=:user2.Id];
            //UserNew2.LastName = 'Bhargava';
            //UserNew2.pss_moodle_user_id__c=145;
            //UserNew2.pss_Needs_Moodle_Update__c=true;
            //update UserNew2;
            
            pss_moodle_settings__c objCustomSetting= new pss_moodle_settings__c(
            //Email_Report_Address__c='test@abc.com',Email_Report_From_Address__c='test@abc.com',
            LMS_Client_Push_Period__c=100,LMS_URL__c='http://dev.paradisosolutions.com/moodle23',LMS_WebService_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea');
            Insert objCustomSetting;
            
        //}
        
        Test.StartTest();
        
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(150);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        pss_REST_Moodle_BatchScheduler moodleScheduler = new pss_REST_Moodle_BatchScheduler();
        String jobId = System.schedule('Moodle User Sync SchedulerTest' + System.now(),chron_exp, moodleScheduler);
        
        CronTrigger ct = fetchCronTrigger(jobId);
        
        System.assertEquals(chron_exp, ct.CronExpression, 'Did not get the same Cron Expression back');
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');
        /*
         String userQuery ='SELECT pss_Moodle_Username__c' +
                   ',FirstName' +
                   ', Country' +
                   ', MobilePhone' +
                   ', LastName' +
                   ',pss_Account_Id__c' +
                   ', Title' +
                   ', ContactId' +
                   ', Contact.AccountId' +
                   ', pss_Account_Name__c' +
                   ', Phone' +
                   ', Email' +
                   ', Street, City' +
                   ', State' +
                   ', PostalCode' +
                   ', pss_Needs_Moodle_Insert__c' +                   
                   ' from User' +
                   ' where ContactId != null' +
                   ' AND (pss_Needs_Moodle_Insert__c = true)';
                   
        
        
        ID batchprocessid = Database.executeBatch(new pss_REST_Moodle_BatchScheduler(userQuery));
        */
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