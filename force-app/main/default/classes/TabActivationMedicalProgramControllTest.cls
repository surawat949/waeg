@isTest
public  class TabActivationMedicalProgramControllTest {
    public TabActivationMedicalProgramControllTest() {

    }
    @testSetup static void setup(){
     Id recordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

      Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'test12312',
            phone='0102030405',
            Onboarding_date__c = date.valueOf(system.now()),
            Onboarding_Customer__c = true,
            Lenses_Net_Sales_Last_12Mo__c = 2,
            Brand_Visibility__c='HOYA',
            CHCUSTCLASSIFICATIONID__c='Ind',
            Seiko_Network__c = 'Visionary Alliance',
            Visionary_Alliance__c = 'Insider',
            ShippingPostalCode = '12345',
            ShippingLatitude=1.2,
            ShippingLongitude=1.7
        );
        insert acc;
        Account acc2 = new Account(
            Name = 'Test AccTESR',
            Hoya_Account_ID__c = 'TE-12312',
            phone='0103030408',
            Account_Status__c='Closed',
            ShippingPostalCode=null,
            ShippingLatitude=null
        );
        insert acc2;
        Account acc3 = new Account(
            Name = 'Test AccTESR1',
            Hoya_Account_ID__c = 'TE-12313',
            phone='0103030408',
            Account_Status__c='Closed'
            /*ShippingPostalCode = '12345',
            ShippingLatitude=1.2,
            ShippingLongitude=1.7*/
        );
        insert acc3;
        Account accAddress = new Account();
        accAddress.Name = 'TestAddress';
        accAddress.hoya_account_id__c = 'TE123456';
        accAddress.RecordTypeId = '012b00000000P38';
        accAddress.shippingCity='Victoria';
        accAddress.ShippingStreet='SH B045 Chatswood Chase S/C 245';
        accAddress.ShippingLatitude=-33.79378366591115;
        accAddress.ShippingLongitude=151.19098186046202;
        accAddress.ShippingCountry='AU';
        accAddress.ShippingPostalCode='2067';
        insert accAddress;
        
        Contact ct = new Contact();
        ct.FirstName = 'Test';
        ct.LastName = 'Contacts';
        ct.AccountId = accAddress.Id;
        ct.RecordtypeId =recordtypeId;
        ct.MailingCity='Victoria';
        ct.MailingStreet='SH B045 Chatswood Chase S/C 245';
        ct.MailingLatitude=-33.79378366591115;
        ct.MailingLongitude=151.19098186046202;
        ct.MailingCountry='AU';
        ct.MailingPostalCode='2067';
        insert ct;
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testtest2@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.Segment_A_Myopic_Child_Patients__c=1;
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;
       Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con1';
        con.AccountId = acc.Id;
        con.RecordtypeId =recordtypeId; 
        con.First_Speciality__c = 'test';
        con.MiyoSmart_Attitude__c='Neutral';
        Con.OwnerId=u.id;
        Con.Myopic_Child_Patients_Per_Week__c=2;
        insert con;
        AccountContactRelation ac = new AccountContactRelation();
        ac.ContactId = con.Id;
        ac.AccountId = acc2.Id;
        ac.Working_Status__c = 'Full Time';

        insert ac;
		
	}

	@isTest static void getContactListTest() {
        
        Test.startTest();
        account act = [Select id,Name from Account where name = 'Test AccTESR' limit 1];
        
        account actAddress = [Select id,Name from Account where Hoya_Account_ID__c = 'TE123456' limit 1];    
        account act2 = [Select id,Name from Account where ShippingPostalCode != null and ShippingLatitude !=null limit 1];
        Contact conId = [SELECT Id,Name,accountId From contact where accountId =:act2.id];
        AccountContactRelation a = [Select ID , AccountId From AccountContactRelation where Account.Name = 'Test Acc' LIMIT 1];
        TabActivationMedicalProgramController.getContactList(act.id);
        TabActivationMedicalProgramController.createAccountContactRel(act.id,conId.Id);
        TabActivationMedicalProgramController.getContactNearby(string.valueOf(act.id),2,'test','Neutral','C','C');
        TabActivationMedicalProgramController.getContactNearby(string.valueOf(a.id),2,'test','Neutral','B','B');
        TabActivationMedicalProgramController.getContactNearby(string.valueOf(act2.id),2,'test','Neutral','A','A');
        TabActivationMedicalProgramController.getContactNearby(string.valueOf(act2.id),2,'test','Neutral','Uncategorized','Uncategorized');
        TabActivationMedicalProgramController.getContactNearby(string.valueOf(actAddress.id),50,'','','','');

        //TabActivationMedicalProgramController.deleteRelationShip(a.id); 
        
        Test.stopTest();
	}

	@isTest static void createAccountContactRelTest() {
		// code_block	
	}

    @isTest static void deleteRelationShipTest() {
		// code_block	
	}

    @isTest static void getContactNearbyTest() {
		// code_block	
	}
   
}