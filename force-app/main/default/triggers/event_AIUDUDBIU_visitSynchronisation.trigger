/**
 *  This trigger is used to
 *
 @author    Peng Zhu
 @created   2013-03-28
 @version   1.0
 @since     25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
 * - Created
 */
trigger event_AIUDUDBIU_visitSynchronisation on Event (after delete, after insert, after undelete, after update, before insert, before update) {
    
    //************************* BEGIN Before Trigger **********************************************
    //validate
    if(!BatchCls_CleanupOldEvents.isRunningBatch)
    {
	    if(Trigger.isBefore) {
	        for(Event e : trigger.new) {
	        	if(trigger.isInsert || trigger.isUpdate) {
					if(e.StartDateTime != null && e.EndDateTime != null && e.StartDateTime > e.EndDateTime) {
						e.addError('Start time can not be greater than end time.');
						continue;
					}
					if(e.StartDateTime != null && e.EndDateTime != null && e.StartDateTime + 13 < e.EndDateTime) {
						e.addError('Duration between Start time and End time can not be longer than 14 days');
						continue;
					}				
					/* Start: 2013-08-14 modify by Jian Yin <Jian.Yin@itbconsult.com>  form date.today() to datetime.now()*/
					if(e.Status__c == 'Complete' && e.EndDateTime != null && e.EndDateTime > datetime.now()) {
						e.addError('Event is set to complete with End date in future. Please check End date to be either in past or today.');	
						continue;
					}
	
				}
	            if(trigger.isUpdate) {
	                if(e.IsPrivate != trigger.oldMap.get(e.id).IsPrivate) {
	                    e.IsPrivate.addError('You can not change private');
	                    continue;
	                }
	            }
	        }
	    }
	    //************************* END Before Trigger ************************************************
	    
	    //************************* BEGIN After Trigger ***********************************************
	    //synchronize 
		// TODO : To be removed as no event update needs to be synchronized with Visits  
	    if(!TriggerRecursionDefense.visitEventSync && Trigger.isAfter) {
	        if(trigger.isAfter) {
	            TriggerRecursionDefense.visitEventSync = true;
	            String mode;
	            list<Event> list_new = new list<Event>();
	            list<Event> list_old = new list<Event>();
	            if(trigger.isInsert || trigger.isUnDelete) {
	                mode = ClsVisitUtil.MODE_INSERT;
	                //list_new = trigger.new;
	                for(Event event : trigger.new) {
		        		if(event.WhatId != null){
		        			list_new.add(event);
		        		}
		        	}
	            } 
	            else if(trigger.isUpdate) {
	                mode = ClsVisitUtil.MODE_UPDATE;
	                //list_new = trigger.new;
	                for(Event event : trigger.new) {
		        		if(event.WhatId != null){
		        			list_new.add(event);
		        		}
		        	}
	                //list_old = trigger.old;
	                for(Event event : trigger.old) {
		        		if(event.WhatId != null){
		        			list_old.add(event);
		        		}
		        	}
	            }
	            else if(trigger.isDelete) {
					mode = ClsVisitUtil.MODE_DELETE;
					//list_old = trigger.old;
	                for(Event event : trigger.old) {
						//CDU 05/02/2020: replace test from whatid to visit_id_c
		        		//if(event.WhatId != null){
						if(event.visit_id__c != null){
		        			list_old.add(event);
		        		}
		        	}
	            }
				// TODO: Below method call can be removed while cleanup. We dont want to update visits anymore based on event update
	            ClsVisitUtil.calculateTriggerOnEvent(mode, list_new, list_old);
	            TriggerRecursionDefense.visitEventSync = false;
	            
	        }
	    }
    }
    //************************* END After Trigger *************************************************
}