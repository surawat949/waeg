/**
 * @description       : 
 * @author            : Mohan G (Encora)
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Mohan G (Encora)
**/
public class serviceFlow_AgentNavigatorCtrl {
    @AuraEnabled
    public static serviceFlowAgentNavWrapper getUserData(string recTypeName, string accId) {
        try {
            serviceFlowAgentNavWrapper returnWrapper = New serviceFlowAgentNavWrapper();
            User userObj = [Select Id, Name, UserName, Country__c, Country_for_Customer_Support__c 
                            FROM User WHERE Id = :userInfo.getUserId()];
            Account accObj = null;
            if(String.isNotBlank(accId)){               
                accObj = [SELECT Id, Name, Shop_email_address__c, Phone,Brand__c
                                  FROM Account WHERE Id = :accId];
            }
            returnWrapper.UserData = userObj;
            returnWrapper.accountData = accObj;
            
            if(String.isNotBlank(userObj.Country_for_Customer_Support__c)){
                returnWrapper.recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get(recTypeName).getRecordTypeId();                
                returnWrapper.recordTypeLenseReturnsId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get('serviceFlow_Case_Edit_SouthAfrica').getRecordTypeId();
                returnWrapper.recordTypeRegularId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByDeveloperName().get('serviceFlow_Chat').getRecordTypeId();
            }
            system.debug('returnWrapper -- '+returnWrapper);
            return returnWrapper;
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static string createTaskforCall(string taskCallData) {
        string callRecId = '';
        try {
            if(String.isNotBlank(taskCallData)) {
                system.debug('taskCallData -- '+taskCallData);
                Task taskRec = (Task)JSON.deserialize(taskCallData, Task.class);
                taskRec.ActivityDate = taskRec.Status == 'Closed' ? System.Today() : null;
                taskRec.recordTypeId = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
                if(taskRec != NULL){
                    insert taskRec;
                    callRecId = taskRec.id;
                }
            }
            return callRecId;
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled
    public static string createTaskUtility(string taskCallData) {
        string callRecId = '';
        try {
            if(String.isNotBlank(taskCallData)) {
                system.debug('taskCallData -- '+taskCallData);
                Task taskRec = (Task)JSON.deserialize(taskCallData, Task.class);
                taskRec.ActivityDate = taskRec.Status == 'Closed' ? System.Today() : null;
                taskRec.recordTypeId = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentEditTask').getRecordTypeId();
                if(taskRec != NULL){
                    insert taskRec;
                    callRecId = taskRec.id;
                }
            }
            return callRecId;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled
    public static Case createCaseUtility(Case caseRec) {
        try {
            //caseRec.RecordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('serviceFlow_Chat').getRecordTypeId();
            insert caseRec;
            return caseRec;
            
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class serviceFlowAgentNavWrapper{
        @AuraEnabled
        public User UserData{set;get;}
        @AuraEnabled
        public string recordTypeId{set;get;}
        @AuraEnabled
        public Account accountData{set;get;}
        
        //@South Aftrica RecordTypes
        @AuraEnabled
        public string recordTypeLenseReturnsId{set;get;}
        @AuraEnabled
        public string recordTypeRegularId{set;get;}        
    }
}