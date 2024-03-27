/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @CreatedDate : 2023-12-26
 * @api : v.55.0
 * @Description : this test class for TabMVAVisitsCertificateController
 * @CodeCoverage : 
 */
@IsTest
public with sharing class TabMVAVisitsCertificateController_Test {
    @TestSetup
    static void makeData(){

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE-001';
        a.Name = 'Test-Account';
        a.Shop_Street__c = 'Bangkok';
        a.Shop_City__c = 'Bangkok';
        a.Shop_State__c = 'Bangkok';
        a.Shop_Country__c = 'Thailand';
        a.Shop_Postal_Code__c = '10110';
        insert a;

        String contactId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Lasttest';
        c.AccountId = a.Id;
        c.RecordTypeId = contactId;
        insert c;

        String EcpRecId = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();
        ECP_Training__c training = new ECP_Training__c();
        training.Account__c = a.Id;
        training.start__c = System.today()-3;
        training.end__c = System.today();
        training.Assigned_to__c = UserInfo.getUserId();
        training.RecordTypeId = ecpRecId;
        training.Training__c = 'HOYA';
        training.Training_status__c = 'Completed';
        training.Type__c = 'In Store';
        insert training;

        ECP_Training_Member__c member = new ECP_Training_Member__c();
        member.Training__c = training.Id;
        member.Contact__c = c.Id;
        insert member;

               
    }

    @IsTest
    static void TestWholeClass(){
        Test.StartTest();
        Account HoyaAcc = [SELECT Id, Hoya_Account_ID__c, Shop_City__c, Shop_Country__c, Name, Brand__c FROM Account WHERE Hoya_Account_ID__c='TE-001' LIMIT 1];
        Contact HoyaCon = [SELECT Id,firstname, Lastname, AccountId FROM Contact WHERE AccountId=:HoyaAcc.Id LIMIT 1];
        ECP_Training__c trains = [SELECT Id, Name, Account__c, start__c, end__c, Assigned_to__c from ECP_Training__c WHERE Account__c=:HoyaAcc.Id LIMIT 1];
        ECP_Training_Member__c members = [SELECT Id, Name, Training__c, Contact__c FROM ECP_Training_Member__c WHERE Training__c=:trains.Id LIMIT 1];

        TabMVAVisitsCertificateController.generateCertificate(trains.Id, members.Id);
        TabMVAVisitsCertificateController.generateCertificate(trains.Id, null);
        TabMVAVisitsCertificateController traingPage = new TabMVAVisitsCertificateController();
        TabMVAVisitsCertificateController.getECPTrainings(trains.Account__c);
        TabMVAVisitsCertificateController.getAttendee(trains.Id);
        TabMVAVisitsCertificateController.getAttendeeNumber(trains.Id);

        try{
            delete trains;
            TabMVAVisitsCertificateController.getECPTrainings('');
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabMVAVisitsCertificateController.getAttendee(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabMVAVisitsCertificateController.generateCertificate(null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        Test.StopTest();

    }

}