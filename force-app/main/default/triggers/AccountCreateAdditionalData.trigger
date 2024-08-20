trigger AccountCreateAdditionalData on Account (before insert, after insert, before update, after update, before delete) {
    System.debug('+++trigger'+ Trigger.operationType);
    AccountTriggerHelper.entry(Trigger.operationType
        , Trigger.new
        , Trigger.newMap
        , Trigger.old
        , Trigger.oldMap);
}