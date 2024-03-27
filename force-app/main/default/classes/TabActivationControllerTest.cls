@isTest
public class TabActivationControllerTest {
    
    @IsTest
    public static void testActivationController(){
        Test.startTest();
    	Account a = new Account();
        a.Hoya_Account_ID__c = 'SO-08922091';
        a.Name = 'Activation Test';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Seiko_Data__c s = new Seiko_Data__c();
        s.Account__c = a.Id;
        s.Name = a.Name;
        s.CurrencyIsoCode = 'EUR';
        s.SEIKO_Xtranet__c = true;
        s.SEIKO_Vision_Xperience_iPAD__c = true;
        insert s;    
        // Cover constructor test coverage
        TabActivationController ctrl = new TabActivationController();
        TabActivationController.getSeikoData(a.Id);
        Test.stopTest();
    }
	
}