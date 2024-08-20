public with sharing class SendRegistrationInvite_Controller {
    private static final String CONTACT_SRX_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('SRX_Contact').getRecordTypeId();

    @AuraEnabled
    public static string sendRegistrationInvite(String recordId){
        try {
            Contact c = [SELECT Id, Account_Portal__c,Account_Template__c,Email, Language_Pick__c,Registration_Invitation_Hash__c, Send_Registration_Email_Flag__c, RecordType.DeveloperName ,Invite_Portal_Email__c,HVNA_Type__c
                            FROM Contact 
                            WHERE Id = :recordId];
            // allowing SRX RT contact to send invite
            if ((c.RecordType.DeveloperName != WAEG_Constants.SHOP_OWNER_RT && c.RecordTypeId != CONTACT_SRX_RT) || String.isBlank(c.Registration_Invitation_Hash__c)) {
                return WAEG_Constants.NOT_SHOP_OWNER_OR_REGISTERED;
            }
            if (c.RecordTypeId == CONTACT_SRX_RT && c.HVNA_Type__c != 'Dispenser') {
                return 'Contact is not a Dispenser. Only Dispensers can be invited currently.';
            }
            if (String.isBlank(c.Email)) {
                return WAEG_Constants.EMAIL_NOT_FILLED_IN;
            }
            if (String.isBlank(c.Invite_Portal_Email__c)) {
                return WAEG_Constants.CHOOSE_PORTAL;
            }
            // allowing SRX RT contact to send invite without Account template
            if (c.RecordType.DeveloperName == WAEG_Constants.SHOP_OWNER_RT && (String.isBlank(c.Account_Portal__c) || c.Account_Template__c == null)) {
                return WAEG_Constants.PORTAL_OR_TEMPLATE_NULL;
            }
            /* else {
                c.Send_Registration_Email_Flag__c = false;
            }*/
            if(!c.Send_Registration_Email_Flag__c){
                Map<String,Assign_default_permissions__mdt> mapCommunicationEmail = new Map<String,Assign_default_permissions__mdt>();
                for(Assign_default_permissions__mdt comm : [SELECT Id, Account_Portal__c,From_Email_Address__c FROM Assign_default_permissions__mdt]){
                    mapCommunicationEmail.put(comm.Account_Portal__c,comm);
                }
                System.debug('Account portal'+c.Account_Portal__c);
                System.debug('Invite portal'+c.Invite_Portal_Email__c);
                String template;
                if(c.Account_Portal__c != null && c.Account_Portal__c.contains('seiko')){
                    template = 'SEIKO_Invitation_Email_ECP';
                }else if(c.Invite_Portal_Email__c == 'VA, HLC & Hoya Hub'){
                    template = 'Va_New_Employee_Registration';
                }else if(c.Invite_Portal_Email__c == 'HOYA Contact Lenses'){
                    template = 'Contact_Lenses_New_Employee_Registration';
                }else if(c.Invite_Portal_Email__c == 'HHP Canada') {
                    /*if (c.Language_Pick__c == 'fr-fr' || c.Language_Pick__c == 'fr-ca')
                    	template = 'Shop_owner_invitation_email_for_HHP_Fr';
					else*/
                    /* CDU 26/08/2021: language is now a parameter in template, email is using custom labels */
	                    template = 'Shop_owner_invitation_email_for_HHP';
                }
                //Canada Email Template -Mohan
                else if(c.Invite_Portal_Email__c == 'VI, HLC, Hoya Hub') {
                    template = 'VI_New_Employee_Registration';                    
                }
                //Costco Portal Email Template -Mohan
                else if(c.Invite_Portal_Email__c == 'Costco Portal') {  
                    template = 'Costco_New_Employee_Registration'; 	                    
                } else if(c.Account_Portal__c == 'exportportal' && c.Invite_Portal_Email__c == 'HOYA Learning Center') {
                    template = 'HLC_Registration_Export_Portal';    
                } else if (c.Invite_Portal_Email__c == 'SafeVision') {
                    template = 'New_Dispenser_Registration';
                } else {
                    template = 'New_Employee_Registration';
                }
                
                System.debug('template: '+template);
                String fromAddress = '';
                if(mapCommunicationEmail.get(c.Account_Portal__c) != null){
                    fromAddress = mapCommunicationEmail.get(c.Account_Portal__c).From_Email_Address__c;
                }else{
                    if(c.Invite_Portal_Email__c == WAEG_Constants.HOYA_LEARNING_CENTER && c.Language_Pick__c == 'en-za'){
                        fromAddress = mapCommunicationEmail.get('zaportal').From_Email_Address__c;
                    }else{
                        fromAddress = mapCommunicationEmail.get('usportal').From_Email_Address__c;
                    }
                }
                System.debug('from address:'+ fromAddress);
                Utility.sendEmailWithTemplate(template, c.Id, fromAddress);
                if (!c.Send_Registration_Email_Flag__c) {
                    c.Send_Registration_Email_Flag__c = true;
                }
                update c;
                LightningLoginFormController.sendEventToGA('', '', 'invitation', c.Id);
                return WAEG_Constants.REGISTRATION_EMAIL_SENT;
            }
            
            return WAEG_Constants.SEND_REGISTRATION_EMAIL_FLAG;
        } catch (Exception e) {
            LogException.log(e);
            return e.getMessage();
        }
    }
    
}