@isTest
public class VisitZonesControllerTest {
    @isTest
	static void testVPMV2Controller() {
        Test.StartTest();
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'SO490060';
        a1.Name = 'Test 60';
        a1.Shop_Name__c = 'Test Account 1';
        a1.CurrencyIsoCode = 'EUR';
        a1.Tacticom_SOF__c = 'Sub-area 1';
        insert a1;
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO490061';
        a2.Name = 'Test 61';
        a2.Shop_Name__c = 'Test Account 2';
        a2.CurrencyIsoCode = 'EUR';
        a2.Tacticom_SOF__c = 'Sub-area 2';
        insert a2;
        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        insert c1;
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a1.Id;
        visit2.contact__c = c1.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Start_Time__c = date.today()-3;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Planned';
        visit2.Visitfreqchk_c__c='1';
        visit2.Visit_Type__c='Visit';
        visit2.End_Time__c=system.now();
        insert visit2;
        VisitZonesController.getAccounts();
        VisitZonesController.getAccountsWithTacticom();
        VisitZonesController.updateAccountStage(a1.id,'Sub-area 3');
        VisitZonesController.removeTacticomSOF(a2.Id);
        VisitZonesController.getCampaignOptions('true');
        Test.StopTest();
    }
    @isTest
	static void testVPMV2ControllerOne() {
        Test.StartTest();
        List<VisitPlanningV2Controller.MyRecordWrapper> wrappers = new List<VisitPlanningV2Controller.MyRecordWrapper>();
        List<String> operands1 = new List<String>{'92010'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper1 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands1, 'GreaterOrEqual');
        wrappers.add(wrapper1);
        List<String> operands2 = new List<String>{'92100'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper2 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands2, 'LessOrEqual');
        wrappers.add(wrapper2);
        String listViewName = 'All Accounts';
        Map<String, String> filterCriteria = new Map<String, String> ();
        filterCriteria.put('Account_Life_Cycles__r.Stage__c','Discover');
        VisitZonesController.getFilteredAccounts(wrappers,filterCriteria,listViewName);
        VisitZonesController.getFilteredAccounts(wrappers,filterCriteria,'$Default');
        Test.StopTest();
    }
    
}