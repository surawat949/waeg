public class serviceFlow_ClosedTaskRedirectToHome {
    @AuraEnabled public static Task getTaskRecord(String recordId){
        return [Select Id,TaskSubtype,Type,Subject,Status,Priority,RecordType.Name,RecordTypeId From Task Where Id=:recordId];
    }
    @AuraEnabled public static void updateTask(String recordId){
        Update new Task (
        	Id = recordId,
            Is_Closed_for_First_Time__c = false
        );
    }
}