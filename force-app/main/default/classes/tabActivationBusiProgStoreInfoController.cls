public class tabActivationBusiProgStoreInfoController {
    @AuraEnabled
    public static void migrateLastYearToPreYear(Id recordID){
        list<Store_Characteristics__c> listOfStoreCharUpdate = new list<Store_Characteristics__c>();
        for(Store_Characteristics__c storeCharObj : [SELECT ID,Account__c,Last_Year_of_Reference__c,
                                                     Retail_Turnover_Last_Year_of_Ref__c,Annual_Growth_Last_Year_of_Ref__c,
                                                    Previous_Year_of_Reference__c,Retail_Turnover_Prev_Year_of_Ref__c,
                                                     Annual_Growth_Prev_Year_of_Ref__c FROM Store_Characteristics__c
                                                    WHERE Account__c=:recordID]){
            Store_Characteristics__c objStoreChar = new Store_Characteristics__c();     
            storeCharObj.Previous_Year_of_Reference__c = storeCharObj.Last_Year_of_Reference__c;
            storeCharObj.Retail_Turnover_Prev_Year_of_Ref__c = storeCharObj.Retail_Turnover_Last_Year_of_Ref__c;
            storeCharObj.Annual_Growth_Prev_Year_of_Ref__c = storeCharObj.Annual_Growth_Last_Year_of_Ref__c;
            storeCharObj.Last_Year_of_Reference__c ='';
            storeCharObj.Retail_Turnover_Last_Year_of_Ref__c = null;
            storeCharObj.Annual_Growth_Last_Year_of_Ref__c = null;                                            
                                                        
            listOfStoreCharUpdate.add(storeCharObj);
        }
        if(listOfStoreCharUpdate.size()>0){
            update listOfStoreCharUpdate;
        }
        
    } 

    @AuraEnabled
    public static List<Store_Related_Pictures__c> getStoredPictures(String receivedId){
        system.debug('>>>>here');
        List<Store_Related_Pictures__c> picList = [SELECT Id,Name,CreatedDate,Description__c,CreatedBy.Name,Account__c
                                    FROM Store_Related_Pictures__c WHERE Account__c=:receivedId ORDER BY CreatedDate DESC ];
        System.debug(' == > '+picList);
        return picList;
    }
    @AuraEnabled
    public static string getStoreId(String receivedId){
        List<Store_Characteristics__c> storeCharId = [SELECT Id,name FROM Store_Characteristics__c WHERE Account__c=:receivedId];
        String recordId;
        if(!storeCharId.isEmpty()){
            recordId = storeCharId[0].id;
        }
        else{
            recordId = '';
        }
        return recordId;
    }
}