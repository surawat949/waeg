@istest
public class tabActivationBusinessProgramCtrlrTest {
    public static testmethod void testOnboarding(){
        Test.startTest();
        Account newAcc = new Account();
        newAcc.name='test';
        newAcc.Hoya_Account_Id__c = 'FR1231';
        insert newAcc;
        tabActivationBusinessProgramController obj = new tabActivationBusinessProgramController();
        tabActivationBusinessProgramController.updateOnboardingFlag(newAcc.Id, true);
        tabActivationBusinessProgramController.updateOnboardingFlag(newAcc.Id, false);
        tabActivationBusinessProgramController.getRelatedLoyaltyPoints(newAcc.Id);
        Test.stopTest();
    }
}