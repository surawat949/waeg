@RestResource(urlMapping = '/GetChildrenAccountIdList')
global with sharing class WS_GetChildrenAccountIdList {
    global static final String EC_ACCOUNT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    global WS_GetChildrenAccountIdList() {

    }
    /**
     * This web service will accept account Id as parameter
     * This will return all the possible children accounts in the hierarchy of passed account Id.
     */

     @HttpPost
     global static void getAccountList(){
         RestResponse res = RestContext.response;
         res.addHeader('Content-Type', 'application/json');
 
         String userJson = RestContext.request.requestBody.toString();
         JSONDeserializer j;
         try {
             j = (JSONDeserializer) JSON.deserialize(userJson, JSONDeserializer.class);
         } catch (Exception e) {
             res.responseBody = Blob.valueOf(JSON.serialize(e));
             res.statusCode = 400;
             return;
         }
         if (String.isBlank(j.accountId)) {
            ErroJson js = new ErroJson();
            js.message = 'Missing Fields (accountId)';
            res.responseBody = Blob.valueOf(JSON.serialize(js));
            res.statusCode = 400;
            return;
         }
 
        List<AccountDetail> resultList = new List<AccountDetail>();
        List<Account> item;
        
        item = [select Id, hoya_account_id__c, name, parentId from Account where id=:j.accountId AND recordTypeId != :EC_ACCOUNT_RT];   
         
         if (!item.isEmpty()) {
            AccountDetail detail = new AccountDetail();
            detail.accountId = item[0].Id;
            detail.hoya_account_id = item[0].hoya_account_id__c;
            detail.name = item[0].name;
            detail.parentId = item[0].parentId;
    
            resultList.add(detail);
            Set<Id> accIdSet = new Set<Id>();
            accIdSet.add(item[0].Id);
            resultList.addAll(getRecursiveAccountList(accIdSet));
            
            res.responseBody = Blob.valueOf(JSON.serialize(resultList));
            res.statusCode = 200;   
         } else {
            res.responseBody = Blob.valueOf(JSON.serialize(item));
            res.statusCode = 404;
            return;
         }
         
 
     }
 
     private static List<AccountDetail> getRecursiveAccountList(Set<Id> accIdSet){
         List<Account> temp = [select Id, hoya_account_id__c, name, parentId from Account where parentId IN :accIdSet AND recordTypeId != :EC_ACCOUNT_RT];
         List<AccountDetail> result = new List<AccountDetail>();
         if (temp != null && temp.size() > 0) {
             Set<Id> accIds = new Set<Id>();
             for (Account item : temp) {
 
                 AccountDetail detail = new AccountDetail();
                 detail.accountId = item.Id;
                 detail.hoya_account_id = item.hoya_account_id__c;
                 detail.name = item.name;
                 detail.parentId = item.parentId;
                 
                 result.add(detail);
                 accIds.add(item.Id);
             }
             result.addAll(getRecursiveAccountList(accIds));
         }
         return result;
     }
 
     private class JSONDeserializer {
         String accountId {
             get;
             set;
         }
     }

     private class ErroJson{
        String message;
     }
 
     private class AccountDetail {
         public Id accountId{get;set;}
         public String hoya_account_id{get;set;}
         public String name{get;set;}
         public Id parentId{get;set;}
     }
}