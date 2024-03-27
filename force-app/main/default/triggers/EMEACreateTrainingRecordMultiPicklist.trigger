trigger EMEACreateTrainingRecordMultiPicklist on ECP_Training__c (after insert, after update) {
    if(EMEAInstoreTrainingController.isFirstTime){
        EMEAInstoreTrainingController.isFirstTime = false;
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                EMEAInstoreTrainingController.updateRecordDataFromMultiPickList(Trigger.new);
            }else if(Trigger.isUpdate){
                EMEAInstoreTrainingController.updateRecordDataFromMultiPickList(Trigger.new);
            }
        }
    }
}