public with sharing class TabAccountInvoiceController {

    public class AccountMap{
        @AuraEnabled public string accountId{get;set;}
        @AuraEnabled public string hoya_account_id{get;set;}
        @AuraEnabled public string accountName{get;set;}
        @AuraEnabled public string accountStreet{get;set;}
        @AuraEnabled public string accountCity{get;set;}
        @AuraEnabled public string accountState{get;set;}
        @AuraEnabled public string accountCountry{get;set;}
        @AuraEnabled public string accountPostalCode{get;set;}
        @AuraEnabled public double accountLatitude{get;set;}
        @AuraEnabled public double accountLongitude{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountMap> getAccountForMap(String recordId){
        try{
            List<AccountMap> dataList = new List<AccountMap>();
            List<Account> acc = new List<Account>([SELECT Id, Hoya_Account_ID__c, Name, Billing_Account_Name__c, 
                                                BillingStreet, BillingCity, BillingState, 
                                                BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude
                                                FROM Account WHERE Id=:recordId]);
            for(Account a : acc){
                AccountMap wraperCls = new AccountMap();
                if(a.BillingLatitude == null && a.BillingLongitude==null){
                    continue;
                }

                wraperCls.accountId = a.Id;
                wraperCls.hoya_account_id = a.Hoya_Account_ID__c;
                wraperCls.accountName = a.Billing_Account_Name__c;
                wraperCls.accountStreet = a.BillingStreet;
                wraperCls.accountCity = a.BillingCity;
                wraperCls.accountState = a.BillingState;
                wraperCls.accountCountry = a.BillingCountry;
                wraperCls.accountPostalCode = a.BillingPostalCode;

                if(a.BillingLongitude == null){
                    wraperCls.accountLatitude = 0;
                }else{
                    wraperCls.accountLatitude = a.BillingLatitude;
                }

                if(a.BillingLongitude == null){
                    wraperCls.accountLongitude = 0;
                }else{
                    wraperCls.accountLongitude = a.BillingLongitude;
                }

                dataList.add(wraperCls);
                
            }
            
            return dataList;
        }catch(Exception e){
            
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}