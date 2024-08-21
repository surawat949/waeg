/*
     * @Author : Austin A
     * @Class name : LifeCycleReportingController
     * Created date : 2024-03-20
     * @Created by : Austin A
     * @Description : class for constructing data to render on Account Life cycle tab
 */
public with sharing class LifeCycleReportingController {
    private static Decimal count = 0;
    private static Decimal countStrategicValue = 0;
    private static Decimal countOfAccounts = 0;
    private static String currencyCode = '';
    private static Set<String> ownerNames = new Set<String>();
    private static Set<String> tacticomValues = new Set<String>();
    private static Set<String> salesManagerNames = new Set<String>();
    private static Set<String> companyList = new Set<String>();
    private static Map<Id, Decimal> recordFieldMap = new Map<Id, Decimal>();
    private static Map<Id, Decimal> sowMapL12 = new Map<Id, Decimal>();
    private static Map<Id, String> taskFieldMap = new Map<Id, String>();
    private static Map<Id, Boolean> visitsFieldMap = new Map<Id, Boolean>();

    @AuraEnabled
    public static LifeCycleReportingController.wrapper getAccountLifeCycleRecords(){
        Map<id,String> mapOfALCIdWithVisitId = new map<id,String>();
        boolean addNewIcon=false;
        LifeCycleReportingController.wrapper wrapperResponse = new LifeCycleReportingController.wrapper();
        List<Account_Life_Cycle__c> lifeCycleList = [Select id,Tacticom__c,Account__c,Latest_Visit_Considered__c,Current_SOW_L3Mo__c,Segmentation__c,
                                                     External_Key__c,Name,Lenses_Net_Sales_Last_12Mo__c,Account__r.CurrencyIsoCode,
                                                     Account__r.OwnerId,Account__r.Owner.Name,Account__r.CHCUSTCLASSIFICATIONID__c,
                                                     Account__r.Name,Account__r.Visionary_Alliance__c,Account__r.Segmentation_Net__c,
                                                     Retain_Stage__c,Account__r.Seiko_Network__c,Account__r.Account_Owner_Company__c,
                                                     Previous_Stage__c,Stage__c,Total_Visits_Achieved__c,Active__c,
                                                     Account__r.Lenses_Net_Sales_Last_12Mo__c,Account__r.Lenses_Net_Sales_LFY__c,
                                                     Account__r.TACTICOM_SOF__c,Account__r.Account_Owners_Manager__c,Account__r.Strategic_Value_Net_Sales__c,
                                                     Strategic_Value__c,Account__r.Account_Owner_Name__c
                                                     from Account_Life_Cycle__c where Active__c = true];
        if(lifeCycleList.size() >0){
            currencyCode = lifeCycleList[0].Account__r.CurrencyIsoCode;
        }else{
            currencyCode = 'EUR';
        }
        wrapperResponse.lifeCycleWrapperList = lifeCycleList;
        String objectName = 'Account_Life_Cycle__c';
        String fieldName ='Stage__c';
        Map<String,Decimal> stageNameMap = new Map<String,Decimal>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(!stageNameMap.containsKey(pickListVal.getValue())){
                stageNameMap.put(pickListVal.getValue(), 0);
            }
        }
        Map<String,Decimal> stageRecordCountMap = new Map<String,Decimal>(stageNameMap);
        Map<String,Decimal> summationOfStrategicValueMap = new Map<String,Decimal>(stageNameMap);
        List<Id> accIds = new List<Id>();
        List<Id> accLifeCycleIds = new List<Id>();
        for(Account_Life_Cycle__c opp: lifeCycleList){
            accIds.add(opp.Account__c);
            accLifeCycleIds.add(opp.Id);
            String visitId = opp.Latest_Visit_Considered__c.SubStringBefore('-V');
            mapOfALCIdWithVisitId.put(opp.id,visitId);
            tacticomValues.add(opp.Account__r.TACTICOM_SOF__c);
            salesManagerNames.add(opp.Account__r.Account_Owners_Manager__c);
            companyList.add(opp.Account__r.Account_Owner_Company__c);
            if(stageNameMap.containsKey(opp.Stage__c)){
                ownerNames.add(opp.Account__r.Owner.Name);
                count = stageNameMap.get(opp.Stage__c);
                countStrategicValue = summationOfStrategicValueMap.get(opp.Stage__c);
                Decimal sumPerStage = count + opp.Lenses_Net_Sales_Last_12Mo__c;
                
                Decimal sumStrategicValue = countStrategicValue + opp.Strategic_Value__c;
                //Decimal sumStrategicValue = countStrategicValue + ((opp.Account__r != null && opp.Account__r.Strategic_Value_Net_Sales__c != null) ? opp.Account__r.Strategic_Value_Net_Sales__c  : 0);
                stageNameMap.put(opp.Stage__c, sumPerStage.intValue());
                summationOfStrategicValueMap.put(opp.Stage__c, sumStrategicValue.intValue());
                countOfAccounts = stageRecordCountMap.get(opp.Stage__c);
                stageRecordCountMap.put(opp.Stage__c, ++countOfAccounts);
            }
        }
        User currentuser = [Select u.Profile.Name, u.ProfileId,CompanyName From User u where Id = :UserInfo.getUserId()];
        if(currentuser.ProfileId == '00eb0000000lainAAA') {
            wrapperResponse.isAdminUser = true;
        }
        List<Last_Sales_Statistics__c> statsData= [select id,Account__c,Lenses_Net_Sales_CFY_vs_LFY_YTD__c,Lenses_Gross_Sales_CFY_vs_LFY_YTD__c,Lenses_Net_SoW_Last_12Mo__c from Last_Sales_Statistics__c where Account__c IN :accIds];
        for (Last_Sales_Statistics__c record : statsData) {
            recordFieldMap.put(record.Account__c, record.Lenses_Net_Sales_CFY_vs_LFY_YTD__c);
            sowMapL12.put(record.Account__c, record.Lenses_Net_SoW_Last_12Mo__c);
        }
        List<Task> tasks = [SELECT Id, WhatId, ActivityDate, Status FROM Task WHERE WhatId IN :accLifeCycleIds AND IsClosed = false];
        for (Task task : tasks) {
            if (task.ActivityDate < Date.today()) {
                taskFieldMap.put(task.WhatId, 'One or more tasks are OVERDUE'); // Task is overdue
            } else {
                if (!taskFieldMap.containsKey(task.WhatId)) {
                    taskFieldMap.put(task.WhatId, 'One or more tasks are pending'); // Task exists but not overdue
                }
            }
        }
        list<Visits__c> listOfVisits = [SELECT id,Account__c,Account__r.Segmentation_Net__c,Visit_Reason__c FROM Visits__c 
                                        WHERE ID IN : mapOfALCIdWithVisitId.values() AND Visit_Reason__c like 'On board%' 
                                        AND Account__r.Segmentation_Net__c in ('A3','B3','C3','UNCATEGORIZED') limit 10000];
        for(Visits__c visitObj : listOfVisits){
            visitsFieldMap.put(visitObj.Account__c,true);
        }    
        List<LifeCycleReportingController.stageObject> pickValList = new List<LifeCycleReportingController.stageObject>();
        for(String stage: stageNameMap.keySet()){
            LifeCycleReportingController.stageObject pickVal = new LifeCycleReportingController.stageObject();
            pickVal.stage = stage;
            pickVal.summation = stageNameMap.get(stage);
            pickVal.summationOfStrategicValue = summationOfStrategicValueMap.get(stage);
            pickVal.noOfRecords = stageRecordCountMap.get(stage);
            pickVal.accountCurrency = currencyCode;
            pickValList.add(pickVal);
        }
        wrapperResponse.pickVals = pickValList;
        
        List<String> ownerList = new List<String>(ownerNames);
        List<String> salesList = new List<String>(salesManagerNames);
        List<String> accCompanyList = new List<String>(companyList);
        List<String> tacticomList = new List<String>(tacticomValues);
        accCompanyList.sort();
        wrapperResponse.ownerNameList = CustomerReviewFilterHandler.getRepresentativeList(currentuser.Id);
        wrapperResponse.salesManagerList = SortList(salesList);
        wrapperResponse.accountCompanyList = accCompanyList;
        wrapperResponse.TacticomList = SortList(tacticomList);
        //For Task 1598
        wrapperResponse.managerList = CustomerReviewFilterHandler.getSalesManagerList(currentuser.CompanyName);
        wrapperResponse.accountStatsMap = recordFieldMap;
        wrapperResponse.sowL12MoMap = sowMapL12;
        wrapperResponse.taskStatusMap = taskFieldMap;
        wrapperResponse.visitFlagMap = visitsFieldMap;
       
        return wrapperResponse;
    }
    public static List<String> SortList(List<String> dataList){
        List<String> tempList = new List<String>();
        tempList.add('No Filter');
        dataList.sort();
        tempList.addAll(dataList);
        return tempList;
    }
    public class stageObject{
        @AuraEnabled public Decimal noOfRecords = 0;
        @AuraEnabled public String stage = '';
        @AuraEnabled public Decimal summation = 0;
        @AuraEnabled public Decimal summationOfStrategicValue = 0;
        @AuraEnabled public String accountCurrency = '';
    }
    
    public class wrapper{
        @AuraEnabled 
        public Boolean isAdminUser = false;
        @AuraEnabled 
        public Map<id,String> taskStatusMap = new Map<Id,String>();
        @AuraEnabled 
        public Map<id,Boolean> visitFlagMap = new Map<Id,Boolean>();
        @AuraEnabled 
        public Map<id,Decimal> accountStatsMap = new Map<Id,Decimal>();
        @AuraEnabled 
        public Map<id,Decimal> sowL12MoMap = new Map<Id,Decimal>();
        @AuraEnabled 
        public List<User> ownerNameList = new List<User>();
        @AuraEnabled 
        public List<String> salesManagerList = new List<String>();
        @AuraEnabled
        public List<User> managerList = new List<User>();
        @AuraEnabled 
        public List<String> TacticomList = new List<String>();
        @AuraEnabled 
        public List<String> accountCompanyList = new List<String>();
        @AuraEnabled
        public List<Account_Life_Cycle__c> lifeCycleWrapperList = new List<Account_Life_Cycle__c>(); 
        @AuraEnabled
        public List<LifeCycleReportingController.stageObject> pickVals = new List<LifeCycleReportingController.stageObject>();
    }
    @AuraEnabled(cacheable=true)
    public static LifeCycleReportingController.wrapper getAccountLifeCycleRecordsUpdated(Boolean isConsolidatedDataNeeded){
        Map<id,String> mapOfALCIdWithVisitId = new map<id,String>();
        List<Account_Life_Cycle__c> lifeCycleList = new List<Account_Life_Cycle__c> ();
        boolean addNewIcon=false;
        LifeCycleReportingController.wrapper wrapperResponse = new LifeCycleReportingController.wrapper();
        if(isConsolidatedDataNeeded){
            lifeCycleList = [Select id,Tacticom__c,Account__c,Latest_Visit_Considered__c,Current_SOW_L3Mo__c,Segmentation__c,
                             External_Key__c,Name,Lenses_Net_Sales_Last_12Mo__c,Account__r.CurrencyIsoCode,
                             Account__r.OwnerId,Account__r.Owner.Name,Account__r.CHCUSTCLASSIFICATIONID__c,
                             Account__r.Name,Account__r.Visionary_Alliance__c,Account__r.Segmentation_Net__c,
                             Retain_Stage__c,Account__r.Seiko_Network__c,Account__r.Account_Owner_Company__c,
                             Previous_Stage__c,Stage__c,Total_Visits_Achieved__c,Active__c,
                             Account__r.Lenses_Net_Sales_Last_12Mo__c,Account__r.Lenses_Net_Sales_LFY__c,
                             Account__r.TACTICOM_SOF__c,Account__r.Account_Owners_Manager__c,Account__r.Strategic_Value_Net_Sales__c,
                             Strategic_Value__c,Account__r.Account_Owner_Name__c
                             from Account_Life_Cycle__c where Active__c = true];
        }else{
            lifeCycleList = [Select id,Tacticom__c,Account__c,Latest_Visit_Considered__c,Current_SOW_L3Mo__c,Segmentation__c,
                             External_Key__c,Name,Lenses_Net_Sales_Last_12Mo__c,Account__r.CurrencyIsoCode,
                             Account__r.OwnerId,Account__r.Owner.Name,Account__r.CHCUSTCLASSIFICATIONID__c,
                             Account__r.Name,Account__r.Visionary_Alliance__c,Account__r.Segmentation_Net__c,
                             Retain_Stage__c,Account__r.Seiko_Network__c,Account__r.Account_Owner_Company__c,
                             Previous_Stage__c,Stage__c,Total_Visits_Achieved__c,Active__c,
                             Account__r.Lenses_Net_Sales_Last_12Mo__c,Account__r.Lenses_Net_Sales_LFY__c,
                             Account__r.TACTICOM_SOF__c,Account__r.Account_Owners_Manager__c,Account__r.Strategic_Value_Net_Sales__c,
                             Strategic_Value__c,Account__r.Account_Owner_Name__c
                             from Account_Life_Cycle__c where Active__c = true AND Account__r.OwnerId = :UserInfo.getUserId()];
        }
        
        if(lifeCycleList.size() >0){
            currencyCode = lifeCycleList[0].Account__r.CurrencyIsoCode;
        }else{
            currencyCode = 'EUR';
        }
        wrapperResponse.lifeCycleWrapperList = lifeCycleList;
        String objectName = 'Account_Life_Cycle__c';
        String fieldName ='Stage__c';
        Map<String,Decimal> stageNameMap = new Map<String,Decimal>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(!stageNameMap.containsKey(pickListVal.getValue())){
                stageNameMap.put(pickListVal.getValue(), 0);
            }
        }
        Map<String,Decimal> stageRecordCountMap = new Map<String,Decimal>(stageNameMap);
        Map<String,Decimal> summationOfStrategicValueMap = new Map<String,Decimal>(stageNameMap);
        List<Id> accIds = new List<Id>();
        List<Id> accLifeCycleIds = new List<Id>();
        for(Account_Life_Cycle__c opp: lifeCycleList){
            accIds.add(opp.Account__c);
            accLifeCycleIds.add(opp.Id);
            String visitId = opp.Latest_Visit_Considered__c.SubStringBefore('-V');
            mapOfALCIdWithVisitId.put(opp.id,visitId);
            tacticomValues.add(opp.Account__r.TACTICOM_SOF__c);
            salesManagerNames.add(opp.Account__r.Account_Owners_Manager__c);
            companyList.add(opp.Account__r.Account_Owner_Company__c);
            if(stageNameMap.containsKey(opp.Stage__c)){
                ownerNames.add(opp.Account__r.Owner.Name);
                count = stageNameMap.get(opp.Stage__c);
                countStrategicValue = summationOfStrategicValueMap.get(opp.Stage__c);
                Decimal sumPerStage = count + opp.Lenses_Net_Sales_Last_12Mo__c;
                
                Decimal sumStrategicValue = countStrategicValue + opp.Strategic_Value__c;
                //Decimal sumStrategicValue = countStrategicValue + ((opp.Account__r != null && opp.Account__r.Strategic_Value_Net_Sales__c != null) ? opp.Account__r.Strategic_Value_Net_Sales__c  : 0);
                stageNameMap.put(opp.Stage__c, sumPerStage.intValue());
                summationOfStrategicValueMap.put(opp.Stage__c, sumStrategicValue.intValue());
                countOfAccounts = stageRecordCountMap.get(opp.Stage__c);
                stageRecordCountMap.put(opp.Stage__c, ++countOfAccounts);
            }
        }
        User currentuser = [Select u.Profile.Name, u.ProfileId,CompanyName From User u where Id = :UserInfo.getUserId()];
        if(currentuser.ProfileId == '00eb0000000lainAAA') {
            wrapperResponse.isAdminUser = true;
        }
        List<Last_Sales_Statistics__c> statsData= [select id,Account__c,Lenses_Net_Sales_CFY_vs_LFY_YTD__c,Lenses_Gross_Sales_CFY_vs_LFY_YTD__c,Lenses_Net_SoW_Last_12Mo__c from Last_Sales_Statistics__c where Account__c IN :accIds];
        for (Last_Sales_Statistics__c record : statsData) {
            recordFieldMap.put(record.Account__c, record.Lenses_Net_Sales_CFY_vs_LFY_YTD__c);
            sowMapL12.put(record.Account__c, record.Lenses_Net_SoW_Last_12Mo__c);
        }
        List<Task> tasks = [SELECT Id, WhatId, ActivityDate, Status FROM Task WHERE WhatId IN :accLifeCycleIds AND IsClosed = false];
        for (Task task : tasks) {
            if (task.ActivityDate < Date.today()) {
                taskFieldMap.put(task.WhatId, 'One or more tasks are OVERDUE'); // Task is overdue
            } else {
                if (!taskFieldMap.containsKey(task.WhatId)) {
                    taskFieldMap.put(task.WhatId, 'One or more tasks are pending'); // Task exists but not overdue
                }
            }
        }
        list<Visits__c> listOfVisits = [SELECT id,Account__c,Account__r.Segmentation_Net__c,Visit_Reason__c FROM Visits__c 
                                        WHERE ID IN : mapOfALCIdWithVisitId.values() AND Visit_Reason__c like 'On board%' 
                                        AND Account__r.Segmentation_Net__c in ('A3','B3','C3','UNCATEGORIZED') limit 10000];
        for(Visits__c visitObj : listOfVisits){
            visitsFieldMap.put(visitObj.Account__c,true);
        }    
        List<LifeCycleReportingController.stageObject> pickValList = new List<LifeCycleReportingController.stageObject>();
        for(String stage: stageNameMap.keySet()){
            LifeCycleReportingController.stageObject pickVal = new LifeCycleReportingController.stageObject();
            pickVal.stage = stage;
            pickVal.summation = stageNameMap.get(stage);
            pickVal.summationOfStrategicValue = summationOfStrategicValueMap.get(stage);
            pickVal.noOfRecords = stageRecordCountMap.get(stage);
            pickVal.accountCurrency = currencyCode;
            pickValList.add(pickVal);
        }
        wrapperResponse.pickVals = pickValList;
        
        List<String> ownerList = new List<String>(ownerNames);
        List<String> salesList = new List<String>(salesManagerNames);
        List<String> accCompanyList = new List<String>(companyList);
        List<String> tacticomList = new List<String>(tacticomValues);
        accCompanyList.sort();
        wrapperResponse.ownerNameList = CustomerReviewFilterHandler.getRepresentativeList(currentuser.Id);
        wrapperResponse.salesManagerList = SortList(salesList);
        wrapperResponse.accountCompanyList = accCompanyList;
        wrapperResponse.TacticomList = SortList(tacticomList);
        //For Task 1598
        wrapperResponse.managerList = CustomerReviewFilterHandler.getSalesManagerList(currentuser.CompanyName);
        wrapperResponse.accountStatsMap = recordFieldMap;
        wrapperResponse.sowL12MoMap = sowMapL12;
        wrapperResponse.taskStatusMap = taskFieldMap;
        wrapperResponse.visitFlagMap = visitsFieldMap;
        
        return wrapperResponse;
    }
}