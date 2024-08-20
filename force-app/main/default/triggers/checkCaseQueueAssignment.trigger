/**
 * @description       : Case Trigger
 * @author            : 
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Mohan G (Encora)
**/
trigger checkCaseQueueAssignment on Case (before insert, after insert, before update, after update) {
    if(trigger.isBefore && trigger.isInsert) {
		User us = [select companyName from user where id=:UserInfo.getUserId()];
		//System.debug('CDU#companyName='+us.companyName );
		if(us.companyName=='HLFR'){
			RecordType hotlineRT = [select Id from RecordType where Name='hotline'];
			//System.debug('CDU#recordTypeId='+hotlineRT );
			for(Case c :Trigger.new){
				//System.debug('CDU#case.recordTypeId='+hotlineRT);
				if(c.RecordTypeId== hotlineRT.id && (c.status =='Neu'||c.status == 'New')){
					//System.debug('CDU#change owner id to queue' );
					//all new case form HLFR should be assign to FR_hotline_queue
					c.OwnerId='00Gb0000001blHq';
				}
			}
		}
        for(Case c :Trigger.new){
            c.Last_Status_Change_Time__c = DateTime.now();
        }
	}

    //serviceFlow Case after insert logic
    if(trigger.isAfter && trigger.isInsert) {
        serviceFlow_Case_TriggerHandler.afterInsertMethod(trigger.new, trigger.newMap);
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
        CaseTriggerHelper.processTimeSpent(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
    }
    
    //serviceFlow Case after update logic
    if(trigger.isAfter && trigger.isUpdate) {
        serviceFlow_Case_TriggerHandler.afterUpdateMethod(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
    }
}