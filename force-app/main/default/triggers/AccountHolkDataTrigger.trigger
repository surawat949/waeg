trigger AccountHolkDataTrigger on Account (before insert, before update) {
    if(Trigger.isInsert && Trigger.isBefore && Trigger.new[0].Hoya_Account_ID__c!=null && Trigger.new[0].Hoya_Account_ID__c.startsWith('SK')){
        
        List<HOLK_account_data__c> insertList = new List<HOLK_account_data__c>();
        for(Account a : Trigger.New) {
            if(a.hoya_account_id__c.startsWith('SK')){
                HOLK_account_data__c holk = new HOLK_account_data__c();
                holk.ownerid = a.ownerid;
                holk.currencyisocode=a.currencyisocode;
                holk.name = a.name;
                holk.hoya_account_id__c = a.hoya_account_id__c;
                insertList.add(holk); 
            }
        }
        insert insertList;
        for(Integer i = 0; i < Trigger.New.size(); i++) {
            trigger.new[i].HOLK_account_data__c = insertList.get(i).id;
        }
    } else if (Trigger.isUpdate){
        if(UserInfo.getLastName()!='Integration user' && Trigger.size==1 && Trigger.new[0].Hoya_Account_ID__c!=null && Trigger.new[0].Hoya_Account_ID__c.startsWith('SK')){
            Map<String, Account> linkAccountDataMap = new Map<String, Account>();
            if(trigger.isBefore){
                for(Account a: Trigger.new){
                    if(a.HOLK_account_data__c==null){
                        system.debug('3.1:AccountHolkDataTrigger - Adding account ' + a.Hoya_Account_ID__c);
                        linkAccountDataMap.put(a.id, a);
                    } else {
                        HOLK_account_data__c aadToUpdate = [select id from HOLK_account_data__c where id=:a.HOLK_account_data__c];
                        aadToUpdate.Hoya_account_id__c = a.hoya_account_id__c;
                        update aadToUpdate;
                    }
                }
    
                List<HOLK_account_data__c> insertList = new List<HOLK_account_data__c>();
                HOLK_account_data__c aad = new HOLK_account_data__c();
                for(String key : linkAccountDataMap.keySet()){
                    Account curAcc = linkAccountDataMap.get(key);
                    system.debug('3.2:AccountHolkDataTrigger - create aad for ' + curAcc.Hoya_Account_ID__c);
                    
                    if(curAcc.hoya_account_id__c !=null && curAcc.hoya_account_id__c !=''){
                        aad.ownerid = curAcc.ownerid;
                        aad.currencyisocode=curAcc.currencyisocode;
                        aad.name = curAcc.name;
                        aad.hoya_account_id__c = curAcc.hoya_account_id__c;
                        //save it
                        insertList.add(aad);
                    }
                }
                system.debug('3.3:AccountHolkDataTrigger - insertList.size= ' + insertList.size());
                if(insertList.size()>0){
                    insert insertList;
                }
                for(HOLK_account_data__c newAad: insertList){
                    Trigger.new[0].HOLK_account_data__c = newAad.id;
                }
            }
        }
    }
}