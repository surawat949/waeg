public with sharing class tabActivationPortalController {
	@AuraEnabled(cacheable=true)
    public static Id getSeikoDataId(Id accId){
        List<Seiko_Data__c> sales = [Select Id From Seiko_Data__c Where Account__c=:accId];
        if(sales.size() > 0){
            return sales[0].Id;
        }
        else 
            return null;
    }   
    @AuraEnabled(cacheable=false)
    public static string startEnroll(Id accountId){
        String error = 'ok';
        try{
            Seiko_data__c s = [select Id,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
            from Seiko_Data__c where Account__c=:accountId];
            error = ExternalWSCall.activateAccount(accountId, s.id);
        }catch (Exception e) {
            LogException.log(e);
            error = e.getMessage();
            return e.getMessage();
        }
        return error;
    }
}