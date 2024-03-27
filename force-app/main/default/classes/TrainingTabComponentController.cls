public with sharing class TrainingTabComponentController {
   
    @AuraEnabled
    public static List<Contact> getAttendeeList(Id trainingId){
        try {
            List<ECP_Training_Member__c> memberList = [select contact__c, name, training__c from ECP_Training_Member__c where training__c=:trainingId];
            ECP_Training__c t = [select Account__c from ECP_Training__c where id=:trainingId];
            List<Id> contactIdList = new List<Id>();
            for(ECP_Training_Member__c member : memberList){
                contactIdList.add(member.contact__c);
            }
            List<Contact> contactList = [select id, Name, firstname, lastname, recordType.Name, email, salutation from contact where AccountId=:t.Account__c and id in :contactIdList];
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Contact> getContactList(Id trainingId){
        try {
            ECP_Training__c t = [select Account__c from ECP_Training__c where id=:trainingId];
            List<ECP_Training_Member__c> memberList = [select contact__c, name, training__c from ECP_Training_Member__c where training__c=:trainingId];
            List<Id> attendeeIdList = new List<Id>();
            for(ECP_Training_Member__c member : memberList){
                attendeeIdList.add(member.contact__c);
            }
            List<Contact> contactList = new List<Contact>();
            for(Contact c : [select id, Name, firstname, lastname, recordType.Name, email, salutation from contact where AccountId=:t.Account__c and ECP_Training__c=null]){
                if(!attendeeIdList.contains(c.Id)){
                    contactList.add(c);
                }
            }

            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteRelationShip(Id contactId, Id trainingId){
        try {
            System.debug('XXX call deleteRelationShip(' + contactId + ', ' + trainingId + ')');
            //List<Contact> cList =[select id, ECP_Training__c from contact where id=:contactId];
            ECP_Training_Member__c member = [select id from ECP_Training_Member__c where contact__c=:contactId and training__c=:trainingId];
            if(member!=null){
                System.debug('XXX delete  ECP_Training_Member__c ' + member.Id);
                delete member;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addRelationShip(Id contactId, Id trainingId){
        try {
            ECP_Training_Member__c member = new ECP_Training_Member__c();
            member.training__c = trainingId;
            member.contact__c = contactId;
            insert member;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}