global class ActivityTimelineModel implements Comparable {
    @AuraEnabled global Id recordId {get;set;}
    @AuraEnabled global String sobjectName {get;set;}    
    @AuraEnabled global String activityTimelineType {get;set;}    
    @AuraEnabled global DateTime activityDate {get;set;}
    @AuraEnabled global String subject {get;set;}    
    @AuraEnabled global String detail {get;set;}    
    @AuraEnabled global List<RecordReference> recipients {get;set;}    
    @AuraEnabled global RecordReference relatedTo {get;set;}
    @AuraEnabled global RecordReference assignedTo {get;set;}    
    @AuraEnabled global DateTime startDateTime {get;set;}
    @AuraEnabled global DateTime endDateTime {get;set;}
    @AuraEnabled global boolean isPriority {get;set;}    
    @AuraEnabled global boolean isComplete {get;set;}
    @AuraEnabled global boolean isRecurring {get;set;}
    @AuraEnabled global boolean isOverdue {get;set;}
    @AuraEnabled global boolean hasAttachments {get;set;}    
    @AuraEnabled global Date CreatedDate{get;set;}
    @AuraEnabled global Date LastModifiedDate{get;set;}    
    @AuraEnabled global String serviceFlow_Hoya_reference_number{get;set;}
    @AuraEnabled global String serviceFlow_ECP_patient_order_number{get;set;}
    @AuraEnabled global String SFlow_Subject{get;set;}
    @AuraEnabled global String SFlow_Sub_Subject{get;set;}
    @AuraEnabled global String Priority{get;set;}
    @AuraEnabled global String CallType{get;set;} 

    global class RecordReference {
        @AuraEnabled global Boolean isCurrentUser {get;set;}
        @AuraEnabled global Id recordId {get;set;}
        @AuraEnabled global String recordName {get;set;}
        @AuraEnabled global String sobjectName {get;set;}        
        global RecordReference(Id recordId, String recordName){
            this.recordId = recordId;
            this.isCurrentUser = recordId == UserInfo.getUserId();
            this.recordName = recordName;
            this.sobjectName = String.valueOf(recordId.getSobjectType());
        }
    }
    global Integer compareTo(Object instance) {
        ActivityTimelineModel compareToActivity = (ActivityTimelineModel) instance;
        if (this.activityDate == compareToActivity.activityDate) return 0;
        if (this.activityDate < compareToActivity.activityDate) return 1;
        return -1;
    }    
}