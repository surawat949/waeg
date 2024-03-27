/*
* 
*/
@istest
public with sharing class Utility_Test {
    public static testmethod void testsendEmailWithTemplate(){
    	String shopOwner = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
        Account newAcc = new Account();
        newAcc.name='test';
        newAcc.Hoya_Account_Id__c = 'US1231';
        insert newAcc;
        
        Contact con=new Contact();
		con.firstname='TestingN';
        con.lastname='Testing';
        con.email='test@test.com';
        con.recordTypeId = shopOwner;
        insert con;
        Test.startTest();
        Messaging.SingleEmailMessage msg = Utility.buildMailMessage('New_Employee_Registration', con.Id, 'test@test.com');
        Utility.sendEmailWithTemplate('New_Employee_Registration', con.Id, 'test@test.com');
        Utility.getPicklistValue('Account','First_Competitor_local_name__c');
		Utility.getTaskSFDCStandardTask();
        Test.stopTest();
    }

    public static testmethod void testMetadata() {
        Test.startTest();
        Map<String, Community_label_settings__mdt> map1 = Utility.getCommunitiesLabel();
        Map<String, Community_Setting__mdt> map2 = Utility.getCommunitiesSettings();
        Test.stopTest();
    }
}