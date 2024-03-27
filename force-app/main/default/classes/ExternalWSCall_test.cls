@isTest
public with sharing class ExternalWSCall_test {
    @isTest
    public static void runtest() {

        Test.startTest();
        Account a = new Account();
        a.Hoya_Account_ID__c='SO0033TESTACC';
        a.Name = 'testaccountxx5';
        insert a;
        ExternalWSCall.getnewToken('');
        //ExternalWSCall.isTokenValid();
        ExternalWSCall.doTest('SO0033TESTACC');
        EnrollDigitalPlatform_Controller.enroll('SO0033TESTACC');
        AccountSalesTabComponentController.startEnroll('SO0033TESTACC');
        Test.stopTest();
    }
}