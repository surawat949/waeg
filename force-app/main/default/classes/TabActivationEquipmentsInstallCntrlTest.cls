@isTest
public class TabActivationEquipmentsInstallCntrlTest {
    @IsTest
    static void runTestCtrl(){
        Test.StartTest();
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.RecordTypeId='012b00000000P38';        
        insert acc;
        Equipment__c e = new Equipment__c();
        e.Name = 'Test Equipment';
        e.Account__c = acc.Id;
        e.HW_Subtype__c = 'EyeGenius';
        insert e;
         TabActivationEquipmentsInstallCntrl.getInstruInShop(acc.Id);
        e.Product_Type__c = 'Software';
        update e;
        TabActivationEquipmentsInstallCntrl.getSoftwareInShop(acc.Id);
        Test.StopTest();


        
    }   

}