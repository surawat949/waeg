@isTest
public class AccountTemplateTriggerHelper_Test {
	private static final String ACCOUNT_TEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
	private static final String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'FR012354',
            shippingPostalCode='76530',
            phone='0102030405'
        );
        insert acc;
        Account_Template__c temp = new Account_Template__c();
        temp.recordTypeId = ACCOUNT_TEMPLATE_MASTER_RT;
        temp.Name = 'Test Template 11';
        insert temp;
        
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;
        
        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = temp.Id,
            Authorization__c = master.Id
        );
        insert aLink;
        
        Account_Template__c template = new Account_Template__c();
        template.Account__c = acc.Id;
        template.recordTypeId = ACCOUNT_TEMPLATE_COPY_RT;
        template.name = temp.Name + ' - ' + acc.name;
        template.Master_Template__c = temp.Id;
        template.Default__c = false;
        template.Active_Authorization_Template__c = false;
        insert template;
        
        Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con1';
        con.AccountId = acc.Id;
        con.Account_Template__c = template.Id;
        insert con;
        
        Contact con2 = new Contact();
        con2.lastname = 'Test';
        con2.FirstName = 'Con2';
        con2.AccountId = acc.Id;
        con2.Account_Template__c = template.Id;
        insert con2;
        
    }
    
     @isTest
    static void testAllMethods() {
        Test.startTest();
        //Account_Template__c tempC = []
        Account_Template__c temp = new Account_Template__c();
        temp.recordTypeId = ACCOUNT_TEMPLATE_MASTER_RT;
        temp.Name = 'Test Template 21';
        insert temp; 
        
        Account_Template__c temp2 = new Account_Template__c();
        temp2.recordTypeId = ACCOUNT_TEMPLATE_MASTER_RT;
        temp2.Name = 'Test Template 22';
        insert temp2; 
        
        Account_Template__c accTemp = [Select Id, name, Account__c,Master_Template__c,Default__c,Active_Authorization_Template__c from Account_Template__c Where recordTypeid =:ACCOUNT_TEMPLATE_COPY_RT limit 1];
        
        Account acc = [Select id, name from Account limit 1];
        Account_Template__c template = new Account_Template__c();
        template.Account__c = acc.Id;
        template.recordTypeId = ACCOUNT_TEMPLATE_COPY_RT;
        template.name = temp.Name + ' - ' + acc.name;
        template.Master_Template__c = temp.Id;
        template.Default__c = true;
        template.Active_Authorization_Template__c = true;
        insert template;
        
        Account_Template__c template2 = new Account_Template__c();
        template2.Account__c = acc.Id;
        template2.recordTypeId = ACCOUNT_TEMPLATE_COPY_RT;
        template2.name = temp2.Name + ' - ' + acc.name;
        template2.Master_Template__c = temp2.Id;
        template2.Default__c = true;
        template2.Active_Authorization_Template__c = true;
        insert template2;
        
        accTemp.Default__c = true;
        accTemp.Active_Authorization_Template__c = true;
        update acctemp;
        
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal2',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;  
        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = temp.Id,
            Authorization__c = master.Id
        );
        insert aLink;
        Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con3';
        con.AccountId = acc.Id;
        con.Account_Template__c = template.Id;
        insert con;
        
        Contact con2 = new Contact();
        con2.lastname = 'Test';
        con2.FirstName = 'Con4';
        con2.AccountId = acc.Id;
        con2.Account_Template__c = template.Id;
        insert con2;
        
        template.Active_Authorization_Template__c = false;
        update template;
        
        delete template2;
        delete temp2;
        
        Test.stopTest();
    }
}