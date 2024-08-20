global class ConnectedAppPluginHOCKoreaUAT  extends Auth.ConnectedAppPlugin {

    // Authorize the app if the user has achieved quota tracked in a custom field
    /* global override Boolean authorize(Id userId, Id connectedAppId, Boolean isAdminApproved, Auth.InvocationContext context) 
    {
        // Create a custom boolean field HasAchievedQuota__c on the user record 
        // and then uncomment the block below 
        // User u = [select id, HasAchievedQuota__c from User where id =: userId].get(0);
        // return u.HasAchievedQuota__c;
        
        return isAdminApproved;
    } */
        
    // Call a flow during refresh
    /* global override void refresh(Id userId, Id connectedAppId, Auth.InvocationContext context)
    {
       try
       {
          Map<String, Object> inputVariables = new Map<String, Object>();
          inputVariables.put('userId', userId);
          inputVariables.put('connectedAppId', connectedAppId);
            
         // Create a custom trigger ready flow and uncomment the block below
         // Flow.Interview.MyCustomFlow interview = new Flow.Interview.MyCustomFlow(inputVariables);
         // interview.start();
        } catch ( Exception e ) {
           System.debug('FLOW Exception:' + e);
        }  
    } */
        
           
    global override Map<String,String> customAttributes(Id userId, Id connectedAppId, Map<String,String>
        formulaDefinedAttributes, Auth.InvocationContext context)         
    {  
        try {
            List<User> userRec = [SELECT Id, contactId, contact.AccountId, contact.Account.Hoya_Account_Id__c, contact.Contact_Owner_Company__c, 
                contact.Account.ShippingCountry,  contact.Account.ShippingCity, contact.Account.ShippingStreet,  contact.Account.ShippingPostalCode, 
                contact.Account.Phone, contact.Account.Fax, contact.Account.Catalog_name__c, contact.Account.Shop_Name__c, contact.Account.Shop_Street__c, contact.Account.Brand__c, contact.Account.Shop_Country__c, contact.Account.Account_Number_ILog__c from User WHERE Id =: userId];
            if (!userRec.isEmpty()) {
                formulaDefinedAttributes.put('AccountId', userRec[0].contact.AccountId);
                formulaDefinedAttributes.put('Hoya_Account_Id__c', userRec[0].contact.Account.Hoya_Account_Id__c);
                formulaDefinedAttributes.put('Contact_Owner_Company__c', userRec[0].contact.Contact_Owner_Company__c);
                formulaDefinedAttributes.put('ShippingCountry', userRec[0].contact.Account.ShippingCountry);
                formulaDefinedAttributes.put('ShippingCity', userRec[0].contact.Account.ShippingCity);
                formulaDefinedAttributes.put('ShippingStreet', userRec[0].contact.Account.ShippingStreet);
                formulaDefinedAttributes.put('ShippingPostalCode', userRec[0].contact.Account.ShippingPostalCode);
                formulaDefinedAttributes.put('Phone', userRec[0].contact.Account.Phone);
                formulaDefinedAttributes.put('Fax', userRec[0].contact.Account.Fax);
                formulaDefinedAttributes.put('Catalog_name__c', userRec[0].contact.Account.Catalog_name__c);
                formulaDefinedAttributes.put('Shop_Name__c', userRec[0].contact.Account.Shop_Name__c);
                formulaDefinedAttributes.put('Shop_Street__c', userRec[0].contact.Account.Shop_Street__c);
                formulaDefinedAttributes.put('Brand__c', userRec[0].contact.Account.Brand__c);
                formulaDefinedAttributes.put('Shop_Country__c', userRec[0].contact.Account.Shop_Country__c);
                formulaDefinedAttributes.put('Account_Number_ILog__c', userRec[0].contact.Account.Account_Number_ILog__c);
                
                Integer count = 0;
                for (Authorization__c eachAuth : [Select Id, claim_formatted__c, Active_Authorization__c FROM Authorization__c Where Contact__c =:userRec[0].ContactId AND Active_Authorization__c = TRUE]) {
                    formulaDefinedAttributes.put(eachAuth.claim_formatted__c, String.valueOf(eachAuth.Active_Authorization__c));                }
            }
            return formulaDefinedAttributes;        
        } catch (Exception e) {
            LogException.log(e);
            return formulaDefinedAttributes;
        }
    } 
}