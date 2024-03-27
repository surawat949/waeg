global class ExternalIncentiveSchedulable implements Schedulable {
    global void execute(SchedulableContext sc){
        ExternaWSIncentiveBatch batch = new ExternaWSIncentiveBatch();
        Database.executeBatch(batch);
    }
}