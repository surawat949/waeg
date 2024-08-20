@isTest
private class pss_TestUserCoursesForSearch{


    static testMethod void EnrollContact() {
        
        
        
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
                pss_moodle_user_id__c='23',                
                AccountId = portalAccount1.Id,
                pss_Needs_Moodle_Update__c=false,
                Email = 'test23@test.com'
            );
            insert(contact1);
            
            //Create contact
            Contact contact2 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                pss_moodle_user_id__c='24',
                pss_Needs_Moodle_Update__c=true,
                pss_Needs_Moodle_Insert__c =true,
                Email = 'tes24t@test.com'
            );
            insert(contact2);
            
            contact1.FirstName='TestUpdate';
            
            
            pss_moodle_settings__c objCustomSetting= new pss_moodle_settings__c(
            //Email_Report_Address__c='test@abc.com',Email_Report_From_Address__c='test@abc.com',
            LMS_Client_Push_Period__c=100,LMS_URL__c='http://dev.paradisosolutions.com/moodle23',LMS_WebService_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea');
            Insert objCustomSetting;
            
        pss_Course__c course = new pss_Course__c (name='testCourse3',Course_Label__c='testCourse3',Start_Date__c= Datetime.Now(), Account_Name__c = portalAccount1.Id);
        upsert(course);
        
        Test.StartTest();
        //Contact con = new Contact(Id = conId);
        
        PageReference pageRef = Page.EnrollCourses;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('contactId', contact1.id);

        
        ApexPages.StandardController stdController = new ApexPages.StandardController(contact1);
        
        
        
        pss_UserCourses userCourses = new pss_UserCourses(stdController);
        //userCourses.isredirect=false;
        if(userCourses.getCourselist != null){
            for(Integer i=0; i< userCourses.getCourselist.size();i++){
                userCourses.getCourselist[i].isSelected = true;
            }
        }
        userCourses.filterbyname = '';
        userCourses.startdate = Date.today();
        userCourses.enrollUser();
        userCourses.getCourses();
        userCourses.filterResults();
        userCourses.runSearch();
        Test.StopTest();
       
    }
    
    
   
   
}