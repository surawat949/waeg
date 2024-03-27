/*This trigger is used to update the variation fields on Sales Statistics object before insert */
trigger SalesStatisticsUpdater on Sales_Statistics__c (before insert) {
    SalesStatisticsUpaterHelper helper =new SalesStatisticsUpaterHelper();
   if (Trigger.isBefore && Trigger.isInsert) {
       helper.handleBeforeInsert(Trigger.New);
   }
}