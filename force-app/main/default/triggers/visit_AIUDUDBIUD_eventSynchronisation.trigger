/**
 *  This trigger is used to synchronize from visit to event
 *
 @author 	Peng Zhu
 @created 	2013-03-28
 @version 	1.0
 @since 	25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
 * - Created
 */
trigger visit_AIUDUDBIUD_eventSynchronisation on Visits__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
         VisitTriggerHelper.entry(Trigger.operationType
        , Trigger.new
        , Trigger.newMap
        , Trigger.old
        , Trigger.oldMap);     
    //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {

    }
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
        //synchronize
    if(!TriggerRecursionDefense.visitEventSync && Trigger.isAfter) {
        // TODO: if block to be removed as its just used for event creation and update based on visit
        // FIXME: Check with US team if they need event on visit creation
        if(trigger.isAfter) {
            TriggerRecursionDefense.visitEventSync = true;
            String mode;
            list<Visits__c> list_new = new list<Visits__c>();
            list<Visits__c> list_old = new list<Visits__c>();
            if(Trigger.isInsert || Trigger.isUnDelete) {
                mode = ClsVisitUtil.MODE_INSERT;
                list_new = trigger.new; 
            }
            else if(Trigger.isUpdate) {
                mode = ClsVisitUtil.MODE_UPDATE;
                list_new = trigger.new; 
                list_old = trigger.old; 
            }
            else if(Trigger.isDelete) {
                mode = ClsVisitUtil.MODE_DELETE;
                list_old = trigger.old; 
            }
            ClsVisitUtil.calculateTriggerOnVisit(mode, list_new, list_old);
            TriggerRecursionDefense.visitEventSync = false;
        }
    }
    //************************* END After Trigger *************************************************
}