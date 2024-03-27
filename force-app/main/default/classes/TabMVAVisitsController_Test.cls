@isTest
public class TabMVAVisitsController_Test {
    public tabMVAVisitsController_Test(){}   
    @IsTest
    static void getVisitsList(){  
         Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO012354',
            shippingPostalCode='23440',
            phone='0102030405'
        );
        insert acc;
        Test.startTest();
        TabMVAVisitsController.getInStoreTrainingRelatedList(acc.Id);
        TabMVAVisitsController.getVisitFrequency(acc.Id);
        TabMVAVisitsController.getVisitsBasedOnContacts(acc.Id);
        Test.stopTest();
    }
}