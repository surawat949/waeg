public class BatchToUpdateAccountChannel implements Database.Batchable<SObject>, Schedulable{
    
    /*
    * This batch class updates Account.Channel__c field 
    * based on the User.Channel__c
    */

    public void execute(SchedulableContext ctx) {
        BatchToUpdateAccountChannel thisBatch = new BatchToUpdateAccountChannel();
        Database.executeBatch(thisBatch);
    }

    public Database.QueryLocator start(Database.BatchableContext context){ 
        return Database.getQueryLocator([SELECT Id, Channel__c,OwnerId FROM Account]);
    }
    public void execute(Database.BatchableContext context, List<Contact> lstContacts) {
        try {
            List<Visits__c> lstVisits = [Select Id, Contact__c,visit_Type__c,Visitfreqchk_c__c,visit_status__c From Visits__c Where Contact__c IN :lstContacts AND visit_status__c = 'Complete' AND Visitfreqchk_c__c = '1' AND (visit_Type__c = 'Visit' OR visit_Type__c='Call')];
            System.debug('lstVisits'+lstVisits);
            Map<Id, List<Visits__c>> conToVistsMap = new  Map<Id, List<Visits__c>>();
            Map<Id, List<Visits__c>> conToDigitalVistsMap = new  Map<Id, List<Visits__c>>();
            for (Visits__c eachVisit : lstVisits) {
                      
                if (conToVistsMap.get(eachVisit.contact__c) == null && eachVisit.visit_Type__c=='Visit') {
                    List<Visits__c> tempList = new List<Visits__c>();
                    tempList.add(eachVisit);
                    conToVistsMap.put(eachVisit.contact__c, tempList);
                } else if(eachVisit.visit_Type__c=='Visit') {
                    List<Visits__c> tempList = conToVistsMap.get(eachVisit.contact__c);
                    tempList.add(eachVisit);
                    conToVistsMap.put(eachVisit.contact__c, tempList);
                }
                
                if (conToDigitalVistsMap.get(eachVisit.contact__c) == null && eachVisit.visit_Type__c=='Call') {
                    List<Visits__c> tempList = new List<Visits__c>();
                    tempList.add(eachVisit);
                    conToDigitalVistsMap.put(eachVisit.contact__c, tempList);
                } else if(eachVisit.visit_Type__c=='Call') {
                    List<Visits__c> tempList = conToDigitalVistsMap.get(eachVisit.contact__c);
                    tempList.add(eachVisit);
                    conToDigitalVistsMap.put(eachVisit.contact__c, tempList);
                }
            }
            List<Contact> updateList = new List<Contact>();
            for (Contact eachCon : lstContacts) {
                if (conToVistsMap.get(eachCon.Id) != null ) {
                    eachCon.Contact_Visits_Performed__c = conToVistsMap.get(eachCon.Id).size();
                    eachCon.Contact_Digital_Visits_Performed__c = conToDigitalVistsMap.get(eachCon.Id).size();
                } else {
                    eachCon.Contact_Visits_Performed__c = 0;
                    eachCon.Contact_Digital_Visits_Performed__c =0;
                }
                updateList.add(eachCon);
            }
            if (!updateList.isEmpty()) {
                update updateList;
            }
        } catch (Exception ex) {
            LogException.log(ex);
        }
    }

    public void finish(Database.BatchableContext context){ }


}