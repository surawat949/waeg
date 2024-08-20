/**
 *	Contains a set of static methods used Visit Task Object
 *
 @author Bin Yuan
 @created 2013-07-12
 @version 1.0
 @since 25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-07-12 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */

 public class ClsVisitTaskUtil {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
	* This method is used to create standard Task object when new Visit Task is created
	*
	@author Bin Yuan
    @created 2013-07-12	
    @version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@param list<Visit_Task__c> list_visitTasks
	*
	*
	@changelog
	* 2013-07-12 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
	public static void createTask(list<Visit_Task__c> list_visitTasks) {
		list<Task> list_stdTask2Insert = new list<Task>();
		for(Visit_Task__c vTask : list_visitTasks) {
			Task sTask = new Task();
			sTask.OwnerId = vTask.CreatedById;
			sTask.ActivityDate = vTask.Visit__r.Start_Time__c.date();
			//sTask.WhoId = vTask.Visit__r.Account__c;
			sTask.Description = vTask.Name;
			sTask.WhatId = vTask.Visit__r.Account__c;
			sTask.Subject = 'Visit Task';
			sTask.Priority = 'medium';
			sTask.Status = vTask.Visit__r.Visit_Status__c;
			sTask.Visit_Task_ID__c = vTask.Id;
			list_stdTask2Insert.add(sTask);
		}
		if(!list_stdTask2Insert.isEmpty()) {
			insert list_stdTask2Insert;
		} 
	}
	
   /**
	* This method is used to update standard Task object when new Visit Task is complete
	*
	@author Bin Yuan
    @created 2013-07-12	
    @version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@param set<Id> set_visitTasks2UpdateIds
	*
	*
	@changelog
	* 2013-07-12 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
	public static void updateTaskStatus(set<Id> set_visitTasks2UpdateIds) {
		list<Task> list_stdTask2Update = new list<Task>();
		for(Task sTask : [Select Id, Status From Task Where Visit_Task_ID__c IN : set_visitTasks2UpdateIds]) {
			sTask.Status = 'Completed';
			list_stdTask2Update.add(sTask);
		}
		if(!list_stdTask2Update.isEmpty()) {
			update list_stdTask2Update;
		} 
	}
	
   /**
	* This method is used to update visit task when standard Task has been set to complete
	*
	@author Bin Yuan
    @created 2013-07-12	
    @version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@param list<Visit_Task__c> list_visitTasks
	*
	*
	@changelog
	* 2013-07-12 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
	public static void updateVisitStatus(set<Id> set_tasks2UpdateIds) {
		
		map<Id, String> map_visitId_vTaskName = new map<Id, String>();
		list<Visits__c> list_visit2Update = new list<Visits__c>();
		
		for(Visit_Task__c vTask : [Select Id, Visit__c, Name From Visit_Task__c Where Id IN : set_tasks2UpdateIds]) {
			map_visitId_vTaskName.put(vTask.Visit__c, 'Closed with visit task: ' + vTask.Name + ' (from Visit Task)');
		}
		if(map_visitId_vTaskName.isEmpty()) {
			return;
		} 
		/*  2013-08-15 modify by Jian Yin <Jian.Yin@itbconsult.com> add Visit_Notes__c to query */
		for(Visits__c visit : [Select Id, Visit_Status__c,Visit_Notes__c  From Visits__c Where Id IN : map_visitId_vTaskName.keySet()]) {
			visit.Visit_Status__c = 'Complete';
			visit.Visit_Notes__c = (visit.Visit_Notes__c == null ? map_visitId_vTaskName.get(visit.Id) : visit.Visit_Notes__c);
			list_visit2Update.add(visit);
		}
		if(!list_visit2Update.isEmpty()) {
			update list_visit2Update;
		}
	}
   /**
	* This method is used to update visit task when standard Task has been set to complete
	*
	@author Bin Yuan
    @created 2013-07-12	
    @version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@param list<Visit_Task__c> list_visitTasks
	*
	*
	@changelog
	* 2013-07-12 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	* 2017-03-01 Weili Hong <weili.hong@itbconsult.com>
	* - removed, not used in trigger now. remove it to avoid testclass error
	*/
	/*public static void updateVisitStatusCancel(set<Id> set_tasks2UpdateIds) {
		
		map<Id, String> map_visitId_vTaskName = new map<Id, String>();
		list<Visits__c> list_visit2Update = new list<Visits__c>();
		
		for(Visit_Task__c vTask : [Select Id, Visit__c, Name From Visit_Task__c Where Id IN : set_tasks2UpdateIds]) {
			map_visitId_vTaskName.put(vTask.Visit__c, '');
		}
		if(map_visitId_vTaskName.isEmpty()) {
			return;
		} 
		for(Visits__c visit : [Select Id, Visit_Status__c  From Visits__c Where Id IN : map_visitId_vTaskName.keySet()]) {
			visit.Visit_Status__c = 'Cancelled';
			//visit.Visit_Notes__c = (visit.Visit_Notes__c == null ? map_visitId_vTaskName.get(visit.Id) : visit.Visit_Notes__c);
			list_visit2Update.add(visit);
		}
		if(!list_visit2Update.isEmpty()) {
			update list_visit2Update;
		}
	}*/
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************	

}