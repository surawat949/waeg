public with sharing class EnrollDigitalPlatform_Controller {
    
    @AuraEnabled
    public static string enroll(String accountId){
        String error = 'ok';
        /*try{
            
            Seiko_data__c s = [select Id,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
            from Seiko_Data__c where Account__c=:accountId];
        
            error = ExternalWSCall.activateAccount(accountId, s.id);
        }catch (Exception e) {
            LogException.log(e);
            error = e.getMessage();
            return e.getMessage();
        }*/
        return error;
    }
}