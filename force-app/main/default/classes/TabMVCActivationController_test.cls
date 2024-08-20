@isTest
public class TabMVCActivationController_test {
	@IsTest
    static void runTest(){
        String HoyaRec = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();
        String SeikoRec = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('SEIKO_Training').getRecordTypeId();

        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        acc.Lenses_Net_Sales_Last_12Mo__c = 10000;       
        insert acc;
        Account ah = new Account();
        ah.Hoya_Account_ID__c = 'TEST-0000';
        ah.Name = 'Parent Account';
        ah.Shop_Name__c = 'Parent Account';
        insert ah;
        
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
        
        Last_Sales_Statistics__c sales= new Last_Sales_Statistics__c();
        sales.Account__c = acc.Id;
        sales.MiyoSmart_Last_12_Mo_Qty__c = 12;
        sales.MiyoSmart_Last_Mo_Qty__c = 2;
        Insert sales;
        AccountContactRelation ac = new AccountContactRelation();
        ac.ContactId = con.Id;
        ac.AccountId = ah.Id;
        ac.Preferred_place_for_visit__c = true;
       // ac.Contact_Role__c = 'Other';
        insert ac;
        
        Test.startTest();
        TabMVCActivationController.accountId = acc.Id;
        TabMVCActivationController.getReferringOpticiansCountList(con.Id);
        TabMVCActivationController.getLastTrainingDate(con.Id);
        TabMVCActivationController.getOrdersMiyoSmartRelatedList(con.Id);
        TabMVCActivationController.getRefferingOptsLst(con.Id, true);
        TabMVCActivationController.getRefferingOptsLst(con.Id, false);
        Test.StopTest();
    }
}