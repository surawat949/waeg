@isTest
public class EyeDoctorVisitPlanningControllerTest {

    @testSetup
    static void setupTestData() {
        // Create Record Types
        RecordType clinicRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Clinic' LIMIT 1];
        RecordType opthalmologistRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND DeveloperName = 'Opthalmologist' LIMIT 1];

        // Create Test Accounts
        Account acc1 = new Account(Name = 'Clinic 1', RecordTypeId = clinicRecordType.Id, Shop_Street__c = 'Street 1', Shop_City__c = 'City 1',
                                   Shop_Postal_Code__c = '12345', Shop_State__c = 'State 1', TACTICOM_SOF__c = 'Sub-area 1');
        insert acc1;

        Account acc2 = new Account(Name = 'Clinic 2', RecordTypeId = clinicRecordType.Id, Shop_Street__c = 'Street 2', Shop_City__c = 'City 2',
                                   Shop_Postal_Code__c = '67890', Shop_State__c = 'State 2', TACTICOM_SOF__c = 'Sub-area 2');
        insert acc2;

        // Create Test Contacts
        Contact con1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc1.Id, RecordTypeId = opthalmologistRecordType.Id, 
                                   OnekeyId__c = '123',  Individual_Status__c = 'Valid', Current_State__c = 'State A', 
                                   MiyoSmart_Attitude__c = 'Neutral', Last_contact_visit_date__c = Date.today(),
                                   Preferred_contact_day_time__c = 'Monday AM', Specialization__c = 'Pediatric');
        insert con1;

        Contact con2 = new Contact(FirstName = 'Jane', LastName = 'Smith', AccountId = acc2.Id, RecordTypeId = opthalmologistRecordType.Id, 
                                   OnekeyId__c = '456',  Individual_Status__c = 'Valid', Current_State__c = 'State B', 
                                   MiyoSmart_Attitude__c = 'Neutral', Last_contact_visit_date__c = Date.today(),
                                   Preferred_contact_day_time__c = 'Monday PM', Specialization__c = 'Outpatient');
        insert con2;

        // Create AccountContactRelations
        AccountContactRelation acr1 = new AccountContactRelation(AccountId = acc1.Id, ContactId = con1.Id, IsActive = true, Preferred_place_for_visit__c = true);
        //insert acr1;

        AccountContactRelation acr2 = new AccountContactRelation(AccountId = acc2.Id, ContactId = con2.Id, IsActive = true, Preferred_place_for_visit__c = false);
        //insert acr2;
    }

    @isTest
    static void testGetAccountVisitPlanningData() {
        Test.startTest();
        
        // Call the method to test
        List<EyeDoctorVisitPlanningController.AccountWrapper> result = EyeDoctorVisitPlanningController.getAccountVisitPlanningData();
        Id eyedoctorRecordtypeId = EyeDoctorVisitPlanningController.getRecordTypeId('Visits__c','Eye_Doctor_Visit');
        // Validate the result
        System.assert(result.size() == 2, 'Expected 2 account wrappers');
        System.assert(result[0].contacts.size() == 1, 'Expected 1 contact for the first account');
        System.assertEquals(result[0].contacts[0].contactName, 'Jane Smith', 'Expected contact name is John Doe');
        
        Test.stopTest();
    }

    @isTest
    static void testFilterAccounts() {
        Test.startTest();
        // Define filter criteria
        List<Map<String, String>> filters = new List<Map<String, String>>();
        Map<String, String> filter1 = new Map<String, String>{ 'key' => 'city', 'value' => 'City 1' };
        filters.add(filter1);
        Map<String, String> filter2 = new Map<String, String>{ 'key' => 'zip', 'value' => '12345' };
        filters.add(filter2);
        Map<String, String> filter3 = new Map<String, String>{ 'key' => 'state', 'value' => 'State 1' };
        filters.add(filter3);
        Map<String, String> filter4 = new Map<String, String>{ 'key' => 'visitZone', 'value' => 'Sub-area 1' };
        filters.add(filter4);
        Map<String, String> filter5 = new Map<String, String>{ 'key' => 'miyoAttitude', 'value' => 'Neutral' };
        filters.add(filter5);
        Map<String, String> filter6 = new Map<String, String>{ 'key' => 'localSpecialization', 'value' => 'Valid' };
        filters.add(filter6);
        Map<String, String> filter7 = new Map<String, String>{ 'key' => 'targetFlag', 'value' => 'true' };
        filters.add(filter7);
        Map<String, String> filter8 = new Map<String, String>{ 'key' => 'quickFilter', 'value' => 'Jane' };
        filters.add(filter8);
        Map<String, String> filter9 = new Map<String, String>{ 'key' => 'miyoSegmentation', 'value' => 'A1' };
        filters.add(filter9);
        Map<String, String> filter10 = new Map<String, String>{ 'key' => 'preferredDayTime', 'value' => 'Monday AM' };
        filters.add(filter10);
        Map<String, String> filter11 = new Map<String, String>{ 'key' => 'sortCondition', 'value' => 'contactName ASC' };
        filters.add(filter11);
        // Call the filterAccounts method
        List<EyeDoctorVisitPlanningController.AccountWrapper> filteredResults = EyeDoctorVisitPlanningController.filterAccounts(filters);
        EyeDoctorVisitPlanningController.getPicklistValues();
        Test.stopTest();
    }
}