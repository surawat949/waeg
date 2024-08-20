trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    UserTriggerHandler UserHandler = new UserTriggerHandler();
 
    /* Before Insert */
    if(Trigger.isInsert && Trigger.isBefore) {
        UserHandler.OnBeforeInsert(Trigger.new);
    }
 
    /* After Insert */
    else if(Trigger.isInsert && Trigger.isAfter) {
        UserHandler.OnAfterInsert(Trigger.new, Trigger.newMap);
    }
    /* Before Update */
    else if(Trigger.isUpdate && Trigger.isBefore) {
        UserHandler.OnBeforeUpdate(Trigger.old, Trigger.oldMap,Trigger.new, Trigger.newMap);
    }
     
    /* After Update */
    else if(Trigger.isUpdate && Trigger.isAfter) {
        UserHandler.OnAfterUpdate(Trigger.old, Trigger.oldMap,Trigger.new, Trigger.newMap);
    }
     
    /* Before Delete 
    else if(Trigger.isDelete && Trigger.isBefore) {
        UserHandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }*/
     
    /* After Delete 
    else if(Trigger.isDelete && Trigger.isAfter) {
        UserHandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }*/
}