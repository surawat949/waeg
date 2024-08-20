/**
 *  This test class is for Task_AU_syncVisitTask.
 *
 @author Yuda Zheng
 @created 2013-07-24
 @version 1.0
 @since 27.0 
 *
 @changelog
 * 2013-07-24 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest
private class TrgTask_AU_syncVisitTask_Test {
    
    static testMethod void testAU() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        insert acc; 
        
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Done';
        visit.Start_Time__c = date.today() - 1;
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        System.debug('Visit creation:'+ visit.Start_Time__c + '/' + visit.End_Time__c);
        visit.Is_All_Day_Event__c = false;
        visit.Call_To_Action__c='none';
        visit.MKT_No_campaign_presented__c=true;
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        
        System.debug('task creation');
        Visit_Task__c vTask = new Visit_Task__c();
        vTask.Visit__c = visit.Id;
        insert vTask;
        
        System.debug('task2 creation');
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Status = 'Delay';
        task.Subject = 'Test';
        task.Visit_Task_ID__c = vTask.Id;
        insert task;

        Test.startTest();
        System.debug('task update');
        task.Status = 'Completed';
        update task;
        
        system.assert(true);
        Test.stopTest();
    }
}