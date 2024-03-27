public class TabAccountContractsLWCController {
    /**
     * =====================================================
     * @Author : austin a
     * @CreatedBy : austin a
     * @Email : austin.a@encora.com
     * @CreatedDate : 2024-02-21
     */

	@AuraEnabled
    public static List<Contract__c> getAccountRelatedContracts(String receivedId){
        List<Contract__c> conList = [SELECT Id, Hoya_Contract_Number__c, Account_Name__c,IsActive__c, Active__c, Contract_Type__c, Termination_date__c,Contract_Class__c,
                                 	Start_Date__c,Days_till_Expiration__c,Days_till_Termination__c,Duration_Month__c,Name,Contract_Amount__c,Expiration_Date__c
                                 	FROM Contract__c WHERE Account__c=:receivedId ORDER BY Start_Date__c DESC limit 10];
        return conList;
    }
}