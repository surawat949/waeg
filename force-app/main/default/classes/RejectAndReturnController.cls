public with sharing class RejectAndReturnController {
    public RejectAndReturnController() {

    }
    public static void doRejectReturnBeforeInsert(List<RejectAndReturn_CS__c> newList){
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        Integer counter = [select count() from RejectAndReturn_CS__c]+1;
        String text1 = 'CS-'+String.valueof(year).substring(2)+String.valueof(month).leftPad(2, '0')+String.valueof(counter).leftPad(4, '0');
        System.debug('Counter number is '+text1);
        
        for(RejectAndReturn_CS__c r : newList){
            if(r.S_Form_Submission__c==false){
                r.Name = text1;
                r.Sequence_Number__c = text1;
            }else if(r.S_Form_Submission__c==true && r.S_Form_Reference_Number__c!=null){
                r.Name = r.S_Form_Reference_Number__c;
                r.Sequence_Number__c = r.S_Form_Reference_Number__c;
            }
            /*
            else if(r.S_Form_Reference_Number__c!=null || r.S_Form_Reference_Number__c!=''){
                r.S_Form_Submission__c = true;
                r.Name = r.S_Form_Reference_Number__c;
                r.Sequence_Number__c = r.S_Form_Reference_Number__c;
            }
            */
            else{
                r.Name = text1;
                r.Sequence_Number__c = text1;
            }
        }   
    }
}