/**
 * This Scheduler class to run Batch CleanupOldEvents
 *
 @author  Steven Qiao
 @created 08/04/2016
 @version 1.0
 @since   35.0 (Force.com ApiVersion)
 *
 @changelog
 * 08/04/2016  Steven Qiao <Rui.Qiao@oinio.com>
 * - Created     
 */
global with sharing class SchedulerCls_CleanupOldEvents implements Schedulable {
	global void execute(SchedulableContext SC) {
		BatchCls_CleanupOldEvents cls = new BatchCls_CleanupOldEvents();
		Database.executeBatch(cls,1);
	}
}