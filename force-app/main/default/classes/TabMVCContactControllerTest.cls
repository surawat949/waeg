@isTest
public class TabMVCContactControllerTest {
    
     private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
     public TabMVCContactControllerTest() {

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
        con.ownerId=userInfo.getUserId();
        con.recordTypeId = CONTACT_OPTHO_RT;
        
        insert con;
       
    }

    @isTest
    static void contactUpdateBatch(){
        Test.startTest();
        Contact con=[Select Id,Name,ownerId from Contact LIMIT 1];
        
        tabMVCContactController.getRelatedClinicsByContactId(con.Id);

        Test.stopTest();
    }
}