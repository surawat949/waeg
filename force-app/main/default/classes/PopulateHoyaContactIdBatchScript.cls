global class PopulateHoyaContactIdBatchScript implements Database.Batchable<SObject>, Database.Stateful {
    global PopulateHoyaContactIdBatchScript() {

    }

    global Database.QueryLocator start(Database.BatchableContext context){ 
        String brand = 'SEIKO';
            String query = 'Select id, name, Firstname, Lastname, AccountId, Hoya_contact_id__c from Contact where Hoya_contact_id__c = null AND Account.Brand__c =: brand';
            System.debug('+++query' + query);
            return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, List<Contact> lstContacts){
        for (Contact eachCon : lstContacts) {
            eachCon.Hoya_contact_id__c = eachCon.Firstname + eachCon.Lastname + eachCon.AccountId;
        }
        update lstContacts;
    }

    global void finish(Database.BatchableContext context){   
        
    }
}