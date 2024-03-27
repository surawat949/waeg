public class VisitTriggerHelper {
     public static void entry(
        System.TriggerOperation triggerEvent,
        List <Visits__c> newList,
        Map <Id, Visits__c> newMap,
        List <Visits__c> oldList,
        Map <Id, Visits__c> oldMap
    ) {
        List<Account_Life_Cycle__c> alcList = new List<Account_Life_Cycle__c>();
        if(triggerEvent == System.TriggerOperation.BEFORE_INSERT ){
            Set<Id> accountIdsLst = new Set<Id>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){
                    accountIdsLst.add(visit.Account__c);
                }
        	} 
           updateVisitHomeOfficeTracker(newList,accountIdsLst);
        }
        if(triggerEvent == System.TriggerOperation.AFTER_INSERT || triggerEvent == System.TriggerOperation.AFTER_UPDATE){
            Set<Id> accountIdsLst = new Set<Id>();
            Set<Id> considerableAccIdLst = new Set<Id>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){
                  //  System.debug(visit.Account__c+'+++'+visit.Account__r.RecordTypeId);
                    if(triggerEvent == System.TriggerOperation.AFTER_INSERT && visit.Visit_Type__c == 'Visit' && visit.Visit_Status__c != 'Cancelled')
                    	accountIdsLst.add(visit.Account__c);
                    else if(triggerEvent == System.TriggerOperation.AFTER_UPDATE){
                        if(((newMap.get(visit.Id).Visit_Status__c != oldMap.get(visit.Id).Visit_Status__c) && (newMap.get(visit.Id).Visit_Status__c == 'Cancelled' || oldMap.get(visit.Id).Visit_Status__c == 'Cancelled' ))|| ((newMap.get(visit.Id).Visit_Type__c != oldMap.get(visit.Id).Visit_Type__c)&&(newMap.get(visit.Id).Visit_Type__c == 'Visit'||oldMap.get(visit.Id).Visit_Type__c == 'Visit'))||(newMap.get(visit.Id).Start_Time__c != oldMap.get(visit.Id).Start_Time__c)||(newMap.get(visit.Id).Visit_Reason__c != oldMap.get(visit.Id).Visit_Reason__c)){
                            accountIdsLst.add(visit.Account__c);
                        }
                    }
                }        	 
                List<Account> accountList = new List<Account>();
                if(accountIdsLst.size() > 0)
                	accountList = [SELECT Id,RecordTypeId from Account where Id in : accountIdsLst];
                Map<Id,Id> accRecTypeMap = new Map<Id,Id>();
                if(accountList.size() > 0){
                    for(Account acc:accountList){
                        accRecTypeMap.put(acc.Id,acc.RecordTypeId);
                    }
                    for(Visits__c visit : newList){
                        if(accRecTypeMap.containsKey(visit.Account__c)){
                            if(AccountTriggerHelper.isConsiderableRecTypeForALC(accRecTypeMap.get(visit.Account__c))){
                    			considerableAccIdLst.add(visit.Account__c);
                    		}                            
                        }
                    }
                }
            }
            if(considerableAccIdLst.size() > 0){
                Map<Id,Visits__c> latestVisit = AccountTriggerHelper.getLatestVisit(considerableAccIdLst);
                //get the account stage
                Map<Id,String> accountStageMap = new Map<Id,String>();
                System.debug(accountStageMap);
                if(latestVisit.size() > 0){
                    accountStageMap = AccountTriggerHelper.getStage(latestVisit);
                }
                for(Id accId:considerableAccIdLst){
                    if(accountStageMap.size() > 0){                   
                        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        alc.Status_Active__c = true;
                        if(accountStageMap.get(accId) != 'Retain'){
                            alc.Stage__c = accountStageMap.get(accId);
                            alc.Stage_Retained__c = false;
                        }	
                        else                            
                            alc.Stage_Retained__c = true;
                        alc.External_Key__c = accId;
                        alc.Account__c = accId;
                        alc.Latest_Visit__c = latestVisit.get(accId).Id+'-'+latestVisit.get(accId).Name;
                        alcList.add(alc);
                        System.debug(alc);
                    }
           		}
            }
        }       
        if(alcList.size() > 0){
            upsert alcList External_Key__c;
        }
    }
    public static void updateVisitHomeOfficeTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
        List<Visits__c> visitUpdateLst = new List<Visits__c>();
        //collect all the country codes and pass them to the query   
         Map<Id,String> shopCountryMap = new Map<Id,String>();
         Date creationDate = Date.today();
         Datetime dt = (DateTime)creationDate;
         String dayOfWeek = dt.format('EEEE');        
         if(accountIdsLst.size() > 0){
            List<Account> accLst =[select Id,Shop_Country__c from Account where Id in :accountIdsLst];
            if(accLst.size() > 0){
                for(Account acc:accLst){
                    shopCountryMap.put(acc.Id,acc.Shop_Country__c);
                }               
            } 
         }
        Map<String,String> homeOfficeDayMap = new Map<String,String>();
        Map<String, Entity_detail__mdt> allMetadadata = Entity_detail__mdt.getAll();
        for (Entity_detail__mdt entity : allMetadadata.values()) {
            homeOfficeDayMap.put(entity.Country_Code__c,entity.ASM_Home_Office_Day__c);
        }            
        //Compare the creationday of visit with home office day
        if(shopCountryMap.size() > 0){
            for(Visits__c visit:newList){
                String shopCountry = shopCountryMap.get(visit.Account__c);
                if(shopCountry != null && homeOfficeDayMap.size() > 0  && homeOfficeDayMap.containsKey(shopCountry)){
                    if(homeOfficeDayMap.get(shopCountry) == 'No Instrution' || homeOfficeDayMap.get(shopCountry) == null){
                        visit.Visit_Home_Office_Tracker__c = 'Free Organization';
                    }
                    else if(dayOfWeek == homeOfficeDayMap.get(shopCountry)){                        
                        visit.Visit_Home_Office_Tracker__c = 'Home Office Day';
                    }
                    else{
                        visit.Visit_Home_Office_Tracker__c = 'Other Days';
                    }
                }
                else{//If Shop country is not there in Meta Data
                    visit.Visit_Home_Office_Tracker__c = 'Free Organization';
                }
            }
        }
    }
}