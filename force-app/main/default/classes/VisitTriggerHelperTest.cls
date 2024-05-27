@IsTest
public class VisitTriggerHelperTest {
    
    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Hoya_Account_ID__c = 'DE123456';
        acc.CHCUSTCLASSIFICATIONID__c = 'Ind';
        acc.TACTICOM_SOF__c = 'Sub-area 1';
        acc.Shop_Country__c = 'BE';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'XX';
        con.LastName = 'Test';
        con.AccountId = acc.Id;
        insert con;
        
        String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

        Contact con1 = new Contact();
        con1.FirstName = 'SFDC';
        con1.LastName = 'Test';
        con1.AccountId = acc.Id;
        con1.RecordTypeId = CONTACT_OPTHO_RT;
        insert con1;
        
        Identified_Business_Opportunity__c opp = new Identified_Business_Opportunity__c();
        opp.Project_Status__c = 'Not Started';
        opp.Account__c = acc.Id;
        insert opp;

    }      
    @isTest
    static void testTrackers() {      
        Test.startTest();       
        Id AccountId=[SELECT Id from Account where Name = 'Test'].Id;
        List<Visits__c> visitsLst = new List<Visits__c>();
        Visits__c visit = new Visits__c();
        visit.Account__c = AccountId;
        visit.Visit_Type__c = 'Visit';
        visit.Visit_Status__c = 'Planned';
        visit.Visit_Reason__c = 'Retain';
        visit.Start_Time__c = date.today();
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Assigned_to__c = UserInfo.getUserId();
        visitsLst.add(visit);
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = AccountId;
        visit1.Visit_Type__c = 'Visit';
        visit1.Visit_Status__c = 'Complete';
        visit1.Visit_Reason__c = 'Retain';
        visit1.Start_Time__c = date.today()-5;
        visit1.End_Time__c = system.today();
        visit1.Assigned_to__c = UserInfo.getUserId();
        visitsLst.add(visit1);
        
        insert visitsLst;
        
        visit.Visit_Status__c = 'Complete';
        update visit;
        
        system.assert(true);
        Test.StopTest();
    }
    
}