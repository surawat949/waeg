global with sharing class ConnectedAppPluginHOYAMarketplace extends Auth.ConnectedAppPlugin {

           
    global override Map<String,String> customAttributes(Id userId, Id connectedAppId, Map<String,String>
        formulaDefinedAttributes, Auth.InvocationContext context)         
    {  
        try {
            List<User> userRec = [SELECT Id, contactId, contact.AccountId, contact.Account.Hoya_Account_Id__c, contact.Account.Additionnal_account_data__c, contact.Account.Additionnal_account_data__r.Current_Month_Tier_Status__c from User WHERE Id =: userId];
            if (!userRec.isEmpty()) {
                formulaDefinedAttributes.put('AccountId', userRec[0].contact.AccountId);
                formulaDefinedAttributes.put('Hoya_Account_Id__c', userRec[0].contact.Account.Hoya_Account_Id__c);
                if (userRec[0].contact.Account.Additionnal_account_data__c != null) {
                    formulaDefinedAttributes.put('Current_Month_Tier_Status__c', userRec[0].contact.Account.Additionnal_account_data__r.Current_Month_Tier_Status__c);    
                }
                
                Integer count = 0;
                String claimFormatted = HOYAConstants.MARKETPLACE_CLAIM;
                List<Authorization__c> marketplaceAuth = [Select Id, claim_formatted__c FROM Authorization__c Where Contact__c =:userRec[0].ContactId AND Active_Authorization__c = TRUE AND claim_formatted__c = :claimFormatted];
                if (!marketplaceAuth.isEmpty()) {
                    formulaDefinedAttributes.put(marketplaceAuth[0].claim_formatted__c, 'true');
                } else {
                    formulaDefinedAttributes.put(marketplaceAuth[0].claim_formatted__c, 'false');
                }
                  
            }
            return formulaDefinedAttributes;        
        } catch (Exception e) {
            LogException.log(e);
            return formulaDefinedAttributes;
        }
    } 
}