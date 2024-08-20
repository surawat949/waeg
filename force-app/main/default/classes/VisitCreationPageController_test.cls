@isTest
public with sharing class VisitCreationPageController_test {
    public VisitCreationPageController_test() {

    }

    @isTest static void testAllMethods(){
        Account acc = new Account();
        acc.Name = 'testcrv';
        acc.Hoya_Account_Id__c= 'FR0123456';
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        insert acc;

        Test.startTest();
        Account testAcc = VisitCreationPageController.getAccount(acc.Id);
        Visits__c v = VisitCreationPageController.initVisit(testAcc.Id);
        v.Start_Time__c = Date.today().addDays(1);
        v.End_Time__c = v.Start_Time__c.addHours(1);
        VisitCreationPageController.saveVisit(v);
        system.assert(true);
        Test.stopTest();
    }
}