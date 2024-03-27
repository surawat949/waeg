trigger AccountLifeCycleTrigger on Account_Life_Cycle__c (before insert,before update) {
    AccountLifeCycleTriggerHelper.entry(Trigger.operationType
        , Trigger.new
        , Trigger.newMap
        , Trigger.old
        , Trigger.oldMap);   
}