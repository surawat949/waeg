public with sharing class TabMVAAccountClinicValidation {
    /**
     *  ========================================================================================
     *  @Author : Surawat Sakulmontreechai
     *  @CreatedBy : Surawat Sakulmontreechai
     *  @Email : surawat.sakulmontreechai@hoya.com
     *  @LastModifiedDate : -
     *  @LastModifiedBy : - 
     *  @Description : Using to query for IQVIA Database - Validation related to Clinic Account
     *  @Version : 1.0
     *  @APIVersion : api v.49.0 via force.com 
     *  ========================================================================================
     */

     @AuraEnabled(cacheable=true)
     public static List<QIDC__Validation_Request_ims__c> getValidationNameByAccountId(String recordId){
        
            List<QIDC__Validation_Request_ims__c> qidList = [SELECT Id, Name, QIDC__Request_Type_ims__c, 
                                                                QIDC__Workplace_ims__c, QIDC__Workplace_ims__r.Hoya_Account_ID__c,
                                                                QIDC__Status_ims__c, QIDC__Workplace_ims__r.Name, QIDC__Request_Date_ims__c, 
                                                                CreatedBy.Name FROM QIDC__Validation_Request_ims__c
                                                                WHERE qidc__workplace_ims__c =: recordId ORDER BY CreatedDate DESC LIMIT 5];
            //System.debug('XXX Get Validation '+qidList.size()+' '+qidList);
            return qidList;
       
     }

     @AuraEnabled(cacheable=true)
     public static List<QIDC__Validation_Request_ims__c> getValidationNameByAccountIdAll(String recordId){
        
            List<QIDC__Validation_Request_ims__c> qdList = [SELECT Id, Name FROM QIDC__Validation_Request_ims__c
                                                            WHERE qidc__workplace_ims__c =: recordId];
            //System.debug('XXX Get Validation All '+qdList.size()+'=>'+qdList);
            return qdList;
     }

    @AuraEnabled(cacheable=true)
    public static string getContactOpthalmologistRecTypeId(){
        String ContactOpthalRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
        return ContactOpthalRecId;
    }
     /*
     @AuraEnabled(cacheable=true)
     public static void DeleteValidation(String recordId){
        try {
            List<QIDC__Validation_Request_ims__c> qlList = new List<QIDC__Validation_Request_ims__c>();
            List<QIDC__Validation_Request_ims__c> qList = [SELECT Id FROM QIDC__Validation_Request_ims__c WHERE Id=:recordId];
            for(QIDC__Validation_Request_ims__c q : qList){
                qlList.add(q);
            }
            If(qlList.size()>0){delete qlList;}
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
     }
     */
}