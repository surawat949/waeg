@isTest
private class pssapi_Moodle_Proxy_Test{
    static testMethod void testCall(){        
        Test.startTest();
        List<KeyValuePair> parameterList = new List<KeyValuePair>();
        parameterList.add(new KeyValuePair('updated_from','2013-12-22'));
        parameterList.add(new KeyValuePair('count',10));
        pssMoodle_API_Response apiresponse = pssapi_Moodle_Proxy.call('test/test', parameterList);
        //System.Debug(' My Response:' + apiResponse.message);
         pss_moodle_settings__c c= new pss_moodle_settings__c()  ;
        //c.IDP_URL__c='IDP';
        //c.Email_Report_Address__c='ankurbhargava2000@gmail.com';
        //c.Email_Report_From_Address__c='sach@paradisosolutions.com';
        c.LMS_Client_Push_Period__c=900;
        c.LMS_URL__c='http://develop.paradisosolutions.com/moodle23/';
        c.LMS_WEBSERVICE_Token__c='df2f702f1c9b7bf5c83fabcfbbc92eea';
        c.Course_Refresh_Interval__c=15;
        insert c;
        string message='';
        //EmailServer.sendEmail('Ankur','test',message);
        try
        {
            pssMoodle_Api_Response m = new pssMoodle_Api_Response();
            m.error=new pssMoodle_Api_Response.RestError('asd');           
            List<KeyValuePair> parameterList1;
            parameterList1.add(new KeyValuePair('count',10));            
        }
        catch(Exception ex)
        {
            //string msg = EmailServer.convertToMailMessage(ex);
        }
        // Verify the expressions are the same
        //string str = HelperFunctions.parseDateString('11/11/2014');
        //System.assertEquals(apiResponse.message, '{"success":true,"idst":12345}');
        
        
        Test.stopTest();
    }
    
    
}