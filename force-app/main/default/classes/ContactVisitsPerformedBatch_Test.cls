/**********************************************************************************************************************
* Name               : ContactVisitsPerformedBatch_Test                                                        
* Description        : Test class for ContactVisitsPerformedBatch
* Created By         : Encora                                                      
**********************************************************************************************************************/

@isTest
public class ContactVisitsPerformedBatch_Test {
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    public ContactVisitsPerformedBatch_Test() {

    }

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
        con.recordTypeId = CONTACT_OPTHO_RT;
        
        insert con;
      
        Contact Con1 = new Contact();
        con1.LastName = 'last1';
        con1.firstName = 'first1';
        con1.accountId = acc.Id;
        con1.recordTypeId = CONTACT_OPTHO_RT;
        Insert Con1;
		
		List<Visits__c> visitLst = new List<Visits__c>();
   
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
        //insert visit11;
		visitLst.add(visit11);
        
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
        //insert visit12;
		visitLst.add(visit12);
        
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
        //insert visit13; 
		visitLst.add(visit13);
		insert visitLst;
    }

    @isTest
    static void contactUpdateBatch(){
        Test.startTest();
        String sch = '0 0 * * * ?';
		system.schedule('Test Check', sch, new ContactVisitsPerformedBatch());
        Test.stopTest();
    }
}