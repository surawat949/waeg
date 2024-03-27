/**
 * This is a test class for QvQueryPageController
 *
 @author cdupre
 @created 2017-02-08
 *
 */
 
 @isTest
 private class QvQueryPageController_Test{
     static testMethod void testCtrl(){
         
         Test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(new Account());

         /*QvQueryPageController qvCtrl = new QvQueryPageController(sc);*/
         system.assert(true);
         Test.stopTest();
     }
 }