trigger UpdateAccountAndContact on tdc_tsw__Message__c (before insert,after insert) {
    if(trigger.isBefore){
        Set<String> senderNumbers = new Set<String>();
        Map<String, Id> existingAccounts = new Map<String, Id>();
    
        for (tdc_tsw__Message__c message : Trigger.new) {
            senderNumbers.add(message.tdc_tsw__Sender_Number__c);
        }
    
        for (Account acc : [SELECT Id, Phone FROM Account WHERE Phone IN :senderNumbers]) {
            existingAccounts.put(acc.Phone, acc.Id);
        }
    
        List<Account> accountsToInsert = new List<Account>();
    
        for (tdc_tsw__Message__c message : Trigger.new) {
            String senderNumber = message.tdc_tsw__Sender_Number__c;
            if (!existingAccounts.containsKey(senderNumber)) {
                accountsToInsert.add(new Account(Name = 'Account for ' + senderNumber, Phone = senderNumber));
            }
        }
        if(!accountsToInsert.isEmpty()){
            insert accountsToInsert;
            for (Account acc : accountsToInsert) {
                existingAccounts.put(acc.Phone, acc.Id);
            }
        }
    
        for (tdc_tsw__Message__c message : Trigger.new) {
            message.tdc_tsw__Account__c = existingAccounts.get(message.tdc_tsw__Sender_Number__c);
            
        }
    }else if(Trigger.isAfter){
        Map<String,tdc_tsw__Message__c> mapOfCaseAccountIds = new Map<String,tdc_tsw__Message__c>();
        for (tdc_tsw__Message__c message : Trigger.new) {
           if(String.isNotBlank(message.tdc_tsw__Related_Object__c) && message.tdc_tsw__Related_Object__c == 'Case'){
                mapOfCaseAccountIds.put(message.tdc_tsw__Related_Object_Id__c,message);
            }
        }
        List<Case> caseToUpdate = new List<Case>();
        for(Case caseRec : [Select Id,AccountId,RecordTypeId,serviceFlow_Contact_Number__c From Case Where Id IN : mapOfCaseAccountIds.keySet()]){
            if(mapOfCaseAccountIds.containsKey(caseRec.Id)){
                caseRec.AccountId = mapOfCaseAccountIds.get(caseRec.Id).tdc_tsw__Account__c;
                caseRec.serviceFlow_Contact_Number__c = mapOfCaseAccountIds.get(caseRec.Id).tdc_tsw__Sender_Number__c;
                caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('serviceFlow_Chat').getRecordTypeId();
                caseToUpdate.add(caseRec);
            }
        }
        if(!caseToUpdate.isEmpty()){
            update caseToUpdate;
        }
    }
}