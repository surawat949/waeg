/**
 * This Batch class to run manually
 *
 @author  Steven Qiao
 @created 19/02/2016
 @version 1.0
 @since   35.0 (Force.com ApiVersion)
 *
 @changelog
 * 19/02/2016  Steven Qiao <Rui.Qiao@oinio.com>
 * - Created     
 */
global class BatchCls_CleanupOldEvents implements Database.Batchable<sObject>{
	global String query;
	global String filter;
	global static boolean isRunningBatch = false;
	
    global Database.QueryLocator start(Database.BatchableContext BC){
    	isRunningBatch = true;
		Date lastyear = Date.today().addYears(-1);
		if (query == '' || query == null){
			query = ' Select Id From Event Where ActivityDate < :lastyear ';
		}
		
		query += ((filter != null && filter != '') ? filter : '');   
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<Event> list_Events){
		isRunningBatch = true;
		try{
			delete list_Events;
		}catch (Exception ex){
			system.debug(ex.getMessage());
		}
	}
	
	global void finish(Database.BatchableContext BC){
		isRunningBatch = false;
	}
}