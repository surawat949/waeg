public with sharing class tabMVAAccountController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccforMapAccountId(String recordId){
        List<Account> acc = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingState, 
                                    ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude 
                                    FROM Account WHERE Id=: recordId];
        if(!acc.isEmpty()){
            return acc;
        }else{
            return null;
        }
    }

}