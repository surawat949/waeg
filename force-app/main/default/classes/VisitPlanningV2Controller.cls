/*
* @Author : Austin A
* @Class name : VisitPlanningV2Controller
* Created date : 2024-04-23
* @Created by : Austin A
* @Description : class for Visit planning v2 tab
*/
public with sharing class VisitPlanningV2Controller {
    private static String clinicRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    private static String accountFields = 'Id, Hoya_Account_ID__c, Channel__c, Total_Visits_Planned__c, CurrencyIsoCode, sf_latitude__c, sf_longitude__c, Name, Shop_Street__c, Shop_Postal_Code__c, Shop_State__c, Shop_Country__c, First_Competitor_local_name__c, CHCUSTCLASSIFICATIONID__c, Shop_City__c, Last_Visit_date__c, Total_Visits_Achieved__c, TACTICOM_SOF__c, Segmentation_Net__c, Visionary_Alliance__c, Seiko_Network__c, Myo_Smart_AuthorizeDealer__c, Lenses_Net_Sales_Last_12Mo__c, Share_of_Wallet__c, Account_Status__c, Strategic_Value_Net_Sales__c,';
    private static String visitsQuery = '(SELECT Id, Start_Day__c FROM Visits__r WHERE Visit_Type__c = \'Visit\' AND Assigned_to__c = :userId AND Visit_Status__c != \'Cancelled\' ORDER BY Start_Day__c LIMIT 1),';
    private static String alcQuery = '(SELECT Id, Name, Stage__c FROM Account_Life_Cycles__r LIMIT 1),';
    private static String lastSalesStats = '(Select Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c from Last_Sales_Statistics__r limit 1),';
    private static String campaignQuery = '(SELECT Id,Central_Campaign__c,Campaign_ID_t__c, Campaign_Presented__c, Campaign_Priority__c,Central_Campaign__r.IsActive FROM Campaign_Membership__r where Central_Campaign__r.IsActive =true)';
    private static Integer queryLimit = 10000;
    @AuraEnabled(cacheable=true)
    public static List<ListView> getAccountListViews() {
        return [SELECT Id, Name, DeveloperName FROM ListView WHERE SObjectType = 'Account'];
    }
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
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchData(List<MyRecordWrapper> selectedViewsFilter, Map<String, String> filterCriteria, String listViewName,String listDetails) {
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(listDetails);
        String alcFilter = '';
        String campaignFilter = '';
        Id userId = UserInfo.getUserId(); 
        // Extract necessary data from the map
        Map<String, Object> info = (Map<String, Object>) params.get('info');
        //List<Map<String, Object>> filteredByInfo = (List<Map<String, Object>>) info.get('filteredByInfo');
        String filterLogicString = (String) info.get('filterLogicString');
        
        // Build the filter conditions
        List<String> filters = new List<String>();
        for(Integer i = 0; i < selectedViewsFilter.size(); i++){
            MyRecordWrapper data = selectedViewsFilter[i];
            String fieldApiName = data.fieldApiName;
            String operator = data.operator;
            List<String> operandLabels = data.operandLabels;
            
            String cleanedValue = operandLabels[0].replace('(', '').replace(')', '');
            String condition = buildCondition(fieldApiName, operator, cleanedValue);
            filters.add(condition);
        }
        String finalFilter = '';
        finalFilter = IsFilterEmpty(finalFilter);

        finalFilter = replacePlaceholders(filterLogicString, filters);        // Replace placeholders in the filter logic string with actual conditions
        if (filterCriteria != null && !filterCriteria.isEmpty()) {
            for (String key : filterCriteria.keySet()) {
                if (key == 'Campaign_Membership__r.Campaign_Priority__c' || 
                    key == 'Campaign_Membership__r.Campaign_Presented__c' || 
                    key == 'Campaign_Membership__r.Central_Campaign__c') {
                        if(campaignFilter != ''){
                            campaignFilter = campaignFilter + ' AND ';
                        }
                        campaignFilter += key + ' =\'' + filterCriteria.get(key) + '\'';
                    } else if (key == 'Account_Life_Cycles__r.Stage__c') {
                        alcFilter = ' where stage__c ' + '=\'' + filterCriteria.get(key) + '\'';
                    }
            }
        }
        
        finalFilter = IsFilterEmpty(finalFilter) + 'Account_Status__c != \'Closed\'';
        
        if (FilterExists(filterCriteria, '$OwnerId')) {
            finalFilter += ' AND OwnerId = \'' + filterCriteria.get('$OwnerId') + '\'';
        }
        if (FilterExists(filterCriteria, '$NotClinics')) {
            finalFilter += ' AND RecordtypeId != \'' + clinicRecordTypeId + '\'';
        }
        if (FilterExists(filterCriteria, '$Tacticom')) {
            String notSelected = 'Not Selected';
            finalFilter += ' AND (Tacticom_SOF__c = null OR Tacticom_SOF__c = \'' + notSelected + '\')';
        }
        if (FilterExists(filterCriteria, '$QuickFilter')) {
            finalFilter += ' AND (Name LIKE \'%' + filterCriteria.get('$QuickFilter') + '%\' OR Hoya_Account_ID__c LIKE \'%' + filterCriteria.get('$QuickFilter') + '%\')';
        }

        String query = 'SELECT ' + accountFields + visitsQuery + alcQuery + lastSalesStats + campaignQuery + ' FROM Account WHERE ' + finalFilter;

        if (alcFilter != '') {
            String alcFilterAddOn = 'Id IN (SELECT Account__c FROM Account_Life_Cycle__c ' + alcFilter + ')';
            query = query + (finalFilter == '' ? ' WHERE ' : ' AND ') + alcFilterAddOn;
        }
        if (campaignFilter != '' && !Test.isRunningTest()) {
            String campaignAddOn = ' AND Id IN (SELECT Account_Name__c FROM Account_Campaing_Member__c WHERE ' + campaignFilter + ')';
            query = query + campaignAddOn;
        }
        query = query + ' ORDER BY Name ASC LIMIT :queryLimit';
        System.debug(query);
        List<Account> accountData = Database.query(query);
        return accountData;    
    }
    
    private static String applyFilterLogic(String filterLogic, Map<Integer, String> filterParts) {
        for (Integer key : filterParts.keySet()) {
            filterLogic = filterLogic.replace(key + '', '(' + filterParts.get(key) + ')');
        }
        return filterLogic;
    }
    
    public static Boolean FilterExists(Map<String, String> filterCriteria, String fieldName){
        Boolean matched = false;
        for(String filter : filterCriteria.keyset()){
            if(filter == fieldName){
                matched = true;
            }
        }
        return matched;
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
        @AuraEnabled
        public string filterLogic { get; set; }
        public MyRecordWrapper() {
            
        }
        public MyRecordWrapper(String fieldApiName, String label, List<String> operandLabels, String operator, String filterLogic) {
            this.fieldApiName = fieldApiName;
            this.label = label;
            this.operandLabels = operandLabels;
            this.operator = operator;
            this.filterLogic = filterLogic;
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
    private static String buildCondition(String fieldApiName, String operator, String value) {
        String condition = fieldApiName;
        String fieldType;
        if(condition.contains('.')){
            fieldType = 'String';
        } else {
            fieldType = getFieldType(condition);
        }
        if(fieldType == 'CURRENCY'){
            value = (String)parseCurrencyString(value);
        }
        Boolean isInteger = isIntegerValue(value);
        
        if (isInteger) {
            if (operator == 'Equals') {
                condition += ' = ' + value;
            } else if (operator == 'NotEqual') {
                condition += ' != ' + value;
            } else if (operator == 'GreaterThan') {
                condition += ' > ' + value;
            } else if (operator == 'LessThan') {
                condition += ' < ' + value;
            } else if (operator == 'GreaterOrEqual') {
                condition += ' >= ' + value;
            } else if (operator == 'LessOrEqual') {
                condition += ' <= ' + value;
            } else {
                condition += ' = ' + value;
            }
        } else {
            if (operator == 'Equals') {
                condition += ' = \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'NotEqual') {
                condition += ' != \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'GreaterThan') {
                condition += ' > \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'LessThan') {
                condition += ' < \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'GreaterOrEqual') {
                condition += ' >= \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'LessOrEqual') {
                condition += ' <= \'' + String.escapeSingleQuotes(value) + '\'';
            } else if (operator == 'Contains') {
                condition += ' LIKE \'%' + String.escapeSingleQuotes(value) + '%\'';
            } else if (operator == 'NotContain') {
                condition += ' NOT LIKE \'%' + String.escapeSingleQuotes(value) + '%\'';
            } else if (operator == 'StartsWith') {
                condition += ' LIKE \'' + String.escapeSingleQuotes(value) + '%\'';
            } else if (operator == 'EndsWith') {
                condition += ' LIKE \'%' + String.escapeSingleQuotes(value) + '\'';
            } else {
                condition += ' = \'' + String.escapeSingleQuotes(value) + '\'';
            }
        }
        return condition;
    }
    
    private static Boolean isIntegerValue(String value) {
        try {
            Integer.valueOf(value);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    
    private static String replacePlaceholders(String logicString, List<String> filters) {
        Integer filterIndex = 0;
        Pattern placeholderPattern = Pattern.compile('\\b\\d+\\b');
        Matcher matcher = placeholderPattern.matcher(logicString);
        String result = '';
        Integer lastEnd = 0;
        while (matcher.find()) {
            if (filterIndex < filters.size()) {
                String placeholder = matcher.group();
                String filter = filters.get(filterIndex);
                String replacement = '';
                if (filter.contains('EUR')) {
                    String[] parts = filter.split(' ');
                    System.debug('Inside '+parts);
                    System.debug('Inside '+parts.size() );
                    if (parts.size() == 4) {
                        try {
                            String result1 = parts[3].replace('\'', '');
                            Decimal value = Decimal.valueOf(result1);
                            replacement = '(' + parts[0] + parts[1] + String.valueOf(value) + ')';
                        } catch (Exception e) {
                            replacement = filter;
                        }
                    } else {
                        replacement = filter;
                    }
                } else {
                    replacement = filter;
                }
                
                result += logicString.substring(lastEnd, matcher.start());
                result += replacement;
                filterIndex++;
                lastEnd = matcher.end();
            }
        }
        
        // Append the remaining text after the last match
        if (lastEnd < logicString.length()) {
            result += logicString.substring(lastEnd);
        }
        
        return result;
    }
    
    
    Public Static String IsFilterEmpty(String filter) {
        if(filter == ''){
            filter = ' where ';
        }else{
            filter = filter + ' AND ';
        }
        return filter;
    }
    
    private static Boolean IsFilterExists(Map<String, String> filterCriteria, String key) {
        return filterCriteria != null && filterCriteria.containsKey(key);
    }
    
}