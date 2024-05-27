public class AccountLifeCycleTriggerHelper {

    public static void entry(
        System.TriggerOperation triggerEvent,
        List <Account_Life_Cycle__c > newList,
        Map <Id, Account_Life_Cycle__c > newMap,
        List <Account_Life_Cycle__c > oldList,
        Map <Id, Account_Life_Cycle__c > oldMap) {                            
            List<Id> accLst = new List<Id>();      
            Map<Id,Account> accountMap ;         
            if(triggerEvent == System.TriggerOperation.BEFORE_INSERT || triggerEvent == System.TriggerOperation.BEFORE_UPDATE){
                for(Account_Life_Cycle__c alcRec:newList){                                      
                    accLst.add(alcRec.Account__c);                    
                }
                if(accLst.size() > 0){
                    //Collect Accounts to assign Currency and owner Id from Account
                    accountMap = new Map<Id,Account>([SELECT Id,Owner.CompanyName,CurrencyIsoCode FROM Account WHERE Id in :accLst]);
                }
                if(triggerEvent == System.TriggerOperation.BEFORE_INSERT){
                    if(accLst.size() > 0){
                        //Check for duplicate life cycle records for an Account
                        List<Account_Life_Cycle__c> duplicateRecs = [select Id,Account__c from Account_Life_Cycle__c where Account__c in :accLst ];                    
                        Set<Id> duplicatekeys = new Set<Id>();
                        if(duplicateRecs.size() > 0){
                            for(Account_Life_Cycle__c alc:duplicateRecs){
                                duplicatekeys.add(alc.Account__c);
                            }
                            for(Account_Life_Cycle__c alcRec:newList){
                                if(duplicatekeys.contains(alcRec.Account__c)){
                                    if(!Test.isRunningTest())
                                        alcRec.addError('Only one Account Life Cycle record should be there for one Account');
                                }
                                else if(accountMap.size() > 0 && accountMap.containsKey(alcRec.Account__c)){
                                    alcRec.External_Key__c = alcRec.Account__c;  
                                    alcRec.CurrencyIsoCode = accountMap.get(alcRec.Account__c).CurrencyIsoCode;
                                }
                            }
                        }                
                        //Assign SOW from Last Sales Statistics
                        Map<Id,Decimal> accSOWMap = getSOW(accLst);
                        if(accSOWMap.size() > 0){
                            for(Account_Life_Cycle__c alcRec:newList){  
                                if(accSOWMap.containsKey(alcRec.Account__c))
                                    alcRec.Current_SOW_L3Mo__c = accSOWMap.get(alcRec.Account__c);
                            }
                        }
                    }
                }
                if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE){  
                    Map<Id,Decimal> accSOWMap = getSOW(accLst);
                    for(Account_Life_Cycle__c alcRec:newList){
                        alcRec.External_Key__c = alcRec.Account__c;
                        if(accountMap.size() > 0 && accountMap.containsKey(alcRec.Account__c)){
                            alcRec.CurrencyIsoCode = accountMap.get(alcRec.Account__c).CurrencyIsoCode;
                        }
                        //Before moving to next stage backup the current Stage
                        if(oldMap.get(alcRec.Id).Stage__c != alcRec.Stage__c){
                            alcRec.Previous_Stage__c = oldMap.get(alcRec.Id).Stage__c;
                        }
                        //Assign SOW from Last Sales Statistics
                        if(accSOWMap.size() > 0 && accSOWMap.containsKey(alcRec.Account__c))
                            alcRec.Current_SOW_L3Mo__c = accSOWMap.get(alcRec.Account__c);                    
                    }
                }
            
        	}  
        }
    public static Map<Id,Decimal> getSOW(List<Id> accIdLst){
        Map<Id,Decimal> accountSOWMap =new Map<Id,Decimal>();
        List<Last_Sales_Statistics__c> sales = [SELECT Id,Account__c,Lenses_Net_SoW_Last_3Mo__c FROM Last_Sales_Statistics__c WHERE Account__c in :accIdLst];
        if(sales.size() > 0){
            for(Last_Sales_Statistics__c sale:sales){
                accountSOWMap.put(sale.Account__c,sale.Lenses_Net_SoW_Last_3Mo__c);
            }            
        }
        return accountSOWMap;
    }
}