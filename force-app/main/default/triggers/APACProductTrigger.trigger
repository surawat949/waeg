trigger APACProductTrigger on APAC_Product__c (before insert, before update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            APACCreateNewProductFormController.doAPACProductBeforeInsert(Trigger.new);
        }
    }
}