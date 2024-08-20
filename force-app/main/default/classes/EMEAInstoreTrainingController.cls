public with sharing class EMEAInstoreTrainingController {
    public EMEAInstoreTrainingController() {

    }

    public static Boolean isFirstTime = true;

    public static void CreateRecordDataFromMultipicklist(List<ECP_Training__c> newList){
       Set<Id> accIds = new Set<Id>();
       Set<String> TrainingPickList = new Set<String>();
       List<ECP_Training__c> training = new List<ECP_Training__c>();

        for(ECP_Training__c e: newList){

            if(e.Training__c != null){TrainingPickList.addAll(e.Training__c.split(';'));}
            accIds.add(e.Account__c);
        }
        System.debug('Account Id is '+accIds);
        System.debug('Training values are '+TrainingPickList);

        for(String s : TrainingPickList){
            for(ECP_Training__c e : newList){
                if(e.Training__c!=null){
                    ECP_Training__c TrainingList = new ECP_Training__c();
                    String[] tmpString = e.Training__c.split(';');

                    TrainingList.Account__c = e.Account__c;
                    TrainingList.Training_status__c = e.Training_status__c;
                    TrainingList.start__c = e.start__c;
                    TrainingList.end__c = e.end__c;
                    TrainingList.Training__c = s;
                    //TrainingList.Training__c = tmpString;
                    TrainingList.Type__c = e.Type__c;

                    training.add(TrainingList);

                }

            }
        }
        if(training.size()>0){insert training;}
    }

    public static void updateRecordDataFromMultiPickList(List<ECP_Training__c> newList){
        Set<Id> addIds = new Set<Id>();
        Set<String> picklistArr = new Set<String>();
        for(ECP_Training__c e : newList){
            if(e.Training__c!=null){picklistArr.addAll(e.Training__c.split(';'));}
            addIds.add(e.Account__c);
        }
        List<Seiko_Data__c> seikoList = [SELECT Id, LastModifiedDate, Account__c, SEIKO_Products_1rst_training_date__c,
                                            SVS_Store_locator_activation__c, Seiko_track_trace_email_activation__c,
                                            Seiko_Vision_Academy_last_training__c, SEIKO_Vision_Xperience_column_training__c,
                                            SEIKO_Vision_Xperience_iPAD_training__c, SEIKO_Xtranet_training__c, 
                                            SVS_Purchase_Registration_activation__c, Loyalty_Program_Emails_Activation__c, 
                                            SVS_Digital_com_platform_activation__c, SVS_Marketing_campaigns_activation__c,
                                            SVS_Sample_boxes_setting_up__c, Starting_kit_setting_up__c, SVS_Communication_kit_setting_up__c
                                            FROM Seiko_Data__c WHERE Account__c IN:addIds];
        List<Seiko_Data__c> updateseikoList = new List<Seiko_Data__c>();
        for(ECP_Training__c e : newList){
            for(Seiko_Data__c seiko : seikoList){
                if(e.Account__c == seiko.Account__c){
                    for(String s : picklistArr){
                        if(s == 'SEIKO Product Range'){
                            seiko.SEIKO_Products_1rst_training_date__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko Products 1st Training Date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Store locator'){
                            seiko.SVS_Store_locator_activation__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            system.debug('SVS Store Locator Activation Date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Track & Trace'){
                            seiko.Seiko_track_trace_email_activation__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko track and trace email activation date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Vision Academy'){
                            seiko.Seiko_Vision_Academy_last_training__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko Vision Academy Last Training Date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Vision Xperience eColonne'){
                            seiko.SEIKO_Vision_Xperience_column_training__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko vision Xperience column last training date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Vision Xperience iPad'){
                            seiko.SEIKO_Vision_Xperience_iPAD_training__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko vision Xperience iPad last training date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO Xtranet'){
                            seiko.SEIKO_Xtranet_training__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Seiko Xtranet last training date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if (s == 'SVS Purchase registration'){
                            seiko.SVS_Purchase_Registration_activation__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('SVS Purchase registration last date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SVS Loyalty Program Emails'){
                            seiko.Loyalty_Program_Emails_Activation__c = true;
                            System.debug('Loyalty program email activation is TRUE');
                        }else if(s == 'SVS Social Media Plateform'){
                            seiko.SVS_Digital_com_platform_activation__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('SVS digial platform activation date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SVS National campaigns'){
                            seiko.SVS_Marketing_campaigns_activation__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('SVS Marketing Campaign activation date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SEIKO samples'){
                            seiko.SVS_Sample_boxes_setting_up__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('SVS Sample boxes setting up date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SVS Essential kit'){
                            seiko.Starting_kit_setting_up__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('Starting kit setting up date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else if(s == 'SVS Magnetic totem'){
                            seiko.SVS_Communication_kit_setting_up__c = date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day());
                            System.debug('SVS Communication kit setting up date is '+date.newInstance(e.LastModifiedDate.year(), e.LastModifiedDate.month(), e.LastModifiedDate.day()));
                        }else{
                            //return nothing;
                        }
                    }
                    updateseikoList.add(seiko);
                }
            }
        }
        update updateseikoList;
    }
}