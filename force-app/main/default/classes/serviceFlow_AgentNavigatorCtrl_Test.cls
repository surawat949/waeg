/**
* @description       : controller method for case serviceFlow_AgentNavigator.cmp
* @author            : Mohan G (Encora)
* @group             : 
* @last modified on  : 01-15-2022
* @last modified by  : Mohan G (Encora)
* @Class             : serviceFlow_AgentNavigatorCtrl
**/
@isTest
public class serviceFlow_AgentNavigatorCtrl_Test {
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
    
    @testSetup static void setup() {
        List<Case> testCases = new List<Case>();
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
        
        for(Integer i=0; i<2; i++) {
            Case caseObj = New Case();
            caseObj.Status = 'New';
            caseObj.AccountId = accObj.Id;
            caseObj.ContactId = conObj.Id;
            caseObj.serviceFlow_Case_Type__c = 'Complaints';
            caseObj.Priority = 'Medium';
            caseObj.Send_Email__c = true;
            caseObj.serviceFlow_Send_a_reminder__c = true;
            caseObj.Ticket_created_date__c = system.now();
            caseObj.serviceFlow_Due_Date__c = system.now() + 5;
            caseObj.Description = 'test hoya';
            caseObj.SFlow_Subject__c = 'Job status';
            caseObj.Origin = 'E-Mail';
            caseObj.User_country__c = 'USA';
            caseObj.SFlow_Subject__c = 'Job status';
            caseObj.SFlow_Sub_Subject__c = 'Outsource';
            caseObj.RecordTypeId = caseRecordTypeName;
        }
        insert testCases;
        
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
    }
    
    public Static testmethod void getUserDataTest(){
        Account accRec = [SELECT Id, Name FROM Account LIMIT 1];
        serviceFlow_AgentNavigatorCtrl.serviceFlowAgentNavWrapper sflowWrap = serviceFlow_AgentNavigatorCtrl.getUserData('ServiceFlow Case Create', accRec.Id);
        system.assertNotEquals(null, sflowWrap, 'This method test will be returning the wrapper');
        try {
            serviceFlow_AgentNavigatorCtrl.getUserData('', '');    
        } catch (exception ex) {
            system.debug('Exception Here -- ' + ex);
        }
    }
    
    public Static testmethod void createTaskTest(){        
        Task taskObj = [Select WhatId, Account__c, CallType, SFlow_Subject__c, 
                        SFlow_Sub_Subject__c, serviceFlow_Origin__c, Description, 
                        serviceFlow_User_Country__c, Subject, TaskSubtype, Status 
                        FROM Task LIMIT 1];
        String callData;
        try {
            callData = JSON.serialize(taskObj, true);
            serviceFlow_AgentNavigatorCtrl.createTaskforCall(callData);
            serviceFlow_AgentNavigatorCtrl.createTaskUtility(callData);
        } catch (exception ex) {
            system.debug('Exception Here -- ' + ex);
            taskObj.Id = null;
            callData = JSON.serialize(taskObj, true);
            string taskId = serviceFlow_AgentNavigatorCtrl.createTaskforCall(callData);
            Task taskRec = [Select Id FROM Task WHERE Id =:taskId];
            system.assertNotEquals(null, taskRec, 'Task Record is Inserted Successfully');
        }
        
    }
    public Static testmethod void createTaskUtilityTest(){        
        Task taskObj = [Select WhatId, Account__c, CallType, SFlow_Subject__c, 
                        SFlow_Sub_Subject__c, serviceFlow_Origin__c, Description, 
                        serviceFlow_User_Country__c, Subject, TaskSubtype, Status 
                        FROM Task LIMIT 1];
        String callData;
        try {
            callData = JSON.serialize(taskObj, true);
            serviceFlow_AgentNavigatorCtrl.createTaskUtility(callData);
        } catch (exception ex) {
        }        
    }
}