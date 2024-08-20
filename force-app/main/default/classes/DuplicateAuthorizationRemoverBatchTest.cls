@IsTest
private class DuplicateAuthorizationRemoverBatchTest {
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String AUTHORIZATION_ORIGINAL_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();

    private static final String ACCTEMPLATE_COPY_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
    private static final String ACCTEMPLATE_ORIGINAL_RT = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();

    @TestSetup
    static void makeData(){

        User u = [SELECT Id FROM User WHERE CompanyName IN ('HOLI', 'HOLA', 'HLCA', 'HVNA', 'VEUS') AND IsActive = true limit 1];


        Account acc = new Account(
                Name = 'Test Acc',
                Hoya_Account_ID__c = '123123',
                Billing_Email_address__c = 'account@email.com'
        );
        insert acc;

        List<Authorization__c> masterAuthorizations = new List<Authorization__c>{
                new Authorization__c(
                        Authorization_Name__c = 'Access to Portal',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT
                ),
                new Authorization__c(
                        Authorization_Name__c = 'Access to CMS',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT
                )
        };

        insert masterAuthorizations;

        List<Authorization__c> authorizationList = new List<Authorization__c>{
                new Authorization__c(
                        Authorization_Name__c = 'Access to Orders - READ',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT,
                        Parent_Authorization__c = masterAuthorizations.get(0).Id,
                        Active_Authorization__c = false,
                        Claim_Formatted__c = 'pread',
                        Description__c = 'older'
                ),
                new Authorization__c(
                        Authorization_Name__c = 'Access to Orders - READ',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT,
                        Parent_Authorization__c = masterAuthorizations.get(0).Id,
                        Active_Authorization__c = true,
                        Claim_Formatted__c = 'pread2replace',
                        Description__c = 'newer'
                ),
                new Authorization__c(
                        Authorization_Name__c = 'Access to Orders - WRITE',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT,
                        Parent_Authorization__c = masterAuthorizations.get(0).Id,
                        Active_Authorization__c = true,
                        Claim_Formatted__c = 'pwrite2replace',
                        Description__c = 'older'
                ),
                new Authorization__c(
                        Authorization_Name__c = 'Access to Orders - WRITE',
                        RecordTypeId = AUTHORIZATION_ORIGINAL_RT,
                        Parent_Authorization__c = masterAuthorizations.get(0).Id,
                        Active_Authorization__c = false,
                        Claim_Formatted__c = 'pwrite',
                        Description__c = 'newer'
                )
        };

        insert authorizationList;


        Account_Template__c at = new Account_Template__c(
                Name = 'Shop Owner',
                RecordTypeId = ACCTEMPLATE_ORIGINAL_RT
        );
        insert at;

        Authorization_Link__c aLink = new Authorization_Link__c(
                Account_Template__c = at.Id,
                Authorization__c = masterAuthorizations.get(0).Id
        );
        insert aLink;

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
                OwnerId = u.Id
        );
        insert ct;

    }

    @isTest static void checkDuplicates_test() {
        Contact c = [SELECT Id FROM Contact WHERE Name = 'John Contact' limit 1];

        for(Authorization__c auth: [SELECT Id, Name, Authorization_Name__c, Claim_Formatted__c, Active_Authorization__c, Contact__c, DupCheck__c FROM Authorization__c WHERE Contact__c != null]){
//            System.debug(JSON.serialize(auth));
            System.debug('__________________________________________________');
            System.debug('Id: '+auth.Id);
            System.debug('Name: '+auth.Name);
            System.debug('Authorization_Name__c: '+auth.Authorization_Name__c);
            System.debug('Claim_Formatted__c: '+auth.Claim_Formatted__c);
            System.debug('Active_Authorization__c: '+auth.Active_Authorization__c);
            System.debug('Contact__c: '+auth.Contact__c);
        }

        Test.startTest();
        DuplicateAuthorizationRemoverBatch batch = new DuplicateAuthorizationRemoverBatch(new List<Id> {c.Id});
        Database.executeBatch(batch, 1);
        Test.stopTest();

        for(Authorization__c auth: [SELECT Id, Name, Authorization_Name__c, Claim_Formatted__c, Active_Authorization__c, Contact__c, DupCheck__c FROM Authorization__c WHERE Contact__c != null]){
//            System.debug(JSON.serialize(auth));
            System.debug('__________________________________________________');
            System.debug('Id: '+auth.Id);
            System.debug('Name: '+auth.Name);
            System.debug('Authorization_Name__c: '+auth.Authorization_Name__c);
            System.debug('Claim_Formatted__c: '+auth.Claim_Formatted__c);
            System.debug('Active_Authorization__c: '+auth.Active_Authorization__c);
            System.debug('Contact__c: '+auth.Contact__c);
        }



    }
}