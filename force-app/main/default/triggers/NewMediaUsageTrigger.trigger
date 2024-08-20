trigger NewMediaUsageTrigger on New_Media_Usage__c (after insert) {
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            NewMediaTriggerController.doNewMediaUsageAfterInsert(Trigger.new);
        }
    }
}