@isTest
public class PopulateHoyaContactIdBatchScript_test {
	@TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO012354',
            phone='0102030405'
        );
        insert acc;
        Contact con = new Contact();
        con.lastname = 'Test';
        con.FirstName = 'Con1';
        con.AccountId = acc.Id;
        insert con;
    }
    
    @isTest
    static void testAllMethods() {
        Test.startTest();
        PopulateHoyaContactIdBatchScript thisBatch = new PopulateHoyaContactIdBatchScript();
		Id batchId = Database.executeBatch(thisBatch);
        Test.stopTest();
    }
}