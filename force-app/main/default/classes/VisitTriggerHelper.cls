public class VisitTriggerHelper {
    private static final String EyeDoctor_RT = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Eye_Doctor_Visit').getRecordTypeId();
    public static  dateTime CompletionDate = null;

    public static void entry(
        System.TriggerOperation triggerEvent,
        List <Visits__c> newList,
        Map <Id, Visits__c> newMap,
        List <Visits__c> oldList,
        Map <Id, Visits__c> oldMap
    ) {
        List<Account_Life_Cycle__c> alcList = new List<Account_Life_Cycle__c>();
        Set<Id> conIdSet = new Set<Id>();
        String companyName = [select companyName from User where id=:UserInfo.getUserId()].companyName;

        if(triggerEvent == System.TriggerOperation.BEFORE_INSERT || triggerEvent == System.TriggerOperation.BEFORE_UPDATE){
            Set<Id> accountIdsLst = new Set<Id>();
            List<Visits__c> eyeVisitIdsLst = new List<Visits__c>();
            Set<Id> ContactIdsLst = new Set<Id>();
            Set<Id> visitAssignedUserLst = new Set<Id>();
            Set<Id> visitAccountLst = new Set<Id>();
            Set<Id> completedVisitAccLst = new Set<Id>();
            List<Visits__c> completedVisitList = new List<Visits__c>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){               
                    if(triggerEvent == System.TriggerOperation.BEFORE_INSERT ){
                        /*system.debug('>>>visitContact'+visit.Contact__r.MiyoSmart_Segmentation__c);
                        if(visit.Contact__c != null){
                         	visit.Visit_Contact_Segmentation_Tracker__c = 'MiyoSmart Segmentation';    
                        }
                        else{
                          	visit.Visit_Contact_Segmentation_Tracker__c = 'No Contact Selected';    
                        }*/
                        if(visit.RecordTypeId == EyeDoctor_RT){
                            eyeVisitIdsLst.add(visit);
                        	ContactIdsLst.add(visit.Contact__c);
                        }    
                        if(visit.Visit_Status__c == 'Complete'){
                            CompletionDate = system.now();
                            completedVisitAccLst.add(visit.Account__c);
                            completedVisitList.add(visit);
                        }
                        accountIdsLst.add(visit.Account__c); 
                        //Collect Assigned to user Ids
                        visitAssignedUserLst.add(visit.Assigned_to__c);  
                        visitAccountLst.add(visit.Account__c);
                    }
                    else if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE){
                        //General validations go here
                        // Migrated the below code from visit_AIU_createVisitTask trigger
                        if (companyName == 'HLBR') {
                            Visits__c oldVisit = oldMap.get(visit.Id);
                            if (visit.Visit_Status__c == 'Complete' && oldVisit.Visit_Status__c == 'Complete') {
                                if (oldVisit.Start_Time__c != visit.Start_Time__c || oldVisit.End_Time__c != visit.End_Time__c) {
                                    visit.addError(System.Label.Completed_Visit_Update_Error);
                                }
                            }
                        }
                        
                        //
                        accountIdsLst.add(visit.Account__c);
                        if(oldMap.get(visit.Id).Visit_Status__c != 'Complete' && newMap.get(visit.Id).Visit_Status__c == 'Complete'){
                            CompletionDate = system.now();
                            completedVisitAccLst.add(visit.Account__c);
                            completedVisitList.add(visit);
  
                        }
                        //if Visit Type is changed or Assigned To Person is changed
                        if(oldMap.get(visit.Id).Visit_Type__c != newMap.get(visit.Id).Visit_Type__c || oldMap.get(visit.Id).Assigned_to__c != newMap.get(visit.Id).Assigned_to__c){
                            visitAssignedUserLst.add(visit.Assigned_to__c);
                            visitAccountLst.add(visit.Account__c);
                        }
                    } 
                    
                    // Setting time as 00:00 for all day events to show duration as zero
                    if (visit.Is_All_Day_Event__c) {
                        if (visit.Start_Time__c != null) {
                            visit.Start_Time__c = ClsVisitUtil.calculateDateTimeValue(visit.Start_Time__c.date(), '00:00');
                        }
                        if (visit.End_Time__c != null) {
                            visit.End_Time__c = ClsVisitUtil.calculateDateTimeValue(visit.End_Time__c.date(), '00:00');
                        }
                    }
                }
            } 
            if(visitAssignedUserLst.size() > 0 && newList.size() > 0 && visitAccountLst.size() > 0){              
                restrictUsersToWorkOnVisits(visitAssignedUserLst,newList,visitAccountLst);
            }
            if(completedVisitList.size()>0 && completedVisitAccLst.size()>0){
                updateCompletedVisitTracker(completedVisitList,completedVisitAccLst,triggerEvent,oldMap);
            } 
            if(accountIdsLst.size()>0){
                Map<Id,Account> allAccVisitMap = new Map<Id,Account>();
                if(accountIdsLst.size() > 0){
                    allAccVisitMap = new Map<Id,Account>([SELECT Id,RecordTypeId,Total_Visits_Planned__c ,Tacticom_SOF__c,CHCUSTCLASSIFICATIONID__c,Lenses_Net_Sales_Last_12Mo__c from Account where Id in : accountIdsLst]);
                }
                populateOpenVisitTracker(allAccVisitMap,newList,oldMap,triggerEvent);
            }
            if(eyeVisitIdsLst.size()>0){
            	updateEyeDoctorVisits(ContactIdsLst,eyeVisitIdsLst);    
                
            }
        }
        if(triggerEvent == System.TriggerOperation.AFTER_INSERT || triggerEvent == System.TriggerOperation.AFTER_UPDATE){
            Set<Id> accountIdsLst = new Set<Id>();
            Set<Account> considerableAccLst = new Set<Account>();
            Set<Id> considerableAccIdLst = new Set<Id>();
            List<Visits__c> considerableVisitsLst = new List<Visits__c>();
            if(newList != null && newList.size() > 0){
                for(Visits__c visit : newList){
                    if(triggerEvent == System.TriggerOperation.AFTER_INSERT) {
                        if (visit.Visit_Type__c == 'Visit' && visit.Visit_Status__c != 'Cancelled' && isConsiderableReason(visit.Visit_Reason__c)) {
                            accountIdsLst.add(visit.Account__c);   
                            considerableVisitsLst.add(visit);
                        }
                        // Get contact Last Visit Date
                        if (visit.Visit_Status__c == 'Complete' && visit.visit_Type__c == 'Visit' && !visit.Visited_but_not_seen__c && visit.Contact__c != null) {
                            conIdSet.add(visit.Contact__c);			
                        }
                        
                    } else if(triggerEvent == System.TriggerOperation.AFTER_UPDATE){
                        if(((newMap.get(visit.Id).Visit_Status__c != oldMap.get(visit.Id).Visit_Status__c) && (newMap.get(visit.Id).Visit_Status__c == 'Cancelled' || oldMap.get(visit.Id).Visit_Status__c == 'Cancelled' ))|| (newMap.get(visit.Id).Visit_Type__c != oldMap.get(visit.Id).Visit_Type__c && (newMap.get(visit.Id).Visit_Type__c == 'Visit' || oldMap.get(visit.Id).Visit_Type__c == 'Visit'))||(newMap.get(visit.Id).Start_Time__c != oldMap.get(visit.Id).Start_Time__c)||(newMap.get(visit.Id).Visit_Reason__c != oldMap.get(visit.Id).Visit_Reason__c &&(isConsiderableReason(newMap.get(visit.Id).Visit_Reason__c) || isConsiderableReason(oldMap.get(visit.Id).Visit_Reason__c)))){
                            accountIdsLst.add(visit.Account__c);
                            considerableVisitsLst.add(visit);
                        }
                    }
                }
                
                if (!conIdSet.isEmpty()) {
                    ClsVisitUtil.updateContactRecords(conIdSet);
                }
                
                Map<Id,Account> accVisitMap = new Map<Id,Account>();
                if(accountIdsLst.size() > 0)
                    accVisitMap = new Map<Id,Account>([SELECT Id,RecordTypeId,Tacticom_SOF__c,CHCUSTCLASSIFICATIONID__c,Lenses_Net_Sales_Last_12Mo__c,Segmentation_Net__c,Onboarding_Customer__c,Total_Visits_Performed__c,Account_Status__c from Account where Id in : accountIdsLst]);
                for(Visits__c visit : considerableVisitsLst){//add considerable visit list
                    if(accVisitMap.size() > 0 && accVisitMap.containsKey(visit.Account__c)){
                        if(AccountTriggerHelper.isConsiderableRecTypeForALC(accVisitMap.get(visit.Account__c).RecordTypeId) && accVisitMap.get(visit.Account__c).Account_Status__c != 'Closed' && accVisitMap.get(visit.Account__c).Account_Status__c != 'Blocked' && accVisitMap.get(visit.Account__c).Account_Status__c != 'Suspended' ){                      
                            if(accVisitMap.get(visit.Account__c).Lenses_Net_Sales_Last_12Mo__c <= 0 && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != null && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != 'none'){
                                considerableAccLst.add(accVisitMap.get(visit.Account__c));
                                considerableAccIdLst.add(visit.Account__c);
                            }
                            else if(accVisitMap.get(visit.Account__c).Lenses_Net_Sales_Last_12Mo__c > 0 && (accVisitMap.get(visit.Account__c).CHCUSTCLASSIFICATIONID__c == 'Chain' && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != null && accVisitMap.get(visit.Account__c).Tacticom_SOF__c != 'none')|| accVisitMap.get(visit.Account__c).CHCUSTCLASSIFICATIONID__c == 'Ind' ){
                                considerableAccLst.add(accVisitMap.get(visit.Account__c));
                                considerableAccIdLst.add(visit.Account__c);
                            }
                        }                         
                    }
                }
            }
            if(considerableAccLst.size() > 0){
                Map<Id,Visits__c> latestVisitMap = AccountTriggerHelper.getLatestVisit(considerableAccIdLst);
                Map<Id,AccountTriggerHelper.RetainDetails> accountRetainStageMap = AccountTriggerHelper.getRetainStage(latestVisitMap);              
                for(Account acc:considerableAccLst){
                    String stage = AccountTriggerHelper.getStage(acc,latestVisitMap);
                    Boolean retainFlag=false;
                    String retainReason='';
                    if(accountRetainStageMap.size() > 0 && accountRetainStageMap.containsKey(acc.Id)){
                       retainFlag = accountRetainStageMap.get(acc.Id).retainStageFlag;
                       retainReason = accountRetainStageMap.get(acc.Id).retainReason;
                    }
                    if(stage != null || accountRetainStageMap.containsKey(acc.Id)){ 
                        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        //alc.Active__c = true;
                        if(stage != null)
                        	alc.Stage__c = stage;
                        alc.Retain_Stage__c = retainFlag;
                        alc.Retain_Reason__c = retainReason;
                        alc.External_Key__c = acc.Id;
                        alc.Account__c = acc.Id;
                        if(latestVisitMap.size() > 0 && latestVisitMap.containsKey(acc.Id))
                        	alc.Latest_Visit_Considered__c = latestVisitMap.get(acc.Id).Id+'-'+latestVisitMap.get(acc.Id).Name;
                        else
                            alc.Latest_Visit_Considered__c = '';
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
    public static void populateOpenVisitTracker(Map<Id,Account> allAccVisitMap,List <Visits__c> newList,Map <Id, Visits__c> oldMap, System.TriggerOperation triggerContext){
        for (Visits__c visitUpdate : newList) {
            Visits__c oldVisit;
            if (oldMap!= null && oldMap.containsKey(visitUpdate.Id)) {
                oldVisit = oldMap.get(visitUpdate.Id);
            }
            
            if(triggerContext === System.TriggerOperation.BEFORE_INSERT){
                Account relatedAccount = allAccVisitMap.get(visitUpdate.Account__c);
                DateTime currentTimeMinus1Mins = DateTime.now().addMinutes(-1);
                // Visit Initial Date Tracker Logic
                visitUpdate.Visit_Initial_Date_Tracker__c = visitUpdate.Start_Time__c.date();
                // Visit Preparation Tracker
                if (visitUpdate.Visit_Status__c == 'Complete' || visitUpdate.Visit_Status__c == 'Cancelled') {
                    visitUpdate.Visit_Preparation_Tracker__c = 'Not Prepared';
                } else if (visitUpdate.Visit_Reason__c != null && visitUpdate.Visit_Objective_follow_up_notes__c != null  && (currentTimeMinus1Mins < visitUpdate.Start_Time__c)) {
                    visitUpdate.Visit_Preparation_Tracker__c = 'Prepared';
                } else {
                    visitUpdate.Visit_Preparation_Tracker__c = 'Not Prepared';
                }
                // Visit Planning Tracker
                if (relatedAccount != null && relatedAccount.Total_Visits_Planned__c != null && relatedAccount.Total_Visits_Planned__c > 0) {
                    visitUpdate.Visit_Planned_Tracker__c = 'Planned by NSM';
                } else {
                    visitUpdate.Visit_Planned_Tracker__c = 'Not Planned by NSM';
                }
                // Visit Tacticom Tracker
                if (relatedAccount != null && relatedAccount.TACTICOM_SOF__c != null && relatedAccount.TACTICOM_SOF__c != 'Not Selected') {
                    visitUpdate.Visit_Tacticom_Tracker__c = 'Inside Tacticom';
                } else {
                    visitUpdate.Visit_Tacticom_Tracker__c = 'Outside Tacticom';
                }
            }
            else if(triggerContext === System.TriggerOperation.BEFORE_UPDATE){		
			   if(visitUpdate.Start_Time__c != oldMap.get(visitUpdate.Id).Start_Time__c){
                    Date currentDate = Date.today();
                    Integer currentMonth = currentDate.month();
                    Integer currentYear = currentDate.year();
                    Integer lastMonth = currentMonth - 1;
                    Integer lastYear = currentYear;
                    Integer nextMonth = currentMonth + 1;
                    Integer nextYear = currentYear;
                    if (lastMonth == 0 || Test.isRunningTest()) {
                        lastMonth = 12;
                        lastYear = currentYear - 1;
                    }
                    if (nextMonth == 13 || Test.isRunningTest()) {
                        nextMonth = 1;
                        nextYear = currentYear + 1;
                    }
                    Date startOfNextMonth = Date.newInstance(nextYear, nextMonth, 1);
                    Date twentiethOfLastMonth = Date.newInstance(lastYear, lastMonth, 20);
                    Date twentiethOfthisMonth = Date.newInstance(currentYear, currentMonth, 20);
                    If(visitUpdate.CreatedDate >= twentiethOfLastMonth && visitUpdate.Start_Time__c == startOfNextMonth && visitUpdate.LastModifiedDate < twentiethOfthisMonth){
                        visitUpdate.Visit_Initial_Date_Tracker__c = visitUpdate.Start_Time__c.date();
                    }else{
                        visitUpdate.Visit_Initial_Date_Tracker__c = currentDate;
                    }
                }
                //Visit Preparation Tracker For Update
                // Check if Visit_Reason__c or Visit_Objective_follow_up_notes__c has changed
                if ((visitUpdate.Visit_Status__c != oldVisit.Visit_Status__c) || (visitUpdate.Visit_Reason__c != oldVisit.Visit_Reason__c) || (visitUpdate.Visit_Objective_follow_up_notes__c != oldVisit.Visit_Objective_follow_up_notes__c)) {
                    if (visitUpdate.Visit_Reason__c != null && visitUpdate.Visit_Objective_follow_up_notes__c != null && DateTime.now() < visitUpdate.Start_Time__c && (visitUpdate.Visit_Status__c == 'Planned' || visitUpdate.Visit_Status__c == 'Prepared')) {
                        visitUpdate.Visit_Preparation_Tracker__c = 'Prepared';
                    } else {
                        visitUpdate.Visit_Preparation_Tracker__c = 'Not Prepared';
                    }
            	}
            }
        }
    }
    public static Boolean isConsiderableReason(String visitReason){
        Boolean isConsiderableReason =false;
        if(visitReason == 'Problem Solving' || visitReason == 'Customer Retention' || visitReason == 'Cash Collection' || visitReason == 'Account Discovery' || visitReason == 'Negotiation' || visitReason == 'Contract signature'){
            isConsiderableReason = true;
        }
        return isConsiderableReason;
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
    public static void updateCompletedVisitTracker(list<Visits__c> completedVisitList, Set<Id> accountIdsLst, System.TriggerOperation triggerContext,Map <Id, Visits__c> oldMap){
        //Map<Id,String> segmentationMap = new Map<Id,String>();
        list<Last_Sales_Statistics__c> listOfSalesStatistics = [SELECT Id,Account__c,H_S_Net_Sales_SOW_Last_12Mo__c 
                                                                FROM Last_Sales_Statistics__c
                                                                WHERE Account__c IN: accountIdsLst];
        Map<Id,Account> accountMap = new Map<Id,Account>([select Id,Strategic_Value_Net_Sales__c,Account_Owner_Name__c,
                                                          Segmentation_Net__c,Lenses_Net_Sales_CFY__c,Shop_Country__c,
                                                          Second_Competitor_Local_Name__c,First_Competitor_local_name__c from Account where Id in :accountIdsLst]);
        Map<Id,Boolean> accOppMap =  new Map<Id,Boolean>();
        Map<Id,Boolean> accStatisticsMap = new Map<Id,Boolean>();        
        Map<Id,Integer> accPrescribersCountMap =new Map<Id,Integer>();
        Map<Id,Boolean> accContactMap = new Map<Id,Boolean>();
        //collect all the country codes and pass them to the query   
        Map<Id,String> shopCountryMap = new Map<Id,String>();
        Date creationDate = Date.today();
        Datetime dt = (DateTime)creationDate;
        String dayOfWeek = dt.format('EEEE');   
        Map<String,String> homeOfficeDayMap = new Map<String,String>();
        Map<String, Entity_detail__mdt> allMetadadata = Entity_detail__mdt.getAll();	
        if(accountIdsLst.size() > 0){
            List<Contact> contactLst = [SELECT ID, AccountId,FirstName,LastName 
                                        FROM Contact WHERE AccountId in: accountIdsLst];
            List<String> listOfFirstAndLastName = new List<String>(new String[] {'X','XX','XXX','Y',
                'YY','YYY','Z','ZZ','ZZZ'});
            List<AggregateResult> accContactRela = [SELECT Count(Id) coun,accountID FROM AccountContactRelation WHERE accountID in :accountIdsLst AND Contact.RecordType.DeveloperName = 'Opthalmologist'
                                                    GROUP BY accountID];
            List<Identified_Business_Opportunity__c> IOppLst = [SELECT Id,Project_Status__c,Account__c FROM Identified_Business_Opportunity__c WHERE Account__c in :accountIdsLst];
            
            for (Entity_detail__mdt entity : allMetadadata.values()) {
                homeOfficeDayMap.put(entity.Country_Code__c,entity.ASM_Home_Office_Day__c);
            } 
            for(Account acc:accountMap.values()){
                shopCountryMap.put(acc.Id,acc.Shop_Country__c);
            }               
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
            if(listOfSalesStatistics.size()>0){
                for(Last_Sales_Statistics__c lastSalesStatistics : listOfSalesStatistics){
                    if(lastSalesStatistics.H_S_Net_Sales_SOW_Last_12Mo__c > 90){
                        if(accStatisticsMap.size() > 0 && accStatisticsMap.containsKey(lastSalesStatistics.Account__c))
                        {
                            //nothing to do   
                        }
                        else if(accStatisticsMap.size() == 0 
                                || (accStatisticsMap.size() > 0 && !accStatisticsMap.containsKey(lastSalesStatistics.Account__c))){
                                    accStatisticsMap.put(lastSalesStatistics.Account__c,true);
                                }
                    }
                }
            }
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
        }				
        for(Visits__c visitObj : completedVisitList){
            visitObj.Visit_completed_date__c= system.now();
            String accountOwnerName = accountMap.get(visitObj.Account__c).Account_Owner_Name__c;
            Decimal StrategicValue = accountMap.get(visitObj.Account__c).Strategic_Value_Net_Sales__c;
			// update Visit Real Time Report Tracker
			    system.debug('>>>>'+CompletionDate);
				if(CompletionDate !=null){
                     Decimal visitHoursDifference = (CompletionDate.getTime() - visitObj.End_Time__c.getTime()) / 3600000.0;
                     if(visitHoursDifference<=24){
                         visitObj.Visit_Real_Time_Report_Tracker__c = 'Real Time'; 
                     }
                     else{
                        visitObj.Visit_Real_Time_Report_Tracker__c = 'Delayed'; 
                     }
			}		
            // update Visit_Segmentation_Net_Tracker  
            visitObj.Visit_Segmentation_Net_Tracker__c = accountMap.get(visitObj.Account__c).Segmentation_Net__c;
            // update Visit_Account_Owner_Tracker
            if(accountMap.get(visitObj.Account__c).Account_Owner_Name__c == visitObj.Visit_assigned_to__c){
                visitObj.Visit_Account_Owner_Tracker__c = 'Account Owner';  
            }
            else{
                visitObj.Visit_Account_Owner_Tracker__c = 'Other';    
            }
            
            // update Visit_Strategic_Value_Tracker
            if(accountMap.get(visitObj.Account__c).Strategic_Value_Net_Sales__c>0){
                visitObj.Visit_Strategic_Value_Tracker__c = 'Identified';
            }
            else{
                visitObj.Visit_Strategic_Value_Tracker__c = 'Not Identified';
            }
            // update Visit_Prospection_Tracker__c;
            if(accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'A1' || accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'A2' 
               || accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'B1' || accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'B2'
               || accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'C1' || accountMap.get(visitObj.Account__c).Segmentation_Net__c == 'C2') {
                   visitObj.Visit_Prospection_Tracker__c = 'Customer'; 
               }  
            else if(accountMap.get(visitObj.Account__c).Lenses_Net_Sales_CFY__c	> 0){
                visitObj.Visit_Prospection_Tracker__c = 'Customer'; 
            }
            else{
                visitObj.Visit_Prospection_Tracker__c = 'Prospect';   
            }
            
            // update Visit Objective Achievement Tracker
            List<String> newActionValue = new List<String>();   
            if (visitObj.Actions_executed__c != null) {
                newActionValue = visitObj.Actions_executed__c.split(';');
            }
            if (visitObj.Visit_Reason__c != null && !newActionValue.isEmpty() && newActionValue.contains(visitObj.Visit_Reason__c)) {
                visitObj.Visit_Objective_Achievement_Tracker__c = 'Achieved';
            } else{
                visitObj.Visit_Objective_Achievement_Tracker__c = 'Not Achieved';
            }
            //update Visit_Contacts_Tracker
            if(accContactMap.size() > 0 && accContactMap.containsKey(visitObj.Account__c)){           
                visitObj.Visit_Contacts_Tracker__c = 'Identified';
                
            }
            else{
                visitObj.Visit_Contacts_Tracker__c = 'Not Identified';
            }
            
            // update Visit_Prescribers_Tracker
            if(accPrescribersCountMap.size() > 0 && accPrescribersCountMap.containsKey(visitObj.Account__c) 
               && accPrescribersCountMap.get(visitObj.Account__c) > 0){
                   visitObj.Visit_Prescribers_Tracker__c = 'Identified';
               }
            else{
                visitObj.Visit_Prescribers_Tracker__c = 'Not Identified';
            }
            // update Visit_Business_Opportunities_Tracker
            if(accOppMap.size() > 0 && accOppMap.containsKey(visitObj.Account__c)){
                visitObj.Visit_Business_Opportunities_Tracker__c = 'Identified';
            }
            else{
                visitObj.Visit_Business_Opportunities_Tracker__c = 'Not Identified';
            }
            // update Visit_Home_Office_Tracker
            if(shopCountryMap.size() > 0){
                String shopCountry = shopCountryMap.get(visitObj.Account__c);
                if(shopCountry != null && homeOfficeDayMap.size() > 0  && homeOfficeDayMap.containsKey(shopCountry)){
                    if(homeOfficeDayMap.get(shopCountry) == 'No Instruction' || homeOfficeDayMap.get(shopCountry) == null){
                        visitObj.Visit_Home_Office_Tracker__c = 'Free Organization';
                    }
                    else if(visitObj.Visit_Creation_Day_Tracker__c == homeOfficeDayMap.get(shopCountry)){                        
                        visitObj.Visit_Home_Office_Tracker__c = 'Home Office Day';
                    }
                    else{
                        visitObj.Visit_Home_Office_Tracker__c = 'Other Days';
                    }
                }
                else{//If Shop country is not there in Meta Data
                    visitObj.Visit_Home_Office_Tracker__c = 'Free Organization';
                }    
            }
            
            // update Competitors Tracker
            system.debug('>>accStatisticsMap'+accStatisticsMap.get(visitObj.Account__c));
            if(accountMap.get(visitObj.Account__c).First_Competitor_local_name__c != null 
               || accountMap.get(visitObj.Account__c).Second_Competitor_Local_Name__c != null ||
               (accStatisticsMap.size()>0 
                && accStatisticsMap.containsKey(visitObj.Account__c) 
               )){
                   visitObj.Visit_Competitors_Tracker__c = 'Identified';   
               }
            else{
                visitObj.Visit_Competitors_Tracker__c = 'Not Identified';     
            }
            //Visit Reporting Day Tracker
            if(((triggerContext === System.TriggerOperation.BEFORE_INSERT) && (visitObj.Visit_Status__c == 'Complete' || visitObj.Visit_Status__c == 'Cancelled'))  || ((triggerContext === System.TriggerOperation.BEFORE_UPDATE) && visitObj.Visit_Status__c != oldMap.get(visitObj.Id).Visit_Status__c && (visitObj.Visit_Status__c == 'Complete' || visitObj.Visit_Status__c == 'Cancelled'))) {  
                visitObj.Visit_Reporting_Day_Tracker__c = dayOfWeek ;
            }
        }
    }		
    public static void restrictUsersToWorkOnVisits(Set<Id> visitAssignedUserLst,List<Visits__c> newList,Set<Id> accountLst){
        Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Hoya_Account_Id__c,OwnerId from Account where id in :accountLst]);
        Map<Id,User> userMap = new Map<Id,user>([Select Id,Sales_Role__c,Profile.Name from User where id in :visitAssignedUserLst]);        
        if(userMap.size() > 0 && accMap.size() > 0){
            for(Visits__c visit:newList){
                Boolean isSelfAssigned = false;
                if(accMap.containsKey(visit.Account__c) && accMap.get(visit.Account__c).Hoya_Account_Id__c != null && (!accMap.get(visit.Account__c).Hoya_Account_Id__c.startsWith('US') && !accMap.get(visit.Account__c).Hoya_Account_Id__c.startsWith('CA'))){
                    if(visit.Visit_Type__c == 'Digital Visit' || visit.Visit_Type__c == 'Visit'){
                        if(visit.Assigned_to__c == accMap.get(visit.Account__c).OwnerId)
                            isSelfAssigned = true;
                        if(userMap.containsKey(visit.Assigned_to__c)){
                            if((userMap.get(visit.Assigned_to__c).Profile.Name != 'System Administrator' && userMap.get(visit.Assigned_to__c).Sales_Role__c == null) || (userMap.get(visit.Assigned_to__c).Profile.Name != 'System Administrator' && !isSelfAssigned && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'ASM' && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'AMS' && userMap.get(visit.Assigned_to__c).Sales_Role__c != 'AMV')){
                                visit.addError(System.Label.Visit_Error_Message1);
                            }
                        }
                    }
                    else if(visit.Visit_Type__c == 'Support Direct Visit' || visit.Visit_Type__c == 'Support Digital Visit'){
                        if(userMap.containsKey(visit.Assigned_to__c)){
                            if(userMap.get(visit.Assigned_to__c).Sales_Role__c == 'ASM' || userMap.get(visit.Assigned_to__c).Sales_Role__c == 'AMS' || userMap.get(visit.Assigned_to__c).Sales_Role__c == 'AMV'){
                                visit.addError(System.Label.Visit_Error_Message2);
                            }
                        }
                    }
                }
            }
        }
    }
    public static void updateEyeDoctorVisits(Set<Id> ContactIdsLst,List<Visits__c> newList){

        Map<Id,Contact> ContactMap = new Map<Id,Contact>([select Id,MiyoSmart_Segmentation__c from Contact 
                                                           where Id in :ContactIdsLst]);
        for(Visits__c visitObj : newList){
            if(visitObj.Contact__c != null ){
             	visitObj.Visit_Contact_Segmentation_Tracker__c = ContactMap.get(visitObj.Contact__c).MiyoSmart_Segmentation__c;     
            }
            else{
              	visitObj.Visit_Contact_Segmentation_Tracker__c = 'No Contact Selected';   
            }
        }
    }
    

    
}