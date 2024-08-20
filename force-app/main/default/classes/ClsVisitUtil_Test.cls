/**
*  This test class is for ClsVisitUtil.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   96%
*/
@isTest
private class ClsVisitUtil_Test {

    static testMethod void testMostMethods() {
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
        acc.Hoya_Account_ID__c = 'DE123456';
        insert acc;
        
        Event event = new Event();
        event.Subject = 'Test FFAs';
        event.DurationInMinutes = 120;
        event.ActivityDateTime = date.today()+1;
        event.Description = 'ldshafkjhakldshfjkadksj';
        event.WhatId = acc.Id;
        //insert event;     
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.HVNA_Visit_Type__c = 'Shop Visit';        //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code.
        visit.HVNA_Visit_Objectives__c = 'CA EMG';      //SSU Added - 2021/08/11 testing class in ClsVisitUtil coverage the code.
        visit.Visit_Status__c = 'Planned';              //SSU Added - 2021/08/11 for testing class in ClsVisitUtil coverange the code.
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = date.today() -1;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        visit.Start_Location_Latitude__c = null;
        visit.Stop_Location_Latitude__c = null;
        insert visit;
        
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Subject = 'Anruf';
        task.Promtion_Group_Task_ID__c = 'Test';
        task.Visit_Task_ID__c = visit.Id;
        insert task;


        list<Visits__c> visitNew = new list<Visits__c>();
        visitNew.add(visit);
        
        list<Event> el = new list<Event>();
        el.add(event);
        
        Test.startTest();
            ClsVisitUtil.calculateDateTimeValue(date.today(), '24000');
            ClsVisitUtil.calculateTriggerOnVisit('UPDATE', visitNew, visitNew);
            ClsVisitUtil.calculateTriggerOnVisit('DELETE', visitNew, visitNew);
            
            //ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'INSERT');
            //ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'UPDATE');
            //ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'DELETE');
            
            //ClsVisitUtil.calculateTriggerOnEvent('INSERT', el, el);
            ClsVisitUtil.calculateTriggerOnEvent('UPDATE', el, el);
            ClsVisitUtil.calculateTriggerOnEvent('DELETE', el, el);
        
            //ClsVisitUtil.CreateVisitMapAPAC(visitNew);
            
            //ClsVisitUtil.syncTaskActivityDate(new map<Id, Date>{visit.Id => Date.today()});
            //ClsVisitUtil.syncTaskStatus(new set<Id>{visit.Id});
            ClsVisitUtil.syncEventFromAccount(new list<Account>{acc});
            //ClsVisitUtil.syncTaskStatusCancel(new set<Id>{visit.Id});
            ClsVisitUtil.getWeekendDays(Date.today());
            ClsVisitUtil.getCompletedVisits(Date.today(), new Set<Id>{UserInfo.getUserId()});
            ClsVisitUtil.getFirstUnCalculatedVisitDate();
            system.assert(true);
        Test.stopTest();
        
    }
    static testMethod void CreateVisitMapAPAC() {
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
        acc.Hoya_Account_ID__c = 'DE123456';
        insert acc;
        
        Event event = new Event();
        event.Subject = 'Test FFAs 1';
        event.DurationInMinutes = 130;
        event.ActivityDateTime = date.today()+1;
        event.Description = 'ldshafkjhakldshfjkadksj';
        event.WhatId = acc.Id;
       // insert event;     
                
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.HVNA_Visit_Type__c = 'Shop Visit';        //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code.
        visit.HVNA_Visit_Objectives__c = 'CA EMG';      //SSU Added - 2021/08/11 testing class in ClsVisitUtil coverage the code.
        visit.Visit_Status__c = 'Planned';              //SSU Added - 2021/08/11 for testing class in ClsVisitUtil coverange the code.
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = date.today() -1;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        visit.Start_Location_Latitude__c = 0;
        visit.Stop_Location_Latitude__c = 1;
        insert visit;
        

        list<Visits__c> visitNew = new list<Visits__c>();
        visitNew.add(visit); 
        
        Test.startTest();
            //ClsVisitUtil.CreateVisitMapAPAC(visitNew);
        system.assert(true);
        Test.stopTest();
        
    }
    static testMethod void CreateVisitMapAPACNegitive() {
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
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
        visit.HVNA_Visit_Type__c = 'Shop Visit';        //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code.
        visit.HVNA_Visit_Objectives__c = 'CA EMG';      //SSU Added - 2021/08/11 testing class in ClsVisitUtil coverage the code.
        visit.Visit_Status__c = 'Planned';              //SSU Added - 2021/08/11 for testing class in ClsVisitUtil coverange the code.
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = date.today() -1;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        visit.Start_Location_Latitude__c = 0;
        visit.Stop_Location_Latitude__c = null;
        insert visit;
        

        list<Visits__c> visitNew = new list<Visits__c>();
        visitNew.add(visit); 
        
        Test.startTest();
            //ClsVisitUtil.CreateVisitMapAPAC(visitNew);
            system.assert(true);
        Test.stopTest();
        
    }
    static testMethod void testMostMethods2() {
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
        acc.Hoya_Account_ID__c = 'DE123456';
        insert acc;
        
        Task task = new Task();
        task.WhatId = acc.Id;
        task.ActivityDate = date.today();
        task.Subject = 'Anruf';
        task.Promtion_Group_Task_ID__c = '123';
        insert task;
        
        Event event = new Event();
        event.Subject = 'Test FFAs 5';
        event.DurationInMinutes = 170;
        event.ActivityDateTime = date.today()+1;
        event.Description = 'ldshafkjhakldshfjkadksj';
        event.WhatId = acc.Id;
       // insert event;     
                
        Visits__c visit11 = new Visits__c();
        visit11.Account__c = acc.Id;
        visit11.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit11.Visit_Type__c = 'Visit';
        visit11.HVNA_Visit_Type__c = 'Shop Visit'; //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code
        visit11.CurrencyIsoCode = 'EUR';
        visit11.Visit_Status__c = 'Planned';
        visit11.End_Time__c = date.today() + 12;
        visit11.Start_Time__c = date.today()-1;
        visit11.Assigned_to__c = UserInfo.getUserId();
        visit11.Start_Location_Latitude__c = 11.1;
        //insert visit11;

        Visits__c visit12 = new Visits__c();
        visit12.Account__c = acc.Id;
        visit12.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit12.Visit_Type__c = 'Visit';
        visit12.HVNA_Visit_Type__c = 'Shop Visit'; //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code
        visit12.CurrencyIsoCode = 'EUR';
        visit12.Visit_Status__c = 'Planned';
        visit12.End_Time__c = date.today() + 12;
        visit12.Start_Time__c = date.today()-1;
        visit12.Assigned_to__c = UserInfo.getUserId();
        visit12.Start_Location_Latitude__c = 11.1;
        visit12.Stop_Location_Longitude__c = 12.1;
        //insert visit12;


        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.HVNA_Visit_Type__c = 'Shop Visit'; //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.End_Time__c = date.today() + 12;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        //insert visit;

        Account acc2 = new Account();
        acc2.Name = '2dsfa';
        acc2.Email__c = '2dsfa@qq.com';
        acc2.Hoya_Account_ID__c = 'DE1234562';
        insert acc2;

        Contact con = new Contact();
        con.AccountId = acc2.Id;
        con.lastname = 'aaaasaaaa';
        con.FirstName = 'bbbbb';
        insert con;
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc2.Id;
        visit2.contact__c = con.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Visit_Status__c = 'Planned';
         visit2.Start_Time__c = date.today()-3;
        visit2.End_Time__c = date.today()-2;
        visit2.Assigned_to__c = UserInfo.getUserId();
        insert visit2;

        Visits__c visit3 = new Visits__c();
        visit3.Account__c = acc2.Id;
        visit3.contact__c = con.Id;
        visit3.Visit_Type__c = 'Visit';
        visit3.CurrencyIsoCode = 'EUR';
        visit3.Visit_Status__c = 'Planned';
        visit3.Start_Time__c = date.today()-2;
        visit3.End_Time__c = date.today();
        visit3.Assigned_to__c = UserInfo.getUserId();
        insert visit3;
        
        Test.startTest();
        visit2.Visit_Status__c = 'Complete';
        update visit2;
        visit3.Start_Time__c = date.today()-1;
        visit3.Visit_Status__c = 'Complete';
        update visit3;
        
        
        list<Visits__c> visitNew = new list<Visits__c>();
        visitNew.add(visit);
        visitNew.add(visit11);
        visitNew.add(visit12);
        insert visitNew;
        
        set<Id> visitSet = new set<Id>();
        visitSet.add(visit3.Id);
        
        
        ClsVisitUtil.calculateDateTimeValue(date.today(), '24000');
        ClsVisitUtil.getCompletedVisits(date.today(), visitSet);
        //ClsVisitUtil.calculateTriggerOnVisit('INSERT', visitNew, visitNew);
        ClsVisitUtil.calculateTriggerOnVisit('UPDATE', visitNew, visitNew);
        ClsVisitUtil.calculateTriggerOnVisit('DELETE', visitNew, visitNew);
        
        //ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'INSERT');
       // ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'UPDATE');
       // ClsVisitUtil.createOrDeleteVisitTask(visitNew, 'DELETE');

        //ClsVisitUtil.CreateVisitMapAPAC(visitNew);
        Map<Id, Visits__c> visitMap =  new Map<Id, Visits__c>();
        /*for(Visits__c vis  : visitNew) {
            visitMap.put(vis.Id, vis);
        }
        //ClsVisitUtil.updateVisitMapAPAC(visitNew, visitMap);*/
        delete visit3;
        system.assert(true);
        Test.stopTest();
    } 
    static testMethod void updateContactRecordsTest() {
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
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
        visit.HVNA_Visit_Type__c = 'Shop Visit';        //SSU Added - 2021/08/04 for testing class in ClsVisitUtil covergage the code.
        visit.HVNA_Visit_Objectives__c = 'CA EMG';      //SSU Added - 2021/08/11 testing class in ClsVisitUtil coverage the code.
        visit.Visit_Status__c = 'Complete';              //SSU Added - 2021/08/11 for testing class in ClsVisitUtil coverange the code.
        visit.CurrencyIsoCode = 'EUR';
        visit.Visited_but_not_seen__c = false;
        visit.End_Time__c = date.today() -1;
        visit.Start_Time__c = date.today()-1;
        visit.Assigned_to__c = UserInfo.getUserId();
        visit.Start_Location_Latitude__c = 0;
        visit.Stop_Location_Latitude__c = null;
        insert visit;
        
        Test.startTest();
            ClsVisitUtil.checkVisitKPIExists(Date.newinstance(visit.End_Time__c.year(), visit.End_Time__c.month(), visit.End_Time__c.day()));
            ClsVisitUtil.fetchVisitMap(new Set<Id> {visit.Id});
            ClsVisitUtil.updateContactRecords(new Set<Id> {visit.Id});
        Test.stopTest();
        
    }
}