trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert,before update,after insert,after update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            LiveChatTranscriptTriggerHelper.doPopulateContactToAgent(trigger.new);
        }else if(trigger.isUpdate){
            
        }
    }else if(trigger.isAfter){
        if(trigger.isInsert){
            //LiveChatTranscriptTriggerHelper.doAttachExistingCases(trigger.new);
        }else if(trigger.isUpdate){ 
            LiveChatTranscriptTriggerHelper.doUpdateContactDetails(trigger.new);   
        }
    }
}