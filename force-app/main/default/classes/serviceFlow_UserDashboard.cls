public class serviceFlow_UserDashboard {
    @AuraEnabled public static UserDashboardWrapper getDashboardDetails(String recordId){
        UserDashboardWrapper userDashboardWrapperObj = new UserDashboardWrapper();
        userDashboardWrapperObj.totalCases =  [Select Count() From Case Where OwnerId =: UserInfo.getUserId()];
        userDashboardWrapperObj.openCases =   [Select Count() From Case Where OwnerId =: UserInfo.getUserId() AND  Status != 'closed'];
        userDashboardWrapperObj.tasksOpen =   [Select Count() From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Task' and Status NOT IN ('Closed','Completed')];
        userDashboardWrapperObj.tasksClosed = [Select Count() From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Task' and Status IN ('Closed','Completed')];
        userDashboardWrapperObj.callsOpen =   [Select Count() From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Call' and Status NOT IN ('Closed','Completed')];
        userDashboardWrapperObj.callsClosed = [Select Count() From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Call' and Status IN ('Closed','Completed')];
        return userDashboardWrapperObj;
    }
    public class UserDashboardWrapper {
        @AuraEnabled public Integer totalCases {get;set;}
        @AuraEnabled public Integer openCases {get;set;}
        @AuraEnabled public Integer tasksOpen {get;set;}
        @AuraEnabled public Integer tasksClosed {get;set;}
        @AuraEnabled public Integer callsOpen {get;set;}
        @AuraEnabled public Integer callsClosed {get;set;}
    }
    @AuraEnabled public static CaseTaskWrapper getCaseTasks(String operation){
        CaseTaskWrapper caseTaskWrapperObj = new CaseTaskWrapper();
        if(operation.equalsIgnoreCase('totalCases')){
            caseTaskWrapperObj.casesList = [Select Id,CaseNumber,HOYA_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_ECP_patient_order_number__c,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Due_Date__c,Priority,Status,CreatedDate,LastModifiedDate From Case Where OwnerId =: UserInfo.getUserId()];
        }else if(operation.equalsIgnoreCase('openCases')){
            caseTaskWrapperObj.casesList = [Select Id,CaseNumber,HOYA_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_ECP_patient_order_number__c,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Due_Date__c,Priority,Status,CreatedDate,LastModifiedDate From Case Where OwnerId =: UserInfo.getUserId()  AND  Status != 'closed'];
        }else if(operation.equalsIgnoreCase('tasksOpen')){
            caseTaskWrapperObj.taskList = [Select Id,Subject,TaskSubtype,Type,Status,WhatId,What.Name,CallType,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Contact_Name__c,serviceFlow_Contact_Name__r.Name,serviceFlow_ECP_patient_order_number__c,serviceFlow_Hoya_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Number_of_Jobs__c,serviceFlow_Origin__c,serviceFlow_User_Country__c From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Task' and Status NOT IN ('Closed','Completed')];
        }else if(operation.equalsIgnoreCase('tasksClosed')){
            caseTaskWrapperObj.taskList = [Select Id,Subject,TaskSubtype,Type,Status,WhatId,What.Name,CallType,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Contact_Name__c,serviceFlow_Contact_Name__r.Name,serviceFlow_ECP_patient_order_number__c,serviceFlow_Hoya_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Number_of_Jobs__c,serviceFlow_Origin__c,serviceFlow_User_Country__c  From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Task' and Status IN ('Closed','Completed')];
        }else if(operation.equalsIgnoreCase('callsOpen')){
            caseTaskWrapperObj.taskList = [Select Id,Subject,TaskSubtype,Type,Status,WhatId,What.Name,CallType,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Contact_Name__c,serviceFlow_Contact_Name__r.Name,serviceFlow_ECP_patient_order_number__c,serviceFlow_Hoya_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Number_of_Jobs__c,serviceFlow_Origin__c,serviceFlow_User_Country__c  From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Call' and Status NOT IN ('Closed','Completed')];
        }else if(operation.equalsIgnoreCase('callsClosed')){
            caseTaskWrapperObj.taskList = [Select Id,Subject,TaskSubtype,Type,Status,WhatId,What.Name,CallType,SFlow_Subject__c,SFlow_Sub_Subject__c,serviceFlow_Contact_Name__c,serviceFlow_Contact_Name__r.Name,serviceFlow_ECP_patient_order_number__c,serviceFlow_Hoya_Account_ID__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Number_of_Jobs__c,serviceFlow_Origin__c,serviceFlow_User_Country__c  From Task Where OwnerId =: UserInfo.getUserId() AND TaskSubtype='Call' and Status IN ('Closed','Completed')];
        }
        return caseTaskWrapperObj;
    }
    public class CaseTaskWrapper {
        @AuraEnabled public List<Case> casesList {get;set;}
        @AuraEnabled public List<Task> taskList {get;set;}
    }
}