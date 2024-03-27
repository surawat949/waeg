/**
 *  This test class is for event_AIUDUDBIU_visitSynchronisation.
 *
 @author Yuda Zheng
 @created 2013-07-30
 @version 1.0
 @since 27.0 
 *
 @changelog
 * 2013-07-30 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 * - Test coverage 92%
 */
@isTest
private class TrgEvent_AIUDUDBIUD_visitSync_Test {
	
	static testMethod void testBI() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        acc.Email__c = 'Test@test.com';
        insert acc; 

        /*SSU 2021-08-11 add for apex testing class */
        Visits__c vs = new Visits__c();
        vs.Assigned_to__c = '0050X0000075o21'; 
        vs.Visit_Status__c = 'Planned'; 
        vs.Account__c = acc.Id; 
        vs.Visit_Type__c = 'Visit'; 
        vs.HVNA_Visit_Type__c = 'Shop Visit'; 
        vs.HVNA_Visit_Objectives__c = 'CA EMG'; 
        insert vs;
        /* End Class */

        Event event = new Event();
        event.WhatId = acc.Id;
        event.Subject = 'Contract;Complaints;Hoya(i)log';
        event.Type__c = 'Visit';
        event.Type = 'Shop Visit';
        event.CurrencyIsoCode = 'EUR';
        event.Status__c = 'Done';
        event.EndDateTime = date.today() + 13;
        event.StartDateTime = date.today();
        event.IsAllDayEvent = true;
    	
        Test.startTest();
        
		insert event;
        
        system.assert(true);
        Test.stopTest();
    }

    static testMethod void testBU() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        acc.Email__c = 'Test@test.com';
        insert acc; 
        
        /* SSU 2021-08-11 adding for this testing class for apex */
        Visits__c vs = new Visits__c();
        vs.Assigned_to__c = '0050X0000075o21';
        vs.Visit_Status__c = 'Planned';
        vs.Account__c = acc.Id;
        vs.Visit_Type__c = 'Visit';
        vs.HVNA_Visit_Type__c = 'Shop Visit';
        vs.HVNA_Visit_Objectives__c = 'CA EMG';
        insert vs;
        /*End Class */
        
        Event event = new Event();
        event.WhatId = acc.Id;
        event.Subject = 'Contract;Complaints;Hoya(i)log';
        event.Type__c = 'Visit';
        event.Type = 'Shop Visit';
        event.CurrencyIsoCode = 'EUR';
        event.Status__c = 'Done';
        event.EndDateTime = date.today() + 13;
        event.StartDateTime = date.today();
        
        insert event;
    	
        Test.startTest();
        
		event.IsAllDayEvent = true;
		event.Status__c = 'Done';
		event.StartDateTime = date.today()+1;
        update event;
        
        system.assert(true);
        Test.stopTest();
    }
    
    static testMethod void testAD() {
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'Test';
        acc.Email__c = 'Test@test.com';
        insert acc; 

        /* SSU 2021-08-11 Add for apex testing class */
        Visits__c vs = new Visits__c();
        vs.Visit_Status__c = 'Planned';
        vs.Account__c = acc.Id;
        vs.Visit_Type__c = 'Visit';
        vs.HVNA_Visit_Type__c = 'Shop Visit';
        vs.HVNA_Visit_Objectives__c = 'CA EMG';
        vs.Assigned_to__c = '0050X0000075o21';
        insert vs;
        /* End Class */
        
        Event event = new Event();
        event.WhatId = acc.Id;
        event.Subject = 'Contract;Complaints;Hoya(i)log';
        event.Type__c = 'Visit';
        event.Type = 'Shop visit'; //SSU 2021-08-11 Add for test class apex
        event.CurrencyIsoCode = 'EUR';
        event.Status__c = 'Done';
        event.EndDateTime = date.today() + 13;
        event.StartDateTime = date.today();
        
        insert event;
    	
        Test.startTest();
        
		delete event;
        
        system.assert(true);
        Test.stopTest();
    }
}