public class ActivityTimelineController {
    @AuraEnabled
    public static List < ActivityTimelineGroup > getActivityTimeline(Id recordId) {
        Schema.SObjectType sobjType = recordId.getSobjectType();
        List < ActivityTimelineModel > lstAllActivities = new List < ActivityTimelineModel > ();
        addTasksAndEmails(lstAllActivities, recordId);
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

    public static void addTasksAndEmails(List < ActivityTimelineModel > returnList, Id recordId) {
        Set<Id> whatIdSet = new Set<Id>{recordId};
        List < Task > taskList = [SELECT Id, ActivityDate, Description, IsRecurrence, OwnerId, Owner.Name, Priority, Status, Subject,TaskSubtype, Type, WhatId, What.Name, WhoId, Who.Name,AccountId,CallType,
                SFlow_Subject__c,SFlow_Sub_Subject__c,CreatedDate,LastModifiedDate,serviceFlow_Hoya_reference_number__c,serviceFlow_ECP_patient_order_number__c
            FROM Task Where (not Status in ('Closed', 'Completed', 'Close', 'Abgeschlossen')) And (WhatId IN :whatIdSet OR AccountId IN :whatIdSet) ORDER BY ActivityDate,TaskSubtype DESC NULLS LAST
        ];

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
                taskItem.detail = String.isNotBlank(taskObj.Description) ? taskObj.Description : '';

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
}