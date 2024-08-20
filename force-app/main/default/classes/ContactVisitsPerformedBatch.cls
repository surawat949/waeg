/*****************************************************************************************************
* Name            :  ContactVisitsPerformedBatch
* Description     :  Batch Class to be used to update the total Direct and Contact Visits performed by the user
                     System.schedule('Visits Contacts Sync Schedule Job', cronexpression, new ContactVisitsPerformedBatch());
* Usage           :  ContactVisitsPerformedBatch                                                          
* Created By      :  Encora                                                     
*****************************************************************************************************/

public class ContactVisitsPerformedBatch implements Database.Batchable<SObject>, Schedulable { 
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    /*
* This batch class updates Contact.Contact_Visits_performed__c field 
* based on Number of visits done for Contact in 365 days
*/
    public ContactVisitsPerformedBatch() {}
    
    public void execute(SchedulableContext ctx) {
        ContactVisitsPerformedBatch thisBatch = new ContactVisitsPerformedBatch();
        Database.executeBatch(thisBatch);
    }
    
    public Database.QueryLocator start(Database.BatchableContext context){ 
        return Database.getQueryLocator([SELECT Id, Contact_Visits_Performed__c FROM Contact]);
    }
    public void execute(Database.BatchableContext context, List<Contact> lstContacts) {
        try {
            List<Visits__c> lstVisits = [Select Id, Contact__c,visit_Type__c,Visitfreqchk_c__c,visit_status__c,Start_day__c From Visits__c Where Contact__c IN :lstContacts AND visit_status__c = 'Complete' AND Visitfreqchk_c__c = '1' AND (visit_Type__c = 'Visit' OR visit_Type__c='Digital Visit') order by Start_day__c DESC ];
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
                
                if (conToDigitalVistsMap.get(eachVisit.contact__c) == null && eachVisit.visit_Type__c=='Digital Visit') {
                    List<Visits__c> tempList = new List<Visits__c>();
                    tempList.add(eachVisit);
                    conToDigitalVistsMap.put(eachVisit.contact__c, tempList);
                } else if(eachVisit.visit_Type__c=='Digital Visit') {
                    List<Visits__c> tempList = conToDigitalVistsMap.get(eachVisit.contact__c);
                    tempList.add(eachVisit);
                    conToDigitalVistsMap.put(eachVisit.contact__c, tempList);
                }
            }
            List<Contact> updateList = new List<Contact>();
            for (Contact eachCon : lstContacts) {
                if (conToVistsMap.get(eachCon.Id) != null ) {
                    eachCon.Contact_Visits_Performed__c = conToVistsMap.get(eachCon.Id).size();
                    eachCon.Last_contact_visit_date__c  =  conToVistsMap.get(eachCon.Id)[0].Start_day__c;
                    
                } else {
                    eachCon.Contact_Visits_Performed__c = 0;
                }
                
                if(conToDigitalVistsMap.get(eachCon.Id)!=null){
                    eachCon.Contact_Digital_Visits_Performed__c = conToDigitalVistsMap.get(eachCon.Id).size();
                    eachCon.Last_Digital_Visit_Date__c = conToDigitalVistsMap.get(eachCon.Id)[0].Start_day__c;
                }
                else {
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