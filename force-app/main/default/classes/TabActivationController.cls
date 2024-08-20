public with sharing class TabActivationController {
    public TabActivationController() {

    }

    @AuraEnabled
    public static Seiko_data__c getSeikoData(Id accountId){
        Seiko_data__c seikoSales = null;
        try {
            list<Seiko_data__c> listOfSeikoData = [select Id from Seiko_Data__c where Account__c=:accountId limit 1]; 
            if(!listOfSeikoData.isEmpty()){
                seikoSales =  listOfSeikoData[0];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return seikoSales;
    }
}