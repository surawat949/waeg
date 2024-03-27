@isTest public class serviceFlow_UpdateCallType_Test {   
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
   
    @testSetup static void setup() {
        Account accObj = new Account(
            RecordTypeId = accontRecordTypeName,
            Name = '4151982 - Rachyls Eyes 4 U',
            Shop_Name__c = 'Rachyls Eyes 4 U',
            //Responsible_Customer_Service_Agent__c = '0059E00000BS1zG',
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
        
        Task sobj = new Task(
            Status__c = 'New',
            Account__c = accObj.Id,
            Priority = 'Low',
            ActivityDate = system.today(),
            serviceFlow_Origin__c = 'Social Media',
            WhoId = conObj.Id,
            CallType = 'Inbound',
            serviceFlow_User_Country__c = 'USA',
            WhatId = accObj.Id,
            SFlow_Subject__c = 'Accounting or finance',
            SFlow_Sub_Subject__c = 'Statement copy',
            recordtypeId = taskRecordTypeName,
            Description = 'Test record please ignore'
        );
        insert sobj;
    }
    @isTest public static void getUserDataTest(){
        Task taskRec = [Select Id,CallType,Subject,SFlow_Subject__c,SFlow_Sub_Subject__c,Description,CreatedDate From Task Limit 1];
        serviceFlow_UpdateCallType.getUserData('ServiceFlow Case Create',taskRec.Id);
        
        taskRec.Description = 'test please update';
        serviceFlow_UpdateCallType.updateTask(taskRec);
        
        taskRec.Description = 'test please update latest';
        serviceFlow_UpdateCallType.updateTaskDescription(taskRec);
        
        taskRec.Description = '';
        update taskRec;
        serviceFlow_UpdateCallType.getUserData('ServiceFlow Case Create',taskRec.Id);
        
        taskRec.Description = '-- test record';
        update taskRec;
        serviceFlow_UpdateCallType.getUserData('ServiceFlow Case Create',taskRec.Id);
    }
}