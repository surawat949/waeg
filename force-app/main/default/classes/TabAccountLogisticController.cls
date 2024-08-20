public with sharing class TabAccountLogisticController {

    public class AccountShippingAddMap{
        @AuraEnabled public string accountId{get;set;}
        @AuraEnabled public string accountShipping{get;set;}
        @AuraEnabled public string accountShippingName{get;set;}
        @AuraEnabled public string shippingPhoneNumber{get;set;}
        @AuraEnabled public string accountStreet{get;set;}
        @AuraEnabled public string accountCity{get;set;}
        @AuraEnabled public string accountState{get;set;}
        @AuraEnabled public string accountCountry{get;set;}
        @AuraEnabled public string accountPostalCode{get;set;}
        @AuraEnabled public double accountShippingLatitude{get;set;}
        @AuraEnabled public double accountShippingLongitude{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountShippingAddMap> getShippingAddress(String recordId){
        try {
            List<AccountShippingAddMap> dataList = new List<AccountShippingAddMap>();
            List<Account> accList = new List<Account>([SELECT Id, Name, Shipping_Account__c, Shipping_Account_Name__c,
                                    Shipping_Phone_Number__c, ShippingPostalCode, ShippingLatitude,
                                    ShippingLongitude, ShippingStreet, ShippingCity, ShippingState, ShippingCountry
                                    FROM Account WHERE Id=:recordId]);
            
            for(Account a:accList){
                AccountShippingAddMap wraperCls = new AccountShippingAddMap();
                wraperCls.accountId = a.Id;
                wraperCls.accountShipping = a.Shipping_Account__c;
                wraperCls.accountShippingName = a.Shipping_Account_Name__c;
                wraperCls.accountStreet = a.ShippingStreet;
                wraperCls.accountCity = a.ShippingCity;
                wraperCls.accountState = a.ShippingState;
                wraperCls.accountPostalCode = a.ShippingPostalCode;
                wraperCls.accountCountry = a.ShippingCountry;
                wraperCls.shippingPhoneNumber = a.Shipping_Phone_Number__c;

                if(a.ShippingLatitude == null){
                    wraperCls.accountShippingLatitude = 0;
                }else{
                    wraperCls.accountShippingLatitude = a.ShippingLatitude;
                }

                if(a.ShippingLongitude == null){
                    wraperCls.accountShippingLongitude = 0;
                }else{
                    wraperCls.accountShippingLongitude = a.ShippingLongitude;
                }

                dataList.add(wraperCls);
            }
            
            return dataList;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }
}