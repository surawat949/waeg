public with sharing class IsicomSSO {
    @AuraEnabled
    public static string getIsicomAgent(){
        try {
            User u = [select Id, username, IsicomAgent__c from User where id=:UserInfo.getUserId()];
            return u.IsicomAgent__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}