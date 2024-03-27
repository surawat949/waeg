@isTest
private class pssCourseSummary_Test{
static testmethod void validateStandardController(){
            
            
            List<Contact> accountContact = new List<Contact>();
            List<pss_Course__c> CoursesList = new List<pss_Course__c>();
            List<pss_Course_Enrollment__c> enrollmentlist = new List<pss_Course_Enrollment__c>();
            String companyString;
            
            //insert account
            Account testAccount = new Account(Name='Test Company Name123',
            Hoya_Account_ID__c = 'DE123456'
            );
            insert testAccount;
            //insert Contacts
            Contact c = New Contact(LastName='TestContact',AccountId = testAccount.id);
            insert c;
            Contact c1 = New Contact(LastName='TestContact1',AccountId = testAccount.id);
            insert c1;
            accountContact.add(c);
            accountContact.add(c1);
            //insert Courses 
            pss_Course__c course = New pss_Course__c(Name='tCourse',Moodle_Course_Id__c='43');
            insert course;
            pss_Course__c course1 = New pss_Course__c(Name='tCourse1',Moodle_Course_Id__c='42');
            insert course1;
            CoursesList.add(course);
            CoursesList.add(course1);
            //Insert pss_Course_Enrollment__c
            pss_Course_Enrollment__c enrol1 = New pss_Course_Enrollment__c(Name='e1', Account__c =testAccount.id,Contact__c =c.id ,Course__c= course.id , Is_Completed__c =true  );
            insert enrol1;
            pss_Course_Enrollment__c enrol2 = New pss_Course_Enrollment__c(Name='e2', Account__c =testAccount.id,Contact__c =c1.id ,Course__c= course1.id , Is_Completed__c =False  );
            insert enrol2;
            pss_Course_Enrollment__c enrol3 = New pss_Course_Enrollment__c(Name='e3', Account__c =testAccount.id,Contact__c =c1.id ,Course__c= course.id , Is_Completed__c =False  );
            insert enrol3;
            pss_Course_Enrollment__c enrol4 = New pss_Course_Enrollment__c(Name='e4', Account__c =testAccount.id,Contact__c =c.id ,Course__c= course1.id , Is_Completed__c =true  );
            insert enrol4;
            
            
            companyString = testAccount.id;
            
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        pssCourseSummary AccountCourses = new pssCourseSummary(stdController);
        
        PageReference pageRef = Page.pss_CourseContacSummary;
        pageRef.getParameters().put('id', String.valueOf(testAccount.id));
        Test.setCurrentPage(pageRef);
    
        
        //testAccPlan.getaccountContact();
        //testAccPlan.save();
        
        
      }
  }