public WITH SHARING class TabMVAActivationController {
    
    private static final String ACCOUNT_CLINIC_RT = Schema.SObjectType.ACCOUNT.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    
    @AuraEnabled(cacheable=true)
    public static List<AccountContactRelation> getAccConRelatedListByAccId(String receivedId){
   
			
            List<Id> conId = new List<Id>();
            for(Contact c : [SELECT Id FROM Contact WHERE AccountId=:receivedId]){
                conId.add(c.Id);
            }
		   
            List<AccountContactRelation> conListRelated = [SELECT id, contact.Id, Contact.name, Account.name, Account.id, 
                                                            Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                                            ,Account.shippingPostalCode, Account.shippingCity, Account.Shop_Street__c,
                                                             Account.Seiko_Network__c, Account.Shop_City__c, Account.Shop_Postal_Code__c
                                                            FROM AccountContactRelation WHERE (contactId =:conId)
                                                            AND (isdirect=false) AND Account.RecordTypeId !=: ACCOUNT_CLINIC_RT AND Account.RecordTypeId != NULL];
            //just copied from AccountSalesTabComponentController.getAccountsLinkedToContactbyContactId
            //but from ContactId coming from looping conId above

            return conListRelated;
    }

}