//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// class to select all the partner user records which have unchecked sync'd with moodle flag
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
global with sharing class pss_REST_Moodle_BatchScheduler  implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts, Database.Stateful
{
     global List<pss_Moodle_Client_native.MoodleResponse> responses;
    
     global void execute(SchedulableContext ctx) {
        String userQuery ='SELECT ID' +
                            ',FirstName' +                            
                            ', LastName' +
                            ', Email,Phone,Title' +
                            ', pss_Needs_Moodle_Insert__c' +
                            ', pss_Needs_Moodle_Update__c' +
                            ', pss_moodle_user_id__c' +
                            ', username__c' +
                            ', Language_Pick__c' +
                            ', Account.Name' +
                            ', Account.Primary_Buying_Group__c' +
                            ', Account.Primary_Buying_Group__r.Name' +
                            ',MobilePhone,MailingStreet,MailingCity,MailingCountry,LMS_Rol_Contact_1__c,LMS_Rol_Contact_2__c,LMS_Rol_Contact_3__c,LMS_Rol_Contact_4__c,LMS_Rol_Contact_5__c,LMS_Rol_Contact_6__c,LMS_Rol_Contact_7__c,LMS_Rol_Contact_8__c,LMS_Rol_by_Date__c,LMS_Rol_by_Profile__c ' +
                            ' from Contact' +
                            /*' ContactId != null' +*/
                            ' where pss_Needs_Moodle_Insert__c=true and ((pss_Needs_Moodle_Update__c = true and pss_moodle_user_id__c != null) or pss_moodle_user_id__c = null )';
        if (Test.isRunningTest())
        {
            userQuery += ' Limit 1';
        }            
        system.debug('userQuery::::'+userQuery);
        Database.executebatch(new pss_REST_Moodle_BatchScheduler(userQuery),1);

        Datetime sysTime = System.now();
//        String period= Label.LMS_Client_Push_Period;
        if (pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c!=null && pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c.intValue()!=0)
        {
            sysTime = sysTime.addMinutes(pss_Moodle_Settings__c.getInstance().LMS_Client_Push_Period__c.intValue());
            String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            system.debug(chron_exp);
            pss_REST_Moodle_BatchScheduler moodleScheduler = new pss_REST_Moodle_BatchScheduler();
            System.schedule('LMS User Sync Scheduler' + System.now(),chron_exp, moodleScheduler);
        }
        Id cronTrigId = ctx.getTriggerId();
        System.abortJob(cronTrigId);

   }

    global final string query;

    global pss_REST_Moodle_BatchScheduler ()
    {
        responses = new List<pss_Moodle_Client_native.MoodleResponse>();
    }

    global pss_REST_Moodle_BatchScheduler (String q)
    {
        responses = new List<pss_Moodle_Client_native.MoodleResponse>();
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
        
            pss_Moodle_Client_native client = new pss_Moodle_Client_native();

            for(sObject userRecordObject: scope)
            {
                Contact userRecord = (Contact) userRecordObject;              
                pss_Moodle_Client_native.MoodleResponse result = new pss_Moodle_Client_native.MoodleResponse();
                System.debug(Logginglevel.DEBUG,'user - '+userRecordObject);
                System.debug(Logginglevel.DEBUG,'execute - '+result);
                if (userRecord.pss_moodle_user_id__c!=null)
                {
                    result = client.updateUserInMoodle(userRecord);         
                }
                else
                {
                    result = client.createUserInMoodle(userRecord);         
                }
                System.debug(Logginglevel.DEBUG,'execute - '+result);
                if(!result.isError || (result.debugInfo!=null && result.debugInfo.contains('Email address already exists')))
                {           
                    if (Schema.sObjectType.Contact.fields.pss_Needs_Moodle_Update__c.isUpdateable())
                    {
                        userRecord.pss_Needs_Moodle_Update__c = false;
                    }

                    if (result.id!=null && result.id!='')
                    {
                        if (Schema.sObjectType.Contact.fields.pss_moodle_user_id__c.isUpdateable())
                        {
                            userRecord.pss_moodle_user_id__c = String.valueOf(result.id);
                        } 
                    }
                    usersForUpdate.add(userRecord);                                           
                 
                }
                /*else
                {
                    userRecord.pss_moodle_user_id__c = recordCount;
                    recordCount++;
                }*/


                responses.add(result);              
            }           
        }
        catch(Exception ex)
        {
            //sendErrorEmail(ex);
            System.debug(Logginglevel.ERROR,'execute - ERROR: '+ex);
        }
        finally
        {
            update usersForUpdate;
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
    
    private void sendResultEmail(AsyncApexJob job)
    {
        /*
        String synchroResultError = '';
        String synchroResultSuccess = '';
        integer errorCount = 0;
        integer successCount = 0;
        */
        
        /* ////
        if(pss_Moodle_Settings__c.getInstance().Email_Report_From_Address__c != null )
        {
            boolean isDebugModeEnabled = pss_moodle_settings__c.getInstance().Debug_Mode__c;  
            for(pss_Moodle_Client_native.MoodleResponse mResponse : responses)
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
        //// */ 
    }
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