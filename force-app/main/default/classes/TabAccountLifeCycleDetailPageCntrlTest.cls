@isTest
public class TabAccountLifeCycleDetailPageCntrlTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Shop_Country__c = 'FR',
            Local_Consolidation_Key__c = 'Test 2'
        );
        insert acc;
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = acc.Id;
        visit1.Visit_Type__c = 'Digital Visit';
        visit1.Start_Time__c = date.today()-9;
        visit1.Assigned_to__c = UserInfo.getUserId();

        insert visit1;
        
        Identified_Business_Opportunity__c indeifiedOpp = new Identified_Business_Opportunity__c();
        indeifiedOpp.Project_Name__c = 'Test01';
        indeifiedOpp.Project_Category__c = 'Product Mix';
        indeifiedOpp.Project_Status__c = 'In progress';
        indeifiedOpp.Priority_level__c = '1';
        indeifiedOpp.Account__c = acc.Id;
        insert indeifiedOpp;
   }
    @isTest
    static void tabVisitTest(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId,Local_Consolidation_Key__c from Account LIMIT 1];
        Visits__c visitObj = [Select id from Visits__c where Account__c =:acc.id];
        TabAccountLifeCycleDetailPageController.getVisits(acc.Id);
        TabAccountLifeCycleDetailPageController.getBusinessOpp(acc.Id);
       Test.StopTest();
    }
}