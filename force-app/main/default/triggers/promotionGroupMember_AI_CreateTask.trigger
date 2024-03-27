/**
 *  This trigger is used to create Task on Account after a PromotionGroupMemeber is created 
 *  and there are PromotionGroupTasks in the PromotionGroup
 *
 @author 	Yuda Zheng
 @created 	2013-04-30
 @version 	1.0
 @since 	27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-04-30 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */
trigger promotionGroupMember_AI_CreateTask on Promotion_Group_Member__c (after insert) {
	//************************* BEGIN Pre-Processing **********************************************
	
	//************************* END Pre-Processing ************************************************
	
	//************************* BEGIN Before Trigger **********************************************
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************

    if(trigger.isAfter && trigger.isInsert) {
    	list<Task> creatTasks;
    	for(Promotion_Group_Member__c promotionGroupMember : trigger.new){
    		//get Promotion_Group_Tasks__c list by Promotion_Group__c
    		list<Promotion_Group_Tasks__c> promotionGroupTasks = [select Id, Name, Description__c from Promotion_Group_Tasks__c where Promotion_Group__c = :promotionGroupMember.Promotion_Group__c ];
    		if(promotionGroupTasks != null && promotionGroupTasks.size() > 0){
    			//get Account map by Id
    			map<Id,Account> accountMap = new map<Id,Account>([select Id, OwnerId from Account where Id = :promotionGroupMember.Account__c]);
    			//get Promotion_Group__c map by Id
    			map<Id,Promotion_Group__c> promotionGroupMap = new map<Id,Promotion_Group__c>([select Id, Name, Promotion_End_Date__c from Promotion_Group__c where Id = :promotionGroupMember.Promotion_Group__c]);
    			for(Promotion_Group_Tasks__c promotionGroupTask : promotionGroupTasks){
					//create new Task for Account which is the Promotion_Group_Member__c in the Promotion_Group__c
    				Task task = new Task();
    				//set OwnerId to Owner of Account__c of Promotion_Group_Member__c
    				task.OwnerId = accountMap.get(promotionGroupMember.Account__c).OwnerId;
    				//set ActivityDate to Promotion_End_Date__c of Promotion_Group__c of Promotion_Group_Member__c
    				task.ActivityDate = promotionGroupMap.get(promotionGroupMember.Promotion_Group__c).Promotion_End_Date__c;
    				//set Subject to Name of Promotion_Group_Tasks__c
    				task.Subject = promotionGroupTask.Name;
    				//set Description to Description__c of Promotion_Group_Tasks__c
    				task.Description = promotionGroupTask.Description__c;
    				//set WhatId to Account__c of Promotion_Group_Member__c
    				task.WhatId = promotionGroupMember.Account__c;
    				//set Promotion_Group_Name__c to Name of Promotion_Group__c of Promotion_Group_Member__c
    				task.Promotion_Group_Name__c = promotionGroupMap.get(promotionGroupMember.Promotion_Group__c).Name;
    				//set Promtion_Group_Task_ID__c to Id of Promotion_Group_Tasks__c
    				task.Promtion_Group_Task_ID__c = promotionGroupTask.Id;
    				//set Status to 'New' as default value
    				task.Status = 'New';
    				if(creatTasks == null){
    					creatTasks = new list<Task>();
    				}
    				creatTasks.add(task);
				}
    		}    		
    	}
    	//create Task
    	if(creatTasks != null && creatTasks.size() > 0){
    		insert creatTasks;
    	}
    }
    
	//************************* END After Trigger *************************************************
}