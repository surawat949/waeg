public with sharing class TrainingCertificateController {
    public String deliveredTo {get; set;}
    public String accountNumber {get; set;}
    public String address1 {get; set;}
    public String address2 {get; set;}
    public String address3 {get; set;}
    public String trainingDate {get; set;}
    public String trainingType {get; set;}
    public String duration {get; set;}
    public String trainersName {get; set;}
    public String trainingIdvf {get; set;}
    public static String trainingTopics {get; set;}
    public static String trainingTopicsRow2 {get; set;}
    public static List<String> attendeesList {get; set;}
    public static List<String> attendeesList2 {get; set;}
    public static final String SEPARATOR = ' / ';
    public static final string ELLIPSIS = '...';

    public TrainingCertificateController() {
        deliveredTo = ApexPages.currentPage().getParameters().get('deliveredTo');
        accountNumber = ApexPages.currentPage().getParameters().get('accountNumber');
        address1 = ApexPages.currentPage().getParameters().get('address1');
        address2 = ApexPages.currentPage().getParameters().get('address2');
        address3 = ApexPages.currentPage().getParameters().get('address3');
        trainingDate = ApexPages.currentPage().getParameters().get('trainingDate');
        trainingType = ApexPages.currentPage().getParameters().get('trainingType');
        duration = ApexPages.currentPage().getParameters().get('duration');
        trainersName = ApexPages.currentPage().getParameters().get('trainersName');
        trainingIdvf = ApexPages.currentPage().getParameters().get('trainingIdvf');
        trainingTopics = ApexPages.currentPage().getParameters().get('trainingTopics');
        trainingTopicsRow2 = ApexPages.currentPage().getParameters().get('trainingTopicsRow2');
        attendeesList = new List<String>();
        attendeesList2 = new List<String>();
        if (!Test.isRunningTest()) {
         	attendeesList.addAll(ApexPages.currentPage().getParameters().get('attendeesList').split(';'));
        	attendeesList2.addAll(ApexPages.currentPage().getParameters().get('attendeesList2').split(';'));   
        }
    }

    @AuraEnabled 
    public static String generateCertificate(String trainingId, String attendeeId, String brand) {
        String returnMsg = 'Success';
        try {
            

            Boolean isIndividual = false;
            Id mergeFieldContact;
            List<String> emailAddresses = new List<String>();
            List<String> ccAddresses = new List<String>();
            Id trId = Id.valueOf(trainingId);
            ECP_Training__c trainingDetails = [SELECT Name, Account__c,Account__r.Name,Account__r.Seiko_local_customer_nr__c,Account__r.Shop_Street__c,Account__r.Shop_Postal_Code__c,
                                                Account__r.Shop_City__c,Account__r.Shop_State__c,Account__r.Shop_Country__c,start__c,Account__r.Owner.Email,Type__c,
                                                Training_duration__c,Assigned_to__r.Name, Assigned_to__r.Email, Training_ID__c,Training__c 
                                                FROM ECP_Training__c where Id =:trId];

            
            if(trainingDetails.Assigned_to__r.Email==null){
                //ccAddresses.add(trainingDetails.Account__r.Owner.Email);        //account owner
                String currentUserMail = UserInfo.getUserEmail();               
                ccAddresses.add(currentUserMail);
            }else{
                //ccAddresses.add(trainingDetails.Account__r.Owner.Email);        //account owner
                String currentUserMail = UserInfo.getUserEmail();               
                ccAddresses.add(currentUserMail);
                ccAddresses.add(trainingDetails.Assigned_to__r.Email);
            }  
            

            //ccAddresses.add('xavier.lacroix@seikovision.com'); // added temp for monitoring feature
            List<ECP_Training_Member__c> memberList = new List<ECP_Training_Member__c>();
            
            attendeesList = new List<String>();
            attendeesList2 = new List<String>();
            trainingTopics = '';
            trainingTopicsRow2 = '';
            
            if (attendeeId == null) {
                // certificate for All attendees
                System.debug('### All attendees');
                memberList = [select contact__c, name, training__c from ECP_Training_Member__c where training__c=:trId];
                if (memberList.isEmpty()) {
                    //No attendee found
                    returnMsg = 'AttendeeError';
                    return returnMsg;
                }
                // this wont be used anywhere in email template but needs to set 
                mergeFieldContact = memberList[0].contact__c;
                Set<Id> contactIdSet = new Set<Id>();
                for (ECP_Training_Member__c member : memberList) {
                    contactIdSet.add(member.contact__c);
                }
                List<Contact> contactList = [select Id, Name, Account.Owner.Email, firstname, lastname, recordType.Name, Email, salutation from contact where AccountId =:trainingDetails.Account__c and Id IN :contactIdSet];
                for (Contact eachCon : contactList) {
                    if (attendeesList.size() < 5) {
                        attendeesList.add(eachCon.Name);    
                    } else if (attendeesList2.size() < 5) {
                        attendeesList2.add(eachCon.Name);
                    } else {
                        //max 10 attendees and 2 columns only
                        break;
                    }
                    emailAddresses.add(eachCon.Account.Owner.Email);
                    
                }
            } else {
                //certificate for Individual attendee
                System.debug('### Individual Attendee');
                isIndividual = true;
                Id attId = Id.valueOf(attendeeId);
                memberList = [select Id, contact__c,contact__r.Name,contact__r.email, name, training__c, contact__r.Account.Owner.Email from ECP_Training_Member__c where Id=:attId];
                // this will be used in email template
                mergeFieldContact = memberList[0].contact__c;
                attendeesList.add(memberList[0].contact__r.Name);
                //emailAddresses.add(memberList[0].contact__r.email);
                emailAddresses.add(memberLIst[0].contact__r.Account.Owner.Email);
            }

            //if seiko brand
            if(brand == 'SEIKO'){
                PageReference pdfPage = Page.TrainingCertificatePage;
                //set parameters for vf page here - SEIKO
                pdfPage.getParameters().put('deliveredTo', trainingDetails.Account__r.Name);
                pdfPage.getParameters().put('accountNumber', trainingDetails.Account__r.Seiko_local_customer_nr__c);
                String tempAddr1 = trainingDetails.Account__r.Shop_Street__c + ',' + trainingDetails.Account__r.Shop_Postal_Code__c;
                pdfPage.getParameters().put('address1', tempAddr1);
                tempAddr1 = '';
                tempAddr1 = trainingDetails.Account__r.Shop_City__c + ',' + trainingDetails.Account__r.Shop_State__c;
                pdfPage.getParameters().put('address2', tempAddr1);
                tempAddr1 = '';
                tempAddr1 = trainingDetails.Account__r.Shop_Country__c;
                pdfPage.getParameters().put('address3', tempAddr1);
                pdfPage.getParameters().put('trainingDate',  String.valueOfGmt(trainingDetails.start__c));
                pdfPage.getParameters().put('trainingType', trainingDetails.Type__c);
                pdfPage.getParameters().put('duration',  String.valueOf(trainingDetails.Training_duration__c));
                pdfPage.getParameters().put('trainersName', trainingDetails.Assigned_to__r.Name);
                pdfPage.getParameters().put('trainingIdvf', trainingDetails.Name);
                for (String eachTopic : trainingDetails.Training__c.split(';')) {
                    if (trainingTopics.length() + eachTopic.length() + SEPARATOR.length() < 66) {
                        trainingTopics += eachTopic + SEPARATOR; 
                    } else if (trainingTopicsRow2.length() + eachTopic.length() + SEPARATOR.length() < 66) {
                        trainingTopicsRow2 += eachTopic + SEPARATOR;      
                    } else {
                        trainingTopicsRow2 += ELLIPSIS;
                        break;
                    }
                }
                pdfPage.getParameters().put('trainingTopics', trainingTopics);
                pdfPage.getParameters().put('trainingTopicsRow2', trainingTopicsRow2);
                pdfPage.getParameters().put('attendeesList', String.join(attendeesList, ';'));
                pdfPage.getParameters().put('attendeesList2', String.join(attendeesList2, ';'));
                

                returnMsg = sendEmail(pdfPage, emailAddresses, ccAddresses, trainingDetails.Name, mergeFieldContact, isIndividual, brand);
            }else{
                //if other brand - Hoya and other brand
                PageReference pdfPageHoya = Page.HoyaTrainingCertificate;
                pdfPageHoya.getParameters().put('deliveredTo', trainingDetails.Account__r.Name);
                pdfPageHOya.getParameters().put('accountNumber', trainingDetails.Account__r.Seiko_local_customer_nr__c);
                String tempAddr1 = trainingDetails.Account__r.Shop_Street__c + ',' + trainingDetails.Account__r.Shop_Postal_Code__c;
                pdfPageHoya.getParameters().put('address1', tempAddr1);
                tempAddr1 = '';
                tempAddr1 = trainingDetails.Account__r.Shop_City__c + ',' + trainingDetails.Account__r.Shop_State__c;
                pdfPageHoya.getParameters().put('address2', tempAddr1);
                tempAddr1 = '';
                tempAddr1 = trainingDetails.Account__r.Shop_Country__c;
                pdfPageHoya.getParameters().put('address3', tempAddr1);
                pdfPageHOya.getParameters().put('trainingDate',  String.valueOfGmt(trainingDetails.start__c));
                pdfPageHoya.getParameters().put('trainingType', trainingDetails.Type__c);
                pdfPageHoya.getParameters().put('duration',  String.valueOf(trainingDetails.Training_duration__c));
                pdfPageHoya.getParameters().put('trainersName', trainingDetails.Assigned_to__r.Name);
                pdfPageHoya.getParameters().put('trainingIdvf', trainingDetails.Name);
                for (String eachTopic : trainingDetails.Training__c.split(';')) {
                    if (trainingTopics.length() + eachTopic.length() + SEPARATOR.length() < 66) {
                        trainingTopics += eachTopic + SEPARATOR; 
                    } else if (trainingTopicsRow2.length() + eachTopic.length() + SEPARATOR.length() < 66) {
                        trainingTopicsRow2 += eachTopic + SEPARATOR;      
                    } else {
                        trainingTopicsRow2 += ELLIPSIS;
                        break;
                    }
                }
                pdfPageHoya.getParameters().put('trainingTopics', trainingTopics);
                pdfPageHoya.getParameters().put('trainingTopicsRow2', trainingTopicsRow2);
                pdfPageHoya.getParameters().put('attendeesList', String.join(attendeesList, ';'));
                pdfPageHoya.getParameters().put('attendeesList2', String.join(attendeesList2, ';'));
                
                returnMsg = sendEmail(pdfPageHoya, emailAddresses, ccAddresses, trainingDetails.Name, mergeFieldContact, isIndividual, brand);
            }
        } catch (Exception ex) {
            
            throw new AuraHandledException(ex.getMessage());
        }
        return returnMsg;
    }

    public static String sendEmail(PageReference pdfPage, List<String> emailAddresses, List<String> ccAddresses, String  trainingCode, Id conId, Boolean isIndividual, String brand) {
        String returnMsg = 'Success';
        try {

            if(brand == 'SEIKO'){
            //Seiko Vision
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName('Seiko Training Certificate ' + trainingCode + '.pdf');
                attach.setInline(false);
                if(!test.isRunningTest()){
                    attach.Body = pdfPage.getContent();
                }else{
                    attach.Body = blob.valueof('TEST');
                }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<OrgWideEmailAddress> orgWideEmail = [SELECT Id, Address, DisplayName, IsAllowAllProfiles, Purpose FROM OrgWideEmailAddress WHERE Address = 'do_not_reply@seikovision.com'];
                
                mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
                mail.setUseSignature(false);
                mail.setToAddresses(emailAddresses);
                mail.setCcAddresses(ccAddresses);
                List<EmailTemplate> emailTemplate;
                if (isIndividual) {
                    emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName,Body from EmailTemplate where DeveloperName ='Seiko_Training_Certificate_Individuals'];
                } else {
                    emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where DeveloperName ='Seiko_Training_Certificate_All_attendees'];
                }
                
                if (!emailTemplate.isEmpty()) {
                    mail.setTemplateID(emailTemplate[0].Id);    
                } else {
                    returnMsg = 'templateError';
                    return returnMsg;
                }
                mail.setTargetObjectId(conId); // required for template.
                mail.setTreatTargetObjectAsRecipient(false); // dont send mail to above Id
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }else{
                //for the other brand - Hoya and other brand
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName('Hoya Training Certificate ' + trainingCode + '.pdf');
                attach.setInline(false);
                if(!test.isRunningTest()){
                    attach.Body = pdfPage.getContent();
                }else{
                    attach.Body = blob.valueof('TEST');
                }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<OrgWideEmailAddress> orgWideEmail = [SELECT Id, Address, DisplayName, IsAllowAllProfiles, Purpose FROM OrgWideEmailAddress WHERE Address = 'salesforce@hoya.eu'];
                
                mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
                mail.setUseSignature(false);
                mail.setToAddresses(emailAddresses);
                mail.setCcAddresses(ccAddresses);
                List<EmailTemplate> emailTemplate;
                if (isIndividual) {
                    emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName,Body from EmailTemplate where DeveloperName ='Hoya_Training_Certificate_Individuals'];
                } else {
                    emailTemplate =[Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where DeveloperName ='Hoya_Training_Certificate_All_attendees'];
                }
                
                if (!emailTemplate.isEmpty()) {
                    mail.setTemplateID(emailTemplate[0].Id);    
                } else {
                    returnMsg = 'templateError';
                    return returnMsg;
                }
                mail.setTargetObjectId(conId); // required for template.
                mail.setTreatTargetObjectAsRecipient(false); // dont send mail to above Id
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }
           
        } catch (Exception ex) {
            
            throw new AuraHandledException(ex.getMessage());
        }
        return returnMsg;
    }

    @AuraEnabled(cacheable=true)
    public static List<ECP_Training__c> getECPTrainings(String accountId){
        List<ECP_Training__c> lstTrainings = new List<ECP_Training__c>();
        try {
            if (accountId != null) {
                Id accId = Id.valueOf(accountId);
                lstTrainings = [SELECT Id, Name, Hoya_Account_ID__c, Training__c, Type__c, 
                                start__c, Assigned_to__r.Name,Training_duration__c,Account__r.Name 
                                FROM ECP_Training__c WHERE (Account__c = :accId) AND (Training_status__c = 'Completed')
                                ORDER BY createdDate Desc];
            }
            
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
        return lstTrainings;
    }

    @AuraEnabled(cacheable=true)
    public static List<ECP_Training_Member__c> getAttendees(String trainingId){
        try {
            Id trId = Id.valueOf(trainingId);
            List<ECP_Training_Member__c> memberList = [select Id, contact__c,contact__r.RecordType.Name,contact__r.Name, name, training__c from ECP_Training_Member__c where training__c=:trId];
            return memberList;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static AttendeeNums getNumAttendee(String trainingId){
        AttendeeNums a = new AttendeeNums();
        AggregateResult[] nums = [SELECT COUNT(Id) attendee FROM ECP_Training_Member__c WHERE training__c =:trainingId];
        for(AggregateResult ar: nums){
            a.getAttendeeNum = (Double)ar.get('attendee');
        }
        return a;
    }

    @AuraEnabled(cacheable=true)
    public static string getAccountBrand(String receivedId){
        String ACC_BRAND = [SELECT Brand__c FROM Account WHERE Id=:receivedId LIMIT 1].Brand__c;
        return ACC_BRAND;
    }

    public class AttendeeNums{
        @AuraEnabled public double getAttendeeNum{get;set;}
    }
}