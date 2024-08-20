@isTest
public with sharing class PortalInitCsvImport_test {
    
    @isTest
    public static void runTest() {

        Test.startTest();
        String lang = PortalInitCsvImport.getLanguageList()[0].Id;
        String portal = PortalInitCsvImport.getPortalList()[0].Id;
        String mail = PortalInitCsvImport.getSystemEmailList()[0].Id;

        Account_Template__c template = new Account_Template__c();
        String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
        template.recordTypeId = ACCOUNT_TEMPLATE_MASTER_RT;
        template.name = 'Master Template';
        template.Active_Authorization_Template__c = true;
        insert template;


        Id templateId = PortalInitCsvImport.getMasterTemplate()[0].Id;
        
        Account a = new Account();
        a.Name='XXXXXXXXX';
        a.hoya_account_id__c = 'TEST001';
        insert a;
        String csv= '[{"hoyaAccountID":"TEST001","AccountName":"xxxxxxx","Title":"Mr","FirstName":"guizmo","LastName":"cat","Email":"dupre@hoya.com","Phone":"0123456789"}]';
        PortalInitCsvImport.insertData(csv, templateId, lang, portal, mail);
    }
}