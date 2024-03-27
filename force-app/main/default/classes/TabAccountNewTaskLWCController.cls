public class TabAccountNewTaskLWCController {
    @AuraEnabled(cacheable=true)
    public static ID taskRecordTypeId(){
      ID SupportTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
        return SupportTask; 
    }
    @AuraEnabled(cacheable=true)
    public static ID getAccountId(Id recordtypeID){
        Id AccountId = [SELECT AccountId, Id From Contact Where ID=:recordtypeID].AccountId;
        return AccountId; 
    }

}