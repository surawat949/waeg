/**
 *  This batch class is run batch class to update VISIT_KPI__c for Users with visit_counter__c checked
 *
 @author    Yuda Zheng
 @created   2014-04-16
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-16 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */
global class ClsSchedule_runBatchUpdateVisitKPI implements Schedulable{
    global void execute(SchedulableContext sc) {
        BatchCls_UpdateVisitKPI batchUpdateVisitKPI = new BatchCls_UpdateVisitKPI(Date.today(), ClsVisitUtil.getFirstUnCalculatedVisitDate());
        DataBase.executeBatch(batchUpdateVisitKPI, 250);
        
    }
}