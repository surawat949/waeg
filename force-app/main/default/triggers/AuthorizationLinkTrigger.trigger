trigger AuthorizationLinkTrigger on Authorization_Link__c (before insert, after insert, after update) {
    AuthorizationLinkTriggerHelper.entry(
                        Trigger.operationType,
                        Trigger.new,
                        Trigger.newMap,
                        Trigger.old,
                        Trigger.oldMap
                        ); 
}