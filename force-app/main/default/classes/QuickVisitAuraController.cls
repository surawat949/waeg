global without sharing class QuickVisitAuraController {
   
    @AuraEnabled
    public static Contact getContact(Id recordId){
        Contact result = [select name, Id,AccountId from contact where id=:recordId];
        return result;
    }
    @AuraEnabled
    public static List<Event> getUserIdEvents(Datetime periodStart, Datetime periodEnd, Id userId) {
        System.debug('userEvent periodStart: ' + periodStart);
        System.debug('userEvent periodEnd: ' + periodEnd);
        System.debug('userEvent ID: ' + userId);
        List<Event> events = [
            select Id, StartDateTime, EndDateTime, Subject, Type, WhoId, RecordTypeId, EventSubtype, Description, IsAllDayEvent
            from Event where OwnerId = :userId
            AND EndDateTime > :periodStart
            AND StartDateTime < :periodEnd
            /*AND Visit_Id__c = null*/
        ];
        System.debug('Nb userEvent=' + events.size());
        return events;
    }
}