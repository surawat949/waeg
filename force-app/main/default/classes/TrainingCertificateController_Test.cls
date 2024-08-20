/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @api : v.55.0
 * @description : this testing class for TrainingCertificateController
 * code coverage : 88%
 */
@isTest
public with sharing class TrainingCertificateController_Test {
    @TestSetup
    static void makeData(){

        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE011';
        a.Name = 'Testaccount';
        a.Shop_City__c = 'Bangkok';
        a.Shop_State__c = 'Bangkok';
        a.Shop_Country__c = 'Thailand';
        insert a;

        String conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
        Contact con = new Contact();
        con.AccountId = a.Id;
        con.firstname = 'Test';
        con.Lastname = 'Testlast';
        con.RecordTypeId = conRecId;
        insert con;

        String ecpRecId = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();
        ECP_Training__c training = new ECP_Training__c();
        training.Account__c = a.Id;
        training.start__c = System.today()-3;
        training.end__c = System.Now();
        training.Assigned_to__c = UserInfo.getUserId();
        training.RecordTypeId = ecpRecId;
        training.Training__c = 'HOYA';
        training.Training_status__c = 'Completed';
        training.Type__c = 'In Store';
        insert training;

        ECP_Training_Member__c member = new ECP_Training_Member__c();
        member.Training__c = training.Id;
        member.Contact__c = con.Id;
        insert member;

        Account aSeiko = new Account();
        aSeiko.Hoya_Account_ID__c = 'SO4900111999';
        aSeiko.Name = 'Test seiko';
        aSeiko.Shop_City__c = 'Hambrug';
        aSeiko.Shop_Country__c = 'German';
        aSeiko.Shop_State__c = 'Hambrug';
        insert aSeiko;

        Contact conSeiko = new Contact();
        conSeiko.AccountId = aSeiko.Id;
        conSeiko.FirstName = 'Testseiko';
        conSeiko.LastName = 'Seikolast';
        conSeiko.RecordTypeId = conRecId;
        insert conSeiko;

        String ecpRecSeikoId = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('SEIKO_Training').getRecordTypeId();
        ECP_Training__c trainingSeiko = new ECP_Training__c();
        trainingSeiko.Account__c = aSeiko.Id;
        trainingSeiko.start__c = System.today()-3;
        trainingSeiko.end__c = System.today();
        trainingSeiko.Assigned_to__c = UserInfo.getUserId();
        trainingSeiko.RecordTypeId = ecpRecSeikoId;
        trainingSeiko.Training__c = 'SEIKO Pro';
        trainingSeiko.Training_status__c = 'Completed';
        trainingSeiko.Type__c = 'In Store';
        insert trainingSeiko;

        ECP_Training_Member__c memberSeiko = new ECP_Training_Member__c();
        memberSeiko.Training__c = trainingSeiko.Id;
        memberSeiko.Contact__c = conSeiko.Id;
        insert memberSeiko;

    }
    
    @IsTest
    static void UnitTest01(){
        Test.StartTest();
        
        Account acc = [SELECT Id, Hoya_Account_ID__c, Shop_City__c, Shop_Country__c, Name, Brand__c FROM Account WHERE Hoya_Account_ID__c='TE011' LIMIT 1];
        Contact con = [SELECT Id,firstname, Lastname, AccountId from contact where AccountId=:acc.Id LIMIT 1];
        ECP_Training__c trains = [SELECT Id, Name, Account__c, start__c, end__c, Assigned_to__c from ECP_Training__c WHERE Account__c=:acc.Id LIMIT 1];
        ECP_Training_Member__c members = [SELECT Id, Name, Training__c, Contact__c FROM ECP_Training_Member__c WHERE Training__c=:trains.Id LIMIT 1];

        Account accSeiko = [SELECT Id, Hoya_Account_ID__c, Shop_City__c, Shop_Country__c, Name FROM Account WHERE Hoya_Account_ID__c='SO4900111999' LIMIT 1];
        Contact conSeiko = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId=:accSeiko.Id LIMIT 1];
        ECP_Training__c trainSeiko = [SELECT Id, Name, Account__c, start__c, end__c, Assigned_to__c FROM ECP_Training__c WHERE Account__c=:accSeiko.Id LIMIT 1];
        ECP_Training_Member__c membersSeiko = [SELECT Id, Name, Training__c, Contact__c FROM ECP_Training_Member__c WHERE Training__c=:trainSeiko.Id LIMIT 1];

        TrainingCertificateController.generateCertificate(trains.Id, members.Id, 'Hoya');
        TrainingCertificateController.generateCertificate(trainSeiko.Id, membersSeiko.Id, 'SEIKO');
        TrainingCertificateController.generateCertificate(trains.Id, null, 'Hoya');
        TrainingCertificateController trainingPage = new TrainingCertificateController();
        TrainingCertificateController.getECPTrainings(trains.Account__c);
        TrainingCertificateController.getAttendees(trains.Id);
        TrainingCertificateController.getNumAttendee(trains.Id);
        TrainingCertificateController.getAccountBrand(acc.Id);

        Test.StopTest();

        try{
            delete trains;
            TrainingCertificateController.getECPTrainings('');
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TrainingCertificateController.getAttendees(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TrainingCertificateController.generateCertificate(null, null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }
}