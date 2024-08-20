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
    
   public static testMethod void testStatisticsConsolidation(){
        User u = new User();
        u.Firstname = 'test';
        u.Lastname = 'testtest';
        u.Username = 'testtest@hoya.com.test';
        u.Email = 'testtest@hoya.com.invalid';
        u.CompanyName = 'HVC';
        u.ProfileId = '00eb0000000lainAAA';
        u.CurrencyIsoCode = 'USD';
        u.Alias = 'STest';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        Account acc1 = new Account();
        acc1.Name='sales test Germany account';
        acc1.hoya_account_id__c='SO4900999xx';
        acc1.Local_Consolidation_Key__c='123';
        acc1.OwnerId = u.Id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name='sales test account1';
        acc2.hoya_account_id__c='SO3299999xx';
        acc2.Local_Consolidation_Key__c='123';    
        acc2.OwnerId = u.Id;
        insert acc2;
        
        Last_Sales_Statistics__c sales = new Last_Sales_Statistics__c();
        sales.Account__c =acc1.Id;
        sales.Lenses_Net_Sales_CFY__c =100;
        insert sales;
        
        Test.startTest();
        System.assert(true);
        Utility.getConsolidatedAccountsList(acc1.Local_Consolidation_Key__c,'HVC','Net');
        Utility.getConsolidatedAccountsList(acc1.Local_Consolidation_Key__c,'HVC','Gross');
        Utility.getConsolidatedAccountsList(acc1.Local_Consolidation_Key__c,'HVC','Net');
        Test.stopTest();
    }
    public static testmethod void testGetTranslatedPicklistValues() {
        Test.startTest();
            Utility.getTranslatedPicklistValues('Account','Tacticom_SOF__c');
        Test.stopTest();
    }
    public static testmethod void testIsFirstLoginOfDay() {
        Test.startTest();
            Utility.isFirstLoginOfDay();
        Test.stopTest();
    }
}