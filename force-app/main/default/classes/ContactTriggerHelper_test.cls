@isTest
public class ContactTriggerHelper_test {
    private static final String ACCOUNT_TEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
	private static final String ACCOUNT_TEMPLATE_MASTER_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    private static final String CONTACT_SHOP_OWNER_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
    
	@TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO012354',
            phone='0102030405',
            Portal__c = 'frportal',
            Shop_Country__c = 'FR'
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
        
        Authorization__c master2 = new Authorization__c(
           Authorization_Name__c = 'is Trade Portal User',
            claim_formatted__c = 'istradeportaluser',
           RecordTypeId = AUTHORIZATION_ORIGINAL_RT
       );
        insert master2;
        
        Authorization__c master3 = new Authorization__c(
           Authorization_Name__c = 'is seiko trade portal user',
            claim_formatted__c = 'isseikotradeportaluser',
           RecordTypeId = AUTHORIZATION_ORIGINAL_RT
       );
        insert master3;
        
        Authorization__c master4 = new Authorization__c(
           Authorization_Name__c = 'is-country-tradeportaluser',
            claim_formatted__c = 'is-country-tradeportaluser',
           RecordTypeId = AUTHORIZATION_ORIGINAL_RT
       );
        insert master4;
        
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
        
        
        
        
        Contact con3 = new Contact();
        con3.lastname = 'Test';
        con3.FirstName = 'Con3';
        con3.AccountId = acc.Id;
        insert con3;
    }
    
    @isTest
    static void testAllMethods() {
        Test.startTest();
        Account_Template__c tempCp = [Select id from Account_Template__c WHERE recordTypeId =: ACCOUNT_TEMPLATE_COPY_RT limit 1];
        Contact con = [Select id, name, Account_Template__c from Contact Where Firstname= 'Con3' limit 1];
        con.Account_Template__c = tempCp.id;
        update con;
        
        Account_Template__c temp = new Account_Template__c();
        temp.recordTypeId = ACCOUNT_TEMPLATE_MASTER_RT;
        temp.Name = 'Test Template 21';
        insert temp; 
        Account acc = [Select id, name from Account limit 1];
        Account_Template__c template = new Account_Template__c();
        template.Account__c = acc.Id;
        template.recordTypeId = ACCOUNT_TEMPLATE_COPY_RT;
        template.name = temp.Name + ' - ' + acc.name;
        template.Master_Template__c = temp.Id;
        template.Default__c = true;
        template.Active_Authorization_Template__c = true;
        insert template;
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
        con.Account_Template__c = template.id;
        update con;
        //
        con.Account_Template__c = null;
        con.Deactivate__c = true;
        update con;
        //
        con.Deactivate__c = false;
        update con;
        Contact con4 = new Contact();
        con4.lastname = 'Test';
        con4.FirstName = 'Con4';
        con4.AccountId = acc.Id;
        con4.OnekeyId__c = 'WD1234';
        con4.email = 'Test@test.com';
        con.RecordTypeId = CONTACT_SHOP_OWNER_RT;
        insert con4;
        List<String> claims = new List<String>();
        claims.add('istradeportaluser');
        Set<Id> conIds = new Set<Id> ();
        conIds.add(con.Id);
        ContactTriggerHelper.assignAllPermissions(conIds, claims);
        
        Test.stopTest();
    }
}