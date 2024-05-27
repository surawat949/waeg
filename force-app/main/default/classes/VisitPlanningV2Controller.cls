/*
* @Author : Austin A
* @Class name : VisitPlanningV2Controller
* Created date : 2024-04-23
* @Created by : Austin A
* @Description : class for Visit planning v2 tab
*/
public with sharing class VisitPlanningV2Controller {
    @AuraEnabled(cacheable=true)
    public static List<ListView> getAccountListViews() {
        return [SELECT Id, Name, DeveloperName FROM ListView WHERE SObjectType = 'Account'];
    }
    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaignOptions(String showCampaign) {
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
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchData(List<MyRecordWrapper> selectedViewsFilter, Map<String, String> filterCriteria) {
        
        String filter = '';
        for(MyRecordWrapper data : selectedViewsFilter){
            String input = data.operandLabels[0];
            String cleanedValue = input.replace('(', '').replace(')', '');
            if(filter != ''){
                filter = filter + ' AND ';
            }else{
                filter = 'where ';
            }
            if(data.operator != 'NotContain'){
                filter = filter + data.fieldApiName;   
            }
            String fieldType ;
            if(data.fieldApiName.contains('.')){
                fieldType = 'String';
            }else{
                fieldType = getFieldType(data.fieldApiName);
            }
            if(fieldType == 'CURRENCY'){
                cleanedValue = (String)parseCurrencyString(cleanedValue);
            }
            if(data.operator == 'StartsWith' || data.operator == 'EndsWith' || data.operator == 'Contains'){
                filter = filter + ' like \'%' +String.escapeSingleQuotes(cleanedValue)+'%\'';
            }
            if(data.operator == 'NotContain'){
                filter = filter + ' (Not ( '+data.fieldApiName +' like \'%' +String.escapeSingleQuotes(cleanedValue)+'%\'))';
            }
            if(data.operator == 'Equals' && fieldType != 'BOOLEAN'){
                filter = filter + '=\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }else If(data.operator == 'Equals' && fieldType == 'BOOLEAN'){
                if(cleanedValue == '1'){
                    filter = filter + '= TRUE';
                }else{
                    filter = filter + '= FALSE';
                }
            }
            if(data.operator == 'GreaterThan' && fieldType != 'String'){
                filter = filter + ' > ' +String.escapeSingleQuotes(cleanedValue);
            }
            if(data.operator == 'GreaterThan' && fieldType == 'String')
            {
                filter = filter + ' <\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }
            if(data.operator == 'LessThan' && fieldType != 'String'){
                filter = filter + ' < ' +String.escapeSingleQuotes(cleanedValue);
            }
            if(data.operator == 'LessThan' && fieldType == 'String'){
                filter = filter + ' <\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }
            if(data.operator == 'NotEqual' && fieldType == 'String'){
                filter = filter + ' !=\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }
            if(data.operator == 'NotEqual' && fieldType != 'String'){
                filter = filter + ' !=' +String.escapeSingleQuotes(cleanedValue);
            }
            if(data.operator == 'LessOrEqual' && fieldType == 'String'){
                filter = filter + ' <=\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }
            if(data.operator == 'LessOrEqual' && fieldType != 'String'){
                filter = filter + ' <=' +String.escapeSingleQuotes(cleanedValue);
            }
            if(data.operator == 'GreaterOrEqual' && fieldType == 'String'){
                filter = filter + ' >=\'' +String.escapeSingleQuotes(cleanedValue)+'\'';
            }
            if(data.operator == 'GreaterOrEqual' && fieldType != 'String'){
                filter = filter + ' <=' +String.escapeSingleQuotes(cleanedValue);
            }
        }
        Id userId = UserInfo.getUserId(); 
        if (filterCriteria != null && !filterCriteria.isEmpty()) {
            System.debug('Inside loop');
            for (String key : filterCriteria.keySet()) {
                if(filter != ''){
                    filter = filter + ' AND ';
                }else{
                    filter = 'where ';
                }
                if(key == 'Campaign_Membership__r.Campaign_Priority__c'){
                    filter += key + ' = ' + filterCriteria.get(key);
                }else if(key == 'Campaign_Membership__r.Campaign_Presented__c'){
                    filter += key + ' = ' + filterCriteria.get(key);
                }else{
                    filter += key + ' Like \'' + filterCriteria.get(key) + '%\' ';
                }
            }
        }
        Integer queryLimit = Limits.getLimitQueryRows() - Limits.getQueryRows();
        String fields ='id,Total_Visits_Planned__c,sf_latitude__c,(select id,Start_Day__c from Visits__r WHERE Visit_Type__c =\'Visit\' AND Assigned_to__c=:userId AND Visit_Status__c!=\'Cancelled\' '+'ORDER BY Start_Day__c limit 1) , sf_longitude__c,name,(Select id,Name,stage__c from Account_Life_Cycles__r),(Select Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c from Last_Sales_Statistics__r),(SELECT Id,Central_Campaign__c,Campaign_ID_t__c, Campaign_Presented__c, Campaign_Priority__c,Central_Campaign__r.IsActive FROM Campaign_Membership__r where Central_Campaign__r.IsActive =true),Shop_Street__c,Shop_Postal_Code__c,Shop_State__c,Shop_Country__c,First_Competitor_local_name__c,CHCUSTCLASSIFICATIONID__c,Shop_City__c, Last_Visit_date__c, Total_Visits_Achieved__c, TACTICOM_SOF__c, Segmentation_Box__c, Visionary_Alliance__c, Seiko_Network__c, Myo_Smart_AuthorizeDealer__c, Lenses_Net_Sales_Last_12Mo__c, Share_of_Wallet__c';
        String query = 'Select '+fields+' from account '+filter +' ORDER BY name ASC Limit :queryLimit';
        System.debug(query);
        List<Account> accountData = Database.query(query);
        return accountData;
    }
    public class MyRecordWrapper {
        @AuraEnabled
        public String fieldApiName { get; set; }
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public List<String> operandLabels { get; set; }
        @AuraEnabled
        public String operator { get; set; }
        public MyRecordWrapper() {
        
    	}
        public MyRecordWrapper(String fieldApiName, String label, List<String> operandLabels, String operator) {
            this.fieldApiName = fieldApiName;
            this.label = label;
            this.operandLabels = operandLabels;
            this.operator = operator;
        }
    }
    public static string getFieldType(String fieldApiName){
        Schema.DescribeSObjectResult accountDescribe = Account.sObjectType.getDescribe();
        Schema.DescribeFieldResult fieldDescribe = accountDescribe.fields.getMap().get(fieldApiName).getDescribe();
        String fieldType = fieldDescribe.getType().name();
        if(fieldType == 'PICKLIST'){
            fieldType = 'String';
        }
        return fieldType;
    }
    public static String parseCurrencyString(String currencyString) {
        String numericString = currencyString.replaceAll('[^0-9]', '');
        return numericString;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,List<String>> getPicklistValues() {
        Map<String,List<String>> dataMap = new Map<String,List<String>>();
        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        Schema.SObjectType accountLifeCycleType = Schema.getGlobalDescribe().get('Account_Life_Cycle__c');
        Schema.DescribeSObjectResult accountDescribe = accountType.getDescribe();
        Schema.DescribeSObjectResult accountLifeCycleDescribe = accountLifeCycleType.getDescribe();
        Schema.DescribeFieldResult fieldDescribeTacticom = accountDescribe.fields.getMap().get('TACTICOM_SOF__c').getDescribe();
        Schema.DescribeFieldResult fieldDescribeLoyalty = accountDescribe.fields.getMap().get('Seiko_Network__c').getDescribe();
        Schema.DescribeFieldResult fieldDescribeStage = accountLifeCycleDescribe.fields.getMap().get('Stage__c').getDescribe();
        
        List<String> picklistValuesTacticom = new List<String>();
        picklistValuesTacticom.add('No Filter');
        for (Schema.PicklistEntry entry : fieldDescribeTacticom.getPicklistValues()) {
            picklistValuesTacticom.add(entry.getLabel());
        }
        List<String> picklistValuesOneLoyalty = new List<String>();
        picklistValuesOneLoyalty.add('No Filter');
        for (Schema.PicklistEntry entry : fieldDescribeLoyalty.getPicklistValues()) {
            picklistValuesOneLoyalty.add(entry.getLabel());
        }
        List<String> picklistValuesStage = new List<String>();
        picklistValuesStage.add('No Filter');
        for (Schema.PicklistEntry entry : fieldDescribeStage.getPicklistValues()) {
            picklistValuesStage.add(entry.getLabel());
        }
        dataMap.put('Tacticom',picklistValuesTacticom);
        dataMap.put('Loyalty',picklistValuesOneLoyalty);
        dataMap.put('Stage',picklistValuesStage);
        return dataMap;
    }
}