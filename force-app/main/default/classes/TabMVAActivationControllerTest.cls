@isTest
public class TabMVAActivationControllerTest {
    
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
        
        insert con;
    
    }

    @isTest
    static void contactUpdateBatch(){
        Test.startTest();
        Account acc=[Select Id,Name,ownerId from Account LIMIT 1];
        TabMVAActivationController.getAccConRelatedListByAccId(acc.Id);
        Test.stopTest();
    }



}