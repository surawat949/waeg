/**
 * This test class used to test class BatchCls_SetCreditHoldForAccount.
 *
 @author  Steven Qiao
 @created 19/02/2016
 @version 1.0
 @since   35.0 (Force.com ApiVersion)
 *
 @changelog
 * 19/02/2016  Steven Qiao <Rui.Qiao@oinio.com>
 * - Created     
 */
@isTest
private class BatchCls_CleanupOldEvents_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
        Test.startTest();
        Event event = new Event();
        event.ActivityDate = Date.today().addyears(-2);
        event.ActivityDateTime = DateTime.now().addyears(-2);
        event.DurationInMinutes = 240;
        insert event;
        
        Event event2 = new Event();
        event2.ActivityDate = Date.today();
        event2.ActivityDateTime = DateTime.now();
        event2.DurationInMinutes = 240;
        insert event2;
        
        list<Event> eventlst = [select id from Event];
        system.debug('01 eventlst: ' + eventlst.size());
        
        BatchCls_CleanupOldEvents batchCls = new BatchCls_CleanupOldEvents();
	    Database.BatchableContext bc;
        Database.QueryLocator ql = batchCls.start(bc);
        
        Date lastyear = Date.today().addYears(-1);
        
        list<Event>list_Events =  [Select Id From Event Where ActivityDate < :lastyear];
        batchCls.execute(bc, list_Events);
        batchCls.finish(bc);
        
        eventlst = [select id from Event];
        system.debug('02 eventlst: ' + eventlst.size());
        
        
        Event event3 = new Event();
        event3.ActivityDate = Date.today().addyears(-2);
        event3.ActivityDateTime = DateTime.now().addyears(-2);
        event3.DurationInMinutes = 240;
        insert event3;
        Test.stopTest();
    }
}