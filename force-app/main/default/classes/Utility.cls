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

}