@isTest
public with sharing class pss_TestMoodle_Client_native {

	static testMethod void testConfigurationPage() 
    {
    	pss_Moodle_Client_native.MoodleUserId muid=new pss_Moodle_Client_native.MoodleUserId();
 		muid.userid = '5';
        
        pss_Moodle_Client_native.MoodleResponse moodleresponse = new pss_Moodle_Client_native.MoodleResponse();
        moodleresponse.userid = '25';
        moodleresponse.code = 'Test';
        moodleresponse.message = 'Test';
        moodleresponse.debuginfo = 'Test';
        moodleresponse.mexception = 'Test';
        moodleresponse.status = 'Available';
        moodleresponse.isError = false;
        moodleresponse.id = '25';
    }   	
    
}