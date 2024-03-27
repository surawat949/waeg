public with sharing class SeikoSalesDataTriggerHelper {
    
	public static void entry(
		System.TriggerOperation triggerEvent,
		List <Seiko_data__c> newList,
		Map <Id, Seiko_data__c> newMap,
		List <Seiko_data__c> oldList,
		Map <Id, Seiko_data__c> oldMap
	) {
        System.debug('call trigger SeikoSalesDataTriggerHelper ' + triggerEvent);
        switch on triggerEvent {
            when AFTER_UPDATE {
                //field use to call WS: SVS_Digital_communication_platform__c
                //List<Seiko_data__c> skList = new List<Seiko_data__c>();
                for(Seiko_data__c sk : newList){
                    Seiko_data__c old = oldMap.get(sk.Id);
                    Boolean oldValue = old.SVS_Digital_communication_platform__c;
                    String oldRadius = old.SVS_Digital_com_Platform_radius__c;
                    System.debug('XXX Account Id=' + sk.Account__c + ', old=' + oldValue + ', new=' + sk.SVS_Digital_communication_platform__c);
                    if(oldValue!=sk.SVS_Digital_communication_platform__c 
                        || (sk.SVS_Digital_com_Platform_radius__c!=oldRadius && sk.SVS_Digital_communication_platform__c==true))
                        {
                        //skList.add(sk);
                        try{
                            System.debug('XXXX calling activateAccount' );
                            //ExternalWSCall.activateAccount(sk.Account__c, sk.id);
                            System.debug('XXXX after activateAccount' );
                            if(ExternalWSToken.error!=null){
                                System.debug('XXXX ExternaWSToken error = ' + ExternalWSToken.error);
                                sk.addError(ExternalWSToken.error);
                                sk.SVS_Digital_communication_platform__c = oldValue;
                                sk.WS_error__c = ExternalWSToken.error;
                            } else {
                                  System.debug('XXXX NO ERROR' );
                            }
                        }catch(IllegalArgumentException e){
                            System.debug('XXX TRIGGER ERROR :'+e.getMessage());
                            sk.addError(e.getMessage());
                            sk.SVS_Digital_communication_platform__c = oldValue;
                            sk.WS_error__c = e.getMessage();
                            continue;
                        }

                    }
                    //System.debug('XXX size = ' + accountIds.size());
                }
                //if(accountIds.size()>0){
                //    ExternalWSCall.updateAccountList(accountIds);
                //}
            }
        }
    }
}