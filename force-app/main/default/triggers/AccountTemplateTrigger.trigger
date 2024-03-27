trigger AccountTemplateTrigger on Account_Template__c (before insert, after update, before delete) {
    AccountTemplateTriggerHelper.entry(
                        Trigger.operationType,
                        Trigger.new,
                        Trigger.newMap,
                        Trigger.old,
                        Trigger.oldMap
                        ); 
}