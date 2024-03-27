public with sharing class NewMediaTriggerController {
    public NewMediaTriggerController() { }

    public static void doNewMediaUsageAfterInsert(List<New_Media_Usage__c> newList) {
        List<Id> Ids = new List<Id>();
        
        for(New_Media_Usage__c newMedia : newList) {
            Ids.add(newMedia.Hoya_Account_ID__c);
        }

        Map<Id, Seiko_data__c> accountToSeikoDataMap = new Map<Id, Seiko_data__c>();
        List<Seiko_Data__c> seikoList = [select Id, Hoya_Account_Id__c, Account__c, SEIKO_Xtranet__c, SEIKO_Vision_Xperience_column__c, SEIKO_Vision_Xperience_iPAD__c from Seiko_Data__c where Account__c IN:Ids];
        for (Seiko_data__c eachData : seikoList) {
            accountToSeikoDataMap.put(eachData.Account__c, eachData);
        }
        
        for(New_Media_Usage__c n : newList){
            if(n.Tool__c == 'SXN orders'){
                if (accountToSeikoDataMap.get(n.Hoya_Account_ID__c) != null) {
                    Seiko_data__c data = accountToSeikoDataMap.get(n.Hoya_Account_ID__c);
                    data.SEIKO_Xtranet__c = true;
                }
            } else if (n.Tool__c=='Measurements') {
                if (accountToSeikoDataMap.get(n.Hoya_Account_ID__c) != null) {
                    Seiko_data__c data = accountToSeikoDataMap.get(n.Hoya_Account_ID__c);
                    data.SEIKO_Vision_Xperience_iPAD__c = true;
                }
            } else if (n.Tool__c=='eColumn Measurements') {
                if (accountToSeikoDataMap.get(n.Hoya_Account_ID__c) != null) {
                    Seiko_data__c data = accountToSeikoDataMap.get(n.Hoya_Account_ID__c);
                    data.SEIKO_Vision_Xperience_column__c = true;
                }
            }
        }
        List<Seiko_data__c> updateList = new List<Seiko_data__c>();
        updateList.addAll(accountToSeikoDataMap.values());
        update updateList;
    }
}