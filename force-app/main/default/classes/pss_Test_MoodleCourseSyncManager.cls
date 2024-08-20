@isTest
private class pss_Test_MoodleCourseSyncManager{
    
    private static testMethod void TestSyncCourseResponse(){
        pssMoodleCourseSyncManager syncMgr = new pssMoodleCourseSyncManager();
        
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
        
        
        pssMoodleCourseSyncManager.Course_Info_Collection response = syncMgr.createResponse(getSuccessfulAPIResponse());
        syncMgr.getAll();
        syncMgr.getCourseComplResponse();
        
        pssMoodleCourseSyncManager.pssCourseJobResult coursejob = new pssMoodleCourseSyncManager.pssCourseJobResult();
        coursejob.success = false;
        coursejob.error = 'Error';
        
        pssMoodleCourseSyncManager.Course_Compl_Info_Collection collection =  syncMgr.createComplResponse(getSuccessfulComplResponse());
        collection.error = 'Error';
        
        System.assertEquals(response.success, true);
        System.assertEquals(response.error, null);

        List<pss_Course__c> courses = pssMoodleCourseSyncManager.transformToNativeCourse(response);
        
        pssMoodleCourseSyncManager.transformToNativeCourseCompl(collection);
    
        //pssMoodleCourseSyncManager.CourseResponse courseresponse; 
        pss_Course__c courseObj = null;
        System.Debug( 'Hello World' + courses );
        for(pss_Course__c course : courses){
            System.Debug( 'Hello World 2' + course );
             if(course.Moodle_Course_ID__c == '1'){
                courseObj = course;
                break;
            }   
        }    
        
        //pss_Course__c courseObj = null;
        //for(pssMoodleCourseSyncManager.Course_Info_Collection course : response.courses){
        //    if(course.Moodle_Course_Id__c == '1'){
                //courseObj = course;
        //        break;
        //    }   
        //}
        System.assertNotEquals(courseObj, null);
        //System.assertEquals(courseObj.pss_Course_Label__c, 'Moodle: Basis');
        //System.assertEquals(courseObj.name, 'Moodle: Basis');
        //System.assertEquals(string.valueOf(courseObj.Start_Date__c), '2013-09-18');
        //System.assertEquals(string.valueOf(courseObj.Time_Created__c), '2013-09-18 14:26:41');
        //System.assertEquals(string.valueOf(courseObj.Time_Modified__c), '2013-09-18 14:26:41');
    }
    
    private static testMethod void TestSycnErrorResponse(){
        pssMoodleCourseSyncManager syncMgr = new pssMoodleCourseSyncManager();
        pssMoodleCourseSyncManager.Course_Info_Collection response = syncMgr.createResponse(getFailedAPIResponse());
        System.assertEquals(response.success, false);        
    }
    
    private static pssMoodle_API_Response getSuccessfulAPIResponse(){
        string messageBody = '{"data":{' +
            '"1":{"id":"1","category":"1","fullname":"Moodle: Basis","shortname":"MB","summary":"","startdate":"1379570400","timecreated":"1379539601","timemodified":"1379539601"},' + 
            '"2":{"id":"2","category":"1","fullname":"AICC Sample2","shortname":"AICC2","summary":"","startdate":"1379570400","timecreated":"1380722934","timemodified":"1380722934"}' +
            '},"code":1,"status":200}';
        pssMoodle_API_Response apiResponse = new pssMoodle_API_Response();
        apiResponse.message = messageBody;
        return apiResponse;
    }
    
    private static pssMoodle_API_Response getSuccessfulComplResponse(){
        string messageBody =  '{"data":[{"iscompleted":false,"coursename":"Prueba Scorm","courseid":"pruebascorm","progress":"0","score":"0.00","last_login":"01/17/2015","userid":"23"},{"iscompleted":false,"coursename":"prueba2 Scorm","courseid":"23","progress":"0","score":"0.00","last_login":"01/17/2015","userid":"23"}],"code":1,"status":200}';
        pssMoodle_API_Response apiResponse = new pssMoodle_API_Response();
        apiResponse.message = messageBody;
        return apiResponse;
    }
    
    private static pssMoodle_API_Response getFailedAPIResponse(){
        string messageBody = '{"code":7,"status":404,"data":"Not Found"}';
        pssMoodle_API_Response apiResponse = new pssMoodle_API_Response();
        apiResponse.message = messageBody;
        return apiResponse;
    }
}