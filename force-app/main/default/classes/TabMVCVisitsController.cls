public with sharing class TabMVCVisitsController {
      //get In Store Training and Webinars related list
    @AuraEnabled(cacheable=true)
    public static List<ECP_Training__c> getInStoreTrainingRelatedList(Id contactId){       
        List<ECP_Training_Member__c> trainingMembersLst=[select Training__c from ECP_Training_Member__c where contact__c=:contactId];
        List<Id> TrainingIdLst=new List<Id>();
        if(trainingMembersLst.size() > 0){
            for(ECP_Training_Member__c member:trainingMembersLst){
                TrainingIdLst.add(member.Training__c);
            }
        }
        List<ECP_Training__c> TrainingLst=[select Id,Name,Training__c,start__c,Assigned_to__c,Training_status__c,Assigned_to__r.Name from ECP_Training__c where Id in :TrainingIdLst Order by start__c desc];
        return TrainingLst;      
    }
    
     //method to get the Contact last visit completed details - AZURE 755
    @AuraEnabled
    public static Visits__c getContactLastVisitCompleted(Id contactId){
         List<Visits__c>  visit=[SELECT id,Name, Visit_Type__c, Assigned_to__c,Start_Day__c,Assigned_to__r.Name,Visit_Reason__c, Start_Date_Time__c, End_Date_Time__c, HVNA_Visit_Objective__c,Contact__c,
                           Contact__r.Name,Contact__r.FirstName, Contact__r.LastName,Visit_Notes__c, Call_To_Action_Notes__c  from Visits__c
                           WHERE  Visit_Status__c ='Complete' AND Contact__c=:contactId ORDER BY End_Date_Time__c DESC LIMIT 1]; 
        
        return visit.size()> 0 ? visit[0]:null;
   }
    
     //method to get the Contact last visit completed details - AZURE 756
    @AuraEnabled
    public static Visits__c getNextVisitPlanned(Id contactId){
         List<Visits__c>  visit=[SELECT id,Name, Visit_Type__c, Assigned_to__c,Start_Day__c,Assigned_to__r.Name,Visit_Reason__c, Start_Date_Time__c, End_Date_Time__c, HVNA_Visit_Objective__c,Contact__c,
                           Contact__r.Name,Contact__r.FirstName, Contact__r.LastName,Visit_Notes__c, Call_To_Action_Notes__c  from Visits__c
                           WHERE  Visit_Status__c ='Planned' AND Visit_Type__c in ('Visit','Digital Visit') AND  Contact__c=:contactId AND Start_Day__c >= Today ORDER BY Start_Day__c  LIMIT 1]; 
         
        return visit.size()> 0 ? visit[0]:null;
   }

    //method to get the visits
    @AuraEnabled
    public static List<Visits__c> getVisits(Id contactId){
        List<Visits__c>  visits=[SELECT id,Name, Visit_Type__c,Start_Day__c,Visit_Status__c,Duration_Minutes__c, Assigned_to__c,Visit_Reason__c,Assigned_to__r.Name, Start_Date_Time__c, End_Date_Time__c, HVNA_Visit_Objective__c,Contact__c,
                           Contact__r.Name,Contact__r.FirstName, Contact__r.LastName,Visit_Notes__c, Call_To_Action_Notes__c  from Visits__c
                           WHERE Contact__c=:contactId order by Start_Day__c DESC ]; 
         return visits;
					  
   }
   
    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisitCompleted(String contactId){
        List<Visits__c> visits=[select Id,Name,Visit_Notes__c,Visit_completed_date__c, Call_To_Action_Notes__c, Contact__c,Start_Day__c, Visit_assigned_to__c, HVNA_Visit_Objective__c,
                                Visit_Type__c, Visit_Reason__c from Visits__c where Contact__c=:contactId AND Visit_Status__c ='Complete' Order By Start_Day__c Desc limit 3];
        return visits;
    } 
    
    
}