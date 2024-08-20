/**
 * @description       : 
 * @author            : Fazurulla Ganganapali
 * @group             : 
 * @last modified on  : 
 * @last modified by  : Fazurulla Ganganapali
**/
public class serviceFlow_EndChatController {
    @AuraEnabled
    public static serviceFlowAgentNavWrapper getUserData(string recTypeName, string recordId) {
        try {
            serviceFlowAgentNavWrapper returnWrapper = New serviceFlowAgentNavWrapper();
            User userObj = [Select Id, Name, UserName, Country__c, Country_for_Customer_Support__c 
                            FROM User WHERE Id = :userInfo.getUserId()];
            Account accObj = new Account();
            List<Case> openCases = new List<Case>();
            if(String.isNotBlank(recordId)){  
                LiveChatTranscript liveChatTrascriptRec = new LiveChatTranscript();
                liveChatTrascriptRec = [Select Id,AccountId,Account.Hoya_Account_ID__c,Hoya_Account_ID__c From LiveChatTranscript Where Id=:recordId];       
                accObj = [SELECT Id, Name, Shop_email_address__c, Phone,Brand__c
                                  FROM Account WHERE (Id = :liveChatTrascriptRec.AccountId OR Hoya_Account_ID__c = :liveChatTrascriptRec.Hoya_Account_ID__c) Limit 1];
                openCases = [Select Id,User_Country__c,CaseNumber,serviceFlow_Hoya_reference_number__c,Description,SFlow_Subject__c,SFlow_Sub_Subject__c,Subject,serviceFlow_ECP_patient_order_number__c,Status,serviceFlow_Origin__c,AccountId,Account.Name,Account.Hoya_Account_ID__c From Case Where Account.Hoya_Account_ID__c = :liveChatTrascriptRec.Hoya_Account_ID__c AND Status Not IN ('Closed') AND serviceFlow_Origin__c = 'Chat'];
            }
            returnWrapper.UserData = userObj;
            returnWrapper.accountData = accObj;
            returnWrapper.openCases = openCases;
            if(String.isNotBlank(userObj.Country_for_Customer_Support__c))
            returnWrapper.recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
            system.debug('returnWrapper -- '+returnWrapper);
            return returnWrapper;
        } catch (Exception ex) {
            System.debug(ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static string createCaseRecord(string caseDetails) {
        string caseRecId = '';
        try {
            if(String.isNotBlank(caseDetails)) {
                Case caseRec = (Case)JSON.deserialize(caseDetails, Case.class);
                if(caseRec != NULL){
                    upsert caseRec;
                    caseRecId = caseRec.Id;
                }
            }
            return caseRecId;
        } catch (Exception ex) {
            System.debug(ex);
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
        @AuraEnabled
        public List<Case> openCases{set;get;}
    }
}