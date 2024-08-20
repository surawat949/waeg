/*
    ServiceFlow_UpdateTaskBatch batch = new ServiceFlow_UpdateTaskBatch();
    Database.executeBatch(batch,50);
*/
global class serviceFlow_UpdateTaskBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([Select Id,ActivityDate,LastModifiedDate From Task where ActivityDate = null and Status = 'Closed' and recordType.Name IN ('serviceFlow_AgentCreateCall','serviceFlow_AgentCreateTask','serviceFlow_AgentEditTask')]);
    }

    global void execute(Database.BatchableContext BC, List<Task> scope) {
        for(Task taskRec : scope) {
            taskRec.ActivityDate = taskRec.LastModifiedDate.date();
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        // Execute any post-processing operations
    }
}