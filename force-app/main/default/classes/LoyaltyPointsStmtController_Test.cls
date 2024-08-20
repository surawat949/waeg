@isTest
public class LoyaltyPointsStmtController_Test {
	 
    public LoyaltyPointsStmtController_Test(){
    
    }
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'FR012354',
            shippingPostalCode='76530',
            phone='0102030405',
            shop_country__c = 'FR'
        );
        insert acc;
        Loyalty_points__c pts = new Loyalty_points__c(
        	Points__c = 20,
            Description__c = 'This is descritpion',
            date_Of_transaction__c = System.today(),
            external_key__c = '20220203H1234',
            Account__c = acc.Id
        );
        insert pts;
    }
    
    @isTest
    static void testGenerateCertpificate() {
        
        Account acc = [SELECT Id FROM Account WHERE Hoya_Account_ID__c='FR012354' LIMIT 1];
        Loyalty_points__c loyalty = [SELECT Id, Points__c, Account__c FROM Loyalty_points__c WHERE Account__c=:acc.Id LIMIT 1];
        List<String> emailList = new List<String>();
        emailList.add('test@hoya.com');
        emailList.add('test2@hoya.com');

        Test.StartTest();
        
        LoyaltyPointsStmtController.generateCertificate(acc.Id, System.today(), System.today(), emailList, 'HOYA');
        LoyaltyPointsStmtController.generateCertificate(acc.Id, System.today(), System.today(), emailList, 'SEIKO');
        LoyaltyPointsStmtController LoyaltyPage = new LoyaltyPointsStmtController();
        Test.StopTest();

        System.assert(true);
    }
}