public class VisitTriggerHelper {
     public static void entry(
        System.TriggerOperation triggerEvent,
        List <Visits__c> newList,
        Map <Id, Visits__c> newMap,
        List <Visits__c> oldList,
        Map <Id, Visits__c> oldMap
    ) {
        List<Account_Life_Cycle__c> alcList = new List<Account_Life_Cycle__c>();
        if(triggerEvent == System.TriggerOperation.BEFORE_INSERT || triggerEvent == System.TriggerOperation.BEFORE_UPDATE){
            Set<Id> accountIdsLst = new Set<Id>();
            Set<Id> visitAssignedUserLst = new Set<Id>();
            Set<Id> completedVisitAccLst = new Set<Id>();
            List<Visits__c> completedVisitList = new List<Visits__c>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){                    
                    if(triggerEvent == System.TriggerOperation.BEFORE_INSERT ){
                        if(visit.Visit_Status__c == 'Complete'){
                             completedVisitAccLst.add(visit.Account__c);
                             completedVisitList.add(visit);
                        }
                        accountIdsLst.add(visit.Account__c);  
                        //Collect Assigned to user Ids
                        visitAssignedUserLst.add(visit.Assigned_to__c);
                    }
                    else if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE){ 
                        if(oldMap.get(visit.Id).Visit_Status__c != 'Complete' && newMap.get(visit.Id).Visit_Status__c == 'Complete'){
                            completedVisitAccLst.add(visit.Account__c);
                            completedVisitList.add(visit);
                        }
                        //if Visit Type is changed or Assigned To Person is changed
                        if(oldMap.get(visit.Id).Visit_Type__c != newMap.get(visit.Id).Visit_Type__c || oldMap.get(visit.Id).Assigned_to__c != newMap.get(visit.Id).Assigned_to__c){
                            visitAssignedUserLst.add(visit.Assigned_to__c);
                        }
                    }
                }
        	} 
            if(visitAssignedUserLst.size() > 0 && newList.size() > 0){
                Map<Id,User> userMap = new Map<Id,user>([Select Id,Sales_Role__c,Profile.Name from User where id in :visitAssignedUserLst]);
                if(userMap.size() > 0){
                    for(Visits__c visit:newList){
                        if(visit.Visit_Type__c == 'Digital Visit' || visit.Visit_Type__c == 'Visit'){
                            if(userMap.containsKey(visit.Assigned_to__c)){
                                if((userMap.get(visit.Assigned_to__c).Profile.Name != 'System Administrator' && userMap.get(visit.Assigned_to__c).Sales_Role__c == null) || (userMap.get(visit.Assigned_to__c).Profile.Name != 'System Administrator' && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'ASM' && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'AMS' && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'AMV')){
                                   visit.addError(System.Label.Visit_Error_Message1);
                                }
                            }
                        }
                        else if(visit.Visit_Type__c == 'Support Visit'){
                            if(userMap.containsKey(visit.Assigned_to__c)){
                                if(userMap.get(visit.Assigned_to__c).Sales_Role__c == 'ASM' || userMap.get(visit.Assigned_to__c).Sales_Role__c == 'AMS' || userMap.get(visit.Assigned_to__c).Sales_Role__c == 'AMV'){
                                    visit.addError(System.Label.Visit_Error_Message2);
                                }
                            }
                        }
                    }
                }
            }
            if(triggerEvent == System.TriggerOperation.BEFORE_INSERT){
                updateVisitHomeOfficeTracker(newList,accountIdsLst);
            }            
            updateVisitContactsTracker(newList,completedVisitAccLst);
            updateBusinessOpportunityTracker(newList,completedVisitAccLst);
            updateVisitPrescriberTracker(newList,completedVisitAccLst);
            updateVisitObjectiveAchievementTracker(completedVisitList,oldMap); 
            updateVisitProspectTracker(completedVisitList,completedVisitAccLst);
        }
        if(triggerEvent == System.TriggerOperation.AFTER_INSERT || triggerEvent == System.TriggerOperation.AFTER_UPDATE){
            Set<Id> accountIdsLst = new Set<Id>();
            Set<Id> considerableAccIdLst = new Set<Id>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){
                    if(triggerEvent == System.TriggerOperation.AFTER_INSERT && visit.Visit_Type__c == 'Visit' && visit.Visit_Status__c != 'Cancelled' && isConsiderableStage(visit.Visit_Reason__c))
                    	accountIdsLst.add(visit.Account__c);
                    else if(triggerEvent == System.TriggerOperation.AFTER_UPDATE){
                        //Need to check is any other check needed
                        if(((newMap.get(visit.Id).Visit_Status__c == 'Cancelled' || oldMap.get(visit.Id).Visit_Status__c == 'Cancelled' ))|| (newMap.get(visit.Id).Visit_Type__c == 'Visit' || oldMap.get(visit.Id).Visit_Type__c == 'Visit')||(newMap.get(visit.Id).Start_Time__c != oldMap.get(visit.Id).Start_Time__c)||(isConsiderableStage(newMap.get(visit.Id).Visit_Reason__c) || isConsiderableStage(oldMap.get(visit.Id).Visit_Reason__c))){
                            accountIdsLst.add(visit.Account__c);
                        }
                    }
                }    
                Map<Id,Account> accVisitMap = new Map<Id,Account>();
                if(accountIdsLst.size() > 0)
                	accVisitMap = new Map<Id,Account>([SELECT Id,RecordTypeId,Tacticom_SOF__c,CHCUSTCLASSIFICATIONID__c from Account where Id in : accountIdsLst]);
                for(Visits__c visit : newList){
                    if(accVisitMap.size() > 0 && accVisitMap.containsKey(visit.Account__c)){
                        if(AccountTriggerHelper.isConsiderableRecTypeForALC(accVisitMap.get(visit.Account__c).RecordTypeId) && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != null && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != 'none' && (accVisitMap.get(visit.Account__c).CHCUSTCLASSIFICATIONID__c == 'Ind' || accVisitMap.get(visit.Account__c).CHCUSTCLASSIFICATIONID__c == 'Chain')){
                            considerableAccIdLst.add(visit.Account__c);
                        }                            
                    }
                }
            }
            if(considerableAccIdLst.size() > 0){
                Set<Id> alcExistsAccsLst = new Set<Id>();
                Map<Id,Visits__c> latestVisit = AccountTriggerHelper.getLatestVisit(considerableAccIdLst);
                //get the account stage
                Map<Id,String> accountStageMap = new Map<Id,String>();
                Map<Id,Boolean> accountRetainStageMap = new Map<Id,Boolean>();
                if(latestVisit.size() > 0){
                    accountStageMap = AccountTriggerHelper.getStage(latestVisit);
                    accountRetainStageMap = AccountTriggerHelper.getRetainStage(latestVisit);
                } 
                else{//If there is no considerable visits,check if it has alc record
                   alcExistsAccsLst = isAlcRecordExists(considerableAccIdLst);
                }
                for(Id accId:considerableAccIdLst){
                    if(accountStageMap.size() > 0 && latestVisit.containsKey(accId)){ 
                        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        alc.Active__c = true;
                        alc.Stage__c = accountStageMap.get(accId);
                        alc.Retain_Stage__c = accountRetainStageMap.get(accId);
                        alc.External_Key__c = accId;
                        alc.Account__c = accId;
                        alc.Latest_Visit_Considered__c = latestVisit.get(accId).Id+'-'+latestVisit.get(accId).Name;
                        alcList.add(alc);
                        System.debug(alc);
                    }
                    else if(alcExistsAccsLst.contains(accId)){//If there is no considerable visit under that account but it already have a Alc then deactivate it
                      	Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        alc.Active__c = false;
                        alc.External_Key__c = accId;
                        alc.Account__c = accId;
                        alcList.add(alc);
                    }
           		}
            }
        }       
        if(alcList.size() > 0){
            upsert alcList External_Key__c;
        }
    }
    public static Boolean isConsiderableStage(String visitReason){
        Boolean isConsiderableStage =false;
        if(visitReason != null &&
           (visitReason.startsWith('Hunt') || visitReason.startsWith('On board') || 
            visitReason.startsWith('Grow') || visitReason.startsWith('Retain'))){
            isConsiderableStage = true;
        }
        return isConsiderableStage;
    }
    public static Set<Id> isAlcRecordExists(Set<Id> accLst){
        Set<Id> alcExistsLst =  new Set<Id>();
        List<Account_Life_Cycle__c> alcLst = [SELECT Id,Account__C FROM Account_Life_Cycle__c WHERE Account__C in : accLst];
        if(alcLst.size() > 0){
            for(Account_Life_Cycle__c alc: alcLst){
                alcExistsLst.add(alc.Account__c);
            }
        }
        return alcExistsLst;
    }
    public static void updateVisitHomeOfficeTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
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
    public static void updateBusinessOpportunityTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
        Map<Id,Boolean> accOppMap =  new Map<Id,Boolean>();
        if(accountIdsLst.size() > 0){
            List<Identified_Business_Opportunity__c> IOppLst = [SELECT Id,Project_Status__c,Account__c FROM Identified_Business_Opportunity__c WHERE Account__c in :accountIdsLst];
            if(IOppLst.size() > 0){
                for(Identified_Business_Opportunity__c opp:IOppLst){                    
                    if(opp.Project_Status__c  == 'Not Started' || opp.Project_Status__c  == 'In progress' || opp.Project_Status__c  == 'Postponed' ){
                        if(accOppMap.size() > 0 && accOppMap.containsKey(opp.Account__c)){
                            //Nothing to do
                        }
                        else if(accOppMap.size() == 0 || (accOppMap.size() > 0 && !accOppMap.containsKey(opp.Account__c))){
                            accOppMap.put(opp.Account__c,true);
                        }
                    }                 
                }
            }
            for(Visits__c visit:newList){
                if(accOppMap.size() > 0 && accOppMap.containsKey(visit.Account__c)){
                    visit.Visit_Business_Opportunities_Tracker__c = 'Identified';
                }
                else{
                    visit.Visit_Business_Opportunities_Tracker__c = 'Not Identified';
                }
            }            
        }
    }
    public static void updateVisitContactsTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
        if(accountIdsLst.size() > 0){
            List<Contact> contactLst = [SELECT ID, AccountId,FirstName,LastName 
                                        FROM Contact WHERE AccountId in: accountIdsLst];
            List<String> listOfFirstAndLastName = new List<String>(new String[] {'X','XX','XXX','Y',
                'YY','YYY','Z','ZZ','ZZZ'});
            
            Map<Id,Boolean> accContactMap = new Map<Id,Boolean>();
            if(contactLst.size() > 0){
                for(Contact con:contactLst){
                    if(con.FirstName != null && !listOfFirstAndLastName.Contains(con.FirstName) && con.LastName != null && !listOfFirstAndLastName.Contains(con.LastName)){
                        if(accContactMap.size() > 0 && accContactMap.containsKey(con.AccountId)){
                            //No need to do anything
                        }
                        else if(accContactMap.size() == 0 || (accContactMap.size() > 0 && !accContactMap.containsKey(con.AccountId))){
                            accContactMap.put(con.AccountId,true);
                        }
                    }
                }
            }
            for(Visits__c visit:newList){
                if(accContactMap.size() > 0 && accContactMap.containsKey(visit.Account__c)){
                    visit.Visit_Contacts_Tracker__c = 'Identified';
                }
                else{
                    visit.Visit_Contacts_Tracker__c = 'Not Identified';
                }
            }
        }        
        
    }
    public static void updateVisitPrescriberTracker(List<Visits__c> newList,Set<Id> accountIdsLst){
        if(accountIdsLst.size() > 0){
            List<AggregateResult> accContactRela = [SELECT Count(Id) coun,accountID FROM AccountContactRelation WHERE accountID in :accountIdsLst AND Contact.RecordType.DeveloperName = 'Opthalmologist'
                                                    GROUP BY accountID];
            Map<Id,Integer> accPrescribersCountMap =new Map<Id,Integer>();
            if(accContactRela.size() > 0){
                for(AggregateResult agg:accContactRela){
                    Id accId = (Id)agg.get('accountID');
                    Integer count = (Integer)agg.get('coun');
                    if(accPrescribersCountMap.size() > 0 && accPrescribersCountMap.containsKey(accId)){
                        //nothing to do
                    }
                    else if(accPrescribersCountMap.size() == 0 || (accPrescribersCountMap.size() > 0 && !accPrescribersCountMap.containsKey(accId))){
                        accPrescribersCountMap.put(accId,count);
                    }
                }
            }
            for(Visits__c visit:newList){
                if(accPrescribersCountMap.size() > 0 && accPrescribersCountMap.containsKey(visit.Account__c) && accPrescribersCountMap.get(visit.Account__c) > 0){
                    visit.Visit_Prescribers_Tracker__c = 'Identified';
                }
                else{
                    visit.Visit_Prescribers_Tracker__c = 'Not Identified';
                }
            }
        }        
    }
    
    public static void updateVisitObjectiveAchievementTracker(List<Visits__c> completedVisitList, 
                                                              Map <Id, Visits__c> oldVisitMap){       
      /*      for(Visits__c visit:completedVisitList){
               if(oldVisitMap!=null){
               if(oldVisitMap.get(visit.Id).Visit_Reason__c!=null && oldVisitMap.get(visit.Id).Actions_executed__c!=null && !oldVisitMap.get(visit.Id).Visit_Reason__c.contains(visit.Actions_executed__c) && visit.Visit_Reason__c!=null && visit.Actions_executed__c!=null && visit.Visit_Reason__c.contains(visit.Actions_executed__c) && oldVisitMap.get(visit.Id).Visit_Objective_Achievement_Tracker__c!=visit.Visit_Objective_Achievement_Tracker__c){
                    visit.Visit_Objective_Achievement_Tracker__c = 'Achieved';
                }
                else{
                    if(visit.Visit_Objective_Achievement_Tracker__c!='Not Achieved'){
                    visit.Visit_Objective_Achievement_Tracker__c = 'Not Achieved';
                }
                }
               }
                else{
                    if(visit.Visit_Reason__c.contains(visit.Actions_executed__c)){
                     visit.Visit_Objective_Achievement_Tracker__c = 'Achieved';
                    }
                    else{
                     visit.Visit_Objective_Achievement_Tracker__c = 'Not Achieved';
                    }                   
               }            
        }*/
    }
    public static void updateVisitProspectTracker(list<Visits__c> listOfVisit, Set<Id> accountIdsLst){
        Map<Id,String> segmentationMap = new Map<Id,String>();
        Map<Id,Account> accountMap = new Map<Id,Account>([select Id,Segmentation_Net__c,Lenses_Net_Sales_CFY__c from Account where Id in :accountIdsLst]);
        for(Visits__c visitObj : listOfVisit){
                String SegmentationNet = accountMap.get(visitObj.Account__c).Segmentation_Net__c;
                Decimal netSales = accountMap.get(visitObj.Account__c).Lenses_Net_Sales_CFY__c;
             	if(SegmentationNet == 'A1' || SegmentationNet == 'A2' 
                   || SegmentationNet == 'B1' || SegmentationNet == 'B2'
                   || SegmentationNet == 'C1' || SegmentationNet == 'C2') {
                         	visitObj.Visit_Prospection_Tracker__c = 'Customer'; 
               }  
               else if(netSales	> 0){
                       visitObj.Visit_Prospection_Tracker__c = 'Customer'; 
               }
                else{
                  	visitObj.Visit_Prospection_Tracker__c = 'Prospect';   
                }
        }
    }  
 }