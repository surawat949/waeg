@isTest
public class HoyaTaskApprovalEmailFlowCtrlTest {
    public static Id taskEditRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();

    @isTest
    static void testPrepareEmailTemplate() {
        // Create test Account and Task records
        Account acc = new Account(
            Name = 'Test Account',
            Hoya_Account_ID__c = '12345',
            OwnerId = UserInfo.getUserId(),
            Strategic_Value_Gross_Sales__c = 100000,
            Strategic_Value_Net_Sales__c = 90000,
            Agreed_Visits__c = 10,
            Agreed_No_of_Digital_Visits__c = 5,
            Requested_Direct_Visits__c = 12,
            Requested_Digital_Visits__c = 7
        );
        insert acc;

        Task taskObj = new Task(
            RecordTypeId = taskEditRecordTypeId,
            Instructions__c = 'test',
            Visit_Update_Request_Open__c = true,
            WhatId = acc.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert taskObj;

        // Call the prepareEmailTemplate method
        String emailTemplateSubmit = HoyaTaskApprovalEmailFlowCtrl.prepareEmailTemplate(taskObj, 'Submit_for_approval');
        String emailTemplateApprove = HoyaTaskApprovalEmailFlowCtrl.prepareEmailTemplate(taskObj, 'Approve');
        String emailTemplateReject = HoyaTaskApprovalEmailFlowCtrl.prepareEmailTemplate(taskObj, 'Reject');

    }

    @isTest
    static void testSendEmail() {
        // Create test Account and Task records
        Account acc = new Account(
            Name = 'Test Account',
            Hoya_Account_ID__c = '12345',
            OwnerId = UserInfo.getUserId(),
            Strategic_Value_Gross_Sales__c = 100000,
            Strategic_Value_Net_Sales__c = 90000,
            Agreed_Visits__c = 10,
            Agreed_No_of_Digital_Visits__c = 5,
            Requested_Direct_Visits__c = 12,
            Requested_Digital_Visits__c = 7
        );
        insert acc;

        Task taskObj = new Task(
            RecordTypeId = taskEditRecordTypeId,
            Instructions__c = 'test',
            Visit_Update_Request_Open__c = true,
            whatId = acc.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert taskObj;

        // Create RequestWrapper
        HoyaTaskApprovalEmailFlowCtrl.RequestWrapper reqWrapper = new HoyaTaskApprovalEmailFlowCtrl.RequestWrapper();
        reqWrapper.recordIds = new List<Id>{taskObj.Id};
        reqWrapper.eventType = 'Submit_for_approval';

        Test.startTest();        
        HoyaTaskApprovalEmailFlowCtrl.sendEmail(new List<HoyaTaskApprovalEmailFlowCtrl.RequestWrapper>{reqWrapper});
        HoyaTaskApprovalEmailFlowCtrl.sendEmail('test@test.com','test','<p>test</p>');
        Test.stopTest();

    }
}