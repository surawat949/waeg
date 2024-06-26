@isTest
public class BatchCls_UpdateVisitKPI_Test {

   
    @isTest
    static void UnitTest01() {
        Test.startTest();
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            // Setup User
            String profileId = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
            
            User u = new User();
            u.FirstName = 'This';
            u.LastName = 'Test';
            u.Username = 'test@hoya.com.wage.invalid';
            u.Email = 'test@hoya.com.waeg.invalid';
            u.Visit_counter__c = true;
            u.CompanyName = 'HAPL';
            u.TimeZoneSidKey = 'Asia/Bangkok';
            u.LocaleSidKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.LanguageLocaleKey = 'en_US';
            u.Alias = 'VTest';
            u.ProfileId = profileId;
            insert u;
        }

        // Using the created user to insert other records
        // Create and insert a single account
        Account a = new Account();
        a.Name = 'Test';
        a.Hoya_Account_ID__c = 'TE-001-1';
        insert a;

        // Create and insert a single visit
        Visits__c visits = new Visits__c();
        visits.Account__c = a.Id;
        visits.Assigned_to__c = UserInfo.getUserId();
        visits.Start_Time__c = System.today()-2;
        visits.End_Time__c = System.today()-1;
        visits.Visit_Status__c = 'Complete';
        insert visits;

        // Create and insert a single VISIT_KPI__c record
        VISIT_KPI__c v = new VISIT_KPI__c();
        v.Area_Sales_Manager__c = UserInfo.getUserId();
        v.Name = 'test';
        v.Date__c = Date.today();
        insert v;

        // Create and insert a single VisitKPI_Settings__c record
        VisitKPI_Settings__c ss = new VisitKPI_Settings__c();
        ss.Name = 'Test';
        ss.isActive__c = false; // Set to false to avoid triggering another batch job
        insert ss;

        
        // Execute the batch
        BatchCls_UpdateVisitKPI obj = new BatchCls_UpdateVisitKPI(System.today(), null);
        Database.executeBatch(obj); 
        Test.stopTest();
    }
    
    @isTest
    public static void testRunVisitKPIBatch() {
        Test.startTest();
        CtrlRunVisitKPIBatch ctrl = new CtrlRunVisitKPIBatch();
        ctrl.runVisitKPIBatch();
        Test.stopTest();
    }

}