/*
* @Author : Austin A
* @Class name : VisitPlanningV2Controller
* Created date : 2024-04-23
* @Created by : Austin A
* @Description : class for Visit planning v2 tab
*/
public with sharing class VisitPlanningV2Controller {
    private static String clinicRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    private static String accountFields = 'Id, Hoya_Account_ID__c, Channel__c, Total_Visits_Planned__c, CurrencyIsoCode, sf_latitude__c, sf_longitude__c, Name, Shop_Street__c, Shop_Postal_Code__c, Shop_State__c, Shop_Country__c, First_Competitor_local_name__c, CHCUSTCLASSIFICATIONID__c, Shop_City__c, Last_Visit_date__c, Total_Visits_Achieved__c, TACTICOM_SOF__c, Segmentation_Net__c, Visionary_Alliance__c, Seiko_Network__c, Myo_Smart_AuthorizeDealer__c, Lenses_Net_Sales_Last_12Mo__c, Share_of_Wallet__c, Account_Status__c, Strategic_Value_Net_Sales__c, Visit_Frequency_Status__c, Visits_performed__c, Last_Digital_Visit_Date__c, Total_Visits_Performed__c, ';
    private static String visitsQuery = '(SELECT Id, Start_Day__c FROM Visits__r WHERE Visit_Type__c = \'Visit\' AND Assigned_to__c = :userId AND Visit_Status__c != \'Cancelled\' ORDER BY Start_Day__c DESC LIMIT 1),';
    private static String alcQuery = '(SELECT Id, Name, Stage__c FROM Account_Life_Cycles__r LIMIT 1),';
    private static String lastSalesStats = '(Select Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c from Last_Sales_Statistics__r limit 1),';
    private static String campaignQuery = '(SELECT Id,Central_Campaign__c,Campaign_ID_t__c, Campaign_Presented__c, Campaign_Priority__c,Central_Campaign__r.IsActive FROM Campaign_Membership__r where Central_Campaign__r.IsActive =true)';
    private static Integer queryLimit = 10000;
    @AuraEnabled(cacheable=true)
    public static List<ListView> getAccountListViews() {
        return [SELECT Id, Name, DeveloperName FROM ListView WHERE SObjectType = 'Account' AND NAME LIKE 'SFDC V2%'];
    }
    /*
    *********************************************************
        @Method Name    : getCampaignOptions
        @author         : Austin A
        @description    : method is used to fetch campigns which the User has access to
        @param          : showCampaign	-> Flag to hide the campaign on UI
        @return         : List of Campaign
    ********************************************************
    */
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
    /*
    *********************************************************
        @Method Name    : fetchData
        @author         : Austin A
        @description    : method to is used to generate Query to fetch records for VPM v2 & Visit Zones
        @param          : selectedViewsFilter	-> Filters set in the list view
						  filterCriteria		-> Filters chosen by User on UI
						  listViewName			-> Name of the selected list view
						  listDetails			-> Completed details of the Selected List view
        @return         : List of accounts
    ********************************************************
    */
    @AuraEnabled
    public static List<Account> fetchData(List<MyRecordWrapper> selectedViewsFilter, Map<String, String> filterCriteria, String listViewName,String listDetails) {
        Map<String, Object> params = new Map<String, Object>();
        Map<String, Object> info = new Map<String, Object> ();
        String alcFilter = '';
        String campaignFilter = '';
        String filterLogicString = '';
        String filterScope = '';
        Map<String, Object> recordScope = new Map<String, Object> ();
        Id userId = UserInfo.getUserId(); 
        //Below if portion checks the listDetails JSON and fetches
        // 1) filterLogicString for custom filters mentioned in list views
        // 2) Scope array which hold whether the filter for accounts is All account or My accounts or My team accounts
        if(listDetails != '' && listDetails != null){
            params = (Map<String, Object>) JSON.deserializeUntyped(listDetails);
            filterLogicString = params?.get('filterLogicString') != null ? (String) params.get('filterLogicString') : '';//(1 And 2)
            recordScope = params?.get('scope') != null ? (Map<String, Object>) params.get('scope') : new Map<String, Object>();
            filterScope = recordScope?.get('apiName') != null ? (String) recordScope.get('apiName') : '';
        }
        
        // Build the filter conditions
        List<String> filters = new List<String>();
        for(Integer i = 0; i < selectedViewsFilter.size(); i++){
            MyRecordWrapper data = selectedViewsFilter[i];
            String fieldApiName = data.fieldApiName;
            String operator = data.operator;
            List<String> operandLabels = data.operandLabels;
            List<String> inputOne = data.operandLabels;
            String cleanedValue = '',condition ='';
            if(inputOne.size() > 1) {
                List<String> conditions = new List<String>();
                for(String input : inputOne) {
                    cleanedValue = input.replace('(', '').replace(')', '');
                    conditions.add(buildCondition(fieldApiName, operator, cleanedValue));// seg = A1
                }
                condition = '(' + String.join(conditions, ' OR ') + ')';
                filters.add(condition);
            }else{
                cleanedValue = operandLabels[0].replace('(', '').replace(')', '');
                condition = buildCondition(fieldApiName, operator, cleanedValue);// This method call generates the filter for the query
                filters.add(condition);
            }
            
        }
        String finalFilter = '';
        if(selectedViewsFilter.size() > 0){
            if(filterLogicString != null && filterLogicString !=''){
            	finalFilter = replacePlaceholders(filterLogicString, filters) +' AND ';// Replace placeholders in the filter logic string with actual conditions    
            }else{
                For(String filter : filters){
                    finalFilter = finalFilter + filter + ' AND ';
                }
            }
        }
		//Generates filter for Campaign_Priority__c,Campaign_Presented__c, choosen Central_Campaign__c & lifecycle Stage__c
        if (filterCriteria != null && !filterCriteria.isEmpty()) {
            for (String key : filterCriteria.keySet()) {
                if(key == 'Campaign_Membership__r.Campaign_Priority__c'){
                    String fieldName = key.substringAfter('.');
                    if(campaignFilter != ''){
                        campaignFilter = campaignFilter + ' AND ';
                    }
                    campaignFilter += fieldName + ' = true';
                }else if(key == 'Campaign_Membership__r.Campaign_Presented__c'){
                    String fieldName = key.substringAfter('.');
                    if(campaignFilter != ''){
                        campaignFilter = campaignFilter + ' AND ';
                    }
                    campaignFilter += fieldName + ' = false';
                }else if(key == 'Campaign_Membership__r.Central_Campaign__c'){
                    String fieldName = key.substringAfter('.');
                    if(campaignFilter != ''){
                        campaignFilter = campaignFilter + ' AND ';
                    }
                    campaignFilter += fieldName + ' =\'' + filterCriteria.get(key)+'\'';
                }else if (key == 'Account_Life_Cycles__r.Stage__c') {
                    alcFilter = ' where stage__c ' + '=\'' + filterCriteria.get(key) + '\'';
                }else if(!key.contains('$')){
                    //Handles all Specific filters entered by User on VPM V2 & Visit Zones
                    finalFilter +=  key + ' Like \'' + filterCriteria.get(key) + '%\' AND ';
                }
            }
        }
        
        finalFilter = finalFilter +' Account_Status__c != \'Closed\'';
        String myTeamAccountFilter = '';
        //handles Conditions from Visit Zones Mainly
        //Few filters such as Account ownerhsip & Quick Filter is also Handled for VPM v2
        if (FilterExists(filterCriteria, '$OwnerId') || filterScope == 'mine') {
            finalFilter += ' AND OwnerId = \'' + userId + '\'';
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
		if (finalFilter != null && !finalFilter.toUpperCase().startsWith('WHERE')) {
            finalFilter = 'WHERE ' + finalFilter;
        }
        String query = 'SELECT ' + accountFields + visitsQuery + alcQuery + lastSalesStats + campaignQuery + ' FROM Account ' + finalFilter;
        if(filterScope == 'account_team'){
            myTeamAccountFilter = ' Id IN (SELECT AccountId FROM AccountTeamMember WHERE UserId = :userId)';
            query = query +' AND '+ myTeamAccountFilter;
        }
        if (alcFilter != '') {
            String alcFilterAddOn = 'Id IN (SELECT Account__c FROM Account_Life_Cycle__c ' + alcFilter + ')';
            query = query + (finalFilter == '' ? ' WHERE ' : ' AND ') + alcFilterAddOn;
        }
        if (campaignFilter != '' && !Test.isRunningTest()) {
            String campaignAddOn = ' AND Id IN (SELECT Account_Name__c FROM Account_Campaing_Member__c WHERE ' + campaignFilter + ')';
            query = query + campaignAddOn;
        }
        query = query + ' ORDER BY Name ASC LIMIT :queryLimit';
        System.debug('FinalQuery '+query);
        List<Account> accountData = Database.query(query);
        return accountData;    
    }
    /*
    *********************************************************
        @Method Name    : FilterExists
        @author         : Austin A
        @description    : method is used to Check if a filter has to be added to query
        @param          : fieldName			-> Field name which has to be checked
						  filterCriteria	-> Filters chosen by User on UI
        @return         : If it matches True, else False
    ********************************************************
    */
    public static Boolean FilterExists(Map<String, String> filterCriteria, String fieldName){
        Boolean matched = false;
        for(String filter : filterCriteria.keyset()){
            if(filter == fieldName){
                matched = true;
                break;
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
    /*
    *********************************************************
        @Method Name    : getFieldType
        @author         : Austin A
        @description    : method is used to Check the type of given field
        @param          : fieldApiName	-> Field name which has to be checked
        @return         : Type of field
    ********************************************************
    */
    public static string getFieldType(String fieldApiName){
        Schema.DescribeSObjectResult accountDescribe = Account.sObjectType.getDescribe();
        Schema.DescribeFieldResult fieldDescribe = accountDescribe.fields.getMap().get(fieldApiName).getDescribe();
        String fieldType = fieldDescribe.getType().name();
        if(fieldType == 'PICKLIST'){
            fieldType = 'String';
        }
        return fieldType;
    }
    //Parses curreny string which has account symbols or literals to only currency values
    public static String parseCurrencyString(String currencyString) {
        String numericString = currencyString.replaceAll('[^0-9,.]', '');
        return numericString;
    }
    /*
    *********************************************************
        @Method Name    : getPicklistValues
        @author         : Austin A
        @description    : method is used to fetch values for all combobox filters in UI
        @param          : NA
        @return         : Picklist values for all filter combo box on Visit Zones & Visit Planning
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,List<Utility.option>> getPicklistValues(List<Map<String, String>> objectFieldMap) {
        Map<String,String> objectFieldMapGenerated = new Map<String,String>();
        for (Map<String, String> item : objectFieldMap) {
             for (String fieldName : item.keySet()) {
                 String objectName = item.get(fieldName);
                objectFieldMapGenerated.put(fieldName,objectName);
            }
        }
        System.debug('objectFieldMapGenerated'+objectFieldMapGenerated);
         //Calling Utility method to get Picklist values for field,Objectname pair
        Map<String,List<Utility.option>> fieldValuesMap = Utility.getPicklistValuesbyMap(objectFieldMapGenerated);
        return fieldValuesMap;
    }
   
    /*
    *********************************************************
        @Method Name    : extractInteger
        @author         : Austin A
        @description    : Method used to Extract the 15.700,000 as 15700 to generate query
        @param          : value	-> Field name which has to be checked
        @return         : Integer value
    ********************************************************
    */
    public static String extractInteger(String value) {
        value = value.replace('"', '');
        String decimalSeparator = '.';
        String thousandSeparator = ',';
        if (value.contains(',') && value.contains('.') && (value.indexOf(',') > value.indexOf('.'))) { // Case where thousand separator is '.' and decimal separator is ','
            decimalSeparator = ',';
            thousandSeparator = '.';
        } else if (value.contains(' ') && value.contains(',') && !value.contains('.')) { // Case where thousand separator is ' ' and decimal separator is ','
            thousandSeparator = ' ';
            decimalSeparator = ',';
        } else if (value.contains(' ') && value.contains('.') && !value.contains(',')) { // Case where thousand separator is ' ' and decimal separator is '.'
            thousandSeparator = ' ';
            decimalSeparator = '.';
        } else if (value.contains(',') && !value.contains('.') && !value.contains(' ')) { // Case where thousand separator is ',' and decimal separator is not present
            thousandSeparator = '';
            decimalSeparator = ',';
        }
        value = value.replace(thousandSeparator, '');
        value = value.replace(' ', '');
        if (decimalSeparator != '') {
            List<String> parts = value.split(Pattern.quote(decimalSeparator));
            if (parts.size() > 0) {
                String integerPart = parts[0];
                return integerPart;
            }
        }
        return value;
    }
    /*
    *********************************************************
        @Method Name    : buildCondition
        @author         : Austin A
        @description    : method is used to create condition/filter in query
        @param          : condition -> field Name, operator -> (=,>,<,!=,etc), value -> Filter value
        @return         : Condition to be added to query
    ********************************************************
    */
    private static String buildCondition(String condition, String operator, String value) {
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
        if ((isInteger || fieldType == 'PERCENT' || fieldType == 'DOUBLE' || fieldType == 'CURRENCY') && fieldType != 'STRING') {
            if(fieldType == 'PERCENT' || fieldType == 'DOUBLE' || fieldType == 'CURRENCY'){
                value = extractInteger(value);
            }
            if (operator == 'Equals' && fieldType != 'BOOLEAN') {
                condition += ' = ' + value;
            } else If(operator == 'Equals' && fieldType == 'BOOLEAN'){
                if(value == '1'){
                    condition = condition + '= TRUE';
                }else{
                    condition = condition + '= FALSE';
                }
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
            if (operator == 'Equals' && fieldType != 'BOOLEAN') {
                if(condition == 'CreatedDate' && value == 'THIS WEEK'){
                        condition = condition + '> LAST_WEEK ';
                }else if(condition == 'CreatedDate' && value == 'THIS MONTH'){
                        condition = condition + '> THIS_MONTH ';
                }else{
                    condition += ' = \'' + String.escapeSingleQuotes(value) + '\'';
                }
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
                condition = ' (NOT '+ condition +' LIKE \'%' + String.escapeSingleQuotes(value) + '%\')';
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
    //checks is String value holds integer or string 
    private static Boolean isIntegerValue(String value) {
        try {
            Integer.valueOf(value);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
        //Place the filter in the custom filter logic sequence(ex 1 AND (2 OR 3) AND 4)
    public static String replacePlaceholders(String logicString, List<String> filters) {
        System.debug('filtersfortest '+filters);
        Integer filterIndex = 0;
        Pattern placeholderPattern = Pattern.compile('\\b\\d+\\b');//Ignore numbers in middle of field api
        Matcher matcher = placeholderPattern.matcher(logicString);
        String result = '';
        Integer lastEnd = 0;
        while (matcher.find()) {
            if (filterIndex < filters.size()) {
                // Get the placeholder
                String placeholder = matcher.group();
                // Get the filter condition from the filters list
                String replacement = '(' + filters.get(filterIndex) + ')';
                                // Append the text before the current placeholder
                result += logicString.substring(lastEnd, matcher.start());
                // Append the replacement
                result += replacement;
                filterIndex++;
                // Update the lastEnd to the end of the current match
                lastEnd = matcher.end();
            }
        }
        
        // Append the remaining text after the last match
        if (lastEnd < logicString.length()) {
            result += logicString.substring(lastEnd);
        }
        return result;
    }
    
}