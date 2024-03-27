@isTest
public class AuthorizationLinkTriggerHelper_Test {
    
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    
    private static final String ACCTEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String ACCTEMPLATE_ORIGINAL_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();

    
	@TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = '123123',
            Billing_Email_address__c = 'account@email.com'
        );
        insert acc;
        
        Authorization__c master = new Authorization__c(
            Authorization_Name__c = 'Access to Portal',
            Claim_Formatted__c = 'accesstoportal',
            RecordTypeId = AUTHORIZATION_ORIGINAL_RT
        );
        insert master;
        
        Account_Template__c at = new Account_Template__c(
            Name = 'Shop Owner',
            RecordTypeId = ACCTEMPLATE_ORIGINAL_RT
        );
        insert at;
        Account_Template__c atCopy = new Account_Template__c(
            Account__c = acc.Id,
            Master_Template__c = at.Id,
            Name = 'Test Acc Shop Owner',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        insert atCopy;
        
		Contact ct = new Contact(
            AccountId = acc.Id,
            FirstName = 'John',
            LastName = 'Contact',
            Account_template__c = atCopy.Id
        );
        insert ct;   
        Contact ct2 = new Contact(
            AccountId = acc.Id,
            FirstName = 'John2',
            LastName = 'Contact2',
            Account_template__c = atCopy.Id
        );
        insert ct2; 
    }
    
    @isTest 
    static void testAllMethods() {
        
        Account_Template__c atCopy = [Select id from Account_Template__c where recordTypeId =:ACCTEMPLATE_COPY_RT limit 1];
		Authorization__c master = [Select id from Authorization__c where recordTypeId =:AUTHORIZATION_ORIGINAL_RT];
        Authorization_Link__c aLink = new Authorization_Link__c(
            Account_Template__c = atCopy.Id,
            Authorization__c = master.Id
        );
        insert aLink;
		
        // Duplicate check
        Authorization_Link__c aLink2 = new Authorization_Link__c(
            Account_Template__c = atCopy.Id,
            Authorization__c = master.Id
        );
        try {
            insert aLink2;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('An Authorization Link between these two entities already exists. Id:'));
        }
        
		Account_Template__c atMaster = [Select id from Account_Template__c where recordTypeId =:ACCTEMPLATE_ORIGINAL_RT limit 1];
        Account acc = new Account(
            Name = 'Test Acc1',
            Hoya_Account_ID__c = '1231231',
            Billing_Email_address__c = 'account1@email.com'
        );
        insert acc;
        Account_Template__c atCopy2 = new Account_Template__c(
            Account__c = acc.Id,
            Master_Template__c = atMaster.Id,
            Name = 'Test Acc1 Shop Owner',
            RecordTypeId = ACCTEMPLATE_COPY_RT
        );
        insert atCopy2;
        
        Authorization_Link__c aLink3 = new Authorization_Link__c(
            Account_Template__c = atMaster.Id,
            Authorization__c = master.Id
        );
        insert aLink3;   
    }
}