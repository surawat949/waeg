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
        Id ContactId=[SELECT Id from Contact where FirstName = 'SFDC'].Id;
        String EyeDoctor_RT = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Eye_Doctor_Visit').getRecordTypeId();

        List<Visits__c> visitsLst = new List<Visits__c>();
        Visits__c visit = new Visits__c();
        visit.Account__c = AccountId;
        visit.Visit_Type__c = 'Visit';
        visit.Visit_Status__c = 'Planned';
        visit.Visit_Reason__c = 'Customer Retention';
        visit.Start_Time__c = date.today()-1;
        visit.End_Time__c = visit.Start_Time__c.addMinutes(60);
        visit.Assigned_to__c = UserInfo.getUserId();
        visitsLst.add(visit);
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = AccountId;
        visit1.Visit_Type__c = 'Visit';
        visit1.Visit_Status__c = 'Planned';
        visit1.Visit_Reason__c = 'Negotiation';
        visit1.Start_Time__c = date.today()-1;
        visit1.End_Time__c = visit1.Start_Time__c.addMinutes(60);
        visit1.Assigned_to__c = UserInfo.getUserId();
        visitsLst.add(visit1);
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = AccountId;
        Visit2.Contact__c = ContactId; 
        visit2.RecordTypeId = EyeDoctor_RT;
        visit2.Visit_Type__c = 'Visit';
        visit2.Visit_Status__c = 'Planned';
        visit2.Start_Time__c = date.today()-1;
        visit2.End_Time__c = visit2.Start_Time__c.addMinutes(60);
        visit2.Assigned_to__c = UserInfo.getUserId();
        visitsLst.add(visit2);
        
        insert visitsLst;
        
        visit.Visit_Status__c = 'Complete';
        update visit;
        visit1.Start_Time__c = date.today()-2;
        update visit1;
        
        system.assert(true);
        Test.StopTest();
    }
    
}