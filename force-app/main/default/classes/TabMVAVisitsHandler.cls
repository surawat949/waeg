public class TabMVAVisitsHandler {
    
  @AuraEnabled(cacheable=true)
  public static List<Visits__c> getVisitsBasedOnContacts(String accountId){
      List<Visits__c> visits=[Select Id,Name,Contact__c,Contact__r.Name,Visit_Type__c,Visit_Reason__c,Visit_completed_date__c from visits__c where Contact__c IN ( select id from Contact where AccountId=:accountId) order by Contact__r.Name];
      System.debug('ContactVisits-->'+visits);
      return visits;
 }   
   
   @AuraEnabled(cacheable=true)
   public static List<Contact> getVisitFrequency(String accountId){
        List<Contact> Contacts=[Select Id,Name,Last_contact_visit_date__c,Contact_Direct_Visits_Frequency__c,Total_Visit_Achieved__c,Contact_Digital_Visits_Frequency__c  from Contact Where AccountId=:accountId];
        System.debug('Contacts-->'+Contacts);
        return Contacts;    
   }

}