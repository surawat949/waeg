// Trigger deactivated. All the stuff is either removed or migrated to VisitTriggerHelper.
trigger visit_AIU_createVisitTask on Visits__c (after insert, after update) {

    Set<Id> conIdSet = new Set<Id>();

    if(trigger.isAfter) {
        list<Visits__c> newVisits;
        List<Visits__c> newVisitsAPAC ;
        //create new VisitTask after create Visit
        if(trigger.isInsert){
            newVisits = trigger.new;
        }
        else if(trigger.isUpdate){
            newVisits = new list<Visits__c>(); 
        }
        
    }

    

    //************************* END After Trigger *************************************************
}