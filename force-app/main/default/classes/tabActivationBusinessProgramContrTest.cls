@isTest
public class tabActivationBusinessProgramContrTest {
    @IsTest
    static void updateOnboardingFlagTest(){ 
        list<Account> listOfAccount = new list<Account>();
         Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'SO012354',
            shippingPostalCode='23440',
            phone='0102030405',
            Onboarding_date__c = date.valueOf(system.now()),
            Onboarding_Customer__c = true
        );
        
        listOfAccount.add(acc);
        insert listOfAccount; 
        
        Test.startTest();

        tabActivationBusinessProgramController objTest = new tabActivationBusinessProgramController();
        tabActivationBusinessProgramController.updateOnboardingFlag(listOfAccount[0].Id,true);
        tabActivationBusinessProgramController.getRelatedLoyaltyPoints(listOfAccount[0].Id);
        tabActivationBusinessProgramController.updateOnboardingFlag(listOfAccount[0].Id,false);
       
        
        Test.stopTest();
    }

}