/**
 *  This trigger is used to calculation account classification
 *
 @author    Yuanyuan Zhang
 @created   2013-05-07
 @version   1.0
 @since     26.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-05-07 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 */
trigger Account_BU_calculationClassification on Account (before update) {
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
    
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
    
    //************************* BEGIN Before Trigger **********************************************
    set<String> set_accCountry = new set<String>();
    //list<Account> list_updateAccount = new list<Account>();
    for(Account acc : trigger.new){//get all valid country to query related account segmentations
        if((acc.BillingCountry != null 
            || acc.ShippingCountry != null
            || acc.Shop_Country__c != null)
            && acc.Turnover_Amount__c != null 
            && acc.Share_of_Wallet__c != null 
            && (acc.Turnover_Amount__c != trigger.oldMap.get(acc.Id).Turnover_Amount__c
            || acc.Share_of_Wallet__c != trigger.oldMap.get(acc.Id).Share_of_Wallet__c)){
            //list_updateAccount.add(acc);
            String coun = acc.BillingCountry;
            if(acc.BillingCountry == null){
                coun = acc.ShippingCountry != null?acc.ShippingCountry:acc.Shop_Country__c;
            }
            if(!set_accCountry.contains(coun)){
                set_accCountry.add(coun);
            }
        }
        else if(acc.BillingCountry == null
            && acc.ShippingCountry == null
            && acc.Shop_Country__c == null){
            acc.Proposed_Classification__c = 'n.a';
        }
    }
    
    if(!set_accCountry.isEmpty()){//get account segmentation
        map<String, Account_Segmentation__c> map_country_accSeg = new map<String, Account_Segmentation__c>();
        for(Account_Segmentation__c aseg : [SELECT Country__c, CurrencyIsoCode, Id, SoW_Threshold_High__c, SoW_Threshold_Low__c, Turnover_Threshold_High__c, Turnover_Threshold_Low__c 
                                            FROM Account_Segmentation__c 
                                            WHERE Country__c IN :set_accCountry]){
            if(!map_country_accSeg.containsKey(aseg.Country__c)){
                map_country_accSeg.put(aseg.Country__c, aseg);
            }
        }
        if(!map_country_accSeg.isEmpty()){
            for(Account acc : trigger.new){
                if(acc.BillingCountry != null || acc.Shop_Country__c != null || acc.ShippingCountry != null){
                    if(acc.Turnover_Amount__c != null && acc.Share_of_Wallet__c != null){
                        if(acc.Turnover_Amount__c != trigger.oldMap.get(acc.Id).Turnover_Amount__c || acc.Share_of_Wallet__c != trigger.oldMap.get(acc.Id).Share_of_Wallet__c){
                            String coun = acc.BillingCountry;
                            if(acc.BillingCountry == null){
                                coun = acc.ShippingCountry != null?acc.ShippingCountry:acc.Shop_Country__c;
                            }
                            if(map_country_accSeg.containsKey(coun)){
                                Account_Segmentation__c aseg = map_country_accSeg.get(coun);
                                if(acc.Turnover_Amount__c  <= aseg.Turnover_Threshold_Low__c){
                                    if(acc.Share_of_Wallet__c <= aseg.SoW_Threshold_Low__c){
                                        acc.Proposed_Classification__c = '1';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_Low__c && acc.Share_of_Wallet__c <= aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '2';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '3';
                                        continue;
                                    }
                                }
                                else if(acc.Turnover_Amount__c  > aseg.Turnover_Threshold_Low__c && acc.Turnover_Amount__c  <= aseg.Turnover_Threshold_High__c){
                                    if(acc.Share_of_Wallet__c <= aseg.SoW_Threshold_Low__c){
                                        acc.Proposed_Classification__c = '4';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_Low__c && acc.Share_of_Wallet__c <= aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '5';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '6';
                                        continue;
                                    }
                                }
                                else if(acc.Turnover_Amount__c  > aseg.Turnover_Threshold_High__c){
                                    if(acc.Share_of_Wallet__c <= aseg.SoW_Threshold_Low__c){
                                        acc.Proposed_Classification__c = '7';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_Low__c && acc.Share_of_Wallet__c <= aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '8';
                                        continue;
                                    }
                                    else if(acc.Share_of_Wallet__c > aseg.SoW_Threshold_High__c){
                                        acc.Proposed_Classification__c = '9';
                                        continue;
                                    }
                                }
                            }
                            else{
                                acc.Proposed_Classification__c = '0';
                            }
                        }
                    }
                    else{
                        acc.Proposed_Classification__c = '0';
                    }
                }
                else{
                    acc.Proposed_Classification__c = 'n.a';
                }
            }
        }
    }
    
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    
    //************************* END After Trigger *************************************************
}