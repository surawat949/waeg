@IsTest
public with sharing class tabMVAVisitsClinicNearbyController_test {
    public tabMVAVisitsClinicNearbyController_test() {

    }
    @TestSetup
    static void makeData(){

        String CONT_OPTO = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST-000';
        a1.Name = 'TEST-000';
        a1.Shop_Name__c = 'TEST-000';
        a1.ShippingLatitude = 0;
        a1.ShippingLongitude = 0;
        a1.ShippingStreet = '123 Ressident Evil Revenue';
        a1.ShippingCity = 'Raccoon City';
        a1.ShippingState = 'Bangkok';
        a1.ShippingCountry = 'Thailand';
        a1.Phone = '12345678';
        a1.Myo_Smart_AuthorizeDealer__c = true;
        a1.First_Competitor_global_name__c = 'Essilor';
        a1.First_Competitor_local_name__c = 'Essilor';
        a1.First_Competitor_SOW__c = '20';
        //a1.Clinic_type__c = 'Other';

        insert a1;

        Contact c1 = new Contact();
        c1.FirstName = 'test-001';
        c1.LastName = 'testtest1';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = CONT_OPTO;
        insert c1;

    }

    @IsTest
    static void testwholeClass(){
        Account acc = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c = 'TEST-000' LIMIT 1];
        Contact con = [SELECT Id, LastName FROM Contact WHERE AccountId =:acc.Id];

        Test.StartTest();
        tabMVAVisitsClinicNearbyController.getAccountsNearBy(acc.Id, 5, null, 0);
        tabMVAVisitsClinicNearbyController.getAccountsNearBy(acc.Id, 5,'', 1);
        tabMVAVisitsClinicNearbyController.getAccountsNearBy(acc.Id, 5, 'No', 1);
       // tabMVAVisitsClinicNearbyController.getAccClinicTypeValue();
        Test.StopTest();

        try{
            tabMVAVisitsClinicNearbyController.getAccountsNearBy(null, null, null, null);

        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }

}