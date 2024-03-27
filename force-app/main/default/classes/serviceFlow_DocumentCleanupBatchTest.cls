@isTest public with sharing class serviceFlow_DocumentCleanupBatchTest {
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
    
    @IsTest public static void contentDocumentTest(){
        Test.startTest();
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion');             
            ContentVersion contentVersion_1 = new ContentVersion(
                Title='serviceFlow', 
                PathOnClient ='serviceFlow.jpg',
                VersionData = bodyBlob, 
                serviceFlow_fileupload__c = 'serviceFlow',
                origin = 'H'
            );
            insert contentVersion_1;
                       
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
            //ActivityDate = date.valueOf(testCases[0].serviceFlow_Due_Date__c),
            serviceFlow_Origin__c = 'Social Media',
            WhoId = conObj.Id,
            serviceFlow_User_Country__c = 'USA',
            WhatId = accObj.Id,
            SFlow_Subject__c = 'Accounting or finance',
            SFlow_Sub_Subject__c = 'Statement copy',
            recordtypeId = taskRecordTypeName
        );
        insert sobj;
        
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                            FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
            
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = sobj.id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink;
            
            serviceFlow_DocumentCleanupBatchJob obj = new serviceFlow_DocumentCleanupBatchJob(); 
            DataBase.executeBatch(obj,1);
            
            obj.execute(null);
            System.assertEquals(contentlink.ContentDocumentId,contentVersion_2.ContentDocumentId );
        Test.stopTest();
        
    }
}