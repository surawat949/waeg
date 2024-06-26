@isTest
public with sharing class ContactRelatedClinicsController_test {
    public ContactRelatedClinicsController_test() {

    }

    @IsTest
    static void runTestCtrl(){
        Test.startTest();
        Account acc2 = new Account();
        acc2.Name='sales test account2';
        acc2.hoya_account_id__c='SO3366666xx';
        insert acc2;
        Contact Con = new Contact();
        con.lastName = 'abd';
        con.FirstName = 'pqr';
        insert Con;
        ContactRelatedClinicsController.getRelatedClinicsByContactId(Con.Id);
        Test.stopTest();
    }

}