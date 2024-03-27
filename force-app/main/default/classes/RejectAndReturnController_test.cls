/*
 ===================================================================
 Test class for Reject and Return -- RejectAndReturn_CS__c
 Created by : Surawat Sakulmontreechai | sakulmontreechai@yahoo.com
 Created date : 2022-09-13
 ===================================================================
 */

@isTest
public with sharing class RejectAndReturnController_test {
    public RejectAndReturnController_test() {

    }
    @TestSetup
    static void makeData(){
        RejectAndReturn_CS__c r = new RejectAndReturn_CS__c();
        r.S_Form_Reference_Number__c = 'test-2222';
        insert r;
    }
    @isTest
    static void runTestReject01(){

        Integer year = Date.today().year();
        Integer month = Date.today().month();
        Integer counter = [select count() from RejectAndReturn_CS__c]+1;
        String text1 = 'CS-'+String.valueof(year).substring(2)+String.valueof(month).leftPad(2, '0')+String.valueof(counter).leftPad(4, '0');
        System.debug('Counter number is '+text1);

        RejectAndReturn_CS__c r = new RejectAndReturn_CS__c();
        r.Name = text1;
        r.S_Form_Submission__c = false;
        r.Sequence_Number__c = text1;
        insert r;

        List<RejectAndReturn_CS__c> lst = new List<RejectAndReturn_CS__c>([select name, S_Form_Submission__c, S_Form_Reference_Number__c from RejectAndReturn_CS__c where name=:text1]);
        Test.StartTest();
        RejectAndReturnController.doRejectReturnBeforeInsert(lst);
        System.assert(true);

    }
    @isTest
    static void runTestReject02(){
        RejectAndReturn_CS__c r = new RejectAndReturn_CS__c();
        r.S_Form_Reference_Number__c = 'test-1111';
        r.Sequence_Number__c = r.S_Form_Reference_Number__c;
        r.S_Form_Submission__c = true;
        insert r;

        List<RejectAndReturn_CS__c> lst = new List <RejectAndReturn_CS__c>([select id, name, S_Form_Reference_Number__c, S_Form_Submission__c from RejectAndReturn_CS__c where S_Form_Reference_Number__c='test-1111']);
        Test.StartTest();
        RejectAndReturnController.doRejectReturnBeforeInsert(lst);
        System.assert(true);
    }
}