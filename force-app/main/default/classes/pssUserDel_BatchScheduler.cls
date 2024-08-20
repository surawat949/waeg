//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// class to select all the partner user records which have unchecked sync'd with moodle flag
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
global with sharing class pssUserDel_BatchScheduler  implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts, Database.Stateful
{
     global List<pssMoodleUserDelManager.MoodleResponse> responses;
    
     global void execute(SchedulableContext ctx) {
        String userQuery ='SELECT ID' +
                            ',LMS_User_Id__c' +                            
                            ' from pssLMS_Delete_User__c' ;
        if (Test.isRunningTest())
        {
            userQuery += ' Limit 1';
        }            
        system.debug('userQuery::::'+userQuery);
        Database.executebatch(new pssUserDel_BatchScheduler(userQuery),200);

        Datetime sysTime = System.now();
//        String period= Label.LMS_Client_Push_Period;
        if (pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c!=null && pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c.intValue()!=0)
        {
            sysTime = sysTime.addMinutes(pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c.intValue());
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug(chron_exp);
            pssUserDel_BatchScheduler moodleScheduler = new pssUserDel_BatchScheduler();
            System.schedule('LMS User Delete Sync Scheduler' + System.now(),chron_exp, moodleScheduler);
        }
        Id cronTrigId = ctx.getTriggerId();
        System.abortJob(cronTrigId);

   }

    global final string query;

    global pssUserDel_BatchScheduler ()
    {
        responses = new List<pssMoodleUserDelManager.MoodleResponse>();
    }

    global pssUserDel_BatchScheduler (String q)
    {
        responses = new List<pssMoodleUserDelManager.MoodleResponse>();
        query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        Decimal errorCount = 0;
        Decimal recordCount = 2001;
        List<Contact> usersForUpdate = new List<Contact>();
        try
        {
            System.debug(Logginglevel.DEBUG,'started with: '+BC.getJobID());
            //get all process step in stage for mll and status initializing - could be any other

            System.debug(Logginglevel.DEBUG,scope);
        
            Map<String,pssLMS_Delete_User__c> mapUsers=new Map<String,pssLMS_Delete_User__c>();
        
            pssMoodleUserDelManager client = new pssMoodleUserDelManager();
            List<pssLMS_Delete_User__c> lstUsers= new List<pssLMS_Delete_User__c>();
            List<pssLMS_Delete_User__c> lstUserstoDelete= new List<pssLMS_Delete_User__c>();
            for(sObject userRecordObject: scope)
            {
                pssLMS_Delete_User__c userRecord = (pssLMS_Delete_User__c) userRecordObject;              
                if (userRecord.LMS_User_Id__c!=null)
                {
                    lstUsers.add(userRecord);
                    if (!mapUsers.containsKey(userRecord.LMS_User_Id__c))
                        mapUsers.put(userRecord.LMS_User_Id__c, userRecord);
                }
            }    
            
            pssMoodleUserDelManager.User_Del_Collection result = new pssMoodleUserDelManager.User_Del_Collection();

            System.debug(Logginglevel.DEBUG,'execute - '+result);
            if (lstUsers.size()>0)
            {
                result = client.DeleteUserInMoodle(lstUsers);         
            }
            
            System.debug(Logginglevel.DEBUG,'execute - '+result);
            if(result.success )
            {
                if (result.data!=null && result.data.size()>0)   
                {
                    for (pssMoodleUserDelManager.MoodleResponse resp : result.data)
                    {
                        if (resp.result=='ok')
                        {
                            if (mapUsers.containsKey(resp.userId))
                                lstUserstoDelete.add(mapUsers.get(resp.userId));
                        }
                    }
                }
                if (lstUserstoDelete.size()>0)   
                     delete lstUserstoDelete;
            }
            
        }
        catch(Exception ex)
        {
            sendErrorEmail(ex);
            System.debug(Logginglevel.ERROR,'execute - ERROR: '+ex);
        }
        finally
        {
            
        }
    }

    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob moodleJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        System.debug(Logginglevel.INFO,'The batch Apex job processed ' + moodleJob.TotalJobItems + ' batches with '+ moodleJob.NumberOfErrors + ' failures.');
        //if(responses.size() > 0)sendResultEmail(moodleJob);
        
        
        
    }
    
 /*     private void sendResultEmail(AsyncApexJob job)
    {
        String synchroResultError = '';
        String synchroResultSuccess = '';
        integer errorCount = 0;
        integer successCount = 0;
       ////
        if(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c != null )
        {
            boolean isDebugModeEnabled = pss_moodle_settings__c.getInstance().Debug_Mode__c;  
            for(pssMoodleUserDelManager.MoodleResponse mResponse : responses)
            {
                if(mResponse.isError)
                {
                    synchroResultError += mResponse + '\n';
                    errorCount++;
                }
                else if(isDebugModeEnabled)
                {
                    synchroResultSuccess += mResponse + '\n';
                    successCount++;
                }
            }
            Messaging.reserveSingleEmailCapacity(1);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {pss_Moodle_Settings__c.getInstance().Email_Report_Address__c};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c);
        
            mail.setSenderDisplayName('LMS synchronisation');
            mail.setSubject('User synchronization report');
            
            // Specify the text content of the email.
            string bodyText = '';
            bodyText = 'Results of user synchronization for job: '+job.Id + '\nTotal processed: '+ responses.size();
            if(isDebugModeEnabled){
                bodyText += '\nNumber of successfull transfers: '+ successCount;
                bodyText += '\n\nSuccess:\n' + synchroResultSuccess;
            }

            bodyText += '\nNumber of errors: '+ errorCount;
            bodyText += '\n\nDetails\nErrors:\n' + synchroResultError;
            mail.setplainTextBody (bodyText);
            
            if (errorCount>0 || (isDebugModeEnabled && successCount>0))
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        ////
    } */ 
    public void sendErrorEmail(Exception ex)
    {
        String message = '';
        /* ////
        if(ex != null)
        {   
            message = 'Error Message:' + ex.getMessage();
            message += '\nError Line:' + ex.getLineNumber();
            message += '\nStack Trace:' + ex.getStackTraceString();
            message += '\nError Type:' + ex.getTypeName();                        
            Messaging.reserveSingleEmailCapacity(1);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {pss_Moodle_Settings__c.getInstance().Email_Report_Address__c};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c);
        
            mail.setSenderDisplayName('LMS Error');
            mail.setSubject('Job Error Report');
            
            // Specify the text content of the email.
            mail.setplainTextBody(message);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
                //// */ 
    }
}