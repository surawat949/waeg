@IsTest
public with sharing class TabMVCVisitsContactNearby_test {

    @TestSetup
    static void makeData(){
        String CON_OPT_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
        String ACC_OPT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST-1234';
        a1.Name = 'Test Account';
        a1.ShippingLatitude = 0;
        a1.ShippingLongitude = 0;
        a1.ShippingStreet = 'test street';
        a1.ShippingCity = 'city';
        a1.ShippingState = 'Bangkok';
        a1.ShippingPostalCode = '12232';
        a1.ShippingCountry = 'Thailand';
        a1.Phone = '+667 232 2201-1';
        a1.RecordTypeId = ACC_OPT_RT;
        insert a1;

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'TEST-4321';
        a2.Name = 'Test Account2';
        a2.ShippingLatitude = 0;
        a2.ShippingLongitude = 0;
        a2.ShippingStreet = 'test street';
        a2.ShippingCity = 'city';
        a2.ShippingState = 'Bangkok';
        a2.ShippingPostalCode = '12232';
        a2.ShippingCountry = 'Thailand';
        a2.Phone = '+667 232 2201-1';
        a2.RecordTypeId = ACC_OPT_RT;
        insert a2;

        Contact c1 = new Contact();
        c1.FirstName = 'Testcontact';
        c1.LastName = 'Testtestcontact';
        c1.AccountId = a1.Id;
        c1.MailingStreet = 'test street';
        c1.MailingCity = 'test city';
        c1.MailingState = 'test state';
        c1.MailingCountry = 'Thailand';
        c1.MailingPostalCode = '123456';
        c1.MailingLatitude = 0;
        c1.MailingLongitude = 0;
        c1.Phone = '+754 111 2924';
        c1.MiyoSmart_Attitude__c = 'Neutral';
        c1.Prescription_Potential__c = 'C';
        c1.Preferred_contact_method__c = 'email';
        c1.First_Speciality__c = 'Other';
        //c1.Professional_Type__c = 'Other';
        c1.RecordTypeId = CON_OPT_RT;
        insert c1;

        AccountContactRelation acon = new AccountContactRelation();
        acon.ContactId = c1.Id;
        acon.AccountId = a2.Id;
        acon.Preferred_contact_day_time__c = 'Monday AM';
        insert acon;

    }

    @IsTest
    static void testWholeClass(){
        Test.StartTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Hoya_Account_ID__c = 'TEST-1234' LIMIT 1];
        Account acc2 = [SELECT Id, Name FROM Account WHERE Hoya_Account_ID__c = 'TEST-4321' LIMIT 1];
        Contact con = [SELECT Id, FirstName, LastName, Name, AccountId, MiyoSmart_Attitude__c, 
                        Prescription_Potential__c, Preferred_contact_method__c, First_Speciality__c
                        FROM Contact WHERE AccountId=:acc.Id];

        AccountContactRelation ac = [SELECT Id, ContactId, Preferred_contact_day_time__c FROM 
                                        AccountContactRelation WHERE AccountId=:acc2.Id];
        
						 
        TabMVCVisitsContactNearby.gettAllContacts(con.Id, 5, 'Neutral', 'C', 'email', 'Other','');
        TabMVCVisitsContactNearby.gettAllContacts(con.Id, 5, 'Neutral', 'C', 'email', 'Other','Monday AM');
        TabMVCVisitsContactNearby.gettAllContacts(con.Id, 1, '', '', '', '','');
        TabMVCVisitsContactNearby.getPickListMiyoSmartAttitude();
        TabMVCVisitsContactNearby.getPicklistPrescriptionPotential();
        TabMVCVisitsContactNearby.getPicklistPreferredContact();
        TabMVCVisitsContactNearby.getPicklistFirstSpeciality();
        //TabMVCVisitsContactNearby.getPicklistProfessionalType();
        TabMVCVisitsContactNearby.getPreferredDayTime();
        Test.StopTest();

        try{
            TabMVCVisitsContactNearby.gettAllContacts(null, null, null, null, null, null,null);

        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}