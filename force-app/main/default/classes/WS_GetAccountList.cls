@RestResource(urlMapping = '/GetAccountList')
global with sharing class WS_GetAccountList {
    global static final String EC_ACCOUNT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    
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
            system.debug('res 2 - fail of json deserialize: '+res);
            return;
        }

        List<Account> accountList = new List<Account>();

        //get contact allowed account:
        List<AccountDetail> resultList = new List<AccountDetail>();

        Contact c = [select id, recordType.name from contact where id=:j.contactId];
        boolean isShopOwner = c.RecordType.Name == 'Shop Owner';
        List<AccountContactRelation> acrList =  [select AccountId, IsDirect from AccountContactRelation where IsActive=true and ContactId=:j.contactId];
        Account main = null;
        for (AccountContactRelation acr : acrList) {
            Account item = [select id, hoya_account_id__c, name, shop_name__c, parentId, recordType.name, Brand__c, Shop_City__c, Shop_Country__c, Shop_Postal_Code__c, Shop_State__c, Shop_Street__c,Seiko_local_customer_nr__c from account where id=:acr.AccountId AND recordTypeId != :EC_ACCOUNT_RT];

            AccountDetail detail = new AccountDetail();
            detail.accountId = item.Id;
            detail.hoya_account_id = item.Hoya_Account_ID__c;
            detail.parentId = item.ParentId;
            detail.isPrimary = acr.isDirect;
            detail.name = item.name;
            detail.DisplayName = item.shop_name__c;
            detail.IsAssignable = false;
            detail.IsSwitchable = true & isShopOwner;
            detail.RelationType = 'relation';
            if (acr.isDirect) {
                detail.RelationType = 'primary';
            }
            detail.brand = item.Brand__c;
            detail.City = item.Shop_City__c;
            detail.Country = item.Shop_Country__c;
            detail.ZIP = item.Shop_Postal_Code__c;
            detail.State = item.Shop_State__c;
            detail.Street = item.Shop_Street__c;
            detail.localCustomerNumber = item.Seiko_local_customer_nr__c;
            resultList.add(detail);

            accountList.add(item);
            if (acr.isDirect) {
                main = item;
            }
        }

        //get account by parentId relationship
        if (main != null) {
            Set<Id> accIdSet = new Set<Id>();
            accIdSet.add(main.Id);
            //accountList.addAll(getRecursiveAccountList(main.Id));
            resultList.addAll(getRecursiveAccountList(accIdSet, isShopOwner));
        }
        res.responseBody = Blob.valueOf(JSON.serialize(resultList));
        res.statusCode = 200;
    }
    
    private static List<AccountDetail> getRecursiveAccountList(Set<Id> accIdSet, boolean isShopOwner){
        List<Account> temp = [select id, hoya_account_id__c, name, shop_name__c, parentId, recordType.name, Brand__c, Shop_City__c, Shop_Country__c, Shop_Postal_Code__c, Shop_State__c, Shop_Street__c,Seiko_local_customer_nr__c from account where parentId IN :accIdSet AND recordTypeId != :EC_ACCOUNT_RT];
        List<AccountDetail> result = new List<AccountDetail>();
        if (temp != null && temp.size() > 0) {
            Set<Id> accIds = new Set<Id>();
            //result.addAll(temp);
            for (Account a : temp) {

                AccountDetail detail = new AccountDetail();
                detail.accountId = a.Id;
                detail.hoya_account_id = a.Hoya_Account_ID__c;
                detail.parentId = a.ParentId;
                detail.isPrimary = false;
                detail.name = a.name;
                detail.DisplayName = a.shop_name__c;
                detail.IsAssignable = true & isShopOwner;
                detail.IsSwitchable = true & isShopOwner;
                detail.RelationType = 'descendent';
                detail.brand = a.Brand__c;
                detail.City = a.Shop_City__c;
                detail.Country = a.Shop_Country__c;
                detail.ZIP = a.Shop_Postal_Code__c;
                detail.State = a.Shop_State__c;
                detail.Street = a.Shop_Street__c;
                detail.localCustomerNumber = a.Seiko_local_customer_nr__c;
                
                result.add(detail);
                accIds.add(a.Id);
            }
            result.addAll(getRecursiveAccountList(accIds, isShopOwner));
        }
        return result;
    }

    private class JSONDeserializer {
        Id contactId {
            get;
            set;
        }
    }

    private class AccountDetail {
        public Id accountId{get;set;}
        public String hoya_account_id{get;set;}
        public String name{get;set;}
        public String DisplayName{get;set;}
        public Id parentId{get;set;}
        public boolean isPrimary{get;set;}
        public boolean IsSwitchable{get;set;}
        public boolean IsAssignable{get;set;}
        public String RelationType{get;set;}
        public String brand{get;set;}
        public String City{get;set;}
        public String Country{get;set;}
        public String ZIP{get;set;}
        public String State{get;set;}
        public String Street{get;set;}
        public String localCustomerNumber{get;set;}
    }
}