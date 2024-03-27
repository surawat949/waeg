@isTest
public class tabVisitFormControllerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Shop_Country__c = 'FR'
        );
        insert acc;
        Visits__c visit11 = new Visits__c();
        visit11.Account__c = acc.Id;
        visit11.Visit_Type__c = 'Visit';
        visit11.HVNA_Visit_Type__c = 'Shop Visit';
        visit11.CurrencyIsoCode = 'EUR';
        visit11.Visit_Status__c = 'Complete';
        visit11.End_Time__c = date.today() - 7;
        visit11.Start_Time__c = date.today()-9;
        visit11.Assigned_to__c = UserInfo.getUserId();
        visit11.Visitfreqchk_c__c = '1';
        visit11.MKT_No_campaign_presented__c=true;
        insert visit11;
    }
     @isTest
    static void tabVisitTest(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId from Account LIMIT 1];
        Visits__c visitObj = [SELECT id from Visits__c where Account__c =:acc.id];
        tabVisitDetailFormController.getBusinessOpportunityRelatedAccount(visitObj.id);
        tabVisitDetailFormController.getUserInfo();
        Test.stopTest();
    }
}