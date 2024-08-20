public class serviceFlow_TimeLineController {
    @AuraEnabled 
    public static List<TaskWrapper> fetchTask(String recordId){
        List<Task> listOfTasks = [SELECT Id,Subject, AccountId,CallType,
                Description,Priority,Status,TaskSubtype,SFlow_Subject__c,SFlow_Sub_Subject__c,
                Type,WhatId,CreatedDate,LastModifiedDate,serviceFlow_Hoya_reference_number__c,serviceFlow_ECP_patient_order_number__c
                 FROM Task Where (WhatId=:recordId OR AccountId=:recordId ) AND Status IN ('Closed','Completed','Abgeschlossen')  Order By TaskSubtype DESC limit 1000
        ]; 
        List<TaskWrapper> taskWrapperList = new List<TaskWrapper>();
        Map<Date, List<Task>> dateMap = new Map<Date, List<Task>>();
        
        for(Task task : listOfTasks){
            TaskWrapper taskWrapper = new TaskWrapper ();
            taskWrapper.Id = task.Id;
            taskWrapper.Subject = String.isNotBlank(task.Subject) ? task.Subject : task.SFlow_Subject__c;
            taskWrapper.AccountId = task.AccountId;
            taskWrapper.CallType = task.CallType;
            taskWrapper.Description = task.Description;
            taskWrapper.Priority = task.Priority;
            taskWrapper.Status = task.Status;
            taskWrapper.TaskSubtype = task.TaskSubtype;
            taskWrapper.Type = task.Type;
            taskWrapper.WhatId = task.WhatId;
            taskWrapper.CreatedDate = task.CreatedDate.date();
            taskWrapper.LastModifiedDate = task.LastModifiedDate.date();
            taskWrapper.serviceFlow_Hoya_reference_number = task.serviceFlow_Hoya_reference_number__c;
            taskWrapper.serviceFlow_ECP_patient_order_number = task.serviceFlow_ECP_patient_order_number__c;
            taskWrapper.SFlow_Subject = String.isNotBlank(task.Subject) ? task.Subject : task.SFlow_Subject__c;
            taskWrapper.SFlow_Sub_Subject = task.SFlow_Sub_Subject__c;
            taskWrapper.dynamicClass = task.TaskSubtype=='Task' ? 'isExpendable slds-timeline__item_expandable slds-timeline__item_task' : 
                                       task.TaskSubtype=='Call' ? 'isExpendable slds-timeline__item_expandable slds-timeline__item_call' : 
                                                                  'isExpendable slds-timeline__item_expandable slds-timeline__item_email';
            taskWrapperList.add(taskWrapper);
        } 
        return taskWrapperList;       
    }
    public class TaskWrapper {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String Subject {get;set;}
        @AuraEnabled public String AccountId {get;set;}
        @AuraEnabled public String CallType{get;set;}
        @AuraEnabled public String Description {get;set;}
        @AuraEnabled public String Priority {get;set;}
        @AuraEnabled public String Status {get;set;}
        @AuraEnabled public String dynamicClass {get;set;}
        @AuraEnabled public String TaskSubtype {get;set;}
        @AuraEnabled public String Type {get;set;}
        @AuraEnabled public String WhatId {get;set;}
        @AuraEnabled public Date CreatedDate{get;set;}
        @AuraEnabled public Date LastModifiedDate{get;set;}    
        @AuraEnabled public String serviceFlow_Hoya_reference_number{get;set;}
        @AuraEnabled public String serviceFlow_ECP_patient_order_number{get;set;}
        @AuraEnabled public String SFlow_Subject{get;set;}
        @AuraEnabled public String SFlow_Sub_Subject{get;set;}   
    }
}