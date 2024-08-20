@isTest
public class TabMVCVisitsController_Test {
      private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'IT0033TESTACC',
            Shop_Country__c = 'FR'
        );
        insert acc;
 
        Contact Con = new Contact();
        con.LastName = 'last';
        con.firstName = 'first';
        con.accountId = acc.Id;
        con.ownerId=userInfo.getUserId();
        con.recordTypeId = CONTACT_OPTHO_RT;
        
        insert con;
    	List<Visits__c> visitsData = new List<Visits__c>();
        Visits__c visit11 = new Visits__c();
        visit11.Account__c = acc.Id;
        visit11.Visit_Type__c = 'Visit';
        visit11.HVNA_Visit_Type__c = 'Shop Visit';
        visit11.CurrencyIsoCode = 'EUR';
        visit11.Visit_Status__c = 'Complete';
        visit11.End_Time__c = date.today() - 7;
        visit11.Start_Time__c = date.today()-9;
        visit11.Assigned_to__c = UserInfo.getUserId();
        visit11.Visitfreqchk_c__c = '1';
        visit11.contact__c = con.Id;
        visit11.MKT_No_campaign_presented__c=true;
		visitsData.add(visit11);
        
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.HVNA_Visit_Type__c = 'Shop Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Visit_Status__c = 'Planned';
        visit2.End_Time__c = date.today() + 7;
        visit2.Start_Time__c = date.today() + 1;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visitfreqchk_c__c = '1';
        visit2.contact__c = con.Id;
        visit2.MKT_No_campaign_presented__c=true;
		visitsData.add(visit2);
        
        Visits__c visit12 = new Visits__c();
        visit12.Account__c = acc.Id;
        visit12.Visit_Type__c = 'Visit';
        visit12.HVNA_Visit_Type__c = 'Shop Visit';
        visit12.CurrencyIsoCode = 'EUR';
        visit12.Visit_Status__c = 'Complete';
        visit12.End_Time__c = date.today() - 7;
        visit12.Start_Time__c = date.today()-9;
        visit12.Assigned_to__c = UserInfo.getUserId();
        visit12.Visitfreqchk_c__c = '1';
        visit12.contact__c = con.Id;
        visit12.MKT_No_campaign_presented__c=true;
		visitsData.add(visit12);
        
        Visits__c visit13 = new Visits__c();
        visit13.Account__c = acc.Id;
        visit13.Visit_Type__c = 'Digital Visit';
        visit13.HVNA_Visit_Type__c = 'Shop Visit';
        visit13.CurrencyIsoCode = 'EUR';
        visit13.Visit_Status__c = 'Complete';
        visit13.End_Time__c = date.today() - 7;
        visit13.Start_Time__c = date.today()-9;
        visit13.Assigned_to__c = UserInfo.getUserId();
        visit13.Visitfreqchk_c__c = '1';
        visit13.contact__c = con.Id;
        visit13.MKT_No_campaign_presented__c =true;
		visitsData.add(visit13);
        
        insert visitsData;
    }
    
    @IsTest
    static void runTest(){
        String SeikoRec = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('SEIKO_Training').getRecordTypeId();

        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.AnnualRevenue = 10000;        
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Rep';
        con.FirstName = 'Tes';
        con.AccountId = acc.Id;        
        insert con;          
        
        ECP_Training__c training = new ECP_Training__c();
        training.Training_status__c ='completed';
        training.start__c = System.today()-2;        
        training.end__C = System.today()-1;
        training.Account__c = acc.Id;
        training.Type__c = 'In Store';
        training.Training__c = 'MIYOSMART';
        training.RecordTypeId = SeikoRec;
        Insert training;
        
        ECP_Training_Member__c member = new ECP_Training_Member__c();
        member.Training__c = training.Id;
        member.Contact__c = con.Id;
        Insert member;
       
    }
    
    @isTest
    static void visitTest(){
        Test.startTest();
        Contact con=[Select Id,Name,ownerId from Contact LIMIT 1];
        TabMVCVisitsController.getInStoreTrainingRelatedList(con.Id);
        Test.stopTest();
    }
    
    @isTest
    static void visitTestOne(){
        Test.startTest();
        Contact con=[Select Id,Name,ownerId from Contact LIMIT 1];
        TabMVCVisitsController.getContactLastVisitCompleted(con.Id);
        TabMVCVisitsController.getNextVisitPlanned(con.Id);
        Test.stopTest();
    }
    
    @isTest
    static void visitTestTwo(){
        Test.startTest();
        Contact con=[Select Id,Name,ownerId from Contact LIMIT 1];
        TabMVCVisitsController.getVisits(con.Id);
		TabMVCVisitsController.getVisitCompleted(con.Id);
        Test.stopTest();
    }

}