/**
 *  Test class for tabAccountContractsLWCController
 * 
 */
@IsTest
public class TabAccountContractsLWCControllerTest {

    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testini@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        insert u;

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.CurrencyIsoCode = 'EUR';
        a1.OwnerId = u.Id;
        a1.Email__c = 'test@hotmail.com';
        insert a1;
		
        Contract__c conData = new Contract__c();
        conData.Hoya_Contract_Number__c = '1233';
        conData.IsActive__c = true;
		conData.Contract_Type__c = 'Demo';
        conData.Termination_date__c = system.today().addDays(100);
        conData.Start_Date__c = system.today();
        conData.Expiration_Date__c = system.today().addDays(150);
        conData.Account__c =a1.ID;
        insert conData;
    }
    @IsTest
    public static void getAccountRelatedContractsTest(){
        Test.StartTest();
        Account acc = [SELECT Id, Hoya_Account_ID__c,Email__c FROM Account
                        WHERE Hoya_Account_ID__c = 'TEST001' LIMIT 1];
		List<Contract__c> data = TabAccountContractsLWCController.getAccountRelatedContracts(acc.Id);
        System.assertEquals(data.size(), 1);
        Test.StopTest();
    }
}