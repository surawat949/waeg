public class serviceFlow_UpdateCallType {
    @AuraEnabled
    public static serviceFlowAgentNavWrapper getUserData(string recTypeName, String recordId) {
        try {
            serviceFlowAgentNavWrapper returnWrapper = New serviceFlowAgentNavWrapper();
            User userObj = [Select Id, Name, UserName, Country__c, Country_for_Customer_Support__c 
                            FROM User WHERE Id = :userInfo.getUserId()];
            Task currentRecord = [Select Id,CallType,Subject,SFlow_Subject__c,SFlow_Sub_Subject__c,Description,CreatedDate From Task Where Id=:recordId Limit 1];
            returnWrapper.UserData = userObj;   
            returnWrapper.taskRecordData = currentRecord;    
            if(String.isBlank(currentRecord.Description)){
                returnWrapper.taskExistingDescription = '';
            }else if(currentRecord.Description.containsNone('--')){
                returnWrapper.taskExistingDescription = '\r\n\r\n--('+currentRecord.CreatedDate+') '+UserInfo.getName()+'--'+'\r\n\r\n' + currentRecord.Description;
            }else{
                returnWrapper.taskExistingDescription = currentRecord.Description;
            }    
            returnWrapper.recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
            returnWrapper.taskRecTypeId = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateTask').getRecordTypeId();
            return returnWrapper;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    public class serviceFlowAgentNavWrapper{
        @AuraEnabled
        public User UserData{set;get;}
        @AuraEnabled
        public Task taskRecordData{set;get;}
        @AuraEnabled
        public String taskExistingDescription{set;get;}
        @AuraEnabled
        public string recordTypeId{set;get;}
        
        @AuraEnabled
        public string taskRecTypeId{set;get;}
    }
    @AuraEnabled
    public static String updateTask (Task taskRec) {
        String returnMessage = 'Success';
        try{
            update taskRec;
        }catch (Exception ex) {
            returnMessage = ex.getMessage();
        }
        return returnMessage;
    }
    @AuraEnabled
    public static String updateTaskDescription(Task taskRec) {
        String returnMessage = 'Success';
        try{
            taskRec.Description = '\r\n\r\n--('+System.Now()+') '+UserInfo.getName()+'--'+'\r\n\r\n'+taskRec.Description;
            update taskRec;
        }catch (Exception ex) {
            returnMessage = ex.getMessage();
        }
        return returnMessage;
    }
}