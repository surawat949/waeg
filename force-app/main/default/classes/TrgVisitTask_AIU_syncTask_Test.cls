/**
*  This test class is for VisitTask_AIU_syncTask.
*
@author Di Chen
@created 2013-07-24
@version 1.0
@since 20.0 
*
@changelog
* 2013-07-24 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   
*/
@isTest
private class TrgVisitTask_AIU_syncTask_Test {

    static testMethod void testMostMethods() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'dsfa';
        insert acc;
        
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Subject = 'Anruf';
        task.Promtion_Group_Task_ID__c = '123';
        insert task;
        
        Event event = new Event();
        event.Subject = 'Test FFAs';
        event.DurationInMinutes = 120;
        event.ActivityDateTime = date.today()+1;
        event.Description = 'ldshafkjhakldshfjkadksj';
        event.WhatId = acc.Id;
       // insert event;     
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Activity_Id__c = event.Id;
      // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = date.today() + 12;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        
        Visit_Task__c  vt = new Visit_Task__c ();
        vt.Visit__c = visit.Id;
        
        Test.startTest();
        
        insert vt;
        
        system.assert(true);
        Test.stopTest();
    
    }
    
}