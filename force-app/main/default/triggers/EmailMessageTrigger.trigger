trigger EmailMessageTrigger on EmailMessage (after insert) {    
    if(Trigger.isAfter && Trigger.isInsert){
        serviceFlow_EmailMessageTriggerHandler.updateCaseDetails(trigger.new);
    }
}