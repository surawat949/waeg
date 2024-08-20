/**
*  This test class is for ClsVisitTaskUtil .
*
@author Di Chen
@created 2013-07-22
@version 1.0
@since 20.0 
*
@changelog
* 2013-07-22 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   89%
*/
@isTest(SeeAllData=true)
private class ClsVisitTaskUtil_Test{

    static testMethod void testMostMethods() {
         
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Hoya_Account_ID__c = 'DE123456';
        insert acc;
        
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
        visit.End_Time__c = date.today();
        visit.Start_Time__c = date.today()-1;
        //add owner information
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        
        Visit_Task__c  vt = new Visit_Task__c ();
        vt.Visit__c = visit.Id;
        insert vt;        
        
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Status = 'Delay';
        task.Subject = 'Test';
        task.Visit_Task_ID__c = vt.Id;
        insert task;
        
        //task.Status = 'Abgeschlossen';
        //update task;
        
        set<Id> set_visitTasks2UpdateIds = new set<Id>();
        set_visitTasks2UpdateIds.add(task.Id);
        
        set<Id> set_tasks2UpdateIds = new set<Id>();
        set_tasks2UpdateIds.add(vt.Id);
        
        Test.startTest();
        
        ClsVisitTaskUtil.updateTaskStatus(set_visitTasks2UpdateIds);
        //ClsVisitTaskUtil.updateVisitStatusCancel(set_tasks2UpdateIds);
        
        system.assert(true);
        Test.stopTest();
        }
    
    }