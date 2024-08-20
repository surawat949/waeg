@isTest
public with sharing class OpportunityStageLayoutController_test {

    /**
     * Changed log : 
     * Due task no.968-unused custom object.
     * Agreed to remove SEIKO_Order__c and related class.
     * Below class should remove due for this custom object removed.
     * Test class related to SEIKO_Order__c was removed.
     * OpportunityStageLayoutController.createTask(orderId);
     * Surawat add - 2023/11/22
     */
      
    @isTest
    static void runTest(){
        Test.startTest();

        Account acc= new Account(
            Name='Hospital',
            Hoya_Account_ID__c='SO33001122',
            shippingCity='Saint-Priest',
            ShippingStreet='6 Allée Irène Joliot Curie',
            ShippingCountry='FR',
            ShippingPostalCode='69800'
        );
        insert acc;

        Opportunity o = new Opportunity(
            Name='opp test',
            AccountId = acc.id,
            StageName = '1. 1st Appointment',
            CloseDate = System.today()+180
        );
        insert o;
        /*
        Seiko_Order__c order = new Seiko_Order__c(
            Assigned_to__c = UserInfo.getUserId(),
            Opportunity__c = o.id,
            account__c = acc.id,
            Special_comment__c = ' this is a test',
            Date_of_demand__c = System.today(),
            Design_name__c ='SEIKO AZ',
            Usefull_diameter__c='50mm',
            Wearer_name__c='xx'
        );
        insert order;
        */

        Opportunity otest = OpportunityStageLayoutController.getOpportunity(o.id);
        Account atest = OpportunityStageLayoutController.getAccount(acc.id);
        Seiko_data__c dtest = OpportunityStageLayoutController.getSeikoData(acc.id);
        OpportunityStageLayoutController.closeOpportunity(o.id, true);
        OpportunityStageLayoutController.closeAtolOpportunity(o.id, true);
        OpportunityStageLayoutController.updateOnBoardingAccount(acc.id);
        //OpportunityStageLayoutController.createTask(order.Id);
        OpportunityStageLayoutController.getCompanyName();
        OpportunityStageLayoutController.getNumberOfVisits(o.id);
        OpportunityStageLayoutController.enrollSVS(acc.id);
        system.assert(true);
    }
}