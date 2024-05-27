public with sharing class TabStatisticNetSalesRequestConso {
    @AuraEnabled(cacheable=true)
    public static List<sObject> getAccountDataPillList(String searchKey, String objectApiName){
        List<sObject> sObjectList = new List<sObject>();
        if(String.isBlank(searchKey)){
            return sObjectList;
        }else{
            String key = '%' + searchKey + '%';
            String query = 'SELECT Id, Name FROM ' + objectApiName + ' WHERE Name LIKE : key ORDER BY Name ASC LIMIT 5';
            sObjectList = Database.query(query, AccessLevel.USER_MODE);
            return sObjectList; 
        }
    }
}