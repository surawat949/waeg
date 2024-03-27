@isTest public class serviceFlow_TrackTrackIntegration_Test {
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
    @isTest public static void testGetTrackTraceOrders(){
        Account accObj = new Account(
            RecordTypeId = accontRecordTypeName,
            Name = '4151982 - Rachyls Eyes 4 U',
            Shop_Name__c = 'Rachyls Eyes 4 U',
            Account_Number_ILog__c = '002646',
            Shop_Country__c = 'DE',
            Account_Status__c = 'Open',
            Phone = '844-736-5773',
            Hoya_Account_ID__c = '4151982',
            NumberOfEmployees = 10,
            DMU__c = 'The Big Nacho Rachyl',
            First_Competitor_global_name__c = 'HOYA',
            First_Competitor_local_name__c = 'HOYA',
            CHCUSTCLASSIFICATIONID__c = 'Ind',
            CHINTERNATIONALGROUP__c = 0,
            Visionary_Alliance__c = 'none',
            Language__c = 'en-us',
            Portal__c = 'usportal',
            Myo_Smart_AuthorizeDealer__c = true,
            Myo_Smart_TrainingComplete__c = false,
            Myo_Kids_Corner__c = true,
            Hoya_Local_Mkt_Campaign_1__c = false,
            Hoya_Local_Mkt_Campaign_2__c = false,
            Onboarding_Customer__c = false,
            Target_List__c = false,
            Potential__c = 0.00,
            Payment_issue__c = false,
            Agreed_Visits__c = 0,
            Financial_Status__c = 'Regular',
            Hunting_Status__c = 'C'
        );
        insert accObj;
        
        Contact conObj = new Contact(
            AccountId = accObj.Id,
            Email = 'testuserhoya@yopmail.com',
            Do_not_visit__c = false,
            Phone = '844-736-5773',
            DoNotCall = false,
            HasOptedOutOfEmail = false,
            HasOptedOutOfFax = false,
            Language_Pick__c = 'English ‎(US)‎',
            Invite_Portal_Email__c = 'HOYA Hub',
            Send_Registration_Email_Flag__c = false,
            LastName = 'test User'
        );
        insert conObj;
        serviceFlow_TrackTrackIntegrationHandler.doGetTrackTraceOrders(accObj.Id);
        serviceFlow_TrackTrackIntegrationHandler.addComments(accObj.Id,'87687687','test record');
        serviceFlow_TrackTrackIntegrationHandler.addCommentsUtility(accObj.Id,'87687687','test record');
        
    }
}