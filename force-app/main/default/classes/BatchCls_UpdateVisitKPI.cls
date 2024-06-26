/**
 *  This batch class is used to create or update VISIT_KPI__c for Users with visit_counter__c checked
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
global class BatchCls_UpdateVisitKPI implements Database.Batchable<SObject>{
    public string query;
    public Date startDate;
    public DateTime firstVisitDateTime;
    
    global BatchCls_UpdateVisitKPI(Date startDate, DateTime firstVisitDateTime){
        this.startDate = startDate.addMonths(-1).toStartOfMonth();
        this.firstVisitDateTime = firstVisitDateTime;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(query == null || query == ''){
            if(Test.isRunningTest())
                query = 'select Id, Visit_counter__c from User where Visit_counter__c = true and isactive=true Limit 1';
            else
                query = 'select Id, Visit_counter__c from User where Visit_counter__c = true and isactive=true';
        }
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext BC, List<User> list_users){   
        Set<Id> set_uIds = new Set<Id>();
        List<VISIT_KPI__c> list_VisitKPI4insert = new List<VISIT_KPI__c>();
        List<VISIT_KPI__c> list_VisitKPI4update = new List<VISIT_KPI__c>();
        
        for(User user : list_users) {
            set_uIds.add(user.Id);
        }
        
        //set VISIT_KPI__c list for update 
        for(VISIT_KPI__c visitKPI : [select Id, Area_Sales_Manager__c, Date__c from VISIT_KPI__c where Area_Sales_Manager__c in: set_uIds and Month__c =: startDate.month() and Year__c =: startDate.year()]) {
            visitKPI.Date__c = startDate;
            list_VisitKPI4update.add(visitKPI);
            set_uIds.remove(visitKPI.Area_Sales_Manager__c);
        }
        
        //set VISIT_KPI__c list for insert 
        for(Id uid : set_uIds){
            VISIT_KPI__c visitKPI = new VISIT_KPI__c();
            visitKPI.Area_Sales_Manager__c = uid;
            visitKPI.Date__c = startDate;
            list_VisitKPI4insert.add(visitKPI);
        }

        if(list_VisitKPI4insert != null && list_VisitKPI4insert.size() > 0){
            Database.insert(list_VisitKPI4insert);
        }

        if(list_VisitKPI4update != null && list_VisitKPI4update.size() > 0){
            Database.update(list_VisitKPI4update);
        }
    }
    
    global void finish(Database.BatchableContext BC){   
        if(VisitKPI_Settings__c.getInstance('RunWithHistoryData') !=null && VisitKPI_Settings__c.getInstance('RunWithHistoryData').isActive__c){
            VisitKPI_Settings__c.getInstance('RunWithHistoryData').isActive__c = false;
            update VisitKPI_Settings__c.getInstance('RunWithHistoryData');
        }

        Date startThisMonth = Date.today().toStartOfMonth();

        if((firstVisitDateTime == null && startDate.monthsBetween(startThisMonth) < 3)  || (firstVisitDateTime != null && !(firstVisitDateTime.year() == startDate.year() && firstVisitDateTime.month() == startDate.month()))) {
            BatchCls_UpdateVisitKPI batchUpdateVisitKPI = new BatchCls_UpdateVisitKPI(startDate, firstVisitDateTime);
            DataBase.executeBatch(batchUpdateVisitKPI, 200);
        }
    }   
}