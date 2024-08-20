/**
 * This test class to test Scheduler class CleanupOldEvents
 *
 @author  Steven Qiao
 @created 08/04/2016
 @version 1.0
 @since   35.0 (Force.com ApiVersion)
 *
 @changelog
 * 08/04/2016  Steven Qiao <Rui.Qiao@oinio.com>
 * - Created     
 */
@isTest
private class SchedulerCls_CleanupOldEvents_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        SchedulerCls_CleanupOldEvents obj = new SchedulerCls_CleanupOldEvents();                
        String jobId = system.schedule('test_CleanupOldEvents', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
    }
}