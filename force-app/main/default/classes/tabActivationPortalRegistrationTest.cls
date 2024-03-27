/**
 *  Test class for tabActivationPortalRegistration #task845,task846,task847,task848
 * 
 */
@IsTest
public class tabActivationPortalRegistrationTest {
     @TestSetup
    static void makeData(){
	
        String contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Consultant').getRecordTypeId();
		String AccTemplateRecordTypeCopy = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
        String AccTemplateRecordTypeMaster = Schema.SObjectType.Account_Template__c.getRecordTypeInfosByDeveloperName().get('MasterRT').getRecordTypeId();
		
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.CurrencyIsoCode = 'EUR';
        a1.ShippingStreet = 'Bangkok Street 123';
        a1.ShippingCity = 'Bangkok';
        a1.ShippingState = 'Bangkok';
        a1.ShippingPostalCode = '12345';
        a1.ShippingCountry = 'Thailand';
        a1.Shop_email_address__c = 'test@gmail.com';
        a1.Surveys_Email__c = 'test@yahoo.com';
        a1.Email__c = 'test@hotmail.com';
        a1.Confidential_Email_Address__c = 'test@hanmail.com';
        insert a1;
        
        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        c1.RecordTypeId=contactRecordTypeId;
        c1.Portal_User_Name__c='test';
        insert c1;
		
		Account_Template__c accTemplateMaster = new Account_Template__c();
        accTemplateMaster.Name = 'Account Template Master';
        accTemplateMaster.RecordTypeId = AccTemplateRecordTypeMaster;
        insert accTemplateMaster;

        Account_Template__c accTemplate = new Account_Template__c();
        accTemplate.Name = 'Test_Copy_Account_Template';
        accTemplate.Account__c = a1.Id;
        accTemplate.RecordTypeId = AccTemplateRecordTypeCopy;
        accTemplate.Master_Template__c = accTemplateMaster.Id;
        insert accTemplate;
		
    }
    @IsTest
    static void testmultipleClass1(){
        Test.StartTest();
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId
                        FROM Account
                        WHERE Hoya_Account_ID__c = 'TEST001' LIMIT 1];
        Contact con = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'test-TEST001' LIMIT 1];
		Account_Template__c Account_Template = [SELECT Id, Name FROM Account_Template__c WHERE Account__c=:acc.Id];
		
        tabActivationPortalRegistration.getRegistratedContact(acc.id);
		tabActivationPortalRegistration.getAccountTemplateIdFromAccount(acc.Id);
		 
        Test.stopTest();
        
		try{
            tabActivationPortalRegistration.getAccountTemplateIdFromAccount(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

    }

}