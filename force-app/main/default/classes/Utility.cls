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
        if (owea.size() > 0) {
            singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        //set template Id
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
	
	@AuraEnabled(cacheable=true)
    public static string getTaskSFDCStandardTask(){
        String Task_Status_SFDC = Task_Status_SFDC_V2;
        return Task_Status_SFDC;
    }
    @AuraEnabled(cacheable=true)
    public static List<AccountRelatedSales> getConsolidatedAccountsList(String localConsolidationKey,String ownerCompany,String type){
        List<AccountRelatedSales> relatedAccountList =new List<AccountRelatedSales>(); 
        Map<Id,String> hoyaAccIdMap = new Map<Id,String>();
        if(localConsolidationKey != null){
            List<Id> accountIdList =new List<Id>();
            List<Account> accs = [select Id,Hoya_Account_ID__c from Account where Local_Consolidation_Key__c=:localConsolidationKey and Account_Owner_Company__c =:ownerCompany];
            System.debug(accs);
            for(Account acc:accs){
                accountIdList.add(acc.Id);
                hoyaAccIdMap.put(acc.Id,acc.Hoya_Account_ID__c);
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
                relatedSales.hoyaAccountId = hoyaAccIdMap.get(account);
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
      //Wrapper class to store Related Account details 
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
    

}