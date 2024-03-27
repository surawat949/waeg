/**
 * This is test class for QVSalesAccountWithSameCOntroller
 * 
 * @author cdupre
 * @created 2020-07-30
 * 
 */
@isTest
public with sharing class QvSalesAccountWithSameParentCtrl_test {
    static testMethod void testCtrl(){
        Test.startTest();

        Account acc = new Account();
        acc.Name='TestCtrl123';
        acc.Hoya_Account_Id__c = 'QVSC1234';
        acc.currencyIsoCode='EUR';
        insert acc;

        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        QvSalesAccountWithSameParentController ctrl = new QvSalesAccountWithSameParentController(sc);
        ctrl.getConversionRate();
        ctrl.getAccountConversionRate();
        ctrl.methodForTest();
        Test.stopTest();
    }
}