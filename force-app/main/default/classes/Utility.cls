public without sharing class Utility {
    
    private static final String Task_Status_SFDC_V2 = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
    
    // method to send email with template name
    public static void sendEmailWithTemplate(String template_name,Id obj_id, String from_address){
        EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName =: template_name LIMIT 1];
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: from_address];
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        //set object Id
        singleMail.setTargetObjectId(obj_id);
        singleMail.setWhatId(obj_id);
        System.debug('owea ID:'+ owea.get(0).Id);
        if (owea.size() > 0) {
            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        //set template Id
        System.debug('et ID:'+ et.Id);
        singleMail.setTemplateId(et.Id);
        //flag to false to stop inserting activity history
        singleMail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleMail });
    }

    // method to send email with template name
    public static Messaging.SingleEmailMessage buildMailMessage(String template_name,Id obj_id, String from_address){
        EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName =: template_name LIMIT 1];
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: from_address];
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        //set object Id
        singleMail.setTargetObjectId(obj_id);
        singleMail.setWhatId(obj_id);
        if (owea.size() > 0) {
            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        //set template Id
        singleMail.setTemplateId(et.Id);
        //flag to false to stop inserting activity history
        singleMail.setSaveAsActivity(false);
        return singleMail;
    }

    // Get labels from custom metadata type
    public static map<String, Community_label_settings__mdt> getCommunitiesLabel(){
        Map<String,Community_label_settings__mdt> mapCommunityLabel = new Map<String,Community_label_settings__mdt>();
        
        for(Community_label_settings__mdt cLabel : [SELECT Id,MasterLabel,DeveloperName,Label_Contact__c,Label_Forgot_Password__c,Label_Help__c,Label_login__c,
                                                            Label_No_Account__c,Label_password__c,Label_Remember_Me__c,Label_username__c,Label_Fill_in_Credentials__c,
                                                            Label_Use_Service_Provider__c,Language__c,Label_Welcome__c,Label_Description__c,Label_Description_1__c,
                                                            Label_Create_Account__c,Label_Seiko_Login__c,Help_URL__c,Contact_Us_URL__c,No_Account_URL__c, Label_Login_Failed__c,
                                                            Privacy_URL__c,Term_Of_Use_URL__c,Label_Terms__c,Label_Privacy__c
                                                              
                                                    FROM Community_label_settings__mdt]){
            mapCommunityLabel.put(cLabel.Language__c,cLabel);
        }

        return mapCommunityLabel;
    }

     public static String getMonthShortName(Integer monthNumber) {
        if (monthNumber == null || monthNumber < 1 || monthNumber > 12) {
            return null; // or handle invalid input as appropriate
        }

        List<String> monthShortNames = new List<String>{
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',
            'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
        };
        return monthShortNames[monthNumber - 1];
    }
     // Get Settings from community setting metadata
     public static map<String, Community_Setting__mdt> getCommunitiesSettings(){
        Map<String,Community_Setting__mdt> mapCommunitySetting = new Map<String,Community_Setting__mdt>();
        
        for(Community_Setting__mdt cSetting : [SELECT Id,MasterLabel,DeveloperName,Value__c
                                                    FROM Community_Setting__mdt]){
            mapCommunitySetting.put(cSetting.DeveloperName,cSetting);
        }

        return mapCommunitySetting;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValue(String ObjectApi_name,String Field_name){ 

        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        
        return lstPickvals;
    }
    
    public static Map<String,List<option>> getPicklistValuesbyMap(Map<String,String> objFieldMap){ 
        System.debug('objFieldMap'+objFieldMap);
        Map<String,List<option>> fieldValuesMap = new Map<String,List<option>>();
         for(String fieldName : objFieldMap.Keyset()){
             String objName = objFieldMap.get(fieldName);
             Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objName);
             Sobject Object_name = targetType.newSObject();
             Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
             Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //desc
             Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
             List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
             List<option> optList = new List<Option>();
             for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                 option opt = new option();
                 opt.label = a.getLabel();
                 opt.value = a.getValue();
                 optList.add(opt);
             }
             fieldValuesMap.put(fieldName,optList);
         }
         return fieldValuesMap;
    }
    
    /***********************************************************
     * Method Name: getTranslatedPicklistValues
     * Description: This method retrieves the translated picklist values for a specified field 
     *              of a given object in Salesforce. It returns a map where each entry's key 
     *              is the picklist value and the value is the translated label of that picklist value.
     * Parameters:
     *    @param objectName - The API name of the Salesforce object (e.g., 'Account', 'Contact').
     *    @param fieldName - The API name of the picklist field on the specified object.
     * Returns:
     *    @return Map<String, String> - A map containing picklist values and their corresponding 
     *                                  translated labels.
    ************************************************************/
    public static Map<String, String> getTranslatedPicklistValues(String objectName, String fieldName) {
        Map<String, String> translatedValues = new Map<String, String>();
    
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
        if (sObjectType != null) {
            Schema.DescribeSObjectResult sObjectResult = sObjectType.getDescribe();
            Map<String, Schema.SObjectField> fields = sObjectResult.fields.getMap();
            Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
    
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry entry : picklistEntries) {
                String value = entry.getValue();
                String label = entry.getLabel();
                translatedValues.put(value, label);
            }
        }
    
        return translatedValues;
    }

    
    @AuraEnabled(cacheable=true)
    public static string getTaskSFDCStandardTask(){
        String Task_Status_SFDC = Task_Status_SFDC_V2;
        return Task_Status_SFDC;
    }
    @AuraEnabled(cacheable=true)
    public static List<AccountRelatedSales> getConsolidatedAccountsList(String localConsolidationKey,String ownerCompany,String type){
        List<AccountRelatedSales> relatedAccountList =new List<AccountRelatedSales>(); 
        Map<Id,Account> accIdMap = new Map<Id,Account>();
        if(localConsolidationKey != null){
            List<Id> accountIdList =new List<Id>();
            List<Account> accs = [select Id,Hoya_Account_ID__c,Name from Account where Local_Consolidation_Key__c=:localConsolidationKey and Account_Owner_Company__c =:ownerCompany];
            System.debug(accs);
            for(Account acc:accs){
                accountIdList.add(acc.Id);
                accIdMap.put(acc.Id,acc);
            }
            Map<Id,Last_Sales_Statistics__c> accountSalesMap = new Map<Id,Last_Sales_Statistics__c>();
            List<Last_Sales_Statistics__c> lastSalesLst = [select Account__c,Hoya_Account_Id__c,Lenses_Net_Sales_CFY__c,Lenses_Gross_Sales_CFY__c,Lenses_Net_Sales_LFY_YTD__c,Lenses_Gross_Sales_LFY_YTD__c,Lenses_Net_Sales_CFY_vs_LFY_YTD__c,Lenses_Gross_Sales_CFY_vs_LFY_YTD__c,Lenses_Qty_CFY__c,Lenses_Qty_LFY_YTD__c,Lenses_Qty_CFY_vs_LFY_YTD__c from Last_Sales_Statistics__c where Account__c in :accountIdList];
            if(lastSalesLst.size() > 0){  
                for(Last_Sales_Statistics__c sale:lastSalesLst){
                    accountSalesMap.put(sale.Account__c,sale);
                }
            }
            AccountRelatedSales totalSales = new AccountRelatedSales();
            totalSales.salesCFY = 0;
            totalSales.salesLFYYTD = 0;
            totalSales.volumesCFY = 0;
            totalSales.volumesLFYYTD = 0;
            for(Id account:accountIdList){
                AccountRelatedSales relatedSales=new AccountRelatedSales();
                relatedSales.AccountId = account ;
                relatedSales.hoyaAccountId = accIdMap.get(account)?.Hoya_Account_ID__c;
                if(accountSalesMap.size() > 0 && accountSalesMap.containskey(account)){
                    relatedSales.volumesLFYYTD =  accountSalesMap.get(account).Lenses_Qty_LFY_YTD__c;                  
                    relatedSales.volumesCFY =  accountSalesMap.get(account).Lenses_Qty_CFY__c;
                    relatedSales.variationVolumes = accountSalesMap.get(account).Lenses_Qty_CFY_vs_LFY_YTD__c;
                    if(type == 'Net'){
                        relatedSales.salesCFY = accountSalesMap.get(account).Lenses_Net_Sales_CFY__c;
                        relatedSales.salesLFYYTD = accountSalesMap.get(account).Lenses_Net_Sales_LFY_YTD__c;
                        relatedSales.variationSales = accountSalesMap.get(account).Lenses_Net_Sales_CFY_vs_LFY_YTD__c;
                        totalSales.salesCFY +=  accountSalesMap.get(account).Lenses_Net_Sales_CFY__c;
                        totalSales.salesLFYYTD += accountSalesMap.get(account).Lenses_Net_Sales_LFY_YTD__c;
                    }
                    else{
                        relatedSales.salesCFY = accountSalesMap.get(account).Lenses_Gross_Sales_CFY__c;
                        relatedSales.salesLFYYTD = accountSalesMap.get(account).Lenses_Gross_Sales_LFY_YTD__c;
                        relatedSales.variationSales = accountSalesMap.get(account).Lenses_Gross_Sales_CFY_vs_LFY_YTD__c;
                        totalSales.salesCFY +=  accountSalesMap.get(account).Lenses_Gross_Sales_CFY__c;
                        totalSales.salesLFYYTD += accountSalesMap.get(account).Lenses_Gross_Sales_LFY_YTD__c;
                    }               
                    totalSales.volumesCFY += accountSalesMap.get(account).Lenses_Qty_CFY__c;
                    totalSales.volumesLFYYTD += accountSalesMap.get(account).Lenses_Qty_LFY_YTD__c;                    
                }
                else{
                    relatedSales.salesCFY = 0;
                    relatedSales.salesLFYYTD = 0;
                    relatedSales.variationSales = 0;
                    relatedSales.volumesLFYYTD  = 0;                 
                    relatedSales.volumesCFY  = 0;
                    relatedSales.variationVolumes  = 0;                        
                }
                relatedAccountList.add(relatedSales);                                    
            }
            if(totalSales.salesLFYYTD != 0 )
                totalSales.variationSales=(( totalSales.salesCFY- totalSales.salesLFYYTD)/ totalSales.salesLFYYTD)*100;
            else
                totalSales.variationSales=0;
            
            if(totalSales.volumesLFYYTD != 0){
                totalSales.variationVolumes =((totalSales.volumesCFY-totalSales.volumesLFYYTD)/totalSales.volumesLFYYTD)*100;
            }
            else
                totalSales.variationVolumes = 0;
            totalSales.AccountId = null;
            totalSales.hoyaAccountId = null;
            relatedAccountList.add(totalSales);
        }  
        return relatedAccountList;
    }
    // Generic method to query Records
	public static List<SObject> queryRecords(String query, Map<String,Object> bindParams, String additionalConditions, String orderBy) {

        if (!String.isBlank(additionalConditions)) {
            if(!query.contains(' WHERE ')){
                query += ' WHERE ';
            }
            query += additionalConditions;
        }

        // Add order by clause if provided
        if (orderBy != null && !String.isBlank(orderBy)) {
            query += ' ORDER BY ' + orderBy;
        }
        
        System.debug('Generated Query'+query);
        
         // Execute the query with or without binds
        if (!bindParams.isEmpty()) {
            return Database.queryWithBinds(query, bindParams, AccessLevel.SYSTEM_MODE);
        } else {
            return Database.query(query);
        }
    } //Wrapper class to store Related Account details 
    public class AccountRelatedSales{
        public AccountRelatedSales(){}
        @AuraEnabled public double salesCFY{get;set;}
        @AuraEnabled public double salesLFYYTD{get;set;}
        @AuraEnabled public double variationSales{get;set;}
        @AuraEnabled public double volumesCFY{get;set;}        
        @AuraEnabled public double volumesLFYYTD{get;set;}
        @AuraEnabled public double variationVolumes{get;set;}
        @AuraEnabled public Id AccountId{get;set;}
        @AuraEnabled public String hoyaAccountId{get;set;}
    }
    
    public class option{
        @AuraEnabled
        public string label{get;set;}
        @AuraEnabled
        public string value{get;set;}
    }
    /***********************************************************
     * Method Name: isFirstLoginOfDay
     * Description: This method returns true if the user is logging for the first time
     *              for the day so that a reminder can be shown on UI 
     * Return:
     *    Boolean - The method will return true if the user is logging in for the first time that day
     *              Returns false if the User has already logged into the system
    ************************************************************/
    @AuraEnabled(cacheable=true)
    public static Boolean isFirstLoginOfDay() {
        DateTime now = DateTime.now();// 22-07-2024 14:00:00
        Date currentDate = Date.today();// 22-07-2024 00:00:00
        //DateTime todayStart = DateTime.newInstanceGmt(currentDate.year(), currentDate.month(), currentDate.day(), 0, 0, 0);

        List<LoginHistory> logins = [
            SELECT LoginTime
            FROM LoginHistory
            WHERE UserId = :UserInfo.getUserId() 
            AND LoginTime >= :currentDate 
            AND LoginTime <= :now
            ORDER BY LoginTime DESC
        	LIMIT 1
        ];
        // If there are no logins for today, this is the first login of the day
        if (logins.isEmpty()) {
            return false;
        }
        
        // Get the last login time
        DateTime lastLoginTime = logins[0].LoginTime;
        
        // Check if the last login was within the last minute
        if (lastLoginTime > now.addMinutes(-1)) {
            return false; // It's the first login of the day
        }
        
        return false; // The modal should not be displayed again
    }
    
}