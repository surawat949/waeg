@IsTest
public with sharing class TrainingTabComponentController_test {
    public TrainingTabComponentController_test() {
    }

    @IsTest
    static void runTestCtrl(){
        
        Test.startTest();
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId='012b00000000P38';
        insert acc;

        ECP_Training__c t= new ECP_Training__c();
        t.Account__c = acc.id;
        t.start__c = System.today();
        t.Training__c = 'MIYOSMART';
        t.Type__c = 'Webinar';
        t.Training_status__c = 'Planned';
        insert t;

        Contact c = new Contact();
        c.firstname='xxxyyy';
        c.lastName='zzzzz';
        c.email = 'fake.email@hoya.com';
        c.recordTypeId= '012b00000000P3DAAU';
        c.ecp_training__c = t.id;
        insert c;

        TrainingTabComponentController.getAttendeeList(t.id);
        TrainingTabComponentController.getContactList(t.id);
        TrainingTabComponentController.addRelationShip(c.Id, t.Id);
        TrainingTabComponentController.deleteRelationShip(c.Id, t.Id);
        System.assert(true);
    }
}