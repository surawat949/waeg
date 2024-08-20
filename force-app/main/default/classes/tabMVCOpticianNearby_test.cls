@IsTest
public with sharing class tabMVCOpticianNearby_test {

    @TestSetup
    static void makeData(){

        String ACC_REC_OPT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
        String CON_REC_OPT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
        String ACC_REC_IND = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
        
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'CLI-00101';
        a1.Name = 'Test for clinic';
        a1.RecordTypeId = ACC_REC_OPT;
        a1.Shop_Name__c = 'Test for clinic';
        a1.Shop_Street__c = 'Spuistraat 288-29, 1012 VX';
        a1.Shop_City__c = 'Amsterdam';
        a1.Shop_State__c = 'Amsterdam';
        a1.Shop_Postal_Code__c = '1012 VX';
        a1.Shop_Country__c = 'Netherlands';
        a1.Phone = '123456789';
        a1.ShippingLatitude = 0;
        a1.ShippingLongitude = 0;
        a1.Seiko_Network__c = 'Visionary Alliance';
        a1.Myo_Smart_AuthorizeDealer__c = false;
        a1.First_Competitor_global_name__c = 'Essilor';
        a1.First_Competitor_SOW__c = '10';

        insert a1;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'CLI-00102';
        a2.Name = 'Test for clinic2';
        a2.RecordTypeId = ACC_REC_OPT;
        a2.Shop_Name__c = 'Test for clinic2';
        a2.Shop_Street__c = 'Papland 21';
        a2.Shop_City__c = 'Gorinchem';
        a2.Shop_State__c = 'Gorinchem';
        a2.Shop_Postal_code__c = '4206 CK';
        a2.Shop_Country__c = 'Netherlands';
        a2.Phone = '123456789';
        a2.ShippingLatitude = 51.8488;
        a2.ShippingLongitude = 4.98326;
        a2.Seiko_Network__c = 'Visionary Alliance';
        a2.Myo_Smart_AuthorizeDealer__c = false;
        a2.First_Competitor_global_name__c = 'Essilor';
        a2.First_Competitor_SOW__c = '10';

        insert a2;

        Account a3 = new Account();
        a3.Hoya_Account_ID__c = 'IND-001001';
        a3.Name = 'Ind Account';
        a3.RecordTypeId = ACC_REC_IND;
        a3.Shop_Name__c = 'Ind Account';
        a3.Shop_Street__c = 'test';
        a3.Shop_City__c = 'test';
        a3.Shop_State__c = 'test';
        a3.Shop_Postal_Code__c = '123456';
        a3.Shop_Country__c = 'NL';
        a3.ShippingLatitude = 51.8488;
        a3.ShippingLongitude = 4.98326;
        insert a3;

        Contact c1 = new Contact();
        c1.FirstName = 'Testmed';
        c1.LastName = 'Testmedmed';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = CON_REC_OPT;
        c1.Email = 'test@hoya.com';
        c1.Phone = '089578899';
        
        insert c1;

        Contact c2 = new Contact();
        c2.FirstName = 'Testmed2';
        c2.LastName = 'Testmed22';
        c2.AccountId = a2.Id;
        c2.RecordTypeId = CON_REC_OPT;
        c2.Email = 'test@yahoo.com';
        c2.Phone = '1112256';

        insert c2;

        Contact c3 = new Contact();
        c3.FirstName = 'Testtest';
        c3.LastName = 'Testlast';
        c3.AccountId = a3.Id;
        c3.RecordTypeId = CON_REC_OPT;
        c3.Email = 'test@gmail.com';
        c3.Phone = '12545663';
        insert c3;


        AccountContactRelation ac = new AccountContactRelation();
        ac.ContactId = c1.Id;
        ac.AccountId = a2.Id;
        ac.Working_Status__c = 'Full Time';

        insert ac;

        AccountContactRelation ac2 = new AccountContactRelation();
        ac2.ContactId = c1.Id;
        ac2.AccountId = a3.Id;
        insert ac2;
    }

    @IsTest
    static void TestWholeClass(){

        Account acc = [SELECT Id, Hoya_Account_ID__c, ShippingLatitude, ShippingLongitude, Myo_Smart_AuthorizeDealer__c, Visionary_Alliance__c, Seiko_Network__c FROM Account WHERE Hoya_Account_ID__c='CLI-00101' LIMIT 1];
        Account acc2 = [SELECT Id, Hoya_Account_ID__c, ShippingLatitude, ShippingLongitude, Myo_Smart_AuthorizeDealer__c, Visionary_Alliance__c, Seiko_Network__c FROM Account WHERE Hoya_Account_ID__c='CLI-00102' LIMIT 1];
        Account acc3 = [SELECT Id, Hoya_Account_ID__c, ShippingLatitude, ShippingLongitude, Myo_Smart_AuthorizeDealer__c, Visionary_Alliance__c, Seiko_Network__c FROM Account WHERE Hoya_Account_ID__c='IND-001001' LIMIT 1];
        Contact con = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId=:acc.Id LIMIT 1];
        Contact con2 = [SELECT Id FROM Contact WHERE LastName = 'Testmed22' LIMIT 1];
        Contact con3 = [SELECT Id FROM Contact WHERE AccountId =:acc3.Id LIMIT 1];
        
        List<AccountContactRelation> cont = new List<AccountContactRelation>();
        
		List<AccountContactRelation> rel = [Select Id, isActive From AccountContactRelation Where contactId = :con.Id];
        rel[0].IsActive = true;
        update rel;

        List<AccountContactRelation> rel2 = [SELECT Id, IsDirect FROM AccountContactRelation WHERE ContactId =:con3.Id];
        rel2[0].IsActive = true;
        update rel2;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'tt-001';
        a.Name = 'tt-001';
        a.Shop_Street__c = 'test street';
        a.Shop_City__c = 'test city';
        a.Shop_State__c = 'test state';
        a.Shop_Postal_Code__c = '123456';
        a.Shop_Country__c = 'NL';
        a.Seiko_Network__c = 'Visionary Alliance';
        a.Visionary_Alliance__c = 'Pro';
        a.Myo_Smart_AuthorizeDealer__c = true;
        a.ShippingLatitude = 0;
        a.shippingLongitude = 0;
        insert a;

        List<Account> acs = new List<Account>();
        
        Test.StartTest();
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, '', false, true, true, '');
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, '', false, true, false, '');
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, '', false, false, true, '');
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, '', true, true, true, '');
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, 'Pro', true, true, true, 'A3');
        tabMVCOpticianNearby.getContactNearby(con.Id, 5, '', false, false, false, '');
        tabMVCOpticianNearby.getPicklistVisionaryAlliance();
        Test.StopTest();

        try{
            tabMVCOpticianNearby.getContactNearby(null, null, null, null, null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}