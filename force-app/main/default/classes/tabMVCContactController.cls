/**
 * Surawat Sakulmontreechai : Amend this class regarding Task-1251
*/

public with sharing class tabMVCContactController {
    
    private static final String ACCOUNT_CLINIC_RT = Schema.SObjectType.ACCOUNT.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    
     //Took code from ContactRelatedClinicsController as part of Azure 701
    
    @AuraEnabled(cacheable=true)
    public static List<AccountContactRelation> getRelatedClinicsByContactId(String contactId){
        List<AccountContactRelation> acRelationList = [SELECT Id, AccountId, ContactId, Account.Name, Account.Clinic_Name__c, 
                                                    Preferred_place_for_visit__c, Account.ShippingStreet, 
                                                    Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, 
                                                    Account.ShippingLatitude, Account.ShippingLongitude, Account.ShippingPostalCode, 
                                                    Activity_Phone__c, Preferred_contact_day_time__c,Contact_Role__c    
                                                    FROM AccountContactRelation WHERE ContactId=:contactId 
                                                    AND Account.RecordTypeId=:ACCOUNT_CLINIC_RT AND Account.RecordTypeId != NULL AND IsActive = true];
        return acRelationList;
        
    }
}