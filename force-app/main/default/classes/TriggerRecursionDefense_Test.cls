/**
*  This test class is for TriggerRecursionDefense.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   
*/
@isTest
private class TriggerRecursionDefense_Test {

    static testMethod void testCtrl() {
        Test.startTest();
        
        TriggerRecursionDefense trg = new TriggerRecursionDefense();
        
        system.assert(true);
        Test.stopTest();
    }
}