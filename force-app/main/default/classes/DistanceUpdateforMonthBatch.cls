global class DistanceUpdateforMonthBatch implements Database.Batchable<SObject>{
    public Date currentDate;
     public static Boolean skipTrigger = false;
    
    global DistanceUpdateforMonthBatch(Date currentDate){
        this.currentDate = currentDate.toStartOfMonth();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        Integer currentMonth = currentDate.month();
        Integer currentYear = currentDate.year();
        System.debug('currentMonth'+currentMonth);
        System.debug('currentYear'+currentYear);
        String query = 'select Id, X12WeekAverageDistanceCovered__c,Area_Sales_Manager__c,Date__c from Visit_KPI__c where Month__c = :currentMonth AND  Year__c =:currentYear';
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext BC, List<Visit_KPI__c> kpiRecords){   
        System.debug('kpiRecords'+kpiRecords);
        Set<Id> set_uIds = new Set<Id>();
               
        List<VISIT_KPI__c> list_VisitKPI4update = new List<VISIT_KPI__c>();
        
        for(Visit_KPI__c KPIrec : kpiRecords) {
            if(KPIrec.Area_Sales_Manager__c != null){
               set_uIds.add(KPIrec.Area_Sales_Manager__c);
            }
        }
        System.debug('Batch currentDate'+currentDate);
       Map<Id, Map<String, DistanceTravelCalculator.AggregateDistanceTravel>> userWeeklyDistances = DistanceTravelCalculator.calculateWeeklyDistances(currentDate,set_uIds);
        Map<Id, Decimal> userAverageDistances = new Map<Id, Decimal>();
        System.debug('userWeeklyDistances'+userWeeklyDistances);
        for (Id userId : userWeeklyDistances.keySet()) {
             System.debug('userWeeklyDistance userId'+userId);
              System.debug('userWeeklyDistance Map'+userWeeklyDistances.get(userId));
            Map<String, DistanceTravelCalculator.AggregateDistanceTravel> weeklyDistances = userWeeklyDistances.get(userId);
             Decimal totalDistance = 0;
             Integer totalcustomerCount = 0;
              for (DistanceTravelCalculator.AggregateDistanceTravel aggregateDistanceTravel : weeklyDistances.values()) {
                  totalDistance += aggregateDistanceTravel.totalDistance;
                  totalCustomerCount += aggregateDistanceTravel.customerCount;
              }
             System.debug('totalDistance'+totalDistance);
             System.debug('totalCustomerCount'+totalCustomerCount);
             Decimal averageDistance = (totalCustomerCount > 0) ? (totalDistance / totalCustomerCount) : 0;
             System.debug('averageDistance'+averageDistance);
             userAverageDistances.put(userId, averageDistance);
         }
            
        //set VISIT_KPI__c list for update 
        for(VISIT_KPI__c visitKPI : kpiRecords) {
            if(userAverageDistances.containsKey(visitKPI.Area_Sales_Manager__c)){
                visitKPI.X12WeekAverageDistanceCovered__c = userAverageDistances.get(visitKPI.Area_Sales_Manager__c);
            }
            list_VisitKPI4update.add(visitKPI);
        }
        

        if(list_VisitKPI4update != null && list_VisitKPI4update.size() > 0){
            skipTrigger = true;
            try{
            	Database.update(list_VisitKPI4update);
            }finally{
                skipTrigger = false;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){   
       
    }   
}