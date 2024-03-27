@IsTest
public class TabAccountNewTaskLWCCntrlTest {
 @IsTest
    static void runTestCtrl(){
    Test.startTest();
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
        ID recordTypeId= Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
        TabAccountNewTaskLWCController.taskRecordTypeId();
        TabAccountNewTaskLWCController.getAccountId(con.id);
        Test.StopTest();    
    }      
}