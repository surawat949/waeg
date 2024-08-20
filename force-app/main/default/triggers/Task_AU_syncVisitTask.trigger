/**
 *  This trigger is used to sync visit Task when status set to complete
 *
 @author    Bin Yuan
 @created   2013-07-11
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-07-11 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
trigger Task_AU_syncVisitTask on Task (before insert, after update, after insert) {
    //************************* BEGIN Pre-Processing **********************************************
    set<Id> set_visitTasks2UpdateIds = new set<Id>();
    set<Id> set_visitTasks2UpdateCancelIds = new set<Id>();
    //************************* END Pre-Processing ************************************************
    
    //************************* BEGIN Before Trigger **********************************************
    
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************

    if(Trigger.isInsert){
        
        if(Trigger.isBefore){
           
            //TaskTriggerHandler.ReturnRelateId(Trigger.New);
        }
    }
    
    if(trigger.isAfter) {

        if(trigger.isUpdate){
            for(Task stask : trigger.new) {
                if(stask.Status == 'Abgeschlossen' && stask.Status != trigger.oldMap.get(stask.Id).Status) {
                    if(stask.Visit_Task_ID__c != null) set_visitTasks2UpdateIds.add(stask.Visit_Task_ID__c);
                }
                
                if(stask.Status == 'Verschoben' && stask.Status != trigger.oldMap.get(stask.Id).Status) {
                    //if(stask.Visit_Task_ID__c != null) set_visitTasks2UpdateCancelIds.add(stask.Visit_Task_ID__c);
                }
            }
        }
        
        if(!set_visitTasks2UpdateCancelIds.isEmpty()) {
            //ClsVisitTaskUtil.updateVisitStatusCancel(set_visitTasks2UpdateCancelIds);
        } 
        if(!set_visitTasks2UpdateIds.isEmpty()) {
            //ClsVisitTaskUtil.updateVisitStatus(set_visitTasks2UpdateIds);
        } 
        
        if(trigger.isInsert){
            TaskTriggerHandler.createContact(Trigger.New);
        }
    }
    
    //************************* END After Trigger ************************************************* 
}