global without sharing class QuickVisitAuraController {
   
    @AuraEnabled(cacheable=true)
    public static Contact getContact(Id recordId){
        Contact result = [select name, Id,AccountId from contact where id=:recordId];
        return result;
    }

    @AuraEnabled
    public static List<Event> getUserIdEvents(Datetime periodStart, Datetime periodEnd, Id userId) {
        //System.debug('userEvent periodStart: ' + periodStart);
        //System.debug('userEvent periodEnd: ' + periodEnd);
        //System.debug('userEvent ID: ' + userId);
        List<Event> events = [
            select Id, StartDateTime, EndDateTime, Subject,Type, WhoId,Visit__c,Visit__r.Account__c, RecordTypeId, EventSubtype, Description, IsAllDayEvent
            from Event where OwnerId = :userId
            AND EndDateTime > :periodStart
            AND StartDateTime < :periodEnd
            /*AND Visit_Id__c = null*/
        ];
        //System.debug('Nb userEvent=' + events.size());
        return events;
    }

    @AuraEnabled
    public static Id getStarndardVisitRecordType(){
        Id StandardVisit = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Eye_Doctor_Visit').getRecordTypeId();
        //System.debug('return : '+StandardVisit);
        return StandardVisit;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchAccountContactRelation(String searchKey, String sObjectApiName, String recordId){
        //System.debug('Contact Id = > '+recordId);
        List<sObject> returnList = new List<sObject>();
        String sWildCardText = '%'+searchKey+'%';
        String sQuery = 'SELECT Id, AccountId, ContactId, Account.Name,Account.Clinic_Name__c,Account.ShippingStreet,Account.ShippingCity FROM '+sObjectApiName+' WHERE ContactId =:recordId AND Account.RecordType.Name=\'Clinic\' AND IsActive=true AND Account.Clinic_Name__c LIKE: sWildCardText ORDER BY Account.Clinic_Name__c ASC LIMIT 100';
        for(sObject obj : database.query(sQuery)){
            returnList.add(obj);
        }
        //System.debug('return size =>'+returnList.size()+' data = > '+returnList);
        return returnList;
    }

    @AuraEnabled(cacheable=true)
    public static sObject getDefaultAccountId(String recordId, String sObjectApiName){
        //System.debug('Account Id = > '+recordId);
        String recId = recordId;
        String sQuery = 'SELECT Id, Account.Name, AccountId,Account.Clinic_Name__c,Account.ShippingStreet,Account.ShippingCity FROM '+sObjectApiName+' WHERE AccountId=:recId LIMIT 1';
        for(sObject obj : database.query(sQuery)){
            System.debug('default record => '+obj);
            return obj;
        }
        return null;
    }
}