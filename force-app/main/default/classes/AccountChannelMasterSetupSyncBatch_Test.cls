@isTest
public class AccountChannelMasterSetupSyncBatch_Test {
    public AccountChannelMasterSetupSyncBatch_Test() {

    }

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Parent Acc',
            Hoya_account_Id__c = 'SO0033TESTACC',
            Optician_Finder_Channel_Decision__c = 'Activation',
            Shop_Country__c = 'FR',
            CHCUSTCLASSIFICATIONID__c = 'IND',
            CHINTERNATIONALGROUP__c = 0
        );
        insert acc;
        
        Channel_Master_Setup_Config__c cms = new Channel_Master_Setup_Config__c(
        	External_key__c = 'SEIKOFRIND0',
            Account_Channel_decision__c = 'Non-activation'
        );
        insert cms;
    }
    
    @isTest
    static void opticianBatch(){
        Test.startTest();
        //Database.executeBatch(new AccountChannelMasterSetupSyncBatch());
        String sch = '0 0 * * * ?';//0 0 2 * * ?'; 
		system.schedule('Test Check', sch, new AccountChannelMasterSetupSyncBatch());
        Test.stopTest();
    }
}