// Not being used anywhere. can be removed

@RestResource(urlMapping = '/GetChildrenAccountAddressList')
global with sharing class WS_GetChildrenAccountAddressList {
    global static final String EC_ACCOUNT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    public WS_GetChildrenAccountAddressList() {

    }

    /**
     * This web service will accept account Id as parameter
     * This will return all the possible children accounts in the hierarchy of passed account Id.
     */

    @HttpPost
    global static void getAccountList(){
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String userJson = RestContext.request.requestBody.toString();
        JSONDeserializer j;
        try {
            j = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }

        List<AccountDetail> resultList = new List<AccountDetail>();

        Account item = [select Id, hoya_account_id__c, name, parentId, Channel__c, Shop_City__c, Shop_Country__c, Shop_Postal_Code__c, Shop_State__c, Shop_Street__c,
         ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where id=:j.accountId AND recordTypeId != :EC_ACCOUNT_RT];
        
        AccountDetail detail = new AccountDetail();
        detail.accountId = item.Id;
        detail.hoya_account_id = item.hoya_account_id__c;
        detail.name = item.name;
        detail.parentId = item.parentId;
        detail.channel = item.Channel__c;
        
        detail.billingCity = item.BillingCity;
        detail.billingCountry = item.BillingCountry;
        detail.billingState = item.BillingState;
        detail.billingStreet = item.BillingStreet;
        detail.billingZip = item.BillingPostalCode;
        
        detail.shippingCity = item.ShippingCity;
        detail.shippingCountry = item.ShippingCountry;
        detail.shippingState = item.ShippingState;
        detail.shippingStreet = item.ShippingStreet;
        detail.shippingZip = item.ShippingPostalCode;

        resultList.add(detail);
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(item.Id);
        resultList.addAll(getRecursiveAccountList(accIdSet));
        
        res.responseBody = Blob.valueOf(JSON.serialize(resultList));
        res.statusCode = 200;

    }

    private static List<AccountDetail> getRecursiveAccountList(Set<Id> accIdSet){
        List<Account> temp = [select Id, hoya_account_id__c, name, parentId, Channel__c, Shop_City__c, Shop_Country__c, Shop_Postal_Code__c, Shop_State__c, Shop_Street__c,
         ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where parentId IN :accIdSet AND recordTypeId != :EC_ACCOUNT_RT];
        List<AccountDetail> result = new List<AccountDetail>();
        if (temp != null && temp.size() > 0) {
            Set<Id> accIds = new Set<Id>();
            for (Account item : temp) {

                AccountDetail detail = new AccountDetail();
                detail.accountId = item.Id;
                detail.hoya_account_id = item.hoya_account_id__c;
                detail.name = item.name;
                detail.parentId = item.parentId;
                detail.channel = item.Channel__c;
                
                detail.billingCity = item.BillingCity;
                detail.billingCountry = item.BillingCountry;
                detail.billingState = item.BillingState;
                detail.billingStreet = item.BillingStreet;
                detail.billingZip = item.BillingPostalCode;
                
                detail.shippingCity = item.ShippingCity;
                detail.shippingCountry = item.ShippingCountry;
                detail.shippingState = item.ShippingState;
                detail.shippingStreet = item.ShippingStreet;
                detail.shippingZip = item.ShippingPostalCode;
                
                result.add(detail);
                accIds.add(item.Id);
            }
            result.addAll(getRecursiveAccountList(accIds));
        }
        return result;
    }

    private class JSONDeserializer {
        Id accountId {
            get;
            set;
        }
    }

    private class AccountDetail {
        public Id accountId{get;set;}
        public String hoya_account_id{get;set;}
        public String name{get;set;}
        public Id parentId{get;set;}
        public String channel{get;set;}

        public String billingCity{get;set;}
        public String billingCountry{get;set;}
        public String billingZip{get;set;}
        public String billingState{get;set;}
        public String billingStreet{get;set;}

        public String shippingCity{get;set;}
        public String shippingCountry{get;set;}
        public String shippingZip{get;set;}
        public String shippingState{get;set;}
        public String shippingStreet{get;set;}
    }
}