public class serviceFlow_TaskIBOBHandler {    
    @AuraEnabled public static List<Task> getTasks(List<String> listOfTaskIds, String callType){
        List<Task> listOfTasks = new List<Task>();
        if(listOfTaskIds.size() > 0){
            for(String taskId : listOfTaskIds){
                listOfTasks.add(new Task(Id = taskId, CallType = callType));
            }
            
        }
        if(listOfTasks.size() > 0){
            Update listOfTasks;        
            return [select Id,CallType,Status,TaskSubtype,serviceFlow_ECP_patient_order_number__c,
                serviceFlow_Hoya_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Number_of_Jobs__c,
                serviceFlow_Origin__c,serviceFlow_User_Country__c,SFlow_Subject__c,SFlow_Sub_Subject__c from Task Where Id IN : listOfTasks
            ];   
        }   
    return new List<Task>();     
    }
}