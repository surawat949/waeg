/*
* @Author : Austin A
* @Class name : VisitZonesController
* Created date : 2024-06-11
* @Created by : Austin A
* @Description : class for Visit Zones v2 tab
*/
public WITHOUT SHARING class VisitZonesController {
    private static Decimal plannedVisitsWeight = 0;
    private static Decimal countOfProspects = 0;
    private static String clinicRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    
    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaignOptions(String showCampaign) {//check for boolean
        List<Campaign> campaignList = new List<Campaign>();
        if(showCampaign == 'true'){
            String currentUser = UserInfo.getUserId();
            String companyName = [SELECT CompanyName FROM User WHERE Id=:currentUser].CompanyName;
            if(String.isBlank(companyName) || String.isEmpty(companyName) || companyName == 'HVC'){
                campaignList = [SELECT Id, Name,Campaign_Subsidiary__c FROM Campaign WHERE IsActive=true WITH USER_MODE ORDER BY Name ASC LIMIT 500];
            }else{
                campaignList = [SELECT Id, Name,Campaign_Subsidiary__c FROM Campaign WHERE IsActive=true AND Campaign_Subsidiary__c =: companyName ORDER BY Name ASC LIMIT 500];
            }
        }
        return campaignList;
    }
    
    @AuraEnabled
    public static VisitZonesController.wrapper getAccountsWithTacticom() {
        Id currentUserId = UserInfo.getUserId();
        Date last7Days = Date.today().addDays(-7);
        Boolean hasRecentVisit = false;
        Date today = Date.today();
        
        List<Account> accountList = [SELECT Id, CHCUSTCLASSIFICATIONID__c, Last_Visit_date__c, Days_since_the_last_visit__c, Seiko_Network__c, Name, Tacticom_SOF__c, Segmentation_Net__c, Strategic_Value_Net_Sales__c, Total_Visits_Planned__c, LastModifiedDate, Lenses_Net_Sales_Last_12Mo__c, 
                                     (SELECT Id, Assigned_to__c, Visit_Status__c, Start_Day__c, Visit_assigned_to__c  
                                      FROM Visits__r 
                                      WHERE Start_Day__c >= :last7Days 
                                      AND Start_Day__c <= :today
                                      AND Visit_Status__c IN ('Planned', 'Complete') 
                                      AND Assigned_to__c = :currentUserId
                                      ORDER BY LastModifiedDate DESC) 
                                     FROM Account 
                                     WHERE Tacticom_SOF__c != NULL 
                                     AND RecordTypeId != :clinicRecordTypeId 
                                     AND Tacticom_SOF__c != 'Not Selected' 
                                     AND OwnerId = :currentUserId  
                                     ORDER BY Name ASC];
        
        //List<Account> accountList = [SELECT Id,CHCUSTCLASSIFICATIONID__c,Last_Visit_date__c,Days_since_the_last_visit__c,Seiko_Network__c,Name,Tacticom_SOF__c,Segmentation_Net__c,Strategic_Value_Net_Sales__c,Total_Visits_Planned__c,LastModifiedDate,Lenses_Net_Sales_Last_12Mo__c, (SELECT Id,Assigned_to__c, Visit_Status__c, Start_Day__c,Visit_assigned_to__c  FROM Visits__r WHERE Start_Day__c >= :last7Days AND Visit_Status__c IN ('Planned', 'Completed') ORDER BY LastModifiedDate DESC) FROM Account where Tacticom_SOF__c != NULL AND RecordTypeId != :clinicRecordTypeId AND Tacticom_SOF__c != 'Not Selected' AND OwnerId = :currentUserId  order by LastModifiedDate desc];
        //List<Account> accountList = [SELECT Id,CHCUSTCLASSIFICATIONID__c,Last_Visit_date__c,Days_since_the_last_visit__c,Seiko_Network__c,Name,Tacticom_SOF__c,Segmentation_Net__c,Strategic_Value_Net_Sales__c,Total_Visits_Planned__c,LastModifiedDate,Lenses_Net_Sales_Last_12Mo__c, (SELECT Id,Assigned_to__c, Visit_Status__c, Start_Day__c,Visit_assigned_to__c  FROM Visits__r WHERE Start_Day__c >= :last7Days AND Visit_Status__c IN ('Planned', 'Completed') ORDER BY LastModifiedDate DESC) FROM Account where Tacticom_SOF__c != NULL AND RecordTypeId != :clinicRecordTypeId AND Tacticom_SOF__c != 'Not Selected' order by LastModifiedDate desc];
        VisitZonesController.wrapper wrapperResponse = new VisitZonesController.wrapper();
        String objectName = 'Account';
        String fieldName ='Tacticom_SOF__c';
        Map<String, String> translatedPicklistValues = Utility.getTranslatedPicklistValues(objectName, fieldName);
        Map<String,Decimal> stageNameMap = new Map<String,Decimal>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(!stageNameMap.containsKey(pickListVal.getValue()) && pickListVal.getValue()!= 'Not Selected'){
                stageNameMap.put(pickListVal.getValue(), 0);
            }
        }
        Map<String,Decimal> visitWeightCountMap = new Map<String,Decimal>(stageNameMap);
        Map<String,Decimal> prospectCountMap = new Map<String,Decimal>(stageNameMap);
        List<String> accVisitMap = new List<String>();
        for(Account acc: accountList){
            if(stageNameMap.containsKey(acc.Tacticom_SOF__c)){
                Integer count = 0;
                plannedVisitsWeight = visitWeightCountMap.get(acc.Tacticom_SOF__c);
                count = integer.valueOf(stageNameMap.get(acc.Tacticom_SOF__c));
                stageNameMap.put(acc.Tacticom_SOF__c, ++count);
                visitWeightCountMap.put(acc.Tacticom_SOF__c, plannedVisitsWeight+acc.Total_Visits_Planned__c);
                if (acc.Lenses_Net_Sales_Last_12Mo__c <= 0 || acc.Lenses_Net_Sales_Last_12Mo__c == null) {
                    countOfProspects = prospectCountMap.get(acc.Tacticom_SOF__c);
                    prospectCountMap.put(acc.Tacticom_SOF__c, ++countOfProspects);
                }
            }
            for (Visits__c visit : acc.Visits__r) {
                if ((visit.Visit_Status__c == 'Complete' || visit.Visit_Status__c == 'Planned') && visit.Assigned_to__c == currentUserId) {
                    hasRecentVisit = true;
                    accVisitMap.add(acc.Id);
                }
            }
        }
        List<VisitZonesController.zoneObject> pickValList = new List<VisitZonesController.zoneObject>();
        for(String stage: stageNameMap.keySet()){
            VisitZonesController.zoneObject pickVal = new VisitZonesController.zoneObject();
            pickVal.zone = stage;
            pickVal.zoneTranslate = translatedPicklistValues.get(stage);
            pickVal.noRecords = integer.valueOf(stageNameMap.get(stage));
            pickVal.plannedVisitsWeight = integer.valueOf(visitWeightCountMap.get(stage));
            pickVal.totalProspects = integer.valueOf(prospectCountMap.get(stage));
            //pickVal.computedClass = getClassForZone(stage);
            pickVal.accVisMap = accVisitMap;
            pickValList.add(pickVal);
        }
        wrapperResponse.accountList = accountList;
        wrapperResponse.pickVals = pickValList;
        return wrapperResponse;
    }
    
    @AuraEnabled
    public static VisitZonesController.wrapper updateAccountStage(Id accountId, String newZone) {
        Account account = [SELECT Id, Tacticom_SOF__c FROM Account WHERE Id = :accountId LIMIT 1];
        account.Tacticom_SOF__c = newZone;
        update account;
        return VisitZonesController.getAccountsWithTacticom();
    }
    
    @AuraEnabled
    public static VisitZonesController.wrapper removeTacticomSOF(Id accountId) {
        try {
            Account acc = [SELECT Id, Tacticom_SOF__c FROM Account WHERE Id = :accountId LIMIT 1];
            acc.Tacticom_SOF__c = null;
            update acc;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to change Tacticom_SOF__c for the Account.');
        }
        return VisitZonesController.getAccountsWithTacticom();
    }
    
    
    @AuraEnabled
    public static filterData getFilteredAccounts(List<VisitPlanningV2Controller.MyRecordWrapper> selectedViewsFilter, Map<String, String> filterCriteria, String listViewName, String listDetails) {
        FilterData datawrap = new FilterData();
        datawrap.prospectCount = 0;
        Id userId = userInfo.getuserId();
        List<Account> alreadyAddedAccounts = [Select Id, Lenses_Net_Sales_Last_12Mo__c,Account_Status__c,Tacticom_SOF__c,RecordTypeId
                                                from Account where Tacticom_SOF__c != NULL AND Tacticom_SOF__c != 'Not Selected' AND ownerId = :userId AND RecordTypeId != :clinicRecordTypeId ORDER BY Name ASC];
        if(listViewName == '$Default'){
            datawrap.filteredAccounts = [Select Id,Hoya_Account_ID__c,Channel__c,Total_Visits_Planned__c,CurrencyIsoCode,sf_latitude__c,sf_longitude__c,name,
                                         Shop_Street__c,Shop_Postal_Code__c,Shop_State__c,Shop_Country__c,First_Competitor_local_name__c,
                                         Shop_City__c, Last_Visit_date__c, Total_Visits_Achieved__c, TACTICOM_SOF__c, Segmentation_Net__c, Visionary_Alliance__c, 
                                         Seiko_Network__c, Lenses_Net_Sales_Last_12Mo__c,Account_Status__c,Strategic_Value_Net_Sales__c
                                         from Account where (Tacticom_SOF__c = NULL OR Tacticom_SOF__c = 'Not Selected') AND ownerId = :userId AND RecordTypeId != :clinicRecordTypeId ORDER BY Name ASC];
        }
        else{
            datawrap.filteredAccounts = VisitPlanningV2Controller.fetchData(selectedViewsFilter,filterCriteria,listViewName,listDetails);
        }
        for(Account acc :  alreadyAddedAccounts){
            if (acc.Lenses_Net_Sales_Last_12Mo__c <= 0 || acc.Lenses_Net_Sales_Last_12Mo__c == null) {
                datawrap.prospectCount++;
            }
        }
        System.debug('datawrap'+datawrap);
        return datawrap;
    }
    
    public class wrapper{
        @AuraEnabled
        public List<Account> accountList = new List<Account>(); 
        @AuraEnabled
        public List<VisitZonesController.zoneObject> pickVals = new List<VisitZonesController.zoneObject>();
    }
    public class zoneObject{
        @AuraEnabled
        public String zone = '';
        @AuraEnabled
        public String zoneTranslate = '';
        @AuraEnabled
        public Integer noRecords = 0;
        @AuraEnabled
        public Integer plannedVisitsWeight = 0;
        @AuraEnabled
        public Integer totalProspects = 0;
        @AuraEnabled
        public String computedClass ='';
        @AuraEnabled
        public List<String> accVisMap =new List<String>();
    }
    
    public class FilterData{
        @AuraEnabled
        public List<Account> filteredAccounts;
        @AuraEnabled
        public Integer prospectCount;
    }
}