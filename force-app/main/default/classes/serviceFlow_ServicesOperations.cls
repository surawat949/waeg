public class serviceFlow_ServicesOperations {
    @AuraEnabled public static UserDashboardWrapper getDashboardDetails(String recordId, String eventType){
        Set<String> statusSet = new Set<String> {'Closed','Geschlossen','Rejected','Close','Marked as Closed'};
        UserDashboardWrapper userDashboardWrapperObj = new UserDashboardWrapper();
        if(eventType == 'Open'){
            userDashboardWrapperObj.openCases =   [Select Count() From Case Where AccountId =: recordId AND  (Status NOT IN : statusSet)];
            userDashboardWrapperObj.tasksOpen =   [Select Count() From Task Where (WhatId =:recordId OR AccountId =: recordId) AND TaskSubtype='Task' and (not Status in ('Closed', 'Completed', 'Close'))];
            userDashboardWrapperObj.callsOpen =   [Select Count() From Task Where (WhatId =:recordId OR AccountId =: recordId) AND TaskSubtype='Call' and (not Status in ('Closed', 'Completed', 'Close'))];        
        }else{        
            userDashboardWrapperObj.closedCases =   [Select Count() From Case Where AccountId =: recordId AND   (Status IN : statusSet)];
            userDashboardWrapperObj.callsClosed =   [Select Count() From Task Where (WhatId =:recordId OR AccountId =: recordId) AND TaskSubtype='Call' and (Status in ('Closed', 'Completed', 'Close'))];
            userDashboardWrapperObj.tasksClosed =   [Select Count() From Task Where (WhatId =:recordId OR AccountId =: recordId) AND TaskSubtype='Task' and (Status in ('Closed', 'Completed', 'Close'))];
        }
        return userDashboardWrapperObj;
    }
    public class UserDashboardWrapper {
        @AuraEnabled public Integer openCases {get;set;}
        @AuraEnabled public Integer tasksOpen {get;set;}
        @AuraEnabled public Integer callsOpen {get;set;}
        
        @AuraEnabled public Integer closedCases {get;set;}
        @AuraEnabled public Integer callsClosed {get;set;}
        @AuraEnabled public Integer tasksClosed {get;set;}
    }
    
    @AuraEnabled
    public static List < ActivityTimelineGroup > getActivityTimeline(Id recordId, String eventType) {
        Schema.SObjectType sobjType = recordId.getSobjectType();
        List < ActivityTimelineModel > lstAllActivities = new List < ActivityTimelineModel > ();
        addTasksAndEmails(lstAllActivities, recordId, eventType);
        return generateGroups(lstAllActivities);
    }
    public static List < ActivityTimelineGroup > generateGroups(List < ActivityTimelineModel > lstAllActivities) {
        lstAllActivities.sort();
        List < ActivityTimelineModel > lstOpenActivities = new List < ActivityTimelineModel > ();
        for (ActivityTimelineModel item: lstAllActivities) {
            if (!item.isComplete) {
                lstOpenActivities.add(item);
            }
        }
        Map < Long, List < ActivityTimelineModel >> mapActivityTimeline = new Map < Long, List < ActivityTimelineModel >> ();
        for (ActivityTimelineModel item: lstAllActivities) {
            if (item.isComplete) {
                List < ActivityTimelineModel > lstActivities = new List < ActivityTimelineModel > ();
                DateTime firstDayOfMonth = item.activityDate != null ? Datetime.newInstance(item.activityDate.year(), item.activityDate.month(), 1, 0, 0, 0) : null;
                Long mapKey = firstDayOfMonth != null ? firstDayOfMonth.getTime() : null;
                if (mapActivityTimeline.containsKey(mapKey)) {
                    lstActivities = mapActivityTimeline.get(mapKey);
                }
                lstActivities.add(item);
                mapActivityTimeline.put(mapKey, lstActivities);
            }
        }

        List < ActivityTimelineGroup > lstActivityGroups = new List < ActivityTimelineGroup > ();
        lstActivityGroups.add(new ActivityTimelineGroup(System.Label.Upcoming_Overdue, lstOpenActivities));
        For(Long dateAsLong: mapActivityTimeline.keySet()) {
            if (dateAsLong != null) {
                ActivityTimelineGroup activityGroup = new ActivityTimelineGroup(dateAsLong, mapActivityTimeline.get(dateAsLong));
                lstActivityGroups.add(activityGroup);
            }
        }
        return lstActivityGroups;
    }

    public static void addTasksAndEmails(List < ActivityTimelineModel > returnList, Id recordId, String eventType) {
        Set<Id> whatIdSet = new Set<Id>{recordId};
        Set<String> statusSet = new Set<String> {'Closed', 'Completed', 'Close'};        
        String soqlString = 'SELECT Id, ActivityDate, Description, IsRecurrence, OwnerId, Owner.Name, Priority, Status, Subject,TaskSubtype, Type, WhatId, What.Name, WhoId, Who.Name,AccountId,CallType, SFlow_Subject__c,SFlow_Sub_Subject__c,CreatedDate,LastModifiedDate,serviceFlow_Hoya_reference_number__c,serviceFlow_ECP_patient_order_number__c From Task ';        
        if(eventType == 'Open')
            soqlString += ' Where (not Status In : statusSet ) And (WhatId IN :whatIdSet OR AccountId IN :whatIdSet) ORDER BY ActivityDate,TaskSubtype DESC NULLS LAST';
        else
            soqlString += ' Where (Status In : statusSet ) And (WhatId IN :whatIdSet OR AccountId IN :whatIdSet) ORDER BY ActivityDate,TaskSubtype DESC NULLS LAST';        
        List < Task > taskList = Database.query(soqlString);
        Map < String, TaskStatus > mapTaskStatus = new Map < String, TaskStatus > ();
        for (TaskStatus ts: [SELECT MasterLabel, IsClosed FROM TaskStatus]) {
            mapTaskStatus.put(ts.MasterLabel, ts);
        }

        Map < String, TaskPriority > mapTaskPriority = new Map < String, TaskPriority > ();
        for (TaskPriority tp: [SELECT MasterLabel, IsHighPriority FROM TaskPriority]) {
            mapTaskPriority.put(tp.MasterLabel, tp);
        }

        Map < Id, Task > mapEmailTasks = new Map < Id, Task > ();
        if (taskList.size() > 0) {
            for (Task taskObj: taskList) {
                ActivityTimelineModel taskItem = new ActivityTimelineModel();
                taskItem.recordId = taskObj.Id;
                taskItem.sobjectName = String.valueOf(Task.SobjectType);
                taskItem.activityTimelineType = taskObj.TaskSubtype;
                taskItem.activityDate = taskObj.ActivityDate;
                taskItem.subject = taskObj.Subject;
                taskItem.detail = taskObj.Description;

                taskItem.assignedTo = new ActivityTimelineModel.RecordReference(taskObj.OwnerId, taskObj.Owner.Name);

                if (String.isNotEmpty(taskObj.WhoId)) {
                    if (taskObj.WhoId != recordId) {
                        taskItem.recipients = new List < ActivityTimelineModel.RecordReference > ();
                        taskItem.recipients.add(new ActivityTimelineModel.RecordReference(taskObj.WhoId, taskObj.Who.Name));
                    }
                }

                if (String.isNotEmpty(taskObj.WhatId)) {
                    if (taskObj.WhatId != recordId) {
                        taskItem.relatedTo = new ActivityTimelineModel.RecordReference(taskObj.WhatId, taskObj.What.Name);
                    }
                }

                taskItem.isComplete = mapTaskStatus.get(taskObj.Status).IsClosed;
                taskItem.isOverdue = taskObj.ActivityDate < Date.today() && !taskItem.isComplete;
                taskItem.isRecurring = taskObj.IsRecurrence;
                
                taskItem.CreatedDate = taskObj.CreatedDate.date();
                taskItem.LastModifiedDate = taskObj.LastModifiedDate.date();
                taskItem.serviceFlow_Hoya_reference_number = taskObj.serviceFlow_Hoya_reference_number__c != null ? taskObj.serviceFlow_Hoya_reference_number__c : '';
                taskItem.serviceFlow_ECP_patient_order_number = taskObj.serviceFlow_ECP_patient_order_number__c != null ? taskObj.serviceFlow_ECP_patient_order_number__c : '';
                taskItem.SFlow_Subject = String.isNotBlank(taskObj.Subject) ? taskObj.Subject : taskObj.SFlow_Subject__c;
                taskItem.SFlow_Sub_Subject = taskObj.SFlow_Sub_Subject__c;
                taskItem.Priority = taskObj.Priority != null ? taskObj.Priority : '';
                taskItem.CallType = taskObj.CallType != null ? taskObj.CallType : '';
                
            
                taskItem.isPriority = mapTaskPriority.get(taskObj.Priority).IsHighPriority;
                returnList.add(taskItem);
            }
        }
    }
    @AuraEnabled(cacheable = true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(String TableName, String recordId, String orderBy, String direction, String eventType)
    {
        List < DataTableColumns > lstDataColumns = new List < DataTableColumns > ();
        List < SObject > lstDataTableData = new List < SObject > ();
        List < string > columnList = new List < string > ();
        List < string > fieldAPINameList = new List < string > ();
        String userId = UserInfo.getUserId();
        Dynamic_Table_DataTable__mdt TableComponentMetadata = [SELECT Id, DeveloperName, Field_Value__c, Header_Value__c, Query__c, Table_Title__c,Sortable__c FROM Dynamic_Table_DataTable__mdt WHERE DeveloperName =: TableName];

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
        Set<String> statusSet = new Set<String> {'Closed','Geschlossen','Rejected','Close','Marked as Closed'};
        if(eventType == 'Open')
            soqlString += ' Where AccountId =: recordId AND (Status Not IN : statusSet) ';            
        else
            soqlString += ' Where AccountId =: recordId AND (Status IN : statusSet) ';        
        soqlString += ' ORDER BY '+orderBy+' '+direction+' Limit 2000';
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
}