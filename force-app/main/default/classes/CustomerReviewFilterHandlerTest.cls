@isTest
public class CustomerReviewFilterHandlerTest {

    @testSetup
    static void setupTestData() {
        // Create test users
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile localAdminProfile = [SELECT Id FROM Profile WHERE Name='SFDC LOCAL ADMIN' LIMIT 1];
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        
        User testNSM = new User(
            Username = 'testnsm@example.com',
            LastName = 'NSM',
            Email = 'testnsm@example.com',
            Alias = 'testnsm',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            Sales_Role__c = 'NSM',
            CompanyName = 'Test Company'
        );
        insert testNSM;

        User testRSM = new User(
            Username = 'testrsm@example.com',
            LastName = 'RSM',
            Email = 'testrsm@example.com',
            Alias = 'testrsm',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            Sales_Role__c = 'RSM',
            CompanyName = 'Test Company',
            ManagerId = testNSM.Id
        );
        insert testRSM;

        User testASM = new User(
            Username = 'testasm@example.com',
            LastName = 'ASM',
            Email = 'testasm@example.com',
            Alias = 'testasm',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = standardUserProfile.Id,
            LanguageLocaleKey = 'en_US',
            Sales_Role__c = 'ASM',
            CompanyName = 'Test Company',
            ManagerId = testRSM.Id
        );
        insert testASM;
		
        Account acc = new Account();
        acc.Name = 'dsfa';
        acc.Email__c = 'dsfa@qq.com';
        acc.Hoya_Account_ID__c = 'DE123456';
        insert acc;
        
        // Create Visit records
        Visits__c visit1 = new Visits__c(
            Account__c = [SELECT Id FROM Account LIMIT 1].Id,
            Visit_Type__c = 'Visit',
            Visit_Status__c = 'Planned',
            Start_Time__c = DateTime.now().addDays(-5),
            Assigned_to__c = testASM.Id
        );
        insert visit1;

        Visits__c visit2 = new Visits__c(
            Account__c = [SELECT Id FROM Account LIMIT 1].Id,
            Visit_Type__c = 'Visit',
            Visit_Status__c = 'Completed',
            Start_Time__c = DateTime.now().addDays(-3),
            Assigned_to__c = testASM.Id
        );
        insert visit2;

        Visits__c visit3 = new Visits__c(
            Account__c = [SELECT Id FROM Account LIMIT 1].Id,
            Visit_Type__c = 'Visit',
            Visit_Status__c = 'Cancelled',
            Start_Time__c = DateTime.now().addDays(-2),
            Assigned_to__c = testASM.Id
        );
        insert visit3;
    }
    
    @isTest
    static void testGetCompanies() {
        Test.startTest();
        // Mocking metadata since DML operations on custom metadata are not allowed in tests
        List<String> companies = CustomerReviewFilterHandler.getCompanies();
        List<User> managerList = CustomerReviewFilterHandler.getSalesManagerList(null);
        Test.stopTest();

        System.assertNotEquals(0, companies.size(), 'Companies list should not be empty');
    }
    
    @isTest
    static void testGetSalesManagerListForNSM() {
        User testUser = [SELECT Id FROM User WHERE Username = 'testnsm@example.com' LIMIT 1];
        User testUserRMS = [SELECT Id FROM User WHERE Username = 'testrsm@example.com' LIMIT 1];
        System.runAs(testUser) {
            Test.startTest();
            List<User> managerList = CustomerReviewFilterHandler.getSalesManagerList(null);
            Test.stopTest();

            System.assertNotEquals(0, managerList.size(), 'Manager list should not be empty');
        }
    }

    @isTest
    static void testGetRepresentativeListForNSM() {
        User testNSM = [SELECT Id FROM User WHERE Username = 'testnsm@example.com' LIMIT 1];
        Test.startTest();
        List<User> representativeList = CustomerReviewFilterHandler.getRepresentativeList(testNSM.Id);
        Test.stopTest();

        System.assertNotEquals(0, representativeList.size(), 'Representative list should not be empty');
        System.assert(representativeList.size() > 0, 'There should be at least one representative');
    }
    
    @isTest
    static void testGetASMManager() {
        User testASM = [SELECT Id FROM User WHERE Username = 'testasm@example.com' LIMIT 1];
        Test.startTest();
        User asmManager = CustomerReviewFilterHandler.getASMManager();
        Test.stopTest();
        
        System.assertNotEquals(null, asmManager, 'ASM manager should not be null');
    }

    @isTest
    static void testGetVisitsForRepresentative() {
        User testASM = [SELECT Id FROM User WHERE Username = 'testasm@example.com' LIMIT 1];
        Date startDate = Date.today().addDays(-7);
        Date endDate = Date.today();

        Test.startTest();
        List<Visits__c> visits = CustomerReviewFilterHandler.getVisitsForRepresentative(testASM.Id, startDate, endDate);
        Test.stopTest();

        System.assertNotEquals(0, visits.size(), 'Visits list should not be empty');
        for (Visits__c visit : visits) {
            System.assertEquals('Visit', visit.Visit_Type__c, 'Visit type should be Visit');
            System.assertNotEquals('Cancelled', visit.Visit_Status__c, 'Visit status should not be Cancelled');
        }
    }
}