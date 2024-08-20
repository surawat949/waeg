@isTest
private class MatchingAccountsBatchTest {
    @isTest
    static void testBatchExecution() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        User testOwner = new User(
            FirstName = 'Test',
            LastName = 'Owner',
            Email = 'test.owner@example.com',
            Alias = 'towner',
            Username = 'test.owner@example.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert testOwner;

        testAccount.OwnerId = testOwner.Id;
        update testAccount;

        // Start the batch job
        Test.startTest();
        MatchingAccountsBatch batchJob = new MatchingAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
    }
}