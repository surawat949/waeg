/**
 *  This apex class aim to test RunBatchCheckController
 *  Surawat Sakulmontreechai - Created
 *  2023-11-16
 *  <<surawat.sakulmontreechai@hoya.com>>
 */

@IsTest
public with sharing class RunBatchCheckController_Test {
    @IsTest
    static void myUnitTest01(){
        Test.StartTest();
        PageReference pageRef = RunBatchCheckController.run();
        System.assert(null != pageRef);
        Test.StopTest();
    }

}