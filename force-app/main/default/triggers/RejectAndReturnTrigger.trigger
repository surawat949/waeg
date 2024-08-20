trigger RejectAndReturnTrigger on  RejectAndReturn_CS__c (before insert, before update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            RejectAndReturnController.doRejectReturnBeforeInsert(Trigger.new);
        }
    }else if(Trigger.isUpdate){
        if(Trigger.isBefore){
            RejectAndReturnController.doRejectReturnBeforeInsert(Trigger.new);
        }
    }
}