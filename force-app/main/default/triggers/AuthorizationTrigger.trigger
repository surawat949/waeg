trigger AuthorizationTrigger on Authorization__c (before insert, after insert, after update, before delete) {
    AuthorizationTriggerHelper.entry(
                        Trigger.operationType,
                        Trigger.new,
                        Trigger.newMap,
                        Trigger.old,
                        Trigger.oldMap
                        ); 
}