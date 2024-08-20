@isTest
public class PopulateSAPCompanyCodeBatchScript_test {

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO4900354',
            phone='0102030405',
            shop_country__c = 'DE'
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
        PopulateSAPCompanyCodeBatchScript thisBatch = new PopulateSAPCompanyCodeBatchScript();
		Id batchId = Database.executeBatch(thisBatch);
        Test.stopTest();
    }
}