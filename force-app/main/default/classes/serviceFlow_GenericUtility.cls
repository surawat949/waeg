public class serviceFlow_GenericUtility
{
    @AuraEnabled(cacheable = true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(String TableName, String orderBy, String direction)
    {
        List < DataTableColumns > lstDataColumns = new List < DataTableColumns > ();
        List < SObject > lstDataTableData = new List < SObject > ();
        List < string > columnList = new List < string > ();
        List < string > fieldAPINameList = new List < string > ();
        String userId = UserInfo.getUserId();
        User user = [Select Id,Country_for_Customer_Support__c From User Where Id=:UserInfo.getUserId()];
        
        if(String.isNotBlank(user.Country_for_Customer_Support__c)){
            TableName += '_'+user.Country_for_Customer_Support__c.replaceAll(' ','_');
        }
        Dynamic_Table_DataTable__mdt TableComponentMetadata = [SELECT Id,Field_Value__c,Object_Name__c, Header_Value__c, Query__c, Table_Title__c FROM Dynamic_Table_DataTable__mdt WHERE DeveloperName =: TableName];
        if (TableComponentMetadata.Header_Value__c != null)
        {
            columnList = TableComponentMetadata.Header_Value__c.split(',');
        }

        if (TableComponentMetadata.Field_Value__c != null)
        {
            fieldAPINameList = TableComponentMetadata.Field_Value__c.split(',');
        }

        for (integer i = 0; i < columnList.size(); i++)
        {

            DataTableColumns datacolumns = new DataTableColumns(columnList[i].trim(),
                fieldAPINameList[i].substringBefore(':').trim(),
                fieldAPINameList[i].substringAfter(':').trim());

            lstDataColumns.add(datacolumns);
        }
        String soqlString = TableComponentMetadata.Query__c;
        if(TableComponentMetadata.Object_Name__c == 'Case'){
            soqlString += ' Where OwnerId=:userId';
            soqlString += ' ORDER BY '+orderBy+' '+direction+' Limit 2000';
        }else if(TableComponentMetadata.Object_Name__c == 'Call'){
            String TaskSubtype = 'Call';
            soqlString += ' Where TaskSubtype=\'' + String.escapeSingleQuotes('Call') + '\' AND (OwnerId=:userId OR CreatedById=:userId OR serviceFlow_Previous_Assigned_User__c=:userId) ';
            soqlString += ' ORDER BY '+orderBy+' '+direction+' Limit 2000';
        }else if(TableComponentMetadata.Object_Name__c == 'Task'){
            String TaskSubtype = 'Call';
            soqlString += ' Where TaskSubtype !=\'' + String.escapeSingleQuotes('Call') + '\' AND (OwnerId=:userId OR CreatedById=:userId OR serviceFlow_Previous_Assigned_User__c=:userId) ';
            soqlString += ' ORDER BY '+orderBy+' '+direction+' Limit 2000';
        }
        for (SObject SObjectItem: Database.query(soqlString))
        {
            lstDataTableData.add(SObjectItem);
        }

        DataTableResponse finalWrapper = new DataTableResponse();
        finalWrapper.TableTitle = TableComponentMetadata.Table_Title__c;
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData = lstDataTableData;
        return finalWrapper;
    }

    public class DataTableColumns
    {
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String fieldName{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String sortable{get;set;}
        

        public DataTableColumns(String label, String fieldName, String type)
        {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.sortable = 'true';
        }
    }

    public class DataTableResponse
    {
        @AuraEnabled public List < DataTableColumns > lstDataTableColumns{get;set;}
        @AuraEnabled public List < sObject > lstDataTableData{get;set;}
        @AuraEnabled public String TableTitle{get;set;}
    }
    
    @AuraEnabled public static Case getRecordDetails(String recordId){
        return [Select Id,serviceFlow_Account_Shop_email_address__c,serviceFlow_Account_Shop_number__c,
            serviceFlow_Box_Number__c,serviceFlow_Case_Type__c,serviceFlow_Contact_Email__c,serviceFlow_Contact_First_Name__c,
            serviceFlow_Contact_Last_Name__c,serviceFlow_Contact_Number__c,serviceFlow_Customer_code__c,serviceFlow_Customer_Email__c,
            serviceFlow_Defect__c,serviceFlow_Due_Date__c,serviceFlow_Email_sent_to_Customer__c,serviceFlow_Free_Text_for_notes__c,serviceFlow_Hoya_Delivery_note__c,
            serviceFlow_Is_Quality_Return_Initiated__c,serviceFlow_Notes__c,serviceFlow_Number_of_Jobs__c,serviceFlow_Origin__c,serviceFlow_Parameters_checked__c,serviceFlow_ECP_patient_order_number__c,
            serviceFlow_Physical_returns__c,serviceFlow_Processing_Description__c,serviceFlow_Quality_return_detailed__c,serviceFlow_Hoya_reference_number__c,serviceFlow_Report_numnber__c,serviceFlow_Send_a_reminder__c,
            serviceFlow_Different_to_account_info__c,serviceFlow_UI_Subject__c,serviceFlow_UI_Sub_Subject__c,SFlow_Subject__c,SFlow_Sub_Subject__c,AccountId,CaseNumber,Origin,OwnerId,Owner.Name,Reason,RecordTypeId,RecordType.Name,
            CreatedDate,CreatedById,CreatedBy.Name,ClosedDate,Priority,Status,Subject,Type,SuppliedCompany,SuppliedEmail,SuppliedName,SuppliedPhone,LastModifiedById,LastModifiedBy.Name From Case Where Id=:recordId];    
    }
    @AuraEnabled public static TaskWrapper getRecordTaskDetails(String recordId){
        Task taskRec = [Select Id,Subject,OwnerId,serviceFlow_Contact_Name__r.Name,serviceFlow_Contact_Name__c,Owner.Name,Status__c,Priority,Type__c,Created_Date__c,serviceFlow_Previous_Assigned_User__c,ActivityDate,
        WhatId,What.Name,WhoId,Who.Name,serviceFlow_User_Country__c,SFlow_Subject__c,SFlow_Sub_Subject__c,CreatedById,CreatedBy.Name,LastModifiedById,LastModifiedBy.Name,Description,Status
        From Task Where Id=:recordId];
        TaskWrapper taskWrapper = new TaskWrapper();
        taskWrapper.Id = taskRec.Id;        
        taskWrapper.ContactId = String.isNotBlank(taskRec.serviceFlow_Contact_Name__c) ? taskRec.serviceFlow_Contact_Name__c : taskRec.WhoId;    
        taskWrapper.Contact_Name =  String.isNotBlank(taskRec.serviceFlow_Contact_Name__c) ? taskRec.serviceFlow_Contact_Name__r.Name : taskRec.Who.Name;
        taskWrapper.Assigned_To = taskRec.Owner.Name;
        taskWrapper.AssignedId = taskRec.OwnerId;
        taskWrapper.Status = taskRec.Status;
        taskWrapper.Priority = taskRec.Priority != null ? taskRec.Priority : '';
        taskWrapper.Type = taskRec.Type__c != null ? taskRec.Type__c : '';
        taskWrapper.Created_Date = taskRec.Created_Date__c;
        taskWrapper.Previous_Assigned_User = taskRec.serviceFlow_Previous_Assigned_User__c;
        taskWrapper.Due_Date = taskRec.ActivityDate != null ? taskRec.ActivityDate : null;
        taskWrapper.Related_To = taskRec.What.Name;
        taskWrapper.RelatedId = taskRec.WhatId;
        taskWrapper.User_Country = taskRec.serviceFlow_User_Country__c;        
        taskWrapper.Subject = String.isNotBlank(taskRec.SFlow_Subject__c) ? taskRec.SFlow_Subject__c : taskRec.Subject;
        taskWrapper.Sub_Subject = taskRec.SFlow_Sub_Subject__c != null ? taskRec.SFlow_Sub_Subject__c : '';
        taskWrapper.Created_Name = taskRec.CreatedBy.Name;
        taskWrapper.CreatedById = taskRec.CreatedById;
        taskWrapper.LastModified_Name = taskRec.LastModifiedBy.Name;
        taskWrapper.LastModifiedById = taskRec.LastModifiedById;
        taskWrapper.Description = taskRec.Description != null ? taskRec.Description : '';
        return taskWrapper;    
    }
    public class TaskWrapper {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String ContactId {get;set;}
        @AuraEnabled public String Contact_Name {get;set;}
        @AuraEnabled public String Assigned_To {get;set;}
        @AuraEnabled public String AssignedId {get;set;}
        @AuraEnabled public String Status {get;set;}
        @AuraEnabled public String Priority {get;set;}
        @AuraEnabled public String Type {get;set;}
        @AuraEnabled public Date Created_Date {get;set;}
        @AuraEnabled public String Previous_Assigned_User {get;set;}
        @AuraEnabled public Date Due_Date {get;set;}
        @AuraEnabled public String Related_To {get;set;}
        @AuraEnabled public String RelatedId {get;set;}
        @AuraEnabled public String User_Country {get;set;}
        @AuraEnabled public String Subject {get;set;}
        @AuraEnabled public String Sub_Subject {get;set;}
        @AuraEnabled public String Created_Name {get;set;}
        @AuraEnabled public String CreatedById {get;set;}
        @AuraEnabled public String LastModified_Name {get;set;}
        @AuraEnabled public String LastModifiedById {get;set;}
        @AuraEnabled public String Description {get;set;}
    }
    @AuraEnabled public static void upsertContactRecord(Contact record, String taskId) {
        Task taskObj = [Select Id,AccountId,WhoId,serviceFlow_Contact_Name__c From Task Where Id=:taskId];
        Id customerServiceContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('serviceFlow_Customer_Service_Contact').getRecordTypeId();
        record.RecordTypeId = customerServiceContactRecordTypeId;
        record.AccountId = taskObj.AccountId;
        upsert record;
        
        if(String.isNotBlank(record.Id)){
            taskObj.WhoId = record.Id;
            taskObj.serviceFlow_Contact_Name__c = record.Id;
            update taskObj;
        }
    }
    @AuraEnabled public static String updateStatus(String recordId, String statusValue){
        try{
            Task taskRec = new Task();
            taskRec.Id = recordId;
            taskRec.Status = statusValue;
            update taskRec;
        }catch(Exception e){
            return e.getMessage();
        }
        return 'Status has been updated successfully';
    }
}