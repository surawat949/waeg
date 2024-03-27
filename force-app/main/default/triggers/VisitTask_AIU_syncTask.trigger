/**
 *  This trigger is used to sync Task
 *
 @author 	Bin Yuan
 @created 	2013-07-11
 @version 	1.0
 @since 	27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-07-11 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
trigger VisitTask_AIU_syncTask on Visit_Task__c (after insert, after update) {
	//************************* BEGIN Pre-Processing **********************************************
	list<Visit_Task__c> list_visitTasks2CreateTask = new list<Visit_Task__c>();
	set<Id> set_visitTasks2UpdateIds = new set<Id>();
	//************************* END Pre-Processing ************************************************
	
	//************************* BEGIN Before Trigger **********************************************
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************

    if(trigger.isAfter) {
    	if(trigger.isInsert){
    		set<Id> set_vtaskIds = new set<Id>();
    		for(Visit_Task__c vtask : [Select Id, Name, CreatedById, Visit__r.Start_Time__c, Visit__r.Account__c,Visit__c, Visit__r.Visit_Status__c
    								   From Visit_Task__c
    								   Where Id IN : trigger.newMap.keySet()]) {
    			
    			list_visitTasks2CreateTask.add(vtask);
    		}
    	}
    	

    	
    	if(!list_visitTasks2CreateTask.isEmpty()) {
    		ClsVisitTaskUtil.createTask(list_visitTasks2CreateTask);
    	} 
    	
    }
    
	//************************* END After Trigger *************************************************
}